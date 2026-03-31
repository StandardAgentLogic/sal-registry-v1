# SAL API Reference (v1.0)

Minimal runtime contract for reading role logic from PostgreSQL/Supabase.

## Tables

- `registry_metadata` (SOC catalog)
- `agent_logic` (execution logic by `soc_code`)
- `guardrails_and_compliance` (protocols + verification by `soc_code`)

## Required Join Key

- `soc_code` is the canonical key across all three tables.

## Read Patterns

### 1) Resolve a role by SOC code

```sql
SELECT soc_code, title, market_value, outlook
FROM registry_metadata
WHERE soc_code = $1;
```

### 2) Load executable logic + guardrails

```sql
SELECT
  rm.soc_code,
  rm.title,
  al.primary_directive,
  al.step_by_step_json,
  al.toolbox_requirements,
  gc.safety_protocols,
  gc.verification_logic,
  gc.last_gov_sync
FROM registry_metadata rm
JOIN agent_logic al ON al.soc_code = rm.soc_code
JOIN guardrails_and_compliance gc ON gc.soc_code = rm.soc_code
WHERE rm.soc_code = $1;
```

### 3) Role lookup by title fragment

```sql
SELECT soc_code, title
FROM registry_metadata
WHERE title ILIKE '%' || $1 || '%'
ORDER BY title;
```

## Agent Call Contract

For an agent runtime, call sequence is:

1. Resolve target role (`soc_code` or title lookup).
2. Read `primary_directive` + `step_by_step_json`.
3. Enforce `safety_protocols`.
4. Apply `verification_logic` checks before completion.

## Example: ISO 20022 Message Router (title search)

```sql
SELECT rm.soc_code, rm.title, gc.verification_logic
FROM registry_metadata rm
JOIN guardrails_and_compliance gc ON gc.soc_code = rm.soc_code
WHERE rm.title ILIKE '%ISO 20022 Message Router%';
```

## Operational Notes

- Use service-role access for ingestion and backend execution.
- Treat `step_by_step_json` and `verification_logic` as source-of-truth JSONB payloads.
- Version schema changes only through SQL migration files.

