"""
Ingest O*NET Excel exports → SAL agent_logic rows (primary_directive + step_by_step_json).

Expected files in ./onet_gold_mine/ (configurable):
  - Occupation Data.xlsx
  - Tasks.xlsx  (Task Statements-style rows)
  - Tools and Technology.xlsx  (sheet with Technology Skills + Hot Technology column)

Environment:
  SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY (or SUPABASE_ANON_KEY)
  OPENAI_API_KEY (optional unless --mock-sal or --prompt-only)

Usage:
  python scripts/onet_sal_ingest.py --limit 5 --mock-sal
  python scripts/onet_sal_ingest.py --limit 5 --prompt-only
  python scripts/onet_sal_ingest.py --limit 5
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import time
from pathlib import Path
from typing import Any

import pandas as pd
from dotenv import load_dotenv

_REPO_ROOT = Path(__file__).resolve().parent.parent
load_dotenv(_REPO_ROOT / ".env")


def _norm_header(s: Any) -> str:
    t = str(s).strip().lower()
    t = t.replace("*", "")
    t = re.sub(r"\s+", " ", t)
    return t


def _find_column(df: pd.DataFrame, *needles: str) -> str:
    """Map normalized needle to actual column name."""
    mapping = {_norm_header(c): c for c in df.columns}
    for n in needles:
        key = _norm_header(n)
        if key in mapping:
            return mapping[key]
    # substring match (e.g. 'onet-soc' inside header)
    for c in df.columns:
        hn = _norm_header(c)
        for n in needles:
            if _norm_header(n) in hn or hn in _norm_header(n):
                return str(c)
    raise KeyError(f"No column matching {needles} in {list(df.columns)[:12]}…")


def _read_occupation(path: Path) -> pd.DataFrame:
    xl = pd.ExcelFile(path, engine="openpyxl")
    sheet = "Occupation Data" if "Occupation Data" in xl.sheet_names else xl.sheet_names[0]
    return pd.read_excel(path, sheet_name=sheet, engine="openpyxl")


def _read_tasks(path: Path) -> pd.DataFrame:
    xl = pd.ExcelFile(path, engine="openpyxl")
    prefer = next(
        (s for s in xl.sheet_names if "task" in s.lower() and "statement" in s.lower()),
        None,
    )
    sheet = prefer or ("Task Statements" if "Task Statements" in xl.sheet_names else xl.sheet_names[0])
    return pd.read_excel(path, sheet_name=sheet, engine="openpyxl")


def _read_technology_skills(path: Path) -> pd.DataFrame:
    xl = pd.ExcelFile(path, engine="openpyxl")
    for name in xl.sheet_names:
        if "technology" in name.lower() and "skill" in name.lower():
            df = pd.read_excel(path, sheet_name=name, engine="openpyxl")
            if any("hot technology" in _norm_header(c) for c in df.columns):
                return df
    for name in xl.sheet_names:
        df = pd.read_excel(path, sheet_name=name, engine="openpyxl")
        if any("hot technology" in _norm_header(c) for c in df.columns):
            return df
    raise ValueError(
        f"No sheet with 'Hot Technology' in {path.name}; sheets={xl.sheet_names}"
    )


def soc_col(df: pd.DataFrame) -> str:
    return _find_column(df, "O*NET-SOC Code", "O NET-SOC Code", "ONET-SOC Code", "SOC Code")


def extract_occupation_title(occ_df: pd.DataFrame, soc: str) -> str:
    c_soc = soc_col(occ_df)
    c_title = _find_column(occ_df, "Title")
    row = occ_df.loc[occ_df[c_soc].astype(str).str.strip() == soc]
    if row.empty:
        return ""
    return str(row.iloc[0][c_title]).strip()


def extract_tasks(tasks_df: pd.DataFrame, soc: str) -> list[str]:
    c_soc = soc_col(tasks_df)
    c_task = _find_column(tasks_df, "Task")
    sub = tasks_df[tasks_df[c_soc].astype(str).str.strip() == soc].copy()
    if sub.empty:
        return []
    # O*NET often includes Task Type; prefer core order if present
    if "Task Type" in sub.columns:
        sub["_sort"] = sub["Task Type"].astype(str).str.lower().eq("core").map({True: 0, False: 1})
        sub = sub.sort_values("_sort", kind="stable")
    out: list[str] = []
    for _, r in sub.iterrows():
        t = str(r[c_task]).strip()
        if t and t not in out:
            out.append(t)
    return out


def extract_hot_technologies(tech_df: pd.DataFrame, soc: str) -> list[str]:
    c_soc = soc_col(tech_df)
    c_hot = _find_column(tech_df, "Hot Technology")
    sub = tech_df[
        (tech_df[c_soc].astype(str).str.strip() == soc)
        & (tech_df[c_hot].astype(str).str.strip().str.upper().isin({"Y", "YES", "TRUE", "1"}))
    ]
    names: list[str] = []
    example_col = None
    title_col = None
    try:
        example_col = _find_column(tech_df, "Example")
    except KeyError:
        pass
    try:
        title_col = _find_column(tech_df, "Commodity Title")
    except KeyError:
        pass
    for _, r in sub.iterrows():
        part = ""
        if example_col:
            part = str(r[example_col]).strip()
        if not part and title_col:
            part = str(r[title_col]).strip()
        if part and part not in names:
            names.append(part)
    return names


def build_llm_prompt(
    *,
    soc_code: str,
    title: str,
    tasks: list[str],
    hot_technologies: list[str],
) -> str:
    tasks_block = "\n".join(f"- {t}" for t in tasks) or "- (no task statements in extract)"
    tech_block = (
        "\n".join(f"- {x}" for x in hot_technologies)
        or "- (no hot technologies flagged for this SOC)"
    )
    return f"""You are authoring Standard Agent Logic (SAL) for an enterprise agent registry.

SOC code: {soc_code}
Occupation title: {title}

## O*NET task statements (source of truth for behavior)
{tasks_block}

## Hot technologies (toolbox emphasis; SAL toolbox_requirements will mirror these names)
{tech_block}

## Output requirements
1. **primary_directive**: One clear mission sentence an agent must follow (no markdown, no quotes wrapping the whole thing).
2. **step_by_step_json**: Exactly **5** objects in a JSON array. Each object MUST have:
   - "step": integer 1–5
   - "title": short verb phrase (<= 12 words)
   - "detail": one sentence describing what the agent does in that step, grounded in the tasks above.

Return **only** valid JSON with this exact top-level shape (no markdown fences):
{{"primary_directive": "...", "step_by_step_json": [{{"step": 1, "title": "...", "detail": "..."}}, ...]}}
"""


def _parse_llm_json(text: str) -> tuple[str, list[dict[str, Any]]]:
    text = text.strip()
    text = re.sub(r"^```(?:json)?\s*", "", text, flags=re.I | re.MULTILINE)
    text = re.sub(r"\s*```\s*$", "", text, flags=re.I | re.MULTILINE)
    text = text.strip()
    m = re.search(r"\{[\s\S]*\}\s*$", text)
    if m:
        text = m.group(0)
    data = json.loads(text)
    pdirect = str(data["primary_directive"]).strip()
    steps = data["step_by_step_json"]
    if not isinstance(steps, list) or len(steps) != 5:
        raise ValueError(f"Expected 5 steps, got {steps!r}")
    norm: list[dict[str, Any]] = []
    for i, s in enumerate(steps, start=1):
        if isinstance(s, dict):
            norm.append(
                {
                    "step": int(s.get("step", i)),
                    "title": str(s.get("title", "")).strip(),
                    "detail": str(s.get("detail", "")).strip(),
                }
            )
        else:
            norm.append({"step": i, "title": f"Step {i}", "detail": str(s)})
    return pdirect, norm


def generate_with_openai(prompt: str, model: str) -> tuple[str, list[dict[str, Any]]]:
    try:
        from openai import OpenAI
    except ImportError as e:
        raise RuntimeError("Install openai: pip install openai") from e
    def is_rate_limited(exc: Exception) -> bool:
        msg = str(exc).lower()
        return "429" in msg or "rate limit" in msg or "rate-limited" in msg

    client = OpenAI()
    attempts = 5
    delay_s = 2.0
    last_exc: Exception | None = None
    for attempt in range(1, attempts + 1):
        try:
            resp = client.chat.completions.create(
                model=model,
                messages=[
                    {
                        "role": "system",
                        "content": "You output only strict JSON for SAL agent logic. No markdown.",
                    },
                    {"role": "user", "content": prompt},
                ],
                temperature=0.2,
            )
            content = resp.choices[0].message.content or ""
            return _parse_llm_json(content)
        except Exception as exc:  # noqa: BLE001
            last_exc = exc
            if attempt >= attempts or not is_rate_limited(exc):
                raise
            print(f"OpenAI rate limit detected (attempt {attempt}/{attempts}). Sleeping {delay_s:.1f}s...")
            time.sleep(delay_s)
            delay_s = min(delay_s * 2.0, 30.0)

    raise last_exc  # type: ignore[misc]


def mock_sal_payload(title: str, tasks: list[str], hot_technologies: list[str]) -> tuple[str, list[dict[str, Any]]]:
    """Deterministic placeholder when OpenAI is not used."""
    pdirect = (
        f"Deliver {title} outcomes by executing the O*NET-modeled task set with emphasis on "
        f"listed hot technologies."
    )
    base = tasks[:5] if tasks else ["Review role requirements", "Plan work", "Execute", "Verify", "Document"]
    while len(base) < 5:
        base.append(f"Supporting activity {len(base) + 1}")
    steps: list[dict[str, Any]] = []
    for i in range(5):
        steps.append(
            {
                "step": i + 1,
                "title": f"Execute phase {i + 1}",
                "detail": base[i][:500],
            }
        )
    if hot_technologies:
        pdirect += f" Prioritize: {', '.join(hot_technologies[:5])}."
    return pdirect, steps


def get_supabase():
    from supabase import create_client

    url = (os.getenv("SUPABASE_URL") or "").strip()
    key = (
        os.getenv("SUPABASE_SERVICE_ROLE_KEY")
        or os.getenv("SUPABASE_ANON_KEY")
        or os.getenv("SUPABASE_KEY")
        or ""
    ).strip()
    if not url or not key:
        raise RuntimeError("SUPABASE_URL and a Supabase key must be set in the environment.")
    return create_client(url, key)


def upsert_agent_logic(
    client: Any,
    *,
    soc_code: str,
    primary_directive: str,
    step_by_step_json: list[dict[str, Any]],
    toolbox_requirements: list[str],
) -> None:
    payload = {
        "soc_code": soc_code,
        "primary_directive": primary_directive,
        "step_by_step_json": step_by_step_json,
        "toolbox_requirements": toolbox_requirements,
    }
    attempts = 5
    delay_s = 2.0
    last_exc: Exception | None = None
    for attempt in range(1, attempts + 1):
        try:
            client.table("agent_logic").upsert(payload, on_conflict="soc_code").execute()
            return
        except Exception as exc:  # noqa: BLE001
            last_exc = exc
            if attempt >= attempts:
                raise
            msg = str(exc).lower()
            is_timeout = "timeout" in msg or "timed out" in msg or "temporarily" in msg
            if is_timeout:
                print(f"Supabase upsert timeout (attempt {attempt}/{attempts}). Sleeping {delay_s:.1f}s...")
            else:
                print(f"Supabase upsert error (attempt {attempt}/{attempts}): {exc}. Retrying...")
            time.sleep(delay_s)
            delay_s = min(delay_s * 2.0, 30.0)

    raise last_exc  # type: ignore[misc]


def main() -> int:
    ap = argparse.ArgumentParser(description="O*NET → SAL agent_logic ingest (test batch).")
    ap.add_argument("--onet-dir", type=Path, default=Path("onet_gold_mine"))
    ap.add_argument(
        "--limit",
        type=int,
        default=None,
        help="How many missing SOC codes to process. Omit to process ALL remaining.",
    )
    ap.add_argument(
        "--prompt-only",
        action="store_true",
        help="Print prompts only; do not call OpenAI or Supabase.",
    )
    ap.add_argument(
        "--mock-sal",
        action="store_true",
        help="Skip OpenAI; use deterministic placeholder directives/steps.",
    )
    ap.add_argument("--model", default=os.getenv("OPENAI_MODEL", "gpt-4o-mini"))
    args = ap.parse_args()

    base = args.onet_dir
    # Be forgiving about filename casing / spacing variations.
    # We expect three Excel exports in --onet-dir (default: onet_gold_mine/).
    allowed_exts = {".xlsx", ".xlsm", ".xls", ".xlsb"}
    excel_files = [p for p in base.iterdir() if p.is_file() and p.suffix.lower() in allowed_exts]
    excel_files_lower = {p: p.name.lower() for p in excel_files}

    def pick(*needles: str) -> Path | None:
        """Pick first file whose name contains all needles (case-insensitive)."""
        needles_l = [n.lower() for n in needles if n]
        for p in excel_files:
            name_l = excel_files_lower[p]
            if all(n in name_l for n in needles_l):
                return p
        return None

    occ_p = pick("occupation", "data") or pick("occupation")
    # Prefer the workbook with explicit task statements.
    task_p = pick("task", "statement") or pick("tasks", "statement") or pick("task") or pick("tasks")
    tech_p = (
        pick("tools", "technology")
        or pick("tools", "tech")
        or pick("technology", "skills")
        or pick("technology")
        or pick("tools")
    )

    if not occ_p or not task_p or not tech_p:
        shown = ", ".join(p.name for p in sorted(excel_files, key=lambda x: x.name.lower())) or "(none found)"
        print(
            "Missing required O*NET workbooks in onet-dir.\n"
            f"Expected keywords: occupation/data, tasks, tools/technology.\n"
            f"Found Excel files: {shown}\n"
            "Action: place the three O*NET Excel exports into the onet directory and re-run.",
            file=sys.stderr,
        )
        return 1

    occ_df = _read_occupation(occ_p)
    tasks_df = _read_tasks(task_p)
    tech_df = _read_technology_skills(tech_p)

    c_soc_occ = soc_col(occ_df)
    occ_df = occ_df.dropna(subset=[c_soc_occ])
    occ_df[c_soc_occ] = occ_df[c_soc_occ].astype(str).str.strip()
    unique_socs_all = occ_df[c_soc_occ].drop_duplicates().sort_values().tolist()

    sb = get_supabase() if not args.prompt_only else None
    if sb is not None:
        # Ensure we only upsert SOC codes that don't already exist in agent_logic.
        existing = (
            sb.table("agent_logic")
            .select("soc_code")
            .limit(10000)
            .execute()
        )
        existing_set = {str(r.get("soc_code") or "") for r in (existing.data or [])}
        missing_socs = [s for s in unique_socs_all if str(s) not in existing_set]
        if args.limit is None:
            unique_socs = missing_socs
        else:
            unique_socs = missing_socs[: args.limit]
        limit_label = "ALL" if args.limit is None else f"limit={args.limit}"
        print(f"Missing SOC codes: {len(missing_socs)}; processing {len(unique_socs)} ({limit_label})")
    else:
        unique_socs = unique_socs_all if args.limit is None else unique_socs_all[: args.limit]
        print(f"Processing {len(unique_socs)} SOC code(s): {unique_socs}")

    for soc in unique_socs:
        title = extract_occupation_title(occ_df, soc) or "(unknown title)"
        tasks = extract_tasks(tasks_df, soc)
        hot = extract_hot_technologies(tech_df, soc)
        prompt = build_llm_prompt(
            soc_code=soc,
            title=title,
            tasks=tasks,
            hot_technologies=hot,
        )
        print("\n" + "=" * 72)
        print(f"SOC {soc} | {title}")
        print(f"Tasks: {len(tasks)} | Hot technologies: {len(hot)}")

        if args.prompt_only:
            print(prompt)
            continue

        if args.mock_sal:
            pdirect, steps = mock_sal_payload(title, tasks, hot)
        else:
            pdirect, steps = generate_with_openai(prompt, args.model)

        assert sb is not None
        try:
            upsert_agent_logic(
                sb,
                soc_code=soc,
                primary_directive=pdirect,
                step_by_step_json=steps,
                toolbox_requirements=hot,
            )
            print("Upsert Successful: agent_logic")
        except Exception as exc:  # noqa: BLE001
            print(f"Upsert failed: {exc}", file=sys.stderr)
            if "foreign key" in str(exc).lower():
                print(
                    "Hint: ensure registry_metadata has this soc_code before agent_logic.",
                    file=sys.stderr,
                )
            return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
