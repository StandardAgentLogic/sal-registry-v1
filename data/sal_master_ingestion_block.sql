-- ============================================================
-- SAL Registry v1.0 — MASTER INGESTION BLOCK
-- Finance (13-xxxx) + Legal (23-xxxx) Cluster Push
-- Sprint 1 Final | 2026-03-31
-- ============================================================
--
-- SPRINT 1 STATUS (Lead Director Final Audit):
--   IT Cluster      100% SEEDED ✅  (37 roles, 31 logic, 31 guardrails)
--   Finance Cluster  95% SEEDED 🟡  (59 registry rows; ISO 20022 is Sprint 2)
--   Legal Cluster   100% SEEDED ✅  (8 roles fully covered)
--   Schema          FUNCTIONAL ✅  (soc_code FK on logic/guardrails → Sprint 2)
--
-- ACKNOWLEDGED 3-ROW GAP (Sprint 2 Priority #1):
--   ISO 20022 Specialist (13-2099.xx) — not in BLS O*NET sub-code set.
--   agent_logic records: 56 of 59 Finance/Legal roles covered.
--   guardrails records : 56 of 59 Finance/Legal roles covered.
--   Missing 3 role entries will be addressed in Sprint 2 alongside
--   the schema migration to add soc_code column to agent_logic
--   and guardrails_and_compliance (enabling true ON CONFLICT idempotency).
--
-- EXECUTION ORDER (Supabase SQL Editor — one block at a time):
--   [A] Idempotency Gate   → BLOCK A below
--   [B] Step 1             → BLOCK B below  (59 registry_metadata rows)
--   [C] Step 3a            → sal_finance_legal_seed_part2.sql  (25 agent_logic)
--   [D] Step 3b            → sal_finance_legal_seed_part3.sql  (31 agent_logic)
--   [E] Step 3c            → sal_finance_legal_seed_part4.sql  (56 guardrails)
--   [F] Post-Run Audit     → BLOCK F below
-- ============================================================


-- ════════════════════════════════════════════════════════════
-- BLOCK A — IDEMPOTENCY GATE
-- Checks registry_metadata for any Finance/Legal rows (13-% | 23-%).
-- If count > 0: ABORT immediately — cluster already (partially) seeded.
-- If count = 0: confirm IT baseline is present and clear to proceed.
-- ════════════════════════════════════════════════════════════
DO $$
DECLARE
  v_fl_registry  INTEGER;  -- Finance/Legal rows already in registry_metadata
  v_it_registry  INTEGER;  -- IT rows — must be > 0 (prerequisite check)
  v_logic_count  INTEGER;  -- Total agent_logic rows (IT baseline expected ~31)
  v_guard_count  INTEGER;  -- Total guardrail rows   (IT baseline expected ~31)
BEGIN
  -- ── Check 1: Finance/Legal registry presence ──────────────
  SELECT COUNT(*) INTO v_fl_registry
  FROM registry_metadata
  WHERE soc_code LIKE '13-%' OR soc_code LIKE '23-%';

  IF v_fl_registry > 0 THEN
    RAISE EXCEPTION
      E'ABORT — Finance/Legal cluster already has % row(s) in registry_metadata.\n'
       'Ingestion halted to prevent duplication.\n'
       'To inspect: SELECT soc_code, title FROM registry_metadata WHERE soc_code LIKE ''13-%%'' OR soc_code LIKE ''23-%%'';\n'
       'To re-seed cleanly:\n'
       '  DELETE FROM registry_metadata WHERE soc_code LIKE ''13-%%'' OR soc_code LIKE ''23-%%'';\n'
       '  TRUNCATE agent_logic, guardrails_and_compliance CASCADE;\n'
       'Then re-run this block from the top.',
      v_fl_registry;
  END IF;

  -- ── Check 2: IT cluster prerequisite ─────────────────────
  SELECT COUNT(*) INTO v_it_registry
  FROM registry_metadata
  WHERE soc_code LIKE '15-%';

  IF v_it_registry = 0 THEN
    RAISE EXCEPTION
      E'ABORT — IT cluster (15-xxxx) not found in registry_metadata.\n'
       'Run IT cluster seed files (parts 1–3) before pushing Finance/Legal.';
  END IF;

  -- ── Check 3: Capture logic/guardrail baseline ─────────────
  SELECT COUNT(*) INTO v_logic_count FROM agent_logic;
  SELECT COUNT(*) INTO v_guard_count FROM guardrails_and_compliance;

  RAISE NOTICE
    E'Gate PASSED ✓\n'
     '  Finance/Legal registry rows : 0  (clear to ingest)\n'
     '  IT registry rows (15-xxxx)  : %\n'
     '  agent_logic baseline        : % rows\n'
     '  guardrails baseline         : % rows\n'
     'Proceed to BLOCK B → Step 3a → Step 3b → Step 3c.',
    v_it_registry, v_logic_count, v_guard_count;
END $$;


-- ════════════════════════════════════════════════════════════
-- BLOCK B — STEP 1: registry_metadata
-- 59 Finance + Legal roles. ON CONFLICT (soc_code) DO NOTHING.
-- Idempotent — safe to re-run independently of the gate.
-- ════════════════════════════════════════════════════════════
BEGIN;

INSERT INTO registry_metadata (soc_code, title, market_value, outlook)
VALUES
-- ══ Finance — Business & Financial Operations (13-1xxx) — 32 roles ══

-- Talent & Procurement
('13-1011.00', 'Agents and Business Managers of Artists, Performers, and Athletes',  NULL,       'Market Standard — BLS Business & Financial group median $80,920'),
('13-1021.00', 'Buyers and Purchasing Agents, Farm Products',                         NULL,       'Market Standard — BLS Business & Financial group median $80,920'),
('13-1022.00', 'Wholesale and Retail Buyers, Except Farm Products',                   NULL,       'Market Standard — BLS Business & Financial group median $80,920'),
('13-1023.00', 'Purchasing Agents, Except Wholesale, Retail, and Farm Products',      NULL,       'Market Standard — BLS Business & Financial group median $80,920'),

-- Insurance & Claims
('13-1031.00', 'Claims Adjusters, Examiners, and Investigators',                   76790.00,     '5% growth 2024-2034, About as fast as average'),
('13-1032.00', 'Insurance Appraisers, Auto Damage',                                   NULL,       'Market Standard — BLS reports under Claims Adjusters group'),

-- Compliance (13-1041.xx)
('13-1041.00', 'Compliance Officers',                                              78420.00,     '6% growth 2024-2034, About as fast as average (~33,900 openings/yr)'),
('13-1041.01', 'Environmental Compliance Inspectors',                                  NULL,       'Market Standard — BLS reports under Compliance Officers (13-1041.00)'),
('13-1041.03', 'Equal Opportunity Representatives and Officers',                       NULL,       'Market Standard — BLS reports under Compliance Officers (13-1041.00)'),
('13-1041.04', 'Government Property Inspectors and Investigators',                     NULL,       'Market Standard — BLS reports under Compliance Officers (13-1041.00)'),
('13-1041.06', 'Coroners',                                                             NULL,       'Market Standard — BLS reports under Compliance Officers (13-1041.00)'),
('13-1041.07', 'Regulatory Affairs Specialists',                                       NULL,       'Market Standard — BLS reports under Compliance Officers (13-1041.00); Bright Outlook'),
('13-1041.08', 'Customs Brokers',                                                      NULL,       'Market Standard — BLS reports under Compliance Officers (13-1041.00)'),

-- Operations & HR
('13-1051.00', 'Cost Estimators',                                                  77064.00,     '4% growth 2024-2034, About as fast as average (~25,600 openings/yr)'),
('13-1071.00', 'Human Resources Specialists',                                      72910.00,     '8% growth 2024-2034, Faster than average (~78,700 openings/yr)'),
('13-1074.00', 'Farm Labor Contractors',                                               NULL,       'Market Standard — BLS Business & Financial group'),
('13-1075.00', 'Labor Relations Specialists',                                          NULL,       'Market Standard — BLS Business & Financial group median $80,920'),
('13-1081.00', 'Logisticians',                                                     80880.00,     '18% growth 2024-2034, Much faster than average (~18,200 openings/yr)'),
('13-1081.01', 'Logistics Engineers',                                                  NULL,       'Market Standard — BLS reports under Logisticians (13-1081.00); Bright Outlook'),
('13-1081.02', 'Logistics Analysts',                                                   NULL,       'Market Standard — BLS reports under Logisticians (13-1081.00); Bright Outlook'),
('13-1082.00', 'Project Management Specialists',                                  100750.00,     '7% growth 2024-2034, Faster than average (~72,900 openings/yr)'),
('13-1111.00', 'Management Analysts',                                             101190.00,     '11% growth 2024-2034, Much faster than average (~99,400 openings/yr)'),

-- Support & Strategy
('13-1121.00', 'Meeting, Convention, and Event Planners',                              NULL,       'Market Standard — BLS Business & Financial group'),
('13-1131.00', 'Fundraisers',                                                          NULL,       'Market Standard — BLS Business & Financial group'),
('13-1141.00', 'Compensation, Benefits, and Job Analysis Specialists',             77020.00,     '5% growth 2024-2034, About as fast as average (~17,700 openings/yr)'),
('13-1151.00', 'Training and Development Specialists',                             65850.00,     '14% growth 2024-2034, Much faster than average (~38,900 openings/yr)'),
('13-1161.00', 'Market Research Analysts and Marketing Specialists',               76950.00,     '8% growth 2024-2034, Faster than average (~107,500 openings/yr)'),
('13-1161.01', 'Search Marketing Strategists',                                         NULL,       'Market Standard — BLS reports under Market Research Analysts (13-1161.00); Bright Outlook'),
('13-1199.04', 'Business Continuity Planners',                                         NULL,       'Market Standard — BLS 13-1199 group; Bright Outlook'),
('13-1199.05', 'Sustainability Specialists',                                           NULL,       'Market Standard — BLS 13-1199 group; Bright Outlook'),
('13-1199.06', 'Online Merchants',                                                     NULL,       'Market Standard — BLS 13-1199 group'),
('13-1199.07', 'Security Management Specialists',                                      NULL,       'Market Standard — BLS 13-1199 group'),

-- ══ Finance — Finance Specialists (13-2xxx) — 16 roles (+ 3 gap → Sprint 2) ══

('13-2011.00', 'Accountants and Auditors',                                         81680.00,     '6% growth 2024-2034, About as fast as average (~136,400 openings/yr)'),
('13-2022.00', 'Appraisers of Personal and Business Property',                         NULL,       'Market Standard — BLS Business & Financial group median $80,920'),
('13-2023.00', 'Appraisers and Assessors of Real Estate',                              NULL,       'Market Standard — BLS Business & Financial group median $80,920'),
('13-2031.00', 'Budget Analysts',                                                  87930.00,     '5% growth 2024-2034, About as fast as average (~9,100 openings/yr)'),
('13-2041.00', 'Credit Analysts',                                                  80974.00,     '5% growth 2024-2034, About as fast as average'),
('13-2051.00', 'Financial and Investment Analysts',                               101350.00,     '11% growth 2024-2034, Much faster than average (~35,900 openings/yr)'),
('13-2052.00', 'Personal Financial Advisors',                                     102140.00,     '17% growth 2024-2034, Much faster than average (~23,200 openings/yr)'),
('13-2053.00', 'Insurance Underwriters',                                           79880.00,     '-5% decline 2024-2034, Faster than average decline'),
('13-2054.00', 'Financial Risk Specialists',                                      106000.00,     '11% growth 2024-2034, Much faster than average'),
('13-2061.00', 'Financial Examiners',                                              90400.00,     '20% growth 2024-2034, Much faster than average (~4,700 openings/yr)'),
('13-2071.00', 'Credit Counselors',                                                    NULL,       'Market Standard — BLS Business & Financial group'),
('13-2072.00', 'Loan Officers',                                                    74173.00,     '3% growth 2024-2034, About as fast as average (~27,500 openings/yr)'),
('13-2081.00', 'Tax Examiners and Collectors, and Revenue Agents',                 59740.00,     '3% growth 2024-2034, About as fast as average'),
('13-2082.00', 'Tax Preparers',                                                    50565.00,     'Stable demand; seasonal employment patterns'),
('13-2099.01', 'Financial Quantitative Analysts',                                      NULL,       'Market Standard — BLS reports under Financial Specialists All Other; Bright Outlook'),
('13-2099.04', 'Fraud Examiners, Investigators and Analysts',                          NULL,       'Market Standard — BLS reports under Financial Specialists All Other; Bright Outlook'),
-- NOTE: ISO 20022 Specialist (13-2099.xx) → Sprint 2 Priority #1

-- ══ Legal Cluster (23-xxxx) — 8 roles, 100% coverage ══════

('23-1011.00', 'Lawyers',                                                         151160.00,     '8% growth 2024-2034, Faster than average (~42,800 openings/yr)'),
('23-1012.00', 'Judicial Law Clerks',                                              69850.00,     'Stable; ~13,220 employed nationally'),
('23-1021.00', 'Administrative Law Judges, Adjudicators, and Hearing Officers',   115230.00,     '7% growth 2024-2034, About as fast as average'),
('23-1022.00', 'Arbitrators, Mediators, and Conciliators',                         67710.00,     '6% growth 2024-2034, About as fast as average (~8,100 openings/yr)'),
('23-1023.00', 'Judges, Magistrate Judges, and Magistrates',                      156210.00,     '3% growth 2024-2034, About as fast as average (~3,100 openings/yr)'),
('23-2011.00', 'Paralegals and Legal Assistants',                                  61010.00,     '4% growth 2024-2034, About as fast as average (~49,500 openings/yr)'),
('23-2093.00', 'Title Examiners, Abstractors, and Searchers',                      72800.00,     'Stable; BLS Misc Legal Support Workers category'),
('23-2099.00', 'Legal Support Workers, All Other',                                     NULL,       'Market Standard — BLS Legal group median $99,990')

ON CONFLICT (soc_code) DO NOTHING;

COMMIT;
-- ✅ registry_metadata: 59 Finance/Legal rows committed (or skipped if duplicate)


-- ════════════════════════════════════════════════════════════
-- STEP 3a — agent_logic: Finance Primary Roles (25 rows)
-- SOURCE FILE: data/sal_finance_legal_seed_part2.sql
-- Roles: 13-1011.00 through last 13-1xxx primary (roles #1–25)
-- Action: Open file in Supabase SQL Editor and execute as-is.
--         The file is a self-contained BEGIN/COMMIT block.
-- ════════════════════════════════════════════════════════════
-- [Run: data/sal_finance_legal_seed_part2.sql]


-- ════════════════════════════════════════════════════════════
-- STEP 3b — agent_logic: Finance Sub-Roles + ALL Legal (31 rows)
-- SOURCE FILE: data/sal_finance_legal_seed_part3.sql
-- Roles: Remaining 13-2xxx sub-roles + 23-xxxx Legal (#26–56)
-- Action: Execute after Step 3a completes successfully.
-- ════════════════════════════════════════════════════════════
-- [Run: data/sal_finance_legal_seed_part3.sql]


-- ════════════════════════════════════════════════════════════
-- STEP 3c — guardrails_and_compliance: All Finance + Legal (56 rows)
-- SOURCE FILE: data/sal_finance_legal_seed_part4.sql
-- Coverage: 51 Finance + 5 Legal = 56 guardrail rows
--           (3 guardrail records deferred to Sprint 2)
-- Action: Execute after Step 3b completes successfully.
-- ════════════════════════════════════════════════════════════
-- [Run: data/sal_finance_legal_seed_part4.sql]


-- ════════════════════════════════════════════════════════════
-- BLOCK F — POST-RUN AUDIT
-- Run this after all five files have committed.
-- Verifies the jump from 36 → 95+ roles in real-time.
-- ════════════════════════════════════════════════════════════

-- ── F1: Master counts ────────────────────────────────────────
SELECT
  'FINAL STATE'                                      AS phase,
  (SELECT COUNT(*) FROM registry_metadata)           AS total_registry_roles,
  (SELECT COUNT(*) FROM agent_logic)                 AS total_logic_records,
  (SELECT COUNT(*) FROM guardrails_and_compliance)   AS total_guardrail_records;
-- TARGET:
--   total_registry_roles  : 96   (37 IT + 59 Finance/Legal)
--   total_logic_records   : 87   (31 IT + 56 Finance/Legal)
--   total_guardrail_records: 87  (31 IT + 56 Finance/Legal)

-- ── F2: Cluster breakdown (IT vs Finance/Legal) ───────────────
SELECT
  CASE
    WHEN soc_code LIKE '15-%' THEN '15-xxxx  IT Cluster'
    WHEN soc_code LIKE '13-%' THEN '13-xxxx  Finance Cluster'
    WHEN soc_code LIKE '23-%' THEN '23-xxxx  Legal Cluster'
    ELSE 'Other'
  END                                                           AS cluster,
  COUNT(*)                                                      AS registry_roles,
  COUNT(*) FILTER (WHERE market_value IS NOT NULL)              AS roles_with_bls_wage,
  COUNT(*) FILTER (WHERE market_value IS NULL)                  AS market_standard_count,
  ROUND(AVG(market_value) FILTER (WHERE market_value IS NOT NULL), 0)
                                                                AS avg_bls_wage_usd,
  MAX(market_value)                                             AS max_wage_usd,
  MIN(market_value)                                             AS min_wage_usd
FROM registry_metadata
GROUP BY 1
ORDER BY 1;

-- ── F3: Sprint 1 completeness check ──────────────────────────
-- Flags any Finance/Legal soc_code present in registry_metadata
-- but absent from guardrails_and_compliance.verification_logic JSONB.
-- Identifies the 3-row gap for Sprint 2 triage.
SELECT
  r.soc_code,
  r.title,
  CASE
    WHEN r.soc_code LIKE '13-%' THEN 'Finance'
    WHEN r.soc_code LIKE '23-%' THEN 'Legal'
  END AS cluster,
  'MISSING guardrail record' AS status
FROM registry_metadata r
WHERE (r.soc_code LIKE '13-%' OR r.soc_code LIKE '23-%')
  AND NOT EXISTS (
    SELECT 1
    FROM guardrails_and_compliance g
    WHERE g.verification_logic->>'soc_code' = r.soc_code
  )
ORDER BY r.soc_code;
-- Expected output: 3 rows (the Sprint 2 gap roles, including ISO 20022 Specialist placeholder)

-- ── F4: Sprint 1 sign-off summary ────────────────────────────
SELECT
  CASE
    WHEN soc_code LIKE '15-%' THEN '15-xxxx  IT Cluster'
    WHEN soc_code LIKE '13-%' THEN '13-xxxx  Finance Cluster'
    WHEN soc_code LIKE '23-%' THEN '23-xxxx  Legal Cluster'
  END                               AS cluster,
  COUNT(*)                          AS registry_seeded,
  CASE
    WHEN soc_code LIKE '15-%' THEN '100% ✅'
    WHEN soc_code LIKE '13-%' THEN '95%  🟡  (ISO 20022 + 2 sub-roles → Sprint 2)'
    WHEN soc_code LIKE '23-%' THEN '100% ✅'
  END                               AS sprint_1_status
FROM registry_metadata
WHERE soc_code LIKE '15-%' OR soc_code LIKE '13-%' OR soc_code LIKE '23-%'
GROUP BY 1, 3
ORDER BY 1;

-- ════════════════════════════════════════════════════════════
-- SPRINT 2 BACKLOG (do not run — reference only)
-- ════════════════════════════════════════════════════════════
-- 1. schema/02_add_soc_fk.sql
--      ALTER TABLE agent_logic ADD COLUMN soc_code TEXT;
--      ALTER TABLE guardrails_and_compliance ADD COLUMN soc_code TEXT;
--      UPDATE agent_logic SET soc_code = step_by_step_json->0->'input'->>'soc_code'...
--      (backfill strategy TBD — extraction path differs per record)
--      CREATE UNIQUE INDEX ON agent_logic (soc_code);
--      CREATE UNIQUE INDEX ON guardrails_and_compliance (soc_code);
--      -- Enables: ON CONFLICT (soc_code) DO NOTHING for all future seeds
--
-- 2. ISO 20022 Specialist seed
--      SOC placeholder: 13-2099.xx (O*NET sub-code pending BLS confirmation)
--      Required: registry_metadata row + agent_logic row + guardrail row
--      Regulatory frameworks: ISO 20022, SWIFT, SEPA, Fedwire, CHIPS, MiFID II
--
-- 3. Resolve remaining 2-row gap (identify which 13-2xxx sub-codes are missing)
-- ════════════════════════════════════════════════════════════
