# SAL Ingestor — Notes & Flags for Orchestrator

## SOC Code Deprecation (Action Required)
The original brief specified **15-1021.00** for Web Developer.
O*NET has **retired this code**. The active replacement is **15-1254.00 (Web Developers)**.
All seed data uses the current active code. The deprecated code is preserved in
`soc_code_deprecated` fields within `verification_logic` JSON for audit traceability.

## BLS Data Access
BLS OOH pages return HTTP 403 on direct programmatic fetch.
All wage and outlook data was retrieved via BLS search index and verified against
published May 2024 figures. For automated future syncs, use:
- BLS Public Data API: `https://api.bls.gov/publicAPI/v2/timeseries/data/`
- Series IDs for median wage: OES series (e.g., `OEUM000000015125200`)

## Verified BLS Data Summary (May 2024)

| SOC Code | Title | Median Annual Wage | 10-Yr Outlook |
|---|---|---|---|
| 15-1252.00 | Software Developers | $133,080 | +15% |
| 15-1212.00 | Information Security Analysts | $124,910 | +29% |
| 15-1242.00 | Database Administrators | $104,620 | +4% |
| 15-1211.00 | Computer Systems Analysts | $103,790 | +9% |
| 15-1254.00 | Web Developers | $90,930 | +7% |

## Schema Gap — FK Linkage
`agent_logic` and `guardrails_and_compliance` do not have a formal FK column
linking to `registry_metadata`. Current linkage is via `soc_code` in
`verification_logic->>'soc_code'` (app-layer join).
**Recommendation:** Add `soc_code TEXT REFERENCES registry_metadata(soc_code)`
to both tables in a future schema migration.

## Files
- `sal_registry_seed.sql` — Single-transaction SQL INSERT, run in Supabase SQL Editor
- `sal_registry_seed.json` — Supabase Data API compatible JSON payload
