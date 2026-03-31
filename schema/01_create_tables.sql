-- ============================================================
-- SAL Schema v1.0 | Step 1: Table Initialization
-- Minimalist Architecture — lean, modular, MCP-compatible
-- Run in Supabase SQL Editor BEFORE 00_enable_rls_and_api.sql
-- ============================================================

-- Enable UUID extension (required for gen_random_uuid)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ------------------------------------------------------------
-- TABLE 1: registry_metadata
-- Maps SOC codes to job titles, market value, and labor outlook.
-- Primary data source: BLS / O*NET (via Firecrawl ingestor)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS registry_metadata (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  soc_code      TEXT        NOT NULL UNIQUE,   -- e.g. "15-1252.00"
  title         TEXT        NOT NULL,           -- e.g. "Software Developers"
  market_value  NUMERIC(12,2),                  -- median annual wage (USD)
  outlook       TEXT,                           -- e.g. "Much faster than average"
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE registry_metadata IS
  'SOC-mapped labor registry. Source: BLS/O*NET via Firecrawl ingestor.';

-- ------------------------------------------------------------
-- TABLE 2: agent_logic
-- Core directive + step-by-step execution logic per agent role.
-- step_by_step_json follows MCP tool-call structure.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS agent_logic (
  id                    UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
  primary_directive     TEXT    NOT NULL,           -- single-sentence mission statement
  step_by_step_json     JSONB   NOT NULL DEFAULT '[]'::jsonb,  -- MCP-compatible step array
  toolbox_requirements  TEXT[]  NOT NULL DEFAULT '{}',         -- list of required tools/MCPs
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE agent_logic IS
  'Agent execution blueprints. step_by_step_json uses MCP tool-call schema.';

-- ------------------------------------------------------------
-- TABLE 3: guardrails_and_compliance
-- Safety rules, verification logic, and government sync tracking.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS guardrails_and_compliance (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  safety_protocols    TEXT[]      NOT NULL DEFAULT '{}',  -- list of active safety rules
  verification_logic  JSONB       NOT NULL DEFAULT '{}'::jsonb, -- structured checks
  last_gov_sync       TIMESTAMPTZ,                         -- last BLS/O*NET sync timestamp
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE guardrails_and_compliance IS
  'Compliance layer. Tracks safety protocols and government data sync state.';

-- ------------------------------------------------------------
-- Auto-update updated_at trigger (shared function)
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_registry_metadata_updated
  BEFORE UPDATE ON registry_metadata
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_agent_logic_updated
  BEFORE UPDATE ON agent_logic
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_guardrails_updated
  BEFORE UPDATE ON guardrails_and_compliance
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();
