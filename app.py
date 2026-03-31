from __future__ import annotations

import os
from typing import Any

import streamlit as st
from dotenv import load_dotenv
from supabase import Client, create_client


load_dotenv()


def get_supabase_client() -> Client:
    url = (st.secrets.get("SUPABASE_URL") or os.getenv("SUPABASE_URL") or "").strip()
    key = (
        st.secrets.get("SUPABASE_SERVICE_ROLE_KEY")
        or st.secrets.get("SUPABASE_ANON_KEY")
        or os.getenv("SUPABASE_SERVICE_ROLE_KEY")
        or os.getenv("SUPABASE_ANON_KEY")
        or ""
    ).strip()
    if not url or not key:
        raise RuntimeError("Missing SUPABASE_URL and/or SUPABASE_SERVICE_ROLE_KEY (or SUPABASE_ANON_KEY).")
    return create_client(url, key)


def fetch_counts(client: Client) -> dict[str, int]:
    registry_rows = client.table("registry_metadata").select("id", count="exact").limit(1).execute()
    logic_rows = client.table("agent_logic").select("id", count="exact").limit(1).execute()
    guardrail_rows = client.table("guardrails_and_compliance").select("id", count="exact").limit(1).execute()
    return {
        "registry_metadata": int(registry_rows.count or 0),
        "agent_logic": int(logic_rows.count or 0),
        "guardrails_and_compliance": int(guardrail_rows.count or 0),
    }


def lookup_role(client: Client, title_query: str) -> list[dict[str, Any]]:
    result = (
        client.table("registry_metadata")
        .select("soc_code,title,market_value,outlook")
        .ilike("title", f"%{title_query}%")
        .order("title")
        .limit(25)
        .execute()
    )
    return result.data or []


def main() -> None:
    st.set_page_config(page_title="SAL v1.0 Registry", layout="wide")
    st.title("Standard Agent Logic (SAL) v1.0")
    st.caption("SOC-aligned registry for IT, Finance, and Legal role logic.")

    with st.sidebar:
        st.subheader("Environment")
        st.write(f"SUPABASE_URL set: `{bool(st.secrets.get('SUPABASE_URL') or os.getenv('SUPABASE_URL'))}`")
        st.write(
            "SUPABASE key set: "
            f"`{bool(st.secrets.get('SUPABASE_SERVICE_ROLE_KEY') or st.secrets.get('SUPABASE_ANON_KEY') or os.getenv('SUPABASE_SERVICE_ROLE_KEY') or os.getenv('SUPABASE_ANON_KEY'))}`"
        )

    try:
        client = get_supabase_client()
        counts = fetch_counts(client)
    except Exception as exc:  # noqa: BLE001
        st.error(f"Connection check failed: {exc}")
        st.stop()

    c1, c2, c3 = st.columns(3)
    c1.metric("Roles (registry_metadata)", counts["registry_metadata"])
    c2.metric("Logic Records (agent_logic)", counts["agent_logic"])
    c3.metric("Guardrails (guardrails_and_compliance)", counts["guardrails_and_compliance"])

    st.divider()
    st.subheader("Role Lookup")
    query = st.text_input("Search title (example: Judicial Law Clerk, ISO 20022 Message Router)")
    if query:
        rows = lookup_role(client, query)
        if rows:
            st.dataframe(rows, use_container_width=True)
        else:
            st.info("No matching roles found.")


if __name__ == "__main__":
    main()

