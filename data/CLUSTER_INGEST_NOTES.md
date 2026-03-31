# SAL Full IT Cluster — Ingest Notes

## Execution Order
1. `schema/01_create_tables.sql` — create tables
2. `schema/00_enable_rls_and_api.sql` — enable RLS + policies
3. `data/sal_full_cluster_seed_part1.sql` — registry_metadata (37 roles, idempotent ON CONFLICT)
4. `data/sal_full_cluster_seed_part2.sql` — agent_logic roles 1–19
5. `data/sal_full_cluster_seed_part3.sql` — agent_logic roles 20–31 + ALL guardrails
> Run parts 2/3 ONLY ONCE on a fresh cluster. They have no UNIQUE constraint guard.
> For re-runs, truncate agent_logic and guardrails_and_compliance first.

## Full Role Coverage: 37 Roles (SOC 15-xxxx)

### Computer & IT Occupations (15-1xxx)
| # | SOC Code | Title | BLS Wage |
|---|---|---|---|
| 1 | 15-1211.00 | Computer Systems Analysts | $103,790 |
| 2 | 15-1211.01 | Health Informatics Specialists | $67,310 |
| 3 | 15-1212.00 | Information Security Analysts | $124,910 |
| 4 | 15-1221.00 | Computer and Information Research Scientists | $140,910 |
| 5 | 15-1231.00 | Computer Network Support Specialists | $73,340 |
| 6 | 15-1232.00 | Computer User Support Specialists | $60,340 |
| 7 | 15-1241.00 | Computer Network Architects | $130,390 |
| 8 | 15-1241.01 | Telecommunications Engineering Specialists | Market Standard |
| 9 | 15-1242.00 | Database Administrators | $104,620 |
| 10 | 15-1243.00 | Database Architects | $135,980 |
| 11 | 15-1243.01 | Data Warehousing Specialists | Market Standard |
| 12 | 15-1244.00 | Network and Computer Systems Administrators | $96,800 |
| 13 | 15-1251.00 | Computer Programmers | $98,670 |
| 14 | 15-1252.00 | Software Developers | $133,080 |
| 15 | 15-1253.00 | Software Quality Assurance Analysts and Testers | $102,610 |
| 16 | 15-1254.00 | Web Developers | $90,930 |
| 17 | 15-1255.00 | Web and Digital Interface Designers | $98,090 |
| 18 | 15-1255.01 | Video Game Designers | Market Standard |
| 19 | 15-1299.01 | Web Administrators | Market Standard |
| 20 | 15-1299.02 | GIS Technologists and Technicians | Market Standard |
| 21 | 15-1299.03 | Document Management Specialists | Market Standard |
| 22 | 15-1299.04 | Penetration Testers | Market Standard |
| 23 | 15-1299.05 | Information Security Engineers | Market Standard |
| 24 | 15-1299.06 | Digital Forensics Analysts | Market Standard |
| 25 | 15-1299.07 | Blockchain Engineers | Market Standard |
| 26 | 15-1299.08 | Computer Systems Engineers/Architects | Market Standard |
| 27 | 15-1299.09 | Information Technology Project Managers | Market Standard |

### Mathematical Science Occupations (15-2xxx)
| # | SOC Code | Title | BLS Wage |
|---|---|---|---|
| 28 | 15-2011.00 | Actuaries | $134,990 |
| 29 | 15-2021.00 | Mathematicians | $121,680 |
| 30 | 15-2031.00 | Operations Research Analysts | $91,290 |
| 31 | 15-2041.00 | Statisticians | $103,300 |
| 32 | 15-2041.01 | Biostatisticians | Market Standard |
| 33 | 15-2051.00 | Data Scientists | $112,590 |
| 34 | 15-2051.01 | Business Intelligence Analysts | Market Standard |
| 35 | 15-2051.02 | Clinical Data Managers | Market Standard |
| 36 | 15-2099.01 | Bioinformatics Technicians | Market Standard |

**Excluded (catchall codes — no specific occupation):**
- 15-1299.00 Computer Occupations, All Other
- 15-2099.00 Mathematical Science Occupations, All Other

## "Market Standard" Definition
BLS does not publish separate OES median wage data at the O*NET sub-occupation level
for these roles. They inherit their parent SOC code's wage band. For future automation,
use BLS Public Data API OES series IDs at the parent SOC level.

## BLS API Endpoint for Future Automation
```
https://api.bls.gov/publicAPI/v2/timeseries/data/
Series format: OEUM000000015XXXXXXXX (OES national, all industries)
Example: OEUM000000015125200 = Software Developers (15-1252.00) annual median
```

## Schema Gap (Carry-Forward)
agent_logic and guardrails_and_compliance have no foreign key to registry_metadata.
App-layer join on soc_code inside verification_logic JSONB.
Recommended next sprint: `schema/02_add_soc_fk.sql`
