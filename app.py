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
</style>
""",
        unsafe_allow_html=True,
    )


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
        initial_sidebar_state="expanded",
    )
    _inject_studio_styles()

    st.markdown("### Standard Agent Logic")
    st.caption("ISO 20022–aligned registry · high-density directory + logic inspector")

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

    with st.sidebar:
        st.markdown("##### Registry directory")
        query = st.text_input(
            "Filter titles",
            key="sal_search",
            placeholder="e.g. ISO 20022, Clerk…",
            label_visibility="visible",
        )
        scope = st.radio(
            "Catalog scope",
            ["Full Catalog", "Private Vault 🏆"],
            horizontal=True,
            label_visibility="visible",
            help="Private Vault lists only `registry_metadata.is_custom = true`.",
            key="sal_scope",
        )
        vault_only = scope != "Full Catalog"
        rows = fetch_registry_roles(client, query, private_vault_only=vault_only)
        _sync_active_role(rows)
        if rows:
            st.caption(f"{len(rows)} roles · click to open in main view")
            _render_sidebar_registry_directory(rows)
        else:
            st.caption("No matches — widen search or switch to Full Catalog.")

        with st.expander("Environment"):
            st.caption("Connection flags (no secrets shown).")
            st.write(f"SUPABASE_URL set: `{bool(_resolve_supabase_url())}`")
            st.write(f"SUPABASE key set: `{bool(_resolve_supabase_key())}`")

    if not rows:
        st.info("No roles match this filter. Adjust **Filter titles** or **Catalog scope** in the sidebar.")
        st.stop()

    selected_soc = str(st.session_state["active_soc"] or "")
    chosen_row = next((r for r in rows if str(r.get("soc_code") or "") == selected_soc), None)
    display_title = str(chosen_row.get("title")) if chosen_row else "Select a role in the sidebar"
    is_custom_row = chosen_row is not None and chosen_row.get("is_custom") is True
    frame_cls = "sal-gold-frame" if is_custom_row else "sal-card"

    st.subheader("Active role")
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
    st.markdown(f"**{escape(display_title)}** `{escape(selected_soc)}`")
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
