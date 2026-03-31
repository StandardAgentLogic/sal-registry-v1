# SAL v1.0 Registry Overview

Standard Agent Logic (SAL) v1.0 is a SOC-aligned execution registry for production agents.

## Coverage

- IT, Finance, and Legal role clusters
- 100+ active roles mapped to SOC codes
- 2026 O*NET and BLS aligned role metadata and market outlook

## Core Tables

- `registry_metadata`: canonical SOC identity, title, market value, outlook
- `agent_logic`: role directive and step-by-step execution JSON
- `guardrails_and_compliance`: safety protocols and verification JSONB

## Production Model

- `soc_code` is the primary join key and enforced via foreign keys in hardened schema
- SQL schema is version-controlled in `schema/v1_final_hardened.sql`
- Runtime reads are designed for deterministic agent behavior and compliance checks

