-- ============================================================
-- SAL Schema v1.0 | Step 0: Security Baseline
-- Run this FIRST in Supabase SQL Editor (Dashboard > SQL Editor)
-- ============================================================

-- NOTE: "Enable Data API" is a project-level toggle.
-- Go to: Supabase Dashboard > Settings > API > enable "Data API (REST)"
-- There is no SQL command for this — it must be toggled in the UI.

-- Enable RLS on all SAL tables after creation.
-- (Run this block AFTER running 01_create_tables.sql)

ALTER TABLE registry_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE agent_logic         ENABLE ROW LEVEL SECURITY;
ALTER TABLE guardrails_and_compliance ENABLE ROW LEVEL SECURITY;

-- Service Role bypass (full access for Ingestor Agent via service_role key)
-- These policies allow the backend/ingestor to read+write unrestricted.
-- Anon/public access is intentionally blocked until explicit policies are added.

CREATE POLICY "service_role_all_registry_metadata"
  ON registry_metadata
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

CREATE POLICY "service_role_all_agent_logic"
  ON agent_logic
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

CREATE POLICY "service_role_all_guardrails"
  ON guardrails_and_compliance
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);
