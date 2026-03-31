# SAL Finance + Legal Cluster — Ingest Notes

## Execution Order
1. `schema/01_create_tables.sql` — create tables (if not already run)
2. `schema/00_enable_rls_and_api.sql` — enable RLS + policies (if not already run)
3. `data/sal_finance_legal_seed_part1.sql` — registry_metadata (59 roles, idempotent ON CONFLICT)
4. `data/sal_finance_legal_seed_part2.sql` — agent_logic roles 1–25 (Finance 13-1xxx primary + 13-2xxx major roles)
5. `data/sal_finance_legal_seed_part3.sql` — agent_logic roles 26–56 (remaining Finance sub-roles + ALL Legal roles)
6. `data/sal_finance_legal_seed_part4.sql` — ALL guardrails_and_compliance (51 Finance + 8 Legal = 59 rows)
> Run parts 2/3/4 ONLY ONCE on a fresh cluster. They have no UNIQUE constraint guard.
> For re-runs, truncate agent_logic and guardrails_and_compliance first.

## Full Role Coverage: 59 Roles

### Finance Cluster — Business & Financial Operations (13-1xxx): 32 roles
| # | SOC Code | Title | BLS Wage |
|---|---|---|---|
| 1 | 13-1011.00 | Agents and Business Managers of Artists, Performers, and Athletes | Market Standard |
| 2 | 13-1021.00 | Buyers and Purchasing Agents, Farm Products | Market Standard |
| 3 | 13-1022.00 | Wholesale and Retail Buyers, Except Farm Products | Market Standard |
| 4 | 13-1023.00 | Purchasing Agents, Except Wholesale, Retail, and Farm Products | Market Standard |
| 5 | 13-1031.00 | Claims Adjusters, Examiners, and Investigators | $76,790 |
| 6 | 13-1032.00 | Insurance Appraisers, Auto Damage | Market Standard |
| 7 | 13-1041.00 | Compliance Officers | $78,420 |
| 8 | 13-1041.01 | Environmental Compliance Inspectors | Market Standard |
| 9 | 13-1041.03 | Equal Opportunity Representatives and Officers | Market Standard |
| 10 | 13-1041.04 | Government Property Inspectors and Investigators | Market Standard |
| 11 | 13-1041.06 | Coroners | Market Standard |
| 12 | 13-1041.07 | Regulatory Affairs Specialists | Market Standard |
| 13 | 13-1041.08 | Customs Brokers | Market Standard |
| 14 | 13-1051.00 | Cost Estimators | $77,064 |
| 15 | 13-1071.00 | Human Resources Specialists | $72,910 |
| 16 | 13-1074.00 | Farm Labor Contractors | Market Standard |
| 17 | 13-1075.00 | Labor Relations Specialists | Market Standard |
| 18 | 13-1081.00 | Logisticians | $80,880 |
| 19 | 13-1081.01 | Logistics Engineers | Market Standard |
| 20 | 13-1081.02 | Logistics Analysts | Market Standard |
| 21 | 13-1082.00 | Project Management Specialists | $100,750 |
| 22 | 13-1111.00 | Management Analysts | $101,190 |
| 23 | 13-1121.00 | Meeting, Convention, and Event Planners | Market Standard |
| 24 | 13-1131.00 | Fundraisers | Market Standard |
| 25 | 13-1141.00 | Compensation, Benefits, and Job Analysis Specialists | $77,020 |
| 26 | 13-1151.00 | Training and Development Specialists | $65,850 |
| 27 | 13-1161.00 | Market Research Analysts and Marketing Specialists | $76,950 |
| 28 | 13-1161.01 | Search Marketing Strategists | Market Standard |
| 29 | 13-1199.04 | Business Continuity Planners | Market Standard |
| 30 | 13-1199.05 | Sustainability Specialists | Market Standard |
| 31 | 13-1199.06 | Online Merchants | Market Standard |
| 32 | 13-1199.07 | Security Management Specialists | Market Standard |

### Finance Cluster — Finance Specialists (13-2xxx): 19 roles
| # | SOC Code | Title | BLS Wage |
|---|---|---|---|
| 33 | 13-2011.00 | Accountants and Auditors | $81,680 |
| 34 | 13-2022.00 | Appraisers of Personal and Business Property | Market Standard |
| 35 | 13-2023.00 | Appraisers and Assessors of Real Estate | Market Standard |
| 36 | 13-2031.00 | Budget Analysts | $87,930 |
| 37 | 13-2041.00 | Credit Analysts | $80,974 |
| 38 | 13-2051.00 | Financial and Investment Analysts | $101,350 |
| 39 | 13-2052.00 | Personal Financial Advisors | $102,140 |
| 40 | 13-2053.00 | Insurance Underwriters | $79,880 |
| 41 | 13-2054.00 | Financial Risk Specialists | $106,000 |
| 42 | 13-2061.00 | Financial Examiners | $90,400 |
| 43 | 13-2071.00 | Credit Counselors | Market Standard |
| 44 | 13-2072.00 | Loan Officers | $74,173 |
| 45 | 13-2081.00 | Tax Examiners and Collectors, and Revenue Agents | $59,740 |
| 46 | 13-2082.00 | Tax Preparers | $50,565 |
| 47 | 13-2099.01 | Financial Quantitative Analysts | Market Standard |
| 48 | 13-2099.04 | Fraud Examiners, Investigators and Analysts | Market Standard |

**Excluded (catchall/no separate BLS occupation):**
- 13-1021.00 listed under Farm Products Buyers (included — has distinct O*NET tasks)
- Sub-codes without independent O*NET task profiles were included at the sub-code level where O*NET provides distinct tasks

### Legal Cluster (23-xxxx): 8 roles
| # | SOC Code | Title | BLS Wage |
|---|---|---|---|
| 49 | 23-1011.00 | Lawyers | $151,160 |
| 50 | 23-1012.00 | Judicial Law Clerks | $69,850 |
| 51 | 23-1021.00 | Administrative Law Judges, Adjudicators, and Hearing Officers | $115,230 |
| 52 | 23-1022.00 | Arbitrators, Mediators, and Conciliators | $67,710 |
| 53 | 23-1023.00 | Judges, Magistrate Judges, and Magistrates | $156,210 |
| 54 | 23-2011.00 | Paralegals and Legal Assistants | $61,010 |
| 55 | 23-2093.00 | Title Examiners, Abstractors, and Searchers | $72,800 |
| 56 | 23-2099.00 | Legal Support Workers, All Other | Market Standard |

## "Market Standard" Definition
BLS does not publish separate OES median wage data at the O*NET sub-occupation level for these roles. They inherit their parent SOC code's wage band. The Finance cluster parent group (13-xxxx) median is $80,920. For future automation, use BLS Public Data API OES series IDs at the parent SOC level.

## BLS API Endpoint for Future Automation
```
https://api.bls.gov/publicAPI/v2/timeseries/data/
Series format: OEUM000000013XXXXXXXX (OES national, all industries, 13-xxxx codes)
Example: OEUM000000013201100 = Accountants and Auditors (13-2011.00) annual median
```

## Key Regulatory Frameworks by Sub-Cluster
- **Financial services (13-2xxx):** SEC, FINRA, CFPB, OCC, FDIC — Investment Advisers Act, Securities Exchange Act, Dodd-Frank
- **Tax roles:** IRC, IRS Circular 230, PCAOB, AICPA standards
- **HR/Labor:** NLRA, FLSA, Title VII, ADA, FMLA
- **Legal cluster (23-xxxx):** ABA Model Rules, state bar rules, APA, USPAP (title), FAA (arbitration)
- **Compliance/Inspection:** EPA, OSHA, EEOC, FAR (government property), FLCRA (farm labor)

## Schema Gap (Carry-Forward from IT Cluster)
agent_logic and guardrails_and_compliance have no foreign key to registry_metadata.
App-layer join on soc_code inside verification_logic JSONB.
Recommended next sprint: `schema/02_add_soc_fk.sql`

## Part File Distribution
| File | Content | Roles |
|---|---|---|
| Part 1 | registry_metadata (idempotent) | All 59 |
| Part 2 | agent_logic — Finance primary roles | 1–25 (13-1011.00 through 13-2099.04 primary) |
| Part 3 | agent_logic — Finance sub-roles + ALL Legal | 26–56 |
| Part 4 | guardrails_and_compliance | All 59 |
