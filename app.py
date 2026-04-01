from __future__ import annotations

import json
import os
from html import escape
from typing import Any

import streamlit as st
from dotenv import load_dotenv
from supabase import Client, create_client


load_dotenv()


def _resolve_supabase_url() -> str:
    """Streamlit Cloud: st.secrets first; local: .env / process env."""
    return (st.secrets.get("SUPABASE_URL") or os.getenv("SUPABASE_URL") or "").strip()


def _resolve_supabase_key() -> str:
    """Prefer service role, then anon, then generic SUPABASE_KEY."""
    return (
        st.secrets.get("SUPABASE_SERVICE_ROLE_KEY")
        or st.secrets.get("SUPABASE_ANON_KEY")
        or st.secrets.get("SUPABASE_KEY")
        or os.getenv("SUPABASE_SERVICE_ROLE_KEY")
        or os.getenv("SUPABASE_ANON_KEY")
        or os.getenv("SUPABASE_KEY")
        or ""
    ).strip()


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
        "soc_code,title,market_value,outlook,is_custom"
    )
    if private_vault_only:
        q = q.eq("is_custom", True)
    t = title_query.strip()
    if t:
        q = q.ilike("title", f"%{t}%")
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


def _render_steps_list(steps: list[Any]) -> None:
    if not steps:
        st.caption("_No steps recorded._")
        return
    for i, item in enumerate(steps, start=1):
        if isinstance(item, dict):
            label = item.get("step") or item.get("title") or item.get("name") or f"Step {i}"
            body = item.get("detail") or item.get("description") or item.get("text")
            st.markdown(f"**{i}.** {escape(str(label))}")
            if body is not None:
                st.markdown(f"&nbsp;&nbsp;&nbsp;{escape(str(body))}")
        elif isinstance(item, (list, tuple)) and len(item) == 2:
            st.markdown(f"**{i}.** {escape(str(item[0]))}")
            st.markdown(f"&nbsp;&nbsp;&nbsp;{escape(str(item[1]))}")
        else:
            st.markdown(f"**{i}.** {escape(str(item))}")


def _inject_studio_styles() -> None:
    """Owner-first polish: gold frame for proprietary (is_custom) roles."""
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
</style>
""",
        unsafe_allow_html=True,
    )


def _render_toolbox_requirements(raw: Any) -> None:
    """Render toolbox_requirements without interpreting stored values as HTML."""
    if raw is None:
        return
    if isinstance(raw, (dict, list)):
        st.json(raw)
        return
    st.text(str(raw))


def main() -> None:
    st.set_page_config(
        page_title="SAL Registry — Orchestrator",
        page_icon="◆",
        layout="wide",
        initial_sidebar_state="collapsed",
    )
    _inject_studio_styles()

    st.markdown("### Standard Agent Logic")
    st.caption("ISO 20022–aligned registry · owner-first orchestrator console")

    # Vault toggle at top (mobile-friendly horizontal radio)
    scope = st.radio(
        "Catalog scope",
        ["Full Catalog", "Private Vault 🏆"],
        horizontal=True,
        label_visibility="visible",
        help="Private Vault lists only `registry_metadata.is_custom = true` (proprietary IP).",
    )
    vault_only = scope != "Full Catalog"
    if vault_only:
        st.caption("Private Vault — proprietary roles only (`is_custom = true`).")
    else:
        st.caption("Full Catalog — all SOC-aligned roles.")

    with st.sidebar:
        st.subheader("Environment")
        st.write(f"SUPABASE_URL set: `{bool(_resolve_supabase_url())}`")
        st.write(f"SUPABASE key set: `{bool(_resolve_supabase_key())}`")

    url_set = bool(_resolve_supabase_url())
    key_set = bool(_resolve_supabase_key())

    if not url_set or not key_set:
        st.error("⛔ SAL System Offline")
        st.markdown(
            """
**Supabase credentials are not configured.**

| Key | Required |
|---|---|
| `SUPABASE_URL` | Yes |
| `SUPABASE_SERVICE_ROLE_KEY` | Yes (or `SUPABASE_ANON_KEY`) |

**Streamlit Cloud:** App → Settings → Secrets — TOML with these keys.  
**Local:** `.env` from `.env.template`.
            """
        )
        st.stop()

    try:
        client = get_supabase_client()
        counts = fetch_counts(client)
    except Exception as exc:  # noqa: BLE001
        st.error("⛔ SAL System Offline — connection failed.")
        st.caption(escape(str(exc)))
        st.stop()

    st.markdown('<div class="sal-metric-wrap">', unsafe_allow_html=True)
    c1, c2, c3 = st.columns(3)
    c1.metric("Roles", counts["registry_metadata"])
    c2.metric("Logic records", counts["agent_logic"])
    c3.metric("Guardrails", counts["guardrails_and_compliance"])
    st.markdown("</div>", unsafe_allow_html=True)

    st.divider()

    query = st.text_input(
        "Search title",
        key="sal_search",
        placeholder="e.g. Judicial Law Clerk, ISO 20022 Message Router",
    )
    rows = fetch_registry_roles(client, query, private_vault_only=vault_only)

    if not rows:
        st.info("No roles match this search. Try another title or switch to Full Catalog.")
        st.stop()

    st.subheader("Results")
    option_labels: list[str] = []
    label_to_soc: dict[str, str] = {}
    for r in rows:
        soc = str(r.get("soc_code") or "")
        title = str(r.get("title") or "(untitled)")
        custom = r.get("is_custom") is True
        badge = "🏆 " if custom else ""
        lab = f"{badge}{title} — {soc}"
        option_labels.append(lab)
        label_to_soc[lab] = soc

    choice = st.selectbox(
        "Select a role",
        options=option_labels,
        index=0,
        key="role_pick",
    )
    selected_soc = label_to_soc.get(choice, "")

    chosen_row = next((r for r in rows if str(r.get("soc_code") or "") == selected_soc), None)
    is_custom_row = chosen_row is not None and chosen_row.get("is_custom") is True
    frame_cls = "sal-gold-frame" if is_custom_row else "sal-card"

    meta_bits: list[str] = []
    if chosen_row:
        if chosen_row.get("market_value") is not None:
            meta_bits.append(f"**Market value:** {escape(str(chosen_row['market_value']))}")
        if chosen_row.get("outlook"):
            meta_bits.append(f"**Outlook:** {escape(str(chosen_row['outlook']))}")
    meta_html = " · ".join(meta_bits) if meta_bits else ""

    st.markdown(f'<div class="{escape(frame_cls)}">', unsafe_allow_html=True)
    if is_custom_row:
        st.markdown("#### 🏆 Private Vault · proprietary role")
    st.markdown(
        f"**{escape(str(chosen_row.get('title') if chosen_row else choice))}** `{escape(selected_soc)}`"
    )
    if meta_html:
        st.markdown(meta_html)
    st.markdown("</div>", unsafe_allow_html=True)

    logic = None
    if selected_soc:
        try:
            logic = fetch_agent_logic_detail(client, selected_soc)
        except Exception as exc:  # noqa: BLE001
            st.warning(escape(str(exc)))

    with st.expander("Inspector — Logic Details", expanded=True):
        if not logic:
            st.caption("No `agent_logic` row for this SOC code yet.")
        else:
            pd = logic.get("primary_directive")
            if pd:
                st.markdown("##### Primary directive")
                st.markdown(escape(str(pd)))
            else:
                st.caption("_No primary directive._")

            st.markdown("##### Steps (`step_by_step_json`)")
            steps = _normalize_steps(logic.get("step_by_step_json"))
            _render_steps_list(steps)

            tb = logic.get("toolbox_requirements")
            if tb is not None and tb != "":
                st.markdown("##### Toolbox requirements")
                _render_toolbox_requirements(tb)

    if vault_only and not any(r.get("is_custom") is True for r in rows):
        st.caption("Tip: set `registry_metadata.is_custom = true` for vault rows.")


if __name__ == "__main__":
    main()
