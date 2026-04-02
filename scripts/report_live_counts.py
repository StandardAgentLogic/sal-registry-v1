"""Print agent_logic and registry_metadata counts using secrets.toml and/or .env."""
from __future__ import annotations

import os
import sys
from pathlib import Path

_REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(_REPO))


def main() -> int:
    try:
        import tomllib
    except ImportError:
        import tomli as tomllib  # type: ignore[no-redef, import-untyped]

    from dotenv import load_dotenv

    load_dotenv(_REPO / ".env")

    url, key = "", ""
    secrets_path = _REPO / ".streamlit" / "secrets.toml"
    if secrets_path.exists():
        data = tomllib.loads(secrets_path.read_text(encoding="utf-8"))
        url = str(data.get("SUPABASE_URL") or "").strip()
        key = (
            str(data.get("SUPABASE_SERVICE_ROLE_KEY") or "").strip()
            or str(data.get("SUPABASE_ANON_KEY") or "").strip()
            or str(data.get("SUPABASE_KEY") or "").strip()
        )
    if not url:
        url = (os.getenv("SUPABASE_URL") or "").strip()
    if not key:
        key = (
            (os.getenv("SUPABASE_SERVICE_ROLE_KEY") or "").strip()
            or (os.getenv("SUPABASE_ANON_KEY") or "").strip()
            or (os.getenv("SUPABASE_KEY") or "").strip()
        )

    if not url or not key or "INSERT_" in key.upper() or "INSERT_" in url.upper():
        print("Supabase URL/key missing or placeholder — Browse mode expected.")
        return 2
    from supabase import create_client

    client = create_client(url, key)
    al = client.table("agent_logic").select("*", count="exact").limit(0).execute()
    rm = client.table("registry_metadata").select("*", count="exact").limit(0).execute()
    print("=== SAL live count report (Supabase) ===")
    print(f"Active Logic (agent_logic):     {al.count}")
    print(f"Catalog (registry_metadata):    {rm.count}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
