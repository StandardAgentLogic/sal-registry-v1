from __future__ import annotations

import json
import os
from html import escape
from typing import Any
from datetime import datetime

import streamlit as st
from dotenv import load_dotenv
from supabase import Client, create_client


load_dotenv()


def _secret_get(name: str) -> str:
    """Read Streamlit secrets without crashing if secrets.toml is missing or partial."""
    try:
        v = st.secrets.get(name)
        return str(v or "").strip()
    except Exception:  # noqa: BLE001
        return (os.getenv(name) or "").strip()


def _looks_like_placeholder(value: str) -> bool:
    """True if URL/key is empty or an obvious scaffold placeholder (demo/browse mode)."""
    t = (value or "").strip()
    if not t:
        return True
    low = t.lower()
    if "insert_" in low:
        return True
    if "your-supabase" in low or "your_openai" in low:
        return True
    if low in {"changeme", "placeholder", "xxx", "none", "null"}:
        return True
    return False


def _resolve_supabase_url() -> str:
    """Streamlit Cloud: st.secrets first; local: .env / process env."""
    return (_secret_get("SUPABASE_URL") or os.getenv("SUPABASE_URL") or "").strip()


def _resolve_supabase_key() -> str:
    """Prefer service role, then anon, then generic SUPABASE_KEY."""
    return (
        _secret_get("SUPABASE_SERVICE_ROLE_KEY")
        or _secret_get("SUPABASE_ANON_KEY")
        or _secret_get("SUPABASE_KEY")
        or os.getenv("SUPABASE_SERVICE_ROLE_KEY")
        or os.getenv("SUPABASE_ANON_KEY")
        or os.getenv("SUPABASE_KEY")
        or ""
    ).strip()


def use_demo_mode() -> bool:
    """Browse UI with mock registry/logic when credentials are missing or still placeholders."""
    return _looks_like_placeholder(_resolve_supabase_url()) or _looks_like_placeholder(
        _resolve_supabase_key()
    )


def get_supabase_client() -> Client:
    url = _resolve_supabase_url()
    key = _resolve_supabase_key()
    if not url or not key:
        raise RuntimeError("SUPABASE_URL and/or key not configured.")
    return create_client(url, key)


def fetch_counts(client: Client) -> dict[str, int]:
    registry_rows = client.table("registry_metadata").select("*", count="exact").limit(0).execute()
    logic_rows = client.table("agent_logic").select("*", count="exact").limit(0).execute()
    guardrail_rows = client.table("guardrails_and_compliance").select("*", count="exact").limit(0).execute()
    return {
        "registry_metadata": int(registry_rows.count or 0),
        "agent_logic": int(logic_rows.count or 0),
        "guardrails_and_compliance": int(guardrail_rows.count or 0),
    }


def fetch_registry_roles(
    client: Client,
    title_query: str,
    *,
    private_vault_only: bool,
    limit: int = 50,
) -> list[dict[str, Any]]:
    """Search registry; optionally restrict to Private Vault (is_custom = true)."""
    q = client.table("registry_metadata").select(
        "soc_code,title,market_value,outlook,is_custom,description"
    )
    if private_vault_only:
        q = q.eq("is_custom", True)
    t = title_query.strip()
    if t:
        # Title-first, then broaden to description/outlook.
        q = q.or_(f"title.ilike.%{t}%,description.ilike.%{t}%,outlook.ilike.%{t}%")
    result = q.order("title").limit(limit).execute()
    return result.data or []


def fetch_agent_logic_detail(client: Client, soc_code: str) -> dict[str, Any] | None:
    """Load hardened agent_logic columns for the Inspector."""
    result = (
        client.table("agent_logic")
        .select("soc_code,primary_directive,step_by_step_json,toolbox_requirements")
        .eq("soc_code", soc_code)
        .limit(1)
        .execute()
    )
    if result.data:
        return result.data[0]
    return None


def _normalize_steps(raw: Any) -> list[Any]:
    if raw is None:
        return []
    if isinstance(raw, str):
        s = raw.strip()
        if not s:
            return []
        try:
            parsed = json.loads(s)
        except json.JSONDecodeError:
            return [s]
        return _normalize_steps(parsed)
    if isinstance(raw, list):
        return raw
    if isinstance(raw, dict):
        return list(raw.items()) if raw else [raw]
    return [raw]


def _inject_studio_styles() -> None:
    """Institutional bright-mode styling with SAL notary stamp."""
    st.markdown(
        """
<style>
  div[data-testid="stVerticalBlock"] > div:has(> iframe) { max-width: 100%; }
  .sal-gold-frame {
    border: 2px solid #c9a227 !important;
    border-radius: 12px !important;
    padding: 0.85rem 1rem !important;
    margin-bottom: 0.65rem !important;
    background: linear-gradient(145deg, #fffef8 0%, #ffffff 55%, #fffdf5 100%) !important;
    box-shadow: 0 2px 14px rgba(201, 162, 39, 0.14) !important;
  }
  .sal-card {
    border: 1px solid #e6e6eb;
    border-radius: 10px;
    padding: 0.75rem 1rem;
    margin-bottom: 0.55rem;
    background: #fafafc;
  }
  .sal-metric-wrap .stMetric { padding-top: 0.25rem; }
  /* High-density sidebar directory: ~15–20 titles visible on typical laptop viewports */
  [data-testid="stSidebar"] .stButton > button {
    font-size: 0.7rem !important;
    line-height: 1.12 !important;
    padding: 0.14rem 0.4rem !important;
    min-height: 1.45rem !important;
    white-space: normal !important;
    text-align: left !important;
  }
  [data-testid="stSidebar"] div[data-testid="column"] {
    gap: 0.15rem !important;
  }
  [data-testid="stSidebar"] .stButton {
    margin-bottom: 0.08rem !important;
  }

  /* Institutional doc view */
  .sal-doc {
    border: 1px solid #d7dbe8;
    border-radius: 14px;
    background: #ffffff;
    padding: 1.05rem 1.1rem;
    position: relative;
    box-shadow: 0 12px 30px rgba(16, 24, 40, 0.08);
  }
  .sal-doc h3, .sal-doc h4, .sal-doc h5 {
    color: #0b2a6f;
  }
  .sal-stamp {
    position: absolute;
    top: 14px;
    right: 14px;
    border: 1.5px solid #1d4ed8;
    color: #1d4ed8;
    border-radius: 999px;
    padding: 0.2rem 0.6rem;
    font-weight: 700;
    font-size: 0.72rem;
    letter-spacing: 0.08em;
    background: rgba(29,78,216,0.05);
    transform: rotate(2deg);
  }
  .sal-outlook {
    display: inline-block;
    border: 1px solid #b9c6ff;
    background: #eef2ff;
    color: #0b2a6f;
    padding: 0.18rem 0.5rem;
    border-radius: 999px;
    font-size: 0.78rem;
    margin-top: 0.25rem;
  }
  .sal-doc .sal-steps {
    margin: 0.5rem 0 0 1.1rem;
    padding: 0;
    color: #0b1220;
  }
  .sal-doc .sal-steps li { margin: 0.35rem 0; line-height: 1.35; }
</style>
""",
        unsafe_allow_html=True,
    )

SOC_MAJOR_GROUPS: dict[str, str] = {
    "11": "Management",
    "13": "Finance",
    "15": "Tech",
    "17": "Engineering",
    "19": "Science",
    "23": "Legal",
    "25": "Education",
    "27": "Arts & Media",
    "29": "Healthcare",
    "31": "Healthcare Support",
    "33": "Protective Service",
    "35": "Food Service",
    "37": "Building & Grounds",
    "39": "Personal Care",
    "41": "Sales",
    "43": "Office & Admin",
    "45": "Farming/Fishing",
    "47": "Construction",
    "49": "Maintenance",
    "51": "Production",
    "53": "Transportation",
    "55": "Military",
}


# --- Demo / browse mode (placeholders or offline Supabase): sample stacked workforce ---

_MOCK_REGISTRY: list[dict[str, Any]] = [
    {
        "soc_code": "11-1011.00",
        "title": "Chief Executives",
        "market_value": "Executive",
        "outlook": "Bright — strategic leadership demand (O*NET-style demo)",
        "is_custom": False,
        "description": "Determine and formulate policies and provide overall direction of companies.",
    },
    {
        "soc_code": "11-3021.00",
        "title": "Computer and Information Systems Managers",
        "market_value": "High",
        "outlook": "Bright — digital operations leadership",
        "is_custom": False,
        "description": "Plan, direct, or coordinate activities in electronic data processing.",
    },
    {
        "soc_code": "13-2011.00",
        "title": "Accountants and Auditors",
        "market_value": "Stable",
        "outlook": "Stable — assurance and controls",
        "is_custom": False,
        "description": "Examine, analyze, and interpret accounting records.",
    },
    {
        "soc_code": "13-2054.00",
        "title": "Financial Risk Specialists",
        "market_value": "High",
        "outlook": "Faster than average — risk analytics",
        "is_custom": False,
        "description": "Analyze and manage operational or market risk.",
    },
    {
        "soc_code": "15-1212.00",
        "title": "Information Security Analysts",
        "market_value": "High",
        "outlook": "Much faster than average — cyber workforce",
        "is_custom": False,
        "description": "Plan, implement, upgrade, or monitor security measures.",
    },
    {
        "soc_code": "15-1252.00",
        "title": "Software Developers",
        "market_value": "High",
        "outlook": "Bright — application engineering",
        "is_custom": False,
        "description": "Research, design, and develop computer and network software.",
    },
    {
        "soc_code": "15-1299.08",
        "title": "SAL Systems Integrator (Vault IP) 🏆",
        "market_value": "Proprietary",
        "outlook": "Institutional — vault-tier placement logic",
        "is_custom": True,
        "description": "Proprietary SAL staffing blueprint for agent orchestration and client-ready exports.",
    },
    {
        "soc_code": "17-2051.00",
        "title": "Civil Engineers",
        "market_value": "Stable",
        "outlook": "Stable — infrastructure cycles",
        "is_custom": False,
        "description": "Perform engineering duties in planning, designing, and overseeing construction.",
    },
    {
        "soc_code": "17-2112.00",
        "title": "Industrial Engineers",
        "market_value": "Stable",
        "outlook": "Average — process optimization",
        "is_custom": False,
        "description": "Design, develop, test, and evaluate integrated systems for manufacturing.",
    },
    {
        "soc_code": "23-1011.00",
        "title": "Lawyers",
        "market_value": "High",
        "outlook": "Stable — legal services",
        "is_custom": False,
        "description": "Represent clients in criminal and civil litigation and other legal proceedings.",
    },
    {
        "soc_code": "23-1022.00",
        "title": "Arbitrators, Mediators, and Conciliators",
        "market_value": "Niche",
        "outlook": "Average — alternative dispute resolution",
        "is_custom": False,
        "description": "Facilitate negotiation and dialogue between disputing parties.",
    },
    {
        "soc_code": "29-1141.00",
        "title": "Registered Nurses",
        "market_value": "High",
        "outlook": "Much faster than average — clinical staffing",
        "is_custom": False,
        "description": "Assess patient health problems and needs, develop and implement nursing care plans.",
    },
    {
        "soc_code": "29-1122.00",
        "title": "Occupational Therapists",
        "market_value": "High",
        "outlook": "Faster than average — rehabilitation",
        "is_custom": False,
        "description": "Assess, plan, and organize rehabilitative programs that build daily living skills.",
    },
]

_MOCK_STEP_TEMPLATE: list[dict[str, str]] = [
    {"step": "Intake & scope", "detail": "Confirm stakeholders, constraints, and success measures."},
    {"step": "Baseline & discovery", "detail": "Gather artifacts, systems map, and dependency list."},
    {"step": "Design & plan", "detail": "Produce blueprint, milestones, and approval gates."},
    {"step": "Execute & instrument", "detail": "Run delivery with telemetry, tests, and controls."},
    {"step": "Close & handoff", "detail": "Document outcomes, runbooks, and compliance evidence."},
]


def _mock_logic_for(soc: str) -> dict[str, Any]:
    title = next((str(r.get("title") or "Role") for r in _MOCK_REGISTRY if r.get("soc_code") == soc), "Role")
    return {
        "soc_code": soc,
        "primary_directive": (
            f"Deliver {title} outcomes using SAL execution: clarify intent, execute controls, and evidence results."
        ),
        "step_by_step_json": list(_MOCK_STEP_TEMPLATE),
        "toolbox_requirements": {"sal": ["Registry lookup", "Inspector export"], "collab": ["Issue tracker", "Runbook repo"]},
    }


_MOCK_LOGIC: dict[str, dict[str, Any]] = {
    "11-1011.00": {
        "soc_code": "11-1011.00",
        "primary_directive": "Establish enterprise direction, allocate capital, and align operating units to regulatory and stakeholder outcomes.",
        "step_by_step_json": [
            {"step": "Frame mandate", "detail": "Clarify board mandate, risk appetite, and 12–24 month priorities."},
            {"step": "Set operating model", "detail": "Define decision rights, KPI tree, and escalation paths."},
            {"step": "Allocate resources", "detail": "Align budget, talent, and technology to top initiatives."},
            {"step": "Govern execution", "detail": "Run executive operating rhythm with audit-ready artifacts."},
            {"step": "Assure compliance", "detail": "Verify statutory, contractual, and ISO control posture."},
        ],
        "toolbox_requirements": {"erp": ["SAP or Oracle GL"], "governance": ["Board portal", "Risk register"]},
    },
    "15-1299.08": {
        "soc_code": "15-1299.08",
        "primary_directive": "Vault-grade systems engineering: integrate agentic workflows with audit-ready SAL steps and proprietary controls.",
        "step_by_step_json": [
            {"step": "Classify workload", "detail": "Separate vault IP from market-standard modules; tag is_custom paths."},
            {"step": "Model interfaces", "detail": "Define API, event, and data contracts with versioning."},
            {"step": "Harden execution", "detail": "Apply least-privilege, secrets, and change windows."},
            {"step": "Validate logic", "detail": "Cross-check primary directive against registry metadata."},
            {"step": "Publish evidence", "detail": "Export inspector-ready artifacts for client review."},
        ],
        "toolbox_requirements": {"vault": ["Private registry", "SAL Inspector"], "integration": ["Service mesh or API gateway"]},
    },
}


def _demo_fetch_counts() -> dict[str, int]:
    n_reg = len(_MOCK_REGISTRY)
    return {
        "registry_metadata": n_reg,
        "agent_logic": n_reg,
        "guardrails_and_compliance": 12,
    }


def _demo_fetch_registry_roles(
    title_query: str,
    *,
    private_vault_only: bool,
    limit: int = 50,
) -> list[dict[str, Any]]:
    q = title_query.strip().lower()
    rows = [dict(r) for r in _MOCK_REGISTRY]
    if private_vault_only:
        rows = [r for r in rows if r.get("is_custom") is True]
    if q:
        rows = [
            r
            for r in rows
            if q in str(r.get("title") or "").lower()
            or q in str(r.get("description") or "").lower()
            or q in str(r.get("outlook") or "").lower()
        ]
    rows.sort(key=lambda r: str(r.get("title") or ""))
    return rows[:limit]


def _demo_fetch_registry_by_prefix(
    *,
    prefix2: str,
    query: str,
    private_vault_only: bool,
    limit: int,
) -> list[dict[str, Any]]:
    rows = [r for r in _MOCK_REGISTRY if str(r.get("soc_code") or "").startswith(f"{prefix2}-")]
    if private_vault_only:
        rows = [r for r in rows if r.get("is_custom") is True]
    t = query.strip().lower()
    if t:
        rows = [
            r
            for r in rows
            if t in str(r.get("title") or "").lower() or t in str(r.get("outlook") or "").lower()
        ]
    rows.sort(key=lambda r: str(r.get("title") or ""))
    return [dict(r) for r in rows[:limit]]


def _demo_fetch_agent_logic_detail(soc_code: str) -> dict[str, Any] | None:
    if soc_code in _MOCK_LOGIC:
        return dict(_MOCK_LOGIC[soc_code])
    if any(r.get("soc_code") == soc_code for r in _MOCK_REGISTRY):
        return _mock_logic_for(soc_code)
    return None


@st.cache_data(show_spinner=False, ttl=300)
def fetch_registry_by_prefix(
    supabase_url: str,
    supabase_key: str,
    *,
    prefix2: str,
    query: str,
    private_vault_only: bool,
    limit: int,
) -> list[dict[str, Any]]:
    client = create_client(supabase_url, supabase_key)
    q = client.table("registry_metadata").select("soc_code,title,is_custom,outlook").ilike("soc_code", f"{prefix2}-%")
    if private_vault_only:
        q = q.eq("is_custom", True)
    t = query.strip()
    if t:
        q = q.or_(f"title.ilike.%{t}%,outlook.ilike.%{t}%")
    res = q.order("title").limit(limit).execute()
    return res.data or []


def _openai_client_available() -> bool:
    key = (_secret_get("OPENAI_API_KEY") or os.getenv("OPENAI_API_KEY") or "").strip()
    return bool(key) and not _looks_like_placeholder(key)


def _get_openai_api_key() -> str:
    return (_secret_get("OPENAI_API_KEY") or os.getenv("OPENAI_API_KEY") or "").strip()


def staffing_agent_reply(
    *,
    client: Client | None,
    user_request: str,
    vault_only: bool,
    demo_mode: bool = False,
    top_k: int = 8,
) -> dict[str, Any]:
    """
    Returns: {"message": str, "selected_soc": str|None, "candidates": list[dict]}
    """
    # Candidate search: pull likely matches from metadata.
    if demo_mode:
        candidates = _demo_fetch_registry_roles(user_request, private_vault_only=vault_only, limit=top_k)
    else:
        if client is None:
            return {
                "message": "Registry offline. Switch to live Supabase keys to enable matching.",
                "selected_soc": None,
                "candidates": [],
            }
        candidates = fetch_registry_roles(client, user_request, private_vault_only=vault_only, limit=top_k)
    if not candidates:
        return {
            "message": "I couldn’t find a close SOC match in the registry for that request. Try a few keywords (domain + task) and I’ll map it to a role blueprint.",
            "selected_soc": None,
            "candidates": [],
        }

    # Prefer OpenAI when available; otherwise heuristic (first candidate).
    selected = candidates[0]
    selected_soc = str(selected.get("soc_code") or "")

    if _openai_client_available():
        try:
            from openai import OpenAI

            api_key = _get_openai_api_key()
            oa = OpenAI(api_key=api_key) if api_key else OpenAI()
            sys_prompt = (
                "You are a Senior Recruiter at a top-tier Chicago staffing firm. "
                "You match client requests to the best-fit SOC-coded SAL logic record. "
                "Be decisive, concise, and institutional. Output JSON only."
            )
            cand_lines = []
            for c in candidates:
                cand_lines.append(
                    {
                        "soc_code": c.get("soc_code"),
                        "title": c.get("title"),
                        "outlook": c.get("outlook"),
                        "description": c.get("description"),
                        "is_custom": c.get("is_custom"),
                    }
                )
            user_msg = {
                "request": user_request,
                "candidates": cand_lines,
                "output_schema": {
                    "selected_soc": "string SOC code from candidates",
                    "rationale": "2-4 sentences",
                    "shortlist": ["up to 3 SOC codes from candidates in order"],
                },
            }
            resp = oa.chat.completions.create(
                model=os.getenv("OPENAI_MODEL", "gpt-4o-mini"),
                messages=[
                    {"role": "system", "content": sys_prompt},
                    {"role": "user", "content": json.dumps(user_msg)},
                ],
                temperature=0.2,
            )
            content = resp.choices[0].message.content or "{}"
            data = json.loads(content)
            selected_soc = str(data.get("selected_soc") or selected_soc)
            rationale = str(data.get("rationale") or "").strip()
            shortlist = data.get("shortlist") or []
            msg = (
                f"**Recommendation:** `{escape(selected_soc)}` — {escape(rationale)}\n\n"
                f"**Shortlist:** {', '.join(f'`{escape(str(x))}`' for x in shortlist[:3])}"
            ).strip()
            return {"message": msg, "selected_soc": selected_soc, "candidates": candidates}
        except Exception:  # noqa: BLE001
            # Fall back silently to heuristic.
            pass

    return {
        "message": f"**Recommendation:** `{escape(selected_soc)}` — {escape(str(selected.get('title') or 'Best-fit SOC role'))}",
        "selected_soc": selected_soc,
        "candidates": candidates,
    }


def _render_file_tree_sidebar(
    *,
    supabase_url: str,
    supabase_key: str,
    query: str,
    vault_only: bool,
    demo_mode: bool,
) -> None:
    st.markdown("##### Bureau directory")
    st.caption("SOC industry folders · click to open a logic specification")

    # Track selected folder/prefix for quick navigation.
    if "active_prefix" not in st.session_state:
        st.session_state["active_prefix"] = "15"

    # Show folder list.
    for prefix2, label in SOC_MAJOR_GROUPS.items():
        folder_title = f"[{prefix2}] {label}"
        expanded = st.session_state.get("active_prefix") == prefix2
        with st.expander(folder_title, expanded=expanded):
            if st.button("Open folder", key=f"open_{prefix2}", use_container_width=True):
                st.session_state["active_prefix"] = prefix2

            rows = (
                _demo_fetch_registry_by_prefix(
                    prefix2=prefix2,
                    query=query,
                    private_vault_only=vault_only,
                    limit=60,
                )
                if demo_mode
                else fetch_registry_by_prefix(
                    supabase_url,
                    supabase_key,
                    prefix2=prefix2,
                    query=query,
                    private_vault_only=vault_only,
                    limit=60,
                )
            )
            if not rows:
                st.caption("No matches in this folder.")
            else:
                if prefix2 == st.session_state.get("active_prefix"):
                    _sync_active_role(rows)
                _render_sidebar_registry_directory(rows)


def _render_industry_cards() -> None:
    st.markdown("#### Placement doors")
    majors = [("11", "Management"), ("13", "Finance"), ("15", "Tech"), ("17", "Engineering"), ("29", "Healthcare"), ("23", "Legal")]
    half = len(majors) // 2
    for group in (majors[:half], majors[half:]):
        cols = st.columns(len(group))
        for col, (p, name) in zip(cols, group, strict=False):
            with col:
                if st.button(f"[{p}] {name}", use_container_width=True, key=f"door_{p}"):
                    st.session_state["active_prefix"] = p


def _sync_active_role(rows: list[dict[str, Any]]) -> None:
    """Keep session ``active_soc`` valid when search/vault results change."""
    codes = [str(r.get("soc_code") or "") for r in rows if str(r.get("soc_code") or "")]
    if "active_soc" not in st.session_state:
        st.session_state["active_soc"] = ""
    if not codes:
        st.session_state["active_soc"] = ""
        return
    current = str(st.session_state["active_soc"] or "")
    if current not in codes:
        st.session_state["active_soc"] = codes[0]


def _render_sidebar_registry_directory(rows: list[dict[str, Any]]) -> None:
    """Vertical directory of ``st.button`` rows; proprietary titles prefixed with 🏆."""
    for r in rows:
        soc = str(r.get("soc_code") or "")
        title = str(r.get("title") or "(untitled)")
        if not soc:
            continue
        custom = r.get("is_custom") is True
        prefix = "🏆 " if custom else ""
        label = f"{prefix}{title}"
        is_active = str(st.session_state["active_soc"] or "") == soc
        if st.button(
            label,
            key=f"sal_dir_{soc}",
            use_container_width=True,
            type="primary" if is_active else "secondary",
        ):
            st.session_state["active_soc"] = soc


def _steps_to_html(steps: list[Any]) -> str:
    """Build a safe HTML ordered list for the logic spec card."""
    if not steps:
        return "<p><em>No steps recorded.</em></p>"
    parts: list[str] = []
    for i, item in enumerate(steps, start=1):
        if isinstance(item, dict):
            label = item.get("step") or item.get("title") or item.get("name") or f"Step {i}"
            body = item.get("detail") or item.get("description") or item.get("text")
            inner = f"<strong>{escape(str(label))}</strong>"
            if body is not None:
                inner += (
                    f"<br><span style='margin-left:0.35rem;display:inline-block'>{escape(str(body))}</span>"
                )
            parts.append(f"<li>{inner}</li>")
        elif isinstance(item, (list, tuple)) and len(item) == 2:
            parts.append(
                f"<li><strong>{escape(str(item[0]))}</strong><br>"
                f"<span style='margin-left:0.35rem;display:inline-block'>{escape(str(item[1]))}</span></li>"
            )
        else:
            parts.append(f"<li>{escape(str(item))}</li>")
    return f"<ol class='sal-steps'>{''.join(parts)}</ol>"


def _render_logic_spec_html_card(
    *,
    selected_soc: str,
    chosen_row: dict[str, Any] | None,
    logic: dict[str, Any] | None,
    browse_mode: bool,
) -> None:
    """Single HTML card so the SAL VERIFIED seal sits inside the bordered spec (Streamlit-safe)."""
    display_title = str((chosen_row or {}).get("title") or "Select a role from the Bureau directory")
    is_custom = chosen_row is not None and chosen_row.get("is_custom") is True
    doc_class = "sal-doc sal-gold-frame" if is_custom else "sal-doc"

    outlook = str((chosen_row or {}).get("outlook") or "").strip()
    outlook_html = f"<div class='sal-outlook'>{escape(outlook)}</div>" if outlook else ""
    desc = str((chosen_row or {}).get("description") or "").strip()
    desc_html = (
        f"<p style='color:#475569;font-size:0.88rem;line-height:1.45'>{escape(desc)}</p>" if desc else ""
    )

    meta_bits: list[str] = []
    if chosen_row and chosen_row.get("market_value") is not None:
        meta_bits.append(f"<strong>Market value:</strong> {escape(str(chosen_row['market_value']))}")
    meta_html = ("<p style='margin:0.4rem 0 0.2rem'>" + " · ".join(meta_bits) + "</p>") if meta_bits else ""

    pd = (logic or {}).get("primary_directive") if logic else None
    if pd:
        pd_html = f"<h5>Primary directive</h5><p style='line-height:1.5'>{escape(str(pd))}</p>"
    else:
        pd_html = "<h5>Primary directive</h5><p><em>No directive loaded yet for this SOC code.</em></p>"

    steps = _normalize_steps((logic or {}).get("step_by_step_json")) if logic else []
    steps_html = f"<h5>Step-by-step execution (SAL)</h5>{_steps_to_html(steps)}"

    tb = (logic or {}).get("toolbox_requirements") if logic else None
    tb_html = ""
    if tb is not None and tb != "":
        if isinstance(tb, (dict, list)):
            tb_body = escape(json.dumps(tb, indent=2, ensure_ascii=False))
            tb_html = (
                "<h5>Toolbox requirements</h5>"
                "<pre style='white-space:pre-wrap;background:#f8fafc;border:1px solid #e2e8f0;"
                "padding:0.65rem;border-radius:8px;font-size:0.82rem'>"
                f"{tb_body}</pre>"
            )
        else:
            tb_html = (
                f"<h5>Toolbox requirements</h5><pre style='white-space:pre-wrap'>{escape(str(tb))}</pre>"
            )

    browse_note = (
        "<p style='font-size:0.78rem;color:#64748b;margin:0.6rem 0 0'><em>"
        "Browse mode — sample data for layout review. Use live Supabase keys for production.</em></p>"
        if browse_mode
        else ""
    )

    html = f"""
<div class="{doc_class}">
  <div class="sal-stamp">SAL VERIFIED</div>
  <h4 style="margin-top:0;padding-right:7.5rem;color:#0b2a6f">Logic Specification</h4>
  <p style="margin:0.2rem 0 0.4rem"><strong>{escape(display_title)}</strong><br>
  <code style="font-size:0.9rem">{escape(selected_soc or "—")}</code></p>
  {outlook_html}
  {desc_html}
  {meta_html}
  {pd_html}
  {steps_html}
  {tb_html}
  <p style='font-size:0.78rem;color:#64748b;margin:0.8rem 0 0'>Rendered: {escape(datetime.utcnow().strftime('%Y-%m-%d %H:%M UTC'))}</p>
  {browse_note}
</div>
"""
    st.markdown(html, unsafe_allow_html=True)


def main() -> None:
    st.set_page_config(
        page_title="SAL Staffing Agent — Registry Bureau",
        page_icon="SAL",
        layout="wide",
        initial_sidebar_state="expanded",
    )
    _inject_studio_styles()

    st.markdown("### SAL Staffing Agent")
    st.caption("Institutional staffing bureau · SOC-indexed logic specifications · SAL VERIFIED")

    browse_mode = use_demo_mode()
    client: Client | None = None
    if browse_mode:
        st.info(
            "**Browse mode:** Credentials are placeholders or missing — showing a sample registry so the Stacked "
            "Workforce UI is fully navigable. Replace secrets with live keys when you return."
        )
        counts = _demo_fetch_counts()
    else:
        try:
            client = get_supabase_client()
            counts = fetch_counts(client)
        except Exception as exc:  # noqa: BLE001
            st.warning("Live Supabase unreachable — **browse mode** enabled for layout review.")
            st.caption(escape(str(exc)))
            browse_mode = True
            client = None
            counts = _demo_fetch_counts()

    st.markdown('<div class="sal-metric-wrap">', unsafe_allow_html=True)
    c1, c2, c3 = st.columns(3)
    c1.metric("Active roles", counts["agent_logic"])
    c2.metric("Catalog roles", counts["registry_metadata"])
    c3.metric("Guardrails", counts["guardrails_and_compliance"])
    st.markdown("</div>", unsafe_allow_html=True)

    st.divider()

    # ----------------------------
    # THE HUB (Top Layer): Chat
    # ----------------------------
    if "hub_messages" not in st.session_state:
        st.session_state["hub_messages"] = [
            {
                "role": "assistant",
                "content": "I’m your **SAL Staffing Agent**. Describe the role you need (domain + outcome) and I’ll map it to a SOC logic record.",
            }
        ]

    hub = st.container()
    with hub:
        st.markdown("#### The Hub — SAL Staffing Agent")
        for m in st.session_state["hub_messages"]:
            with st.chat_message(m["role"]):
                st.markdown(m["content"])

        hub_prompt = st.chat_input("Example: I need someone to manage hospital logistics.")
        if hub_prompt:
            st.session_state["hub_messages"].append({"role": "user", "content": escape(hub_prompt)})
            with st.chat_message("user"):
                st.markdown(escape(hub_prompt))

            # Vault scope influences what is eligible for recommendation.
            vault_only = bool(st.session_state.get("vault_only", False))
            reply = staffing_agent_reply(
                client=client,
                user_request=hub_prompt,
                vault_only=vault_only,
                demo_mode=browse_mode,
            )
            if reply.get("selected_soc"):
                st.session_state["active_soc"] = str(reply["selected_soc"])
            with st.chat_message("assistant"):
                st.markdown(reply["message"])
            st.session_state["hub_messages"].append({"role": "assistant", "content": reply["message"]})

    st.divider()

    # ----------------------------
    # THE BUREAU (Middle Layer): File Tree + Doc view
    # ----------------------------
    with st.sidebar:
        st.markdown("##### Filters")
        query = st.text_input("Filter titles", key="sal_search", placeholder="Search titles / outlook…")
        scope = st.radio(
            "Catalog scope",
            ["Full Catalog", "Private Vault 🏆"],
            horizontal=True,
            help="Private Vault lists only proprietary roles (`is_custom = true`).",
            key="sal_scope",
        )
        vault_only = scope != "Full Catalog"
        st.session_state["vault_only"] = vault_only

        _render_file_tree_sidebar(
            supabase_url=_resolve_supabase_url(),
            supabase_key=_resolve_supabase_key(),
            query=query,
            vault_only=vault_only,
            demo_mode=browse_mode,
        )

        with st.expander("Environment"):
            st.caption("Connection flags (no secrets shown).")
            st.write(f"Browse mode: `{browse_mode}`")
            st.write(f"SUPABASE_URL set: `{bool(_resolve_supabase_url())}`")
            st.write(f"SUPABASE key set: `{bool(_resolve_supabase_key())}`")

    selected_soc = str(st.session_state.get("active_soc") or "")
    chosen_row = None
    if selected_soc:
        if browse_mode:
            chosen_row = next((dict(r) for r in _MOCK_REGISTRY if r.get("soc_code") == selected_soc), None)
        elif client is not None:
            try:
                rr = (
                    client.table("registry_metadata")
                    .select("soc_code,title,market_value,outlook,is_custom,description")
                    .eq("soc_code", selected_soc)
                    .limit(1)
                    .execute()
                )
                if rr.data:
                    chosen_row = rr.data[0]
            except Exception:
                chosen_row = None

    logic = None
    if selected_soc:
        if browse_mode:
            logic = _demo_fetch_agent_logic_detail(selected_soc)
        elif client is not None:
            try:
                logic = fetch_agent_logic_detail(client, selected_soc)
            except Exception as exc:  # noqa: BLE001
                st.warning(escape(str(exc)))

    _render_logic_spec_html_card(
        selected_soc=selected_soc,
        chosen_row=chosen_row,
        logic=logic,
        browse_mode=browse_mode,
    )

    # ----------------------------
    # THE PLACEMENT (Bottom Layer): Industry Cards
    # ----------------------------
    st.divider()
    _render_industry_cards()


if __name__ == "__main__":
    main()
