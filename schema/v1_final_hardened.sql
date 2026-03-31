-- ============================================================
-- SAL v1.0 Final Hardened Schema
-- Version: 2026-03-31
-- Purpose: production baseline with SOC foreign keys
-- ============================================================

BEGIN;

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ------------------------------------------------------------
-- registry_metadata (SOC source of truth)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS registry_metadata (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  soc_code      TEXT NOT NULL UNIQUE,
  title         TEXT NOT NULL,
  market_value  NUMERIC(12,2),
  outlook       TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT chk_registry_soc_code_format
    CHECK (soc_code ~ '^[0-9]{2}-[0-9]{4}\.[0-9]{2}$')
);

-- ------------------------------------------------------------
-- agent_logic (execution plan)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS agent_logic (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  soc_code              TEXT NOT NULL,
  primary_directive     TEXT NOT NULL,
  step_by_step_json     JSONB NOT NULL DEFAULT '[]'::jsonb,
  toolbox_requirements  TEXT[] NOT NULL DEFAULT '{}',
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT fk_agent_logic_soc_code
    FOREIGN KEY (soc_code)
    REFERENCES registry_metadata (soc_code)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_agent_logic_steps_array
    CHECK (jsonb_typeof(step_by_step_json) = 'array')
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_agent_logic_soc_code
  ON agent_logic (soc_code);

-- ------------------------------------------------------------
-- guardrails_and_compliance (safety + verification)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS guardrails_and_compliance (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  soc_code            TEXT NOT NULL,
  safety_protocols    TEXT[] NOT NULL DEFAULT '{}',
  verification_logic  JSONB NOT NULL DEFAULT '{}'::jsonb,
  last_gov_sync       TIMESTAMPTZ,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT fk_guardrails_soc_code
    FOREIGN KEY (soc_code)
    REFERENCES registry_metadata (soc_code)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_guardrails_verification_object
    CHECK (jsonb_typeof(verification_logic) = 'object')
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_guardrails_soc_code
  ON guardrails_and_compliance (soc_code);

CREATE INDEX IF NOT EXISTS ix_registry_market_value
  ON registry_metadata (market_value DESC);

-- ------------------------------------------------------------
-- Updated-at trigger
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_registry_metadata_updated ON registry_metadata;
CREATE TRIGGER trg_registry_metadata_updated
  BEFORE UPDATE ON registry_metadata
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_agent_logic_updated ON agent_logic;
CREATE TRIGGER trg_agent_logic_updated
  BEFORE UPDATE ON agent_logic
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_guardrails_updated ON guardrails_and_compliance;
CREATE TRIGGER trg_guardrails_updated
  BEFORE UPDATE ON guardrails_and_compliance
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ------------------------------------------------------------
-- RLS baseline
-- ------------------------------------------------------------
ALTER TABLE registry_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE agent_logic ENABLE ROW LEVEL SECURITY;
ALTER TABLE guardrails_and_compliance ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS service_role_all_registry_metadata ON registry_metadata;
CREATE POLICY service_role_all_registry_metadata
  ON registry_metadata
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

DROP POLICY IF EXISTS service_role_all_agent_logic ON agent_logic;
CREATE POLICY service_role_all_agent_logic
  ON agent_logic
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

DROP POLICY IF EXISTS service_role_all_guardrails ON guardrails_and_compliance;
CREATE POLICY service_role_all_guardrails
  ON guardrails_and_compliance
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

COMMIT;

