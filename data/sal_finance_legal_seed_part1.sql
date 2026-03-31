-- ============================================================
-- SAL Registry v1.0 — FINANCE (13-xxxx) + LEGAL (23-xxxx) CLUSTERS
-- Part 1 of 4: registry_metadata — All 59 roles
-- Source: O*NET OnLine + BLS OEWS May 2024
-- Ingested: 2026-03-31 | NULL market_value = "Market Standard"
-- Single BEGIN/COMMIT — entire batch fails if any row is malformed
-- ============================================================

BEGIN;

INSERT INTO registry_metadata (soc_code, title, market_value, outlook)
VALUES
-- ══════════════════════════════════════════════════════════════
-- FINANCE CLUSTER — Business & Financial Operations (13-1xxx)
-- ══════════════════════════════════════════════════════════════
('13-1011.00','Agents and Business Managers of Artists, Performers, and Athletes', NULL,         'Market Standard — BLS Business & Financial group median $80,920'),
('13-1021.00','Buyers and Purchasing Agents, Farm Products',                        NULL,         'Market Standard — BLS Business & Financial group median $80,920'),
('13-1022.00','Wholesale and Retail Buyers, Except Farm Products',                  NULL,         'Market Standard — BLS Business & Financial group median $80,920'),
('13-1023.00','Purchasing Agents, Except Wholesale, Retail, and Farm Products',     NULL,         'Market Standard — BLS Business & Financial group median $80,920'),
('13-1031.00','Claims Adjusters, Examiners, and Investigators',                  76790.00,       '5% growth 2024-2034, About as fast as average'),
('13-1032.00','Insurance Appraisers, Auto Damage',                                  NULL,         'Market Standard — BLS reports under Claims Adjusters group'),
('13-1041.00','Compliance Officers',                                             78420.00,        '6% growth 2024-2034, About as fast as average (~33,900 openings/yr)'),
('13-1041.01','Environmental Compliance Inspectors',                                NULL,         'Market Standard — BLS reports under Compliance Officers (13-1041.00)'),
('13-1041.03','Equal Opportunity Representatives and Officers',                      NULL,         'Market Standard — BLS reports under Compliance Officers (13-1041.00)'),
('13-1041.04','Government Property Inspectors and Investigators',                    NULL,         'Market Standard — BLS reports under Compliance Officers (13-1041.00)'),
('13-1041.06','Coroners',                                                            NULL,         'Market Standard — BLS reports under Compliance Officers (13-1041.00)'),
('13-1041.07','Regulatory Affairs Specialists',                                      NULL,         'Market Standard — BLS reports under Compliance Officers (13-1041.00); Bright Outlook'),
('13-1041.08','Customs Brokers',                                                     NULL,         'Market Standard — BLS reports under Compliance Officers (13-1041.00)'),
('13-1051.00','Cost Estimators',                                                  77064.00,       '4% growth 2024-2034, About as fast as average (~25,600 openings/yr)'),
('13-1071.00','Human Resources Specialists',                                      72910.00,       '8% growth 2024-2034, Faster than average (~78,700 openings/yr)'),
('13-1074.00','Farm Labor Contractors',                                               NULL,        'Market Standard — BLS Business & Financial group'),
('13-1075.00','Labor Relations Specialists',                                          NULL,        'Market Standard — BLS Business & Financial group median $80,920'),
('13-1081.00','Logisticians',                                                     80880.00,       '18% growth 2024-2034, Much faster than average (~18,200 openings/yr)'),
('13-1081.01','Logistics Engineers',                                                  NULL,        'Market Standard — BLS reports under Logisticians (13-1081.00); Bright Outlook'),
('13-1081.02','Logistics Analysts',                                                   NULL,        'Market Standard — BLS reports under Logisticians (13-1081.00); Bright Outlook'),
('13-1082.00','Project Management Specialists',                                  100750.00,       '7% growth 2024-2034, Faster than average (~72,900 openings/yr)'),
('13-1111.00','Management Analysts',                                             101190.00,       '11% growth 2024-2034, Much faster than average (~99,400 openings/yr)'),
('13-1121.00','Meeting, Convention, and Event Planners',                              NULL,        'Market Standard — BLS Business & Financial group'),
('13-1131.00','Fundraisers',                                                          NULL,        'Market Standard — BLS Business & Financial group'),
('13-1141.00','Compensation, Benefits, and Job Analysis Specialists',             77020.00,       '5% growth 2024-2034, About as fast as average (~17,700 openings/yr)'),
('13-1151.00','Training and Development Specialists',                             65850.00,       '14% growth 2024-2034, Much faster than average (~38,900 openings/yr)'),
('13-1161.00','Market Research Analysts and Marketing Specialists',               76950.00,       '8% growth 2024-2034, Faster than average (~107,500 openings/yr)'),
('13-1161.01','Search Marketing Strategists',                                         NULL,        'Market Standard — BLS reports under Market Research Analysts (13-1161.00); Bright Outlook'),
('13-1199.04','Business Continuity Planners',                                         NULL,        'Market Standard — BLS 13-1199 group; Bright Outlook'),
('13-1199.05','Sustainability Specialists',                                            NULL,        'Market Standard — BLS 13-1199 group; Bright Outlook'),
('13-1199.06','Online Merchants',                                                      NULL,        'Market Standard — BLS 13-1199 group'),
('13-1199.07','Security Management Specialists',                                       NULL,        'Market Standard — BLS 13-1199 group'),
-- ── Finance Specialists (13-2xxx) ───────────────────────────
('13-2011.00','Accountants and Auditors',                                         81680.00,       '6% growth 2024-2034, About as fast as average (~136,400 openings/yr)'),
('13-2022.00','Appraisers of Personal and Business Property',                         NULL,        'Market Standard — BLS Business & Financial group median $80,920'),
('13-2023.00','Appraisers and Assessors of Real Estate',                              NULL,        'Market Standard — BLS Business & Financial group median $80,920'),
('13-2031.00','Budget Analysts',                                                  87930.00,       '5% growth 2024-2034, About as fast as average (~9,100 openings/yr)'),
('13-2041.00','Credit Analysts',                                                  80974.00,       '5% growth 2024-2034, About as fast as average'),
('13-2051.00','Financial and Investment Analysts',                               101350.00,       '11% growth 2024-2034, Much faster than average (~35,900 openings/yr)'),
('13-2052.00','Personal Financial Advisors',                                     102140.00,       '17% growth 2024-2034, Much faster than average (~23,200 openings/yr)'),
('13-2053.00','Insurance Underwriters',                                           79880.00,       '-5% decline 2024-2034, Faster than average decline'),
('13-2054.00','Financial Risk Specialists',                                      106000.00,       '11% growth 2024-2034, Much faster than average'),
('13-2061.00','Financial Examiners',                                              90400.00,       '20% growth 2024-2034, Much faster than average (~4,700 openings/yr)'),
('13-2071.00','Credit Counselors',                                                    NULL,        'Market Standard — BLS Business & Financial group'),
('13-2072.00','Loan Officers',                                                    74173.00,       '3% growth 2024-2034, About as fast as average (~27,500 openings/yr)'),
('13-2081.00','Tax Examiners and Collectors, and Revenue Agents',                 59740.00,       '3% growth 2024-2034, About as fast as average'),
('13-2082.00','Tax Preparers',                                                    50565.00,       'Stable demand; seasonal employment patterns'),
('13-2099.01','Financial Quantitative Analysts',                                      NULL,        'Market Standard — BLS reports under Financial Specialists All Other; Bright Outlook'),
('13-2099.04','Fraud Examiners, Investigators and Analysts',                          NULL,        'Market Standard — BLS reports under Financial Specialists All Other; Bright Outlook'),

-- ══════════════════════════════════════════════════════════════
-- LEGAL CLUSTER (23-xxxx)
-- ══════════════════════════════════════════════════════════════
('23-1011.00','Lawyers',                                                         151160.00,       '8% growth 2024-2034, Faster than average (~42,800 openings/yr)'),
('23-1012.00','Judicial Law Clerks',                                              69850.00,       'Stable; ~13,220 employed nationally'),
('23-1021.00','Administrative Law Judges, Adjudicators, and Hearing Officers',   115230.00,       '7% growth 2024-2034, About as fast as average'),
('23-1022.00','Arbitrators, Mediators, and Conciliators',                         67710.00,       '6% growth 2024-2034, About as fast as average (~8,100 openings/yr)'),
('23-1023.00','Judges, Magistrate Judges, and Magistrates',                      156210.00,       '3% growth 2024-2034, About as fast as average (~3,100 openings/yr)'),
('23-2011.00','Paralegals and Legal Assistants',                                  61010.00,       '4% growth 2024-2034, About as fast as average (~49,500 openings/yr)'),
('23-2093.00','Title Examiners, Abstractors, and Searchers',                      72800.00,       'Stable; BLS Misc Legal Support Workers category'),
('23-2099.00','Legal Support Workers, All Other',                                     NULL,        'Market Standard — BLS Legal group median $99,990')

ON CONFLICT (soc_code) DO UPDATE SET
  title        = EXCLUDED.title,
  market_value = EXCLUDED.market_value,
  outlook      = EXCLUDED.outlook,
  updated_at   = NOW();

COMMIT;
