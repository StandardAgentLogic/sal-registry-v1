-- ============================================================
-- SAL Registry v1.0 — FULL IT CLUSTER (SOC 15-0000)
-- Part 1 of 3: registry_metadata (37 roles)
-- Source: O*NET OnLine + BLS OEWS May 2024
-- Ingested: 2026-03-31
-- NULL market_value = "Market Standard" (BLS sub-occupation not
-- reported separately; inherits parent code wage band)
-- ============================================================

BEGIN;

INSERT INTO registry_metadata (soc_code, title, market_value, outlook)
VALUES
-- ── Previously seeded (ON CONFLICT update keeps data fresh) ─
('15-1252.00','Software Developers',                      133080.00, '15% growth 2024-2034, Much faster than average (~129,200 openings/yr)'),
('15-1211.00','Computer Systems Analysts',                103790.00, '9% growth 2024-2034, Much faster than average (~34,200 openings/yr)'),
('15-1212.00','Information Security Analysts',            124910.00, '29% growth 2024-2034, Much faster than average (~16,000 openings/yr)'),
('15-1254.00','Web Developers',                            90930.00, '7% growth 2024-2034, Much faster than average (~14,500 openings/yr)'),
('15-1242.00','Database Administrators',                  104620.00, '4% growth 2024-2034, About as fast as average (~7,800 openings/yr)'),
-- ── New: IT Computer Roles ───────────────────────────────────
('15-1211.01','Health Informatics Specialists',            67310.00, 'Bright Outlook; BLS category: Health IT Technologists and Medical Registrars'),
('15-1221.00','Computer and Information Research Scientists',140910.00,'26% growth 2024-2034, Much faster than average (~3,400 openings/yr)'),
('15-1231.00','Computer Network Support Specialists',      73340.00, '7% growth 2024-2034, Much faster than average'),
('15-1232.00','Computer User Support Specialists',         60340.00, '6% growth 2024-2034, About as fast as average (~65,400 openings/yr)'),
('15-1241.00','Computer Network Architects',              130390.00, '7% growth 2024-2034, Much faster than average (~12,500 openings/yr)'),
('15-1241.01','Telecommunications Engineering Specialists',  NULL,   'Market Standard — BLS reports under Computer Network Architects (15-1241.00)'),
('15-1243.00','Database Architects',                      135980.00, '9% growth 2024-2034, Much faster than average (~7,800 openings/yr combined with DBAs)'),
('15-1243.01','Data Warehousing Specialists',                  NULL, 'Market Standard — BLS reports under Database Architects (15-1243.00)'),
('15-1244.00','Network and Computer Systems Administrators', 96800.00,'7% growth 2024-2034, Much faster than average (~29,600 openings/yr)'),
('15-1251.00','Computer Programmers',                      98670.00, '-10% decline 2024-2034, Faster than average decline'),
('15-1253.00','Software Quality Assurance Analysts and Testers',102610.00,'15% growth 2024-2034, Much faster than average'),
('15-1255.00','Web and Digital Interface Designers',       98090.00, '7% growth 2024-2034, Much faster than average'),
('15-1255.01','Video Game Designers',                          NULL, 'Market Standard — BLS reports under Software Developers (15-1252.00); Bright Outlook'),
-- ── New: Computer Occupations — Specialty Codes ─────────────
('15-1299.01','Web Administrators',                            NULL, 'Market Standard — BLS 15-1299 group; ~8% growth projected 2024-2034'),
('15-1299.02','Geographic Information Systems Technologists and Technicians',NULL,'Market Standard — BLS 15-1299 group; Bright Outlook'),
('15-1299.03','Document Management Specialists',               NULL, 'Market Standard — BLS 15-1299 group'),
('15-1299.04','Penetration Testers',                           NULL, 'Market Standard — BLS 15-1299 group; Bright Outlook; ~29%+ growth'),
('15-1299.05','Information Security Engineers',                NULL, 'Market Standard — BLS 15-1299 group; Bright Outlook'),
('15-1299.06','Digital Forensics Analysts',                    NULL, 'Market Standard — BLS 15-1299 group; Bright Outlook'),
('15-1299.07','Blockchain Engineers',                          NULL, 'Market Standard — BLS 15-1299 group; Emerging role'),
('15-1299.08','Computer Systems Engineers/Architects',         NULL, 'Market Standard — BLS 15-1299 group'),
('15-1299.09','Information Technology Project Managers',       NULL, 'Market Standard — BLS 15-1299 group'),
-- ── New: Mathematical Science Roles ─────────────────────────
('15-2011.00','Actuaries',                                134990.00, '7% growth 2024-2034, Much faster than average (~2,700 openings/yr)'),
('15-2021.00','Mathematicians',                           121680.00, '8% growth 2024-2034, Much faster than average (~4,800 openings/yr combined with statisticians)'),
('15-2031.00','Operations Research Analysts',              91290.00, '21% growth 2024-2034, Much faster than average (~10,200 openings/yr)'),
('15-2041.00','Statisticians',                            103300.00, '8% growth 2024-2034, Much faster than average'),
('15-2041.01','Biostatisticians',                              NULL, 'Market Standard — BLS reports under Statisticians (15-2041.00); Bright Outlook'),
('15-2051.00','Data Scientists',                          112590.00, '34% growth 2024-2034, Much faster than average (~17,700 openings/yr)'),
('15-2051.01','Business Intelligence Analysts',                NULL, 'Market Standard — BLS reports under Data Scientists (15-2051.00); Bright Outlook'),
('15-2051.02','Clinical Data Managers',                        NULL, 'Market Standard — BLS reports under Data Scientists (15-2051.00); Bright Outlook'),
('15-2099.01','Bioinformatics Technicians',                    NULL, 'Market Standard — BLS 15-2099 group; Bright Outlook')
ON CONFLICT (soc_code) DO UPDATE SET
  title        = EXCLUDED.title,
  market_value = EXCLUDED.market_value,
  outlook      = EXCLUDED.outlook,
  updated_at   = NOW();

COMMIT;
