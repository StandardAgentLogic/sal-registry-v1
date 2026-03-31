# SAL v1.0 Release Notes

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

