# SAL Database — Deployment Runbook

## Execution Order

### Step 1 — Manual UI: Enable Data API
1. Supabase Dashboard > **Settings > API**
2. Toggle **"Enable Data API (REST)"** → ON
3. Save. (No SQL equivalent — UI only.)

### Step 2 — SQL Editor: Create Tables
Paste and run `schema/01_create_tables.sql` in full.

### Step 3 — SQL Editor: Enable RLS + Policies
Paste and run `schema/00_enable_rls_and_api.sql` in full.

### Step 4 — Configure Ingestor Agent
```
cp .env.template .env
# Fill in SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, FIRECRAWL_API_KEY
```

## Verification Queries

```sql
-- Confirm tables exist
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('registry_metadata', 'agent_logic', 'guardrails_and_compliance');

-- Confirm RLS is enabled
SELECT tablename, rowsecurity FROM pg_tables
WHERE schemaname = 'public';
```

## Table Summary

| Table | Purpose | Primary Source |
|---|---|---|
| `registry_metadata` | SOC → title, wage, outlook | BLS / O*NET |
| `agent_logic` | MCP execution blueprints | Internal |
| `guardrails_and_compliance` | Safety rules + gov sync state | Internal + BLS |
