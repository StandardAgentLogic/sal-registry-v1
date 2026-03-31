-- ============================================================
-- SAL Registry v1.0 — FULL IT CLUSTER (SOC 15-0000)
-- Part 3 of 3: agent_logic — Roles 20–37 + ALL guardrails
-- ============================================================

BEGIN;

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

COMMIT;
