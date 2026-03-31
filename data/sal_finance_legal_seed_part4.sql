-- ============================================================
-- SAL Registry v1.0 — FINANCE (13-xxxx) + LEGAL (23-xxxx) CLUSTERS
-- Part 4 of 4: guardrails_and_compliance — ALL 59 roles
-- Source: O*NET + BLS + CFR/USC regulatory frameworks
-- Ingested: 2026-03-31
-- Run ONCE on a fresh cluster (no UNIQUE guard on guardrails_and_compliance)
-- For re-runs: TRUNCATE guardrails_and_compliance CASCADE first
-- ============================================================

BEGIN;

-- ══════════════════════════════════════════════════════════════
-- FINANCE CLUSTER — 13-1xxx ROLES (Business & Financial Ops)
-- ══════════════════════════════════════════════════════════════

-- 13-1011.00 — Agents and Business Managers of Artists, Performers, and Athletes
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Disclose all conflicts of interest and dual agency relationships to clients in writing',
  'Maintain separate client trust accounts for all collected commissions and receipts',
  'Comply with state talent agency licensing requirements (CA AB5, NY Arts & Cultural Affairs Law)',
  'Never negotiate terms that violate SAG-AFTRA, AFM, or applicable union collective bargaining agreements',
  'Ensure minor performers'' contracts comply with Coogan Law requirements (15% trust account)'
],
'{"soc_code":"13-1011.00","title":"Agents and Business Managers of Artists, Performers, and Athletes","regulatory_bodies":["State talent agency licensing boards","SAG-AFTRA","AFM","NBA/NFL/MLB players associations"],"key_regulations":["California Talent Agencies Act","NY Arts & Cultural Affairs Law §37","Coogan Law (CA Fam. Code §6750)","Sherman Antitrust Act (agency fee limits)"],"verification_checks":["State talent agency license current","Client representation agreement signed","Trust account segregated from operating funds","Union franchise agreement current if applicable","Coogan account established for minor clients"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1021.00 — Buyers and Purchasing Agents, Farm Products
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with USDA Agricultural Marketing Act grading and labeling requirements',
  'Register as commodity trading advisor or merchant if required under Commodity Exchange Act',
  'Maintain accurate weight and measurement records to comply with USDA Weights and Measures standards',
  'Disclose all financial interests in transactions to prevent conflicts of interest per CFTC rules',
  'Comply with country-of-origin labeling (COOL) requirements for covered commodities'
],
'{"soc_code":"13-1021.00","title":"Buyers and Purchasing Agents, Farm Products","regulatory_bodies":["USDA AMS","CFTC","FDA (food safety)","EPA (pesticide residue limits)"],"key_regulations":["Commodity Exchange Act (7 U.S.C. §1 et seq.)","USDA Agricultural Marketing Act","PACA (Perishable Agricultural Commodities Act)","Country of Origin Labeling Act (7 U.S.C. §1638)"],"verification_checks":["PACA license current if applicable","CFTC registration status verified","USDA grade certificates on file","Chain of custody documentation complete","Country-of-origin certificates obtained"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1022.00 — Wholesale and Retail Buyers, Except Farm Products
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with FTC regulations on deceptive advertising and labeling requirements',
  'Ensure supplier compliance with fair labor standards and forced labor prohibition (FLSA, Uyghur Forced Labor Prevention Act)',
  'Maintain conflict of interest policy — disclose and recuse from supplier decisions involving personal financial interest',
  'Verify product safety compliance with CPSC standards before purchase commitments',
  'Document all supplier due diligence to support ESG and supply chain transparency requirements'
],
'{"soc_code":"13-1022.00","title":"Wholesale and Retail Buyers, Except Farm Products","regulatory_bodies":["FTC","CPSC","CBP (import compliance)","DOL (FLSA supplier audits)"],"key_regulations":["Uyghur Forced Labor Prevention Act (UFLPA)","Consumer Product Safety Act","FTC Act §5 (deceptive acts)","California Transparency in Supply Chains Act","Modern Slavery Act (UK — for multinationals)"],"verification_checks":["Supplier conflict of interest form on file","CPSC product safety certificates reviewed","UFLPA entity list checked for suppliers","Supplier code of conduct signed","Import compliance documentation verified"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1023.00 — Purchasing Agents, Except Wholesale, Retail, and Farm Products
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with FAR/DFARS procurement regulations for government contract purchasing',
  'Avoid bid rigging, price fixing, or other anti-competitive procurement practices (Sherman Act)',
  'Declare and recuse from all procurement decisions involving personal financial conflicts of interest',
  'Maintain competitive bidding requirements and sole-source justification documentation',
  'Ensure small business subcontracting goals are met on applicable federal contracts'
],
'{"soc_code":"13-1023.00","title":"Purchasing Agents, Except Wholesale, Retail, and Farm Products","regulatory_bodies":["FAR Council","SBA","DOJ Antitrust Division","Inspector General (federal agencies)"],"key_regulations":["Federal Acquisition Regulation (FAR)","DFARS","Competition in Contracting Act","Sherman Antitrust Act","False Claims Act (31 U.S.C. §3729)"],"verification_checks":["SAM.gov vendor registration verified","Conflict of interest certification obtained","Competitive bid documentation complete","Sole-source justification approved if applicable","Small business goals documented"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1031.00 — Claims Adjusters, Examiners, and Investigators
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain current state adjuster license in all states of claims activity',
  'Comply with state Unfair Claims Settlement Practices Act requirements for timely acknowledgment, investigation, and settlement',
  'Never engage in bad faith claims handling — document all communications and decision rationale',
  'Protect policyholder personal information per state insurance privacy regulations and Gramm-Leach-Bliley Act',
  'Report suspected insurance fraud to state Insurance Fraud Bureau per mandatory reporting statutes'
],
'{"soc_code":"13-1031.00","title":"Claims Adjusters, Examiners, and Investigators","regulatory_bodies":["State Insurance Departments","NAIC","State Insurance Fraud Bureaus"],"key_regulations":["State Unfair Claims Settlement Practices Acts (NAIC Model Law)","Gramm-Leach-Bliley Act (privacy)","State adjuster licensing statutes","McCarran-Ferguson Act"],"verification_checks":["Active adjuster license in all applicable states","Claim acknowledgment within statutory timeframe (typically 10-15 days)","Fraud indicators documented and reported","Privacy notice sent to claimant","Claims file documentation audit-ready"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1032.00 — Insurance Appraisers, Auto Damage
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain state auto damage appraiser license where required',
  'Comply with state total loss threshold regulations for salvage value and ACV determination',
  'Use only certified and approved estimating systems (CCC, Mitchell, Audatex) for claims settlements',
  'Do not accept gifts, referral fees, or kickbacks from repair shops — maintain independence',
  'Document all appraisal decisions to withstand state insurance department audit'
],
'{"soc_code":"13-1032.00","title":"Insurance Appraisers, Auto Damage","regulatory_bodies":["State Insurance Departments","State DMV (salvage title)","NAIC"],"key_regulations":["State auto damage appraiser licensing statutes","State total loss threshold regulations","NAIC Auto Physical Damage Claim Guidelines","Gramm-Leach-Bliley Act (privacy)"],"verification_checks":["Appraiser license current and in-state valid","Estimating system version current and approved","Total loss formula documented per state law","No referral fee arrangements with repair shops","Claimant privacy rights notice delivered"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1041.00 — Compliance Officers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Report identified compliance violations to senior management and board as required by applicable law and internal policy',
  'Protect whistleblowers per Dodd-Frank Act, SOX Section 806, and applicable state statutes',
  'Maintain independence from business units being monitored to avoid conflicts of interest',
  'Document all compliance findings, risk assessments, and corrective actions in auditable format',
  'Stay current on regulatory changes through continuous education and agency guidance monitoring'
],
'{"soc_code":"13-1041.00","title":"Compliance Officers","regulatory_bodies":["SEC","FINRA","OCC","CFPB","DOL","EPA","HHS OIG (healthcare)"],"key_regulations":["Dodd-Frank Act (whistleblower protection §922)","Sarbanes-Oxley Act §301, §806","Bank Secrecy Act / AML requirements","DOJ FCPA (Foreign Corrupt Practices Act)","HIPAA (healthcare compliance)"],"verification_checks":["Compliance program documented and board-approved","Hotline and non-retaliation policy active","Risk assessment updated annually","Training completion rates at 100%","Regulatory examination findings resolved"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1041.01 — Environmental Compliance Inspectors
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain appropriate federal and state inspector credentials and training certifications',
  'Follow chain-of-custody protocols for all environmental samples — deviation invalidates enforcement action',
  'Protect inspector safety with required PPE for hazardous environments per OSHA 1910.120',
  'Issue inspection findings only within statutory authority — avoid inspector bias per EPA Inspector Standards',
  'Maintain confidentiality of enforcement-sensitive information pending formal agency action'
],
'{"soc_code":"13-1041.01","title":"Environmental Compliance Inspectors","regulatory_bodies":["EPA","State environmental agencies","Army Corps of Engineers","OSHA (inspector safety)"],"key_regulations":["Clean Air Act (42 U.S.C. §7401)","Clean Water Act (33 U.S.C. §1251)","RCRA (42 U.S.C. §6901)","CERCLA (Superfund)","OSHA HAZWOPER (29 CFR §1910.120)"],"verification_checks":["Inspector credentials current (EPA/State certified)","Chain-of-custody forms completed for all samples","PPE requirements met for site hazard level","Inspection authority documented in statute/regulation","Enforcement-sensitive information handling protocol followed"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1041.03 — Equal Opportunity Representatives and Officers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Protect complainant confidentiality to the maximum extent permitted by law',
  'Conduct impartial investigations — document evidence without predetermination',
  'Comply with EEOC charge intake and processing timelines per 29 CFR Part 1601',
  'Do not retaliate against complainants or witnesses — retaliation is independently unlawful',
  'Apply proper legal standards for each basis of discrimination (disparate treatment vs disparate impact)'
],
'{"soc_code":"13-1041.03","title":"Equal Opportunity Representatives and Officers","regulatory_bodies":["EEOC","OFCCP","DOJ Civil Rights Division","State fair employment agencies"],"key_regulations":["Title VII (42 U.S.C. §2000e)","ADA (42 U.S.C. §12101)","ADEA (29 U.S.C. §621)","Executive Order 11246","Section 503 of Rehabilitation Act"],"verification_checks":["Charge filed within statute of limitations (180/300 days)","Respondent notified within 10 days of charge","Confidentiality notice provided to parties","Investigation timeframe meets agency standards","Legal standard correctly applied to each discrimination basis"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1041.04 — Government Property Inspectors and Investigators
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Conduct inspections per FAR 45.105 and DCSA/DCMA inspection procedures only',
  'Maintain inspector independence — never approve contractor property management systems with known uncorrected deficiencies',
  'Protect controlled unclassified information (CUI) in property records per DoDI 5200.48',
  'Report fraud, waste, and abuse findings to agency IG per applicable reporting requirements',
  'Never accept gifts from contractors under inspection per Standards of Ethical Conduct (5 CFR Part 2635)'
],
'{"soc_code":"13-1041.04","title":"Government Property Inspectors and Investigators","regulatory_bodies":["DCMA","DCSA","DLA","Agency IGs","FAR Council"],"key_regulations":["FAR Part 45 (Government Property)","DFARS 252.245","DoDI 5000.64 (Accountability of DoD Property)","5 CFR Part 2635 (Ethics)","Inspector General Act of 1978"],"verification_checks":["Inspector credentials/warrant current","FAR 45 inspection checklist completed","CUI handling procedures followed","IG referral made for fraud findings","No gift acceptance from inspected contractor"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1041.06 — Coroners
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Exercise jurisdiction only over deaths within statutory coroner/ME authority (violent, sudden, unexplained, unattended)',
  'Maintain chain of custody for all biological samples and evidence from scene to laboratory to court',
  'Comply with next-of-kin notification requirements per state vital statistics law',
  'Ensure death certificates are accurate and timely — errors create downstream legal and insurance complications',
  'Protect decedent privacy and family dignity per applicable state laws and professional standards'
],
'{"soc_code":"13-1041.06","title":"Coroners","regulatory_bodies":["State vital statistics agencies","State medical examiner boards","CDC NVSS","State forensic science commissions"],"key_regulations":["State Coroner/ME statutes","EDRS regulations (state vital records)","HIPAA (applies to protected health information of decedents for 50 years)","FBI NIBRS (violent death reporting)","CDC NVDRS (National Violent Death Reporting System)"],"verification_checks":["Coroner/ME jurisdiction confirmed before accepting case","Chain of custody documented from scene to lab","Death certificate completed within statutory timeframe","Next of kin notified per state statute","Criminal referral made when homicide indicated"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1041.07 — Regulatory Affairs Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Ensure all regulatory submissions are accurate and complete — false statements to FDA/EPA/other agencies are federal crimes',
  'Maintain 21 CFR Part 11 electronic records and signatures compliance for FDA submissions',
  'Track and respond to all agency queries within stated regulatory timelines',
  'Protect proprietary regulatory data under trade secret protections and data exclusivity provisions',
  'Report adverse events, safety signals, and field corrections to applicable agencies per mandatory reporting timelines'
],
'{"soc_code":"13-1041.07","title":"Regulatory Affairs Specialists","regulatory_bodies":["FDA","EPA","EMA (EU)","Health Canada","ICH"],"key_regulations":["FD&C Act (21 U.S.C. §301 et seq.)","21 CFR Parts 11, 314, 601, 820","ICH Q10 Pharmaceutical Quality System","EPA TSCA","FTC Act (advertising claims)"],"verification_checks":["Submission accuracy verified by second reviewer","21 CFR Part 11 system validation current","Adverse event reporting system active and within timelines","Data exclusivity and trade secret protections documented","Regulatory dossier version control maintained"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1041.08 — Customs Brokers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain active CBP customs broker license (19 CFR Part 111) with triennial reporting current',
  'Exercise reasonable care in HTS classification — incorrect classification is a CBP violation subject to penalties',
  'Comply with C-TPAT security standards if participating in trusted trader program',
  'Never submit false or fraudulent information to CBP — violations subject to 19 U.S.C. §1592 penalties',
  'Maintain importer records for 5 years per CBP 19 CFR Part 163 recordkeeping requirements'
],
'{"soc_code":"13-1041.08","title":"Customs Brokers","regulatory_bodies":["CBP","Commerce BIS (export controls)","OFAC","FDA (regulated imports)","USDA APHIS"],"key_regulations":["19 CFR Part 111 (Customs Brokers)","19 U.S.C. §1592 (Penalties for False Statements)","19 CFR Part 163 (Recordkeeping)","OFAC sanctions regulations","BIS EAR (Export Administration Regulations)"],"verification_checks":["CBP broker license active and triennial report filed","HTS classification supported by binding ruling or internal analysis","OFAC sanctions list checked for each transaction","ISF (10+2) filed timely for ocean imports","5-year records maintained per 19 CFR Part 163"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1051.00 — Cost Estimators
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Disclose all assumptions and uncertainties in cost estimates — overconfident estimates expose firms to contract losses',
  'Comply with Truth in Negotiations Act (TINA) for certified cost or pricing data on government contracts over threshold',
  'Maintain estimate documentation to support audit by DCAA or other oversight bodies',
  'Apply correct burden rates and indirect cost pools per CAS (Cost Accounting Standards) when applicable',
  'Never certify as accurate cost or pricing data that you know to be inaccurate — criminal penalties apply'
],
'{"soc_code":"13-1051.00","title":"Cost Estimators","regulatory_bodies":["DCAA","DCMA","FAR Council","AACE International"],"key_regulations":["Truth in Negotiations Act/TINA (10 U.S.C. §2306a)","Cost Accounting Standards (48 CFR Part 9903)","FAR Part 15.403 (Cost or Pricing Data)","False Claims Act (31 U.S.C. §3729)"],"verification_checks":["TINA certification threshold check ($2M+ contracts)","Estimate basis of estimate (BOE) documented","DCAA-adequate accounting system confirmed","CAS disclosure statement current","Risk and uncertainty ranges documented"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1071.00 — Human Resources Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with EEOC regulations — all hiring decisions must be based on bona fide occupational qualifications',
  'Maintain I-9 Employment Eligibility Verification forms for all employees within required timeframes',
  'Protect employee medical and genetic information separate from personnel files per ADA and GINA',
  'Comply with WARN Act notice requirements for mass layoffs and plant closings',
  'Ensure all job postings are OFCCP-compliant for federal contractors — no discriminatory language'
],
'{"soc_code":"13-1071.00","title":"Human Resources Specialists","regulatory_bodies":["EEOC","DOL WHD","OFCCP","DHS USCIS (I-9)","NLRB"],"key_regulations":["Title VII (42 U.S.C. §2000e)","ADA §102","GINA (29 CFR Part 1635)","WARN Act (29 U.S.C. §2101)","IRCA (I-9 Requirements)"],"verification_checks":["I-9 completed within 3 business days of hire","Medical records stored separately from personnel file","Interview questions audited for EEOC compliance","WARN Act notice lead time calculated correctly","OFCCP AAP current for federal contractors"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1074.00 — Farm Labor Contractors
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain valid FLCRA (Farm Labor Contractor Registration Act) registration with DOL at all times',
  'Provide all required written disclosures to workers before recruitment — failure subjects to civil penalties up to $1,000 per violation',
  'Comply with FLSA minimum wage and overtime requirements for agricultural workers',
  'Ensure transportation vehicles meet FMCSA safety standards and drivers hold CDL if required',
  'Comply with Migrant and Seasonal Agricultural Worker Protection Act (MSPA) housing and safety standards'
],
'{"soc_code":"13-1074.00","title":"Farm Labor Contractors","regulatory_bodies":["DOL WHD","FMCSA","OSHA (field sanitation)","State agricultural labor departments"],"key_regulations":["Migrant and Seasonal Agricultural Worker Protection Act (MSPA) (29 U.S.C. §1801)","FLCRA (29 U.S.C. §1811)","FLSA §13 (agricultural exceptions)","FMCSA 49 CFR Part 391 (driver qualifications)","OSHA 29 CFR §1928.110 (field sanitation)"],"verification_checks":["FLCRA registration certificate valid and on person during recruiting","Written worker disclosure provided before work begins","FMCSA vehicle safety inspection current","CDL verified for drivers of vehicles with 16+ passengers","Housing certified by applicable state agency if provided"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1075.00 — Labor Relations Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with NLRA good faith bargaining obligations — surface bargaining is an unfair labor practice',
  'Never retaliate against employees exercising Section 7 protected concerted activity rights',
  'Maintain confidentiality of grievance and arbitration proceedings as required by CBA',
  'Ensure management negotiators do not make unilateral changes to mandatory subjects of bargaining without union agreement',
  'File LMRDA reports as required for employer expenditures on union-related activities'
],
'{"soc_code":"13-1075.00","title":"Labor Relations Specialists","regulatory_bodies":["NLRB","FMCS (Federal Mediation and Conciliation Service)","BLS (LMRDA)","State labor relations boards"],"key_regulations":["National Labor Relations Act (29 U.S.C. §151)","LMRDA (29 U.S.C. §401)","Railway Labor Act (transportation sectors)","FMCS notice requirements (29 U.S.C. §158(d))"],"verification_checks":["FMCS 30-day notice filed before contract expiration","Good faith bargaining documented in session minutes","No unilateral change to mandatory bargaining subjects","LMRDA Form LM-10 filed if required","Grievance response within contractual timeframes"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1081.00 — Logisticians
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Ensure all hazardous materials shipments comply with DOT 49 CFR Parts 100-185 and IATA DGR for air',
  'Comply with CBP import/export regulations and maintain export licenses for controlled items (EAR/ITAR)',
  'Verify carrier operating authority (MC number) and insurance compliance before tendering freight',
  'Maintain supply chain security standards per C-TPAT or equivalent for government and multinational supply chains',
  'Track and document supply chain GHG emissions per Scope 3 requirements for applicable reporting frameworks'
],
'{"soc_code":"13-1081.00","title":"Logisticians","regulatory_bodies":["DOT PHMSA","CBP","BIS","FMCSA","TSA (air cargo)"],"key_regulations":["49 CFR Parts 100-185 (HazMat)","IATA Dangerous Goods Regulations","EAR (15 CFR Parts 730-774)","ITAR (22 CFR Parts 120-130)","FMCSA carrier regulations (49 CFR Part 390)"],"verification_checks":["HazMat shipping papers and labels correct per 49 CFR","Carrier MC number and insurance verified in SAFER","Export license obtained for EAR/ITAR controlled items","C-TPAT validation current if enrolled","Scope 3 logistics emissions data collected and reported"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1081.01 — Logistics Engineers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Validate logistics system designs against safety-critical requirements before implementation',
  'Ensure warehouse automation designs comply with OSHA machine guarding and robotics safety standards',
  'Document engineering assumptions and model limitations for audit and liability protection',
  'Obtain PE licensure if designs are subject to engineering certification requirements',
  'Apply human factors engineering principles to warehouse and logistics facility designs to prevent worker injury'
],
'{"soc_code":"13-1081.01","title":"Logistics Engineers","regulatory_bodies":["OSHA","State PE licensing boards","ISO (safety standards)","ANSI MH (material handling standards)"],"key_regulations":["OSHA 29 CFR §1910.217 (mechanical power presses)","OSHA 29 CFR §1910.212 (machine guarding)","ANSI/RIA R15.06 (industrial robot safety)","ANSI MH16.3 (AS/RS systems)","State PE Practice Acts"],"verification_checks":["Safety risk assessment completed for automation designs","OSHA machine guarding review done before commissioning","Engineering documentation sufficient for PE certification if required","Failure mode and effects analysis (FMEA) completed","Worker ergonomics assessment incorporated into facility design"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1081.02 — Logistics Analysts
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Protect proprietary supply chain data per confidentiality agreements and data governance policy',
  'Validate data quality before presenting analysis — incorrect logistics data can cause costly operational decisions',
  'Disclose model assumptions and limitations clearly in all analytical reports',
  'Comply with carrier data use restrictions in TMS contracts — don''t share carrier rates without authorization',
  'Ensure analytics recommendations consider regulatory constraints (HOS rules, HazMat routing, weight limits)'
],
'{"soc_code":"13-1081.02","title":"Logistics Analysts","regulatory_bodies":["FMCSA","DOT","State transportation departments"],"key_regulations":["FMCSA Hours of Service (49 CFR Part 395)","DOT HazMat routing regulations (49 CFR §397)","State vehicle weight limit regulations","GDPR/CCPA (customer data in logistics systems)"],"verification_checks":["Data governance approval for external data sharing","Analytical model assumptions documented","HOS rule constraints factored into routing recommendations","HazMat routing restrictions applied","Report quality review by second analyst completed"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1082.00 — Project Management Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain PMI PMP or equivalent certification as required by client or employer standards',
  'Comply with project governance requirements including change control, risk management, and earned value reporting',
  'Protect project information classified as proprietary or government sensitive per applicable agreements',
  'Ensure all project changes follow formal change control process — undocumented scope changes create liability',
  'Comply with FAR 34.2 Earned Value Management requirements on applicable government contracts'
],
'{"soc_code":"13-1082.00","title":"Project Management Specialists","regulatory_bodies":["PMI","CMMI Institute","FAR Council (government contracts)","ISO"],"key_regulations":["PMBOK Guide (PMI Standard)","ANSI/EIA-748 (Earned Value Management)","FAR Part 34 (Major System Acquisition)","ISO 21500 (Project Management Guidance)"],"verification_checks":["PMP or equivalent certification current","Change control log maintained for all scope changes","Risk register updated throughout project lifecycle","Earned value metrics reported per contractual requirements","Lessons learned documented at project close"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1111.00 — Management Analysts
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Disclose all conflicts of interest before accepting or continuing consulting engagements',
  'Protect client confidential information per engagement terms — do not share across engagements',
  'Base recommendations on evidence and sound methodology — do not recommend predetermined outcomes',
  'Comply with applicable professional standards (IIA, IMC, government auditing standards) for audit-related work',
  'Ensure deliverables are not used to facilitate illegal activity — cease engagement if evidence of fraud emerges'
],
'{"soc_code":"13-1111.00","title":"Management Analysts","regulatory_bodies":["IMC USA","IIA","GAO (government contracts)","SEC (publicly regulated clients)"],"key_regulations":["Generally Accepted Government Auditing Standards (GAGAS)","IIA Professional Standards","IMC Code of Ethics","FAR Part 9.5 (Organizational Conflicts of Interest)"],"verification_checks":["Conflict of interest check completed before engagement","Engagement letter executed with scope and confidentiality terms","Evidence of fraud or illegality escalated to senior management","Recommendations supported by documented analysis","Client data destroyed or returned per engagement terms"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1121.00 — Meeting, Convention, and Event Planners
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with venue contract force majeure provisions and event insurance requirements',
  'Ensure ADA accessibility compliance for all events open to the public or employees',
  'Obtain all required permits — fire marshal occupancy, food service, noise, and alcohol (ABC license)',
  'Protect attendee personal data per GDPR/CCPA requirements in event registration platforms',
  'Conduct event safety risk assessment and maintain emergency response plan for all events'
],
'{"soc_code":"13-1121.00","title":"Meeting, Convention, and Event Planners","regulatory_bodies":["State ABC boards","Local fire marshal","ADA enforcement (DOJ)","State health departments (food service)"],"key_regulations":["ADA Title III (public accommodations)","State fire codes (NFPA 101)","State alcohol beverage control laws","GDPR/CCPA (attendee data)","USDA/FDA food service regulations"],"verification_checks":["ADA accessibility checklist completed for venue","Alcohol service permit obtained and posted","Fire marshal occupancy certification obtained","Attendee data privacy notice in registration","Emergency response plan distributed to event staff"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1131.00 — Fundraisers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with state charitable solicitation registration requirements in all states where donors are solicited',
  'Disclose all material information to donors including how funds will be used and organization financial status',
  'Comply with IRS quid pro quo disclosure rules for gifts where donors receive goods or services',
  'Honor donor restricted gift designations — redirect of restricted funds without consent is misappropriation',
  'Comply with CAN-SPAM Act and state email marketing laws for digital fundraising communications'
],
'{"soc_code":"13-1131.00","title":"Fundraisers","regulatory_bodies":["IRS (Form 990, charitable status)","State attorneys general (charitable solicitation)","FTC","AFP (professional standards)"],"key_regulations":["IRC §501(c)(3) (tax-exempt status)","State Charitable Solicitation Acts (all 50 states)","IRS Rev. Proc. 90-12 (quid pro quo)","CAN-SPAM Act (15 U.S.C. §7701)","AFP Code of Ethical Standards"],"verification_checks":["Charitable solicitation registration current in all solicitation states","Form 990 filed timely and accurately","Quid pro quo acknowledgments sent for gifts with donor benefits","Restricted funds tracked separately in accounting system","CAN-SPAM opt-out honored within 10 business days"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1141.00 — Compensation, Benefits, and Job Analysis Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Ensure compensation programs comply with FLSA minimum wage, overtime, and exempt classification requirements',
  'Maintain pay equity compliance — analyze and remediate unexplained pay gaps by gender, race, and protected class',
  'Protect employee compensation data as confidential — NLRA protects employees discussing wages with coworkers',
  'Comply with ACA affordability and minimum value requirements for employer-sponsored health benefits',
  'Ensure executive compensation disclosures are accurate in proxy statements per SEC rules'
],
'{"soc_code":"13-1141.00","title":"Compensation, Benefits, and Job Analysis Specialists","regulatory_bodies":["DOL WHD (FLSA)","EEOC (pay equity)","IRS (benefits tax treatment)","SEC (executive comp disclosure)","DOL EBSA (ERISA)"],"key_regulations":["FLSA (29 U.S.C. §201) — exemption classification","Equal Pay Act (29 U.S.C. §206(d))","ACA §4980H (employer mandate)","ERISA (29 U.S.C. §1001)","SEC Reg. S-K Item 402 (executive compensation)"],"verification_checks":["FLSA exemption analysis documented for each exempt position","Pay equity analysis conducted annually","NLRA right to discuss wages not infringed by pay confidentiality policy","ACA affordability test calculated for each benefit plan option","Pay ratio disclosure accurate per SEC Item 402(u)"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1151.00 — Training and Development Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Ensure all mandatory training programs (OSHA, harassment, security) meet regulatory minimum requirements',
  'Protect training participant personal data per GDPR/CCPA — minimize collection and secure storage',
  'Comply with copyright law when using third-party training content — obtain licenses for all reproduced materials',
  'Ensure training accessibility compliance for employees with disabilities per ADA Section 508',
  'Maintain training completion records for regulatory audit purposes — typically 3-5 year retention'
],
'{"soc_code":"13-1151.00","title":"Training and Development Specialists","regulatory_bodies":["OSHA (mandatory safety training)","EEOC (harassment training)","ATD (professional standards)","ADA enforcement (Section 508)"],"key_regulations":["OSHA 29 CFR (specific training requirements by hazard)","Title VII / EEOC harassment training guidance","Section 508 (Federal) / WCAG 2.1 (ADA accessibility)","Copyright Act (17 U.S.C.) — licensed training content","GDPR/CCPA (participant personal data)"],"verification_checks":["OSHA-required training completed within mandated timeframes","Harassment training meets state-specific requirements (CA, NY, IL)","Copyright license obtained for all third-party content","Training accessibility reviewed for ADA compliance","Completion records retained per regulatory requirement"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1161.00 — Market Research Analysts and Marketing Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with FTC endorsement and testimonial guidelines — all paid endorsements must be clearly disclosed',
  'Protect consumer research data per GDPR, CCPA, and applicable state privacy laws',
  'Comply with CAN-SPAM Act and TCPA for email and SMS marketing campaigns',
  'Obtain proper IRB approval for research studies involving human subjects',
  'Ensure all marketing claims are substantiated — unsubstantiated claims violate FTC Act §5'
],
'{"soc_code":"13-1161.00","title":"Market Research Analysts and Marketing Specialists","regulatory_bodies":["FTC","FCC (TCPA)","State AGs (privacy)","IRB (research ethics)"],"key_regulations":["FTC Act §5 (unfair or deceptive acts)","FTC Endorsement Guides (16 CFR Part 255)","CAN-SPAM Act","TCPA (47 U.S.C. §227)","GDPR / CCPA"],"verification_checks":["Paid endorsements disclosed per FTC guidelines","Marketing claims backed by documented evidence","TCPA prior express written consent obtained for SMS","Research participant consent and IRB approval on file","Privacy policy updated and data handling compliant"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1161.01 — Search Marketing Strategists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with Google Ads and Microsoft Advertising policies — prohibited content, restricted industries, and trademark use',
  'Ensure paid search ads clearly disclose material connections and are not deceptive per FTC guidelines',
  'Protect consumer data collected through search campaigns per GDPR/CCPA — implement proper consent mechanisms',
  'Comply with COPPA if search campaigns target or attract minors',
  'Do not use unauthorized competitor trademarks in ad copy per Lanham Act — keyword bidding on competitor trademarks is permitted but use in ad text requires care'
],
'{"soc_code":"13-1161.01","title":"Search Marketing Strategists","regulatory_bodies":["FTC","Google (ad policies)","Microsoft Advertising","FCC (regulated industries)"],"key_regulations":["FTC Act §5 (deceptive advertising)","FTC Endorsement Guides","COPPA (15 U.S.C. §6501) — under-13 audiences","Lanham Act §43(a) (trademark in ad copy)","GDPR / CCPA (tracking and remarketing)"],"verification_checks":["Platform ad policy compliance review completed","Material connections disclosed in sponsored content","COPPA compliance verified if audience includes minors","Trademark use in ad copy reviewed by legal","Consent management platform deployed for EU/CA users"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1199.04 — Business Continuity Planners
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with financial services BCP regulatory requirements (FFIEC, SEC Rule 17a-4, FINRA Rule 4370)',
  'Ensure BCP documentation is classified appropriately — detailed plans may contain sensitive infrastructure information',
  'Test BCP at minimum annually per ISO 22301 and regulatory requirements — untested plans are insufficient',
  'Maintain BCP contact lists with current information — outdated contacts render plans ineffective',
  'Coordinate BCP with third-party vendor resilience — concentration risk with critical vendors must be assessed'
],
'{"soc_code":"13-1199.04","title":"Business Continuity Planners","regulatory_bodies":["FFIEC (banking)","SEC","FINRA","FEMA (government)","ISO (standards)"],"key_regulations":["FFIEC BCP Booklet","SEC Rule 17a-4 (records preservation)","FINRA Rule 4370 (BD business continuity)","ISO 22301 (Business Continuity Management)","NIST SP 800-34 (IT contingency planning)"],"verification_checks":["Annual BCP test completed and documented","Critical vendor resilience assessments on file","BCP executive approval obtained","Employee contact information current in plan","Recovery time objectives validated through testing"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1199.05 — Sustainability Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with SEC climate disclosure rules for public companies — material climate risks must be disclosed',
  'Ensure GHG emissions data is verified by accredited third party before external publication',
  'Avoid greenwashing — marketing claims about environmental performance must be substantiated per FTC Green Guides',
  'Comply with EU CSRD (Corporate Sustainability Reporting Directive) for companies with EU operations',
  'Ensure supply chain emissions (Scope 3) data collection from suppliers complies with CDP and GHG Protocol standards'
],
'{"soc_code":"13-1199.05","title":"Sustainability Specialists","regulatory_bodies":["SEC (ESG disclosure)","EPA (GHG reporting)","FTC (green claims)","EU ESMA (CSRD)","CDP"],"key_regulations":["SEC Climate Disclosure Rule (2024)","EPA 40 CFR Part 98 (mandatory GHG reporting)","FTC Green Guides (16 CFR Part 260)","EU CSRD (Directive 2022/2464)","GHG Protocol Corporate Standard"],"verification_checks":["GHG inventory third-party verified","SEC climate disclosures reviewed by legal and audit committee","FTC Green Guides substantiation on file for all environmental claims","CSRD readiness assessment complete for EU subsidiaries","CDP questionnaire data complete and submitted by deadline"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1199.06 — Online Merchants
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with FTC Mail or Telephone Order Rule — ship within stated timeframe or provide option to cancel',
  'Collect and remit sales tax in all nexus states per South Dakota v. Wayfair (2018)',
  'Comply with COPPA if website collects information from children under 13',
  'Ensure PCI DSS compliance for all payment card processing — annual assessment required',
  'Comply with platform-specific seller policies (Amazon, eBay) — violations result in account suspension'
],
'{"soc_code":"13-1199.06","title":"Online Merchants","regulatory_bodies":["FTC","IRS","State tax authorities","PCI SSC","CFPB"],"key_regulations":["FTC Mail or Telephone Order Rule (16 CFR Part 435)","South Dakota v. Wayfair (sales tax nexus)","COPPA (15 U.S.C. §6501)","PCI DSS v4.0","CCPA / GDPR (consumer data)"],"verification_checks":["PCI DSS compliance assessment current","Sales tax collected and remitted in all nexus states","FTC shipping timeline promises honored","COPPA parental consent mechanism active if applicable","Return policy clearly disclosed before purchase"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-1199.07 — Security Management Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with state private security licensing requirements for all contract security personnel',
  'Ensure use-of-force policies comply with applicable laws and are proportionate to threat level',
  'Maintain surveillance and access control systems in compliance with state wiretapping and privacy laws',
  'Report crimes discovered during security operations to law enforcement — obstruction of justice risk if suppressed',
  'Comply with OSHA workplace violence prevention standards for high-risk facility types'
],
'{"soc_code":"13-1199.07","title":"Security Management Specialists","regulatory_bodies":["State security licensing boards","OSHA","Local law enforcement","DHS (critical infrastructure)"],"key_regulations":["State Private Security Acts (license requirements)","OSHA 29 CFR §1910 (workplace safety)","State wiretapping and surveillance laws","ASIS International standards (PSC.1, ASIS/ANSI standards)","18 U.S.C. §1510 (obstruction of criminal investigations)"],"verification_checks":["Security guard licenses current in all applicable states","Use-of-force policy reviewed by legal counsel","CCTV signage posted per state notification requirements","Incident report submitted to law enforcement for criminal conduct","OSHA workplace violence prevention assessment completed"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- ══════════════════════════════════════════════════════════════
-- FINANCE 13-2xxx GUARDRAILS
-- ══════════════════════════════════════════════════════════════

-- 13-2011.00 — Accountants and Auditors
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain CPA license in good standing with applicable state board — CPE requirements must be met annually',
  'Comply with AICPA Code of Professional Conduct — independence rules apply to audit clients',
  'Report material weaknesses and significant deficiencies in internal controls per PCAOB AS 2201',
  'Comply with SOX Section 302 and 906 CEO/CFO certification requirements for public company financial statements',
  'Protect client financial data per state accountant confidentiality statutes and engagement agreements'
],
'{"soc_code":"13-2011.00","title":"Accountants and Auditors","regulatory_bodies":["PCAOB","AICPA","State CPA licensing boards","SEC","IRS"],"key_regulations":["Sarbanes-Oxley Act §301, §302, §404, §906","PCAOB Auditing Standards","AICPA Code of Professional Conduct","IRC (tax compliance)","GAAP (FASB ASC)"],"verification_checks":["CPA license current and CPE hours met","Independence confirmed for all audit clients (AICPA Independence Rules)","Engagement quality review completed for public company audits","Going concern assessment documented","Workpapers retained 7 years per SOX and PCAOB"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2022.00 — Appraisers of Personal and Business Property
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain ASA, AAA, or equivalent professional appraisal designation and comply with USPAP',
  'Include required USPAP certification statement in all written appraisals',
  'Comply with IRS qualified appraisal requirements for charitable contribution appraisals over $5,000',
  'Do not accept contingency fees based on appraised value — prohibited by USPAP Ethics Rule',
  'Maintain competency in property type being appraised — do not accept assignments outside area of expertise'
],
'{"soc_code":"13-2022.00","title":"Appraisers of Personal and Business Property","regulatory_bodies":["IRS","ASA","AAA","State appraisal licensing boards (personal property varies by state)"],"key_regulations":["USPAP (Uniform Standards of Professional Appraisal Practice)","IRC §170(f)(11) (qualified appraisal for charitable deductions)","IRS Form 8283 (noncash charitable contribution)","IRS Revenue Procedure for appraisal standards"],"verification_checks":["USPAP certification included in written report","IRS qualified appraisal requirements met for charitable deductions","Contingency fee arrangement absent","Competency qualification demonstrated for property type","Appraiser signature and designation on final report"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2023.00 — Appraisers and Assessors of Real Estate
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain state certified appraiser license (Certified Residential or Certified General) — required for all federally related transactions',
  'Comply with USPAP and FIRREA appraisal independence requirements',
  'Comply with Appraiser Independence Requirements (AIR) — lenders cannot influence appraised value',
  'Report discriminatory requests (steer toward or away from neighborhoods based on race) to state board and HUD',
  'Complete approved continuing education including 7-hour USPAP update every cycle'
],
'{"soc_code":"13-2023.00","title":"Appraisers and Assessors of Real Estate","regulatory_bodies":["State appraiser licensing boards","ASC (Appraisal Subcommittee)","The Appraisal Foundation","HUD","CFPB"],"key_regulations":["FIRREA (Financial Institutions Reform, Recovery, and Enforcement Act)","USPAP (Uniform Standards of Professional Appraisal Practice)","Appraiser Independence Requirements (AIR)","Fair Housing Act (discriminatory appraisals)","Dodd-Frank AMC regulations (12 CFR Part 1222)"],"verification_checks":["State certified appraiser license active","USPAP certification and limiting conditions signed","AIR compliance — no lender pressure documented","Comparable selection non-discriminatory and documented","7-hour USPAP update completed within regulatory cycle"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2031.00 — Budget Analysts
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with OMB Circular A-11 for federal budget preparation and submission requirements',
  'Ensure budget justifications are accurate and complete — false statements in budget submissions to Congress are prohibited',
  'Comply with Anti-Deficiency Act — no obligations or expenditures exceeding appropriated amounts',
  'Maintain budget documentation for Inspector General review and GAO audits',
  'Protect budget data classified as deliberative process or pre-decisional from premature disclosure'
],
'{"soc_code":"13-2031.00","title":"Budget Analysts","regulatory_bodies":["OMB","GAO","Congressional Budget Office","Agency IGs","Treasury"],"key_regulations":["Anti-Deficiency Act (31 U.S.C. §1341)","OMB Circular A-11 (federal budget)","Congressional Budget Act of 1974","GAAP (GASB for government)","Federal Appropriations Law (GAO Red Book)"],"verification_checks":["Obligations within appropriated authority","Budget justifications verified for accuracy","Anti-Deficiency Act violations reported to President and Congress if occur","Budget documentation retained per NARA schedules","Pre-decisional budget data handling per agency policy"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2041.00 — Credit Analysts
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with ECOA (Regulation B) — credit decisions cannot be based on protected class characteristics',
  'Ensure adverse action notices are provided within required timeframes with specific reasons',
  'Comply with FCRA requirements when using consumer reports in credit analysis',
  'Document credit decision rationale to withstand fair lending examination by CFPB, OCC, or Fed',
  'Maintain model validation documentation for credit scoring models per SR 11-7 guidance'
],
'{"soc_code":"13-2041.00","title":"Credit Analysts","regulatory_bodies":["CFPB","OCC","Federal Reserve","FDIC","NCUA"],"key_regulations":["Equal Credit Opportunity Act / Regulation B (12 CFR Part 1002)","Fair Credit Reporting Act (15 U.S.C. §1681)","Fair Housing Act (mortgage lending)","SR Letter 11-7 (model risk management)","Community Reinvestment Act (applicable institutions)"],"verification_checks":["Credit decision criteria free of ECOA prohibited factors","Adverse action notice provided within 30 days (consumer) or 60 days (business)","FCRA permissible purpose documented for consumer report use","Fair lending disparate impact analysis conducted annually","Credit model validation documented and current"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2051.00 — Financial and Investment Analysts
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain CFA designation or Series 86/87 research analyst registration per FINRA requirements',
  'Comply with SEC Regulation AC — certify that research reports express analyst''s actual views',
  'Disclose all material conflicts of interest in research reports per FINRA Rule 2241',
  'Comply with Regulation FD — do not receive or act on material non-public information',
  'Maintain Chinese Wall between investment banking and research to prevent analyst independence violations'
],
'{"soc_code":"13-2051.00","title":"Financial and Investment Analysts","regulatory_bodies":["SEC","FINRA","CFA Institute","State securities regulators"],"key_regulations":["SEC Regulation AC (analyst certification)","SEC Regulation FD (fair disclosure)","FINRA Rule 2241 (research analyst conflicts)","Securities Exchange Act §10(b) and Rule 10b-5","CFA Institute Code and Standards"],"verification_checks":["Series 86/87 registration current (sell-side analysts at broker-dealers)","Reg AC certification on all research reports","Conflict of interest disclosures current and accurate","No trading on material non-public information","Chinese Wall procedures documented and tested"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2052.00 — Personal Financial Advisors
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with fiduciary duty as an RIA under Investment Advisers Act — best interest of client, not just suitability',
  'Maintain Series 65 or Series 66 license as required, and state RIA or SEC RIA registration',
  'Provide complete Form ADV Part 2 disclosure to clients — annual update and amendment required',
  'Comply with SEC Regulation Best Interest (Reg BI) if also a broker-dealer registered representative',
  'Protect client financial data per Gramm-Leach-Bliley Act and applicable state privacy regulations'
],
'{"soc_code":"13-2052.00","title":"Personal Financial Advisors","regulatory_bodies":["SEC","FINRA","State securities regulators","DOL (ERISA fiduciary)"],"key_regulations":["Investment Advisers Act of 1940","SEC Regulation Best Interest (Reg BI)","DOL Fiduciary Rule (ERISA)","Gramm-Leach-Bliley Act (privacy)","Securities Exchange Act §15 (broker-dealer registration)"],"verification_checks":["Form ADV Part 2 delivered to clients annually","State or SEC RIA registration current","Series 65/66 license current","Suitability/best interest analysis documented for all recommendations","Client financial data protected per GLB safeguards rule"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2053.00 — Insurance Underwriters
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with state insurance underwriting regulations — rate and form filings must be approved before use',
  'Ensure underwriting criteria do not constitute unfair discrimination under state insurance laws',
  'Comply with FCRA requirements when using consumer reports in underwriting decisions',
  'Document underwriting decisions to support regulatory examination and reinsurance audit requirements',
  'Comply with OFAC sanctions screening — do not issue policies to sanctioned individuals or entities'
],
'{"soc_code":"13-2053.00","title":"Insurance Underwriters","regulatory_bodies":["State Insurance Departments","NAIC","OFAC","CFPB (credit-based insurance)"],"key_regulations":["State Insurance Code (rate/form filing requirements)","State Unfair Trade Practices Acts","FCRA (consumer reports in underwriting)","OFAC sanctions regulations","NAIC Model Unfair Discrimination Act"],"verification_checks":["Rate and form filings approved in all applicable states","Underwriting guidelines reviewed for disparate impact","FCRA adverse action notice provided when consumer report used adversely","OFAC screening completed for all applicants","Underwriting file documentation sufficient for exam"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2054.00 — Financial Risk Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with Basel III/IV capital adequacy and risk management requirements for banking institutions',
  'Ensure risk models meet SR 11-7 model risk management guidance — validation by independent team required',
  'Report material risk limit breaches to senior management and risk committee immediately',
  'Comply with Dodd-Frank stress testing (DFAST) or CCAR requirements for applicable institutions',
  'Maintain FRM, PRM, or equivalent professional risk certification as required by employer standards'
],
'{"soc_code":"13-2054.00","title":"Financial Risk Specialists","regulatory_bodies":["Federal Reserve","OCC","FDIC","BCBS (Basel Committee)","CFTC (derivatives)"],"key_regulations":["Basel III (capital adequacy)","SR Letter 11-7 (model risk management)","Dodd-Frank DFAST/CCAR (stress testing)","CFTC Title VII (OTC derivatives risk)","FINRA Rule 4210 (margin requirements)"],"verification_checks":["Risk model validation by independent model validation team","Risk limit framework approved by board risk committee","DFAST/CCAR submission completed timely","Basel capital ratios above regulatory minimums","Material risk events escalated per policy"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2061.00 — Financial Examiners
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Conduct examinations per applicable examination manual (FFIEC, State Banking Department) and within statutory authority',
  'Maintain examiner independence — no financial interests in examined institutions',
  'Protect examination findings as confidential until formal supervisory action — premature disclosure is prohibited',
  'Issue examination reports with factual findings only — support all criticisms with documented evidence',
  'Escalate imminent safety-and-soundness concerns to supervisory leadership immediately'
],
'{"soc_code":"13-2061.00","title":"Financial Examiners","regulatory_bodies":["OCC","Federal Reserve","FDIC","CFPB","State banking departments"],"key_regulations":["Bank Examination Guidelines (FFIEC)","CAMELS Rating System","12 U.S.C. §1820 (OCC examination authority)","12 CFR Part 4 (OCC)","Bank Secrecy Act examination procedures"],"verification_checks":["Examiner commission/authority current","Personal conflicts of interest cleared","Examination findings supported by documented evidence","Draft report reviewed by supervisory examiner","Privileged examination information not disclosed"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2071.00 — Credit Counselors
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain NFCC membership or HUD-approved agency status for applicable counseling programs',
  'Comply with FTC Credit Repair Organizations Act (CROA) — cannot charge upfront fees before services rendered',
  'Disclose all fees to clients before providing services — no hidden charges permitted',
  'Comply with state credit counseling licensing requirements in all states of operation',
  'Maintain client fund handling controls for Debt Management Plan payments — no commingling with operating funds'
],
'{"soc_code":"13-2071.00","title":"Credit Counselors","regulatory_bodies":["FTC","HUD (housing counseling)","State credit counseling regulators","IRS (nonprofit status)","CFPB"],"key_regulations":["Credit Repair Organizations Act (15 U.S.C. §1679)","HUD Handbook 7610.1 (housing counseling)","State credit counseling licensing statutes","FTC Act §5 (deceptive practices)","IRC §501(c)(3) (nonprofit credit counseling agencies)"],"verification_checks":["State credit counseling license current in all operating states","CROA upfront fee prohibition complied with","Client agreement with fees disclosed before services begin","DMP client funds in separate trust account","HUD counseling certification current if providing housing counseling"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2072.00 — Loan Officers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain active NMLS Mortgage Loan Originator license in all states of origination activity',
  'Comply with TRID (TILA-RESPA Integrated Disclosure) rules — Loan Estimate within 3 days, Closing Disclosure 3 days before consummation',
  'Comply with ECOA and Fair Housing Act — no discriminatory lending based on protected class',
  'Comply with HOEPA high-cost loan restrictions and ability-to-repay/QM requirements',
  'Disclose all compensation arrangements per CFPB Loan Originator Compensation Rule (Regulation Z §1026.36)'
],
'{"soc_code":"13-2072.00","title":"Loan Officers","regulatory_bodies":["CFPB","NMLS","Federal Reserve (Reg Z)","HUD","State banking departments"],"key_regulations":["TRID (TILA-RESPA Integrated Disclosure Rule)","ECOA / Regulation B","Fair Housing Act","ATR/QM Rule (12 CFR Part 1026)","HOEPA (15 U.S.C. §1639)","Dodd-Frank Loan Originator Compensation Rule"],"verification_checks":["NMLS license active in state of origination","Loan Estimate issued within 3 business days of application","No ECOA prohibited factors in underwriting recommendation","QM/ATR documentation complete","Loan Originator compensation not based on loan terms"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2081.00 — Tax Examiners and Collectors, and Revenue Agents
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with IRS examination procedures per Internal Revenue Manual (IRM) — audits must be conducted within statutory authority',
  'Protect taxpayer information under IRC §6103 — unauthorized disclosure is a federal crime',
  'Comply with IRS Taxpayer Bill of Rights — inform taxpayers of their rights before and during examination',
  'Document all examination adjustments with specific legal authority and factual basis',
  'Comply with Collection Due Process requirements before levying taxpayer property'
],
'{"soc_code":"13-2081.00","title":"Tax Examiners and Collectors, and Revenue Agents","regulatory_bodies":["IRS","Treasury Inspector General for Tax Administration (TIGTA)","State tax authorities"],"key_regulations":["Internal Revenue Code (26 U.S.C.)","Internal Revenue Manual (IRM)","IRC §6103 (taxpayer privacy)","Taxpayer Bill of Rights (IRC §7803(a)(3))","IRC §6330 (Collection Due Process)"],"verification_checks":["Examination authority within statute of limitations (3 years standard, 6 years for substantial omission)","Taxpayer rights publication provided","IRC §6103 taxpayer information handling training current","Adjustment rationale cites specific IRC section","CDP notice issued before levy action"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2082.00 — Tax Preparers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Register as IRS Tax Return Preparer with valid PTIN — mandatory for all paid preparers',
  'Comply with IRS Circular 230 — due diligence, accuracy, and ethical standards for tax practitioners',
  'Never prepare fraudulent returns or claim deductions the preparer knows are improper',
  'Provide client with copy of completed return before filing',
  'Comply with IRC §6694 preparer penalty provisions — incompetent or reckless positions carry monetary penalties'
],
'{"soc_code":"13-2082.00","title":"Tax Preparers","regulatory_bodies":["IRS","State tax authorities","AICPA (CPAs)","NAEA (EAs)"],"key_regulations":["IRC §6694 (preparer penalties)","IRS Circular 230 (31 CFR Part 10)","IRC §6713 (disclosure of return information)","EITC due diligence requirements (IRC §6695(g))","PTIN registration requirement (26 CFR §1.6109-2)"],"verification_checks":["Valid PTIN on all prepared returns","Circular 230 due diligence performed","EITC due diligence forms (8867) completed","Client copy provided before e-file authorization signed","Return signed by preparer with PTIN"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2099.01 — Financial Quantitative Analysts
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with SEC model disclosure requirements for algorithmic trading and quantitative investment strategies',
  'Validate quantitative models per SR 11-7 (Model Risk Management) before production deployment',
  'Do not use MNPI (material non-public information) in quantitative models — insider trading applies to systematic strategies',
  'Ensure backtesting methodology is honest and free of look-ahead bias and overfitting',
  'Comply with MiFID II algorithmic trading requirements including kill switch and annual self-assessment'
],
'{"soc_code":"13-2099.01","title":"Financial Quantitative Analysts","regulatory_bodies":["SEC","FINRA","CFTC","Federal Reserve (SR 11-7)","FCA/ESMA (EU/UK)"],"key_regulations":["SR Letter 11-7 (Model Risk Management)","SEC Rule 15c3-5 (Market Access Rule)","MiFID II Algorithmic Trading (Article 17)","Securities Exchange Act Rule 10b-5 (MNPI)","CFTC Regulation AT (algorithmic trading — proposed)"],"verification_checks":["Independent model validation completed before production","Look-ahead bias and data leakage checks in backtest","MNPI controls in data acquisition documented","Kill switch tested and operational for algorithmic strategies","MiFID II algorithmic trading annual self-assessment submitted"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 13-2099.04 — Fraud Examiners, Investigators and Analysts
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain CFE (Certified Fraud Examiner) certification and comply with ACFE Code of Professional Ethics',
  'Obtain proper legal authorization before accessing computer systems, records, or communications',
  'Protect investigation confidentiality — premature disclosure can compromise evidence and expose liability',
  'Comply with applicable state and federal wiretapping laws — do not intercept communications without authorization',
  'Issue investigation reports with factual findings only — do not express legal opinions on criminal guilt'
],
'{"soc_code":"13-2099.04","title":"Fraud Examiners, Investigators and Analysts","regulatory_bodies":["ACFE","FBI (federal fraud referrals)","DOJ","SEC (securities fraud)","State fraud bureaus"],"key_regulations":["ACFE Code of Professional Ethics","CFAA (Computer Fraud and Abuse Act — 18 U.S.C. §1030)","Electronic Communications Privacy Act (18 U.S.C. §2510)","False Claims Act (31 U.S.C. §3729)","Bank Secrecy Act (SAR filing requirements)"],"verification_checks":["CFE certification current","Legal authorization obtained before computer/records access","SAR filed within required timeframe for bank/financial institution examiners","Investigation report factual only — no legal conclusions","Confidentiality protocol documented and followed"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- ══════════════════════════════════════════════════════════════
-- LEGAL CLUSTER 23-xxxx GUARDRAILS
-- ══════════════════════════════════════════════════════════════

-- 23-1011.00 — Lawyers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with all rules of professional conduct in every jurisdiction of practice — bar license requires it',
  'Maintain client confidentiality under ABA Model Rule 1.6 — disclose only with client consent or mandatory exceptions',
  'Avoid conflicts of interest per ABA Model Rules 1.7, 1.8, 1.9 — conduct conflict check before every new engagement',
  'Hold client funds in IOLTA trust account — never commingle with operating funds',
  'Report ethical violations of other attorneys per ABA Model Rule 8.3 where required by jurisdiction'
],
'{"soc_code":"23-1011.00","title":"Lawyers","regulatory_bodies":["State Bar Associations","ABA","State Supreme Courts","USPTO (patent attorneys)"],"key_regulations":["ABA Model Rules of Professional Conduct","State Rules of Professional Conduct","IOLTA trust account rules (state-specific)","ABA Model Rule 1.6 (confidentiality)","ABA Model Rule 1.7 (conflicts of interest)"],"verification_checks":["Bar license active in all jurisdictions of practice","Conflicts check cleared before engagement opened","Client funds in IOLTA trust account, reconciled monthly","Engagement letter executed with scope and fee terms","Mandatory disclosure exceptions reviewed (e.g., imminent harm)"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 23-1012.00 — Judicial Law Clerks
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain absolute confidentiality of all judicial deliberations — disclosure is a serious ethical violation',
  'Recuse from any matter in which the clerk has a personal interest or prior involvement',
  'Comply with Code of Conduct for Judicial Employees — strict restrictions on outside activities and political engagement',
  'Never communicate ex parte with parties or counsel about pending matters without judicial authorization',
  'Comply with post-clerkship restrictions on practice before the presiding judge'
],
'{"soc_code":"23-1012.00","title":"Judicial Law Clerks","regulatory_bodies":["Judicial Conference of the United States","Chief Judge of circuit/district","State court administrative offices"],"key_regulations":["Code of Conduct for Judicial Employees (federal)","28 U.S.C. §455 (recusal standards)","Judicial Conference Ethics Opinions","State judicial employee conduct codes","Post-clerkship practice restrictions (court local rules)"],"verification_checks":["Financial disclosure form filed annually (federal clerks)","Recusal from cases with personal conflicts","No ex parte communications with parties","Post-clerkship bar compliance reviewed","Outside employment approved by chief judge if any"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 23-1021.00 — Administrative Law Judges, Adjudicators, and Hearing Officers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Maintain independence from agency prosecutorial functions — ALJs must be insulated from agency pressure per APA',
  'Comply with APA requirements for hearing procedures, due process, and written decisions',
  'Recuse from matters involving personal bias, financial interest, or prior involvement',
  'Conduct hearings on the record — all evidence and argument must be part of the administrative record',
  'Issue reasoned written decisions — bare conclusions without explanation violate APA and due process'
],
'{"soc_code":"23-1021.00","title":"Administrative Law Judges, Adjudicators, and Hearing Officers","regulatory_bodies":["Office of Personnel Management (federal ALJ tenure)","MSPB (ALJ performance)","Agency heads","Federal courts (APA review)"],"key_regulations":["Administrative Procedure Act (5 U.S.C. §554-557)","5 U.S.C. §7521 (ALJ removal only for good cause)","28 U.S.C. §455 (recusal — applied by analogy)","State Administrative Procedure Acts","Mathews v. Eldridge due process standard"],"verification_checks":["ALJ appointment through OPM merit-selection process (federal)","Recusal from matters with conflicts","All evidence received on the record","Written decision with findings of fact and conclusions of law","Decision reviewable by agency and federal courts on record"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 23-1022.00 — Arbitrators, Mediators, and Conciliators
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Disclose all potential conflicts of interest to parties before appointment — ongoing duty to disclose throughout proceedings',
  'Maintain impartiality throughout proceedings — ex parte communications with one party are prohibited in arbitration',
  'Comply with applicable arbitration rules (AAA, JAMS, ICC, UNCITRAL) governing the proceeding',
  'Protect confidentiality of mediation communications per applicable state mediation privilege statutes',
  'Issue arbitration awards within required timeframes and in writing per governing rules'
],
'{"soc_code":"23-1022.00","title":"Arbitrators, Mediators, and Conciliators","regulatory_bodies":["AAA","JAMS","ICC","State courts (award confirmation)","FMCS (labor arbitration)"],"key_regulations":["Federal Arbitration Act (9 U.S.C. §1)","AAA Commercial Arbitration Rules","JAMS Comprehensive Arbitration Rules","Uniform Mediation Act (state adoptions)","NY Convention (international arbitration awards)"],"verification_checks":["Full disclosure of conflicts made at appointment","No ex parte communications with parties (arbitration)","Mediation communications privileged per applicable state statute","Award issued within contractual timeframe","Award properly executed and transmitted for enforcement"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 23-1023.00 — Judges, Magistrate Judges, and Magistrates
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with Code of Conduct for United States Judges or applicable state judicial conduct code',
  'Recuse from any matter in which impartiality might reasonably be questioned (28 U.S.C. §455)',
  'File financial disclosure reports annually and avoid financial interests in entities with matters before the court',
  'Never engage in ex parte communications about pending matters with parties or their counsel',
  'Apply sentencing guidelines consistently and document substantial assistance departures per 18 U.S.C. §3553'
],
'{"soc_code":"23-1023.00","title":"Judges, Magistrate Judges, and Magistrates","regulatory_bodies":["Judicial Conference of the United States","State judicial conduct commissions","Federal courts of appeals (appellate review)","U.S. Senate (Article III confirmation)"],"key_regulations":["Code of Conduct for United States Judges","28 U.S.C. §455 (disqualification)","Ethics in Government Act (financial disclosure)","U.S. Sentencing Guidelines (18 U.S.C. §3553)","Due Process Clause (5th and 14th Amendments)"],"verification_checks":["Annual financial disclosure filed","Recusal motion evaluated promptly and documented","No ex parte contacts on pending cases","Sentencing departures documented with specific findings","Opinions contain adequate findings for appellate review"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 23-2011.00 — Paralegals and Legal Assistants
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Work only under supervision of licensed attorney — paralegals cannot practice law independently',
  'Maintain client confidentiality per attorney-client privilege and applicable ethics rules',
  'Disclose paralegal status to all opposing parties and third parties — cannot be mistaken for an attorney',
  'Never provide legal advice directly to clients — advice must come from supervising attorney',
  'Maintain accuracy in all court filings — errors can constitute sanctionable conduct by the supervising attorney'
],
'{"soc_code":"23-2011.00","title":"Paralegals and Legal Assistants","regulatory_bodies":["State bar associations (UPL enforcement)","NALA","NFPA","State courts"],"key_regulations":["ABA Model Rule 5.3 (supervision of non-lawyer assistants)","Unauthorized Practice of Law statutes (state-specific)","ABA Model Guideline 1 (paralegals may not practice law)","NALA Code of Ethics and Professional Responsibility","GDPR/CCPA (client data handling)"],"verification_checks":["All work product reviewed by supervising attorney","Paralegal status disclosed to third parties when relevant","No direct legal advice provided to clients","Confidentiality obligations understood and followed","Court filing deadlines calendared and verified with attorney"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 23-2093.00 — Title Examiners, Abstractors, and Searchers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with ALTA Best Practices for title companies — data security, trust accounting, and closing procedures',
  'Protect non-public personal information per Gramm-Leach-Bliley Act safeguards rule',
  'Maintain title plant or search records access in compliance with county recorder data use agreements',
  'Comply with RESPA Section 8 — no kickbacks or referral fees for title business',
  'Ensure ALTA commitments and policies conform to ALTA standard forms and underwriter requirements'
],
'{"soc_code":"23-2093.00","title":"Title Examiners, Abstractors, and Searchers","regulatory_bodies":["CFPB (RESPA)","State insurance departments (title insurance)","ALTA","County recorders"],"key_regulations":["RESPA §8 (kickbacks and referral fees — 12 U.S.C. §2607)","Gramm-Leach-Bliley Act (title company safeguards)","State title insurance statutes","ALTA Best Practices Framework","TRID (title charges on Loan Estimate and Closing Disclosure)"],"verification_checks":["ALTA Best Practices certification current","No RESPA §8 referral fee arrangements","GLB safeguards rule data security controls in place","Title commitment conforms to ALTA standard form","Closing funds handled in separate escrow accounts"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

-- 23-2099.00 — Legal Support Workers, All Other
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY[
  'Comply with state process server registration or licensing requirements where applicable',
  'Do not engage in unauthorized practice of law — scope limited to ministerial and clerical tasks',
  'Court reporters must comply with accuracy and transcript certification requirements of applicable jurisdiction',
  'Protect court records and transcripts from unauthorized disclosure per court order and applicable law',
  'Process servers must provide accurate affidavits of service — false affidavits constitute perjury'
],
'{"soc_code":"23-2099.00","title":"Legal Support Workers, All Other","regulatory_bodies":["State courts","State process server licensing boards","NCRA (court reporters)","State bar associations (UPL)"],"key_regulations":["State process server licensing statutes","State court reporter certification requirements","NCRA Code of Professional Ethics","Unauthorized Practice of Law statutes (state-specific)","18 U.S.C. §1621 (perjury — false affidavit of service)"],"verification_checks":["Process server license current in applicable states","Court reporter certification current and in good standing","Affidavit of service accurate and executed under oath","Scope of work within ministerial/clerical limits","No unauthorized legal advice provided to parties"],"last_bls_sync":"2026-03-31","soc_code_deprecated":null}'::jsonb,
'2026-03-31'::timestamptz
);

COMMIT;
