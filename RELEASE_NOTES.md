# SAL v1.0 Release Notes

---

## v1.0.2 — Production Handshake Complete
Date: 2026-03-31
Status: **LIVE — Secret-Aware Chassis Online**
Commit: `e00558b`

### What Changed
- Fixed `fetch_counts()` to use column-agnostic `select("*").limit(0)` count query,
  resolving PostgreSQL error 42703 caused by REST API column visibility mismatch.
- Added pre-flight credential check in `app.py`: app now renders a structured
  "System Offline" UI with remediation instructions if Supabase secrets are absent,
  instead of surfacing a raw Python traceback.
- Confirmed Streamlit Cloud secrets vault is bridged:
  `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `SUPABASE_ANON_KEY` all resolving `True`.
- Live smoke test confirmed: zero errors, zero tracebacks, Role Lookup query path
  executes cleanly. Metrics read `0` pending SQL seed execution (expected — DB empty).

### Production Coordinates
- App: `https://sal-registry-v1-9ozcn4anauizepp4nbbrk6.streamlit.app`
- Repo: `https://github.com/StandardAgentLogic/sal-registry-v1`
- Supabase Project: `mykojfjfwgdaudkjmgke`

### Next Required Action (Data Ingestion Phase)
Run seed files 1–9 (IT + Finance + Legal clusters) in Supabase SQL Editor to
populate the registry. See `data/FINANCE_LEGAL_INGEST_NOTES.md` for execution order.

---

## v1.0.1 — Schema & Compliance Layer Complete
Date: 2026-03-31
Status: Production-ready baseline

## Highlights

- Completed 2026 O*NET/BLS role harvest for IT, Finance, and Legal clusters.
- Established SOC-keyed registry model for metadata, execution logic, and compliance guardrails.
- Promoted SQL registry to operational source of truth for agent runtime behavior.

## Data and Schema

- Seeded and validated role logic using JSONB payloads and array-based safety protocols.
- Added hardened schema target with explicit SOC foreign keys:
  - `schema/v1_final_hardened.sql`
- Maintained RLS service-role baseline for controlled backend execution.

## Runtime Transition

- Transitioned from scrape-first workflow to DB-backed execution workflow.
- Standardized ingestion path through `executor/terminal_bridge.py`.
- Standardized role resolution/loading through `skills/skill_registry.py`.

## Operational Outcome

- Registry now acts as canonical logic backend ("Source of Truth") for future agents.
- Future releases should append migrations only; no direct production drift.

