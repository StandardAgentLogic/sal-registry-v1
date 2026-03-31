# Standard Agent Logic (SAL) v1.0

Production registry for role-driven agent execution logic and compliance guardrails.

## Scope

- Active coverage: 100+ SOC-aligned roles across IT, Finance, and Legal clusters.
- Core objective: maintain one canonical logic registry for agent directives, tool plans, and safety protocols.
- Source basis: 2026 O*NET + BLS harvest, normalized for SQL-first runtime access.

## Registry Model

- `registry_metadata`: SOC identity, role title, market value, outlook.
- `agent_logic`: executable role logic (`step_by_step_json`) and required tool stack.
- `guardrails_and_compliance`: safety protocols plus machine-readable verification logic.

## Runtime

- SQL seed ingestion via `executor/terminal_bridge.py`.
- Dynamic role-tool loading via `skills/skill_registry.py`.
- Validation harness via `test_skill.py`.

## Release Artifacts

- Hardened schema: `schema/v1_final_hardened.sql`
- API contract: `docs/API_REFERENCE.md`
- Release summary: `RELEASE_NOTES.md`

