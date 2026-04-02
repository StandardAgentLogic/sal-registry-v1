"""
Sync O*NET Occupation Data.xlsx → Supabase registry_metadata (full occupation list).

Upserts: soc_code, title, description
(requires `description` column — run schema/add_registry_description.sql if needed)

Environment: SUPABASE_URL + SUPABASE_SERVICE_ROLE_KEY (or SUPABASE_ANON_KEY)

Usage:
  python scripts/onet_metadata_sync.py
  python scripts/onet_metadata_sync.py --dry-run
"""

from __future__ import annotations

import argparse
import os
import re
import sys
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
    mapping = {_norm_header(c): c for c in df.columns}
    for n in needles:
        key = _norm_header(n)
        if key in mapping:
            return mapping[key]
    for c in df.columns:
        hn = _norm_header(c)
        for n in needles:
            if _norm_header(n) in hn or hn in _norm_header(n):
                return str(c)
    raise KeyError(f"No column matching {needles} in {list(df.columns)[:15]}…")


def _read_occupation(path: Path) -> pd.DataFrame:
    xl = pd.ExcelFile(path, engine="openpyxl")
    sheet = "Occupation Data" if "Occupation Data" in xl.sheet_names else xl.sheet_names[0]
    return pd.read_excel(path, sheet_name=sheet, engine="openpyxl")


def soc_col(df: pd.DataFrame) -> str:
    return _find_column(df, "O*NET-SOC Code", "O NET-SOC Code", "ONET-SOC Code", "SOC Code")


_SOC_RE = re.compile(r"^\d{2}-\d{4}\.\d{2}$")


def _valid_soc(s: str) -> bool:
    return bool(_SOC_RE.match(s.strip()))


def rows_for_upsert(df: pd.DataFrame) -> list[dict[str, Any]]:
    c_soc = soc_col(df)
    c_title = _find_column(df, "Title")
    c_desc = _find_column(df, "Description")

    work = df.dropna(subset=[c_soc]).copy()
    work[c_soc] = work[c_soc].astype(str).str.strip()
    work = work[work[c_soc].map(_valid_soc)]
    work = work.drop_duplicates(subset=[c_soc], keep="first")

    out: list[dict[str, Any]] = []
    for _, r in work.iterrows():
        soc = str(r[c_soc]).strip()
        title = str(r[c_title]).strip() if pd.notna(r[c_title]) else ""
        desc = str(r[c_desc]).strip() if pd.notna(r[c_desc]) else ""
        if not title:
            continue
        out.append({"soc_code": soc, "title": title, "description": desc})
    return out


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


BATCH = 250


def upsert_batches(client: Any, rows: list[dict[str, Any]]) -> None:
    for i in range(0, len(rows), BATCH):
        chunk = rows[i : i + BATCH]
        client.table("registry_metadata").upsert(chunk, on_conflict="soc_code").execute()


def main() -> int:
    ap = argparse.ArgumentParser(description="O*NET Occupation Data → registry_metadata upsert.")
    ap.add_argument("--onet-dir", type=Path, default=Path("onet_gold_mine"))
    ap.add_argument(
        "--limit",
        type=int,
        default=None,
        help="If provided with --only-missing-from-agent-logic, only upsert this many missing SOC codes. Omit to upsert ALL missing.",
    )
    ap.add_argument(
        "--only-missing-from-agent-logic",
        action="store_true",
        help="Upsert metadata only for SOC codes that exist in agent_logic but not yet in registry_metadata.",
    )
    ap.add_argument("--dry-run", action="store_true", help="Parse Excel only; print counts and exit.")
    args = ap.parse_args()

    occ_path = args.onet_dir / "Occupation Data.xlsx"
    if not occ_path.is_file():
        print(f"Missing file: {occ_path.resolve()}", file=sys.stderr)
        return 1

    occ_df = _read_occupation(occ_path)

    wanted_soc_codes: set[str] | None = None
    if args.only_missing_from_agent_logic:
        sb = get_supabase()
        reg = sb.table("registry_metadata").select("soc_code").execute()
        agent = sb.table("agent_logic").select("soc_code").execute()
        reg_set = {str(r.get("soc_code") or "") for r in (reg.data or [])}
        agent_set = {str(r.get("soc_code") or "") for r in (agent.data or [])}
        missing = sorted([s for s in agent_set if s and s not in reg_set])
        if args.limit is None:
            wanted_soc_codes = set(missing)
        else:
            wanted_soc_codes = set(missing[: args.limit])
        print(
            f"Missing SOC codes in registry_metadata: {len(missing)}; "
            f"upserting {len(wanted_soc_codes)} ({'ALL' if args.limit is None else f'limit={args.limit}'})"
        )

    if wanted_soc_codes is None:
        rows = rows_for_upsert(occ_df)
        print(f"Prepared {len(rows)} registry rows (unique, valid SOC format).")
    else:
        # Filter Excel-derived rows down to wanted SOC codes.
        all_rows = rows_for_upsert(occ_df)
        rows = [r for r in all_rows if r["soc_code"] in wanted_soc_codes]
        print(f"Prepared {len(rows)} filtered registry rows for upsert.")

    if args.dry_run:
        if rows:
            print("Sample:", rows[0])
        return 0

    try:
        sb = get_supabase()
        upsert_batches(sb, rows)
    except Exception as exc:  # noqa: BLE001
        msg = str(exc).lower()
        print(f"Sync failed: {exc}", file=sys.stderr)
        if "description" in msg or "column" in msg:
            print(
                "If the error mentions unknown column `description`, run in Supabase SQL:\n"
                "  schema/add_registry_description.sql",
                file=sys.stderr,
            )
        return 1

    print(f"Upsert complete: {len(rows)} rows into registry_metadata.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
