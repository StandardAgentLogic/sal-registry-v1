-- final_migration.sql — SAL Registry v1.0 production ingest

BEGIN;

-- merged from sal_finance_legal_seed_part1.sql
-- ============================================================
-- SAL Registry v1.0 — FINANCE (13-xxxx) + LEGAL (23-xxxx) CLUSTERS
-- Part 1 of 4: registry_metadata — All 59 roles
-- Source: O*NET OnLine + BLS OEWS May 2024
-- Ingested: 2026-03-31 | NULL market_value = "Market Standard"
-- Single BEGIN/COMMIT — entire batch fails if any row is malformed
-- ============================================================

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

ON CONFLICT (soc_code) DO NOTHING;

-- merged from sal_full_cluster_seed_part3.sql
-- ============================================================
-- SAL Registry v1.0 — FULL IT CLUSTER (SOC 15-0000)
-- Part 3 of 3: agent_logic — Roles 20–37 + ALL guardrails
-- ============================================================

-- ── 20. Blockchain Engineers (15-1299.07) ────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Design, deploy, and maintain distributed blockchain networks and cryptographic protocols to enable secure, transparent, and immutable transaction systems.',
'[
  {"step":1,"type":"tool_use","name":"assess_blockchain_requirements","description":"Define use case requirements, consensus mechanism, and token/smart contract scope","input":{"action":"requirements_analysis","tools":["Confluence","JIRA","GitHub"],"artifacts":["architecture_decision_record","smart_contract_spec","tokenomics_doc"]},"definition_of_done":"Requirements signed off, consensus mechanism selected with rationale documented"},
  {"step":2,"type":"tool_use","name":"assess_security_threats","description":"Assess blockchain-specific threats including untested code, unprotected keys, and 51% attacks","input":{"action":"threat_modeling","tools":["MITRE_ATT&CK","Slither","MythX"],"threats":["reentrancy","integer_overflow","front_running","key_compromise"]},"definition_of_done":"Threat model complete, all identified risks mitigated in design phase"},
  {"step":3,"type":"tool_use","name":"design_and_deploy_smart_contracts","description":"Design cryptographic protocols and deploy blockchain patterns for secure transactions","input":{"action":"implement","languages":["Solidity","Go","TypeScript","C++","Python","Rust"],"tools":["Docker","Kubernetes","Terraform","GitHub","Jenkins_CI"]},"definition_of_done":"Smart contracts audited, deployed to testnet and validated, no critical findings"},
  {"step":4,"type":"tool_use","name":"automate_network_operations","description":"Automate software update deployment across distributed network nodes","input":{"action":"automate_ops","tools":["Ansible","Docker","Kubernetes","AWS","Azure","Apache_Kafka"],"scope":["node_updates","monitoring","alerting","rollback"]},"definition_of_done":"Automated pipeline deploys to all nodes with zero-downtime, rollback tested"},
  {"step":5,"type":"tool_use","name":"build_reporting_dashboards","description":"Design and implement dashboards and data visualizations for blockchain network reporting","input":{"action":"build_dashboard","tools":["React","Angular","Grafana","MongoDB","PostgreSQL","Amazon_Kinesis"],"metrics":["transaction_volume","block_time","network_health","gas_costs"]},"definition_of_done":"Dashboard live in production, stakeholders can self-serve key network metrics"},
  {"step":6,"type":"tool_use","name":"security_audit_and_compliance","description":"Conduct ongoing security audits and maintain compliance with applicable regulations","input":{"action":"audit","tools":["Slither","MythX","Nessus","Confluence"],"frameworks":["FATF_guidelines","AML_KYC","SOC2"],"frequency":"pre-release_and_quarterly"},"definition_of_done":"Audit report clean or all critical issues remediated, compliance attestation signed off"}
]'::jsonb,
ARRAY['Go','TypeScript','C++','C#','Python','Java','Docker','Kubernetes','AWS','Azure','Terraform','Apache Kafka','Git','GitHub','Jenkins CI','React','Angular','Spring Framework','MongoDB','MySQL','PostgreSQL','Amazon Kinesis','Node.js','Grafana','Ansible','Linux','SQL']
);

-- ── 21. Computer Systems Engineers/Architects (15-1299.08) ───
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Design and develop solutions to complex application, system administration, and network architecture problems at enterprise scale while providing security and implementation guidance.',
'[
  {"step":1,"type":"tool_use","name":"gather_system_requirements","description":"Communicate with staff and clients to understand specific technical and business system requirements","input":{"action":"requirements_gathering","tools":["JIRA","Confluence","Microsoft_Project","Microsoft_Teams"],"methods":["workshops","architecture_reviews","RFP_analysis"]},"definition_of_done":"System requirements document approved, non-functional requirements quantified"},
  {"step":2,"type":"tool_use","name":"evaluate_components","description":"Investigate and assess system component suitability for specified purposes including build-vs-buy analysis","input":{"action":"technology_evaluation","tools":["AWS_CloudFormation","Oracle_Cloud","Splunk","Docker"],"artifacts":["POC_results","vendor_comparison","ADR"]},"definition_of_done":"Technology decisions documented in ADRs, approved by architecture review board"},
  {"step":3,"type":"tool_use","name":"design_solution_architecture","description":"Direct the design and architecture of complete computer systems across all layers","input":{"action":"architect","tools":["Terraform","Chef","Puppet","Ansible","Kubernetes"],"artifacts":["system_architecture_diagram","network_diagram","data_flow","deployment_model"]},"definition_of_done":"Architecture document approved, security and compliance review passed"},
  {"step":4,"type":"tool_use","name":"direct_implementation","description":"Direct installation of operating systems, network software, and hardware across the environment","input":{"action":"oversee_deployment","tools":["Git","GitLab","Bitbucket","Python","Go","Node.js","Java"],"method":"infrastructure_as_code"},"definition_of_done":"All components deployed per spec, integration tests pass, rollback plan documented"},
  {"step":5,"type":"tool_use","name":"provide_security_guidelines","description":"Provide customers and teams with guidelines for implementing secure and compliant systems","input":{"action":"security_guidance","frameworks":["NIST_SP_800-53","CIS_Controls","OWASP"],"tools":["Nagios","Wireshark","Splunk"],"artifacts":["hardening_guide","security_architecture_review"]},"definition_of_done":"Security guidelines published, reviewed by CISO, no unmitigated critical findings"},
  {"step":6,"type":"tool_use","name":"monitor_and_optimize","description":"Monitor system operations to detect potential problems and plan architectural improvements","input":{"action":"operations_review","tools":["Nagios","Datadog","Grafana","JIRA","Confluence","React"],"frequency":"weekly_ops_review"},"definition_of_done":"Operations review held weekly, all P1 issues have active remediation plans, roadmap updated"}
]'::jsonb,
ARRAY['AWS CloudFormation','Oracle Cloud','Splunk','Terraform','Chef','Puppet','Ansible','Docker','Kubernetes','Git','GitLab','Bitbucket','Python','Go','Java','Node.js','React','Angular','Django','Linux','Windows Server','Unix','Nagios','Wireshark','PostgreSQL','SQL Server','Oracle']
);

-- ── 22. IT Project Managers (15-1299.09) ─────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Plan, initiate, and manage IT projects from inception to delivery while leading technical teams and serving as the bridge between business stakeholders and engineering.',
'[
  {"step":1,"type":"tool_use","name":"initiate_project","description":"Define project scope, objectives, success criteria, and initial risk register","input":{"action":"project_initiation","tools":["Atlassian_JIRA","Confluence","Microsoft_Project"],"artifacts":["project_charter","stakeholder_register","RACI_matrix"]},"definition_of_done":"Project charter signed, sponsor approved, team assembled and kickoff scheduled"},
  {"step":2,"type":"tool_use","name":"build_project_plan","description":"Develop detailed project schedule, resource plan, and budget with milestones and deliverables","input":{"action":"planning","tools":["Microsoft_Project","Oracle_Primavera","Atlassian_JIRA","Confluence"],"artifacts":["WBS","Gantt_chart","resource_plan","budget_baseline"]},"definition_of_done":"Project plan baselined, critical path identified, all dependencies mapped"},
  {"step":3,"type":"tool_use","name":"execute_and_track","description":"Manage project execution ensuring adherence to scope, schedule, and budget","input":{"action":"execution_monitoring","tools":["JIRA","Microsoft_Teams","Slack","Tableau","Apache_Spark"],"cadence":["daily_standup","weekly_status_report","monthly_steering_committee"]},"definition_of_done":"Project within 10% of baseline schedule/budget, risks actively managed"},
  {"step":4,"type":"tool_use","name":"resolve_issues_and_risks","description":"Confer with project personnel to identify and resolve problems and escalate blockers","input":{"action":"issue_and_risk_management","tools":["JIRA","Confluence","Microsoft_Excel","ServiceNow"],"process":["identify","assess","respond","monitor"]},"definition_of_done":"All P1 issues have owners and resolution dates, risk register current"},
  {"step":5,"type":"tool_use","name":"manage_stakeholder_needs","description":"Assess customer needs and priorities through direct communication and adjust project accordingly","input":{"action":"stakeholder_management","tools":["Microsoft_Teams","Cisco_Webex","PowerPoint","Tableau","MATLAB"],"frequency":"weekly_stakeholder_updates"},"definition_of_done":"Stakeholder satisfaction tracked, change requests managed through formal process"},
  {"step":6,"type":"tool_use","name":"deliver_and_close","description":"Submit final deliverables, conduct lessons learned, and formally close the project","input":{"action":"project_closure","tools":["JIRA","Confluence","SAS","Oracle_Primavera"],"artifacts":["final_delivery_acceptance","lessons_learned_report","project_closure_document"]},"definition_of_done":"All deliverables accepted, lessons learned published, project closed in PM tool"}
]'::jsonb,
ARRAY['Atlassian JIRA','Atlassian Confluence','Microsoft Project','Oracle Primavera','Microsoft Teams','Microsoft Excel','Microsoft PowerPoint','Tableau','Apache Spark','SAS','MATLAB','Docker','GitHub','Spring Boot','React','Angular','IBM DB2','ServiceNow','SQL Server','Oracle','Slack','Cisco Webex']
);

-- ── 23. Actuaries (15-2011.00) ───────────────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Analyze statistical data on risk, mortality, accidents, and financial uncertainty to construct probability models and inform insurance, pension, and investment product design.',
'[
  {"step":1,"type":"tool_use","name":"define_risk_problem","description":"Collaborate with underwriters, programmers, and senior management to scope the actuarial analysis","input":{"action":"problem_scoping","tools":["Microsoft_Excel","SAS","Confluence"],"artifacts":["analysis_scope","assumptions_document","data_requirements"]},"definition_of_done":"Analysis scope approved by appointed actuary, assumptions signed off"},
  {"step":2,"type":"tool_use","name":"collect_and_validate_data","description":"Gather and validate statistical data on mortality, accident, sickness, and disability rates","input":{"action":"data_collection","tools":["SAS","IBM_SPSS_Statistics","SQL","Oracle_Database"],"sources":["industry_tables","internal_claims","government_statistics"]},"definition_of_done":"Data validated for completeness and consistency, data quality report filed"},
  {"step":3,"type":"tool_use","name":"build_actuarial_model","description":"Construct probability tables and statistical models for specified risk events","input":{"action":"model_development","tools":["SAS","MATLAB","Python","Visual_Basic","Microsoft_Excel"],"models":["mortality_table","frequency-severity","GLM","stochastic_simulation"]},"definition_of_done":"Model validated against historical data, peer reviewed by fellow actuary"},
  {"step":4,"type":"tool_use","name":"calculate_premiums_and_reserves","description":"Ascertain premium rates and cash reserves required to ensure payment of future benefits","input":{"action":"pricing_and_reserving","tools":["SAS","Python","Java","Microsoft_Excel","Tableau"],"outputs":["premium_rate_table","reserve_calculation","sensitivity_analysis"]},"definition_of_done":"Calculations reviewed and signed off by chief actuary, filed with regulator if required"},
  {"step":5,"type":"tool_use","name":"design_insurance_products","description":"Design, review, and administer insurance, annuity, and pension plans","input":{"action":"product_design","tools":["Microsoft_Excel","Power_BI","SAS"],"artifacts":["product_specification","policy_form","regulatory_filing"]},"definition_of_done":"Product design approved by actuarial committee, regulatory approval obtained"},
  {"step":6,"type":"tool_use","name":"communicate_to_executives","description":"Determine company policy and present complex actuarial findings to executives and officials","input":{"action":"executive_reporting","tools":["Tableau","Power_BI","Microsoft_PowerPoint","Microsoft_Excel"],"formats":["board_presentation","regulatory_report","management_summary"]},"definition_of_done":"Report delivered on schedule, executive questions answered, action items documented"}
]'::jsonb,
ARRAY['SAS','IBM SPSS Statistics','MATLAB','Python','Java','Visual Basic','Microsoft Excel','Oracle Database','SQL','Microsoft Access','Tableau','Power BI','Microsoft Office']
);

-- ── 24. Mathematicians (15-2021.00) ─────────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Conduct research in fundamental and applied mathematics, develop new mathematical principles, and apply quantitative methods to solve practical problems across science and industry.',
'[
  {"step":1,"type":"tool_use","name":"identify_research_question","description":"Identify mathematical problems and gaps in existing theoretical frameworks","input":{"action":"literature_review","tools":["MATLAB","Mathematica","LaTeX","Python"],"sources":["arXiv","MathSciNet","IEEE_Xplore"]},"definition_of_done":"Research question formulated, hypothesis stated, scope bounded with clear success criteria"},
  {"step":2,"type":"tool_use","name":"develop_mathematical_framework","description":"Develop new mathematical principles, theorems, and relationships to advance the field","input":{"action":"theoretical_development","tools":["MATLAB","SAS","IBM_SPSS","Python","R"],"methods":["proof_by_induction","linear_algebra","differential_equations","topology"]},"definition_of_done":"Mathematical framework internally consistent, key lemmas proven"},
  {"step":3,"type":"tool_use","name":"implement_computational_methods","description":"Perform computations and apply numerical analysis methods to validate theoretical results","input":{"action":"numerical_implementation","languages":["Python","R","C","C#","Java","Perl"],"tools":["MATLAB","Visual_Studio","Tableau"],"methods":["finite_element","Monte_Carlo","optimization_algorithms"]},"definition_of_done":"Numerical results consistent with theoretical predictions, code reproducible"},
  {"step":4,"type":"tool_use","name":"explore_applied_implications","description":"Apply mathematical techniques to solve practical problems in science, engineering, or business","input":{"action":"applied_analysis","tools":["SQL","MySQL","Microsoft_Access","Tableau","Python"],"domains":["financial_modeling","physics_simulation","operations_research","ML_theory"]},"definition_of_done":"Applied model validated against real-world data, limitations documented"},
  {"step":5,"type":"tool_use","name":"publish_and_present","description":"Share research findings through publications, reports, and conference presentations","input":{"action":"dissemination","tools":["LaTeX","Overleaf","MATLAB","PowerPoint"],"venues":["peer_reviewed_journals","AMS_conferences","IEEE"]},"definition_of_done":"Paper submitted to target venue or published, presentation delivered"},
  {"step":6,"type":"tool_use","name":"mentor_and_collaborate","description":"Mentor junior staff and collaborate across disciplines on mathematical applications","input":{"action":"knowledge_transfer","tools":["Confluence","GitHub","Microsoft_Office","Zoom"],"deliverables":["technical_reports","code_documentation","training_sessions"]},"definition_of_done":"Mentees demonstrate improved proficiency, collaboration deliverables completed on schedule"}
]'::jsonb,
ARRAY['MATLAB','SAS','IBM SPSS Statistics','Python','R','C','C#','Java','Perl','SQL','MySQL','Microsoft Access','Tableau','Visual Studio','Microsoft Excel','Microsoft Office','Linux','UNIX','macOS','Bash','HTML','CSS','JavaScript','PHP','XML']
);

-- ── 25. Operations Research Analysts (15-2031.00) ────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Formulate and apply mathematical modeling and optimization methods to help management make data-driven decisions about complex operational problems.',
'[
  {"step":1,"type":"tool_use","name":"define_problem","description":"Define and scope the operational problem, collecting information to understand constraints and objectives","input":{"action":"problem_definition","tools":["Microsoft_Project","JIRA","Confluence","SAP"],"artifacts":["problem_statement","objective_function","constraints_list"]},"definition_of_done":"Problem formally defined, decision variables and constraints agreed with management"},
  {"step":2,"type":"tool_use","name":"gather_and_validate_data","description":"Define data requirements, gather information, and validate using statistical methods","input":{"action":"data_collection","tools":["Apache_Hadoop","Teradata","SQL","Python","R"],"validation":["outlier_detection","completeness_check","cross-validation"]},"definition_of_done":"Dataset validated, data quality report filed, all assumptions documented"},
  {"step":3,"type":"tool_use","name":"build_and_calibrate_model","description":"Formulate mathematical and simulation models relating variables and parameters","input":{"action":"model_building","tools":["MATLAB","IBM_SPSS","Minitab","Python_scipy","R"],"model_types":["linear_programming","simulation","queueing_theory","integer_programming"]},"definition_of_done":"Model calibrated against historical data, validation metrics meet defined thresholds"},
  {"step":4,"type":"tool_use","name":"test_and_validate_model","description":"Test model under multiple scenarios and reformulate as needed for adequacy","input":{"action":"scenario_testing","tools":["Amazon_Redshift","Splunk","ProModel","Microsoft_Visio"],"tests":["sensitivity_analysis","scenario_planning","stress_test"]},"definition_of_done":"Model passes all test scenarios, sensitivity report documents key drivers"},
  {"step":5,"type":"tool_use","name":"develop_recommendations","description":"Prepare management reports that evaluate operational problems and recommend solutions","input":{"action":"reporting","tools":["Tableau","Power_BI","Microsoft_Excel","Oracle","SAP"],"outputs":["executive_summary","technical_report","cost-benefit_analysis"]},"definition_of_done":"Report delivered on time, recommendations quantified with projected ROI"},
  {"step":6,"type":"tool_use","name":"support_implementation","description":"Collaborate across the organization to implement recommended solutions successfully","input":{"action":"implementation_support","tools":["Microsoft_Project","JIRA","GitHub","SAP","Oracle"],"role":"subject_matter_expert"},"definition_of_done":"Solution implemented, post-implementation KPIs tracked against projections, lessons documented"}
]'::jsonb,
ARRAY['MATLAB','IBM SPSS Statistics','Minitab','Python','R','C','SQL','Apache Hadoop','Teradata','Amazon Redshift','Tableau','Power BI','Microsoft Excel','SAP','Oracle','Microsoft Visio','ProModel','GitHub','Microsoft Project']
);

-- ── 26. Statisticians (15-2041.00) ───────────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Develop and apply statistical theory and methods to collect, analyze, and interpret numerical data, enabling evidence-based decisions across scientific, government, and business domains.',
'[
  {"step":1,"type":"tool_use","name":"design_study","description":"Develop experimental designs, sampling techniques, and analytical methods for the research question","input":{"action":"study_design","tools":["SAS","R","IBM_SPSS_Statistics","MATLAB"],"designs":["randomized_controlled_trial","survey_design","observational_study"]},"definition_of_done":"Study design reviewed by lead statistician, power analysis completed, IRB approved if required"},
  {"step":2,"type":"tool_use","name":"collect_and_prepare_data","description":"Organize, clean, and weight raw data to prepare it for statistical processing","input":{"action":"data_preparation","tools":["Python","R","SAS","SQL_Server","Amazon_Redshift"],"tasks":["missing_data_imputation","outlier_treatment","variable_encoding"]},"definition_of_done":"Clean dataset documented, data dictionary complete, reproducible preparation script saved"},
  {"step":3,"type":"tool_use","name":"evaluate_statistical_methods","description":"Evaluate and select appropriate statistical methods based on data type and research objectives","input":{"action":"method_selection","tools":["IBM_SPSS","SAS","R","MATLAB"],"considerations":["distribution_assumptions","sample_size","hypothesis_type"]},"definition_of_done":"Method selection justified in analysis plan, assumptions documented and tested"},
  {"step":4,"type":"tool_use","name":"analyze_and_interpret","description":"Analyze data to identify significant relationships, differences, and patterns","input":{"action":"statistical_analysis","tools":["SAS","R","Python","Apache_Spark","Apache_Hadoop","Tableau"],"methods":["regression","ANOVA","time_series","Bayesian_inference","machine_learning"]},"definition_of_done":"Analysis complete, effect sizes and confidence intervals reported, reproducible code archived"},
  {"step":5,"type":"tool_use","name":"report_results","description":"Report statistical analyses through graphs, charts, tables, and written interpretation","input":{"action":"reporting","tools":["Tableau","QlikView","R_ggplot2","Microsoft_PowerPoint"],"standards":["APA_format","p_value_reporting","confidence_intervals"]},"definition_of_done":"Report reviewed by stakeholder, all visualizations accurately represent findings"},
  {"step":6,"type":"tool_use","name":"ensure_methodological_validity","description":"Assess statistical procedures used to ensure validity, applicability, and accuracy","input":{"action":"peer_review","tools":["R","SAS","Confluence"],"checks":["assumption_verification","replication","sensitivity_analysis"]},"definition_of_done":"Methodology validated by independent reviewer, replication package archived"}
]'::jsonb,
ARRAY['IBM SPSS Statistics','SAS','MATLAB','R','Python','C++','Java','Apache Spark','Apache Hadoop','Tableau','QlikView','SQL Server','Amazon Redshift','AWS','Microsoft Excel','Microsoft Office','PowerPoint']
);

-- ── 27. Biostatisticians (15-2041.01) ────────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Develop and apply biostatistical theory and methods to design clinical and life science studies, analyze biological data, and support evidence-based medical decision-making.',
'[
  {"step":1,"type":"tool_use","name":"collaborate_on_study_design","description":"Design research studies in collaboration with physicians and life scientists","input":{"action":"study_design","tools":["SAS","R","MATLAB","IBM_SPSS"],"designs":["RCT","cohort_study","case-control","adaptive_design"]},"definition_of_done":"Protocol finalized, IRB approved, randomization scheme documented"},
  {"step":2,"type":"tool_use","name":"calculate_sample_size","description":"Calculate sample size requirements and power analysis for clinical studies","input":{"action":"power_analysis","tools":["SAS","R","MATLAB","G*Power"],"inputs":["effect_size","alpha","power","dropout_rate"]},"definition_of_done":"Sample size calculation documented, reviewed by principal investigator and statistician lead"},
  {"step":3,"type":"tool_use","name":"write_analysis_plan","description":"Write detailed statistical analysis plans and descriptions for research protocols","input":{"action":"SAP_development","tools":["Microsoft_Word","SAS","R","LaTeX"],"content":["endpoints","analysis_methods","handling_of_missing_data","multiplicity_adjustment"]},"definition_of_done":"SAP finalized before database lock, signed by lead biostatistician"},
  {"step":4,"type":"tool_use","name":"analyze_clinical_data","description":"Analyze clinical or survey data using longitudinal analysis, logistic regression, and survival methods","input":{"action":"run_analysis","tools":["SAS","R","IBM_SPSS","MATLAB","Python","MySQL"],"methods":["mixed_models","Cox_regression","logistic_regression","meta_analysis"]},"definition_of_done":"Analysis complete, QC passed by independent programmer, output tables finalized"},
  {"step":5,"type":"tool_use","name":"draw_conclusions","description":"Draw conclusions and make predictions based on data summaries and statistical analyses","input":{"action":"interpretation","tools":["SAS","R","Tableau","Microsoft_Excel"],"outputs":["clinical_study_report","regulatory_submission_tables","publications"]},"definition_of_done":"Conclusions aligned with pre-specified SAP, all results interpretable in clinical context"},
  {"step":6,"type":"tool_use","name":"maintain_methodological_currency","description":"Read current literature and attend conferences to stay current with biostatistical methods","input":{"action":"continuous_development","sources":["ASA_conferences","Biometrics_journal","NEJM","FDA_guidance_documents"],"tools":["Linux","UNIX","Bash","C#","Java","Perl"]},"definition_of_done":"Annual development plan met, at least one new methodology applied or published per year"}
]'::jsonb,
ARRAY['SAS','IBM SPSS Statistics','MATLAB','R','Python','MySQL','SQL','Oracle Database','Microsoft Access','C#','Java','Perl','Linux','UNIX','Bash','Microsoft Visual Studio','Microsoft Excel','Microsoft Office']
);

-- ── 28. Data Scientists (15-2051.00) ─────────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Transform raw data into actionable insights by applying machine learning, statistical modeling, and data visualization techniques to solve complex business and scientific problems.',
'[
  {"step":1,"type":"tool_use","name":"identify_business_problem","description":"Identify and frame business problems or management objectives addressable through data analysis","input":{"action":"problem_framing","tools":["Confluence","JIRA","Tableau"],"artifacts":["problem_statement","success_metrics","data_availability_assessment"]},"definition_of_done":"Problem framed with quantifiable success criteria, stakeholder alignment confirmed"},
  {"step":2,"type":"tool_use","name":"collect_and_clean_data","description":"Clean and manipulate raw datasets using statistical software to prepare for analysis","input":{"action":"data_prep","tools":["Python","R","Alteryx","Apache_Spark","Snowflake"],"tasks":["missing_value_handling","feature_engineering","normalization","train-test_split"]},"definition_of_done":"Clean dataset versioned, data lineage documented, no data leakage confirmed"},
  {"step":3,"type":"tool_use","name":"build_and_train_models","description":"Develop machine learning models and statistical algorithms to address the defined problem","input":{"action":"model_development","tools":["TensorFlow","SAS","PyTorch","AWS_SageMaker","Scikit_Learn","MATLAB"],"frameworks":["supervised_learning","unsupervised_learning","NLP","deep_learning"]},"definition_of_done":"Model exceeds baseline metrics, hyperparameters tuned, cross-validation results documented"},
  {"step":4,"type":"tool_use","name":"validate_and_test","description":"Test, validate, and reformulate models to ensure accurate outcome prediction","input":{"action":"model_validation","tools":["Python","R","Jupyter","Docker","AWS"],"methods":["holdout_test","A/B_test","confusion_matrix","SHAP_values"]},"definition_of_done":"Model passes validation tests, fairness audit complete, no significant degradation on holdout set"},
  {"step":5,"type":"tool_use","name":"visualize_and_communicate","description":"Create graphs, charts, and dashboards to convey data analysis results to stakeholders","input":{"action":"visualization","tools":["Tableau","Power_BI","Apache_Spark","Alteryx","matplotlib","Plotly"],"outputs":["executive_dashboard","technical_report","slide_deck"]},"definition_of_done":"Visualizations reviewed by stakeholders, key findings unambiguous, no misleading charts"},
  {"step":6,"type":"tool_use","name":"deploy_and_monitor","description":"Deploy models to production and monitor for data drift and performance degradation","input":{"action":"MLOps","tools":["Docker","Kubernetes","AWS_SageMaker","Azure_ML","Git","GitHub","Apache_Kafka"],"monitoring":["data_drift","model_performance","pipeline_health"]},"definition_of_done":"Model in production, monitoring dashboard live, retraining trigger defined and tested"}
]'::jsonb,
ARRAY['Python','R','Scala','Java','C#','JavaScript','TensorFlow','MATLAB','IBM SPSS Statistics','SAS','Tableau','Power BI','Apache Spark','Alteryx','Snowflake','PostgreSQL','MongoDB','Apache Cassandra','Elasticsearch','AWS','Microsoft Azure','Google Cloud','Docker','Kubernetes','Apache Kafka','Git','GitHub']
);

-- ── 29. Business Intelligence Analysts (15-2051.01) ──────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Produce financial and market intelligence by querying data repositories, building dashboards, and generating reports that enable executives and managers to make informed business decisions.',
'[
  {"step":1,"type":"tool_use","name":"gather_intelligence_requirements","description":"Identify reporting needs and KPIs required by executives, managers, and operational teams","input":{"action":"requirements_gathering","tools":["JIRA","Confluence","Microsoft_Excel"],"artifacts":["reporting_requirements_doc","KPI_inventory","data_source_map"]},"definition_of_done":"Requirements signed off, data sources identified and access confirmed"},
  {"step":2,"type":"tool_use","name":"design_data_model","description":"Design or update BI data models, cubes, and semantic layers supporting required analytics","input":{"action":"data_modeling","tools":["Power_BI","Tableau","Snowflake","Oracle_PL-SQL","Amazon_DynamoDB"],"patterns":["star_schema","calculated_measures","row-level_security"]},"definition_of_done":"Data model reviewed by data architect, performance tested at expected data volumes"},
  {"step":3,"type":"tool_use","name":"build_dashboards_and_reports","description":"Develop interactive dashboards and standard reports that surface key business insights","input":{"action":"build","tools":["Power_BI","Tableau","Alteryx","Elasticsearch","IBM_SPSS","SAS","MATLAB"],"deliverables":["executive_dashboard","operational_reports","ad_hoc_query_layer"]},"definition_of_done":"Dashboard reviewed by stakeholders, data validated against source systems, performance SLA met"},
  {"step":4,"type":"tool_use","name":"analyze_trends","description":"Identify and analyze industry or geographic trends with business strategy implications","input":{"action":"trend_analysis","tools":["Google_Analytics","Snowflake","Oracle_Cloud","Splunk"],"methods":["time_series","cohort_analysis","market_benchmarking"]},"definition_of_done":"Trend analysis report delivered with actionable recommendations, reviewed by business leadership"},
  {"step":5,"type":"tool_use","name":"maintain_bi_infrastructure","description":"Maintain and update BI tools, databases, dashboards, and data pipelines","input":{"action":"maintenance","tools":["Apache_Kafka","PowerShell","Microsoft_Azure","Git"],"tasks":["pipeline_monitoring","data_quality_alerts","version_management","access_reviews"]},"definition_of_done":"All pipelines green, no SLA breaches, version changelog current"},
  {"step":6,"type":"tool_use","name":"provide_technical_support","description":"Provide technical support for existing reports and document BI specifications","input":{"action":"support_and_documentation","tools":["Confluence","JIRA","Microsoft_Excel"],"deliverables":["user_guide","data_dictionary","technical_spec"]},"definition_of_done":"All P1 support tickets resolved within SLA, documentation current and accessible"}
]'::jsonb,
ARRAY['Microsoft Power BI','Tableau','Alteryx','Snowflake','Oracle PL/SQL','Amazon DynamoDB','Elasticsearch','SAS','MATLAB','IBM SPSS Statistics','Apache Kafka','PowerShell','Microsoft Excel','Microsoft Office','Oracle Cloud','Splunk Enterprise','SAP','Oracle PeopleSoft','Google Analytics']
);

-- ── 30. Clinical Data Managers (15-2051.02) ──────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Apply healthcare and database management expertise to design clinical trial databases, manage data collection and validation, and ensure the integrity of clinical research data.',
'[
  {"step":1,"type":"tool_use","name":"design_clinical_database","description":"Design and validate clinical trial databases including logic checks and edit specifications","input":{"action":"database_design","tools":["SAS","Epic_Systems","MEDITECH","Teradata"],"artifacts":["CRF_specifications","edit_check_specifications","data_model"]},"definition_of_done":"Database UAT complete, all edit checks validated, sponsor approved before first patient in"},
  {"step":2,"type":"tool_use","name":"develop_data_management_plan","description":"Develop project-specific data management plans addressing coding, reporting, and transfer","input":{"action":"DMP_development","tools":["Microsoft_Word","SharePoint","Confluence"],"content":["data_flow","coding_conventions","transfer_specifications","archival_plan"]},"definition_of_done":"DMP approved by sponsor/CRO and signed before study start"},
  {"step":3,"type":"tool_use","name":"process_clinical_data","description":"Receive, enter, verify, and file clinical data within defined timelines","input":{"action":"data_entry_and_verification","tools":["SAS","IBM_SPSS","Teradata","Microsoft_Excel","Microsoft_Access"],"sla":{"entry_lag_days":5,"query_response_days":7}},"definition_of_done":"Data current within SLA, all fields within valid ranges, no outstanding critical errors"},
  {"step":4,"type":"tool_use","name":"generate_and_resolve_queries","description":"Generate data queries based on validation checks and track resolution with sites","input":{"action":"query_management","tools":["EDC_system","SAS","SQL","ServiceNow"],"thresholds":{"open_query_rate_pct":5}},"definition_of_done":"Open query rate below 5%, all critical queries resolved before database lock"},
  {"step":5,"type":"tool_use","name":"monitor_compliance","description":"Monitor work productivity and quality to ensure compliance with SOPs and regulatory requirements","input":{"action":"quality_monitoring","tools":["SAS","IBM_SPSS","Confluence"],"frameworks":["ICH_E6_GCP","FDA_21_CFR_Part_11","GDPR"],"frequency":"ongoing_and_at_milestones"},"definition_of_done":"Compliance metrics within defined thresholds, no unresolved CAPA items"},
  {"step":6,"type":"tool_use","name":"prepare_for_database_lock","description":"Prepare, clean, and format datasets for database lock and regulatory submission","input":{"action":"database_lock","tools":["SAS","R","Teradata","SharePoint"],"deliverables":["clean_dataset","audit_trail_report","data_transfer_package","coding_completion_report"]},"definition_of_done":"Database locked per SOP, sponsor QC passed, transfer package delivered within 5 days of lock"}
]'::jsonb,
ARRAY['SAS','IBM SPSS Statistics','Teradata','Epic Systems','MEDITECH','SQL','Microsoft Excel','Microsoft Access','Microsoft Word','SharePoint','Java','C++','C#','Python','R']
);

-- ── 31. Bioinformatics Technicians (15-2099.01) ───────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Apply bioinformatics principles and computational tools to assist scientists in analyzing molecular sequence data and maintaining biological databases in pharmaceutical and biotechnology research.',
'[
  {"step":1,"type":"tool_use","name":"access_biological_databases","description":"Access and retrieve data from structural, protein sequence, genomic, and gene expression databases","input":{"action":"data_retrieval","tools":["NCBI_databases","UniProt","Ensembl","MySQL","Oracle_Database"],"formats":["FASTA","VCF","BAM","GFF3"]},"definition_of_done":"Relevant datasets downloaded, provenance documented, data integrity checksums verified"},
  {"step":2,"type":"tool_use","name":"perform_quality_checks","description":"Perform quality checks on data inputs and resulting analyses to ensure accuracy","input":{"action":"QC","tools":["FastQC","Trimmomatic","R","Python","SAS"],"checks":["sequence_quality","read_depth","mapping_rate","variant_calling_accuracy"]},"definition_of_done":"QC report generated, all samples meet minimum quality thresholds, failed samples flagged"},
  {"step":3,"type":"tool_use","name":"analyze_molecular_data","description":"Examine and interpret bioinformatics data using statistical and data mining techniques","input":{"action":"analysis","tools":["R_Bioconductor","Python_Biopython","MATLAB","SAS","IBM_SPSS","Perl"],"methods":["sequence_alignment","differential_expression","phylogenetics","variant_annotation"]},"definition_of_done":"Analysis results reproducible, methods documented in analysis script with comments"},
  {"step":4,"type":"tool_use","name":"extend_bioinformatics_tools","description":"Extend existing software programs, tools, and database queries as analysis needs evolve","input":{"action":"tool_development","languages":["Python","R","C","C++","Java","Perl","Ruby"],"tools":["Git","Apache_Subversion","Microsoft_SQL_Server"],"type":"scripts_and_pipelines"},"definition_of_done":"Extended tools version-controlled, documented, and unit tested"},
  {"step":5,"type":"tool_use","name":"build_and_maintain_databases","description":"Build and maintain searchable biological databases for analysis and presentation","input":{"action":"database_management","tools":["MySQL","Oracle_Database","SQL","Python"],"tasks":["schema_updates","data_loading","indexing","backup"]},"definition_of_done":"Database current, queries performant, backup verified monthly"},
  {"step":6,"type":"tool_use","name":"stay_current_with_methods","description":"Keep current with new computational methods and emerging bioinformatics technologies","input":{"action":"professional_development","sources":["Bioinformatics_journal","ISMB","bioRxiv","vendor_training"],"tools":["LaTeX","Microsoft_Office"]},"definition_of_done":"Annual development goals met, at least one new method integrated into team workflows per year"}
]'::jsonb,
ARRAY['Python','R','C','C++','Java','Perl','Ruby','MATLAB','SAS','IBM SPSS Statistics','MySQL','Oracle Database','SQL','Microsoft SQL Server','Git','Apache Subversion','Microsoft Excel','Microsoft Office','Linux','UNIX','Bash']
);

-- ============================================================
-- GUARDRAILS AND COMPLIANCE — All 37 Roles
-- Keyed by soc_code in verification_logic JSONB
-- ============================================================

-- Previously seeded roles (5) — insert new guardrail records
-- (agent_logic/guardrails have no UNIQUE on soc_code;
--  run Part 1 SQL FIRST to avoid FK-less duplicates.
--  Use this script only on a fresh cluster deploy.)

-- 1. Health Informatics Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All patient data handling must comply with HIPAA and HL7 FHIR standards','No EHR configuration change deployed without clinical sign-off and UAT','PHI must never appear in test or development environments','All system changes must include a documented rollback procedure','Training completion rate for new EHR features must reach 95% before go-live'],
'{"soc_code":"15-1211.01","definition_of_done":["Clinical requirements approved by nursing leadership","System spec approved by informatics team","Privacy controls verified — no PHI exposure in any env","Analysis KPIs trending as expected","Training completion >= 95%, competency score >= 80%"],"compliance_standards":["HIPAA","HL7_FHIR","ONC_Certification","Joint_Commission"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 2. Computer and Information Research Scientists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All research experiments must be reproducible with published methodology','No proprietary algorithms deployed to production without peer review','Data sets used in research must be licensed for intended use','AI/ML models must be evaluated for bias and unintended consequences before publication','Research involving human subjects requires IRB approval'],
'{"soc_code":"15-1221.00","definition_of_done":["Research proposal peer-reviewed and approved","Experiments reproducible by independent team","Results statistically significant","Paper accepted or posted with peer review initiated","Applied team can reproduce results independently"],"compliance_standards":["IRB_Protocol","IEEE_Ethics","ACM_Code_of_Ethics","NIST_AI_RMF"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 3. Computer Network Support Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All network configuration changes require change management approval and rollback plan','Security breaches must be reported to security team within 1 hour of detection','Network backups must be tested monthly for restorability','No access credentials to be shared or documented in insecure channels','All diagnostic sessions on production systems must be logged with ticket reference'],
'{"soc_code":"15-1231.00","definition_of_done":["Network health baseline documented","Root cause identified with supporting evidence","Configuration fix applied and change log updated","Metrics within SLA after fix, no recurrence in 24h","Incident closed in ticketing system"],"compliance_standards":["ITIL_v4","CIS_Benchmarks","NIST_SP_800-53"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 4. Computer User Support Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['Support tickets must be logged for every user interaction — no undocumented fixes','P1 incidents must be acknowledged within 15 minutes of report','Endpoint provisioning must follow approved Standard Operating Environment (SOE)','No software may be installed on user devices without IT approval and license verification','Remote access sessions to user machines require user consent before initiating'],
'{"soc_code":"15-1232.00","definition_of_done":["Ticket created and prioritized within SLA","Root cause identified or escalation made with full notes","Issue resolved and user confirmed resolution","Device provisioned per SOE build standards","Daily health checks logged with no unacknowledged P1s"],"compliance_standards":["ITIL_v4","ISO_20000","CIS_Benchmarks"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 5. Computer Network Architects
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['No network architecture deployed without formal security review and pen test sign-off','All network designs must eliminate single points of failure at the L3 layer and above','Disaster recovery failover must be tested at least annually via live exercise','Change management approval required for all production topology modifications','Network access credentials must rotate on a 90-day maximum cycle'],
'{"soc_code":"15-1241.00","definition_of_done":["Requirements document approved, capacity goals defined","Architecture approved — no single points of failure","Security controls active, pen test clean","All hardware online per design spec","DR failover completes within RTO, DR runbook signed off"],"compliance_standards":["NIST_SP_800-53","CIS_Controls","ISO_27001","ITIL_v4"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 6. Telecommunications Engineering Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All telecommunications deployments must comply with applicable FCC regulations','Signal coverage gaps must be documented and remediation planned before sign-off','Telecom systems carrying PHI or financial data must encrypt all transmissions','Disaster recovery plan must achieve defined RTO/RPO and be tested annually','Vendor contracts must include SLA provisions before any system dependency is created'],
'{"soc_code":"15-1241.01","definition_of_done":["Requirements approved, regulatory compliance confirmed","Design reviewed by engineering consultants","Systems pass all acceptance tests","All KPIs within spec, no coverage gaps","DR plan tested, RTO/RPO documented"],"compliance_standards":["FCC_Regulations","NIST_SP_800-53","TIA_Standards","ITU_Standards"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 7. Database Architects
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All database architecture decisions must be documented in Architecture Decision Records (ADRs)','No new database technology may be adopted without proof-of-concept and architecture review','Schemas must be normalized to 3NF minimum — denormalization requires written justification','Encryption at rest and in transit is mandatory for all databases handling PII or financial data','Capacity planning review must occur quarterly to prevent performance degradation'],
'{"soc_code":"15-1243.00","definition_of_done":["Architecture ADR approved by tech leadership","Standards ratified and published in team wiki","System live with P99 query within SLA","Certification benchmarks documented and within spec","Quarterly governance review held, capacity forecast current"],"compliance_standards":["SOC2","GDPR","NIST_SP_800-53","ISO_27001"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 8. Data Warehousing Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['No data may be loaded to the warehouse without passing automated quality validation (>= 98% score)','All ETL pipelines must have documented lineage and transformation logic before production deployment','PII data must be masked or tokenized in non-production warehouse environments','Pipeline failures must trigger automated alerts and be resolved within defined SLA','All schema changes require approval and versioned changelog entry before deployment'],
'{"soc_code":"15-1243.01","definition_of_done":["Source-to-target mapping approved","Schema design approved by data architect","ETL pipelines tested and within latency SLA","Data quality score >= 98%, all checks green","Data dictionary complete, changelog current"],"compliance_standards":["SOC2","GDPR","DAMA_DMBOK","ISO_8000"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 9. Network and Computer Systems Administrators
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All server and network changes require change management approval and documented rollback','Backup restore tests must be conducted monthly with results recorded','Privileged account access must be logged and reviewed quarterly','Antivirus signatures and OS patches must be applied within 30 days of release','P1 monitoring alerts must trigger on-call notification within 5 minutes'],
'{"soc_code":"15-1244.00","definition_of_done":["All systems online with health checks passing","Monitoring dashboard live with P1 alerting active","Incidents resolved within SLA, root cause documented","Access reviews current, no unauthorized accounts","Backup jobs error-free, monthly restore test passes"],"compliance_standards":["CIS_Benchmarks","NIST_SP_800-53","ISO_20000","ITIL_v4"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 10. Computer Programmers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['No code may be merged to main branch without passing automated tests and peer review','Code coverage must meet or exceed 75% for all new modules','Security vulnerabilities identified by SAST tools must be remediated before release','No hardcoded credentials or secrets permitted in any code repository','All production deployments must have a documented rollback procedure'],
'{"soc_code":"15-1251.00","definition_of_done":["Spec ambiguities resolved before implementation","Code compiles, all acceptance criteria met","Trial runs pass, edge cases documented","Zero known blocking bugs","Refactor passes all tests, no regressions","Documentation current, changelog updated"],"compliance_standards":["OWASP_Top_10","CWE_Top_25","NIST_SP_800-218"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 11. Software QA Analysts and Testers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['Zero critical or high severity defects may be open at release gate','Test coverage must reach 80% minimum before release recommendation is issued','All test results must be logged in the official test management tool — no informal testing','Performance testing is required before any release affecting high-traffic user paths','Regression suite must execute on every pull request via CI/CD pipeline'],
'{"soc_code":"15-1253.00","definition_of_done":["All requirements mapped to test conditions","Test plan approved by QA lead and product owner","Automated suite integrated into CI/CD","All test cases executed and results logged","All P1/P2 defects triaged within 24h","Release report published with go/no-go decision"],"compliance_standards":["ISO_29119","ISTQB_Standards","NIST_SP_800-53"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 12. Web and Digital Interface Designers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All designs must comply with WCAG 2.1 AA accessibility standards before handoff','No design assets may be handed off to development without stakeholder sign-off','All user research data must be anonymized and stored per GDPR requirements','Design system components must be reused before creating new custom components','Usability testing must be conducted on all major user flows before release'],
'{"soc_code":"15-1255.00","definition_of_done":["User research report delivered with personas documented","Design requirements approved by product owner","Prototype approved by client, all critical user flows validated","Implementation matches spec, cross-browser verified","Usability test KPIs trending positively"],"compliance_standards":["WCAG_2.1_AA","GDPR","W3C_Standards","ISO_9241"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 13. Video Game Designers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All game content must pass age-rating review (ESRB/PEGI) compliance check before submission','Core game loop must be validated via internal playtesting before full production begins','Design documents must be version-controlled — no verbal-only design decisions','All third-party assets must have verified licensing before integration','Player data collection must comply with COPPA if game targets under-13 audiences'],
'{"soc_code":"15-1255.01","definition_of_done":["Concept approved by creative director, core loop defined","GDD reviewed by engineering and art leads","Prototype passes internal fun bar","All missions in production-ready format","Balance metrics within target ranges","Stakeholder sign-off on final GDD"],"compliance_standards":["ESRB_Ratings","PEGI_Standards","COPPA","GDPR"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 14. Web Administrators
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['SSL/TLS certificates must be renewed minimum 30 days before expiration','All web server software and CMS plugins must be patched within 30 days of security release','Security monitoring alerts must be reviewed daily — no unreviewed P1 alerts older than 24h','Web access logs must be retained for minimum 90 days for forensic purposes','Content publishing workflow requires review and approval before going live'],
'{"soc_code":"15-1299.01","definition_of_done":["All systems on current versions, certificates valid","Security alerts reviewed daily, incidents reported within SLA","Backup verified restorable monthly","Zero P1 bugs in production","Access matrix documented, quarterly review complete"],"compliance_standards":["OWASP_Top_10","GDPR","CIS_Web_Server_Benchmarks","ISO_27001"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 15. GIS Technologists and Technicians
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All spatial data must be validated for correct coordinate reference system before loading','No GIS data containing PII may be published publicly without anonymization review','Source data provenance must be documented for all layers in production databases','Map products must include accuracy and uncertainty statements before delivery','Custom GIS applications must pass functional testing before client deployment'],
'{"soc_code":"15-1299.02","definition_of_done":["Data loaded with correct CRS, topology validated","Database passes topology check, metadata current","Analysis methodology documented and validated","Maps meet organizational style standards","Application tested and deployed with documentation"],"compliance_standards":["ISO_19115_Metadata","FGDC_Standards","GDPR","Section_508"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 16. Document Management Specialists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['Retention schedules must be followed — no documents deleted outside approved schedule','Access to sensitive classified documents restricted to authorized roles only','All document management system changes must maintain a complete audit trail','Records destruction must be authorized and documented per legal hold review','Regulatory compliance calendar must be reviewed monthly for upcoming obligations'],
'{"soc_code":"15-1299.03","definition_of_done":["Current-state compliance gaps identified and approved","Classification scheme approved by legal and IG teams","DMS deployed, audit trail active","Version control tested with no unauthorized overwrites","No overdue retention actions, compliance calendar current"],"compliance_standards":["ISO_15489","GDPR","HIPAA","SOX","DoD_5015.02"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 17. Penetration Testers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['Written signed authorization is mandatory before any testing begins — zero exceptions','Testing must stay strictly within the agreed scope — out-of-scope systems must never be touched','No production data may be exfiltrated during testing — simulated exfiltration only','All exploited vulnerabilities must be left in their pre-test state after engagement','Final report must be delivered within the agreed timeline and retained under NDA'],
'{"soc_code":"15-1299.04","definition_of_done":["Signed authorization and scope agreement obtained","Target profile complete within approved scope","All vulnerabilities documented with CVSS scores","Exploits executed within scope, systems restored to pre-test state","Report delivered with remediation guidance","All critical/high findings confirmed remediated in retest"],"compliance_standards":["PTES_Standard","OWASP_Testing_Guide","NIST_SP_800-115","EC-Council_CEH"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 18. Information Security Engineers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All security controls must pass validation testing before being considered effective','P1 security incidents must be acknowledged within 15 minutes and contained within 1 hour','Security architecture changes require CISO review and approval before implementation','Zero unmitigated critical findings at quarterly compliance audit — no exceptions','Encryption at rest and in transit is mandatory for all systems handling sensitive data'],
'{"soc_code":"15-1299.05","definition_of_done":["Architecture gaps documented with CVSS scores","Control design approved by CISO","SIEM ingesting all relevant log sources","All P1 incidents contained within SLA","Quarterly KPI report published, zero unmitigated critical findings","IR playbook published, tabletop exercise completed"],"compliance_standards":["NIST_CSF","SOC2_Type_II","ISO_27001","CIS_Controls","NIST_SP_800-53"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 19. Digital Forensics Analysts
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['Chain of custody documentation is mandatory for all digital evidence — no exceptions','Forensic images must be hash-verified immediately after acquisition and before analysis','Analysis must be conducted on forensic copies only — original evidence must never be modified','All investigation activities must be authorized by legal counsel or law enforcement directive','Findings reports must be reviewed by legal team before submission to any external party'],
'{"soc_code":"15-1299.06","definition_of_done":["Chain of custody form signed and evidence sealed","Forensic image hash verified against source","Findings documented with timestamps and artifacts","Full attack path reconstructed and mapped to MITRE ATT&CK","Investigation plan reviewed by legal before execution","Report reviewed by legal, evidence catalog complete"],"compliance_standards":["ACPO_Guidelines","NIST_SP_800-86","ISO_27037","FRE_Evidence_Standards","GDPR"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 20. Blockchain Engineers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All smart contracts must undergo formal security audit before mainnet deployment','Private keys must be managed using hardware security modules (HSM) — never stored in plaintext','All code must pass automated static analysis (Slither/MythX) with zero critical findings','Blockchain infrastructure must maintain 99.9% uptime — planned maintenance requires advance notice','Regulatory compliance (AML/KYC/FATF) must be verified before any token-related feature ships'],
'{"soc_code":"15-1299.07","definition_of_done":["Threat model complete, all risks mitigated in design","Smart contracts audited — no critical findings","Automated pipeline deploys to all nodes with rollback tested","Dashboard live with key metrics accessible","Audit report clean or critical issues remediated before ship"],"compliance_standards":["FATF_Guidelines","AML_KYC_Regulations","SOC2","NIST_CSF","ERC_Standards"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 21. Computer Systems Engineers/Architects
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All architectural decisions must be documented in ADRs before implementation begins','No new technology stack may be adopted in production without POC and architecture board approval','Systems must be designed for high availability with defined RTO/RPO targets from day one','Security architecture review is mandatory before any system handling PII or financial data goes live','Weekly operations reviews must occur — no P1 issues may go unreviewed for more than 24 hours'],
'{"soc_code":"15-1299.08","definition_of_done":["System requirements document approved, NFRs quantified","Technology decisions documented in ADRs, approved by board","Architecture document approved, security review passed","Integration tests pass, rollback plan documented","Security guidelines published and reviewed by CISO","Weekly ops review held, all P1s have active remediation plans"],"compliance_standards":["NIST_SP_800-53","TOGAF","ISO_27001","SOC2","CIS_Controls"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 22. IT Project Managers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['Project charter must be signed by sponsor before any resources are committed','Scope changes must go through formal change control — no verbal scope changes accepted','Risk register must be reviewed and updated at every weekly status meeting','All project deliverables must have documented acceptance criteria before work begins','Budget variances exceeding 10% must be escalated to steering committee immediately'],
'{"soc_code":"15-1299.09","definition_of_done":["Project charter signed, kickoff scheduled","Project plan baselined, critical path identified","Project within 10% of baseline schedule/budget","All P1 issues have owners and resolution dates","Stakeholder satisfaction tracked, change requests through formal process","All deliverables accepted, lessons learned published"],"compliance_standards":["PMI_PMBOK","PRINCE2","ISO_21502","Agile_Manifesto"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 23. Actuaries
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All actuarial analyses must be reviewed and signed off by a credentialed actuary (FSA/FCAS)','Assumptions must be documented and actuarially justified before being used in any model','Premium and reserve calculations must be peer-reviewed before regulatory filing','Data used in models must be audited for completeness and consistency before use','Actuarial opinions must comply with applicable Actuarial Standards of Practice (ASOPs)'],
'{"soc_code":"15-2011.00","definition_of_done":["Analysis scope approved by appointed actuary","Data validated, quality report filed","Model peer-reviewed by fellow actuary","Calculations signed off by chief actuary, filed if required","Product approved by actuarial committee","Report delivered on schedule, questions answered"],"compliance_standards":["ASOP_Standards","SOX","NAIC_Guidelines","IFRS_17","Solvency_II"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 24. Mathematicians
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All research must cite sources accurately and avoid plagiarism per academic standards','Data sets used must be licensed for intended research use — no unauthorized data usage','Human subjects research requires IRB approval before any data collection begins','Mathematical models applied to high-stakes decisions must document assumptions and limitations','Computational results must be reproducible — code and data must be archived with publications'],
'{"soc_code":"15-2021.00","definition_of_done":["Research question formulated with clear success criteria","Mathematical framework internally consistent, lemmas proven","Numerical results consistent with theory, code reproducible","Applied model validated against real-world data","Paper submitted or published, presentation delivered","Mentees demonstrate improved proficiency"],"compliance_standards":["AMS_Ethics","IEEE_Ethics","IRB_Protocol","NIST_Standards","Academic_Integrity_Policy"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 25. Operations Research Analysts
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All model assumptions must be documented and validated before recommendations are made','Sensitivity analysis is required for all high-stakes operational recommendations','Data used in models must be verified against authoritative source systems before use','Recommendations must include quantified uncertainty ranges — point estimates alone are insufficient','Model code must be version-controlled and reproducible for audit purposes'],
'{"soc_code":"15-2031.00","definition_of_done":["Problem formally scoped, decision variables and constraints agreed","Dataset validated, assumptions documented","Model calibrated, validation metrics meet thresholds","Model passes scenario tests, sensitivity report complete","Recommendations quantified with projected ROI","Post-implementation KPIs tracked against projections"],"compliance_standards":["INFORMS_Ethics","ISO_9001","PMI_Standards","NIST_SP_800-53"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 26. Statisticians
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['Statistical methods must be pre-specified before data collection — no post-hoc method selection','All analyses must report effect sizes and confidence intervals alongside p-values','Human subjects data must be anonymized per IRB protocol before statistical analysis','Reproducibility package (code + data) must be archived with all published analyses','Multiple comparison corrections must be applied when testing multiple hypotheses'],
'{"soc_code":"15-2041.00","definition_of_done":["Study design peer-reviewed, power analysis complete","Clean dataset documented, preparation script saved","Method selection justified with assumptions documented","Analysis complete, effect sizes and CIs reported","Report reviewed by stakeholder, visualizations accurate","Methodology validated by independent reviewer"],"compliance_standards":["ASA_Ethical_Guidelines","IRB_Protocol","FDA_Statistical_Guidance","ICH_E9","GDPR"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 27. Biostatisticians
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['Statistical Analysis Plan must be finalized before database lock — no exceptions','All changes to the SAP after first patient enrolled must be documented as protocol amendments','Database lock requires sign-off from biostatistician, data manager, and clinical lead','Analysis must be conducted by unblinded statisticians only after formal unblinding procedure','Regulatory submissions must comply with ICH E9(R1) estimand framework'],
'{"soc_code":"15-2041.01","definition_of_done":["Protocol IRB approved, randomization scheme documented","Sample size calculation reviewed by PI and stat lead","SAP finalized before database lock, signed by lead biostatistician","QC passed by independent programmer, output tables finalized","Conclusions aligned with pre-specified SAP","Annual methodology development goals met"],"compliance_standards":["ICH_E6_GCP","ICH_E9_R1","FDA_21_CFR_Part_11","EMA_Guidelines","GDPR"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 28. Data Scientists
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['No ML model may be deployed to production without bias audit and fairness assessment','Training data must be documented with provenance, version, and known limitations','Models must be monitored for data drift and performance degradation post-deployment','Experiments must be tracked in a versioned experiment registry — no undocumented experiments','Models making high-stakes decisions (credit, hiring, healthcare) require human-in-the-loop review'],
'{"soc_code":"15-2051.00","definition_of_done":["Problem framed with quantifiable success criteria","Clean dataset versioned, no data leakage confirmed","Model exceeds baseline metrics, cross-validation documented","Model passes validation tests, fairness audit complete","Visualizations reviewed and unambiguous","Model in production with monitoring dashboard live, retraining trigger defined"],"compliance_standards":["NIST_AI_RMF","EU_AI_Act","GDPR","ISO_42001","IEEE_Ethically_Aligned_Design"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 29. Business Intelligence Analysts
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All BI reports must be validated against source system data before distribution','Row-level security must be implemented to prevent unauthorized data access in dashboards','No PII may appear in BI dashboards without explicit data governance approval','Pipeline failures must trigger automated alerts within 15 minutes of occurrence','All BI deliverables must have documented data definitions and business rules'],
'{"soc_code":"15-2051.01","definition_of_done":["Requirements signed off, data source access confirmed","Data model reviewed by architect, performance tested","Dashboard validated against source systems, SLA met","Trend analysis delivered with actionable recommendations","All pipelines green, version changelog current","P1 support tickets resolved within SLA"],"compliance_standards":["SOC2","GDPR","DAMA_DMBOK","ISO_8000","CCPA"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 30. Clinical Data Managers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['Database must not be locked until all critical queries are resolved — zero open critical queries at lock','All clinical data systems must comply with FDA 21 CFR Part 11 for electronic records','Data Management Plan must be approved before first patient enrolled','No external data transfer without sponsor authorization and encrypted transfer protocol','Audit trail must be active and immutable for all EDC systems throughout the study'],
'{"soc_code":"15-2051.02","definition_of_done":["Database UAT complete, sponsor approved before FPI","DMP approved before study start","Data current within SLA, no outstanding critical errors","Open query rate below 5%, critical queries resolved before lock","Compliance metrics within thresholds, no open CAPAs","Database locked per SOP, transfer package delivered within 5 days"],"compliance_standards":["ICH_E6_GCP","FDA_21_CFR_Part_11","EMA_Annex_11","GDPR","CDISC_Standards"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- 31. Bioinformatics Technicians
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES (
ARRAY['All biological data must be stored in compliant repositories with appropriate access controls','Analysis pipelines must be version-controlled and reproducible — no ad-hoc undocumented analyses','Human genomic data handling must comply with applicable privacy regulations (GDPR, HIPAA, dbGaP)','Data integrity checksums must be verified on all downloaded datasets before use','Research data must be retained for minimum 5 years per institutional policy'],
'{"soc_code":"15-2099.01","definition_of_done":["Datasets downloaded with provenance and checksums verified","All samples meet minimum QC thresholds, failed samples flagged","Analysis results reproducible, methods documented in script","Extended tools version-controlled, unit tested","Biological database current, backup verified monthly","Annual development goals met, new method integrated into workflows"],"compliance_standards":["GDPR","HIPAA","dbGaP_Policy","NIH_Data_Sharing_Policy","FAIR_Principles"]}'::jsonb,
'2026-03-31T00:00:00Z');

-- merged from sal_finance_legal_seed_part2.sql
-- ============================================================
-- SAL Registry v1.0 — FINANCE + LEGAL CLUSTERS
-- Part 2 of 4: agent_logic — Finance Roles 1–25 (13-1xxx)
-- All step_by_step_json: 6-step MCP tool-call arrays
-- ============================================================

-- ── 1. Agents and Business Managers of Artists (13-1011.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Represent and manage the business, financial, and contractual affairs of artists, performers, and athletes to maximize career opportunities and earnings.',
'[
  {"step":1,"type":"tool_use","name":"evaluate_talent_and_market","description":"Assess client''s commercial value, brand potential, and current market demand across target industries","input":{"action":"market_analysis","tools":["Bloomberg","Salesforce","Microsoft_Excel"],"outputs":["talent_assessment","market_positioning_report"]},"definition_of_done":"Client profile and market positioning report approved by client"},
  {"step":2,"type":"tool_use","name":"negotiate_contracts","description":"Negotiate terms for performance, endorsement, recording, or appearance contracts on behalf of clients","input":{"action":"contract_negotiation","tools":["Adobe_Acrobat","DocuSign","LexisNexis","Microsoft_Word"],"scope":["fee_structure","IP_rights","exclusivity","performance_clauses"]},"definition_of_done":"Contract executed with terms within client''s approved parameters"},
  {"step":3,"type":"tool_use","name":"manage_finances","description":"Oversee client financial accounts, track earnings, and coordinate with accountants on tax obligations","input":{"action":"financial_management","tools":["QuickBooks","Microsoft_Excel","SAP"],"reports":["earnings_statement","expense_report","tax_estimate"]},"definition_of_done":"Monthly financial summary delivered, no outstanding invoices > 30 days"},
  {"step":4,"type":"tool_use","name":"develop_career_strategy","description":"Plan and coordinate promotional activities, appearances, and career development opportunities","input":{"action":"strategic_planning","tools":["Microsoft_Project","Outlook","Salesforce","PowerPoint"],"artifacts":["12_month_career_plan","opportunity_pipeline"]},"definition_of_done":"Career strategy approved by client, key opportunities scheduled"},
  {"step":5,"type":"tool_use","name":"manage_stakeholder_relationships","description":"Maintain relationships with promoters, labels, studios, sponsors, and booking agencies","input":{"action":"relationship_management","tools":["Salesforce","Outlook","Zoom","Microsoft_Teams"],"frequency":"weekly_outreach_log"},"definition_of_done":"Relationship log current, no active opportunities going dark > 14 days"},
  {"step":6,"type":"tool_use","name":"resolve_disputes_and_compliance","description":"Address contract disputes, protect intellectual property rights, and ensure regulatory compliance","input":{"action":"dispute_resolution","tools":["LexisNexis","Adobe_Acrobat","DocuSign","Microsoft_Word"],"resources":["entertainment_lawyer","IP_counsel"]},"definition_of_done":"Disputes resolved or referred to legal counsel, compliance issues remediated"}
]'::jsonb,
ARRAY['Salesforce','Adobe Acrobat','DocuSign','LexisNexis','QuickBooks','SAP','Microsoft Excel','Microsoft Word','Microsoft Project','Microsoft Teams','Outlook','Zoom','PowerPoint']
);

-- ── 2. Wholesale and Retail Buyers (13-1022.00) ──────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Purchase merchandise for wholesale or retail sale by analyzing market trends, evaluating suppliers, negotiating contracts, and managing inventory to maximize profitability.',
'[
  {"step":1,"type":"tool_use","name":"analyze_market_and_trends","description":"Research consumer trends, competitive pricing, and product demand to inform purchasing decisions","input":{"action":"market_research","tools":["Nielsen","IBISWorld","Tableau","Microsoft_Excel"],"outputs":["trend_report","demand_forecast","competitive_analysis"]},"definition_of_done":"Category trend report published, purchasing plan aligned with sales forecast"},
  {"step":2,"type":"tool_use","name":"evaluate_and_select_suppliers","description":"Assess vendor capability, quality, pricing, and reliability through RFQ processes","input":{"action":"vendor_evaluation","tools":["SAP_SRM","Oracle_Procurement","Microsoft_Excel"],"criteria":["price","quality","lead_time","financial_stability","sustainability"]},"definition_of_done":"Vendor scorecard completed, preferred supplier list approved by category manager"},
  {"step":3,"type":"tool_use","name":"negotiate_purchase_contracts","description":"Negotiate pricing, payment terms, delivery schedules, and return policies with suppliers","input":{"action":"contract_negotiation","tools":["SAP","DocuSign","Microsoft_Word","Adobe_Acrobat"],"targets":["cost_reduction","payment_terms","exclusivity_clauses"]},"definition_of_done":"Contract executed with target margins met, terms documented in procurement system"},
  {"step":4,"type":"tool_use","name":"manage_purchase_orders","description":"Create and track purchase orders through the procurement-to-payment cycle","input":{"action":"order_management","tools":["SAP_MM","Oracle_ERP","QuickBooks"],"kpis":{"on-time_delivery_pct":95,"fill_rate_pct":98}},"definition_of_done":"All POs confirmed with delivery dates, exceptions escalated within 24 hours"},
  {"step":5,"type":"tool_use","name":"monitor_inventory_performance","description":"Review stock levels, turnover rates, and slow-moving items to optimize inventory investment","input":{"action":"inventory_analysis","tools":["Tableau","Power_BI","SAP_EWM","Microsoft_Excel"],"metrics":["inventory_turnover","days_on_hand","sell-through_rate"]},"definition_of_done":"Monthly inventory report published, markdowns or reorders initiated within SLA"},
  {"step":6,"type":"tool_use","name":"manage_returns_and_compliance","description":"Handle supplier returns, quality disputes, and ensure compliance with import/trade regulations","input":{"action":"returns_and_compliance","tools":["SAP","Customs_management_software","Microsoft_Excel"],"frameworks":["CBP_compliance","trade_agreements","product_safety_standards"]},"definition_of_done":"All returns processed within 30 days, no outstanding compliance violations"}
]'::jsonb,
ARRAY['SAP','Oracle ERP','Tableau','Power BI','Microsoft Excel','QuickBooks','DocuSign','Adobe Acrobat','Microsoft Word','Salesforce','Nielsen','Microsoft Project','Microsoft Teams']
);

-- ── 3. Purchasing Agents (13-1023.00) ────────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Purchase goods, materials, equipment, and services for organizational use by evaluating bids, negotiating with vendors, and managing the procurement lifecycle.',
'[
  {"step":1,"type":"tool_use","name":"identify_procurement_needs","description":"Gather purchase requisitions and verify specifications, budget authority, and business need","input":{"action":"requisition_review","tools":["SAP_MM","Oracle_Procurement","ServiceNow"],"checks":["budget_availability","specification_completeness","approval_hierarchy"]},"definition_of_done":"Requisition validated, budget confirmed, purchase approved per delegation of authority"},
  {"step":2,"type":"tool_use","name":"source_and_solicit_bids","description":"Research potential vendors, issue RFQs/RFPs, and collect competitive bids","input":{"action":"sourcing","tools":["SAP_SRM","Ariba","Jaggaer","Microsoft_Excel"],"methods":["public_tender","invited_bid","sole_source_justification"]},"definition_of_done":"Minimum 3 competitive bids received (or sole-source justified and documented)"},
  {"step":3,"type":"tool_use","name":"evaluate_and_award","description":"Evaluate bids on price, quality, delivery, and compliance criteria; award to best-value supplier","input":{"action":"bid_evaluation","tools":["Microsoft_Excel","SAP","Tableau"],"scoring":["price_40pct","quality_30pct","delivery_20pct","compliance_10pct"]},"definition_of_done":"Award recommendation documented, reviewed and approved by procurement authority"},
  {"step":4,"type":"tool_use","name":"execute_purchase_order","description":"Issue purchase orders with accurate specifications, pricing, and delivery terms","input":{"action":"PO_execution","tools":["SAP_MM","Oracle_ERP","QuickBooks"],"required_fields":["vendor_info","itemized_specs","price","delivery_date","payment_terms"]},"definition_of_done":"PO issued, vendor acknowledgment received within 48 hours"},
  {"step":5,"type":"tool_use","name":"monitor_and_expedite","description":"Track order status, expedite overdue deliveries, and resolve quality or delivery disputes","input":{"action":"order_tracking","tools":["SAP","Outlook","Excel","ServiceNow"],"escalation_sla_days":3},"definition_of_done":"All orders within lead time tolerance, expedite actions documented with resolution dates"},
  {"step":6,"type":"tool_use","name":"close_and_audit","description":"Process invoices, close purchase orders, and maintain procurement records for audit compliance","input":{"action":"PO_closeout","tools":["SAP_FI","Oracle_AP","Microsoft_Excel","SharePoint"],"compliance":["three_way_match","audit_trail","retention_policy"]},"definition_of_done":"Three-way match confirmed, PO closed, records archived per retention schedule"}
]'::jsonb,
ARRAY['SAP MM','SAP SRM','Oracle Procurement','Ariba','Jaggaer','QuickBooks','Microsoft Excel','ServiceNow','Adobe Acrobat','DocuSign','Tableau','Microsoft Project','Microsoft Teams','Outlook']
);

-- ── 4. Claims Adjusters, Examiners, and Investigators (13-1031.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Investigate, evaluate, and settle insurance claims by verifying coverage, assessing damage or liability, and recommending appropriate payments or denials.',
'[
  {"step":1,"type":"tool_use","name":"intake_and_coverage_review","description":"Receive new claim, examine policy documents, and verify insurance coverage and applicability","input":{"action":"coverage_analysis","tools":["ClaimsPro","Microsoft_Excel","Microsoft_Word"],"checks":["policy_terms","coverage_limits","deductible","exclusions"]},"definition_of_done":"Coverage determination documented, claim accepted or denied with written rationale"},
  {"step":2,"type":"tool_use","name":"investigate_claim","description":"Review police reports, medical records, property damage assessments, and interview relevant parties","input":{"action":"investigation","tools":["Xactimate","Colossus","WinSMAC","Zoom"],"methods":["document_review","field_inspection","witness_interview","fraud_flag_analysis"]},"definition_of_done":"Investigation report complete with supporting evidence, fraud indicators noted if applicable"},
  {"step":3,"type":"tool_use","name":"assess_damages_and_liability","description":"Calculate extent of damages or loss and determine degree of insurer liability","input":{"action":"damage_assessment","tools":["Xactimate","CCC_EZNet","Microsoft_Excel","fraud_detection_systems"],"outputs":["damage_estimate","liability_determination","reserve_recommendation"]},"definition_of_done":"Damage assessment documented, reserve amount set in claims system"},
  {"step":4,"type":"tool_use","name":"negotiate_settlement","description":"Negotiate settlement amount with claimants, attorneys, or public adjusters within authority limits","input":{"action":"settlement_negotiation","tools":["ClaimsPro","OnBase","Microsoft_Word","DocuSign"],"authority_limit":"per_delegation_matrix"},"definition_of_done":"Settlement agreed and documented, or claim escalated to supervisor if beyond authority"},
  {"step":5,"type":"tool_use","name":"process_payment","description":"Authorize and process claim payment within designated authority levels and verify procedural compliance","input":{"action":"payment_processing","tools":["ClaimsPro","SAP","QuickBooks","Microsoft_Excel"],"controls":["fraud_check","duplicate_detection","three_way_validation"]},"definition_of_done":"Payment issued within SLA, all controls passed, payment recorded in claims system"},
  {"step":6,"type":"tool_use","name":"document_and_close_claim","description":"Complete final documentation, close the claim file, and report outcomes for trend analysis","input":{"action":"claim_closure","tools":["ClaimsPro","OnBase","Microsoft_Office","Tableau"],"reports":["closed_claim_summary","cycle_time_metrics","recovery_amounts"]},"definition_of_done":"Claim closed in system, all documents archived, metrics reported to management"}
]'::jsonb,
ARRAY['ClaimsPro','Xactimate','Colossus','WinSMAC','CCC EZNet','OnBase','CSC Automated Work Distributor','PCG Virtual Examiner','SAP','QuickBooks','DocuSign','Microsoft Excel','Microsoft Word','Microsoft Office','Zoom','Tableau']
);

-- ── 5. Compliance Officers (13-1041.00) ──────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Examine and enforce compliance with laws, regulations, and organizational policies to ensure lawful operations and protect the organization from legal and regulatory risk.',
'[
  {"step":1,"type":"tool_use","name":"map_regulatory_landscape","description":"Identify applicable laws, regulations, and industry standards governing the organization''s operations","input":{"action":"regulatory_mapping","tools":["CDLIS","LexisNexis","Microsoft_Access","Excel"],"outputs":["regulatory_inventory","compliance_calendar","gap_analysis"]},"definition_of_done":"Regulatory inventory current, all applicable regulations identified and owners assigned"},
  {"step":2,"type":"tool_use","name":"evaluate_applications_and_records","description":"Review applications, records, licenses, and documents to assess eligibility and compliance","input":{"action":"document_review","tools":["Microsoft_Access","SharePoint","Adobe_Acrobat","Outlook"],"checks":["completeness","accuracy","regulatory_conformance"]},"definition_of_done":"Review completed within SLA, findings documented with citation to applicable regulation"},
  {"step":3,"type":"tool_use","name":"conduct_compliance_audit","description":"Perform audits of operational processes and records against regulatory and policy standards","input":{"action":"audit","tools":["Microsoft_Excel","PowerPoint","Access","audit_management_software"],"scope":["process_walkthroughs","document_testing","transaction_sampling"]},"definition_of_done":"Audit report issued, all findings rated by risk level, management response obtained"},
  {"step":4,"type":"tool_use","name":"address_violations","description":"Warn violators of infractions, issue corrective action notices, and escalate as required","input":{"action":"enforcement","tools":["Microsoft_Word","DocuSign","SharePoint","Outlook"],"process":["verbal_warning","written_notice","regulatory_referral","escalation_to_legal"]},"definition_of_done":"All open violations have documented actions, CAP deadlines tracked and monitored"},
  {"step":5,"type":"tool_use","name":"prepare_regulatory_reports","description":"Prepare and file required regulatory reports with government agencies and internal leadership","input":{"action":"reporting","tools":["Microsoft_Excel","PowerPoint","Word","SharePoint"],"reports":["regulatory_filing","board_compliance_report","annual_compliance_summary"]},"definition_of_done":"Reports filed on time, no late filings, copies archived per retention policy"},
  {"step":6,"type":"tool_use","name":"advise_and_train","description":"Advise staff on regulatory requirements and conduct compliance training programs","input":{"action":"advisory_and_training","tools":["Microsoft_PowerPoint","LMS","Outlook","Zoom","Teams"],"coverage":["onboarding_training","regulatory_updates","case_studies"]},"definition_of_done":"Training completion rate >= 100% for mandatory programs, advisory questions answered within SLA"}
]'::jsonb,
ARRAY['CDLIS','LexisNexis','Microsoft Access','Microsoft Excel','SharePoint','Adobe Acrobat','DocuSign','Outlook','Tableau','Power BI','Zoom','Microsoft Teams','SAP','PowerPoint']
);

-- ── 6. Regulatory Affairs Specialists (13-1041.07) ───────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Coordinate regulatory documentation, submissions, and compliance strategy to obtain and maintain product approvals from domestic and international regulatory authorities.',
'[
  {"step":1,"type":"tool_use","name":"interpret_regulatory_requirements","description":"Research and interpret applicable regulatory rules and guidance documents for target markets","input":{"action":"regulatory_intelligence","tools":["FDA_website","EMA_portal","LexisNexis","SharePoint"],"outputs":["regulatory_pathway_analysis","submission_strategy_document"]},"definition_of_done":"Submission strategy reviewed and approved by regulatory leadership"},
  {"step":2,"type":"tool_use","name":"prepare_regulatory_submissions","description":"Coordinate and prepare regulatory submissions including dossiers, 510(k)s, or CTDs","input":{"action":"dossier_preparation","tools":["Microsoft_Word","Excel","Adobe_Acrobat","Veeva_Vault"],"frameworks":["CTD_format","eCTD","FDA_21_CFR","EU_MDR"]},"definition_of_done":"Submission package complete, quality checked, approved for filing by RAhead"},
  {"step":3,"type":"tool_use","name":"communicate_with_agencies","description":"Respond to agency queries, attend meetings, and maintain productive regulatory relationships","input":{"action":"agency_liaison","tools":["Outlook","Microsoft_Teams","Zoom","FDA_CDER_portal"],"correspondence_types":["deficiency_responses","clarification_meetings","annual_reports"]},"definition_of_done":"All agency queries responded to within specified timeframe, correspondence archived"},
  {"step":4,"type":"tool_use","name":"maintain_technical_files","description":"Maintain regulatory dossiers, product technical files, and approval documentation in compliance","input":{"action":"document_control","tools":["Veeva_Vault","SharePoint","Microsoft_Word","Adobe_Acrobat"],"standards":["ISO_13485","21_CFR_Part_820","EU_MDR_Article_10"]},"definition_of_done":"All technical files complete, version-controlled, and audit-ready at all times"},
  {"step":5,"type":"tool_use","name":"monitor_and_interpret_rule_changes","description":"Track regulatory rule changes and assess impact on products and corporate compliance posture","input":{"action":"regulatory_surveillance","tools":["Federal_Register","EMA_eSubmission","LexisNexis","Excel"],"frequency":"weekly_scan_monthly_impact_assessment"},"definition_of_done":"Impact assessment distributed within 5 business days of material rule change"},
  {"step":6,"type":"tool_use","name":"train_internal_teams","description":"Educate product, engineering, and quality teams on regulatory requirements applicable to their work","input":{"action":"internal_training","tools":["PowerPoint","Zoom","LMS","SharePoint"],"deliverables":["training_deck","job_aid","regulatory_FAQ"]},"definition_of_done":"Training delivered to all affected teams, completion documented, materials archived in DMS"}
]'::jsonb,
ARRAY['Microsoft Excel','Microsoft Word','Microsoft PowerPoint','Adobe Acrobat','SharePoint','Veeva Vault','Outlook','Microsoft Project','SQL','Microsoft Access','LexisNexis','Zoom','Microsoft Teams']
);

-- ── 7. Cost Estimators (13-1051.00) ──────────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Prepare accurate time, cost, materials, and labor estimates for manufacturing, construction, or service projects to support bidding, pricing, and project planning decisions.',
'[
  {"step":1,"type":"tool_use","name":"analyze_project_documentation","description":"Review blueprints, specifications, SOWs, and technical documents to understand project scope","input":{"action":"document_analysis","tools":["AutoCAD","Revit","Adobe_Acrobat","Microsoft_Word"],"outputs":["scope_checklist","clarification_questions","quantity_takeoff_draft"]},"definition_of_done":"All documents reviewed, open questions submitted to engineering or owner"},
  {"step":2,"type":"tool_use","name":"perform_quantity_takeoff","description":"Calculate material quantities, labor hours, and equipment requirements from project drawings","input":{"action":"quantity_takeoff","tools":["Microsoft_Excel","ProEst","WinEstimator","AutoCAD"],"methods":["plan_measurement","digital_takeoff","BIM_extraction"]},"definition_of_done":"Quantity takeoff complete, reviewed against scope checklist for completeness"},
  {"step":3,"type":"tool_use","name":"develop_cost_model","description":"Apply unit rates, historical cost data, and escalation factors to build detailed cost estimate","input":{"action":"cost_modeling","tools":["CPR_Visual_Estimator","PRICE_Systems","Microsoft_Excel","Primavera"],"data_sources":["historical_projects","vendor_quotes","RSMeans","COCOMO"]},"definition_of_done":"Cost model built, peer-reviewed by senior estimator, within ±10% of target accuracy"},
  {"step":4,"type":"tool_use","name":"confer_with_stakeholders","description":"Discuss estimate assumptions and changes with engineers, architects, and subcontractors","input":{"action":"stakeholder_review","tools":["Microsoft_Project","Outlook","Zoom","Teams"],"outputs":["change_log","assumption_register","revised_estimate"]},"definition_of_done":"All stakeholder comments resolved, revised estimate issued with change log"},
  {"step":5,"type":"tool_use","name":"assess_cost_effectiveness","description":"Evaluate cost effectiveness of design alternatives and recommend value engineering opportunities","input":{"action":"value_engineering","tools":["Microsoft_Excel","Tableau","PRICE_Systems"],"analysis":["design_alternative_comparison","lifecycle_cost_analysis","ROI_analysis"]},"definition_of_done":"VE recommendations documented with cost/benefit rationale, presented to owner"},
  {"step":6,"type":"tool_use","name":"finalize_and_submit_estimate","description":"Prepare final estimate report for bid submission, contract award, or project budgeting","input":{"action":"report_finalization","tools":["Microsoft_Excel","Word","PowerPoint","Primavera"],"deliverables":["bid_tabulation","cost_summary","basis_of_estimate","risk_contingency"]},"definition_of_done":"Final estimate signed off by estimating manager, submitted on time with all required documents"}
]'::jsonb,
ARRAY['Microsoft Excel','AutoCAD','Revit','Microsoft Project','Oracle Primavera','ProEst','WinEstimator','CPR Visual Estimator','PRICE Systems','Adobe Acrobat','RSMeans','Microsoft Word','PowerPoint','Tableau']
);

-- ── 8. Human Resources Specialists (13-1071.00) ──────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Recruit, screen, and place employees while administering HR programs and ensuring compliance with employment laws and organizational policies.',
'[
  {"step":1,"type":"tool_use","name":"define_hiring_requirements","description":"Collaborate with hiring managers to develop job descriptions, requirements, and sourcing strategy","input":{"action":"job_analysis","tools":["Workday","Oracle_Taleo","Microsoft_Word","SharePoint"],"artifacts":["job_description","competency_profile","sourcing_plan"]},"definition_of_done":"Job description approved by manager and HR leadership, requisition opened in ATS"},
  {"step":2,"type":"tool_use","name":"source_and_screen_candidates","description":"Post positions, source passive candidates, and screen applicants against requirements","input":{"action":"sourcing_and_screening","tools":["Oracle_Taleo","LinkedIn","ADP_Workforce","Microsoft_Outlook"],"methods":["job_boards","employee_referral","social_recruiting","university_partnerships"]},"definition_of_done":"Qualified candidate shortlist of 3–5 presented to hiring manager within agreed SLA"},
  {"step":3,"type":"tool_use","name":"conduct_interviews_and_assessments","description":"Coordinate and conduct behavioral interviews and skills assessments","input":{"action":"interviewing","tools":["Zoom","Microsoft_Teams","Workday","HireVue"],"frameworks":["STAR_method","structured_interview_guides","assessment_rubrics"]},"definition_of_done":"Candidate scorecards completed for all interviewers, hiring recommendation documented"},
  {"step":4,"type":"tool_use","name":"process_hiring_and_onboarding","description":"Extend offers, complete background checks, and process all hiring documentation","input":{"action":"offer_and_onboarding","tools":["ADP","Workday","DocuSign","SharePoint","SAP"],"checks":["background_check","I-9_verification","reference_check"]},"definition_of_done":"Offer accepted, all pre-employment checks clear, onboarding tasks assigned in HRIS"},
  {"step":5,"type":"tool_use","name":"maintain_employment_records","description":"Maintain current and accurate employee records in HRIS in compliance with legal requirements","input":{"action":"records_management","tools":["ADP_Workforce","Oracle_PeopleSoft","SAP_HR","Microsoft_SQL_Server"],"compliance":["EEO","FLSA","FMLA","state_law"]},"definition_of_done":"All records complete and current, audit-ready, retention schedule followed"},
  {"step":6,"type":"tool_use","name":"address_employee_relations","description":"Investigate workplace complaints, advise on policy interpretation, and resolve employee relations issues","input":{"action":"employee_relations","tools":["ServiceNow","Workday","Outlook","Confluence"],"issues":["harassment_complaints","work_complaints","policy_questions","disciplinary_actions"]},"definition_of_done":"All open cases resolved or escalated within defined SLA, outcomes documented per policy"}
]'::jsonb,
ARRAY['Workday','Oracle Taleo','ADP Workforce Now','SAP HR','Oracle PeopleSoft','TempWorks','Tableau','QlikView','IBM SPSS Statistics','SAS','Microsoft SQL Server','Oracle Database','Microsoft Office','Zoom','Cisco Webex','Slack','SharePoint','DocuSign','HireVue','ServiceNow']
);

-- ── 9. Logisticians (13-1081.00) ──────────────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Analyze and coordinate logistical functions across the product lifecycle from acquisition through distribution to ensure efficient, cost-effective supply chain operations.',
'[
  {"step":1,"type":"tool_use","name":"assess_logistics_requirements","description":"Analyze business needs and design logistics solutions covering transportation, warehousing, and distribution","input":{"action":"logistics_design","tools":["SAP_TM","Oracle_SCM","AutoCAD","Visio"],"outputs":["logistics_network_design","cost_model","service_level_matrix"]},"definition_of_done":"Logistics plan approved by supply chain leadership, cost targets defined"},
  {"step":2,"type":"tool_use","name":"manage_procurement_and_sourcing","description":"Create proposals with detailed documentation and cost estimates for logistics services","input":{"action":"sourcing","tools":["SAP","Oracle_Procurement","Microsoft_Project","Primavera"],"scope":["carrier_selection","3PL_evaluation","freight_contracts"]},"definition_of_done":"Preferred carrier/3PL contracts executed, rate cards in ERP system"},
  {"step":3,"type":"tool_use","name":"coordinate_inventory_and_distribution","description":"Direct allocation and availability of materials, supplies, and finished products across the network","input":{"action":"inventory_coordination","tools":["SAP_EWM","Oracle_WMS","QuickBooks","Microsoft_Excel"],"kpis":{"inventory_accuracy_pct":99,"fill_rate_pct":98,"order_cycle_time_days":2}},"definition_of_done":"Inventory levels within plan, fill rate and cycle time KPIs met"},
  {"step":4,"type":"tool_use","name":"manage_subcontractors","description":"Oversee subcontractor performance and serve as liaison between vendors and the organization","input":{"action":"vendor_management","tools":["Salesforce","SAP","Outlook","Microsoft_Project"],"cadence":"weekly_performance_review"},"definition_of_done":"Subcontractor scorecards current, all SLA breaches addressed within 48 hours"},
  {"step":5,"type":"tool_use","name":"monitor_performance_metrics","description":"Review logistics performance metrics against targets, SLAs, and service agreements","input":{"action":"performance_monitoring","tools":["Tableau","Power_BI","SAP_Analytics","Microsoft_Excel"],"metrics":["on-time_delivery","cost_per_unit","transit_time","damage_rate"]},"definition_of_done":"Monthly KPI dashboard published, root cause analysis complete for all SLA misses"},
  {"step":6,"type":"tool_use","name":"ensure_compliance_and_develop_customers","description":"Maintain positive customer relationships and ensure compliance with import/export regulations","input":{"action":"compliance_and_CRM","tools":["Salesforce","LexisNexis","SAP_GTS","Microsoft_Project","Visio"],"regulations":["CBP","ITAR","EAR","IATA_DGR"]},"definition_of_done":"Customer satisfaction scores within target, no outstanding regulatory violations"}
]'::jsonb,
ARRAY['SAP TM','SAP EWM','Oracle SCM','Oracle WMS','QuickBooks','AutoCAD','Microsoft Project','Oracle Primavera','Microsoft Excel','Tableau','Power BI','Salesforce','Microsoft Access','SQL Server','SharePoint','Outlook']
);

-- ── 10. Project Management Specialists (13-1082.00) ───────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Analyze and coordinate the schedule, timeline, procurement, staffing, and budget of projects to deliver defined outcomes on time, within scope, and within budget.',
'[
  {"step":1,"type":"tool_use","name":"define_project_scope","description":"Communicate with stakeholders to determine project requirements, objectives, and success criteria","input":{"action":"scope_definition","tools":["Atlassian_JIRA","Confluence","Microsoft_Project","Teams"],"artifacts":["project_charter","scope_statement","stakeholder_register"]},"definition_of_done":"Scope document signed off by sponsor and key stakeholders"},
  {"step":2,"type":"tool_use","name":"develop_project_plan","description":"Build comprehensive project plan covering schedule, budget, resources, and risk register","input":{"action":"planning","tools":["Microsoft_Project","Oracle_Primavera","Asana","Microsoft_Excel"],"artifacts":["WBS","Gantt_chart","resource_plan","budget_baseline","risk_register"]},"definition_of_done":"Project plan baselined, critical path identified, all dependencies mapped"},
  {"step":3,"type":"tool_use","name":"execute_and_coordinate","description":"Plan, schedule, and coordinate project activities to meet milestones and deliverables","input":{"action":"execution","tools":["JIRA","Teams","Slack","Zoom","Cisco_Webex","PowerPoint"],"cadence":["daily_standup","weekly_status","monthly_steering"]},"definition_of_done":"Project tracking current, milestones met within 5% schedule variance"},
  {"step":4,"type":"tool_use","name":"monitor_budget","description":"Track costs incurred by project staff and flag budget issues early","input":{"action":"cost_control","tools":["Microsoft_Excel","Tableau","IBM_SPSS","Intuit_QuickBooks","Oracle_Primavera"],"threshold":{"variance_alert_pct":10}},"definition_of_done":"Budget report current, all variances > 10% have corrective action plans"},
  {"step":5,"type":"tool_use","name":"manage_risks_and_issues","description":"Identify, assess, and respond to project risks and issues throughout the lifecycle","input":{"action":"risk_management","tools":["JIRA","Confluence","Microsoft_Excel","SharePoint"],"process":["identify","analyze","respond","monitor"],"cadence":"weekly_risk_review"},"definition_of_done":"Risk register current, all P1 risks have mitigation plans and owners"},
  {"step":6,"type":"tool_use","name":"close_and_evaluate","description":"Complete final deliverables, obtain acceptance, and conduct lessons-learned session","input":{"action":"project_closure","tools":["JIRA","Confluence","Microsoft_Project","Adobe_Acrobat"],"artifacts":["acceptance_sign-off","lessons_learned_report","post-project_review"]},"definition_of_done":"All deliverables formally accepted, lessons learned published within 2 weeks of closure"}
]'::jsonb,
ARRAY['Microsoft Project','Oracle Primavera','Atlassian JIRA','Confluence','Asana','Microsoft Teams','Microsoft Excel','Tableau','IBM SPSS Statistics','Intuit QuickBooks','Adobe Acrobat','SharePoint','Zoom','Cisco Webex','Slack','PowerPoint']
);

-- ── 11. Management Analysts (13-1111.00) ──────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Conduct organizational studies and evaluations to improve management effectiveness, design efficient systems and procedures, and recommend operational changes.',
'[
  {"step":1,"type":"tool_use","name":"define_study_scope","description":"Plan the scope of management study covering organizational structure, processes, or systems","input":{"action":"scoping","tools":["Microsoft_Visio","Confluence","JIRA","PowerPoint"],"artifacts":["study_plan","stakeholder_map","data_requirements"]},"definition_of_done":"Study plan approved by client/management, success criteria defined"},
  {"step":2,"type":"tool_use","name":"gather_data_and_interview","description":"Interview personnel, conduct on-site observation, and gather operational data to understand current state","input":{"action":"data_collection","tools":["Microsoft_Excel","SPSS","Tableau","Zoom","Teams"],"methods":["structured_interviews","process_observation","document_review","surveys"]},"definition_of_done":"All data collection complete, current-state documentation finalized and validated"},
  {"step":3,"type":"tool_use","name":"analyze_and_diagnose","description":"Analyze gathered data to identify inefficiencies, gaps, and improvement opportunities","input":{"action":"analysis","tools":["Tableau","Power_BI","Alteryx","SAS","MATLAB","Python"],"methods":["root_cause_analysis","process_mapping","benchmarking","gap_analysis"]},"definition_of_done":"Analysis complete, key findings validated with client team"},
  {"step":4,"type":"tool_use","name":"develop_recommendations","description":"Develop solutions or alternative methods for organizational change and process improvement","input":{"action":"solution_design","tools":["Visio","PowerPoint","Microsoft_Excel","Confluence"],"artifacts":["future_state_design","implementation_roadmap","cost_benefit_analysis"]},"definition_of_done":"Recommendations reviewed and approved by client, implementation plan scoped"},
  {"step":5,"type":"tool_use","name":"document_findings_and_present","description":"Prepare written reports and present recommendations to management","input":{"action":"reporting","tools":["Microsoft_Word","PowerPoint","Tableau","Excel","SharePoint"],"deliverables":["executive_summary","findings_report","recommendation_deck"]},"definition_of_done":"Report delivered on time, presentation completed, management response documented"},
  {"step":6,"type":"tool_use","name":"support_implementation","description":"Prepare procedure manuals and train workers in the use of new systems or processes","input":{"action":"change_enablement","tools":["PowerPoint","Visio","SharePoint","LMS","Confluence","JIRA"],"deliverables":["procedure_manual","training_program","FAQ_guide"]},"definition_of_done":"All impacted staff trained, procedure manual published, post-implementation check scheduled"}
]'::jsonb,
ARRAY['Microsoft Excel','Microsoft Word','PowerPoint','Microsoft Visio','Tableau','Power BI','Alteryx','SPSS','Minitab','SAS','MATLAB','SQL','MySQL','MongoDB','PostgreSQL','JIRA','Confluence','Microsoft Teams','Salesforce','SAP','Oracle']
);

-- ── 12. Compensation, Benefits, and Job Analysis Specialists (13-1141.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Conduct compensation and benefits programs and job analysis to ensure competitive, equitable pay practices and regulatory compliance across the organization.',
'[
  {"step":1,"type":"tool_use","name":"conduct_job_analysis","description":"Evaluate job positions to determine appropriate classification, grade, and salary level","input":{"action":"job_evaluation","tools":["Workday","Oracle_Taleo","SAP_HR","Microsoft_Excel"],"methods":["point_factor","market_pricing","Hay_method","benchmarking"]},"definition_of_done":"Job evaluation completed, grade and level recommendation documented and approved"},
  {"step":2,"type":"tool_use","name":"benchmark_compensation","description":"Research employee benefit and pay practices to position the organization competitively","input":{"action":"market_research","tools":["IBM_Cognos","MicroStrategy","SAS","Excel"],"data_sources":["Mercer_surveys","Willis_Towers_Watson","ERI","Radford"]},"definition_of_done":"Market data analysis complete, competitive positioning confirmed against 50th/75th percentile"},
  {"step":3,"type":"tool_use","name":"develop_compensation_programs","description":"Design and administer merit, incentive, and bonus pay programs aligned with organizational goals","input":{"action":"program_design","tools":["Workday","Oracle_PeopleSoft","SAP_HR","Microsoft_Excel"],"programs":["merit_increase_matrix","annual_bonus_plan","long_term_incentive","ESPP"]},"definition_of_done":"Compensation program design approved by CHRO and finance, ready for annual cycle"},
  {"step":4,"type":"tool_use","name":"administer_benefits_programs","description":"Administer employee insurance, pension, and savings plans in coordination with insurance brokers","input":{"action":"benefits_administration","tools":["Workday","ADP","SAP_HR","Oracle_PeopleSoft"],"programs":["health_insurance","401k","FSA_HSA","life_insurance","disability"]},"definition_of_done":"Open enrollment completed, all eligible employees enrolled, carrier files reconciled"},
  {"step":5,"type":"tool_use","name":"ensure_legal_compliance","description":"Ensure compliance with FLSA, ACA, ERISA, and other federal and state employment regulations","input":{"action":"compliance_monitoring","tools":["IBM_Cognos","Microsoft_Excel","SAP","Oracle"],"regulations":["FLSA","ACA","ERISA","FMLA","equal_pay_laws"],"frequency":"annual_audit_and_ongoing"},"definition_of_done":"Compliance audit completed, no unresolved violations, required filings submitted on time"},
  {"step":6,"type":"tool_use","name":"advise_and_report","description":"Advise managers and employees on compensation policies and prepare compensation analytics","input":{"action":"advisory_and_reporting","tools":["Tableau","Power_BI","Workday_Reports","Excel"],"deliverables":["comp_ratio_analysis","pay_equity_report","salary_range_review"]},"definition_of_done":"Quarterly comp analytics delivered, pay equity review completed annually"}
]'::jsonb,
ARRAY['IBM SPSS Statistics','SAS','IBM Cognos','MicroStrategy','SQL','Microsoft Access','Oracle Taleo','SAP HR','Workday','Oracle PeopleSoft','Microsoft Project','Microsoft Excel','Microsoft Office','ADP']
);

-- ── 13. Training and Development Specialists (13-1151.00) ─────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Design, develop, and deliver training programs that enhance employee skills and organizational performance, from needs analysis through effectiveness evaluation.',
'[
  {"step":1,"type":"tool_use","name":"assess_training_needs","description":"Identify skill gaps and training requirements through surveys, interviews, and performance data","input":{"action":"needs_assessment","tools":["Workday","SAP","Microsoft_Excel","SurveyMonkey","Zoom"],"methods":["surveys","manager_interviews","performance_review_analysis","job_task_analysis"]},"definition_of_done":"Training needs analysis report approved by L&D manager and HR leadership"},
  {"step":2,"type":"tool_use","name":"design_training_curriculum","description":"Design learning objectives, content structure, and instructional approach for training programs","input":{"action":"instructional_design","tools":["Adobe_Creative_Cloud","PowerPoint","Articulate_Storyline","Visio","Microsoft_Project"],"models":["ADDIE","Kirkpatrick_model","70-20-10_framework"]},"definition_of_done":"Curriculum design document approved, learning objectives aligned to business outcomes"},
  {"step":3,"type":"tool_use","name":"develop_training_materials","description":"Create training content including e-learning modules, job aids, and facilitator guides","input":{"action":"content_development","tools":["Articulate_Storyline","Adobe_Captivate","PowerPoint","Moodle","SumTotal"],"formats":["e-learning","instructor-led","blended","microlearning","video"]},"definition_of_done":"All materials QA reviewed, accessible, and loaded into LMS"},
  {"step":4,"type":"tool_use","name":"deliver_training","description":"Facilitate live, virtual, or blended training sessions using varied instructional techniques","input":{"action":"facilitation","tools":["Zoom","Webex","Microsoft_Teams","Blackboard","Moodle"],"techniques":["role_play","simulations","group_discussion","case_studies","hands-on_lab"]},"definition_of_done":"All sessions delivered on schedule, attendance tracked in LMS"},
  {"step":5,"type":"tool_use","name":"evaluate_training_effectiveness","description":"Assess learning outcomes and behavioral changes using Kirkpatrick evaluation framework","input":{"action":"evaluation","tools":["SumTotal","Oracle_PeopleSoft","SAP","Microsoft_Excel","Tableau"],"levels":["L1_reaction","L2_learning","L3_behavior","L4_results"]},"definition_of_done":"Evaluation data collected and analyzed, L1/L2 targets met, L3/L4 plan in place"},
  {"step":6,"type":"tool_use","name":"maintain_and_improve_programs","description":"Update training programs based on evaluation data, regulatory changes, and business evolution","input":{"action":"continuous_improvement","tools":["Moodle","Microsoft_Project","SharePoint","Visio","FileMaker_Pro"],"frequency":"annual_review_with_triggered_updates"},"definition_of_done":"All mandatory programs updated within 30 days of regulatory change, improvement actions tracked"}
]'::jsonb,
ARRAY['Adobe Creative Cloud','Articulate Storyline','Adobe Captivate','Moodle','SumTotal Systems','Blackboard','Oracle PeopleSoft','SAP','Microsoft Project','Microsoft Office','Zoom','Cisco Webex','Microsoft Teams','Tableau','FileMaker Pro','Microsoft Visio']
);

-- ── 14. Market Research Analysts and Marketing Specialists (13-1161.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Research market conditions, analyze consumer behavior, and evaluate marketing program effectiveness to inform product strategies and drive business growth.',
'[
  {"step":1,"type":"tool_use","name":"define_research_objectives","description":"Collaborate with marketing and business teams to define research questions and success metrics","input":{"action":"scope_definition","tools":["Confluence","JIRA","PowerPoint","Excel"],"artifacts":["research_brief","hypothesis_list","KPI_framework"]},"definition_of_done":"Research brief approved by marketing leadership, questions operationalized"},
  {"step":2,"type":"tool_use","name":"design_research_methodology","description":"Devise and evaluate methods for data collection including surveys, focus groups, and analytics","input":{"action":"methodology_design","tools":["SurveyMonkey","Qualtrics","R","Python","SPSS"],"methods":["quantitative_survey","qualitative_focus_group","ethnography","A/B_test","social_listening"]},"definition_of_done":"Research methodology approved, sample size calculated, instruments tested"},
  {"step":3,"type":"tool_use","name":"collect_and_analyze_data","description":"Collect consumer demographic data and analyze buying habits, preferences, and market segments","input":{"action":"data_collection_and_analysis","tools":["IBM_SPSS_Statistics","MATLAB","Tableau","Google_Analytics","R","Python"],"sources":["consumer_surveys","social_media","CRM_data","third_party_panels"]},"definition_of_done":"Analysis complete, statistical significance confirmed, key insights extracted"},
  {"step":4,"type":"tool_use","name":"measure_marketing_effectiveness","description":"Measure effectiveness of marketing, advertising, and communications programs and strategies","input":{"action":"campaign_measurement","tools":["Google_Analytics","Salesforce","HubSpot","Google_Ads","Adobe_Analytics"],"metrics":["ROI","CAC","conversion_rate","brand_lift","NPS"]},"definition_of_done":"Campaign performance report delivered, ROI calculated against targets"},
  {"step":5,"type":"tool_use","name":"prepare_and_present_findings","description":"Prepare reports illustrating data graphically and translate complex findings into clear recommendations","input":{"action":"reporting","tools":["Tableau","PowerPoint","Excel","Adobe_Creative_Cloud","R_ggplot2"],"deliverables":["executive_summary","full_research_report","data_visualization_deck"]},"definition_of_done":"Report delivered on time, findings validated by client team, all visualizations accurate"},
  {"step":6,"type":"tool_use","name":"monitor_market_conditions","description":"Track consumer trends, competitor activity, and SEO/SEM performance on an ongoing basis","input":{"action":"market_intelligence","tools":["Google_Analytics","Salesforce","SQL_Server","MySQL","Zoom","Slack"],"frequency":"weekly_dashboard_update"},"definition_of_done":"Market intelligence dashboard current, weekly brief delivered to marketing leadership"}
]'::jsonb,
ARRAY['IBM SPSS Statistics','MATLAB','Tableau','Google Analytics','Salesforce','Microsoft SQL Server','MySQL','Google Ads','HubSpot','Microsoft Excel','Microsoft PowerPoint','Microsoft Office','Adobe Creative Cloud','R','Python','Zoom','Google Drive','Slack']
);

-- ── 15. Accountants and Auditors (13-2011.00) ─────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Examine, analyze, and interpret financial records to prepare accurate financial statements, provide accounting advice, and audit financial processes for compliance and integrity.',
'[
  {"step":1,"type":"tool_use","name":"plan_audit_or_engagement","description":"Plan audit scope, risk assessment, and testing approach based on client size and industry","input":{"action":"audit_planning","tools":["TeamMate","CaseWare","SAP_Concur","Microsoft_Excel"],"outputs":["audit_plan","risk_matrix","materiality_calculation","sampling_strategy"]},"definition_of_done":"Audit plan reviewed and signed off by audit manager, engagement letter executed"},
  {"step":2,"type":"tool_use","name":"collect_and_analyze_financial_data","description":"Collect accounting records and analyze data to detect deficiencies, fraud, or non-compliance","input":{"action":"data_analysis","tools":["ACL_Analytics","IDEA","Tableau","Alteryx","Excel","SQL"],"methods":["data_analytics","transaction_testing","trend_analysis","ratio_analysis"]},"definition_of_done":"All planned data analytics procedures complete, anomalies documented for further testing"},
  {"step":3,"type":"tool_use","name":"inspect_accounts_and_systems","description":"Inspect account books and accounting systems for efficiency, accuracy, and regulatory compliance","input":{"action":"substantive_testing","tools":["QuickBooks","SAP","Oracle_PeopleSoft","Workday","Sage_50"],"areas":["revenue","expenses","assets","liabilities","payroll","tax"]},"definition_of_done":"All risk areas tested to planned sample size, exceptions documented with client responses"},
  {"step":4,"type":"tool_use","name":"prepare_financial_statements","description":"Prepare detailed financial statements and reports in accordance with GAAP or IFRS","input":{"action":"financial_reporting","tools":["SAP","Oracle","Workday","Microsoft_Excel","Hyperion"],"standards":["US_GAAP","IFRS","GAAS","PCAOB"]},"definition_of_done":"Financial statements prepared, tied to supporting schedules, ready for management review"},
  {"step":5,"type":"tool_use","name":"report_findings_and_recommend","description":"Report to management on audit findings, asset utilization, and recommend operational improvements","input":{"action":"reporting","tools":["Microsoft_Word","PowerPoint","SharePoint","Excel","Tableau"],"deliverables":["audit_report","management_letter","action_items_tracker"]},"definition_of_done":"Audit report issued, management response obtained, action items have owners and due dates"},
  {"step":6,"type":"tool_use","name":"ensure_tax_and_regulatory_compliance","description":"Verify tax and regulatory filing compliance and advise on financial and regulatory matters","input":{"action":"compliance_review","tools":["Thomson_GoSystem_Tax","TurboTax","SAP_Concur","LexisNexis"],"regulations":["IRC","SOX","SEC_rules","state_tax_law"]},"definition_of_done":"All filings timely and accurate, compliance memo prepared for any identified issues"}
]'::jsonb,
ARRAY['QuickBooks','Sage 50','SAP Concur','SAP','Oracle PeopleSoft','Workday','ACL Analytics','IDEA','TeamMate','CaseWare','Thomson Reuters GoSystem Tax','TurboTax','Tableau','Alteryx','Microsoft Excel','SQL','Oracle Database','Hyperion','SharePoint']
);

-- ── 16. Budget Analysts (13-2031.00) ──────────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Examine budget estimates for accuracy and compliance, analyze financial trends, and provide technical assistance on cost analysis and fiscal allocation to support organizational budget decisions.',
'[
  {"step":1,"type":"tool_use","name":"compile_budget_submissions","description":"Collect departmental budget requests and verify completeness, accuracy, and policy conformance","input":{"action":"budget_collection","tools":["Deltek_Costpoint","SAP","Oracle","Microsoft_Excel"],"checks":["completeness","accuracy","policy_conformance","prior_year_comparison"]},"definition_of_done":"All department submissions received, completeness checklist signed off"},
  {"step":2,"type":"tool_use","name":"analyze_budget_requests","description":"Analyze budget estimates against historical trends, program needs, and resource availability","input":{"action":"budget_analysis","tools":["Microsoft_Excel","IBM_Cognos","Power_BI","SQL","Access"],"methods":["variance_analysis","trend_analysis","zero_base_review","cost_benefit_analysis"]},"definition_of_done":"Budget analysis complete, anomalies and over-requests documented with recommendations"},
  {"step":3,"type":"tool_use","name":"review_operating_expenditures","description":"Analyze monthly budget reports to maintain expenditure controls and identify trends","input":{"action":"expenditure_monitoring","tools":["Hyperion_Enterprise","SAP","Oracle_E-Business","Microsoft_Excel"],"frequency":"monthly_review"},"definition_of_done":"Monthly review report issued, variances > 5% have explanations and corrective actions"},
  {"step":4,"type":"tool_use","name":"provide_technical_assistance","description":"Advise departments on cost analysis, fiscal allocation, and budget preparation best practices","input":{"action":"advisory","tools":["Outlook","Teams","PowerPoint","Excel","Confluence"],"deliverables":["budget_guidance_memo","training_session","Q&A_responses"]},"definition_of_done":"All department advisory requests answered within SLA, budget guidance published"},
  {"step":5,"type":"tool_use","name":"summarize_and_recommend_budgets","description":"Summarize budget analysis and submit recommendations for fund approval or disapproval","input":{"action":"recommendation_reporting","tools":["Microsoft_Excel","Word","PowerPoint","Tableau","Power_BI"],"deliverables":["budget_recommendation_memo","summary_tables","variance_narrative"]},"definition_of_done":"Recommendation report delivered to budget authority on schedule, reviewed and actioned"},
  {"step":6,"type":"tool_use","name":"monitor_and_forecast","description":"Track actual spending against budget and develop revised forecasts for management","input":{"action":"forecast_management","tools":["Hyperion","SAP","Oracle","Tableau","SharePoint"],"frequency":"monthly_forecast_quarterly_reforecast"},"definition_of_done":"Forecast current and published within 5 business days of period close, accuracy within ±3%"}
]'::jsonb,
ARRAY['Deltek Costpoint','Hyperion Enterprise','SAP','Oracle E-Business Suite','Oracle','IBM Cognos','Microsoft Power BI','Microsoft Excel','SQL','Microsoft Access','Crystal Reports','SharePoint','Microsoft Word','PowerPoint','Tableau']
);

-- ── 17. Credit Analysts (13-2041.00) ──────────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Evaluate creditworthiness of individuals and businesses by analyzing financial data and generating risk assessments to inform lending and credit decisions.',
'[
  {"step":1,"type":"tool_use","name":"collect_and_verify_financial_data","description":"Gather financial statements, tax returns, bank records, and credit reports from applicants","input":{"action":"data_collection","tools":["Microsoft_Excel","SAP","Oracle","CALMS"],"sources":["financial_statements","credit_bureaus","tax_returns","bank_statements"]},"definition_of_done":"All required financial documents received and verified for authenticity"},
  {"step":2,"type":"tool_use","name":"analyze_creditworthiness","description":"Analyze financial data and statements to determine degree of credit risk","input":{"action":"credit_analysis","tools":["SAS","Fair_Isaac","Moodys_KMV","Oracle_Business_Intelligence","Excel"],"methods":["ratio_analysis","cash_flow_analysis","credit_scoring","sensitivity_testing"]},"definition_of_done":"Credit analysis complete, risk rating assigned per internal credit policy"},
  {"step":3,"type":"tool_use","name":"generate_financial_ratios","description":"Use computer programs to generate financial ratios assessing customer financial status","input":{"action":"ratio_computation","tools":["Microsoft_Excel","Visual_Basic","VBA","SQL_Server","SAP"],"ratios":["debt_to_equity","current_ratio","interest_coverage","DSCR","quick_ratio"]},"definition_of_done":"All required ratios computed, benchmarked against industry peers and policy thresholds"},
  {"step":4,"type":"tool_use","name":"forecast_loan_profitability","description":"Analyze income growth and market share metrics to forecast long-term loan profitability","input":{"action":"profitability_forecast","tools":["Excel","SAS","Oracle_Business_Intelligence","Tableau"],"outputs":["return_on_loan","expected_loss_model","stress_test_results"]},"definition_of_done":"Profitability forecast included in credit memo, approved by credit officer"},
  {"step":5,"type":"tool_use","name":"prepare_credit_report_and_recommendation","description":"Prepare credit reports outlining degree of risk and complete loan application for committee review","input":{"action":"credit_memo_preparation","tools":["Microsoft_Word","Excel","SharePoint","CALMS"],"content":["borrower_profile","financial_analysis","risk_rating","recommendation","conditions"]},"definition_of_done":"Credit memo approved by senior credit officer, submitted to committee within SLA"},
  {"step":6,"type":"tool_use","name":"monitor_portfolio_and_compliance","description":"Monitor approved credits, flag covenant breaches, and ensure regulatory compliance","input":{"action":"portfolio_monitoring","tools":["SAP","Oracle","SAS","Excel","Tableau"],"triggers":["covenant_breach","rating_downgrade","payment_delinquency"]},"definition_of_done":"Portfolio reviews current, all covenant breaches actioned within 5 business days"}
]'::jsonb,
ARRAY['SAS','Fair Isaac','Moody''s KMV','Oracle Business Intelligence','Microsoft SQL Server','SQL','Visual Basic','VBA','SAP','Oracle','Microsoft Excel','Microsoft Word','PowerPoint','Outlook','CALMS','Tableau']
);

-- ── 18. Financial and Investment Analysts (13-2051.00) ────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Conduct quantitative analyses of investment programs, financial data, and market conditions to inform investment decisions and guide portfolio strategy for institutional or retail clients.',
'[
  {"step":1,"type":"tool_use","name":"monitor_economic_and_market_conditions","description":"Track fundamental economic, industrial, and corporate developments from financial publications and data services","input":{"action":"market_monitoring","tools":["Bloomberg_Terminal","FactSet","Refinitiv_Eikon","Microsoft_Excel"],"sources":["earnings_releases","economic_reports","regulatory_filings","industry_journals"]},"definition_of_done":"Weekly market intelligence summary published, all monitored positions updated"},
  {"step":2,"type":"tool_use","name":"analyze_financial_performance","description":"Analyze company financial or operational performance including companies facing financial difficulties","input":{"action":"financial_analysis","tools":["IBM_SPSS","SAS","MATLAB","Excel","Bloomberg"],"methods":["DCF_analysis","comparable_company","precedent_transactions","ratio_analysis","DuPont"]},"definition_of_done":"Financial model complete, peer-reviewed, key drivers and sensitivities documented"},
  {"step":3,"type":"tool_use","name":"interpret_investment_risk_and_yield","description":"Interpret data on price, yield, stability, and future investment-risk trends","input":{"action":"risk_assessment","tools":["Power_BI","Alteryx","SAP","Oracle_PeopleSoft","R","Python"],"models":["VaR","Monte_Carlo","scenario_analysis","factor_model"]},"definition_of_done":"Risk report prepared, all positions rated by risk level, within investment mandate"},
  {"step":4,"type":"tool_use","name":"develop_financial_models","description":"Build financial models to solve complex financial problems and assess capital impact of transactions","input":{"action":"model_development","tools":["Microsoft_Excel","Python","R","MATLAB","Bloomberg"],"model_types":["LBO_model","merger_model","DCF","option_pricing","credit_model"]},"definition_of_done":"Model peer-reviewed, key assumptions documented, scenarios analyzed"},
  {"step":5,"type":"tool_use","name":"formulate_investment_recommendations","description":"Recommend investments and timing to companies, investment firm staff, or the public","input":{"action":"investment_recommendation","tools":["Bloomberg","FactSet","Tableau","PowerPoint","Excel"],"formats":["buy_sell_hold_rating","investment_memo","portfolio_recommendation"]},"definition_of_done":"Recommendation documented with thesis, catalysts, risks, and price target; approved by senior analyst"},
  {"step":6,"type":"tool_use","name":"report_and_communicate","description":"Prepare and present investment reports and analysis to portfolio managers, clients, or committees","input":{"action":"reporting","tools":["PowerPoint","Excel","Tableau","Refinitiv_Eikon","Bloomberg"],"deliverables":["research_report","portfolio_review","client_presentation","earnings_call_notes"]},"definition_of_done":"Reports published on schedule, client/PM questions addressed, recommendations tracked for performance"}
]'::jsonb,
ARRAY['Bloomberg Terminal','FactSet','Refinitiv Eikon','IBM SPSS Statistics','SAS','MATLAB','Alteryx','Power BI','Tableau','Microsoft Excel','SAP','Oracle PeopleSoft','QuickBooks','SQL','Python','R','Microsoft Office']
);

-- ── 19. Personal Financial Advisors (13-2052.00) ──────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Advise clients on comprehensive financial plans encompassing investments, taxes, insurance, and retirement to help them achieve short and long-term financial goals.',
'[
  {"step":1,"type":"tool_use","name":"conduct_client_discovery","description":"Interview clients to determine income, expenses, insurance, tax status, risk tolerance, and financial goals","input":{"action":"discovery_meeting","tools":["Salesforce","Microsoft_Outlook","Zoom","financial_planning_software"],"artifacts":["client_profile","risk_questionnaire","financial_data_gathering_form"]},"definition_of_done":"Complete financial picture captured, goals prioritized and confirmed with client"},
  {"step":2,"type":"tool_use","name":"analyze_financial_position","description":"Analyze financial information and cash flow to understand current position and gaps to goals","input":{"action":"financial_analysis","tools":["Microsoft_Excel","MoneyGuidePro","eMoney_Advisor","Oracle"],"methods":["net_worth_analysis","cash_flow_projection","Monte_Carlo_simulation","tax_projection"]},"definition_of_done":"Financial analysis complete, gaps to goals quantified, planning assumptions documented"},
  {"step":3,"type":"tool_use","name":"develop_financial_plan","description":"Develop comprehensive financial plan with strategies for investment, tax, insurance, and retirement","input":{"action":"plan_development","tools":["eMoney_Advisor","MoneyGuidePro","Microsoft_Excel","Salesforce"],"components":["asset_allocation","retirement_projection","insurance_review","estate_planning_overview","tax_optimization"]},"definition_of_done":"Financial plan reviewed and approved by client, compliance reviewed by supervisory principal"},
  {"step":4,"type":"tool_use","name":"implement_recommendations","description":"Execute recommended investment and insurance strategies in accordance with the approved plan","input":{"action":"implementation","tools":["custodial_platforms","Salesforce","Microsoft_Excel","DocuSign"],"actions":["investment_account_setup","insurance_application","401k_allocation_change","tax_loss_harvesting"]},"definition_of_done":"All plan actions executed, confirmations filed, client notified of implementation"},
  {"step":5,"type":"tool_use","name":"monitor_and_review_portfolios","description":"Review client accounts and plans regularly to identify changing needs and reassessment requirements","input":{"action":"portfolio_review","tools":["Bloomberg","eMoney","Microsoft_Excel","Salesforce"],"triggers":["annual_review","life_event","market_dislocation","10pct_portfolio_change"]},"definition_of_done":"Annual review completed for every client, recommendations issued where applicable"},
  {"step":6,"type":"tool_use","name":"recommend_and_manage_products","description":"Recommend appropriate financial products and manage product suitability and disclosure compliance","input":{"action":"product_recommendation","tools":["Salesforce","DocuSign","CRM","compliance_software"],"products":["stocks","bonds","mutual_funds","ETFs","annuities","insurance"],"regulations":["Reg_BI","fiduciary_standard","FINRA_suitability"]},"definition_of_done":"Product recommendation documented with suitability rationale, disclosures delivered and acknowledged"}
]'::jsonb,
ARRAY['Microsoft Excel','Salesforce','eMoney Advisor','MoneyGuidePro','Oracle','IBM systems','DocuSign','Bloomberg','Microsoft Access','SQL','Microsoft Office','PowerPoint','Word','Zoom','Outlook']
);

-- ── 20. Insurance Underwriters (13-2053.00) ───────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Evaluate insurance applications and risk factors to determine whether to accept, modify, or decline coverage, ensuring profitable and safe distribution of risk across the insurance portfolio.',
'[
  {"step":1,"type":"tool_use","name":"review_application_documents","description":"Examine policy application documents and supporting materials to identify risk factors","input":{"action":"document_review","tools":["Microsoft_Excel","Microsoft_Access","LexisNexis","Outlook"],"documents":["application_form","inspection_report","financial_statements","medical_records_if_applicable"]},"definition_of_done":"All required documents received and reviewed, initial risk flags documented"},
  {"step":2,"type":"tool_use","name":"assess_degree_of_risk","description":"Evaluate risk factors including applicant health, financial standing, property value, and loss history","input":{"action":"risk_assessment","tools":["actuarial_tables","catastrophe_models","Microsoft_Excel","proprietary_rating_engines"],"factors":["loss_history","exposure_characteristics","credit_score","inspection_results"]},"definition_of_done":"Risk score assigned, underwriting decision recommendation drafted"},
  {"step":3,"type":"tool_use","name":"apply_underwriting_guidelines","description":"Apply company underwriting policies to determine acceptability and appropriate rating","input":{"action":"guideline_application","tools":["underwriting_workstation","ERP_software","Microsoft_Excel","Access"],"decisions":["accept_standard","accept_modified","decline","refer_to_reinsurance"]},"definition_of_done":"Underwriting decision documented with rationale aligned to company guidelines"},
  {"step":4,"type":"tool_use","name":"structure_policy_terms","description":"Determine coverage limits, deductibles, endorsements, and premium rates for accepted risks","input":{"action":"policy_structuring","tools":["rating_software","Microsoft_Excel","policy_management_system","Word"],"adjustments":["rate_modifications","exclusions","sublimits","endorsements"]},"definition_of_done":"Policy terms finalized, premium calculated, terms compliant with state filings"},
  {"step":5,"type":"tool_use","name":"communicate_decisions","description":"Write to field representatives and brokers to quote rates, explain decisions, and request additional information","input":{"action":"stakeholder_communication","tools":["Microsoft_Outlook","Word","broker_portal","Zoom"],"correspondence":["declination_letter","conditional_acceptance","rate_indication","referral_notice"]},"definition_of_done":"All correspondence sent within turnaround SLA, responses logged in policy system"},
  {"step":6,"type":"tool_use","name":"review_existing_portfolio","description":"Review in-force business to evaluate aggregate exposure and reinsurance needs","input":{"action":"portfolio_review","tools":["Microsoft_Excel","Access","ERP_software","Tableau"],"analysis":["aggregate_exposure","probable_maximum_loss","reinsurance_adequacy","renewal_strategy"]},"definition_of_done":"Portfolio review completed quarterly, reinsurance treaty compliance confirmed"}
]'::jsonb,
ARRAY['Microsoft Excel','Microsoft Access','Microsoft Word','Microsoft Office','LexisNexis','Outlook','SAP','Oracle','ERP software','rating software','Tableau','Zoom','DocuSign']
);

-- ── 21. Financial Risk Specialists (13-2054.00) ───────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Analyze and measure financial risk exposure including market, credit, and operational risk to protect organizational assets and inform risk management strategy.',
'[
  {"step":1,"type":"tool_use","name":"identify_risk_exposures","description":"Analyze areas of potential risk to organizational assets, earnings, and financial state","input":{"action":"risk_identification","tools":["Oracle_E-Business_Suite","ServiceNow","IBM_SPSS","SAS","Microsoft_Excel"],"risk_types":["market_risk","credit_risk","liquidity_risk","operational_risk","model_risk"]},"definition_of_done":"Risk inventory complete, all material exposures identified and owners assigned"},
  {"step":2,"type":"tool_use","name":"quantify_risk_using_models","description":"Conduct statistical analyses and apply econometric models to quantify risk exposures","input":{"action":"risk_quantification","tools":["MATLAB","TensorFlow","SAS","IBM_SPSS","R","Python","C++","Perl"],"methods":["VaR","CVaR","stress_testing","scenario_analysis","Monte_Carlo","factor_decomposition"]},"definition_of_done":"Risk metrics computed, model validated against historical data, uncertainty bounds documented"},
  {"step":3,"type":"tool_use","name":"confer_with_traders_and_stakeholders","description":"Confer with traders to identify risks in trading strategies and with risk owners across the enterprise","input":{"action":"stakeholder_engagement","tools":["Outlook","Microsoft_Teams","Bloomberg","Tableau","QlikView"],"cadence":"daily_risk_meetings_and_weekly_committee"},"definition_of_done":"All high-risk positions reviewed, stakeholder concerns documented and addressed"},
  {"step":4,"type":"tool_use","name":"develop_risk_models_and_methodologies","description":"Develop and implement risk-assessment models and risk management methodologies","input":{"action":"model_development","tools":["MATLAB","Python","R","C++","Apache_Hive","Teradata","SQL_Server"],"frameworks":["Basel_III","FRTB","CCAR","ICAAP"]},"definition_of_done":"Model documented, independently validated, approved by model risk committee"},
  {"step":5,"type":"tool_use","name":"produce_risk_reports","description":"Generate risk reports outlining findings, risk positions, and recommended management actions","input":{"action":"reporting","tools":["Tableau","Oracle_Business_Intelligence","SQL_Server_Reporting","SharePoint","Excel"],"reports":["daily_VaR_report","stress_test_results","risk_dashboard","regulatory_risk_report"]},"definition_of_done":"Reports published on schedule, CRO and regulators receive required reports within deadlines"},
  {"step":6,"type":"tool_use","name":"recommend_risk_controls","description":"Recommend ways to control or reduce organizational risk through policy, limits, or hedging","input":{"action":"risk_mitigation","tools":["MATLAB","Excel","Tableau","PowerPoint","Confluence"],"controls":["position_limits","stop_loss_triggers","hedging_strategy","insurance_programs","operational_controls"]},"definition_of_done":"Recommendations approved by CRO, implemented with defined monitoring metrics"}
]'::jsonb,
ARRAY['IBM SPSS Statistics','SAS','MATLAB','TensorFlow','Python','R','C++','Perl','Oracle E-Business Suite Financials','SQL Server Reporting Services','Apache Hive','Teradata','Tableau','QlikView','Oracle Business Intelligence','Microsoft Excel','Microsoft SharePoint','AWS','ServiceNow']
);

-- ── 22. Financial Examiners (13-2061.00) ──────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Enforce laws governing financial and securities institutions by examining records to ensure the legality of transactions, institutional solvency, and compliance with applicable regulations.',
'[
  {"step":1,"type":"tool_use","name":"plan_examination","description":"Design examination scope, approach, and work program based on institution risk profile","input":{"action":"examination_planning","tools":["GENESYS","ACL_Analytics","Microsoft_Excel","NILS_INSource"],"outputs":["risk_assessment","examination_plan","data_request_list"]},"definition_of_done":"Examination plan approved by examination manager, institution notified per regulatory protocol"},
  {"step":2,"type":"tool_use","name":"review_financial_records","description":"Review balance sheets, loan documentation, and investment portfolios to confirm assets and liabilities","input":{"action":"document_examination","tools":["GENESYS","ACL_Analytics","Microsoft_Excel","SQL","Access"],"areas":["loan_portfolio","capital_adequacy","liquidity","asset_quality","earnings"]},"definition_of_done":"All CAMELS components tested, exceptions documented with regulatory citations"},
  {"step":3,"type":"tool_use","name":"investigate_compliance","description":"Investigate institutional activities to enforce applicable laws and regulations","input":{"action":"compliance_testing","tools":["SERFF","NILS_INSource","LexisNexis","Westlaw","SAP","Excel"],"tests":["BSA_AML_compliance","fair_lending","CRA","consumer_protection","capital_requirements"]},"definition_of_done":"All compliance tests completed, violations identified with supporting evidence"},
  {"step":4,"type":"tool_use","name":"direct_meetings_and_discussions","description":"Conduct formal and informal meetings with institution leadership to discuss examination findings","input":{"action":"stakeholder_meetings","tools":["Microsoft_Teams","Zoom","Outlook","PowerPoint","Word"],"types":["entry_meeting","exit_meeting","MRA_discussion","formal_enforcement_action"]},"definition_of_done":"Exit meeting held, all findings communicated, institution responses documented"},
  {"step":5,"type":"tool_use","name":"prepare_examination_report","description":"Prepare detailed reports on safety, soundness, and regulatory compliance for agency and institution","input":{"action":"report_writing","tools":["Microsoft_Word","Excel","SharePoint","Visio","Project"],"content":["CAMELS_ratings","findings_by_area","violations","MRAs","corrective_actions_required"]},"definition_of_done":"Examination report approved by supervisory examiner, issued within agency timeline"},
  {"step":6,"type":"tool_use","name":"recommend_and_follow_up","description":"Recommend compliance actions and monitor corrective action plan progress","input":{"action":"remediation_oversight","tools":["GENESYS","Microsoft_Excel","Outlook","NILS_INSource"],"sla":{"MRA_response_days":30,"formal_enforcement_compliance_days":90}},"definition_of_done":"All MRAs have institution commitments, follow-up examinations scheduled where needed"}
]'::jsonb,
ARRAY['GENESYS','ACL Analytics','NILS INSource','SERFF','SAP','LexisNexis','Thomson Reuters Westlaw','Microsoft Access','Microsoft Excel','SQL','SharePoint','Microsoft Project','Visio','Word','Outlook','Zoom','Microsoft Teams','PowerPoint']
);

-- ── 23. Loan Officers (13-2072.00) ────────────────────────────
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Evaluate, authorize, or recommend approval of loan applications by analyzing applicant creditworthiness and advising borrowers on appropriate credit and financing options.',
'[
  {"step":1,"type":"tool_use","name":"intake_and_qualify_applicants","description":"Meet with applicants to gather loan application information and explain available options","input":{"action":"application_intake","tools":["LoanMaster","VueCentric_MortgageDashboard","Microsoft_Outlook","Zoom"],"information":["income","assets","liabilities","credit_history","loan_purpose"]},"definition_of_done":"Complete application received, initial qualification confirmed within one business day"},
  {"step":2,"type":"tool_use","name":"analyze_creditworthiness","description":"Analyze applicant financial status, credit reports, and property evaluations for loan feasibility","input":{"action":"credit_underwriting","tools":["Experian_Credinomics","Fair_Isaac","Microsoft_Excel","FileMaker_Pro","Access"],"analysis":["credit_score_review","DTI_calculation","LTV_calculation","income_verification","asset_verification"]},"definition_of_done":"Credit analysis complete, risk rating assigned, approval or denial recommendation documented"},
  {"step":3,"type":"tool_use","name":"structure_loan_terms","description":"Determine appropriate loan type, amount, rate, and terms matching applicant needs and risk profile","input":{"action":"loan_structuring","tools":["financial_analysis_software","Microsoft_Excel","Wolters_Kluwer_ComplianceOne"],"parameters":["loan_type","maturity","rate","collateral","covenants","conditions"]},"definition_of_done":"Loan structure documented, terms within policy limits, compliance check passed"},
  {"step":4,"type":"tool_use","name":"obtain_approval_and_document","description":"Approve within authority limits or submit to management for approval; review loan agreements","input":{"action":"approval_and_documentation","tools":["LoanMaster","eOriginal_eCore","DocuSign","SAP","Oracle_PeopleSoft"],"checks":["completeness","accuracy","regulatory_compliance","BSA_AML"]},"definition_of_done":"Approval documented, loan agreement executed, all conditions precedent satisfied"},
  {"step":5,"type":"tool_use","name":"close_and_fund_loan","description":"Coordinate loan closing with title, legal, and operations teams and fund the approved loan","input":{"action":"loan_closing","tools":["eOriginal_eCore","DocuSign","Microsoft_Excel","SAP"],"coordination":["title_company","legal_counsel","appraisers","insurance"]},"definition_of_done":"Loan closed, funds disbursed, all documents recorded and filed in loan system"},
  {"step":6,"type":"tool_use","name":"advise_on_financial_goals","description":"Work with clients to identify financial goals and find ways of achieving them through appropriate loan products","input":{"action":"financial_counseling","tools":["Microsoft_Dynamics","Salesforce","Outlook","Zoom","Microsoft_Excel"],"deliverables":["financial_needs_assessment","product_recommendation","repayment_schedule"]},"definition_of_done":"Client understands loan terms, financial goals documented, relationship manager assigned"}
]'::jsonb,
ARRAY['LoanMaster','Financial Industry Computer Systems','Wolters Kluwer ComplianceOne','Experian Credinomics','VueCentric MortgageDashboard','Microsoft Dynamics','FileMaker Pro','Microsoft Access','eOriginal eCore','DocuSign','SAP','Oracle PeopleSoft','Microsoft Excel','Outlook','Zoom']
);

-- ── 24. Tax Examiners, Collectors, and Revenue Agents (13-2081.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Examine and audit tax returns, collect overdue taxes, and investigate tax compliance to enforce tax laws and ensure accurate reporting by individuals and businesses.',
'[
  {"step":1,"type":"tool_use","name":"select_and_assign_returns","description":"Select and review tax returns flagged for examination based on risk criteria and compliance indicators","input":{"action":"return_selection","tools":["IRS_CADE2","Microsoft_Excel","Access","Document_Upload_Delivery"],"criteria":["DIF_score","industry_risk","deduction_anomalies","third_party_reporting_mismatches"]},"definition_of_done":"Return assigned to examiner, taxpayer notified per IRM procedures, statute of limitations confirmed"},
  {"step":2,"type":"tool_use","name":"examine_tax_returns_and_records","description":"Conduct field or correspondence examination of returns, records, and supporting documents","input":{"action":"examination","tools":["Microsoft_Excel","Access","IRS_CADE2","Adobe_Acrobat"],"areas":["income_reporting","deductions_and_credits","cost_of_goods_sold","payroll_taxes","employment_taxes"]},"definition_of_done":"All identified issues tested and documented with applicable IRC citations"},
  {"step":3,"type":"tool_use","name":"analyze_and_calculate_liability","description":"Calculate tax liability, interest, and penalties based on examination findings","input":{"action":"liability_calculation","tools":["Microsoft_Excel","IRS_calculation_tools","Access"],"components":["tax_deficiency","accuracy_related_penalties","failure_to_file_penalties","interest_computation"]},"definition_of_done":"Tax calculation verified, statutory authority documented for each adjustment"},
  {"step":4,"type":"tool_use","name":"communicate_with_taxpayers","description":"Issue preliminary findings, conduct appeals conferences, and negotiate settlements within authority","input":{"action":"taxpayer_engagement","tools":["Outlook","Microsoft_Word","Zoom","IRS_portal"],"process":["30_day_letter","protest_response","appeals_conference","closing_agreement"]},"definition_of_done":"Taxpayer has been notified, all correspondence timely per IRC requirements"},
  {"step":5,"type":"tool_use","name":"collect_and_resolve_delinquencies","description":"Initiate collection actions on overdue taxes and negotiate payment arrangements","input":{"action":"collection","tools":["IRS_CADE2","Microsoft_Excel","Word","certified_mail_systems"],"tools_used":["levies","liens","installment_agreements","OIC_processing"]},"definition_of_done":"All assigned cases actioned within CSED, collection vehicle properly documented"},
  {"step":6,"type":"tool_use","name":"document_and_close_case","description":"Prepare examination reports, close case files, and report results for compliance trend analysis","input":{"action":"case_closure","tools":["IRS_CADE2","Microsoft_Excel","Word","SharePoint"],"reports":["Revenue_Agent_Report","Form_4549","closing_statement"]},"definition_of_done":"Case closed in IRS system, all required forms generated, revenue protected documented"}
]'::jsonb,
ARRAY['Microsoft Excel','Microsoft Access','Microsoft Word','Adobe Acrobat','IRS CADE2','Document Upload Delivery system','Outlook','Zoom','SharePoint','PowerPoint']
);

-- ── 25. Fraud Examiners, Investigators and Analysts (13-2099.04) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Obtain evidence, take statements, produce reports, and coordinate detection and prevention of fraud to protect organizational and client assets from financial crime.',
'[
  {"step":1,"type":"tool_use","name":"detect_and_intake_fraud_allegations","description":"Identify fraud indicators through analytics, hotline tips, or referrals and open formal investigation","input":{"action":"fraud_detection","tools":["SAS","IBM_Cognos","Tableau","Splunk","PCG_Virtual_Examiner"],"methods":["anomaly_detection","benford_law_analysis","link_analysis","hotline_triage"]},"definition_of_done":"Investigation opened, case number assigned, preliminary risk assessment documented"},
  {"step":2,"type":"tool_use","name":"gather_and_secure_evidence","description":"Gather financial documents, records, and digital evidence related to the investigation","input":{"action":"evidence_collection","tools":["SAP_Business_Objects","Microsoft_Access","SQL_Server","SharePoint","Adobe_Acrobat"],"sources":["financial_records","email_archives","transaction_logs","personnel_files","vendor_records"]},"definition_of_done":"Evidence log complete, chain of custody documented, all documents secured per policy"},
  {"step":3,"type":"tool_use","name":"conduct_interviews","description":"Interview witnesses, suspects, and subject matter experts and record statements","input":{"action":"interviewing","tools":["Zoom","Outlook","Microsoft_Word","audio_recording_equipment"],"techniques":["cognitive_interview","motivational_interviewing","PEACE_model"]},"definition_of_done":"All key witnesses interviewed, statements documented and reviewed for consistency"},
  {"step":4,"type":"tool_use","name":"analyze_financial_transactions","description":"Analyze financial transactions to trace fraud schemes and quantify losses","input":{"action":"forensic_analysis","tools":["TIBCO_Spotfire","IBM_Cognos","Tableau","SAS","Python","R","Excel"],"methods":["source_and_application_of_funds","net_worth_analysis","timeline_reconstruction","transaction_tracing"]},"definition_of_done":"Financial analysis complete, fraud scheme reconstructed, loss amount quantified"},
  {"step":5,"type":"tool_use","name":"prepare_investigation_report","description":"Prepare comprehensive written report of investigation findings for management and legal counsel","input":{"action":"report_writing","tools":["Microsoft_Word","Excel","SharePoint","LexisNexis","SAP_Business_Objects"],"content":["executive_summary","findings","evidence_summary","loss_calculation","recommendations"]},"definition_of_done":"Report reviewed by legal counsel, approved for distribution, action items assigned"},
  {"step":6,"type":"tool_use","name":"coordinate_with_law_enforcement","description":"Coordinate investigative efforts with law enforcement officers, attorneys, and regulatory agencies","input":{"action":"law_enforcement_liaison","tools":["Outlook","Microsoft_Word","SharePoint","Zoom"],"parties":["FBI","DOJ","SEC","state_AG","internal_legal"],"deliverables":["referral_package","grand_jury_subpoena_response","SAR_filing"]},"definition_of_done":"Referral package complete, law enforcement contacts established, SAR filed if required within 30 days"}
]'::jsonb,
ARRAY['SAS','IBM Cognos','Tableau','TIBCO Spotfire','Splunk Enterprise','PCG Virtual Examiner','SAP Business Objects','Microsoft Access','Microsoft SQL Server','SQL','SharePoint','Microsoft Excel','Microsoft Word','Adobe Acrobat','Outlook','Python','R','LexisNexis']
);

-- merged from sal_finance_legal_seed_part3.sql
-- ============================================================
-- SAL Registry v1.0 — FINANCE (13-xxxx) + LEGAL (23-xxxx) CLUSTERS
-- Part 3 of 4: agent_logic — Remaining Finance sub-roles + ALL Legal roles
-- Source: O*NET OnLine + BLS OEWS May 2024
-- Ingested: 2026-03-31
-- Run ONCE on a fresh cluster (no UNIQUE guard on agent_logic)
-- For re-runs: TRUNCATE agent_logic CASCADE first
-- ============================================================

-- ══════════════════════════════════════════════════════════════
-- REMAINING FINANCE 13-1xxx SUB-ROLES
-- ══════════════════════════════════════════════════════════════

-- ── 26. Insurance Appraisers, Auto Damage (13-1032.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Appraise automobile or other vehicle damage to determine repair costs for insurance claim settlements. Examine damaged vehicle to determine extent of structural, body, mechanical, electrical, or interior damage.',
'[
  {"step":1,"type":"tool_use","name":"receive_and_review_claim","description":"Receive insurance claim assignment, review policyholder information, accident report, and coverage details","input":{"claim_id":"string","policy_number":"string","accident_date":"date","vehicle_vin":"string"},"definition_of_done":"Claim file is open, coverage confirmed, inspection appointment scheduled"},
  {"step":2,"type":"tool_use","name":"inspect_damaged_vehicle","description":"Physically examine vehicle to document all damage — structural, body, mechanical, electrical, and interior — using standardized appraisal methodology","input":{"inspection_location":"string","vehicle_year_make_model":"string","damage_areas":["array"],"odometer_reading":"number"},"definition_of_done":"All damage documented with photos, measurements, and part identifications recorded"},
  {"step":3,"type":"tool_use","name":"research_repair_costs","description":"Query parts databases, labor guides (Mitchell, CCC, Audatex), and salvage markets to price all required repairs and replacements","input":{"parts_needed":["array"],"labor_hours_estimated":"number","local_labor_rate":"number","total_loss_threshold":"number"},"definition_of_done":"Line-item repair cost estimate generated with parts, labor, paint, and materials"},
  {"step":4,"type":"tool_use","name":"determine_actual_cash_value","description":"If vehicle is a total loss, establish ACV using market value tools (CCC ONE, Mitchell WorkCenter) and comparable vehicle sales","input":{"vehicle_condition":"string","market_comparables":["array"],"depreciation_factors":["array"]},"definition_of_done":"ACV determined, total loss or repairable decision documented"},
  {"step":5,"type":"tool_use","name":"prepare_appraisal_report","description":"Compile complete damage appraisal report with itemized costs, photos, and settlement recommendation","input":{"estimate_total":"number","supplemental_items":["array"],"photos_attached":"boolean","salvage_value":"number"},"definition_of_done":"Signed appraisal report submitted to claims handler within SLA"},
  {"step":6,"type":"tool_use","name":"negotiate_with_repair_facility","description":"Liaise with body shop or repair facility to reconcile estimate discrepancies and authorize repair proceed","input":{"shop_counter_estimate":"number","disputed_line_items":["array"],"final_authorized_amount":"number"},"definition_of_done":"Agreed repair authorization issued, supplement process documented"}
]'::jsonb,
ARRAY['CCC ONE','Mitchell WorkCenter','Audatex Estimating','Xactimate','Digital imaging tools','AutoVin','NADA Guides','Kelley Blue Book']
);

-- ── 27. Environmental Compliance Inspectors (13-1041.01) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Inspect and investigate sources of pollution to protect the public and environment and ensure conformance with Federal, State, and local regulations and ordinances.',
'[
  {"step":1,"type":"tool_use","name":"plan_compliance_inspection","description":"Review facility permit conditions, prior inspection history, complaint records, and regulatory requirements to plan inspection scope","input":{"facility_id":"string","permit_number":"string","regulatory_program":"string","prior_violations":["array"]},"definition_of_done":"Inspection plan finalized with checklist, sampling protocol, and regulatory citations identified"},
  {"step":2,"type":"tool_use","name":"conduct_site_inspection","description":"Perform on-site inspection of facility operations, waste handling, emissions controls, and record-keeping compliance","input":{"inspection_date":"date","areas_inspected":["array"],"records_reviewed":["array"],"observations":["array"]},"definition_of_done":"All permit conditions evaluated, field notes and photos documented"},
  {"step":3,"type":"tool_use","name":"collect_environmental_samples","description":"Collect air, water, soil, or waste samples per chain-of-custody protocols for laboratory analysis","input":{"sample_types":["array"],"sampling_locations":["array"],"lab_submission_id":"string","chain_of_custody_completed":"boolean"},"definition_of_done":"Samples collected, labeled, and submitted to certified laboratory"},
  {"step":4,"type":"tool_use","name":"document_violations_and_findings","description":"Record all violations, deficiencies, and observations with specific regulatory citations and photographic evidence","input":{"violations_found":["array"],"regulatory_citations":["array"],"severity_rating":"string","imminent_hazard":"boolean"},"definition_of_done":"Complete violation documentation with citation basis prepared"},
  {"step":5,"type":"tool_use","name":"issue_inspection_report_and_notice","description":"Prepare formal inspection report and Notice of Violation or compliance schedule as appropriate","input":{"report_type":"string","corrective_actions_required":["array"],"compliance_deadline":"date","penalty_assessment":"number"},"definition_of_done":"Report issued to facility, enforcement action initiated if warranted"},
  {"step":6,"type":"tool_use","name":"track_corrective_action_compliance","description":"Monitor facility response to violations, review corrective action plans, and verify compliance through follow-up inspections","input":{"corrective_action_plan":"object","follow_up_inspection_date":"date","compliance_achieved":"boolean"},"definition_of_done":"Facility returned to compliance or escalated to formal enforcement"}
]'::jsonb,
ARRAY['EPA ECHO database','EPA ICIS-Air','EPA RCRA Info','GIS mapping tools','Field sampling equipment','Chain-of-custody forms','Regulatory databases','CROMERR-compliant portals']
);

-- ── 28. Equal Opportunity Representatives and Officers (13-1041.03) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Monitor and evaluate compliance with equal opportunity laws, guidelines, and policies to ensure that employment practices and contracting arrangements give equal opportunity without regard to race, religion, color, national origin, sex, age, or disability.',
'[
  {"step":1,"type":"tool_use","name":"receive_and_screen_complaint","description":"Receive discrimination complaint or compliance review assignment, screen for jurisdictional basis, and identify applicable laws (Title VII, ADA, ADEA, Executive Order 11246)","input":{"complaint_id":"string","complainant_demographics":"object","alleged_basis":"string","respondent_employer":"string"},"definition_of_done":"Complaint accepted or dismissed with written determination, charging party notified"},
  {"step":2,"type":"tool_use","name":"conduct_compliance_review_or_investigation","description":"Gather evidence through document requests, interviews, workplace visits, and statistical workforce analysis","input":{"documents_requested":["array"],"interviews_conducted":["array"],"workforce_data_analyzed":"boolean","site_visit_completed":"boolean"},"definition_of_done":"Complete evidentiary record assembled with factual findings documented"},
  {"step":3,"type":"tool_use","name":"analyze_statistical_workforce_data","description":"Analyze employer workforce composition data, applicant flow, promotion rates, and compensation equity using statistical methods","input":{"workforce_report":"object","comparison_group":"string","statistical_test":"string","disparate_impact_found":"boolean"},"definition_of_done":"Statistical analysis completed with findings summarized in quantitative terms"},
  {"step":4,"type":"tool_use","name":"determine_violation_and_prepare_findings","description":"Apply legal standards to evidence, make reasonable cause or no cause determination, document factual and legal basis","input":{"legal_standard_applied":"string","key_findings":["array"],"determination":"string","supporting_citations":["array"]},"definition_of_done":"Formal determination letter drafted with complete legal and factual analysis"},
  {"step":5,"type":"tool_use","name":"facilitate_conciliation_or_corrective_action","description":"Facilitate voluntary compliance through conciliation agreements, corrective action plans, or training requirements","input":{"remedies_proposed":["array"],"back_pay_calculated":"number","policy_changes_required":["array"],"training_required":"boolean"},"definition_of_done":"Conciliation agreement executed or case referred to legal counsel for enforcement"},
  {"step":6,"type":"tool_use","name":"monitor_and_close_case","description":"Monitor employer compliance with agreement terms, verify implementation of corrective actions, and close case with final documentation","input":{"monitoring_period_months":"number","compliance_verified":"boolean","case_closure_date":"date"},"definition_of_done":"Case closed with verification of full compliance or referral to enforcement"}
]'::jsonb,
ARRAY['EEOC case management system','OFCCP compliance database','Charge receipt portal','Statistical analysis software (SPSS, SAS)','Workforce composition analysis tools','Legal research databases (Westlaw, LexisNexis)']
);

-- ── 29. Government Property Inspectors and Investigators (13-1041.04) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Investigate or inspect government property to ensure compliance with contract agreements and government regulations.',
'[
  {"step":1,"type":"tool_use","name":"review_contract_and_property_records","description":"Review government contract terms, property custodian records, accountable property officer designations, and prior audit findings","input":{"contract_number":"string","property_records":"object","custodian_id":"string","property_book_value":"number"},"definition_of_done":"Contract requirements understood, baseline property record established"},
  {"step":2,"type":"tool_use","name":"conduct_physical_property_inventory","description":"Perform physical count and condition assessment of government-furnished property, contractor-acquired property, and sensitive/accountable items","input":{"property_items":["array"],"serial_numbers":["array"],"condition_ratings":["array"],"location_verified":"boolean"},"definition_of_done":"100% inventory of accountable items completed with discrepancy list"},
  {"step":3,"type":"tool_use","name":"investigate_property_discrepancies","description":"Investigate identified shortages, losses, damages, and unauthorized use through interviews, records review, and evidence collection","input":{"discrepancy_items":["array"],"responsible_parties":["array"],"evidence_collected":["array"],"monetary_value_at_risk":"number"},"definition_of_done":"Investigation complete with factual findings and responsible party determination"},
  {"step":4,"type":"tool_use","name":"assess_contractor_property_management_system","description":"Evaluate contractor property management system against FAR 52.245-1 requirements for identification, records, reports, and disposal","input":{"far_elements_assessed":["array"],"system_deficiencies":["array"],"disapproval_criteria_met":"boolean"},"definition_of_done":"Property management system assessment report with approval/disapproval determination"},
  {"step":5,"type":"tool_use","name":"prepare_inspection_report_and_findings","description":"Document findings, violations, and recommended corrective actions in formal inspection or investigation report","input":{"findings":["array"],"violations":["array"],"recommended_actions":["array"],"financial_impact":"number"},"definition_of_done":"Signed report submitted to contracting officer and legal counsel"},
  {"step":6,"type":"tool_use","name":"coordinate_property_disposition","description":"Coordinate proper disposition of excess, lost, or damaged government property through DRMO, turn-in, or relief from responsibility process","input":{"disposition_type":"string","property_items":["array"],"relief_from_responsibility_granted":"boolean"},"definition_of_done":"All discrepant items dispositioned or relief action closed"}
]'::jsonb,
ARRAY['GFP (Government-Furnished Property) module','PIEE','DCSA systems','FAR Part 45 reference','Property Book Unit Supply Enhanced (PBUSE)','FEDLOG','Wide Area WorkFlow (WAWF)']
);

-- ── 30. Coroners (13-1041.06) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Direct activities such as autopsies, pathological and toxicological analyses, and inquests relating to the investigation of deaths occurring within a legal jurisdiction to determine cause of death or to fix responsibility for accidental, violent, or unexplained deaths.',
'[
  {"step":1,"type":"tool_use","name":"receive_and_classify_death_report","description":"Receive death notification, determine coroner jurisdiction based on manner and circumstances, classify as natural, accident, homicide, suicide, or undetermined","input":{"deceased_id":"string","death_location":"string","circumstances":"string","reporting_agency":"string"},"definition_of_done":"Jurisdiction accepted or declined, scene response authorized if required"},
  {"step":2,"type":"tool_use","name":"conduct_death_scene_investigation","description":"Investigate death scene, document physical evidence, interview witnesses, review medical history, and coordinate with law enforcement","input":{"scene_photos":"boolean","evidence_collected":["array"],"witnesses_interviewed":["array"],"medical_history_obtained":"boolean"},"definition_of_done":"Scene investigation complete, body released or held for autopsy"},
  {"step":3,"type":"tool_use","name":"order_and_oversee_autopsy","description":"Order autopsy when indicated, coordinate with forensic pathologist, ensure proper chain of custody for samples and evidence","input":{"autopsy_ordered":"boolean","forensic_pathologist_assigned":"string","toxicology_ordered":"boolean","evidence_items":["array"]},"definition_of_done":"Autopsy performed, tissue/toxicology samples submitted, preliminary findings received"},
  {"step":4,"type":"tool_use","name":"review_forensic_findings","description":"Review autopsy, toxicology, and ancillary lab reports to synthesize cause and manner of death determination","input":{"autopsy_report":"object","toxicology_results":"object","ancillary_labs":["array"],"contributory_conditions":["array"]},"definition_of_done":"Cause and manner of death determined with evidentiary support"},
  {"step":5,"type":"tool_use","name":"complete_death_certificate","description":"Complete and certify death certificate with accurate cause of death, manner of death, and contributing conditions in compliance with state vital records standards","input":{"immediate_cause":"string","underlying_cause":"string","contributory_conditions":["array"],"manner_of_death":"string"},"definition_of_done":"Death certificate certified and filed with vital statistics registry"},
  {"step":6,"type":"tool_use","name":"conduct_inquest_or_notify_stakeholders","description":"Conduct formal inquest if required, notify next of kin, coordinate with DA/law enforcement for criminal referrals, and release case records","input":{"inquest_required":"boolean","next_of_kin_notified":"boolean","criminal_referral":"boolean","records_released":"boolean"},"definition_of_done":"Case closed with all notifications and referrals completed, records retained per retention schedule"}
]'::jsonb,
ARRAY['OCME Case Management System','Forensic pathology consultation','Toxicology laboratory','EDRS (Electronic Death Registration System)','Law enforcement evidence tracking','AFIS','Vital records database']
);

-- ── 31. Customs Brokers (13-1041.08) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Prepare customs documentation and ensure that shipments meet all applicable laws to facilitate the import and export of goods. Determine and track duties and taxes payable and process payments on behalf of client.',
'[
  {"step":1,"type":"tool_use","name":"classify_goods_and_determine_duties","description":"Analyze shipment commercial invoice, country of origin, and product specifications to assign HTS tariff classification and calculate applicable duties, taxes, and fees","input":{"product_description":"string","country_of_origin":"string","commercial_value":"number","hts_candidate_codes":["array"]},"definition_of_done":"Binding HTS classification confirmed, duty rate applied, total landed cost calculated"},
  {"step":2,"type":"tool_use","name":"verify_import_eligibility_and_permits","description":"Confirm shipment meets all admissibility requirements — FDA, USDA, FWS, EPA, CPSC, DOT — and obtain required import permits or licenses","input":{"agency_requirements":["array"],"permits_required":["array"],"admissibility_status":"string"},"definition_of_done":"All agency clearances confirmed, shipment admissible to entry"},
  {"step":3,"type":"tool_use","name":"prepare_entry_documentation","description":"Prepare CBP entry (CF-7501 or ACE electronic entry), arrival notice, ISF if applicable, and supporting documents for CBP filing","input":{"entry_type":"string","bill_of_lading":"string","commercial_invoice":"object","packing_list":"object","certificate_of_origin":"string"},"definition_of_done":"Complete entry package assembled and reviewed for accuracy"},
  {"step":4,"type":"tool_use","name":"file_entry_in_ace_system","description":"Transmit customs entry electronically through ACE (Automated Commercial Environment), respond to CBP queries, and monitor release status","input":{"ace_entry_number":"string","filing_timestamp":"datetime","cbp_exam_requested":"boolean","release_status":"string"},"definition_of_done":"Entry accepted by CBP, release notification received, cargo available to importer"},
  {"step":5,"type":"tool_use","name":"process_duty_payment","description":"Calculate total duties, taxes, MPF, HMF, and fees; process payment via ACH debit or bond; reconcile against importer account","input":{"duties_owed":"number","mpf":"number","hmf":"number","payment_method":"string","bond_type":"string"},"definition_of_done":"Payment processed, receipt confirmed, importer invoiced"},
  {"step":6,"type":"tool_use","name":"maintain_records_and_post_entry_compliance","description":"Retain all import records for CBP 5-year recordkeeping requirement, manage post-entry amendments, protests, and binding ruling requests","input":{"record_retention_date":"date","post_entry_amendments":["array"],"protest_filed":"boolean","binding_ruling_requested":"boolean"},"definition_of_done":"All records filed and indexed, post-entry corrections resolved"}
]'::jsonb,
ARRAY['ACE (Automated Commercial Environment)','CBP One','HTS Schedule lookup','Descartes e-Customs','Amber Road GTM','OCR/EDI document processing','Trade compliance databases','Customs bond management system']
);

-- ── 32. Buyers and Purchasing Agents, Farm Products (13-1021.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Purchase farm products either for further processing or resale. Conduct negotiations, evaluate quality, and buy commodities, grain, livestock, or other agricultural products.',
'[
  {"step":1,"type":"tool_use","name":"monitor_commodity_markets","description":"Track commodity spot prices, futures markets, weather patterns, and crop reports to inform purchasing decisions and timing","input":{"commodities_tracked":["array"],"futures_exchange":"string","usda_reports":["array"],"market_data_sources":["array"]},"definition_of_done":"Market conditions documented, buy/hold/sell recommendation prepared"},
  {"step":2,"type":"tool_use","name":"identify_and_qualify_suppliers","description":"Identify farm product suppliers, evaluate production capacity, quality certifications, financial stability, and regulatory compliance","input":{"supplier_candidates":["array"],"certification_requirements":["array"],"volume_requirements":"number","geographic_preference":"string"},"definition_of_done":"Approved supplier list updated with qualification documentation"},
  {"step":3,"type":"tool_use","name":"grade_and_inspect_product_quality","description":"Inspect physical samples, review USDA grade certificates, and assess product quality against specifications before purchase commitment","input":{"product_samples":["array"],"usda_grade_required":"string","moisture_content":"number","test_weight":"number"},"definition_of_done":"Quality approval documented, grade certificate archived"},
  {"step":4,"type":"tool_use","name":"negotiate_purchase_contracts","description":"Negotiate price, volume, delivery schedule, payment terms, and quality specifications with producers or trading intermediaries","input":{"target_price":"number","volume_bushels_tons":"number","delivery_window":"string","basis":"number","contract_type":"string"},"definition_of_done":"Signed purchase contract executed, logistics handoff initiated"},
  {"step":5,"type":"tool_use","name":"coordinate_logistics_and_delivery","description":"Arrange transportation, storage, and handling for purchased commodities from farm to processing facility or resale point","input":{"transportation_mode":"string","storage_facility":"string","delivery_date":"date","shrinkage_allowance":"number"},"definition_of_done":"Product received, quantity and quality verified at destination"},
  {"step":6,"type":"tool_use","name":"process_payment_and_update_records","description":"Process producer payment per contract terms, update commodity inventory records, and report transactions per CFTC/USDA reporting requirements","input":{"payment_amount":"number","payment_method":"string","inventory_update":"object","regulatory_report":"boolean"},"definition_of_done":"Payment completed, inventory reconciled, compliance reports filed"}
]'::jsonb,
ARRAY['CME Group trading platform','DTN/Progressive Farmer','USDA AMS Grade Certificates','Farm/commodity ERP (Quorum, AgiBiz)','Grain Management System (GMS)','CBOT/ICE Futures','EDI for contracts']
);

-- ── 33. Farm Labor Contractors (13-1074.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Recruit and hire seasonal farm workers and crew leaders. Arrange, direct, or transport migrant or seasonal workers to farms where they work under contract.',
'[
  {"step":1,"type":"tool_use","name":"obtain_and_maintain_flcra_registration","description":"Maintain active Farm Labor Contractor registration under FLCRA with DOL, ensure all required bonds, insurance, and disclosures are current","input":{"flcra_certificate_number":"string","expiration_date":"date","surety_bond_amount":"number","insurance_coverage":"object"},"definition_of_done":"Valid FLCRA registration confirmed, all compliance documents on file"},
  {"step":2,"type":"tool_use","name":"recruit_seasonal_farmworkers","description":"Recruit seasonal and migrant workers through approved channels, provide all required written disclosures about wages, hours, working conditions, and housing","input":{"workers_needed":"number","crop_type":"string","work_start_date":"date","wage_rate":"number","housing_provided":"boolean"},"definition_of_done":"Workforce recruited with signed disclosure acknowledgments from all workers"},
  {"step":3,"type":"tool_use","name":"verify_worker_eligibility","description":"Verify I-9 employment eligibility for all workers, complete E-Verify as required, maintain payroll records per MSPA/FLSA requirements","input":{"worker_count":"number","i9_completed":"boolean","e_verify_status":"string","minor_workers":"boolean"},"definition_of_done":"100% I-9 compliance, worker eligibility verified and documented"},
  {"step":4,"type":"tool_use","name":"arrange_transportation_and_housing","description":"Coordinate DOT-compliant transportation to work sites and ensure housing meets ETA/OSHA standards if provided","input":{"transportation_vehicles":["array"],"driver_credentials":["array"],"housing_facilities":["array"],"housing_inspection_date":"date"},"definition_of_done":"Transportation safety inspected, housing certified compliant"},
  {"step":5,"type":"tool_use","name":"manage_payroll_and_wage_compliance","description":"Process accurate payroll per FLSA minimum wage requirements, provide itemized pay statements, and ensure piece-rate calculations are compliant","input":{"pay_period":"string","hours_worked":["array"],"piece_rate_units":"number","deductions":["array"]},"definition_of_done":"All workers paid accurately and on time, payroll records retained 3 years"},
  {"step":6,"type":"tool_use","name":"coordinate_with_agricultural_employer","description":"Coordinate crew placement, work assignment, and performance with the agricultural employer while maintaining contractor compliance responsibilities","input":{"farm_employer":"string","work_assignments":["array"],"crew_size":"number","harvest_completion_date":"date"},"definition_of_done":"Harvest work completed, final settlement with employer and workers processed"}
]'::jsonb,
ARRAY['DOL FLCRA registration portal','E-Verify','QuickBooks Payroll','I-9 management software','DOT FMCSA compliance tools','Time and attendance (paper or mobile)','Worker disclosure templates']
);

-- ── 34. Labor Relations Specialists (13-1075.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Resolve disputes between workers and managers, negotiate collective bargaining agreements, or coordinate grievance procedures to handle employee complaints.',
'[
  {"step":1,"type":"tool_use","name":"analyze_labor_relations_environment","description":"Assess organizational labor climate, union presence, contract status, grievance trends, and NLRA compliance posture","input":{"union_contracts_active":["array"],"grievances_filed_ytd":"number","pending_arbitrations":"number","nlrb_charges":"number"},"definition_of_done":"Labor relations situation mapped with risk areas identified"},
  {"step":2,"type":"tool_use","name":"manage_grievance_and_arbitration_process","description":"Investigate employee grievances at each step, prepare management responses, represent management at arbitration hearings","input":{"grievance_id":"string","grievance_basis":"string","investigation_findings":"object","step_in_process":"number","arbitration_scheduled":"boolean"},"definition_of_done":"Grievance resolved at lowest step or arbitration case prepared and presented"},
  {"step":3,"type":"tool_use","name":"prepare_collective_bargaining_proposals","description":"Research wages, benefits, and work rules at comparable employers; develop management bargaining proposals; analyze cost impact of union demands","input":{"contract_expiration_date":"date","management_proposals":["array"],"union_demands":["array"],"cost_analysis":"object","comparator_settlements":["array"]},"definition_of_done":"Complete bargaining book with costed proposals and counter-proposals ready"},
  {"step":4,"type":"tool_use","name":"conduct_contract_negotiations","description":"Represent management at collective bargaining table, document all proposals and counter-proposals, maintain NLRA good faith bargaining obligations","input":{"session_dates":["array"],"proposals_exchanged":["array"],"tentative_agreements":["array"],"impasse_declared":"boolean"},"definition_of_done":"Tentative agreement reached or impasse procedures invoked"},
  {"step":5,"type":"tool_use","name":"administer_collective_bargaining_agreement","description":"Interpret and apply CBA provisions, train supervisors on contract language, and develop consistent administration practices","input":{"cba_provisions":["array"],"supervisor_training_completed":"boolean","administration_guidelines":"object","past_practice_issues":["array"]},"definition_of_done":"CBA administration guide distributed, supervisors trained on key provisions"},
  {"step":6,"type":"tool_use","name":"monitor_nlra_compliance","description":"Ensure management actions comply with NLRA, advise on protected concerted activity, respond to NLRB charges","input":{"nlrb_charge_number":"string","charge_basis":"string","position_statement_due":"date","counsel_engaged":"boolean"},"definition_of_done":"NLRB response filed, compliance advice documented, charge resolved or litigated"}
]'::jsonb,
ARRAY['NLRB Case Management System','Westlaw/LexisNexis Labor Law','BNA Labor Relations','LaborSoft grievance tracking','HRIS (Workday, SAP HR)','Contract costing model (Excel/Tableau)','Arbitration case management']
);

-- ── 35. Logistics Engineers (13-1081.01) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Apply scientific and mathematical principles to the design, analysis, and improvement of logistics systems including transportation networks, warehousing operations, and supply chain integration.',
'[
  {"step":1,"type":"tool_use","name":"map_and_baseline_current_logistics_network","description":"Document current logistics network flows, costs, capacity, and service levels to establish baseline for engineering analysis","input":{"network_nodes":["array"],"transportation_lanes":["array"],"throughput_volumes":"object","cost_baseline":"object"},"definition_of_done":"Complete network map with quantified baseline metrics and identified inefficiencies"},
  {"step":2,"type":"tool_use","name":"conduct_logistics_systems_analysis","description":"Apply operations research and industrial engineering methods (simulation, linear programming, network optimization) to identify improvement opportunities","input":{"analysis_method":"string","decision_variables":["array"],"constraints":["array"],"objective_function":"string"},"definition_of_done":"Optimization model built and validated against baseline, improvement scenarios quantified"},
  {"step":3,"type":"tool_use","name":"design_improved_logistics_solution","description":"Design optimized network configuration, routing algorithms, warehouse layout, or automation specification to achieve target improvements","input":{"solution_design":"object","technology_requirements":["array"],"capital_cost_estimate":"number","operating_cost_delta":"number"},"definition_of_done":"Solution design document with technical specifications, ROI analysis, and implementation roadmap"},
  {"step":4,"type":"tool_use","name":"develop_and_test_logistics_models","description":"Build simulation or digital twin models of proposed logistics system to validate performance under various demand and disruption scenarios","input":{"simulation_software":"string","scenarios_tested":["array"],"kpi_results":"object","sensitivity_analysis":"object"},"definition_of_done":"Model validated with statistical confidence, performance projections finalized"},
  {"step":5,"type":"tool_use","name":"support_implementation_of_logistics_improvements","description":"Provide engineering support during implementation, develop standard operating procedures, and monitor KPIs against design targets","input":{"implementation_milestones":["array"],"sop_documents":["array"],"kpi_monitoring_dashboard":"string"},"definition_of_done":"System live at design performance, SOPs approved and trained"},
  {"step":6,"type":"tool_use","name":"conduct_post_implementation_review","description":"Measure actual vs projected performance, identify residual gaps, and document lessons learned for future engineering projects","input":{"actual_kpis":"object","projected_kpis":"object","variance_analysis":"object","lessons_learned":["array"]},"definition_of_done":"Post-implementation report published, improvement cycle initiated"}
]'::jsonb,
ARRAY['AnyLogic','Arena Simulation','CPLEX/Gurobi (optimization)','AutoCAD (warehouse layout)','SAP TM','Oracle Transportation Management','Python (supply chain analytics)','Tableau','GIS network tools']
);

-- ── 36. Logistics Analysts (13-1081.02) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Analyze product delivery or supply chain processes to identify or recommend changes. May manage route assignments and schedules.',
'[
  {"step":1,"type":"tool_use","name":"collect_and_validate_logistics_data","description":"Extract and validate data from TMS, WMS, ERP, and carrier systems to build analysis datasets on shipments, costs, and service performance","input":{"data_sources":["array"],"date_range":"string","data_quality_checks":["array"],"record_count":"number"},"definition_of_done":"Clean, validated dataset with documented assumptions and data dictionary"},
  {"step":2,"type":"tool_use","name":"analyze_supply_chain_performance","description":"Calculate KPIs for transportation cost per unit, on-time delivery, order cycle time, fill rate, and carrier performance","input":{"kpis_calculated":["array"],"comparison_period":"string","carrier_scorecards":"object","lane_level_analysis":"boolean"},"definition_of_done":"KPI dashboard populated with trend analysis and benchmark comparisons"},
  {"step":3,"type":"tool_use","name":"identify_cost_and_service_improvement_opportunities","description":"Analyze root causes of cost overruns, service failures, and capacity constraints using statistical methods and process mapping","input":{"root_cause_method":"string","priority_issues":["array"],"financial_impact":"number","service_impact":"string"},"definition_of_done":"Ranked improvement opportunity list with quantified business case for each"},
  {"step":4,"type":"tool_use","name":"develop_routing_and_scheduling_recommendations","description":"Optimize route assignments, carrier selection, load consolidation, and delivery scheduling to reduce cost and improve service","input":{"routing_optimization_tool":"string","lanes_analyzed":["array"],"consolidation_opportunities":["array"],"schedule_constraints":["array"]},"definition_of_done":"Recommended routing and scheduling plan with projected savings"},
  {"step":5,"type":"tool_use","name":"prepare_logistics_analysis_reports","description":"Compile analysis findings, recommendations, and supporting data into management reports and executive dashboards","input":{"report_audience":"string","key_findings":["array"],"recommendations":["array"],"implementation_steps":["array"]},"definition_of_done":"Report distributed to stakeholders, action items assigned with owners and dates"},
  {"step":6,"type":"tool_use","name":"monitor_improvement_implementation","description":"Track implementation of approved recommendations, measure results, and report progress against targets","input":{"initiatives_tracked":["array"],"savings_realized":"number","service_improvement":"object","status_report_frequency":"string"},"definition_of_done":"Improvement results documented, next analysis cycle initiated"}
]'::jsonb,
ARRAY['SAP TM','Oracle TM','Tableau','Power BI','Excel (advanced)','SQL','Python (pandas)','FourKites','project44','Carrier portals','WMS reporting modules']
);

-- ── 37. Meeting, Convention, and Event Planners (13-1121.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Coordinate activities of staff and convention personnel to make arrangements for group meetings and conventions.',
'[
  {"step":1,"type":"tool_use","name":"define_event_scope_and_requirements","description":"Gather client requirements for event purpose, audience size, budget, dates, location preferences, and program content","input":{"event_type":"string","expected_attendance":"number","budget":"number","target_dates":["array"],"location_preferences":"string"},"definition_of_done":"Event brief approved with signed requirements document"},
  {"step":2,"type":"tool_use","name":"source_and_contract_venue","description":"Research, evaluate, and negotiate contracts with venues including hotels, convention centers, and meeting facilities","input":{"venue_candidates":["array"],"space_requirements":"object","av_requirements":["array"],"F&B_minimum":"number","room_block":"number"},"definition_of_done":"Venue contract executed with space, services, and rates confirmed"},
  {"step":3,"type":"tool_use","name":"coordinate_vendor_and_supplier_contracts","description":"Contract and coordinate with A/V, catering, transportation, entertainment, décor, and registration vendors","input":{"vendors_needed":["array"],"vendor_contracts":["array"],"coordination_timeline":"object"},"definition_of_done":"All vendor contracts executed, coordination schedule distributed"},
  {"step":4,"type":"tool_use","name":"manage_registration_and_attendee_communications","description":"Set up and manage event registration system, communicate with attendees about logistics, manage room blocks and special requests","input":{"registration_platform":"string","registration_open_date":"date","communications_schedule":["array"],"special_accommodations":["array"]},"definition_of_done":"Registration system live, all pre-event communications delivered on schedule"},
  {"step":5,"type":"tool_use","name":"execute_onsite_event_management","description":"Manage all on-site logistics including setup, vendor coordination, staff assignments, speaker management, and real-time problem resolution","input":{"setup_timeline":"object","staff_assignments":["array"],"run_of_show":"object","contingency_plans":["array"]},"definition_of_done":"Event executed per program, all issues resolved, attendee satisfaction maintained"},
  {"step":6,"type":"tool_use","name":"conduct_post_event_closeout","description":"Reconcile all invoices and payments, collect attendee feedback, prepare event summary report with lessons learned and ROI analysis","input":{"final_budget_reconciliation":"object","attendee_satisfaction_score":"number","lessons_learned":["array"],"next_event_recommendations":["array"]},"definition_of_done":"Final invoices paid, event report delivered to client within 30 days"}
]'::jsonb,
ARRAY['Cvent','EventPro','Bizzabo','Aventri','Salesforce CRM','Survey tools (Qualtrics, SurveyMonkey)','Microsoft Project','Slack (vendor coordination)','Hotel RFP tools']
);

-- ── 38. Fundraisers (13-1131.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Organize activities to raise funds or otherwise solicit and gather monetary donations or other gifts for an organization. May design and produce promotional materials. May also raise awareness of the organization''s work, goals, and financial needs.',
'[
  {"step":1,"type":"tool_use","name":"develop_fundraising_strategy_and_annual_plan","description":"Analyze donor base, set fundraising goals, identify funding sources (major gifts, grants, annual fund, events, planned giving), and allocate resources","input":{"current_donor_base":"object","revenue_goal":"number","funding_source_mix":["array"],"budget":"number","staff_capacity":"object"},"definition_of_done":"Approved annual fundraising plan with monthly targets and activity calendar"},
  {"step":2,"type":"tool_use","name":"identify_and_research_donor_prospects","description":"Identify major gift prospects through wealth screening, board networks, and peer review; research giving capacity, interests, and connection to mission","input":{"screening_tool":"string","prospect_pool_size":"number","research_sources":["array"],"rating_criteria":["array"]},"definition_of_done":"Qualified major gift prospect list with capacity ratings and engagement plans"},
  {"step":3,"type":"tool_use","name":"cultivate_and_solicit_major_donors","description":"Develop individualized cultivation and stewardship plans, arrange meetings, make or support face-to-face solicitations","input":{"prospects_in_pipeline":["array"],"cultivation_activities":["array"],"ask_amounts":"object","solicitation_materials":["array"]},"definition_of_done":"Solicitation made to all qualified prospects with documented outcome"},
  {"step":4,"type":"tool_use","name":"execute_annual_fund_and_direct_response_campaigns","description":"Manage direct mail, email, phone, and digital fundraising campaigns to renew and upgrade annual donors","input":{"campaign_type":"string","segment_list":"object","message_and_ask_string":"string","response_rate_target":"number"},"definition_of_done":"Campaign launched on schedule, responses processed, results analyzed against targets"},
  {"step":5,"type":"tool_use","name":"write_and_submit_grant_proposals","description":"Research foundation and government grant opportunities, write proposals, track deadlines, and manage funder relationships","input":{"grant_opportunities":["array"],"proposal_deadlines":["array"],"narratives_written":["array"],"reporting_requirements":["array"]},"definition_of_done":"Proposals submitted by deadline, grant decisions tracked, reports filed on time"},
  {"step":6,"type":"tool_use","name":"steward_donors_and_report_impact","description":"Send acknowledgment letters, recognition, impact reports, and personalized stewardship communications to retain and upgrade donors","input":{"donors_stewardship_this_period":["array"],"acknowledgment_turnaround_days":"number","impact_report_sent":"boolean","retention_rate":"number"},"definition_of_done":"100% of donors acknowledged within 48 hours, retention rate at or above target"}
]'::jsonb,
ARRAY['Raiser''s Edge NXT','Salesforce NPSP','DonorPerfect','Blackbaud','iWave wealth screening','Moves Management software','Mailchimp/Constant Contact','Classy/GiveLively','Foundation Directory Online']
);

-- ── 39. Search Marketing Strategists (13-1161.01) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Develop and implement strategies for online search advertising and optimization campaigns. Employ the use of search engines to market client products or services through paid search advertising and organic search optimization.',
'[
  {"step":1,"type":"tool_use","name":"conduct_search_landscape_audit","description":"Audit current organic rankings, paid search account structure, Quality Scores, competitor SERP presence, and keyword coverage gaps","input":{"domain":"string","primary_keywords":["array"],"competitor_domains":["array"],"current_campaigns":"object"},"definition_of_done":"Full audit report with prioritized opportunity list and benchmark data"},
  {"step":2,"type":"tool_use","name":"develop_keyword_strategy_and_taxonomy","description":"Build comprehensive keyword universe through research tools, search volume data, intent classification, and negative keyword identification","input":{"seed_keywords":["array"],"intent_categories":["array"],"monthly_search_volume_minimum":"number","competition_threshold":"string"},"definition_of_done":"Structured keyword taxonomy with volume, intent, and bid estimates for each term"},
  {"step":3,"type":"tool_use","name":"build_and_optimize_paid_search_campaigns","description":"Create or restructure Google Ads and Microsoft Ads campaigns with tight ad groups, relevant ad copy, extensions, and landing page alignment","input":{"campaign_structure":"object","ad_copies":["array"],"extensions_configured":["array"],"landing_pages_mapped":"object","bid_strategy":"string"},"definition_of_done":"Campaigns live with Quality Scores ≥7, ad relevance and expected CTR Above Average"},
  {"step":4,"type":"tool_use","name":"execute_seo_strategy","description":"Implement on-page SEO recommendations, coordinate technical fixes, develop content strategy, and build authority through link acquisition","input":{"on_page_fixes":["array"],"technical_issues":["array"],"content_calendar":"object","link_building_targets":["array"]},"definition_of_done":"Prioritized SEO fixes implemented, content published on schedule, backlinks acquired"},
  {"step":5,"type":"tool_use","name":"optimize_campaigns_and_bids","description":"Manage ongoing bid optimization using automated rules, scripts, and manual analysis; A/B test ad copy and landing pages; adjust targeting","input":{"optimization_frequency":"string","bid_adjustments":"object","tests_running":["array"],"budget_pacing":"object"},"definition_of_done":"CPA/ROAS at or below target with positive performance trend vs prior period"},
  {"step":6,"type":"tool_use","name":"report_search_marketing_performance","description":"Compile weekly and monthly performance reports with insights on impressions, clicks, CTR, conversions, CPA, Quality Score, and organic ranking changes","input":{"report_period":"string","kpis_reported":["array"],"insights":["array"],"recommendations":["array"]},"definition_of_done":"Report delivered to stakeholders with actionable recommendations and next period plan"}
]'::jsonb,
ARRAY['Google Ads','Microsoft Advertising','Google Search Console','Google Analytics 4','SEMrush','Ahrefs','Moz','Screaming Frog','Looker Studio','Supermetrics','Optmyzr']
);

-- ── 40. Business Continuity Planners (13-1199.04) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Develop, maintain, or implement business continuity and disaster recovery strategies and solutions, including risk assessments, business impact analyses, strategy selection, and documentation of business continuity and disaster recovery procedures.',
'[
  {"step":1,"type":"tool_use","name":"conduct_business_impact_analysis","description":"Identify critical business processes, determine recovery time objectives (RTO) and recovery point objectives (RPO), and quantify financial impact of disruptions","input":{"business_units_assessed":["array"],"processes_inventoried":["array"],"rto_targets":"object","rpo_targets":"object"},"definition_of_done":"BIA report approved by executive leadership with validated RTO/RPO for all critical processes"},
  {"step":2,"type":"tool_use","name":"assess_organizational_risk","description":"Identify threats and vulnerabilities to critical processes through risk assessment methodology (ISO 22301, NIST SP 800-34), evaluate likelihood and impact","input":{"threat_categories":["array"],"vulnerability_assessment":"object","risk_matrix":"object","residual_risk":"object"},"definition_of_done":"Risk register completed and accepted by risk committee"},
  {"step":3,"type":"tool_use","name":"develop_continuity_strategies_and_plans","description":"Design recovery strategies for people, facilities, technology, and suppliers; document Business Continuity Plan and IT Disaster Recovery Plan","input":{"recovery_strategies":["array"],"bcp_document":"object","drp_document":"object","workaround_procedures":["array"]},"definition_of_done":"BCP and DRP documents reviewed and approved by senior leadership"},
  {"step":4,"type":"tool_use","name":"coordinate_bcp_awareness_and_training","description":"Train business unit recovery teams, BCP coordinators, and crisis management teams on plan procedures and their roles","input":{"training_audiences":["array"],"training_format":"string","completion_rate_target":"number","training_records":"object"},"definition_of_done":"All recovery team members trained and training records archived"},
  {"step":5,"type":"tool_use","name":"conduct_exercises_and_tests","description":"Plan and execute tabletop exercises, functional exercises, and full-scale tests to validate plan effectiveness and identify gaps","input":{"exercise_type":"string","scenario":"string","participants":["array"],"gaps_identified":["array"]},"definition_of_done":"Exercise after-action report with findings and corrective action plan approved"},
  {"step":6,"type":"tool_use","name":"maintain_and_update_bcp","description":"Conduct annual BCP review cycle, update plans for organizational changes, incorporate lessons learned, and track corrective actions to closure","input":{"review_cycle":"string","changes_incorporated":["array"],"corrective_actions_open":"number","plan_version":"string"},"definition_of_done":"Updated plans distributed, version control maintained, executive re-approval obtained"}
]'::jsonb,
ARRAY['Fusion Framework','Castellan BCP','Archer GRC','ServiceNow BCP module','Veeam (DR)','Zerto','ISO 22301 documentation','NIST SP 800-34','DRaaS platforms']
);

-- ── 41. Sustainability Specialists (13-1199.05) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Address organizational sustainability issues, such as waste stream management, green building practices, and the promotion of sustainable organizational policies and practices.',
'[
  {"step":1,"type":"tool_use","name":"conduct_sustainability_materiality_assessment","description":"Identify material ESG topics through stakeholder engagement, industry benchmarking, and regulatory landscape analysis","input":{"stakeholder_groups":["array"],"esg_topics_assessed":["array"],"frameworks_used":["array"],"peer_benchmarks":["array"]},"definition_of_done":"Materiality matrix finalized and approved, material topics prioritized for reporting"},
  {"step":2,"type":"tool_use","name":"measure_and_inventory_environmental_footprint","description":"Collect and calculate GHG emissions (Scope 1, 2, 3), energy consumption, water use, and waste generation per GHG Protocol and CDP standards","input":{"scope_1_sources":["array"],"scope_2_method":"string","scope_3_categories":["array"],"measurement_year":"number"},"definition_of_done":"Verified emissions inventory with third-party assurance completed"},
  {"step":3,"type":"tool_use","name":"develop_sustainability_strategy_and_targets","description":"Set science-based targets (SBTi), develop reduction roadmap, and identify sustainability initiatives aligned with business strategy","input":{"baseline_year":"number","net_zero_target_year":"number","interim_targets":"object","reduction_levers":["array"]},"definition_of_done":"Board-approved sustainability strategy with SMART targets and initiative roadmap"},
  {"step":4,"type":"tool_use","name":"implement_sustainability_programs","description":"Execute energy efficiency, renewable energy, waste reduction, circular economy, and supply chain sustainability programs","input":{"programs_active":["array"],"capital_projects":["array"],"supplier_engagement":"boolean","renewable_energy_target":"number"},"definition_of_done":"Programs on track vs implementation milestones, emissions reductions achieved"},
  {"step":5,"type":"tool_use","name":"prepare_esg_and_sustainability_report","description":"Compile sustainability data and narrative per GRI, SASB, TCFD, and SEC climate disclosure frameworks","input":{"reporting_frameworks":["array"],"disclosure_topics":["array"],"third_party_assurance":"boolean","publication_date":"date"},"definition_of_done":"Sustainability report published, data submitted to CDP, DJSI, and other raters"},
  {"step":6,"type":"tool_use","name":"engage_stakeholders_and_advance_policy","description":"Engage investors, customers, regulators, and communities on sustainability progress; participate in industry coalitions and policy forums","input":{"investor_esg_meetings":["array"],"industry_coalitions":["array"],"regulatory_engagement":"object","community_programs":["array"]},"definition_of_done":"Stakeholder engagement activities completed, feedback incorporated into next strategy cycle"}
]'::jsonb,
ARRAY['Sphera ESG','Enablon','Persefoni (carbon accounting)','CDP reporting portal','EcoVadis','GRI Standards','TCFD framework','SBTi tools','ENERGY STAR Portfolio Manager','LEED certification tools']
);

-- ── 42. Online Merchants (13-1199.06) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Conduct retail activities of businesses that operate exclusively online. May develop marketing strategies, communicate with vendors/suppliers, identify new products, oversee direct shipping activities, or manage payment transactions.',
'[
  {"step":1,"type":"tool_use","name":"manage_product_catalog_and_listings","description":"Create and optimize product listings with SEO-rich titles, descriptions, images, and attributes across all sales channels","input":{"products_to_list":["array"],"channels":["array"],"seo_keywords":["array"],"image_requirements":"object"},"definition_of_done":"All products live on all channels with complete, optimized listings"},
  {"step":2,"type":"tool_use","name":"manage_inventory_and_supplier_relationships","description":"Monitor inventory levels, reorder points, and supplier lead times; negotiate procurement terms and manage purchase orders","input":{"sku_count":"number","reorder_points":"object","supplier_list":["array"],"po_pending":["array"]},"definition_of_done":"Inventory in-stock rate ≥98%, all POs confirmed with expected receipt dates"},
  {"step":3,"type":"tool_use","name":"execute_digital_marketing_and_promotions","description":"Plan and execute paid advertising (Google Shopping, Meta Ads), email campaigns, and promotions to drive traffic and conversion","input":{"campaign_budget":"number","channels":["array"],"promotions_calendar":"object","target_roas":"number"},"definition_of_done":"Campaigns active, ROAS meeting target, promo codes validated and active"},
  {"step":4,"type":"tool_use","name":"manage_order_processing_and_fulfillment","description":"Monitor order queues, coordinate fulfillment (3PL or in-house), process payment transactions, and manage shipping carrier performance","input":{"daily_order_volume":"number","fulfillment_method":"string","carrier_mix":["array"],"sla_hours":"number"},"definition_of_done":"Orders processed and shipped within SLA, payment transactions reconciled daily"},
  {"step":5,"type":"tool_use","name":"handle_customer_service_and_returns","description":"Manage customer inquiries, resolve disputes, process returns and exchanges, and maintain seller performance metrics on platforms","input":{"ticket_volume":"number","response_time_target_hours":"number","return_rate":"number","seller_rating":"number"},"definition_of_done":"Response SLA met, customer satisfaction score maintained, return rate within threshold"},
  {"step":6,"type":"tool_use","name":"analyze_sales_data_and_optimize_performance","description":"Analyze sales trends, conversion rates, customer acquisition costs, and margin by SKU and channel to optimize assortment and marketing mix","input":{"analytics_period":"string","top_skus":"object","channel_performance":"object","margin_analysis":"object"},"definition_of_done":"Monthly performance report with actionable optimization recommendations implemented"}
]'::jsonb,
ARRAY['Shopify','Amazon Seller Central','WooCommerce','BigCommerce','Google Merchant Center','Meta Ads Manager','Klaviyo','ShipStation','Inventory Planner','Linnworks','Jungle Scout']
);

-- ── 43. Security Management Specialists (13-1199.07) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Plan and coordinate security operations for specified areas such as office buildings, retail stores, or industrial complexes. May direct staff who protect property from theft, vandalism, or fire; or coordinate security activities such as access control.',
'[
  {"step":1,"type":"tool_use","name":"conduct_security_risk_assessment","description":"Assess physical security vulnerabilities, threats, and risks for assigned facilities or operational areas using structured methodology","input":{"facility_type":"string","assets_protected":["array"],"threat_scenarios":["array"],"current_controls":"object"},"definition_of_done":"Risk assessment report with prioritized vulnerability list and recommended countermeasures"},
  {"step":2,"type":"tool_use","name":"develop_security_plans_and_procedures","description":"Develop comprehensive security plans covering access control, patrol procedures, emergency response, and incident protocols","input":{"security_zones":["array"],"access_control_design":"object","patrol_routes":"object","emergency_procedures":["array"]},"definition_of_done":"Security plan approved by leadership, SOPs distributed to all security personnel"},
  {"step":3,"type":"tool_use","name":"manage_security_personnel_and_contractors","description":"Schedule security officers, conduct performance evaluations, manage contract security vendor relationships, and ensure post coverage","input":{"post_assignments":["array"],"staff_count":"number","contractor_vendor":"string","performance_standards":"object"},"definition_of_done":"All posts covered 24/7, performance standards maintained, contractor compliance verified"},
  {"step":4,"type":"tool_use","name":"oversee_access_control_and_surveillance","description":"Manage badge access systems, visitor management, and CCTV surveillance to monitor and control access to protected areas","input":{"access_control_system":"string","camera_coverage":"object","visitor_protocol":"object","restricted_areas":["array"]},"definition_of_done":"Access control system configured correctly, surveillance coverage gaps remediated"},
  {"step":5,"type":"tool_use","name":"investigate_and_report_security_incidents","description":"Investigate security incidents including theft, trespass, vandalism, and policy violations; prepare incident reports and coordinate with law enforcement","input":{"incident_type":"string","evidence_collected":["array"],"witnesses_interviewed":["array"],"law_enforcement_notified":"boolean"},"definition_of_done":"Incident report completed within 24 hours, root cause analysis and corrective actions documented"},
  {"step":6,"type":"tool_use","name":"coordinate_emergency_preparedness_and_response","description":"Conduct drills, maintain emergency response plans, coordinate with local emergency services, and lead response during critical incidents","input":{"drill_frequency":"string","emergency_scenarios":["array"],"local_emergency_contacts":"object","incident_command_structure":"object"},"definition_of_done":"Annual drills completed, emergency plans current, after-action improvements implemented"}
]'::jsonb,
ARRAY['Lenel OnGuard','Software House C•CURE','Milestone XProtect (VMS)','Genetec Security Center','Incident reporting system (Resolver, Origami)','GuardTour Pro','ASIS CPP study materials','Everbridge mass notification']
);

-- ══════════════════════════════════════════════════════════════
-- REMAINING FINANCE 13-2xxx ROLES
-- ══════════════════════════════════════════════════════════════

-- ── 44. Appraisers of Personal and Business Property (13-2022.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Appraise and estimate the fair value of tangible personal property, such as jewelry, art, antiques, collectibles, and equipment. May also appraise business entities and intangible assets.',
'[
  {"step":1,"type":"tool_use","name":"accept_and_define_appraisal_assignment","description":"Define appraisal purpose, effective date, property to be appraised, intended use, and applicable appraisal standards (USPAP, IRS Revenue Procedure)","input":{"client_name":"string","property_type":"string","appraisal_purpose":"string","effective_date":"date","intended_use":"string"},"definition_of_done":"Appraisal engagement letter signed with scope clearly defined"},
  {"step":2,"type":"tool_use","name":"inspect_and_document_subject_property","description":"Physically inspect, photograph, and document all properties including condition, provenance, marks, materials, dimensions, and unique characteristics","input":{"property_items":["array"],"condition_ratings":["array"],"provenance_documents":["array"],"photographs_taken":"boolean"},"definition_of_done":"Complete property inventory with detailed descriptions and photo documentation"},
  {"step":3,"type":"tool_use","name":"research_market_comparables","description":"Research auction records, dealer sales, price databases, and market reports to identify comparable sales for each item","input":{"auction_databases":["array"],"comparable_sales":["array"],"market_conditions":"string","date_range_for_comps":"string"},"definition_of_done":"Comparable sales file assembled for each item with source citations"},
  {"step":4,"type":"tool_use","name":"apply_appraisal_methodology","description":"Apply appropriate valuation approaches (sales comparison, cost, income) and reconcile value indications to final value conclusions","input":{"valuation_approaches":["array"],"adjustments_made":["array"],"value_indications":"object","reconciled_values":"object"},"definition_of_done":"Value conclusions supported by market evidence and professional judgment"},
  {"step":5,"type":"tool_use","name":"prepare_appraisal_report","description":"Prepare USPAP-compliant written appraisal report with property descriptions, methodology, comparable analysis, and certified value conclusions","input":{"report_type":"string","certification_signed":"boolean","limiting_conditions":["array"],"total_appraised_value":"number"},"definition_of_done":"Signed and certified appraisal report delivered to client"},
  {"step":6,"type":"tool_use","name":"support_client_and_regulatory_review","description":"Respond to IRS, estate attorney, or insurance company inquiries about appraisal methodology, support audit defense, and provide expert testimony if required","input":{"reviewing_party":"string","questions_received":["array"],"additional_documentation":["array"],"testimony_required":"boolean"},"definition_of_done":"All inquiries addressed, appraisal position defended, case resolved"}
]'::jsonb,
ARRAY['Invaluable','Artnet','Christie''s/Sotheby''s auction database','NADA Guides (equipment)','Machinery Info (MACI)','RealPage','USPAP standards','ASA/AAA appraisal databases','Collectibles insurance databases']
);

-- ── 45. Appraisers and Assessors of Real Estate (13-2023.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Appraise real estate or estimate the fair value of land and buildings for sale, mortgage, tax assessment, insurance, or condemnation purposes.',
'[
  {"step":1,"type":"tool_use","name":"accept_appraisal_assignment_and_scope","description":"Define appraisal purpose, effective date, property rights appraised, client/intended user, and applicable standards (USPAP, FIRREA)","input":{"property_address":"string","appraisal_purpose":"string","client_lender":"string","effective_date":"date","intended_use":"string"},"definition_of_done":"Engagement letter or order accepted with scope clearly documented"},
  {"step":2,"type":"tool_use","name":"conduct_property_inspection","description":"Physically inspect subject property — exterior, interior, site, improvements, condition — and measure gross living area per ANSI standards","input":{"inspection_date":"date","property_type":"string","year_built":"number","gla_sq_ft":"number","condition_rating":"string"},"definition_of_done":"Complete inspection with sketch, photos, and deficiency notes documented"},
  {"step":3,"type":"tool_use","name":"research_market_data_and_comparables","description":"Search MLS, public records, and deed data for comparable sales, listings, and market condition data within subject''s competitive market area","input":{"search_radius_miles":"number","time_period_months":"number","comparables_identified":["array"],"market_trend":"string"},"definition_of_done":"Minimum 3 closed comparables confirmed with verified data"},
  {"step":4,"type":"tool_use","name":"apply_sales_comparison_approach","description":"Adjust comparables for differences in location, size, condition, features, and market time to derive adjusted sales prices and value indication","input":{"comparable_sales":["array"],"adjustments_applied":"object","adjusted_prices":["array"],"reconciled_value":"number"},"definition_of_done":"Sales comparison value conclusion with net/gross adjustment analysis within FNMA guidelines"},
  {"step":5,"type":"tool_use","name":"apply_cost_and_income_approaches_if_applicable","description":"Apply cost approach (land value + depreciated improvement cost) and/or income approach (GRM or capitalized NOI) as applicable to property type","input":{"cost_approach_applicable":"boolean","income_approach_applicable":"boolean","land_value":"number","effective_age_years":"number","cap_rate":"number"},"definition_of_done":"All applicable approaches completed, values reconciled to final opinion of value"},
  {"step":6,"type":"tool_use","name":"prepare_and_certify_appraisal_report","description":"Complete FNMA 1004/1073/1025 or narrative appraisal report, certify per USPAP, and submit to lender or client","input":{"report_form":"string","uspap_certification":"boolean","final_value_opinion":"number","submission_method":"string"},"definition_of_done":"Signed and certified appraisal submitted, underwriting conditions resolved"}
]'::jsonb,
ARRAY['TOTAL by a la mode','ACI Appraisal','Bradford Technologies','ClickFORMS','MLS (local board)','CoreLogic','DataMaster','Sketch/sketch software','FNMA Forms (UAD)','FHA Connection']
);

-- ── 46. Credit Counselors (13-2071.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Advise and educate individuals or organizations on acquiring and managing debt. May provide guidance in determining the best type of loan and explain loan requirements or restrictions.',
'[
  {"step":1,"type":"tool_use","name":"conduct_financial_counseling_intake","description":"Gather complete financial picture from client including income, expenses, assets, liabilities, credit report, and financial goals","input":{"client_id":"string","income_sources":["array"],"monthly_expenses":["array"],"total_debt":"number","credit_score":"number"},"definition_of_done":"Complete financial snapshot documented, client consent and disclosure forms signed"},
  {"step":2,"type":"tool_use","name":"analyze_client_financial_situation","description":"Calculate debt-to-income ratio, cash flow, and net worth; review credit report for derogatory items, errors, and improvement opportunities","input":{"dti_ratio":"number","monthly_surplus_deficit":"number","credit_report_items":["array"],"error_disputes_needed":"boolean"},"definition_of_done":"Written financial analysis completed with prioritized issue list"},
  {"step":3,"type":"tool_use","name":"develop_personalized_action_plan","description":"Create individualized debt management or financial education plan with specific steps for budgeting, debt payoff strategy, and credit building","input":{"plan_type":"string","monthly_payment_plan":"object","payoff_timeline_months":"number","credit_building_steps":["array"]},"definition_of_done":"Action plan reviewed and signed by client with clear milestones"},
  {"step":4,"type":"tool_use","name":"negotiate_debt_management_plan_with_creditors","description":"If appropriate, negotiate reduced interest rates and consolidated payments through Debt Management Plan (DMP) with creditor participation","input":{"creditors_contacted":["array"],"rate_reductions_negotiated":"object","monthly_dmp_payment":"number","dmp_term_months":"number"},"definition_of_done":"DMP established with all participating creditors, first payment scheduled"},
  {"step":5,"type":"tool_use","name":"provide_ongoing_counseling_and_education","description":"Conduct follow-up counseling sessions, monitor budget adherence, provide financial literacy education on credit, budgeting, and savings","input":{"session_frequency":"string","topics_covered":["array"],"budget_compliance":"boolean","credit_score_change":"number"},"definition_of_done":"Client demonstrating measurable financial improvement, education modules completed"},
  {"step":6,"type":"tool_use","name":"evaluate_housing_or_specialized_counseling","description":"Provide HUD-approved housing counseling for homebuyers, foreclosure prevention, or reverse mortgage clients per HUD protocols","input":{"counseling_type":"string","hud_approval_number":"string","certificates_issued":"boolean","referrals_made":["array"]},"definition_of_done":"HUD-required certificates issued, referrals to appropriate housing resources completed"}
]'::jsonb,
ARRAY['DebtPayPro CMS','NFCC counseling platform','HUD CMS (Client Management System)','Credit report (Experian, Equifax, TransUnion)','CUNA Mutual','Budget worksheet tools','FCRA dispute portal','Mortgage counseling curriculum']
);

-- ── 47. Tax Preparers (13-2082.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Prepare tax returns for individuals or small businesses. Check for completeness and accuracy of information and ensure compliance with current tax law.',
'[
  {"step":1,"type":"tool_use","name":"gather_and_organize_client_tax_documents","description":"Collect all required tax documents — W-2s, 1099s, K-1s, mortgage interest, charitable contributions, business records — and organize for data entry","input":{"tax_year":"number","client_id":"string","documents_received":["array"],"documents_missing":["array"]},"definition_of_done":"Complete document checklist signed off, all required forms received"},
  {"step":2,"type":"tool_use","name":"enter_and_review_tax_data","description":"Enter all income, deduction, and credit data into tax preparation software; cross-check against prior year return and identify discrepancies","input":{"income_items":["array"],"deductions":["array"],"credits":["array"],"prior_year_comparison":"object"},"definition_of_done":"All data entered accurately, diagnostic errors cleared"},
  {"step":3,"type":"tool_use","name":"optimize_filing_status_and_deductions","description":"Determine optimal filing status, evaluate standard vs itemized deduction, and identify all applicable credits and deductions to minimize tax liability legally","input":{"filing_status_options":["array"],"itemized_total":"number","standard_deduction":"number","credits_available":["array"]},"definition_of_done":"Optimal tax position documented with filing status and deduction method selected"},
  {"step":4,"type":"tool_use","name":"prepare_and_review_return_for_accuracy","description":"Complete final return review for mathematical accuracy, form completeness, and compliance with current IRS regulations and state tax law","input":{"forms_prepared":["array"],"total_tax_liability":"number","refund_or_balance_due":"number","review_checklist_completed":"boolean"},"definition_of_done":"Return passes quality review, all required forms attached"},
  {"step":5,"type":"tool_use","name":"obtain_client_signature_and_file_return","description":"Present return to client for review and signature, explain key items, obtain consent to e-file, and electronically transmit to IRS and state agencies","input":{"client_presentation_completed":"boolean","signature_forms":["array"],"efile_authorization":"boolean","filing_date":"date"},"definition_of_done":"Return accepted by IRS/state, acknowledgment confirmation archived"},
  {"step":6,"type":"tool_use","name":"archive_records_and_respond_to_notices","description":"Retain copies of filed returns and supporting documents per IRS retention requirements; assist client with IRS or state notices and correspondence","input":{"records_retained_years":"number","notice_type":"string","response_due_date":"date","amended_return_required":"boolean"},"definition_of_done":"Records archived securely, notice response filed timely"}
]'::jsonb,
ARRAY['Intuit ProConnect','Drake Tax','TaxSlayer Pro','H&R Block Tax Pro','Thomson Reuters UltraTax','IRS e-file system','IRS Free File','Publication 17','State tax preparation software']
);

-- ── 48. Financial Quantitative Analysts (13-2099.01) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Develop quantitative financial models to evaluate investment opportunities, assess risk, price derivatives, and optimize portfolio performance. Apply mathematical, statistical, and programming skills to financial problems.',
'[
  {"step":1,"type":"tool_use","name":"define_quantitative_problem_and_data_requirements","description":"Define the financial problem (pricing, risk measurement, alpha generation, portfolio optimization), specify required data, and select modeling approach","input":{"problem_type":"string","modeling_approach":"string","data_requirements":["array"],"target_accuracy":"string"},"definition_of_done":"Project specification document approved by stakeholders with clear success criteria"},
  {"step":2,"type":"tool_use","name":"acquire_and_clean_financial_data","description":"Source market data (prices, rates, alternative data), perform quality checks, handle missing values, and construct model-ready time series datasets","input":{"data_vendors":["array"],"securities_universe":["array"],"date_range":"string","data_frequency":"string"},"definition_of_done":"Clean, validated dataset with documented data lineage and quality statistics"},
  {"step":3,"type":"tool_use","name":"develop_and_calibrate_quantitative_model","description":"Build mathematical model using statistical, machine learning, or stochastic methods; calibrate parameters to historical data and validate assumptions","input":{"model_type":"string","programming_language":"string","calibration_method":"string","validation_tests":["array"]},"definition_of_done":"Model implemented and calibrated, statistical validity tests passed"},
  {"step":4,"type":"tool_use","name":"backtest_and_stress_test_model","description":"Backtest model performance on out-of-sample historical data; stress test against tail scenarios including market crises and regime changes","input":{"backtest_period":"string","out_of_sample_period":"string","stress_scenarios":["array"],"performance_metrics":["array"]},"definition_of_done":"Backtest complete with risk-adjusted performance metrics, stress test results documented"},
  {"step":5,"type":"tool_use","name":"implement_model_in_production","description":"Translate validated model into production-grade code, integrate with trading or risk systems, and establish monitoring and alert framework","input":{"production_language":"string","integration_systems":["array"],"monitoring_alerts":["array"],"deployment_documentation":"object"},"definition_of_done":"Model deployed, integrated with live systems, monitoring operational"},
  {"step":6,"type":"tool_use","name":"monitor_and_recalibrate_model_performance","description":"Monitor model performance vs expectations, investigate degradation, recalibrate parameters, and publish performance attribution analysis","input":{"monitoring_frequency":"string","performance_metrics":"object","degradation_threshold":"string","recalibration_trigger":"string"},"definition_of_done":"Model within acceptable performance bounds, recalibration schedule maintained"}
]'::jsonb,
ARRAY['Python (NumPy, pandas, scikit-learn, PyTorch)','R','MATLAB','Bloomberg Terminal','FactSet','Refinitiv Eikon','C++ (high-frequency)','SQL','kdb+/Q','Risk systems (MSCI RiskMetrics, Axioma)','Jupyter Notebooks']
);

-- ══════════════════════════════════════════════════════════════
-- LEGAL CLUSTER (23-xxxx) — ALL 8 ROLES
-- ══════════════════════════════════════════════════════════════

-- ── 49. Lawyers (23-1011.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Represent clients in criminal and civil litigation and other legal proceedings, draw up legal documents, or manage or advise clients on legal transactions. May specialize in a single area or may practice broadly in many areas of law.',
'[
  {"step":1,"type":"tool_use","name":"conduct_client_intake_and_matter_assessment","description":"Evaluate potential client matter for legal merit, conflicts of interest, jurisdiction, and scope; establish engagement terms and retainer agreement","input":{"client_name":"string","matter_type":"string","facts_presented":"string","statute_of_limitations":"date","conflicts_check_cleared":"boolean"},"definition_of_done":"Engagement letter signed, matter opened in case management system, conflicts cleared"},
  {"step":2,"type":"tool_use","name":"research_applicable_law_and_precedent","description":"Research statutes, regulations, case law, and secondary sources to identify controlling authority, applicable defenses, and legal strategy options","input":{"jurisdiction":"string","legal_issues":["array"],"research_databases":["array"],"key_precedents":["array"]},"definition_of_done":"Research memorandum completed with analysis of legal issues and recommended strategy"},
  {"step":3,"type":"tool_use","name":"conduct_discovery_or_due_diligence","description":"Plan and execute discovery (interrogatories, depositions, document requests, subpoenas) or transactional due diligence to develop the factual record","input":{"discovery_type":"string","documents_requested":["array"],"depositions_scheduled":["array"],"expert_witnesses":["array"]},"definition_of_done":"Full evidentiary record assembled, discovery responses complete and verified"},
  {"step":4,"type":"tool_use","name":"draft_and_review_legal_documents","description":"Draft pleadings, motions, briefs, contracts, agreements, and legal instruments with precision and compliance with applicable rules and standards","input":{"document_type":"string","applicable_rules":"string","key_provisions":["array"],"negotiation_terms":["array"]},"definition_of_done":"Document reviewed, revised per comments, and executed or filed"},
  {"step":5,"type":"tool_use","name":"represent_client_in_proceedings","description":"Appear in court, arbitration, regulatory hearings, or at negotiation table to advance client interests through oral argument, examination, and advocacy","input":{"proceeding_type":"string","court_or_tribunal":"string","hearing_date":"date","arguments_prepared":["array"]},"definition_of_done":"Proceeding completed, outcome documented, follow-up actions assigned"},
  {"step":6,"type":"tool_use","name":"advise_on_risk_and_resolve_matter","description":"Provide strategic legal advice on risk, evaluate settlement or transaction terms, and work toward final resolution — verdict, settlement, closing, or opinion","input":{"resolution_type":"string","client_recommendation":"string","risk_analysis":"object","final_outcome":"string"},"definition_of_done":"Matter resolved, client advised, file closed and archived per retention policy"}
]'::jsonb,
ARRAY['Westlaw','LexisNexis','Casetext','PACER','iManage (document management)','Relativity (eDiscovery)','Clio (practice management)','MyCase','DocuSign','Kira (contract review AI)']
);

-- ── 50. Judicial Law Clerks (23-1012.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Assist judges in court by researching legal questions, drafting opinions, and analyzing briefs and records submitted to the court. Perform legal research, draft bench memoranda, and prepare orders and opinions under judicial supervision.',
'[
  {"step":1,"type":"tool_use","name":"review_and_analyze_case_filings","description":"Review all briefs, motions, pleadings, and record on appeal filed in assigned cases to identify legal issues and factual background","input":{"case_number":"string","docket_entries":["array"],"briefs_reviewed":["array"],"procedural_posture":"string"},"definition_of_done":"Case summary with procedural history and issue identification complete"},
  {"step":2,"type":"tool_use","name":"research_controlling_legal_authority","description":"Research applicable statutes, regulations, constitutional provisions, and binding/persuasive precedent in assigned jurisdiction","input":{"legal_issues":["array"],"circuit_jurisdiction":"string","research_databases":["array"],"key_cases_found":["array"]},"definition_of_done":"Research complete with synthesis of controlling authority and identification of circuit splits or open questions"},
  {"step":3,"type":"tool_use","name":"prepare_bench_memorandum","description":"Draft bench memo summarizing facts, issues, law, and recommended outcome for judge''s review before hearing or conference","input":{"case_name":"string","summary_of_facts":"string","legal_analysis":"string","recommended_disposition":"string","sensitive_issues":["array"]},"definition_of_done":"Bench memo reviewed and approved by judge, marked for hearing"},
  {"step":4,"type":"tool_use","name":"assist_at_oral_argument_or_hearing","description":"Attend hearings, take notes on arguments made, identify questions the judge may have, and flag issues that require follow-up research","input":{"hearing_date":"date","parties_appeared":["array"],"arguments_summary":"string","follow_up_issues":["array"]},"definition_of_done":"Hearing notes compiled, follow-up research assigned and completed"},
  {"step":5,"type":"tool_use","name":"draft_opinion_or_order","description":"Draft judicial opinion, order, or decision based on judge''s direction, ensuring legal accuracy, proper citation, and clarity of reasoning","input":{"decision_type":"string","holding":"string","reasoning":"string","citations":["array"],"length_pages":"number"},"definition_of_done":"Draft opinion reviewed by judge, revisions incorporated, final version ready for release"},
  {"step":6,"type":"tool_use","name":"finalize_and_file_court_documents","description":"Finalize opinions and orders for filing, ensure proper formatting per court rules, coordinate with clerk''s office for publication","input":{"document_finalized":"boolean","formatting_rules_applied":"string","filing_date":"date","publication_status":"string"},"definition_of_done":"Opinion filed and posted to court website, parties notified"}
]'::jsonb,
ARRAY['Westlaw','LexisNexis','PACER/CM-ECF','Fastcase','Google Scholar (case law)','Bluebook citation guide','Court-specific CM/ECF system','Microsoft Word (legal formatting)']
);

-- ── 51. Administrative Law Judges, Adjudicators, and Hearing Officers (23-1021.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Conduct hearings to recommend or make decisions on claims concerning government programs or activities. Preside over hearings to determine eligibility for government programs, penalties for regulatory violations, or other administrative matters.',
'[
  {"step":1,"type":"tool_use","name":"review_case_file_and_schedule_hearing","description":"Review administrative record, identify issues for hearing, verify jurisdiction, and schedule proceeding per APA and agency rules","input":{"case_number":"string","claimant_name":"string","agency_program":"string","issues_to_be_heard":["array"],"hearing_format":"string"},"definition_of_done":"Case ready for hearing, all parties notified with prehearing order"},
  {"step":2,"type":"tool_use","name":"conduct_prehearing_conference","description":"Hold prehearing conference to narrow issues, address procedural motions, set briefing schedule, and facilitate potential settlement","input":{"prehearing_motions":["array"],"stipulated_facts":["array"],"contested_issues":["array"],"settlement_discussed":"boolean"},"definition_of_done":"Prehearing order issued with final hearing schedule and ruling on motions"},
  {"step":3,"type":"tool_use","name":"preside_over_administrative_hearing","description":"Conduct formal or informal hearing, admit evidence, examine witnesses, rule on evidentiary objections, and maintain complete record","input":{"hearing_date":"date","witnesses_examined":["array"],"exhibits_admitted":["array"],"objections_ruled_on":["array"]},"definition_of_done":"Complete hearing record on file, transcript ordered"},
  {"step":4,"type":"tool_use","name":"review_post_hearing_briefs_and_evidence","description":"Review post-hearing briefs, proposed findings of fact, and entire record to evaluate credibility and weigh evidence","input":{"briefs_received":["array"],"record_volumes":"number","credibility_findings":"object","evidence_weight_analysis":"object"},"definition_of_done":"All post-hearing submissions reviewed, record closed"},
  {"step":5,"type":"tool_use","name":"draft_initial_decision_or_recommended_decision","description":"Write decision applying controlling statutes, regulations, and agency precedent to findings of fact, with clear holdings and remedy","input":{"findings_of_fact":["array"],"conclusions_of_law":["array"],"holding":"string","remedy_ordered":"string"},"definition_of_done":"Decision complete with proper citations, signed and issued to parties"},
  {"step":6,"type":"tool_use","name":"manage_appellate_or_review_proceedings","description":"Respond to appeals, motions for reconsideration, or agency review of initial decision; coordinate record transmission","input":{"appeal_filed":"boolean","grounds_for_appeal":["array"],"record_transmitted":"boolean","final_agency_action":"string"},"definition_of_done":"All appellate matters addressed, final order entered"}
]'::jsonb,
ARRAY['ALJNET case management','Agency-specific hearing systems (SSA HOCALJ, MSPB e-Appeal)','Westlaw/LexisNexis','PACER','Hearing room recording systems','Adobe Acrobat (record management)','Agency e-docket systems']
);

-- ── 52. Arbitrators, Mediators, and Conciliators (23-1022.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Facilitate negotiation and conflict resolution through dialogue. Resolve conflicts outside of the court system by mutual consent of parties. May conduct hearings to determine the facts and make binding decisions in arbitration.',
'[
  {"step":1,"type":"tool_use","name":"accept_case_and_conduct_conflict_check","description":"Review dispute referral, confirm jurisdiction under applicable ADR agreement (AAA, JAMS, ICC rules), disclose all potential conflicts of interest to parties","input":{"case_type":"string","parties":["array"],"governing_rules":"string","conflict_check_completed":"boolean","disclosures_made":["array"]},"definition_of_done":"Appointment accepted or declined, disclosure acknowledged by parties"},
  {"step":2,"type":"tool_use","name":"conduct_preliminary_conference","description":"Hold preliminary conference to establish ground rules, schedule, discovery parameters (arbitration) or ground rules (mediation), and identify key issues","input":{"process_type":"string","schedule_established":"object","discovery_scope":"string","issues_framed":["array"]},"definition_of_done":"Scheduling order issued, parties aligned on process and timeline"},
  {"step":3,"type":"tool_use","name":"facilitate_information_exchange_and_preparation","description":"Coordinate document exchange, pre-hearing submissions, and witness lists; review case materials to understand factual and legal landscape","input":{"document_exchange_complete":"boolean","pre_hearing_briefs":["array"],"witness_lists":["array"],"joint_exhibits":["array"]},"definition_of_done":"All pre-hearing submissions received and reviewed"},
  {"step":4,"type":"tool_use","name":"conduct_hearing_or_mediation_session","description":"For arbitration: preside over evidentiary hearing, examine witnesses, rule on objections. For mediation: facilitate joint sessions and private caucuses to explore settlement","input":{"session_format":"string","witnesses_heard":["array"],"exhibits_admitted":["array"],"settlement_positions":"object"},"definition_of_done":"Hearing record complete (arbitration) or settlement discussions advanced (mediation)"},
  {"step":5,"type":"tool_use","name":"deliberate_and_issue_award_or_assist_resolution","description":"Arbitration: deliberate on evidence and applicable law, draft and issue binding award. Mediation: assist parties in drafting settlement agreement","input":{"award_type":"string","legal_standard_applied":"string","award_amount":"number","settlement_terms":"object"},"definition_of_done":"Arbitration award issued in writing with reasoning, or mediation settlement signed by parties"},
  {"step":6,"type":"tool_use","name":"close_case_and_manage_records","description":"Close case file, transmit award or settlement agreement to appropriate parties and institutions, retain records per governing rules","input":{"award_transmitted":"boolean","enforcement_institution":"string","record_retention_years":"number","case_statistics":"object"},"definition_of_done":"Case administratively closed, records retained per applicable rules"}
]'::jsonb,
ARRAY['AAA WebFile','JAMS Resolution Centers portal','ICC Dispute Resolution platform','Relativity (document review for complex arbitrations)','Zoom/Teams (virtual hearings)','Westlaw','LexisNexis','Concorde DRMS']
);

-- ── 53. Judges, Magistrate Judges, and Magistrates (23-1023.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Arbitrate, advise, adjudicate, or administer justice in a court of law. May sentence defendants in criminal cases according to government statutes. May determine liability of defendants in civil cases.',
'[
  {"step":1,"type":"tool_use","name":"manage_docket_and_case_assignments","description":"Manage assigned docket, set hearing schedules, allocate judicial resources, and ensure cases progress within applicable time standards","input":{"pending_cases":"number","case_types":["array"],"scheduling_constraints":["array"],"time_to_trial_targets":"object"},"definition_of_done":"Docket managed within court time standards, hearings scheduled and parties notified"},
  {"step":2,"type":"tool_use","name":"review_pretrial_motions_and_issue_rulings","description":"Review and decide motions to dismiss, motions for summary judgment, suppression motions, discovery disputes, and other pretrial matters","input":{"motions_pending":["array"],"briefing_complete":"boolean","oral_argument_held":"boolean","ruling_type":"string"},"definition_of_done":"Written orders issued on all pending motions with proper legal analysis"},
  {"step":3,"type":"tool_use","name":"conduct_trials_and_hearings","description":"Preside over bench trials, jury trials, and hearings, control courtroom proceedings, rule on evidentiary objections, and instruct juries","input":{"proceeding_type":"string","jury_impaneled":"boolean","witnesses_examined":["array"],"exhibits_admitted":["array"]},"definition_of_done":"Proceeding conducted consistent with procedural rules, complete record on file"},
  {"step":4,"type":"tool_use","name":"deliberate_and_render_verdict_or_judgment","description":"Apply law to facts, evaluate witness credibility, deliberate on legal issues, and render decision in bench trials or accept jury verdict","input":{"verdict_type":"string","findings_of_fact":["array"],"conclusions_of_law":["array"],"judgment":"string"},"definition_of_done":"Decision rendered in open court and memorialized in written order"},
  {"step":5,"type":"tool_use","name":"impose_sentence_or_enter_judgment","description":"In criminal cases, conduct sentencing hearing and impose sentence per guidelines and statutory factors. In civil cases, calculate damages and enter judgment","input":{"sentencing_guidelines_range":"string","sentencing_factors":["array"],"sentence_imposed":"string","damages_awarded":"number"},"definition_of_done":"Sentence or judgment entered in writing, rights of appeal explained to parties"},
  {"step":6,"type":"tool_use","name":"manage_post_judgment_matters","description":"Manage post-trial motions, injunctions, contempt proceedings, and compliance monitoring; coordinate with probation and corrections","input":{"post_trial_motions":["array"],"injunction_terms":"object","contempt_proceedings":"boolean","compliance_reviews":"boolean"},"definition_of_done":"All post-judgment matters resolved, case closed or transferred to supervisory jurisdiction"}
]'::jsonb,
ARRAY['CM/ECF (PACER)','Tyler Technologies Odyssey','State court case management systems','Westlaw/LexisNexis','Sentencing Guidelines calculators (USSG)','Courtroom recording systems','Jury management software']
);

-- ── 54. Paralegals and Legal Assistants (23-2011.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Assist lawyers by investigating facts, preparing legal documents, or researching pertinent legal developments. May represent or advise clients in informal administrative hearings or federal agency proceedings.',
'[
  {"step":1,"type":"tool_use","name":"open_matter_and_organize_case_file","description":"Open new matter in practice management system, organize physical and digital case files, calendar deadlines, and prepare client intake documentation","input":{"matter_number":"string","client_name":"string","matter_type":"string","key_deadlines":["array"],"responsible_attorney":"string"},"definition_of_done":"Matter opened, file organized, all deadlines calendared and confirmed with supervising attorney"},
  {"step":2,"type":"tool_use","name":"conduct_legal_and_factual_research","description":"Research statutes, regulations, case law, and secondary sources; investigate facts through public records, databases, and interviews","input":{"research_issues":["array"],"jurisdictions":["array"],"databases_used":["array"],"fact_investigation_needed":["array"]},"definition_of_done":"Research memorandum or summary delivered to attorney with citations and analysis"},
  {"step":3,"type":"tool_use","name":"draft_legal_documents_and_pleadings","description":"Prepare first drafts of pleadings, motions, contracts, discovery requests, correspondence, and transactional documents for attorney review","input":{"document_type":"string","applicable_rules":"string","key_facts":["array"],"exhibits":["array"]},"definition_of_done":"Draft document delivered to supervising attorney with deadline marked"},
  {"step":4,"type":"tool_use","name":"manage_discovery_and_document_review","description":"Coordinate document collection, organize and review documents for relevance and privilege, code documents in eDiscovery platform, and assist with discovery responses","input":{"document_volume":"number","review_platform":"string","privilege_log_required":"boolean","bates_numbering_complete":"boolean"},"definition_of_done":"Document review complete, privilege log finalized, production set ready for attorney approval"},
  {"step":5,"type":"tool_use","name":"coordinate_trial_preparation","description":"Organize exhibits, prepare witness binders, coordinate subpoenas, maintain trial notebook, and assist attorney at counsel table during proceedings","input":{"exhibits_numbered":"boolean","witness_binders_prepared":"boolean","subpoenas_served":["array"],"trial_notebook_complete":"boolean"},"definition_of_done":"All trial materials organized and delivered to attorney, court logistics confirmed"},
  {"step":6,"type":"tool_use","name":"file_court_documents_and_manage_deadlines","description":"File documents electronically through CM/ECF, confirm filing, serve parties, and maintain proof of service; track and update all matter deadlines","input":{"filing_deadline":"date","filing_system":"string","service_method":"string","deadline_calendar_updated":"boolean"},"definition_of_done":"Filing confirmed accepted, service completed with proof, deadline calendar updated"}
]'::jsonb,
ARRAY['Clio Manage','MyCase','PracticePanther','Relativity','Everlaw','PACER/CM-ECF','Westlaw','LexisNexis','Smokeball','NetDocuments','Docrio']
);

-- ── 55. Title Examiners, Abstractors, and Searchers (23-2093.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'Search real estate records, examine titles, or summarize pertinent legal or insurance documents or details for a variety of purposes. May compile lists of mortgages, contracts, and other instruments pertaining to titles.',
'[
  {"step":1,"type":"tool_use","name":"receive_and_establish_title_order","description":"Accept title order from lender, attorney, or buyer; identify search parameters including property legal description, vesting, and required search period","input":{"order_number":"string","property_address":"string","legal_description":"string","search_period_years":"number","order_type":"string"},"definition_of_done":"Order opened in title plant, search parameters confirmed, turnaround time committed"},
  {"step":2,"type":"tool_use","name":"search_public_records","description":"Search grantor/grantee indexes, deed records, mortgage records, judgment liens, tax records, and UCC filings in county recorder and other offices","input":{"county_recorder_searched":"boolean","tax_records_searched":"boolean","judgment_search_completed":"boolean","ucc_search_completed":"boolean","search_years_covered":"number"},"definition_of_done":"Complete search of all applicable indexes documented with instrument copies obtained"},
  {"step":3,"type":"tool_use","name":"compile_title_abstract_or_chain_of_title","description":"Organize all instruments found into chronological abstract showing complete chain of title, vesting, and encumbrances from earliest record to present","input":{"instruments_found":["array"],"chain_of_title_complete":"boolean","gaps_identified":["array"],"abstract_format":"string"},"definition_of_done":"Title abstract complete showing all conveyances, encumbrances, and exceptions"},
  {"step":4,"type":"tool_use","name":"examine_title_for_defects_and_risk","description":"Analyze abstract for title defects including breaks in chain, improper execution, undischarged liens, easements, and encroachments","input":{"title_defects_found":["array"],"curative_instruments_needed":["array"],"risk_assessment":"string","underwriting_guidelines_applied":"string"},"definition_of_done":"Title exam report with all exceptions and required curative actions identified"},
  {"step":5,"type":"tool_use","name":"prepare_title_commitment_or_report","description":"Prepare ALTA title commitment or title report with Schedule A (insured, amount, legal description) and Schedule B (exceptions and requirements)","input":{"schedule_a":"object","schedule_b_requirements":["array"],"schedule_b_exceptions":["array"],"commitment_date":"date"},"definition_of_done":"Commitment issued to all parties, requirements list distributed for clearing"},
  {"step":6,"type":"tool_use","name":"clear_requirements_and_issue_policy","description":"Review and approve curative instruments (releases, affidavits, corrective deeds), confirm requirements satisfied, and coordinate policy issuance","input":{"requirements_cleared":["array"],"outstanding_items":["array"],"policy_type":"string","policy_amount":"number"},"definition_of_done":"All requirements cleared, title policy issued and delivered to insured and lender"}
]'::jsonb,
ARRAY['Softpro','ResWare','RamQuest','TitleExpress','DataTrace','First American DataTree','ATIDS (Attorneys'' Title Insurance Fund)','County recorder public portals','PACER (federal lien search)','AgentNet']
);

-- ── 56. Legal Support Workers, All Other (23-2099.00) ──
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES (
'All legal support workers not listed separately. Includes process servers, court reporters, legal document assistants, and other legal support specialists who assist attorneys and courts in the administration of justice.',
'[
  {"step":1,"type":"tool_use","name":"receive_legal_support_assignment","description":"Receive specific legal support task — process service, court reporting, document preparation, or legal records management — and clarify scope, deadline, and special requirements","input":{"assignment_type":"string","requestor":"string","deadline":"date","special_requirements":["array"],"jurisdiction":"string"},"definition_of_done":"Assignment accepted with confirmed scope and delivery timeline"},
  {"step":2,"type":"tool_use","name":"execute_process_service_or_document_retrieval","description":"Serve legal process documents per applicable state rules (personal service, substituted service, posting); retrieve court records or legal documents as assigned","input":{"documents_to_serve":["array"],"service_address":"string","service_attempts":["array"],"service_method_used":"string"},"definition_of_done":"Service completed and documented with affidavit of service, or documents retrieved and delivered"},
  {"step":3,"type":"tool_use","name":"prepare_or_transcribe_legal_records","description":"Prepare legal document packages for pro se clients (document assistants), transcribe court proceedings (court reporters), or process legal records per assignment","input":{"document_type":"string","transcription_accuracy_target":"number","turnaround_hours":"number","certification_required":"boolean"},"definition_of_done":"Documents prepared or transcript delivered meeting required accuracy and format standards"},
  {"step":4,"type":"tool_use","name":"manage_legal_correspondence_and_calendaring","description":"Manage legal correspondence, deadline calendaring, court filing logistics, and administrative coordination for legal proceedings","input":{"correspondence_types":["array"],"deadlines_calendared":["array"],"filing_submissions":["array"],"attorney_coordination":"boolean"},"definition_of_done":"All correspondence handled and deadlines current in case management system"},
  {"step":5,"type":"tool_use","name":"coordinate_with_courts_and_agencies","description":"Liaise with clerks of court, government agencies, and court administrators regarding case status, filings, fee payments, and procedural requirements","input":{"court_or_agency":"string","inquiry_type":"string","fees_paid":"number","confirmation_received":"boolean"},"definition_of_done":"Court/agency coordination complete with confirmation of acceptance or status"},
  {"step":6,"type":"tool_use","name":"close_and_archive_assignment_records","description":"Archive assignment documentation, delivery confirmations, invoices, and affidavits per law firm or agency retention policies","input":{"records_archived":"boolean","retention_period_years":"number","invoice_submitted":"boolean","file_closed":"boolean"},"definition_of_done":"Assignment records filed, invoice approved, quality review completed"}
]'::jsonb,
ARRAY['LegalEase','Clio','Practice management platforms','PACER/CM-ECF','Court reporter CAT software (CaseCatalyst, Eclipse)','Process server mobile apps (ABC Legal)','Notary tools','State court e-filing portals']
);

-- merged from sal_finance_legal_seed_part4.sql
-- ============================================================
-- SAL Registry v1.0 — FINANCE (13-xxxx) + LEGAL (23-xxxx) CLUSTERS
-- Part 4 of 4: guardrails_and_compliance — ALL 59 roles
-- Source: O*NET + BLS + CFR/USC regulatory frameworks
-- Ingested: 2026-03-31
-- Run ONCE on a fresh cluster (no UNIQUE guard on guardrails_and_compliance)
-- For re-runs: TRUNCATE guardrails_and_compliance CASCADE first
-- ============================================================

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

SELECT count(*) as total_roles FROM registry_metadata;
SELECT count(*) as total_logic FROM agent_logic;
SELECT count(*) as total_guardrails FROM guardrails_and_compliance;
