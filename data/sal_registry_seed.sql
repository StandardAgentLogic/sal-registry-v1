-- ============================================================
-- SAL Registry v1.0 — Verified Seed Data
-- Source: O*NET OnLine + BLS Occupational Outlook Handbook
-- Ingested: 2026-03-31 | BLS Wage Data: May 2024
-- ============================================================
-- SCHEMA NOTE: agent_logic and guardrails_and_compliance are
-- linked to registry_metadata via soc_code (app-layer join).
-- A future migration may add soc_code FK columns formally.
-- ============================================================

-- DEPRECATION NOTE: O*NET SOC 15-1021.00 (Web Developer) has
-- been retired. Correct current code is 15-1254.00. This registry
-- uses the active code. Old code preserved as a comment only.
-- ============================================================

BEGIN;

-- ============================================================
-- TABLE 1: registry_metadata
-- ============================================================

INSERT INTO registry_metadata (soc_code, title, market_value, outlook) VALUES
(
  '15-1252.00',
  'Software Developers',
  133080.00,
  '15% growth 2024–2034, Much faster than average (~129,200 openings/yr)'
),
(
  '15-1211.00',
  'Computer Systems Analysts',
  103790.00,
  '9% growth 2024–2034, Much faster than average (~34,200 openings/yr)'
),
(
  '15-1212.00',
  'Information Security Analysts',
  124910.00,
  '29% growth 2024–2034, Much faster than average (~16,000 openings/yr)'
),
(
  '15-1254.00',
  'Web Developers',
  90930.00,
  '7% growth 2024–2034, Much faster than average (~14,500 openings/yr)'
),
(
  '15-1242.00',
  'Database Administrators',
  104620.00,
  '4% growth 2024–2034, About as fast as average (~7,800 openings/yr)'
);


-- ============================================================
-- TABLE 2: agent_logic
-- step_by_step_json: MCP tool-call format
--   { step, type, name, description, input, definition_of_done }
-- ============================================================

-- 1. Software Developers (15-1252.00)
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES
(
  'Research, design, and develop computer and network software by analyzing user requirements and applying computer science and mathematical principles.',
  '[
    {"step":1,"type":"tool_use","name":"analyze_requirements","description":"Analyze user needs and software requirements to determine design feasibility","input":{"action":"gather_requirements","sources":["user_interviews","technical_specs","stakeholder_docs"]},"definition_of_done":"Requirements document reviewed and signed off by product owner"},
    {"step":2,"type":"tool_use","name":"design_architecture","description":"Design system architecture using scientific analysis and mathematical models","input":{"action":"create_architecture_document","artifacts":["data_flow_diagram","system_design_doc","API_contracts"]},"definition_of_done":"Architecture document approved, no unresolved design conflicts"},
    {"step":3,"type":"tool_use","name":"implement_code","description":"Develop software systems according to approved design specifications","input":{"action":"write_code","languages":["Python","Java","JavaScript"],"version_control":"git"},"definition_of_done":"Code passes all unit tests, peer review approved, merged to main"},
    {"step":4,"type":"tool_use","name":"run_test_suite","description":"Direct software system testing and validation against requirements","input":{"action":"execute_tests","frameworks":["JUnit","Selenium","SonarQube"],"coverage_threshold":80},"definition_of_done":"All tests pass, coverage >= 80%, no critical/high severity bugs open"},
    {"step":5,"type":"tool_use","name":"deploy_and_monitor","description":"Deploy software and monitor system compliance with specifications","input":{"action":"deploy","environment":"production","monitoring":["Splunk","CloudWatch"],"iac_tools":["Terraform","AWS_CloudFormation"]},"definition_of_done":"Deployment successful, zero error-rate spike within 30min post-deploy"},
    {"step":6,"type":"tool_use","name":"document_and_report","description":"Prepare project reports, documentation, and correspondence","input":{"action":"generate_docs","tools":["Confluence","JIRA"],"artifacts":["release_notes","runbook","API_docs"]},"definition_of_done":"All documentation updated, stakeholders notified via project tracker"}
  ]'::jsonb,
  ARRAY[
    'Git','Apache Maven','Oracle SQL Developer','PostgreSQL','Amazon DynamoDB',
    'React','Vue.js','Spring Framework','Selenium','JUnit','SonarQube',
    'Terraform','AWS CloudFormation','Splunk Enterprise','Atlassian JIRA','Docker'
  ]
);

-- 2. Computer Systems Analysts (15-1211.00)
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES
(
  'Analyze science, engineering, business, and other data processing problems to implement solutions using computer technology and information systems.',
  '[
    {"step":1,"type":"tool_use","name":"problem_assessment","description":"Analyze business or technical problems to identify root causes and data processing gaps","input":{"action":"conduct_discovery","methods":["stakeholder_interviews","current_state_analysis","data_flow_review"]},"definition_of_done":"Problem statement documented, root cause identified, scope agreed upon"},
    {"step":2,"type":"tool_use","name":"design_system_solution","description":"Design IT solution using structured analysis and data modeling","input":{"action":"create_solution_design","artifacts":["entity_relationship_diagram","process_flow","system_specification"]},"definition_of_done":"Solution design document completed and approved by architecture review"},
    {"step":3,"type":"tool_use","name":"coordinate_integration","description":"Coordinate and link computer systems within and across departments","input":{"action":"integrate_systems","platforms":["SAP","Oracle_ERP","Azure"],"protocols":["REST_API","ETL_pipeline"]},"definition_of_done":"Integration tested end-to-end, zero data loss confirmed"},
    {"step":4,"type":"tool_use","name":"test_and_validate","description":"Test, maintain, and monitor computer programs and systems post-implementation","input":{"action":"execute_validation","tools":["Selenium","Tableau","Power_BI"],"metrics":["performance","accuracy","uptime"]},"definition_of_done":"System meets all KPI thresholds defined in requirements"},
    {"step":5,"type":"tool_use","name":"train_end_users","description":"Train staff and provide technical guidance on new or modified systems","input":{"action":"deliver_training","format":["documentation","live_session","video_walkthrough"]},"definition_of_done":"Users pass competency check, support ticket volume baseline established"},
    {"step":6,"type":"tool_use","name":"report_to_management","description":"Consult with management on system principles and prepare performance reports","input":{"action":"generate_report","tools":["Tableau","Power_BI","JIRA"],"frequency":"quarterly"},"definition_of_done":"Report delivered, action items tracked in project management tool"}
  ]'::jsonb,
  ARRAY[
    'Oracle Database','Microsoft SQL Server','PostgreSQL','Python','Java','C#',
    'Tableau','Power BI','SAP','React','Django','Git','Atlassian JIRA',
    'Azure DevOps','AWS','Microsoft Azure','Selenium','JUnit'
  ]
);

-- 3. Information Security Analysts (15-1212.00)
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES
(
  'Plan, implement, upgrade, and monitor security measures to protect an organization''s computer networks and information systems from unauthorized access and cyber threats.',
  '[
    {"step":1,"type":"tool_use","name":"threat_assessment","description":"Perform risk assessments and evaluate current security posture","input":{"action":"run_risk_assessment","tools":["Nessus","Qualys","Wireshark"],"scope":["network","endpoints","cloud_assets"]},"definition_of_done":"Risk register updated, all critical/high findings documented with severity scores"},
    {"step":2,"type":"tool_use","name":"design_security_controls","description":"Develop plans to safeguard computer files against unauthorized modification or destruction","input":{"action":"design_controls","artifacts":["security_policy","firewall_rules","access_control_matrix"]},"definition_of_done":"Security plan reviewed by CISO, approved with no unresolved critical gaps"},
    {"step":3,"type":"tool_use","name":"implement_protections","description":"Encrypt data transmissions, establish firewalls, and deploy intrusion detection systems","input":{"action":"deploy_controls","tools":["Palo_Alto_Networks","Splunk_SIEM","CrowdStrike"],"protocols":["TLS_1.3","Zero_Trust","MFA"]},"definition_of_done":"All controls deployed, penetration test confirms no bypass vectors"},
    {"step":4,"type":"tool_use","name":"monitor_and_respond","description":"Monitor network activity, virus reports, and access logs for anomalies","input":{"action":"continuous_monitoring","platforms":["Splunk","Nagios","Azure_Sentinel"],"alert_thresholds":{"severity":"high","response_sla_minutes":15}},"definition_of_done":"Monitoring dashboard live, all P1/P2 alerts trigger automated incident response"},
    {"step":5,"type":"tool_use","name":"enforce_compliance","description":"Review security violations, update access status, and document policy breaches","input":{"action":"compliance_audit","frameworks":["NIST_CSF","SOC2","ISO_27001"],"evidence_collection":["logs","screenshots","change_records"]},"definition_of_done":"Audit report completed, zero unaddressed critical findings before sign-off"},
    {"step":6,"type":"tool_use","name":"security_awareness_training","description":"Train users on security best practices and update protection procedures","input":{"action":"deliver_training","format":["phishing_simulation","live_workshop","policy_acknowledgment"]},"definition_of_done":"100% of target staff complete training, phishing click rate below 5%"}
  ]'::jsonb,
  ARRAY[
    'Palo Alto Networks','Wireshark','Nagios','Splunk','CrowdStrike','Nessus',
    'Python','PowerShell','Bash','AWS','Microsoft Azure','Docker','Kubernetes',
    'Windows Server','Linux','UNIX','Microsoft SharePoint'
  ]
);

-- 4. Web Developers (15-1254.00 — formerly 15-1021.00, retired)
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES
(
  'Design, build, and maintain websites and web applications that meet user requirements, ensuring performance, security, and cross-browser compatibility.',
  '[
    {"step":1,"type":"tool_use","name":"requirements_analysis","description":"Analyze user needs to determine technical requirements and site architecture","input":{"action":"gather_requirements","methods":["wireframing","user_stories","stakeholder_review"],"tools":["Figma","Confluence"]},"definition_of_done":"Technical requirements document approved, sitemap and wireframes signed off"},
    {"step":2,"type":"tool_use","name":"design_and_prototype","description":"Design UI/UX and create interactive prototypes for stakeholder review","input":{"action":"create_prototype","tools":["Figma","Adobe_Creative_Suite"],"deliverables":["mockups","component_library","style_guide"]},"definition_of_done":"Prototype approved by client/product owner, accessibility standards met"},
    {"step":3,"type":"tool_use","name":"develop_frontend","description":"Build website using authoring languages, scripting, and modern frameworks","input":{"action":"implement_frontend","frameworks":["React","Vue.js","Angular"],"languages":["HTML5","CSS3","TypeScript","JavaScript"],"standards":["WCAG_2.1","W3C"]},"definition_of_done":"All pages render correctly on target browsers and devices, Lighthouse score >= 90"},
    {"step":4,"type":"tool_use","name":"develop_backend_and_database","description":"Develop application databases and server-side logic supporting web applications","input":{"action":"implement_backend","databases":["PostgreSQL","MongoDB","MySQL"],"APIs":["REST","GraphQL"],"runtime":["Node.js","Django"]},"definition_of_done":"All API endpoints tested, database queries optimized, no N+1 issues"},
    {"step":5,"type":"tool_use","name":"security_and_testing","description":"Design and implement security measures; evaluate code and test for bugs","input":{"action":"test_and_secure","tools":["Selenium","Jest","JUnit","OWASP_ZAP"],"checks":["XSS","SQL_injection","CSRF","auth_flow"]},"definition_of_done":"All tests pass, zero OWASP Top 10 vulnerabilities present, SSL/TLS configured"},
    {"step":6,"type":"tool_use","name":"deploy_and_maintain","description":"Deploy to production, monitor performance, and perform updates","input":{"action":"deploy","ci_cd":["Jenkins","GitHub_Actions"],"infrastructure":["Docker","Kubernetes","AWS"],"analytics":["Google_Analytics"]},"definition_of_done":"Site live with < 200ms TTFB, uptime >= 99.9%, analytics tracking verified"}
  ]'::jsonb,
  ARRAY[
    'React','Vue.js','Angular','TypeScript','PostgreSQL','MySQL','MongoDB',
    'Amazon DynamoDB','Git','Jenkins CI','Docker','Kubernetes','AWS CloudFormation',
    'Red Hat OpenShift','Selenium','Jest','WordPress','Figma','Adobe Creative Suite',
    'Google Analytics','GraphQL','Atlassian JIRA'
  ]
);

-- 5. Database Administrators (15-1242.00)
INSERT INTO agent_logic (primary_directive, step_by_step_json, toolbox_requirements) VALUES
(
  'Administer, test, and implement computer databases to ensure data integrity, security, performance, and availability for organizational systems and applications.',
  '[
    {"step":1,"type":"tool_use","name":"design_data_model","description":"Develop data models and database specifications aligned with application requirements","input":{"action":"create_data_model","artifacts":["ERD","schema_design","normalization_review"],"tools":["Oracle_SQL_Developer","pgAdmin","Lucidchart"]},"definition_of_done":"Data model reviewed by dev team, normalized to 3NF minimum, approved for build"},
    {"step":2,"type":"tool_use","name":"install_and_configure","description":"Plan and install database systems and configure for production workloads","input":{"action":"provision_database","platforms":["Oracle","PostgreSQL","MySQL","MongoDB"],"environments":["on_prem","AWS_RDS","Azure_SQL"]},"definition_of_done":"Database provisioned, connection pooling configured, health checks passing"},
    {"step":3,"type":"tool_use","name":"set_access_controls","description":"Specify user access levels for each database segment and enforce least-privilege","input":{"action":"configure_access","method":["RBAC","row_level_security"],"tools":["pgAdmin","Oracle_Enterprise_Manager"]},"definition_of_done":"All roles defined, no over-privileged accounts, access matrix documented"},
    {"step":4,"type":"tool_use","name":"performance_tuning","description":"Monitor database performance, optimize queries, and plan capacity upgrades","input":{"action":"optimize","tools":["Explain_Analyze","pg_stat_statements","Datadog","New_Relic"],"targets":{"query_p99_ms":500,"index_hit_rate":0.99}},"definition_of_done":"Query P99 within SLA, index hit rate >= 99%, upgrade plan documented if needed"},
    {"step":5,"type":"tool_use","name":"backup_and_recovery","description":"Plan and coordinate security measures and backup strategies for data protection","input":{"action":"configure_backup","tools":["Veritas_NetBackup","EMC_NetWorker","pg_dump","AWS_Backup"],"schedule":"daily_full_hourly_incremental","rto_hours":4,"rpo_hours":1},"definition_of_done":"Backup verified via restore test, RTO/RPO targets met, DR runbook current"},
    {"step":6,"type":"tool_use","name":"provide_technical_support","description":"Train users, support application teams, and direct programmers on DB changes","input":{"action":"support_and_document","tools":["Confluence","JIRA","Tableau"],"deliverables":["query_guide","schema_changelog","runbook"]},"definition_of_done":"Support tickets resolved within SLA, all schema changes documented in changelog"}
  ]'::jsonb,
  ARRAY[
    'Oracle Database','MySQL','PostgreSQL','MongoDB','Elasticsearch','Snowflake',
    'Amazon RDS','Microsoft Azure SQL','Tableau','Power BI','Python','Linux',
    'Windows Server','Veritas NetBackup','EMC NetWorker','Datadog','pgAdmin',
    'Oracle Enterprise Manager','AWS Backup'
  ]
);


-- ============================================================
-- TABLE 3: guardrails_and_compliance
-- One record per role — keyed by soc_code in verification_logic
-- ============================================================

-- 1. Software Developers
INSERT INTO guardrails_and_compliance (safety_protocols, verification_logic, last_gov_sync) VALUES
(
  ARRAY[
    'No code deployment without passing test suite (coverage >= 80%)',
    'Mandatory peer code review before merge to main branch',
    'Security scanning (SAST/DAST) required on every release pipeline',
    'All third-party dependencies scanned for CVEs before inclusion',
    'No hardcoded credentials — secrets management via vault required'
  ],
  '{
    "soc_code": "15-1252.00",
    "role": "Software Developers",
    "definition_of_done_checklist": [
      "Requirements document approved by product owner",
      "Architecture document approved by tech lead",
      "All unit and integration tests pass",
      "Code review approved by >= 1 senior engineer",
      "Security scan shows zero critical/high CVEs",
      "Deployment completes with zero error-rate spike",
      "Documentation updated in Confluence/JIRA"
    ],
    "compliance_standards": ["OWASP_Top_10","SOC2","NIST_SP_800-53"],
    "data_sources": {
      "onet": "https://www.onetonline.org/link/summary/15-1252.00",
      "bls": "https://www.bls.gov/ooh/computer-and-information-technology/software-developers.htm"
    }
  }'::jsonb,
  '2026-03-31T00:00:00Z'
),
-- 2. Computer Systems Analysts
(
  ARRAY[
    'No system integration without documented test plan and rollback procedure',
    'All data flows must be mapped and approved before implementation',
    'Change management approval required for production system modifications',
    'User acceptance testing (UAT) sign-off mandatory before go-live',
    'Performance benchmarks must be established before and after system changes'
  ],
  '{
    "soc_code": "15-1211.00",
    "role": "Computer Systems Analysts",
    "definition_of_done_checklist": [
      "Problem statement and root cause documented",
      "Solution design approved by architecture review board",
      "Integration tested end-to-end with zero data loss",
      "System meets all defined KPI thresholds",
      "UAT sign-off obtained from business stakeholders",
      "Training delivered and user competency confirmed",
      "Quarterly performance report filed"
    ],
    "compliance_standards": ["ITIL_v4","COBIT","ISO_9001"],
    "data_sources": {
      "onet": "https://www.onetonline.org/link/summary/15-1211.00",
      "bls": "https://www.bls.gov/ooh/computer-and-information-technology/computer-systems-analysts.htm"
    }
  }'::jsonb,
  '2026-03-31T00:00:00Z'
),
-- 3. Information Security Analysts
(
  ARRAY[
    'All security controls must be validated by penetration test before sign-off',
    'Incident response SLA: P1 alerts must be acknowledged within 15 minutes',
    'Zero unaddressed critical findings allowed before audit sign-off',
    'Security awareness training completion rate must reach 100% of target staff',
    'All access changes must be logged, reviewed, and traceable to a ticket'
  ],
  '{
    "soc_code": "15-1212.00",
    "role": "Information Security Analysts",
    "definition_of_done_checklist": [
      "Risk register updated with all critical/high findings",
      "Security plan approved by CISO",
      "All controls deployed and pen test confirms no bypass vectors",
      "Monitoring dashboard live with automated P1/P2 alerting",
      "Compliance audit completed with zero unaddressed critical findings",
      "Staff phishing click rate below 5%",
      "All security events logged and traceable"
    ],
    "compliance_standards": ["NIST_CSF","SOC2_Type_II","ISO_27001","CIS_Controls"],
    "data_sources": {
      "onet": "https://www.onetonline.org/link/summary/15-1212.00",
      "bls": "https://www.bls.gov/ooh/computer-and-information-technology/information-security-analysts.htm"
    }
  }'::jsonb,
  '2026-03-31T00:00:00Z'
),
-- 4. Web Developers (15-1254.00, formerly 15-1021.00)
(
  ARRAY[
    'All web applications must meet WCAG 2.1 AA accessibility standards',
    'Zero OWASP Top 10 vulnerabilities permitted before production deployment',
    'Cross-browser and cross-device testing required on all major platforms',
    'SSL/TLS must be configured on all public-facing endpoints',
    'Lighthouse performance score must reach >= 90 before launch'
  ],
  '{
    "soc_code": "15-1254.00",
    "soc_code_deprecated": "15-1021.00",
    "role": "Web Developers",
    "definition_of_done_checklist": [
      "Technical requirements and wireframes signed off",
      "UI prototype approved by client/product owner",
      "All pages pass cross-browser rendering checks",
      "Lighthouse score >= 90 on performance, accessibility, best practices",
      "All API endpoints tested, no N+1 database query issues",
      "Zero OWASP Top 10 vulnerabilities (OWASP ZAP scan clean)",
      "Site live with TTFB < 200ms and uptime >= 99.9%"
    ],
    "compliance_standards": ["WCAG_2.1_AA","OWASP_Top_10","W3C_Standards","GDPR"],
    "data_sources": {
      "onet": "https://www.onetonline.org/link/summary/15-1254.00",
      "bls": "https://www.bls.gov/ooh/computer-and-information-technology/web-developers.htm"
    }
  }'::jsonb,
  '2026-03-31T00:00:00Z'
),
-- 5. Database Administrators
(
  ARRAY[
    'No schema changes deployed to production without change management approval',
    'Backup restore test must be run monthly — results documented',
    'RTO <= 4 hours and RPO <= 1 hour must be met for all production databases',
    'All access grants must follow least-privilege principle — quarterly review required',
    'Query P99 latency must remain within SLA thresholds at all times'
  ],
  '{
    "soc_code": "15-1242.00",
    "role": "Database Administrators",
    "definition_of_done_checklist": [
      "Data model reviewed and normalized to 3NF minimum",
      "Database provisioned and health checks passing",
      "All roles defined with least-privilege access, matrix documented",
      "Query P99 within SLA, index hit rate >= 99%",
      "Backup verified via restore test, RTO/RPO targets met",
      "DR runbook current and approved",
      "All schema changes logged in versioned changelog"
    ],
    "compliance_standards": ["SOC2","HIPAA_if_applicable","GDPR","NIST_SP_800-53"],
    "data_sources": {
      "onet": "https://www.onetonline.org/link/summary/15-1242.00",
      "bls": "https://www.bls.gov/ooh/computer-and-information-technology/database-administrators.htm"
    }
  }'::jsonb,
  '2026-03-31T00:00:00Z'
);

COMMIT;

-- ============================================================
-- Verification Queries — Run after INSERT to confirm success
-- ============================================================
-- SELECT soc_code, title, market_value, outlook FROM registry_metadata ORDER BY market_value DESC;
-- SELECT primary_directive, toolbox_requirements FROM agent_logic;
-- SELECT safety_protocols, last_gov_sync FROM guardrails_and_compliance;
