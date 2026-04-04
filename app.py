from __future__ import annotations

import base64
import json
import math
import os
import re
import traceback
from html import escape
from pathlib import Path
from typing import Any
from datetime import datetime, timezone

import streamlit as st
import streamlit.components.v1 as _stc

# ── Page config — MUST be the first st.* call in the module ─────────────────
st.set_page_config(
    page_title="SAL Registry | Federal-Grade Precision",
    page_icon="SAL",
    layout="wide",
    initial_sidebar_state="collapsed",
)

# ── Optional heavy dependencies (graceful degradation) ──────────────────────
try:
    from dotenv import load_dotenv as _ld
    _ld()
except ImportError:
    pass

try:
    from supabase import Client, create_client as _cc  # type: ignore
    def _make_client(url: str, key: str):
        return _cc(url, key)
except ImportError:
    class Client:  # type: ignore
        pass
    def _make_client(url: str, key: str):
        raise RuntimeError("supabase package not installed – browse mode active.")

_REPO_ROOT = Path(__file__).resolve().parent
_CONNECTION_LOG = _REPO_ROOT / "logs" / "connection_audit.log"


# ── Supabase helpers ─────────────────────────────────────────────────────────

def _audit_connection_failure(exc: BaseException, context: str) -> None:
    try:
        _CONNECTION_LOG.parent.mkdir(parents=True, exist_ok=True)
        ts = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")
        detail = traceback.format_exc()
        line = f"[{ts}] {context}\n{type(exc).__name__}: {exc}\n{detail}\n---\n"
        with _CONNECTION_LOG.open("a", encoding="utf-8") as fh:
            fh.write(line)
    except Exception:
        pass


def _secret_get(name: str) -> str:
    try:
        sec = getattr(st, "secrets", None)
        if sec is not None:
            try:
                raw = sec.get(name, "") if callable(getattr(sec, "get", None)) else ""
            except KeyError:
                raw = ""
            return str(raw or "").strip()
    except Exception:
        pass
    return (os.getenv(name) or "").strip()


def _looks_like_placeholder(value: str) -> bool:
    t = (value or "").strip()
    if not t:
        return True
    low = t.lower()
    return (
        "insert_" in low
        or "your-supabase" in low
        or "your_openai" in low
        or low in {"changeme", "placeholder", "xxx", "none", "null"}
    )


def _resolve_supabase_url() -> str:
    return (_secret_get("SUPABASE_URL") or os.getenv("SUPABASE_URL") or "").strip()


def _resolve_supabase_key() -> str:
    return (
        _secret_get("SUPABASE_SERVICE_ROLE_KEY")
        or _secret_get("SUPABASE_ANON_KEY")
        or _secret_get("SUPABASE_KEY")
        or os.getenv("SUPABASE_SERVICE_ROLE_KEY")
        or os.getenv("SUPABASE_ANON_KEY")
        or os.getenv("SUPABASE_KEY")
        or ""
    ).strip()


def use_demo_mode() -> bool:
    return _looks_like_placeholder(_resolve_supabase_url()) or _looks_like_placeholder(
        _resolve_supabase_key()
    )


def get_supabase_client():
    url = _resolve_supabase_url()
    key = _resolve_supabase_key()
    if not url or not key:
        raise RuntimeError("SUPABASE_URL and/or key not configured.")
    return _make_client(url, key)


def fetch_live_table_counts(client) -> dict[str, int]:
    registry_rows = client.table("registry_metadata").select("*", count="exact").limit(0).execute()
    logic_rows = client.table("agent_logic").select("*", count="exact").limit(0).execute()
    guardrail_rows = client.table("guardrails_and_compliance").select("*", count="exact").limit(0).execute()
    return {
        "registry_metadata": int(registry_rows.count or 0),
        "agent_logic": int(logic_rows.count or 0),
        "guardrails_and_compliance": int(guardrail_rows.count or 0),
    }


def fetch_registry_roles(client, title_query: str, *, private_vault_only: bool, limit: int = 50) -> list[dict[str, Any]]:
    q = client.table("registry_metadata").select("soc_code,title,market_value,outlook,is_custom,description")
    if private_vault_only:
        q = q.eq("is_custom", True)
    t = title_query.strip()
    if t:
        q = q.or_(f"title.ilike.%{t}%,description.ilike.%{t}%,outlook.ilike.%{t}%")
    result = q.order("title").limit(limit).execute()
    return result.data or []


def fetch_latest_verified_logic(client, *, demo_mode: bool, limit: int = 12) -> list[dict[str, Any]]:
    if demo_mode:
        return [{"soc_code": r["soc_code"], "title": str(r.get("title") or "")} for r in _MOCK_REGISTRY[:limit]]
    if client is None:
        return []
    data: list[dict[str, Any]] = []
    try:
        res = client.table("agent_logic").select("soc_code").order("updated_at", desc=True).limit(limit).execute()
        data = list(res.data or [])
    except Exception:
        try:
            res = client.table("agent_logic").select("soc_code").order("created_at", desc=True).limit(limit).execute()
            data = list(res.data or [])
        except Exception:
            res = client.table("agent_logic").select("soc_code").limit(limit).execute()
            data = list(res.data or [])
    rows = [{"soc_code": str(r.get("soc_code") or ""), "title": ""} for r in data if r.get("soc_code")]
    if not rows:
        return []
    codes = [r["soc_code"] for r in rows]
    try:
        mr = client.table("registry_metadata").select("soc_code,title").in_("soc_code", codes).execute()
        title_map = {str(x["soc_code"]): str(x.get("title") or "") for x in (mr.data or [])}
        for r in rows:
            r["title"] = title_map.get(r["soc_code"], "") or r["soc_code"]
    except Exception:
        for r in rows:
            r["title"] = r["soc_code"]
    return rows


def fetch_agent_logic_detail(client, soc_code: str) -> dict[str, Any] | None:
    result = (
        client.table("agent_logic")
        .select("soc_code,primary_directive,step_by_step_json,toolbox_requirements")
        .eq("soc_code", soc_code)
        .limit(1)
        .execute()
    )
    if result.data:
        return result.data[0]
    return None


def _normalize_steps(raw: Any) -> list[Any]:
    if raw is None:
        return []
    if isinstance(raw, str):
        s = raw.strip()
        if not s:
            return []
        try:
            parsed = json.loads(s)
        except json.JSONDecodeError:
            return [s]
        return _normalize_steps(parsed)
    if isinstance(raw, list):
        return raw
    if isinstance(raw, dict):
        return list(raw.items()) if raw else [raw]
    return [raw]


# ── SOC major group folder map ───────────────────────────────────────────────
SOC_MAJOR_GROUPS: dict[str, str] = {
    "11": "Management",
    "13": "Finance",
    "15": "Tech",
    "17": "Engineering",
    "19": "Science",
    "23": "Legal",
    "25": "Education",
    "27": "Arts & Media",
    "29": "Healthcare",
    "31": "Healthcare Support",
    "33": "Protective Service",
    "35": "Food Service",
    "37": "Building & Grounds",
    "39": "Personal Care",
    "41": "Sales",
    "43": "Office & Admin",
    "45": "Farming/Fishing",
    "47": "Construction",
    "49": "Maintenance",
    "51": "Production",
    "53": "Transportation",
    "55": "Military",
}


# ── Mock / browse-mode data ──────────────────────────────────────────────────
def _auto_reg(code: str, title: str, key: str = "A") -> "dict[str, Any]":
    major = code[:2]
    mv = {
        "11": "Executive", "13": "High",    "15": "High",       "17": "Stable",
        "19": "Stable",    "21": "Stable",  "23": "High",       "25": "Stable",
        "27": "Niche",     "29": "High",    "31": "Stable",     "33": "Stable",
        "35": "Low",       "37": "Low",     "39": "Low",        "41": "Stable",
        "43": "Stable",    "45": "Low",     "47": "Stable",     "49": "Stable",
        "51": "Stable",    "53": "Stable",  "55": "Government",
    }.get(major, "Stable")
    out = {
        "B": "Bright — high demand growth",
        "A": "Average — stable demand",
        "F": "Faster than average",
        "M": "Much faster than average",
        "L": "Below average — declining",
    }.get(key, "Average — stable demand")
    return {
        "soc_code": code, "title": title, "market_value": mv,
        "outlook": out, "is_custom": (code == "15-1299.08"),
        "description": f"{title}: O*NET federal occupation standard.",
    }

_RAW_ONET: list[tuple[str, str, str]] = [
    # ── 11 Management ────────────────────────────────────────────────────────
    ("11-1011.00","Chief Executives","B"),
    ("11-1021.00","General and Operations Managers","A"),
    ("11-2011.00","Advertising and Promotions Managers","A"),
    ("11-2021.00","Marketing Managers","B"),
    ("11-2022.00","Sales Managers","B"),
    ("11-2031.00","Public Relations and Fundraising Managers","A"),
    ("11-3011.00","Administrative Services Managers","A"),
    ("11-3012.00","Facilities Managers","A"),
    ("11-3021.00","Computer and Information Systems Managers","B"),
    ("11-3031.00","Financial Managers","B"),
    ("11-3051.00","Industrial Production Managers","A"),
    ("11-3061.00","Purchasing Managers","A"),
    ("11-3071.00","Transportation, Storage, and Distribution Managers","A"),
    ("11-3111.00","Compensation and Benefits Managers","A"),
    ("11-3121.00","Human Resources Managers","A"),
    ("11-3131.00","Training and Development Managers","A"),
    ("11-9011.00","Farm, Ranch, and Other Agricultural Managers","L"),
    ("11-9021.00","Construction Managers","A"),
    ("11-9031.00","Education Administrators, Preschool and Childcare","A"),
    ("11-9032.00","Education Administrators, Kindergarten through Secondary","A"),
    ("11-9033.00","Education Administrators, Postsecondary","A"),
    ("11-9039.00","Education Administrators, All Other","A"),
    ("11-9041.00","Architectural and Engineering Managers","B"),
    ("11-9051.00","Food Service Managers","A"),
    ("11-9061.00","Funeral Home Managers","A"),
    ("11-9071.00","Gaming Managers","A"),
    ("11-9081.00","Lodging Managers","A"),
    ("11-9111.00","Medical and Health Services Managers","B"),
    ("11-9121.00","Natural Sciences Managers","A"),
    ("11-9131.00","Postmasters and Mail Superintendents","L"),
    ("11-9141.00","Property, Real Estate, and Community Association Managers","A"),
    ("11-9151.00","Social and Community Service Managers","B"),
    ("11-9161.00","Emergency Management Directors","A"),
    ("11-9171.00","Spa Managers","A"),
    ("11-9198.00","Compliance Managers","B"),
    ("11-9199.00","Managers, All Other","A"),
    # ── 13 Business and Financial Operations ─────────────────────────────────
    ("13-1011.00","Agents and Business Managers of Artists and Athletes","A"),
    ("13-1021.00","Buyers and Purchasing Agents, Farm Products","A"),
    ("13-1022.00","Wholesale and Retail Buyers, Except Farm Products","A"),
    ("13-1023.00","Purchasing Agents, Except Wholesale, Retail, and Farm Products","A"),
    ("13-1031.00","Claims Adjusters, Examiners, and Investigators","A"),
    ("13-1032.00","Insurance Appraisers, Auto Damage","A"),
    ("13-1041.00","Compliance Officers","B"),
    ("13-1051.00","Cost Estimators","A"),
    ("13-1071.00","Human Resources Specialists","B"),
    ("13-1075.00","Labor Relations Specialists","A"),
    ("13-1081.00","Logisticians","B"),
    ("13-1082.00","Project Management Specialists","B"),
    ("13-1111.00","Management Analysts","B"),
    ("13-1121.00","Meeting, Convention, and Event Planners","A"),
    ("13-1131.00","Fundraisers","A"),
    ("13-1141.00","Compensation, Benefits, and Job Analysis Specialists","A"),
    ("13-1151.00","Training and Development Specialists","B"),
    ("13-1161.00","Market Research Analysts and Marketing Specialists","B"),
    ("13-1191.00","Procurement Specialists","A"),
    ("13-1199.00","Business Operations Specialists, All Other","A"),
    ("13-2011.00","Accountants and Auditors","B"),
    ("13-2020.00","Property Appraisers and Assessors","A"),
    ("13-2031.00","Budget Analysts","A"),
    ("13-2041.00","Credit Analysts","A"),
    ("13-2051.00","Financial and Investment Analysts","B"),
    ("13-2052.00","Personal Financial Advisors","B"),
    ("13-2053.00","Insurance Underwriters","A"),
    ("13-2054.00","Financial Risk Specialists","B"),
    ("13-2061.00","Financial Examiners","B"),
    ("13-2071.00","Credit Counselors","A"),
    ("13-2072.00","Loan Officers","A"),
    ("13-2081.00","Tax Examiners and Collectors, and Revenue Agents","A"),
    ("13-2082.00","Tax Preparers","A"),
    ("13-2099.00","Financial Specialists, All Other","A"),
    # ── 15 Computer and Mathematical ─────────────────────────────────────────
    ("15-1211.00","Computer Systems Analysts","B"),
    ("15-1212.00","Information Security Analysts","M"),
    ("15-1221.00","Computer and Information Research Scientists","B"),
    ("15-1231.00","Computer Network Support Specialists","A"),
    ("15-1232.00","Computer User Support Specialists","A"),
    ("15-1241.00","Computer Network Architects","B"),
    ("15-1242.00","Database Administrators","B"),
    ("15-1243.00","Database Architects","B"),
    ("15-1244.00","Network and Computer Systems Administrators","A"),
    ("15-1245.00","Data Scientists","M"),
    ("15-1246.00","Data Warehousing Specialists","B"),
    ("15-1247.00","Software Quality Assurance Analysts and Testers","B"),
    ("15-1251.00","Computer Programmers","A"),
    ("15-1252.00","Software Developers","B"),
    ("15-1253.00","Software Quality Assurance Analysts and Testers","B"),
    ("15-1254.00","Web Developers","B"),
    ("15-1255.00","Web and Digital Interface Designers","B"),
    ("15-1256.00","Cloud Computing Engineers","M"),
    ("15-1257.00","Robotics Engineers","B"),
    ("15-1258.00","DevOps Engineers","M"),
    ("15-1259.00","Computer Occupations, All Other","A"),
    ("15-1299.08","SAL Systems Integrator (Vault IP) \U0001f3c6","B"),
    ("15-2011.00","Actuaries","B"),
    ("15-2021.00","Mathematicians","A"),
    ("15-2031.00","Operations Research Analysts","B"),
    ("15-2041.00","Statisticians","B"),
    ("15-2051.00","Data Scientists and Mathematical Science Occupations, All Other","M"),
    ("15-2099.00","Mathematical Science Occupations, All Other","A"),
    # ── 17 Architecture and Engineering ──────────────────────────────────────
    ("17-1011.00","Architects, Except Landscape and Naval","B"),
    ("17-1012.00","Landscape Architects","A"),
    ("17-1021.00","Cartographers and Photogrammetrists","A"),
    ("17-1022.00","Surveying and Mapping Technicians","A"),
    ("17-2011.00","Aerospace Engineers","B"),
    ("17-2021.00","Agricultural Engineers","A"),
    ("17-2031.00","Bioengineers and Biomedical Engineers","M"),
    ("17-2041.00","Chemical Engineers","A"),
    ("17-2051.00","Civil Engineers","A"),
    ("17-2061.00","Computer Hardware Engineers","B"),
    ("17-2071.00","Electrical Engineers","B"),
    ("17-2072.00","Electronics Engineers, Except Computer","B"),
    ("17-2081.00","Environmental Engineers","B"),
    ("17-2111.00","Health and Safety Engineers, Except Mining Safety Engineers","A"),
    ("17-2112.00","Industrial Engineers","A"),
    ("17-2121.00","Marine Engineers and Naval Architects","A"),
    ("17-2131.00","Materials Engineers","A"),
    ("17-2141.00","Mechanical Engineers","A"),
    ("17-2151.00","Mining and Geological Engineers","A"),
    ("17-2161.00","Nuclear Engineers","A"),
    ("17-2171.00","Petroleum Engineers","A"),
    ("17-2199.00","Engineers, All Other","A"),
    ("17-3011.00","Architectural and Civil Drafters","A"),
    ("17-3012.00","Electrical and Electronics Drafters","A"),
    ("17-3013.00","Mechanical Drafters","A"),
    ("17-3019.00","Drafters, All Other","A"),
    ("17-3021.00","Aerospace Engineering and Operations Technologists and Technicians","A"),
    ("17-3022.00","Civil Engineering Technologists and Technicians","A"),
    ("17-3023.00","Electrical and Electronic Engineering Technologists and Technicians","A"),
    ("17-3024.00","Electro-Mechanical and Mechatronics Technologists and Technicians","A"),
    ("17-3025.00","Environmental Engineering Technologists and Technicians","A"),
    ("17-3026.00","Industrial Engineering Technologists and Technicians","A"),
    ("17-3027.00","Mechanical Engineering Technologists and Technicians","A"),
    ("17-3028.00","Calibration Technologists and Technicians","A"),
    ("17-3029.00","Engineering Technologists and Technicians, All Other","A"),
    ("17-3031.00","Surveying and Mapping Technicians","A"),
    # ── 19 Life, Physical, and Social Science ────────────────────────────────
    ("19-1011.00","Animal Scientists","A"),
    ("19-1012.00","Food Scientists and Technologists","B"),
    ("19-1013.00","Soil and Plant Scientists","A"),
    ("19-1021.00","Biochemists and Biophysicists","B"),
    ("19-1022.00","Microbiologists","B"),
    ("19-1023.00","Zoologists and Wildlife Biologists","A"),
    ("19-1029.00","Biological Scientists, All Other","A"),
    ("19-1031.00","Conservation Scientists","A"),
    ("19-1032.00","Foresters","A"),
    ("19-1041.00","Epidemiologists","B"),
    ("19-1042.00","Medical Scientists, Except Epidemiologists","B"),
    ("19-1099.00","Life Scientists, All Other","A"),
    ("19-2011.00","Astronomers","A"),
    ("19-2012.00","Physicists","A"),
    ("19-2021.00","Atmospheric and Space Scientists","A"),
    ("19-2031.00","Chemists","A"),
    ("19-2032.00","Materials Scientists","A"),
    ("19-2041.00","Environmental Scientists and Specialists, Including Health","B"),
    ("19-2042.00","Geoscientists, Except Hydrologists and Geographers","A"),
    ("19-2043.00","Hydrologists","A"),
    ("19-2099.00","Physical Scientists, All Other","A"),
    ("19-3011.00","Economists","B"),
    ("19-3012.00","Survey Researchers","A"),
    ("19-3031.00","Clinical and Counseling Psychologists","B"),
    ("19-3032.00","Industrial-Organizational Psychologists","B"),
    ("19-3033.00","School Psychologists","B"),
    ("19-3039.00","Psychologists, All Other","A"),
    ("19-3041.00","Sociologists","A"),
    ("19-3051.00","Urban and Regional Planners","B"),
    ("19-3091.00","Anthropologists and Archeologists","A"),
    ("19-3092.00","Geographers","A"),
    ("19-3093.00","Historians","A"),
    ("19-3094.00","Political Scientists","B"),
    ("19-3099.00","Social Scientists and Related Workers, All Other","A"),
    ("19-4011.00","Agricultural and Food Science Technicians","A"),
    ("19-4013.00","Forensic Science Technicians","B"),
    ("19-4021.00","Biological Technicians","A"),
    ("19-4031.00","Chemical Technicians","A"),
    ("19-4051.00","Nuclear Technicians","A"),
    ("19-4071.00","Forest and Conservation Technicians","A"),
    ("19-4092.00","Forensic Science Technicians","B"),
    ("19-4099.00","Life, Physical, and Social Science Technicians, All Other","A"),
    # ── 21 Community and Social Service ──────────────────────────────────────
    ("21-1011.00","Substance Abuse and Behavioral Disorder Counselors","B"),
    ("21-1012.00","Educational, Guidance, and Career Counselors and Advisors","B"),
    ("21-1013.00","Marriage and Family Therapists","B"),
    ("21-1014.00","Mental Health Counselors","B"),
    ("21-1015.00","Rehabilitation Counselors","A"),
    ("21-1019.00","Counselors, All Other","A"),
    ("21-1021.00","Child, Family, and School Social Workers","B"),
    ("21-1022.00","Healthcare Social Workers","B"),
    ("21-1023.00","Mental Health and Substance Abuse Social Workers","B"),
    ("21-1029.00","Social Workers, All Other","A"),
    ("21-1091.00","Health Education Specialists","B"),
    ("21-1092.00","Probation Officers and Correctional Treatment Specialists","A"),
    ("21-1093.00","Social and Human Service Assistants","B"),
    ("21-1094.00","Community Health Workers","B"),
    ("21-1099.00","Community and Social Service Specialists, All Other","A"),
    ("21-2011.00","Clergy","A"),
    ("21-2021.00","Directors, Religious Activities and Education","A"),
    ("21-2099.00","Religious Workers, All Other","A"),
    # ── 23 Legal ─────────────────────────────────────────────────────────────
    ("23-1011.00","Lawyers","B"),
    ("23-1012.00","Judicial Law Clerks","A"),
    ("23-1021.00","Administrative Law Judges, Adjudicators, and Hearing Officers","A"),
    ("23-1022.00","Arbitrators, Mediators, and Conciliators","A"),
    ("23-1023.00","Judges, Magistrate Judges, and Magistrates","A"),
    ("23-2011.00","Paralegals and Legal Assistants","B"),
    ("23-2012.00","Legal Secretaries and Administrative Assistants","A"),
    ("23-2091.00","Court Reporters and Simultaneous Captioners","A"),
    ("23-2093.00","Title Examiners, Abstractors, and Searchers","A"),
    ("23-2099.00","Legal Support Workers, All Other","A"),
    # ── 25 Educational Instruction and Library ────────────────────────────────
    ("25-1011.00","Business Teachers, Postsecondary","A"),
    ("25-1012.00","Computer Science Teachers, Postsecondary","B"),
    ("25-1022.00","Mathematical Science Teachers, Postsecondary","A"),
    ("25-1032.00","Engineering Teachers, Postsecondary","B"),
    ("25-1041.00","Agricultural Sciences Teachers, Postsecondary","A"),
    ("25-1042.00","Biological Science Teachers, Postsecondary","A"),
    ("25-1043.00","Chemistry Teachers, Postsecondary","A"),
    ("25-1044.00","Environmental Science Teachers, Postsecondary","A"),
    ("25-1051.00","Atmospheric, Earth, Marine, and Space Sciences Teachers, Postsecondary","A"),
    ("25-1054.00","Physics Teachers, Postsecondary","A"),
    ("25-1061.00","Anthropology and Archeology Teachers, Postsecondary","A"),
    ("25-1062.00","Area, Ethnic, and Cultural Studies Teachers, Postsecondary","A"),
    ("25-1063.00","Economics Teachers, Postsecondary","A"),
    ("25-1064.00","Geography Teachers, Postsecondary","A"),
    ("25-1065.00","Political Science Teachers, Postsecondary","A"),
    ("25-1066.00","Psychology Teachers, Postsecondary","A"),
    ("25-1067.00","Sociology Teachers, Postsecondary","A"),
    ("25-1069.00","Social Sciences Teachers, Postsecondary, All Other","A"),
    ("25-1071.00","Health Specialties Teachers, Postsecondary","B"),
    ("25-1072.00","Nursing Instructors and Teachers, Postsecondary","B"),
    ("25-1081.00","Education Teachers, Postsecondary","A"),
    ("25-1082.00","Library Science Teachers, Postsecondary","A"),
    ("25-1099.00","Postsecondary Teachers, All Other","A"),
    ("25-2011.00","Preschool Teachers, Except Special Education","B"),
    ("25-2012.00","Kindergarten Teachers, Except Special Education","A"),
    ("25-2021.00","Elementary School Teachers, Except Special Education","A"),
    ("25-2022.00","Middle School Teachers, Except Special and Career/Technical Education","A"),
    ("25-2023.00","Career/Technical Education Teachers, Middle School","A"),
    ("25-2031.00","Secondary School Teachers, Except Special and Career/Technical Education","A"),
    ("25-2032.00","Career/Technical Education Teachers, Secondary School","A"),
    ("25-2051.00","Special Education Teachers, Preschool","B"),
    ("25-2052.00","Special Education Teachers, Kindergarten and Elementary School","B"),
    ("25-2053.00","Special Education Teachers, Middle School","B"),
    ("25-2054.00","Special Education Teachers, Secondary School","B"),
    ("25-2056.00","Special Education Teachers, All Other","B"),
    ("25-3011.00","Adult Basic and Secondary Education and Literacy Teachers","A"),
    ("25-3021.00","Self-Enrichment Education Teachers","A"),
    ("25-3031.00","Substitute Teachers, Short-Term","A"),
    ("25-3041.00","Tutors","A"),
    ("25-3099.00","Teachers and Instructors, All Other","A"),
    ("25-4012.00","Curators","A"),
    ("25-4013.00","Museum Technicians and Conservators","A"),
    ("25-4021.00","Librarians and Media Collections Specialists","A"),
    ("25-4022.00","Library Technicians","A"),
    ("25-9011.00","Audio-Visual and Multimedia Collections Specialists","A"),
    ("25-9021.00","Farm and Home Management Educators","A"),
    ("25-9031.00","Instructional Coordinators","B"),
    ("25-9041.00","Teacher Assistants","B"),
    ("25-9099.00","Educational Instruction and Library Workers, All Other","A"),
    # ── 27 Arts, Design, Entertainment, Sports, and Media ────────────────────
    ("27-1011.00","Art Directors","B"),
    ("27-1012.00","Craft Artists","A"),
    ("27-1013.00","Fine Artists, Including Painters, Sculptors, and Illustrators","A"),
    ("27-1014.00","Special Effects Artists and Animators","B"),
    ("27-1019.00","Artists and Related Workers, All Other","A"),
    ("27-1021.00","Commercial and Industrial Designers","B"),
    ("27-1022.00","Fashion Designers","A"),
    ("27-1023.00","Floral Designers","A"),
    ("27-1024.00","Graphic Designers","B"),
    ("27-1025.00","Interior Designers","A"),
    ("27-1026.00","Merchandise Displayers and Window Trimmers","A"),
    ("27-1027.00","Set and Exhibit Designers","A"),
    ("27-1029.00","Designers, All Other","A"),
    ("27-2011.00","Actors","A"),
    ("27-2012.00","Producers and Directors","B"),
    ("27-2021.00","Athletes and Sports Competitors","A"),
    ("27-2022.00","Coaches and Scouts","A"),
    ("27-2023.00","Umpires, Referees, and Other Sports Officials","A"),
    ("27-2031.00","Dancers","A"),
    ("27-2032.00","Choreographers","A"),
    ("27-2041.00","Music Directors and Composers","A"),
    ("27-2042.00","Musicians and Singers","A"),
    ("27-2099.00","Entertainers and Performers, Sports and Related Workers, All Other","A"),
    ("27-3011.00","Broadcast Announcers and Radio Disc Jockeys","A"),
    ("27-3023.00","News Analysts, Reporters, and Journalists","A"),
    ("27-3031.00","Public Relations Specialists","B"),
    ("27-3041.00","Editors","A"),
    ("27-3042.00","Technical Writers","B"),
    ("27-3043.00","Writers and Authors","A"),
    ("27-3099.00","Media and Communication Workers, All Other","A"),
    ("27-4011.00","Audio and Video Technicians","A"),
    ("27-4012.00","Broadcast Technicians","A"),
    ("27-4013.00","Radio Operators","A"),
    ("27-4014.00","Sound Engineering Technicians","A"),
    ("27-4015.00","Lighting Technicians","A"),
    ("27-4021.00","Photographers","A"),
    ("27-4031.00","Camera Operators, Television, Video, and Film","A"),
    ("27-4032.00","Film and Video Editors","B"),
    ("27-4099.00","Media and Communication Equipment Workers, All Other","A"),
    # ── 29 Healthcare Practitioners and Technical ─────────────────────────────
    ("29-1011.00","Chiropractors","A"),
    ("29-1021.00","Dentists, General","A"),
    ("29-1022.00","Oral and Maxillofacial Surgeons","A"),
    ("29-1023.00","Orthodontists","A"),
    ("29-1024.00","Prosthodontists","A"),
    ("29-1029.00","Dentists, All Other Specialists","A"),
    ("29-1031.00","Dietitians and Nutritionists","B"),
    ("29-1041.00","Optometrists","B"),
    ("29-1051.00","Pharmacists","A"),
    ("29-1071.00","Physician Assistants","M"),
    ("29-1081.00","Podiatrists","A"),
    ("29-1122.00","Occupational Therapists","B"),
    ("29-1123.00","Physical Therapists","B"),
    ("29-1124.00","Radiation Therapists","A"),
    ("29-1125.00","Recreational Therapists","A"),
    ("29-1126.00","Respiratory Therapists","B"),
    ("29-1127.00","Speech-Language Pathologists","B"),
    ("29-1128.00","Exercise Physiologists","B"),
    ("29-1129.00","Therapists, All Other","A"),
    ("29-1131.00","Veterinarians","A"),
    ("29-1141.00","Registered Nurses","B"),
    ("29-1151.00","Nurse Anesthetists","M"),
    ("29-1161.00","Nurse Midwives","B"),
    ("29-1171.00","Nurse Practitioners","M"),
    ("29-1181.00","Audiologists","B"),
    ("29-1182.00","Orthotists and Prosthetists","B"),
    ("29-1211.00","Anesthesiologists","A"),
    ("29-1212.00","Cardiologists","B"),
    ("29-1213.00","Dermatologists","A"),
    ("29-1214.00","Emergency Medicine Physicians","B"),
    ("29-1215.00","Family Medicine Physicians","B"),
    ("29-1216.00","General Internal Medicine Physicians","B"),
    ("29-1217.00","Hospitalists","B"),
    ("29-1218.00","Obstetricians and Gynecologists","A"),
    ("29-1221.00","Pediatricians, General","B"),
    ("29-1222.00","Physicians, Pathologists","A"),
    ("29-1223.00","Psychiatrists","B"),
    ("29-1224.00","Radiologists","A"),
    ("29-1229.00","Physicians, All Other","A"),
    ("29-1241.00","Ophthalmologists","A"),
    ("29-1242.00","Orthopedic Surgeons","A"),
    ("29-1243.00","Neurologists","B"),
    ("29-1249.00","Surgeons, All Other","A"),
    ("29-1291.00","Acupuncturists","A"),
    ("29-1292.00","Dental Hygienists","B"),
    ("29-1299.00","Healthcare Diagnosing or Treating Practitioners, All Other","A"),
    ("29-2011.00","Medical and Clinical Laboratory Technologists","A"),
    ("29-2012.00","Medical and Clinical Laboratory Technicians","A"),
    ("29-2031.00","Cardiovascular Technologists and Technicians","A"),
    ("29-2032.00","Diagnostic Medical Sonographers","B"),
    ("29-2033.00","Nuclear Medicine Technologists","A"),
    ("29-2034.00","Radiologic Technologists and Technicians","A"),
    ("29-2035.00","Magnetic Resonance Imaging Technologists","B"),
    ("29-2036.00","Medical Dosimetrists","A"),
    ("29-2041.00","Emergency Medical Technicians","B"),
    ("29-2042.00","Paramedics","B"),
    ("29-2051.00","Dietetic Technicians","A"),
    ("29-2052.00","Pharmacy Technicians","B"),
    ("29-2053.00","Psychiatric Technicians","A"),
    ("29-2055.00","Surgical Technologists","B"),
    ("29-2056.00","Veterinary Technologists and Technicians","B"),
    ("29-2057.00","Ophthalmic Medical Technicians","A"),
    ("29-2061.00","Licensed Practical and Licensed Vocational Nurses","A"),
    ("29-2071.00","Medical Records Specialists","B"),
    ("29-2072.00","Medical Secretaries and Administrative Assistants","A"),
    ("29-2081.00","Opticians, Dispensing","A"),
    ("29-2091.00","Orthotists and Prosthetists","B"),
    ("29-2092.00","Hearing Aid Specialists","A"),
    ("29-9011.00","Occupational Health and Safety Specialists","B"),
    ("29-9012.00","Occupational Health and Safety Technicians","A"),
    ("29-9021.00","Health Informatics Specialists","M"),
    ("29-9022.00","Medical Appliance Technicians","A"),
    ("29-9091.00","Athletic Trainers","B"),
    ("29-9092.00","Genetic Counselors","M"),
    ("29-9093.00","Surgical Assistants","A"),
    ("29-9099.00","Healthcare Practitioners and Technical Workers, All Other","A"),
    # ── 31 Healthcare Support ─────────────────────────────────────────────────
    ("31-1121.00","Home Health Aides","M"),
    ("31-1122.00","Personal Care Aides","M"),
    ("31-1131.00","Nursing Assistants","B"),
    ("31-1132.00","Orderlies","A"),
    ("31-1133.00","Psychiatric Aides","A"),
    ("31-2011.00","Occupational Therapy Assistants","B"),
    ("31-2012.00","Occupational Therapy Aides","A"),
    ("31-2021.00","Physical Therapist Assistants","B"),
    ("31-2022.00","Physical Therapist Aides","A"),
    ("31-9011.00","Massage Therapists","B"),
    ("31-9091.00","Dental Assistants","B"),
    ("31-9092.00","Medical Assistants","B"),
    ("31-9093.00","Medical Equipment Preparers","A"),
    ("31-9094.00","Medical Transcriptionists","L"),
    ("31-9095.00","Pharmacy Aides","A"),
    ("31-9096.00","Veterinary Assistants and Laboratory Animal Caretakers","A"),
    ("31-9097.00","Phlebotomists","B"),
    ("31-9099.00","Healthcare Support Workers, All Other","A"),
    # ── 33 Protective Service ─────────────────────────────────────────────────
    ("33-1011.00","First-Line Supervisors of Correctional Officers","A"),
    ("33-1012.00","First-Line Supervisors of Police and Detectives","A"),
    ("33-1021.00","First-Line Supervisors of Firefighting and Prevention Workers","A"),
    ("33-1091.00","First-Line Supervisors of Security Workers","A"),
    ("33-1099.00","First-Line Supervisors of Protective Service Workers, All Other","A"),
    ("33-2011.00","Firefighters","A"),
    ("33-2021.00","Fire Inspectors and Investigators","A"),
    ("33-2022.00","Forest Fire Inspectors and Prevention Specialists","A"),
    ("33-3011.00","Bailiffs","A"),
    ("33-3012.00","Correctional Officers and Jailers","A"),
    ("33-3021.00","Detectives and Criminal Investigators","B"),
    ("33-3031.00","Fish and Game Wardens","A"),
    ("33-3041.00","Parking Enforcement Workers","L"),
    ("33-3051.00","Police and Sheriff's Patrol Officers","A"),
    ("33-3052.00","Transit and Railroad Police","A"),
    ("33-3099.00","Law Enforcement Workers, All Other","A"),
    ("33-9011.00","Animal Control Workers","A"),
    ("33-9021.00","Private Detectives and Investigators","A"),
    ("33-9031.00","Gaming Surveillance Officers and Gaming Investigators","A"),
    ("33-9032.00","Security Guards","A"),
    ("33-9091.00","Crossing Guards and Flaggers","L"),
    ("33-9092.00","Lifeguards, Ski Patrol, and Other Recreational Protective Service Workers","A"),
    ("33-9093.00","Transportation Security Screeners","A"),
    ("33-9099.00","Protective Service Workers, All Other","A"),
    # ── 35 Food Preparation and Serving ──────────────────────────────────────
    ("35-1011.00","Chefs and Head Cooks","A"),
    ("35-1012.00","First-Line Supervisors of Food Preparation and Serving Workers","A"),
    ("35-2011.00","Cooks, Fast Food","A"),
    ("35-2012.00","Cooks, Institution and Cafeteria","A"),
    ("35-2013.00","Cooks, Private Household","A"),
    ("35-2014.00","Cooks, Restaurant","A"),
    ("35-2015.00","Cooks, Short Order","A"),
    ("35-2019.00","Cooks, All Other","A"),
    ("35-2021.00","Food Preparation Workers","A"),
    ("35-3011.00","Bartenders","A"),
    ("35-3023.00","Fast Food and Counter Workers","A"),
    ("35-3031.00","Waiters and Waitresses","A"),
    ("35-3041.00","Food Servers, Nonrestaurant","A"),
    ("35-9011.00","Dining Room and Cafeteria Attendants and Bartender Helpers","A"),
    ("35-9021.00","Dishwashers","L"),
    ("35-9031.00","Hosts and Hostesses, Restaurant, Lounge, and Coffee Shop","A"),
    ("35-9099.00","Food Preparation and Serving Related Workers, All Other","A"),
    # ── 37 Building and Grounds Cleaning and Maintenance ─────────────────────
    ("37-1011.00","First-Line Supervisors of Housekeeping and Janitorial Workers","A"),
    ("37-1012.00","First-Line Supervisors of Landscaping, Lawn Service, and Groundskeeping Workers","A"),
    ("37-2011.00","Janitors and Cleaners, Except Maids and Housekeeping Cleaners","A"),
    ("37-2012.00","Maids and Housekeeping Cleaners","A"),
    ("37-2019.00","Building Cleaning Workers, All Other","A"),
    ("37-2021.00","Pest Control Workers","A"),
    ("37-3011.00","Landscaping and Groundskeeping Workers","A"),
    ("37-3012.00","Pesticide Handlers, Sprayers, and Applicators, Vegetation","A"),
    ("37-3013.00","Tree Trimmers and Pruners","A"),
    ("37-3019.00","Grounds Maintenance Workers, All Other","A"),
    # ── 39 Personal Care and Service ─────────────────────────────────────────
    ("39-1013.00","First-Line Supervisors of Gambling Services Workers","A"),
    ("39-1014.00","First-Line Supervisors of Entertainment and Recreation Workers, Except Gambling","A"),
    ("39-1031.00","First-Line Supervisors of Personal Service Workers","A"),
    ("39-2011.00","Animal Trainers","A"),
    ("39-2021.00","Non-Farm Animal Caretakers","A"),
    ("39-3011.00","Gambling Dealers","A"),
    ("39-3021.00","Motion Picture Projectionists","L"),
    ("39-3031.00","Ushers, Lobby Attendants, and Ticket Takers","A"),
    ("39-3091.00","Amusement and Recreation Attendants","A"),
    ("39-3093.00","Locker Room, Coatroom, and Dressing Room Attendants","A"),
    ("39-3099.00","Entertainment Attendants and Related Workers, All Other","A"),
    ("39-4011.00","Embalmers","A"),
    ("39-4012.00","Crematory Operators","A"),
    ("39-4031.00","Funeral Attendants","A"),
    ("39-5011.00","Barbers","A"),
    ("39-5012.00","Hairdressers, Hairstylists, and Cosmetologists","A"),
    ("39-5013.00","Manicurists and Pedicurists","A"),
    ("39-5014.00","Skincare Specialists","B"),
    ("39-5091.00","Makeup Artists, Theatrical and Performance","A"),
    ("39-5092.00","Manicurists and Pedicurists","A"),
    ("39-5094.00","Skincare Specialists","B"),
    ("39-6011.00","Baggage Porters and Bellhops","A"),
    ("39-6012.00","Concierges","A"),
    ("39-7011.00","Tour Guides and Escorts","A"),
    ("39-7012.00","Travel Guides","A"),
    ("39-9011.00","Childcare Workers","A"),
    ("39-9021.00","Exercise Trainers and Group Fitness Instructors","B"),
    ("39-9031.00","Recreation Workers","A"),
    ("39-9032.00","Residential Advisors","A"),
    ("39-9099.00","Personal Care and Service Workers, All Other","A"),
    # ── 41 Sales and Related ──────────────────────────────────────────────────
    ("41-1011.00","First-Line Supervisors of Retail Sales Workers","A"),
    ("41-1012.00","First-Line Supervisors of Non-Retail Sales Workers","A"),
    ("41-2011.00","Cashiers","A"),
    ("41-2021.00","Counter and Rental Clerks","A"),
    ("41-2022.00","Parts Salespersons","A"),
    ("41-2031.00","Retail Salespersons","A"),
    ("41-3011.00","Advertising Sales Agents","A"),
    ("41-3021.00","Insurance Sales Agents","B"),
    ("41-3031.00","Securities, Commodities, and Financial Services Sales Agents","B"),
    ("41-3041.00","Travel Agents","A"),
    ("41-3091.00","Sales Representatives of Services, Except Advertising, Insurance, Financial Services, and Travel","A"),
    ("41-3099.00","Sales Representatives, Services, All Other","A"),
    ("41-4011.00","Sales Representatives, Wholesale and Manufacturing, Technical and Scientific Products","B"),
    ("41-4012.00","Sales Representatives, Wholesale and Manufacturing, Except Technical and Scientific Products","A"),
    ("41-9011.00","Demonstrators and Product Promoters","A"),
    ("41-9012.00","Models","A"),
    ("41-9021.00","Real Estate Brokers","A"),
    ("41-9022.00","Real Estate Sales Agents","A"),
    ("41-9031.00","Sales Engineers","B"),
    ("41-9041.00","Telemarketers","L"),
    ("41-9091.00","Door-to-Door Sales Workers, News and Street Vendors, and Related Workers","L"),
    ("41-9099.00","Sales and Related Workers, All Other","A"),
    # ── 43 Office and Administrative Support ─────────────────────────────────
    ("43-1011.00","First-Line Supervisors of Office and Administrative Support Workers","A"),
    ("43-2011.00","Switchboard Operators, Including Answering Service","L"),
    ("43-2021.00","Telephone Operators","L"),
    ("43-2099.00","Communications Equipment Operators, All Other","A"),
    ("43-3011.00","Bill and Account Collectors","A"),
    ("43-3021.00","Billing and Posting Clerks","A"),
    ("43-3031.00","Bookkeeping, Accounting, and Auditing Clerks","A"),
    ("43-3041.00","Gambling Cage Workers","A"),
    ("43-3051.00","Payroll and Timekeeping Clerks","A"),
    ("43-3061.00","Procurement Clerks","A"),
    ("43-3071.00","Tellers","A"),
    ("43-3099.00","Financial Clerks, All Other","A"),
    ("43-4011.00","Brokerage Clerks","A"),
    ("43-4021.00","Correspondence Clerks","L"),
    ("43-4031.00","Court, Municipal, and License Clerks","A"),
    ("43-4041.00","Credit Authorizers, Checkers, and Clerks","A"),
    ("43-4051.00","Customer Service Representatives","B"),
    ("43-4061.00","Eligibility Interviewers, Government Programs","A"),
    ("43-4071.00","File Clerks","L"),
    ("43-4081.00","Hotel, Motel, and Resort Desk Clerks","A"),
    ("43-4111.00","Interviewers, Except Eligibility and Loan","A"),
    ("43-4121.00","Library Assistants, Clerical","A"),
    ("43-4131.00","Loan Interviewers and Clerks","A"),
    ("43-4141.00","New Accounts Clerks","A"),
    ("43-4151.00","Order Clerks","A"),
    ("43-4161.00","Human Resources Assistants, Except Payroll and Timekeeping","A"),
    ("43-4171.00","Receptionists and Information Clerks","A"),
    ("43-4181.00","Reservation and Transportation Ticket Agents and Travel Clerks","A"),
    ("43-4199.00","Information and Record Clerks, All Other","A"),
    ("43-5011.00","Cargo and Freight Agents","A"),
    ("43-5021.00","Couriers and Messengers","A"),
    ("43-5031.00","Public Safety Telecommunicators","A"),
    ("43-5032.00","Dispatchers, Except Police, Fire, and Ambulance","A"),
    ("43-5041.00","Meter Readers, Utilities","A"),
    ("43-5051.00","Postal Service Clerks","A"),
    ("43-5052.00","Postal Service Mail Carriers","A"),
    ("43-5053.00","Postal Service Mail Sorters, Processors, and Processing Machine Operators","L"),
    ("43-5061.00","Production, Planning, and Expediting Clerks","A"),
    ("43-5071.00","Shipping, Receiving, and Inventory Clerks","A"),
    ("43-5111.00","Weighers, Measurers, Checkers, and Samplers, Recordkeeping","A"),
    ("43-6011.00","Executive Secretaries and Executive Administrative Assistants","A"),
    ("43-6012.00","Legal Secretaries and Administrative Assistants","A"),
    ("43-6013.00","Medical Secretaries and Administrative Assistants","A"),
    ("43-6014.00","Secretaries and Administrative Assistants, Except Legal, Medical, and Executive","A"),
    ("43-7011.00","Office Machine Operators, Except Computer","A"),
    ("43-8011.00","Data Entry Keyers","L"),
    ("43-9011.00","Computer Operators","A"),
    ("43-9031.00","Desktop Publishers","A"),
    ("43-9041.00","Insurance Claims and Policy Processing Clerks","A"),
    ("43-9051.00","Mail Clerks and Mail Machine Operators, Except Postal Service","L"),
    ("43-9061.00","Office Clerks, General","A"),
    ("43-9081.00","Proofreaders and Copy Markers","A"),
    ("43-9111.00","Statistical Assistants","A"),
    ("43-9199.00","Office and Administrative Support Workers, All Other","A"),
    # ── 45 Farming, Fishing, and Forestry ────────────────────────────────────
    ("45-1011.00","First-Line Supervisors of Farming, Fishing, and Forestry Workers","A"),
    ("45-2011.00","Agricultural Inspectors","A"),
    ("45-2021.00","Animal Breeders","A"),
    ("45-2041.00","Graders and Sorters, Agricultural Products","A"),
    ("45-2091.00","Agricultural Equipment Operators","A"),
    ("45-2092.00","Farmworkers and Laborers, Crop, Nursery, and Greenhouse","L"),
    ("45-2093.00","Farmworkers, Farm, Ranch, and Aquacultural Animals","L"),
    ("45-2099.00","Agricultural Workers, All Other","A"),
    ("45-3011.00","Fishing and Hunting Workers","A"),
    ("45-4011.00","Forest and Conservation Workers","A"),
    ("45-4021.00","Fallers","A"),
    ("45-4022.00","Logging Equipment Operators","A"),
    ("45-4023.00","Log Graders and Scalers","A"),
    ("45-4029.00","Logging Workers, All Other","A"),
    # ── 47 Construction and Extraction ───────────────────────────────────────
    ("47-1011.00","First-Line Supervisors of Construction Trades and Extraction Workers","A"),
    ("47-2011.00","Boilermakers","A"),
    ("47-2021.00","Brickmasons and Blockmasons","A"),
    ("47-2022.00","Stonemasons","A"),
    ("47-2031.00","Carpenters","A"),
    ("47-2041.00","Carpet Installers","A"),
    ("47-2042.00","Floor Layers, Except Carpet, Wood, and Hard Tiles","A"),
    ("47-2043.00","Floor Sanders and Finishers","A"),
    ("47-2044.00","Tile and Stone Setters","A"),
    ("47-2051.00","Cement Masons and Concrete Finishers","A"),
    ("47-2053.00","Terrazzo Workers and Finishers","A"),
    ("47-2061.00","Construction Laborers","A"),
    ("47-2071.00","Paving, Surfacing, and Tamping Equipment Operators","A"),
    ("47-2072.00","Pile Driver Operators","A"),
    ("47-2073.00","Operating Engineers and Other Construction Equipment Operators","A"),
    ("47-2081.00","Drywall and Ceiling Tile Installers","A"),
    ("47-2082.00","Tapers","A"),
    ("47-2111.00","Electricians","B"),
    ("47-2121.00","Glaziers","A"),
    ("47-2131.00","Insulation Workers, Floor, Ceiling, and Wall","A"),
    ("47-2132.00","Insulation Workers, Mechanical","A"),
    ("47-2141.00","Painters, Construction and Maintenance","A"),
    ("47-2142.00","Paperhangers","A"),
    ("47-2151.00","Pipelayers","A"),
    ("47-2152.00","Plumbers, Pipefitters, and Steamfitters","B"),
    ("47-2161.00","Plasterers and Stucco Masons","A"),
    ("47-2171.00","Reinforcing Iron and Rebar Workers","A"),
    ("47-2181.00","Roofers","A"),
    ("47-2211.00","Sheet Metal Workers","A"),
    ("47-2221.00","Structural Iron and Steel Workers","A"),
    ("47-2231.00","Solar Photovoltaic Installers","M"),
    ("47-2251.00","Telecommunications Equipment Installers and Repairers, Except Line Installers","A"),
    ("47-2261.00","Elevator and Escalator Installers and Repairers","B"),
    ("47-3011.00","Helpers—Brickmasons, Blockmasons, Stonemasons, and Tile and Marble Setters","A"),
    ("47-3012.00","Helpers—Carpenters","A"),
    ("47-3013.00","Helpers—Electricians","A"),
    ("47-3014.00","Helpers—Painters, Paperhangers, Plasterers, and Stucco Masons","A"),
    ("47-3015.00","Helpers—Pipelayers, Plumbers, Pipefitters, and Steamfitters","A"),
    ("47-3016.00","Helpers—Roofers","A"),
    ("47-3019.00","Helpers, Construction Trades, All Other","A"),
    ("47-4011.00","Construction and Building Inspectors","A"),
    ("47-4031.00","Fence Erectors","A"),
    ("47-4041.00","Hazardous Materials Removal Workers","B"),
    ("47-4051.00","Highway Maintenance Workers","A"),
    ("47-4061.00","Rail-Track Laying and Maintenance Equipment Operators","A"),
    ("47-4071.00","Septic Tank Servicers and Sewer Pipe Cleaners","A"),
    ("47-5011.00","Derrick Operators, Oil and Gas","A"),
    ("47-5012.00","Rotary Drill Operators, Oil and Gas","A"),
    ("47-5013.00","Service Unit Operators, Oil and Gas","A"),
    ("47-5021.00","Earth Drillers, Except Oil and Gas","A"),
    ("47-5031.00","Explosives Workers, Ordnance Handling Experts, and Blasters","A"),
    ("47-5041.00","Mining Machine Operators","A"),
    ("47-5042.00","Mine Cutting and Channeling Machine Operators","A"),
    ("47-5051.00","Rock Splitters, Quarry","A"),
    ("47-5061.00","Roof Bolters, Mining","A"),
    ("47-5071.00","Roustabouts, Oil and Gas","A"),
    ("47-5081.00","Helpers—Extraction Workers","A"),
    # ── 49 Installation, Maintenance, and Repair ──────────────────────────────
    ("49-1011.00","First-Line Supervisors of Mechanics, Installers, and Repairers","A"),
    ("49-2011.00","Computer, Automated Teller, and Office Machine Repairers","A"),
    ("49-2021.00","Radio, Cellular, and Tower Equipment Installers and Repairers","A"),
    ("49-2022.00","Telecommunications Equipment Installers and Repairers, Except Line Installers","B"),
    ("49-2091.00","Avionics Technicians","B"),
    ("49-2092.00","Electric Motor, Power Tool, and Related Repairers","A"),
    ("49-2093.00","Electrical and Electronics Installers and Repairers, Transportation Equipment","A"),
    ("49-2094.00","Electrical and Electronics Repairers, Commercial and Industrial Equipment","A"),
    ("49-2095.00","Electrical and Electronics Repairers, Powerhouse, Substation, and Relay","A"),
    ("49-2096.00","Electronic Equipment Installers and Repairers, Motor Vehicles","A"),
    ("49-2097.00","Electronic Home Entertainment Equipment Installers and Repairers","A"),
    ("49-2098.00","Security and Fire Alarm Systems Installers","B"),
    ("49-3011.00","Aircraft Mechanics and Service Technicians","B"),
    ("49-3021.00","Automotive Body and Related Repairers","A"),
    ("49-3022.00","Automotive Glass Installers and Repairers","A"),
    ("49-3023.00","Automotive Service Technicians and Mechanics","A"),
    ("49-3031.00","Bus and Truck Mechanics and Diesel Engine Specialists","A"),
    ("49-3041.00","Farm Equipment Mechanics and Service Technicians","A"),
    ("49-3042.00","Mobile Heavy Equipment Mechanics, Except Engines","A"),
    ("49-3043.00","Rail Car Repairers","A"),
    ("49-3051.00","Motorboat Mechanics and Service Technicians","A"),
    ("49-3052.00","Motorcycle Mechanics","A"),
    ("49-3053.00","Outdoor Power Equipment and Other Small Engine Mechanics","A"),
    ("49-3091.00","Bicycle Repairers","A"),
    ("49-3092.00","Recreational Vehicle Service Technicians","A"),
    ("49-3093.00","Tire Repairers and Changers","A"),
    ("49-9011.00","Mechanical Door Repairers","A"),
    ("49-9012.00","Control and Valve Installers and Repairers, Except Mechanical Door","A"),
    ("49-9021.00","Heating, Air Conditioning, and Refrigeration Mechanics and Installers","B"),
    ("49-9031.00","Home Appliance Repairers","A"),
    ("49-9041.00","Industrial Machinery Mechanics","B"),
    ("49-9043.00","Maintenance Workers, Machinery","A"),
    ("49-9044.00","Millwrights","A"),
    ("49-9045.00","Refractory Materials Repairers, Except Brickmasons","A"),
    ("49-9051.00","Electrical Power-Line Installers and Repairers","A"),
    ("49-9052.00","Telecommunications Line Installers and Repairers","A"),
    ("49-9061.00","Camera and Photographic Equipment Repairers","A"),
    ("49-9062.00","Medical Equipment Repairers","B"),
    ("49-9063.00","Musical Instrument Repairers and Tuners","A"),
    ("49-9064.00","Watch and Clock Repairers","A"),
    ("49-9069.00","Precision Instrument and Equipment Repairers, All Other","A"),
    ("49-9071.00","Maintenance and Repair Workers, General","A"),
    ("49-9081.00","Wind Turbine Service Technicians","M"),
    ("49-9091.00","Coin, Vending, and Amusement Machine Servicers and Repairers","A"),
    ("49-9092.00","Commercial Divers","A"),
    ("49-9094.00","Locksmiths and Safe Repairers","A"),
    ("49-9095.00","Manufactured Building and Mobile Home Installers","A"),
    ("49-9096.00","Riggers","A"),
    ("49-9097.00","Signal and Track Switch Repairers","A"),
    ("49-9099.00","Installation, Maintenance, and Repair Workers, All Other","A"),
    # ── 51 Production ─────────────────────────────────────────────────────────
    ("51-1011.00","First-Line Supervisors of Production and Operating Workers","A"),
    ("51-2011.00","Aircraft Structure, Surfaces, Rigging, and Systems Assemblers","A"),
    ("51-2021.00","Coil Winders, Tapers, and Finishers","A"),
    ("51-2022.00","Electrical and Electronic Equipment Assemblers","A"),
    ("51-2023.00","Electromechanical Equipment Assemblers","A"),
    ("51-2031.00","Engine and Other Machine Assemblers","A"),
    ("51-2041.00","Structural Metal Fabricators and Fitters","A"),
    ("51-2051.00","Fiberglass Laminators and Fabricators","A"),
    ("51-2092.00","Team Assemblers","A"),
    ("51-2099.00","Assemblers and Fabricators, All Other","A"),
    ("51-3011.00","Bakers","A"),
    ("51-3021.00","Butchers and Meat Cutters","A"),
    ("51-3022.00","Meat, Poultry, and Fish Cutters and Trimmers","A"),
    ("51-3023.00","Slaughterers and Meat Packers","A"),
    ("51-3091.00","Food and Tobacco Roasting, Baking, and Drying Machine Operators and Tenders","A"),
    ("51-3092.00","Food Batchmakers","A"),
    ("51-3093.00","Food Cooking Machine Operators and Tenders","A"),
    ("51-3099.00","Food Processing Workers, All Other","A"),
    ("51-4011.00","Computer Numerically Controlled Tool Operators","B"),
    ("51-4012.00","Computer Numerically Controlled Tool Programmers","B"),
    ("51-4021.00","Extruding and Drawing Machine Setters, Operators, and Tenders, Metal and Plastic","A"),
    ("51-4022.00","Forging Machine Setters, Operators, and Tenders, Metal and Plastic","A"),
    ("51-4023.00","Rolling Machine Setters, Operators, and Tenders, Metal and Plastic","A"),
    ("51-4031.00","Cutting, Punching, and Press Machine Setters, Operators, and Tenders, Metal and Plastic","A"),
    ("51-4032.00","Drilling and Boring Machine Tool Setters, Operators, and Tenders, Metal and Plastic","A"),
    ("51-4033.00","Grinding, Lapping, Polishing, and Buffing Machine Tool Setters, Metal and Plastic","A"),
    ("51-4034.00","Lathe and Turning Machine Tool Setters, Operators, and Tenders, Metal and Plastic","A"),
    ("51-4035.00","Milling and Planing Machine Setters, Operators, and Tenders, Metal and Plastic","A"),
    ("51-4041.00","Machinists","B"),
    ("51-4051.00","Metal-Refining Furnace Operators and Tenders","A"),
    ("51-4052.00","Pourers and Casters, Metal","A"),
    ("51-4061.00","Model Makers, Metal and Plastic","A"),
    ("51-4062.00","Patternmakers, Metal and Plastic","A"),
    ("51-4071.00","Foundry Mold and Coremakers","A"),
    ("51-4072.00","Molding, Coremaking, and Casting Machine Setters, Operators, and Tenders, Metal and Plastic","A"),
    ("51-4081.00","Multiple Machine Tool Setters, Operators, and Tenders, Metal and Plastic","A"),
    ("51-4111.00","Tool and Die Makers","A"),
    ("51-4121.00","Welders, Cutters, Solderers, and Brazers","A"),
    ("51-4122.00","Welding, Soldering, and Brazing Machine Setters, Operators, and Tenders","A"),
    ("51-4191.00","Heat Treating Equipment Setters, Operators, and Tenders, Metal and Plastic","A"),
    ("51-4192.00","Layout Workers, Metal and Plastic","A"),
    ("51-4193.00","Plating Machine Setters, Operators, and Tenders, Metal and Plastic","A"),
    ("51-4194.00","Tool Grinders, Filers, and Sharpeners","A"),
    ("51-4199.00","Metal Workers and Plastic Workers, All Other","A"),
    ("51-5111.00","Prepress Technicians and Workers","A"),
    ("51-5112.00","Printing Press Operators","A"),
    ("51-5113.00","Print Binding and Finishing Workers","A"),
    ("51-6011.00","Laundry and Dry-Cleaning Workers","A"),
    ("51-6021.00","Pressers, Textile, Garment, and Related Materials","A"),
    ("51-6031.00","Sewing Machine Operators","A"),
    ("51-6041.00","Shoe and Leather Workers and Repairers","A"),
    ("51-6042.00","Shoe Machine Operators and Tenders","A"),
    ("51-6051.00","Sewers, Hand","A"),
    ("51-6052.00","Tailors, Dressmakers, and Custom Sewers","A"),
    ("51-6061.00","Textile Bleaching and Dyeing Machine Operators and Tenders","A"),
    ("51-6062.00","Textile Cutting Machine Setters, Operators, and Tenders","A"),
    ("51-6063.00","Textile Knitting and Weaving Machine Setters, Operators, and Tenders","A"),
    ("51-6064.00","Textile Winding, Twisting, and Drawing Out Machine Setters, Operators, and Tenders","A"),
    ("51-6091.00","Extruding and Forming Machine Setters, Operators, and Tenders, Synthetic and Glass Fibers","A"),
    ("51-6092.00","Fabric and Apparel Patternmakers","A"),
    ("51-6093.00","Upholsterers","A"),
    ("51-6099.00","Textile, Apparel, and Furnishings Workers, All Other","A"),
    ("51-7011.00","Cabinetmakers and Bench Carpenters","A"),
    ("51-7021.00","Furniture Finishers","A"),
    ("51-7031.00","Model Makers, Wood","A"),
    ("51-7032.00","Patternmakers, Wood","A"),
    ("51-7041.00","Sawing Machine Setters, Operators, and Tenders, Wood","A"),
    ("51-7042.00","Woodworking Machine Setters, Operators, and Tenders, Except Sawing","A"),
    ("51-7099.00","Woodworkers, All Other","A"),
    ("51-8011.00","Nuclear Power Reactor Operators","A"),
    ("51-8012.00","Power Distributors and Dispatchers","A"),
    ("51-8013.00","Power Plant Operators","A"),
    ("51-8021.00","Stationary Engineers and Boiler Operators","A"),
    ("51-8031.00","Water and Wastewater Treatment Plant and System Operators","A"),
    ("51-8091.00","Chemical Plant and System Operators","A"),
    ("51-8092.00","Gas Plant Operators","A"),
    ("51-8093.00","Petroleum Pump System Operators, Refinery Operators, and Gaugers","A"),
    ("51-8099.00","Plant and System Operators, All Other","A"),
    ("51-9011.00","Chemical Equipment Operators and Tenders","A"),
    ("51-9012.00","Separating, Filtering, Clarifying, Precipitating, and Still Machine Setters, Operators, and Tenders","A"),
    ("51-9021.00","Crushing, Grinding, and Polishing Machine Setters, Operators, and Tenders","A"),
    ("51-9022.00","Grinding and Polishing Workers, Hand","A"),
    ("51-9023.00","Mixing and Blending Machine Setters, Operators, and Tenders","A"),
    ("51-9031.00","Cutters and Trimmers, Hand","A"),
    ("51-9032.00","Cutting and Slicing Machine Setters, Operators, and Tenders","A"),
    ("51-9041.00","Extruding, Forming, Pressing, and Compacting Machine Setters, Operators, and Tenders","A"),
    ("51-9051.00","Furnace, Kiln, Oven, Drier, and Kettle Operators and Tenders","A"),
    ("51-9061.00","Inspectors, Testers, Sorters, Samplers, and Weighers","A"),
    ("51-9071.00","Jewelers and Precious Stone and Metal Workers","A"),
    ("51-9081.00","Dental Laboratory Technicians","A"),
    ("51-9082.00","Medical Appliance Technicians","A"),
    ("51-9083.00","Ophthalmic Laboratory Technicians","A"),
    ("51-9111.00","Packaging and Filling Machine Operators and Tenders","A"),
    ("51-9121.00","Coating, Painting, and Spraying Machine Setters, Operators, and Tenders","A"),
    ("51-9122.00","Painters, Transportation Equipment","A"),
    ("51-9123.00","Painting, Coating, and Decorating Workers","A"),
    ("51-9131.00","Photographic Process Workers and Processing Machine Operators","A"),
    ("51-9141.00","Semiconductor Processing Technicians","B"),
    ("51-9191.00","Adhesive Bonding Machine Operators and Tenders","A"),
    ("51-9192.00","Cleaning, Washing, and Metal Pickling Equipment Operators and Tenders","A"),
    ("51-9193.00","Cooling and Freezing Equipment Operators and Tenders","A"),
    ("51-9194.00","Etchers and Engravers","A"),
    ("51-9195.00","Molders, Shapers, and Casters, Except Metal and Plastic","A"),
    ("51-9196.00","Paper Goods Machine Setters, Operators, and Tenders","A"),
    ("51-9197.00","Tire Builders","A"),
    ("51-9198.00","Helpers—Production Workers","A"),
    ("51-9199.00","Production Workers, All Other","A"),
    # ── 53 Transportation and Material Moving ─────────────────────────────────
    ("53-1047.00","First-Line Supervisors of Transportation and Material-Moving Workers","A"),
    ("53-2011.00","Airline Pilots, Copilots, and Flight Engineers","A"),
    ("53-2012.00","Commercial Pilots","B"),
    ("53-2021.00","Air Traffic Controllers","A"),
    ("53-2022.00","Airfield Operations Specialists","A"),
    ("53-2031.00","Flight Attendants","A"),
    ("53-3011.00","Ambulance Drivers and Attendants, Except Emergency Medical Technicians","A"),
    ("53-3031.00","Driver/Sales Workers","A"),
    ("53-3032.00","Heavy and Tractor-Trailer Truck Drivers","A"),
    ("53-3033.00","Light Truck Drivers","A"),
    ("53-3041.00","Taxi Drivers","A"),
    ("53-3042.00","Rideshare Drivers","A"),
    ("53-3051.00","Bus Drivers, School","A"),
    ("53-3052.00","Bus Drivers, Transit and Intercity","A"),
    ("53-3053.00","Shuttle Drivers and Chauffeurs","A"),
    ("53-3099.00","Motor Vehicle Operators, All Other","A"),
    ("53-4011.00","Locomotive Engineers","A"),
    ("53-4012.00","Locomotive Firers","A"),
    ("53-4021.00","Railroad Brake, Signal, and Switch Operators and Locomotive Firers","A"),
    ("53-4031.00","Railroad Conductors and Yardmasters","A"),
    ("53-4041.00","Subway and Streetcar Operators","A"),
    ("53-4099.00","Rail Transportation Workers, All Other","A"),
    ("53-5011.00","Sailors and Marine Oilers","A"),
    ("53-5021.00","Ship and Boat Captains","A"),
    ("53-5022.00","Motorboat Operators","A"),
    ("53-5031.00","Ship Engineers","A"),
    ("53-6011.00","Bridge and Lock Tenders","A"),
    ("53-6021.00","Parking Attendants","A"),
    ("53-6031.00","Automotive and Watercraft Service Attendants","A"),
    ("53-6041.00","Traffic Technicians","A"),
    ("53-6051.00","Transportation Inspectors","A"),
    ("53-6061.00","Passenger Attendants","A"),
    ("53-6099.00","Transportation Workers, All Other","A"),
    ("53-7011.00","Conveyor Operators and Tenders","A"),
    ("53-7021.00","Crane and Tower Operators","A"),
    ("53-7031.00","Dredge Operators","A"),
    ("53-7041.00","Hoist and Winch Operators","A"),
    ("53-7051.00","Industrial Truck and Tractor Operators","A"),
    ("53-7061.00","Cleaners of Vehicles and Equipment","A"),
    ("53-7062.00","Laborers and Freight, Stock, and Material Movers, Hand","A"),
    ("53-7063.00","Machine Feeders and Offbearers","A"),
    ("53-7064.00","Packers and Packagers, Hand","A"),
    ("53-7065.00","Stockers and Order Fillers","B"),
    ("53-7069.00","Material Moving Workers, All Other","A"),
    ("53-7081.00","Refuse and Recyclable Material Collectors","A"),
    # ── 55 Military Specific ──────────────────────────────────────────────────
    ("55-1011.00","Air Crew Officers","A"),
    ("55-1012.00","Aircraft Launch and Recovery Officers","A"),
    ("55-1013.00","Armored Assault Vehicle Officers","A"),
    ("55-1014.00","Artillery and Missile Officers","A"),
    ("55-1015.00","Command and Control Center Officers","A"),
    ("55-1016.00","Infantry Officers","A"),
    ("55-1017.00","Special Forces Officers","A"),
    ("55-1019.00","Military Officer Special and Tactical Operations Leaders, All Other","A"),
    ("55-2011.00","First-Line Enlisted Military Supervisors","A"),
    ("55-2012.00","Aircraft Launch and Recovery Specialists","A"),
    ("55-2013.00","Armored Assault Vehicle Crew Members","A"),
    ("55-2014.00","Artillery and Missile Crew Members","A"),
    ("55-2015.00","Command and Control Center Specialists","A"),
    ("55-2016.00","Infantry","A"),
    ("55-2017.00","Special Forces","A"),
    ("55-2019.00","Military Enlisted Tactical Operations and Air/Weapons Specialists, All Other","A"),
    ("55-3011.00","Military Officers, All Other","A"),
    ("55-3012.00","Military Enlisted Workers, All Other","A"),
]

_MOCK_REGISTRY: list[dict[str, Any]] = [_auto_reg(c, t, k) for c, t, k in _RAW_ONET]
# Restore full detail on the vault IP entry
for _r in _MOCK_REGISTRY:
    if _r["soc_code"] == "15-1299.08":
        _r["title"] = "SAL Systems Integrator (Vault IP) \U0001f3c6"
        _r["market_value"] = "Proprietary"
        _r["outlook"] = "Institutional — vault-tier registry logic"
        _r["description"] = "Proprietary SAL agent-logic blueprint for orchestration and registry-grade exports."
        break

_MOCK_STEP_TEMPLATE: list[dict[str, str]] = [
    {"step": "Intake & scope",       "detail": "Confirm stakeholders, constraints, and success measures."},
    {"step": "Baseline & discovery", "detail": "Gather artifacts, systems map, and dependency list."},
    {"step": "Design & plan",        "detail": "Produce blueprint, milestones, and approval gates."},
    {"step": "Execute & instrument", "detail": "Run delivery with telemetry, tests, and controls."},
    {"step": "Close & handoff",      "detail": "Document outcomes, runbooks, and compliance evidence."},
]

_MOCK_LOGIC: dict[str, dict[str, Any]] = {

    # ── 11 MANAGEMENT ──────────────────────────────────────────────────────────
    "11-1011.00": {
        "soc_code": "11-1011.00",
        "primary_directive": "Establish enterprise direction, allocate capital, and align operating units to regulatory and stakeholder outcomes.",
        "step_by_step_json": [
            {"step": "Frame mandate",       "detail": "Clarify board mandate, risk appetite, and 12-24 month priorities."},
            {"step": "Set operating model", "detail": "Define decision rights, KPI tree, and escalation paths."},
            {"step": "Allocate resources",  "detail": "Align budget, talent, and technology to top initiatives."},
            {"step": "Govern execution",    "detail": "Run executive operating rhythm with audit-ready artifacts."},
            {"step": "Assure compliance",   "detail": "Verify statutory, contractual, and ISO control posture."},
        ],
        "toolbox_requirements": {"erp": ["SAP", "Oracle Fusion"], "governance": ["Board portal", "Risk register", "OKR platform"]},
    },
    "11-3021.00": {
        "soc_code": "11-3021.00",
        "primary_directive": "Direct technology strategy and infrastructure to maintain competitive capability, security posture, and 99.9%+ platform reliability.",
        "step_by_step_json": [
            {"step": "Assess tech landscape",  "detail": "Inventory systems, vendors, technical debt, and capability gaps vs. roadmap."},
            {"step": "Define architecture",     "detail": "Publish target-state diagrams, ADRs, and platform engineering standards."},
            {"step": "Secure the perimeter",    "detail": "Commission pen-test, remediate CVSS ≥7 findings, enforce MFA and RBAC."},
            {"step": "Govern delivery",         "detail": "Run sprint reviews, incident reviews, and change-advisory meetings on cadence."},
            {"step": "Report to executive",     "detail": "Produce monthly IT scorecard: uptime, cost/unit, backlog health, risk register delta."},
        ],
        "toolbox_requirements": {"itsm": ["ServiceNow", "Jira Service Mgmt"], "monitoring": ["Datadog", "PagerDuty"], "security": ["SIEM", "Vulnerability scanner"]},
    },

    # ── 13 FINANCE ─────────────────────────────────────────────────────────────
    "13-2051.00": {
        "soc_code": "13-2051.00",
        "primary_directive": "Translate financial data into investment intelligence: model valuation, stress-test assumptions, and deliver decision-grade research with defensible methodology.",
        "step_by_step_json": [
            {"step": "Source & validate data",  "detail": "Pull filings (10-K/Q, 8-K), normalize for GAAP/IFRS adjustments, and flag restatements."},
            {"step": "Build financial model",   "detail": "Construct 3-statement model with DCF, comps, and sensitivity tables."},
            {"step": "Stress-test scenarios",   "detail": "Run bear/base/bull cases across macro, credit, and operational levers."},
            {"step": "Draft investment thesis", "detail": "Synthesize key drivers, catalysts, and risks into a 1-page investment memo."},
            {"step": "Deliver & defend",        "detail": "Present to portfolio committee, log model version, and track to price target."},
        ],
        "toolbox_requirements": {"data": ["Bloomberg Terminal", "FactSet", "Refinitiv"], "modeling": ["Excel / Python pandas", "Capital IQ"], "compliance": ["FINRA rulebook", "CFA standards checklist"]},
    },
    "13-1111.00": {
        "soc_code": "13-1111.00",
        "primary_directive": "Diagnose organizational performance gaps and prescribe evidence-based operating model improvements with measurable ROI.",
        "step_by_step_json": [
            {"step": "Scope engagement",       "detail": "Agree on problem statement, stakeholders, data access, and deliverable format."},
            {"step": "Collect evidence",        "detail": "Interview SMEs, mine operational data, and benchmark against industry peers."},
            {"step": "Diagnose root causes",    "detail": "Apply structured problem-solving (MECE, fishbone, value-stream) to isolate drivers."},
            {"step": "Design recommendations", "detail": "Prioritize initiatives by impact/effort; build implementation roadmap with owners."},
            {"step": "Transfer & close",        "detail": "Hand off playbook, train internal team, and schedule 90-day check-in."},
        ],
        "toolbox_requirements": {"analytics": ["Power BI", "Tableau", "SQL"], "frameworks": ["McKinsey 7S", "MECE canvas"], "collab": ["Miro", "Confluence"]},
    },

    # ── 15 TECHNOLOGY ──────────────────────────────────────────────────────────
    "15-1245.00": {
        "soc_code": "15-1245.00",
        "primary_directive": "Extract predictive signal from complex, high-dimensional data sets; deploy production-grade ML systems that drive measurable business outcomes.",
        "step_by_step_json": [
            {"step": "Frame the problem",      "detail": "Translate business question to ML task type (classification, regression, forecasting, NLP)."},
            {"step": "Engineer features",      "detail": "Ingest raw data pipelines, handle missingness, encode categoricals, and version feature store."},
            {"step": "Train & tune models",    "detail": "Baseline → hyperparameter search → ensemble; track experiments in MLflow or W&B."},
            {"step": "Validate rigorously",    "detail": "Evaluate on holdout, slice by subgroups, run bias/fairness audit and SHAP explainability."},
            {"step": "Deploy & monitor",       "detail": "Ship via CI/CD to serving layer; instrument data drift, model decay, and alert thresholds."},
        ],
        "toolbox_requirements": {"compute": ["GPU cluster", "AWS SageMaker", "GCP Vertex AI"], "stack": ["Python", "PyTorch / scikit-learn", "Apache Spark"], "ops": ["MLflow", "Weights & Biases", "Evidently AI"]},
    },
    "15-1252.00": {
        "soc_code": "15-1252.00",
        "primary_directive": "Architect, build, and ship reliable software systems at scale — writing clean code, preventing regressions, and continuously improving system quality.",
        "step_by_step_json": [
            {"step": "Clarify requirements",   "detail": "Break down epic into user stories; define acceptance criteria and edge cases."},
            {"step": "Design system",          "detail": "Produce ADR covering data model, API contracts, dependencies, and scale assumptions."},
            {"step": "Implement & test",       "detail": "Write production code + unit/integration tests; enforce ≥80% coverage gate in CI."},
            {"step": "Code review & security", "detail": "Peer review for correctness, OWASP top-10 scan, and dependency CVE check."},
            {"step": "Deploy & observe",       "detail": "Canary deploy with feature flag; monitor latency P99, error rate, and rollback trigger."},
        ],
        "toolbox_requirements": {"languages": ["Python", "TypeScript", "Go", "Rust"], "infra": ["Docker", "Kubernetes", "Terraform"], "ci_cd": ["GitHub Actions", "ArgoCD"], "observability": ["OpenTelemetry", "Grafana"]},
    },
    "15-1211.00": {
        "soc_code": "15-1211.00",
        "primary_directive": "Bridge business needs and IT capabilities — designing systems that are cost-efficient, secure, interoperable, and aligned to enterprise architecture standards.",
        "step_by_step_json": [
            {"step": "Elicit requirements",    "detail": "Run structured workshops to capture functional, non-functional, and integration needs."},
            {"step": "Map current state",       "detail": "Document AS-IS data flows, integrations, and pain points using BPMN or ArchiMate."},
            {"step": "Design future state",     "detail": "Produce TO-BE architecture with gap analysis, vendor recommendations, and risk log."},
            {"step": "Validate with IT & biz",  "detail": "Walk through with tech leads and business owners; resolve conflicting priorities."},
            {"step": "Govern implementation",   "detail": "Oversee dev team adherence to spec; conduct UAT sign-off and architecture gate review."},
        ],
        "toolbox_requirements": {"modeling": ["Lucidchart", "Sparx EA", "ArchiMate"], "analysis": ["JIRA", "Confluence", "Draw.io"], "testing": ["Postman", "SoapUI", "JMeter"]},
    },

    # ── 17 ENGINEERING ─────────────────────────────────────────────────────────
    "17-2141.00": {
        "soc_code": "17-2141.00",
        "primary_directive": "Design, analyze, and validate mechanical systems that meet performance specs, manufacturing tolerances, and safety codes across the full product lifecycle.",
        "step_by_step_json": [
            {"step": "Define specifications",  "detail": "Capture load cases, thermal constraints, material limits, and regulatory standards (ASME, ISO)."},
            {"step": "Conceptual design",      "detail": "Generate design alternatives via sketches and CAD concepts; select via Pugh matrix."},
            {"step": "Detailed modeling",      "detail": "Build 3D parametric model; run FEA (stress, fatigue, thermal) and tolerance stack-up."},
            {"step": "Prototype & test",       "detail": "Fabricate prototype; run validation tests against spec; iterate on failures."},
            {"step": "Release for production", "detail": "Issue controlled drawings, BOM, and DFMEA; obtain DFM sign-off from manufacturing."},
        ],
        "toolbox_requirements": {"cad_cae": ["SolidWorks / CATIA", "ANSYS / Abaqus", "MATLAB"], "pdm": ["PTC Windchill", "Teamcenter"], "standards": ["ASME Y14.5 GD&T", "ISO 9001 QMS"]},
    },
    "17-2051.00": {
        "soc_code": "17-2051.00",
        "primary_directive": "Plan, design, and oversee construction of civil infrastructure — ensuring structural integrity, code compliance, environmental sustainability, and on-budget delivery.",
        "step_by_step_json": [
            {"step": "Site & needs assessment", "detail": "Survey site conditions, geotechnical data, hydrology, and regulatory constraints."},
            {"step": "Preliminary design",      "detail": "Develop schematic design, feasibility cost estimate, and permitting strategy."},
            {"step": "Detailed engineering",    "detail": "Produce construction drawings, structural calcs, and technical specifications."},
            {"step": "Bid & procurement",       "detail": "Issue IFB, evaluate contractor proposals, and award with bonding and insurance requirements."},
            {"step": "Construction oversight",  "detail": "Inspect RFIs, submittals, and field conditions; certify pay applications and punch list."},
        ],
        "toolbox_requirements": {"design": ["AutoCAD Civil 3D", "Revit", "Bentley OpenRoads"], "analysis": ["STAAD.Pro", "SAP2000"], "project": ["Primavera P6", "Procore"]},
    },

    # ── 19 SCIENCE ─────────────────────────────────────────────────────────────
    "19-1042.00": {
        "soc_code": "19-1042.00",
        "primary_directive": "Design and execute rigorous biomedical research protocols that advance disease understanding, validate therapeutic targets, and generate publication-grade evidence.",
        "step_by_step_json": [
            {"step": "Formulate hypothesis",    "detail": "Review literature; define PICO question, primary endpoint, and success criteria."},
            {"step": "Design study protocol",   "detail": "Select model system, sample sizes (power calc), controls, and blinding strategy."},
            {"step": "Conduct experiments",     "detail": "Execute protocol with GLP documentation; manage reagents, cell lines, and data chain-of-custody."},
            {"step": "Analyze & interpret",     "detail": "Apply appropriate biostatistics; generate figures; assess significance and effect size."},
            {"step": "Disseminate findings",    "detail": "Submit to peer-reviewed journal; file IP disclosures; brief regulatory affairs on translational implications."},
        ],
        "toolbox_requirements": {"lab": ["Flow cytometry", "CRISPR screening platform", "Mass spectrometry"], "informatics": ["R / Python", "GraphPad Prism", "Galaxy bioinformatics"], "compliance": ["IACUC protocol", "GLP audit trail"]},
    },
    "19-2031.00": {
        "soc_code": "19-2031.00",
        "primary_directive": "Develop and characterize chemical compounds, materials, and processes — from molecular design through safety validation and scale-up documentation.",
        "step_by_step_json": [
            {"step": "Literature & IP scan",    "detail": "Review prior art, patent landscape, and safety data sheets for target chemistry."},
            {"step": "Synthesize & characterize","detail": "Execute synthesis route; confirm structure via NMR, MS, IR; measure physical properties."},
            {"step": "Optimize & scale",        "detail": "Iterate reaction conditions for yield and selectivity; develop scalable process with EHS review."},
            {"step": "Safety & regulatory",     "detail": "Complete SDS, GHS classification, waste disposal plan, and REACH/TSCA compliance check."},
            {"step": "Document & publish",      "detail": "Archive lab notebooks, ELN entries, and submit findings for peer review or patent filing."},
        ],
        "toolbox_requirements": {"instrumentation": ["NMR spectrometer", "HPLC-MS", "FTIR"], "informatics": ["ChemDraw", "SciFinder / Reaxys", "ELN platform"], "safety": ["SDS management system", "COSHH assessment"]},
    },

    # ── 21 COMMUNITY ───────────────────────────────────────────────────────────
    "21-1023.00": {
        "soc_code": "21-1023.00",
        "primary_directive": "Deliver trauma-informed, evidence-based behavioral health interventions that support recovery, community reintegration, and sustained wellness outcomes.",
        "step_by_step_json": [
            {"step": "Intake & risk screen",    "detail": "Administer validated tools (PHQ-9, AUDIT, DAST); complete safety assessment and crisis plan."},
            {"step": "Treatment planning",      "detail": "Co-create individualized plan with goals, evidence-based modalities (CBT, MI, MAT), and milestones."},
            {"step": "Coordinate care",         "detail": "Link to psychiatry, PCP, housing, and peer support; manage releases of information."},
            {"step": "Deliver interventions",   "detail": "Conduct individual and group sessions; document per SOAP and payer requirements."},
            {"step": "Discharge & follow-up",   "detail": "Build relapse prevention plan, warm-handoff to community resources, 30/60/90-day check-in."},
        ],
        "toolbox_requirements": {"ehr": ["Epic", "Cerner", "Credible"], "clinical": ["PHQ-9", "AUDIT-C", "Columbia Suicide Scale"], "resources": ["SAMHSA locator", "211 referral network"]},
    },

    # ── 23 LEGAL ───────────────────────────────────────────────────────────────
    "23-1011.00": {
        "soc_code": "23-1011.00",
        "primary_directive": "Represent client interests with precision legal analysis, strategic advocacy, and risk-calibrated counsel — from intake through resolution or trial.",
        "step_by_step_json": [
            {"step": "Conflict check & intake",  "detail": "Run conflict-of-interest screen; execute engagement letter and retainer."},
            {"step": "Research & discovery",     "detail": "Survey case law, statutes, and regulations; issue discovery, manage document review via TAR."},
            {"step": "Develop legal theory",     "detail": "Frame causes of action or defenses; draft pleadings, motions, and briefs with controlling authority."},
            {"step": "Negotiate or litigate",    "detail": "Conduct mediation, depositions, or trial prep; evaluate settlement risk against litigation cost."},
            {"step": "Close & preserve",         "detail": "Execute judgment or settlement; file closing docs; retain matter files per jurisdiction rules."},
        ],
        "toolbox_requirements": {"research": ["Westlaw", "LexisNexis", "Fastcase"], "ediscovery": ["Relativity", "Everlaw"], "practice_mgmt": ["Clio", "iManage", "NetDocuments"]},
    },

    # ── 25 EDUCATION ───────────────────────────────────────────────────────────
    "25-2021.00": {
        "soc_code": "25-2021.00",
        "primary_directive": "Foster foundational literacy, numeracy, and social-emotional learning in every student — using differentiated instruction and data-driven intervention cycles.",
        "step_by_step_json": [
            {"step": "Assess baseline",         "detail": "Administer diagnostic assessments (reading levels, math fluency); map IEPs and 504 plans."},
            {"step": "Plan curriculum unit",    "detail": "Align lessons to state standards; design gradual-release sequence with formative checkpoints."},
            {"step": "Differentiate delivery",  "detail": "Use small-group rotations, scaffolded materials, and tech tools for diverse learners."},
            {"step": "Monitor & adjust",        "detail": "Analyze weekly progress data; adjust pacing, groupings, and intervention intensity."},
            {"step": "Communicate outcomes",    "detail": "Share report cards and conference notes with families; escalate concerns to counselors or specialists."},
        ],
        "toolbox_requirements": {"learning": ["Google Classroom", "Seesaw", "IXL"], "assessment": ["NWEA MAP", "DIBELS", "Renaissance Star"], "ell_support": ["Amplify CKLA", "Rosetta Stone"]},
    },

    # ── 27 ARTS & MEDIA ────────────────────────────────────────────────────────
    "27-3042.00": {
        "soc_code": "27-3042.00",
        "primary_directive": "Transform complex technical concepts into precise, accessible documentation — reducing support burden, accelerating onboarding, and satisfying compliance requirements.",
        "step_by_step_json": [
            {"step": "Needs analysis",          "detail": "Interview SMEs and end-users; identify gaps in existing docs; define audience and output formats."},
            {"step": "Information architecture","detail": "Design topic hierarchy using DITA or docs-as-code structure; establish style guide and templates."},
            {"step": "Draft content",           "detail": "Write procedure, reference, and conceptual topics with screenshots, code samples, and callouts."},
            {"step": "Technical review",        "detail": "Route drafts to engineering and QA for accuracy review; resolve comments in tracker."},
            {"step": "Publish & maintain",      "detail": "Build and deploy to docs portal; set review cadence; track doc issues from support tickets."},
        ],
        "toolbox_requirements": {"authoring": ["MadCap Flare", "Sphinx", "Docusaurus"], "graphics": ["Snagit", "Figma", "Adobe Illustrator"], "version_control": ["Git / GitHub", "Paligo"]},
    },
    "27-1024.00": {
        "soc_code": "27-1024.00",
        "primary_directive": "Create visual communications that solve business problems — balancing brand integrity, user psychology, and aesthetic excellence across digital and print channels.",
        "step_by_step_json": [
            {"step": "Brief & research",        "detail": "Absorb creative brief, audience personas, competitive landscape, and brand standards."},
            {"step": "Concept development",     "detail": "Sketch multiple directions; present mood boards and rationale to stakeholders."},
            {"step": "Design execution",        "detail": "Build production files in vector and raster formats; apply typography, color, and grid systems."},
            {"step": "Feedback & iteration",    "detail": "Present designs in context; incorporate structured feedback; version and track revisions."},
            {"step": "Handoff & archive",       "detail": "Package assets for print or dev handoff (export specs, style tokens); archive source files in DAM."},
        ],
        "toolbox_requirements": {"design": ["Figma", "Adobe CC (Illustrator, Photoshop, InDesign)"], "prototyping": ["Figma Interactive", "InVision"], "assets": ["DAM platform", "Stock library"]},
    },

    # ── 29 HEALTHCARE ──────────────────────────────────────────────────────────
    "29-1215.00": {
        "soc_code": "29-1215.00",
        "primary_directive": "Deliver comprehensive, evidence-based primary care — managing acute illness, chronic disease, preventive services, and care coordination across the patient lifespan.",
        "step_by_step_json": [
            {"step": "Patient encounter",       "detail": "Take history, perform physical exam; review HPI, medications, allergies, and SDOH factors."},
            {"step": "Clinical reasoning",      "detail": "Form differential, order targeted diagnostics, and apply clinical decision support tools."},
            {"step": "Treatment & prescribing", "detail": "Apply evidence-based guidelines (ADA, JNC, USPSTF); e-prescribe with drug-interaction check."},
            {"step": "Coordinate care",         "detail": "Refer to specialists, manage transitions, and reconcile medications across settings."},
            {"step": "Document & quality",      "detail": "Complete SOAP note, close care gaps for HEDIS measures, and respond to patient portal messages."},
        ],
        "toolbox_requirements": {"ehr": ["Epic", "Athenahealth", "eClinicalWorks"], "decision_support": ["UpToDate", "CDC immunization schedule"], "quality": ["HEDIS dashboard", "Chronic disease registry"]},
    },
    "29-1141.00": {
        "soc_code": "29-1141.00",
        "primary_directive": "Deliver safe, patient-centered nursing care — assessing clinical status, executing physician orders, advocating for patients, and preventing adverse events.",
        "step_by_step_json": [
            {"step": "Shift assessment",        "detail": "Complete head-to-toe assessment; review chart, vitals trend, and handoff from prior nurse."},
            {"step": "Plan & prioritize",       "detail": "Apply nursing diagnosis framework (NANDA); prioritize by acuity using SBAR and ISBAR."},
            {"step": "Administer & document",   "detail": "Execute medication administration with 5-rights; chart interventions in real time."},
            {"step": "Patient education",       "detail": "Teach condition management, discharge instructions, and medication adherence in plain language."},
            {"step": "Handoff & escalation",    "detail": "Use structured SBAR handoff; escalate deteriorating patients via rapid response or STAT call."},
        ],
        "toolbox_requirements": {"ehr": ["Epic", "Cerner", "Meditech"], "monitoring": ["Cardiac telemetry", "SpO2 / EtCO2 monitoring"], "safety": ["Pyxis / Omnicell dispensing", "Bar-code MAR"]},
    },

    # ── 31 HEALTH SUPPORT ──────────────────────────────────────────────────────
    "31-1131.00": {
        "soc_code": "31-1131.00",
        "primary_directive": "Provide compassionate, dignity-preserving personal care that supports resident or patient activities of daily living while maintaining infection control and safety standards.",
        "step_by_step_json": [
            {"step": "Report & review",         "detail": "Review care plan updates from prior shift; note changes in resident condition or behavior."},
            {"step": "Personal care delivery",  "detail": "Assist with bathing, grooming, dressing, positioning, and mobility per individualized care plan."},
            {"step": "Nutrition & hydration",   "detail": "Serve meals, document intake, assist with feeding, and monitor for dysphagia signs."},
            {"step": "Observe & report",        "detail": "Document vitals, skin integrity, and behavioral changes; report deviations to charge nurse immediately."},
            {"step": "Environment & safety",    "detail": "Maintain clean, clutter-free resident space; apply fall-prevention and standard precautions."},
        ],
        "toolbox_requirements": {"ehr": ["PointClickCare", "MatrixCare"], "safety": ["Gait belt", "Hoyer lift protocol"], "infection_control": ["PPE bundle", "Hand hygiene audit tool"]},
    },

    # ── 33 PROTECTIVE SERVICES ─────────────────────────────────────────────────
    "33-3051.00": {
        "soc_code": "33-3051.00",
        "primary_directive": "Maintain public safety through visible patrol, rapid incident response, evidence-based policing strategies, and constitutional, community-centered law enforcement.",
        "step_by_step_json": [
            {"step": "Patrol & presence",       "detail": "Conduct assigned patrol; engage community contacts; log observations in CAD system."},
            {"step": "Incident response",       "detail": "Respond to calls for service; assess threat level; apply de-escalation before force continuum."},
            {"step": "Investigation & evidence","detail": "Secure scene, collect and chain-of-custody physical/digital evidence, canvass witnesses."},
            {"step": "Report & documentation",  "detail": "Complete incident report, arrest affidavit, or use-of-force report within shift per policy."},
            {"step": "Court & prosecution",     "detail": "Testify with organized notes; coordinate with DA; maintain evidence integrity through trial."},
        ],
        "toolbox_requirements": {"dispatch": ["CAD system", "RMS (records management)"], "field": ["Body-worn camera", "TASER", "Mobile data terminal"], "analytics": ["PredPol / ShotSpotter", "NIBRS reporting"]},
    },
    "33-1011.00": {
        "soc_code": "33-1011.00",
        "primary_directive": "Lead correctional officer teams to maintain secure, humane, and rehabilitative facility operations — enforcing policy, managing incidents, and developing staff.",
        "step_by_step_json": [
            {"step": "Shift briefing",          "detail": "Review inmate population changes, incident log, and post assignments before shift."},
            {"step": "Security audits",         "detail": "Conduct head counts, contraband searches, and perimeter checks per post orders."},
            {"step": "Incident management",     "detail": "Command emergency response; apply use-of-force matrix; preserve evidence and document."},
            {"step": "Staff development",       "detail": "Coach officers on de-escalation, policy compliance, and professional conduct; document counseling."},
            {"step": "Reporting & compliance",  "detail": "Complete supervisory log; review incident reports for accuracy; submit ACA compliance data."},
        ],
        "toolbox_requirements": {"systems": ["Offender management system", "Incident command radio"], "compliance": ["ACA standards checklist", "PREA audit tool"], "training": ["CJTC curriculum", "De-escalation simulator"]},
    },

    # ── 35 FOOD SERVICE ────────────────────────────────────────────────────────
    "35-1011.00": {
        "soc_code": "35-1011.00",
        "primary_directive": "Conceive, execute, and quality-control restaurant cuisine — from menu engineering and cost control through brigade leadership and plate-perfect service delivery.",
        "step_by_step_json": [
            {"step": "Menu engineering",        "detail": "Design seasonal menu balancing food cost %, margin, dietary trends, and kitchen throughput."},
            {"step": "Procurement & prep",      "detail": "Source vendors, set par levels, write production sheets, and oversee mise en place."},
            {"step": "Service execution",       "detail": "Run expediting station during service; enforce ticket times, plate presentation, and temperature standards."},
            {"step": "Food safety & sanitation","detail": "Monitor HACCP controls, temp logs, and cleaning schedules; conduct daily line checks."},
            {"step": "Team development",        "detail": "Train line cooks, conduct skills demos, manage schedules, and drive labor cost within budget."},
        ],
        "toolbox_requirements": {"operations": ["POS system", "Recipe costing software (e.g., MarketMan)"], "safety": ["HACCP log", "ServSafe certification"], "sourcing": ["Sysco / US Foods portal", "Local farm CSA"]},
    },

    # ── 37 GROUNDS ─────────────────────────────────────────────────────────────
    "37-1011.00": {
        "soc_code": "37-1011.00",
        "primary_directive": "Maintain pristine indoor and outdoor environments by directing janitorial and grounds crews, enforcing cleaning standards, and managing supply and equipment budgets.",
        "step_by_step_json": [
            {"step": "Inspect & prioritize",    "detail": "Walk facility; identify high-traffic soiling, safety hazards, and scheduled maintenance items."},
            {"step": "Assign & brief crew",     "detail": "Assign tasks by zone and skill; brief on chemical handling, PPE, and quality standards."},
            {"step": "Quality control",         "detail": "Spot-inspect completed areas against checklist; re-assign deficiencies before sign-off."},
            {"step": "Inventory & ordering",    "detail": "Track supply usage; place orders before par triggers; manage equipment maintenance schedule."},
            {"step": "Incident & safety log",   "detail": "Document spills, slips, or equipment failures; complete OSHA-compliant incident reports."},
        ],
        "toolbox_requirements": {"operations": ["CMMS (e.g., Hippo, Dude Solutions)", "Cleaning schedule app"], "safety": ["SDS binder", "OSHA 300 log"], "equipment": ["Auto-scrubber", "Backpack vacuum"]},
    },

    # ── 39 PERSONAL CARE ───────────────────────────────────────────────────────
    "39-9021.00": {
        "soc_code": "39-9021.00",
        "primary_directive": "Design and deliver results-driven fitness programming that safely progresses clients toward evidence-based health outcomes with exceptional motivation and accountability.",
        "step_by_step_json": [
            {"step": "Health history & screen",  "detail": "Complete PAR-Q+, review medical history, and obtain physician clearance if flagged."},
            {"step": "Fitness assessment",       "detail": "Measure cardiorespiratory fitness, muscular strength, flexibility, and body composition baselines."},
            {"step": "Program design",           "detail": "Build periodized plan using FITT-VP principles; align to SMART goals and exercise preferences."},
            {"step": "Session delivery",         "detail": "Demonstrate, coach form, and apply progressive overload; monitor RPE and adjust intensity."},
            {"step": "Track & progress",         "detail": "Log sessions and metrics; reassess every 4-6 weeks; celebrate milestones and adjust plan."},
        ],
        "toolbox_requirements": {"platforms": ["Trainerize", "TrueCoach", "Mindbody"], "assessment": ["InBody or DEXA scan", "VO2 max protocol"], "certifications": ["NASM CPT", "ACE", "ACSM"]},
    },

    # ── 41 SALES ───────────────────────────────────────────────────────────────
    "41-4011.00": {
        "soc_code": "41-4011.00",
        "primary_directive": "Drive B2B revenue through consultative technical sales — educating buyers, navigating complex buying committees, and closing deals that deliver measurable ROI for customers.",
        "step_by_step_json": [
            {"step": "Prospect & qualify",      "detail": "Build ICP-matched target list; qualify via BANT/MEDDIC; score against quota pipeline model."},
            {"step": "Discovery call",          "detail": "Uncover technical requirements, current-state pain, decision process, and economic buyer."},
            {"step": "Solution demo & proposal","detail": "Tailor demo to discovered pain; build ROI model and written proposal with technical specs."},
            {"step": "Negotiate & close",       "detail": "Handle objections with proof points; navigate legal redlines; secure PO and contract signature."},
            {"step": "Onboard & expand",        "detail": "Coordinate SE and CSM handoff; identify upsell opportunities at 90-day business review."},
        ],
        "toolbox_requirements": {"crm": ["Salesforce", "HubSpot CRM"], "enablement": ["Gong.io", "Outreach", "ZoomInfo"], "pricing": ["CPQ tool", "Deal desk portal"]},
    },
    "41-3021.00": {
        "soc_code": "41-3021.00",
        "primary_directive": "Match clients to optimal insurance solutions through needs analysis, risk assessment, and compliant advisory practice — building a referral-driven book of business.",
        "step_by_step_json": [
            {"step": "Needs analysis",          "detail": "Conduct life-stage interview; quantify income replacement, liability exposure, and coverage gaps."},
            {"step": "Market & quote",          "detail": "Run comparative quotes across carriers; evaluate premium, coverage limits, and exclusions."},
            {"step": "Present & recommend",     "detail": "Illustrate coverage options in plain language; disclose commissions per suitability standards."},
            {"step": "Issue & bind",            "detail": "Complete application, underwriting submissions, and policy delivery with client signature."},
            {"step": "Service & retain",        "detail": "Conduct annual reviews; process claims advocacy; ask for referrals at renewal."},
        ],
        "toolbox_requirements": {"quoting": ["Applied EPIC", "EZLynx", "Vertafore AMS360"], "compliance": ["FINRA suitability checklist", "State DOI CE tracker"], "crm": ["Salesforce FSC", "Redtail CRM"]},
    },

    # ── 43 ADMIN / OFFICE SUPPORT ──────────────────────────────────────────────
    "43-6014.00": {
        "soc_code": "43-6014.00",
        "primary_directive": "Serve as the operational backbone of the office — managing information flow, scheduling, correspondence, and administrative systems with accuracy and discretion.",
        "step_by_step_json": [
            {"step": "Calendar & comms",        "detail": "Manage executive calendar; prioritize inbound comms; draft responses and route to appropriate owner."},
            {"step": "Document management",     "detail": "Create, format, and version-control reports, presentations, and correspondence per org templates."},
            {"step": "Meeting coordination",    "detail": "Book rooms and AV; distribute agendas; capture minutes and distribute action items within 24 hours."},
            {"step": "Process & data entry",    "detail": "Maintain databases, filing systems, and records with 99%+ accuracy; reconcile invoices and expense reports."},
            {"step": "Vendor & supply mgmt",    "detail": "Manage office supply inventory, vendor invoices, and facility service requests."},
        ],
        "toolbox_requirements": {"productivity": ["Microsoft 365 / Google Workspace", "Zoom / Teams"], "admin": ["DocuSign", "Concur Expense", "SharePoint"], "scheduling": ["Calendly", "Outlook scheduling assistant"]},
    },

    # ── 45 FARMING ─────────────────────────────────────────────────────────────
    "45-2041.00": {
        "soc_code": "45-2041.00",
        "primary_directive": "Maintain agricultural product quality through precise grading, sorting, and inspection — minimizing waste, ensuring food safety compliance, and maximizing marketable yield.",
        "step_by_step_json": [
            {"step": "Receive & inspect",       "detail": "Check incoming lots against USDA grade standards; reject non-conforming product; log lot numbers."},
            {"step": "Set up equipment",        "detail": "Calibrate optical sorters, grading tables, and weight sensors to spec before each run."},
            {"step": "Sort & grade",            "detail": "Operate grading line; monitor defect rates; manually inspect edge cases for borderline grades."},
            {"step": "Pack & label",            "detail": "Pack to trade unit spec; apply lot code, weight, and compliance labels per COOL and traceability regs."},
            {"step": "Document & report",       "detail": "Record yield percentages, culls, and equipment downtime; flag food safety concerns immediately."},
        ],
        "toolbox_requirements": {"equipment": ["Optical belt sorter", "Weight-check conveyor", "Grading table"], "compliance": ["USDA grade standards", "FSMA traceability rule"], "erp": ["AgriWebb", "Granular", "FarmLogs"]},
    },

    # ── 47 CONSTRUCTION ────────────────────────────────────────────────────────
    "47-1011.00": {
        "soc_code": "47-1011.00",
        "primary_directive": "Lead construction trade crews to deliver scope on schedule and budget — enforcing safety, quality, and contract compliance from mobilization through close-out.",
        "step_by_step_json": [
            {"step": "Mobilize & plan",         "detail": "Review drawings, specs, and schedule; conduct pre-task planning and site hazard identification."},
            {"step": "Crew management",         "detail": "Assign tasks by trade and skill; coordinate subcontractors; enforce safety PPE and site rules."},
            {"step": "Quality control",         "detail": "Inspect work against drawings and specifications; document NCRs and direct rework immediately."},
            {"step": "Progress reporting",      "detail": "Submit daily field report with installed quantities, labor hours, equipment, and weather impacts."},
            {"step": "Punch & close-out",       "detail": "Walk punch list with owner/GC; obtain inspections and approvals; compile as-built documentation."},
        ],
        "toolbox_requirements": {"project": ["Procore", "Autodesk Construction Cloud", "Bluebeam Revu"], "scheduling": ["Primavera P6", "MS Project"], "safety": ["OSHA 30-hr card", "JHA templates", "Site safety plan"]},
    },
    "47-2061.00": {
        "soc_code": "47-2061.00",
        "primary_directive": "Execute physical construction tasks safely and efficiently — supporting all trades with ground-level labor, material handling, and site preparation to keep the project moving.",
        "step_by_step_json": [
            {"step": "Pre-task safety",         "detail": "Attend toolbox talk; complete JHA; inspect personal PPE and tool/equipment condition."},
            {"step": "Site preparation",        "detail": "Excavate, grade, and compact per stakeout; install erosion controls and form work."},
            {"step": "Material handling",       "detail": "Unload deliveries; stage materials by zone; operate telehandler or forklift per certification."},
            {"step": "Trade support",           "detail": "Mix concrete, cut rebar, set forms, pull wire, or assist any trade per daily foreman direction."},
            {"step": "Clean & secure",          "detail": "Clean debris to dumpster; secure tools and materials; report any site damage or near-misses."},
        ],
        "toolbox_requirements": {"safety": ["OSHA 10-hr card", "Fall protection harness", "Hard hat/Hi-vis vest"], "equipment": ["Excavator", "Plate compactor", "Concrete mixer"], "certs": ["Forklift / telehandler cert", "Confined space awareness"]},
    },

    # ── 49 MAINTENANCE & REPAIR ────────────────────────────────────────────────
    "49-9071.00": {
        "soc_code": "49-9071.00",
        "primary_directive": "Maintain facility systems and equipment at peak reliability — executing preventive maintenance, rapid corrective repair, and continuous improvement to reduce downtime costs.",
        "step_by_step_json": [
            {"step": "Work order intake",       "detail": "Triage work orders in CMMS by criticality; review equipment history and parts availability."},
            {"step": "Preventive maintenance",  "detail": "Execute PM tasks per OEM schedules: lubricate, inspect, clean, calibrate, and replace wear items."},
            {"step": "Corrective repair",       "detail": "Diagnose fault using multimeter, vibration analysis, or visual inspection; repair or replace component."},
            {"step": "Parts & documentation",   "detail": "Record labor, parts used, and findings in CMMS; update equipment records for warranty tracking."},
            {"step": "Root cause & improve",    "detail": "Analyze repeat failures; recommend design changes or PM interval updates to reduce recurrence."},
        ],
        "toolbox_requirements": {"cmms": ["Fiix", "UpKeep", "Maximo"], "diagnostic": ["Fluke multimeter", "Thermal camera", "Vibration analyzer"], "safety": ["LOTO kit", "Arc flash PPE", "Permit-to-work system"]},
    },

    # ── 51 PRODUCTION ──────────────────────────────────────────────────────────
    "51-1011.00": {
        "soc_code": "51-1011.00",
        "primary_directive": "Direct production floor operations to achieve throughput, quality, and safety targets — leading operators, managing material flow, and driving continuous improvement.",
        "step_by_step_json": [
            {"step": "Shift startup",           "detail": "Review prior shift log; verify machine readiness, material availability, and staffing; brief team."},
            {"step": "Production control",      "detail": "Monitor output vs. schedule; adjust run rates, address bottlenecks, and reallocate labor in real time."},
            {"step": "Quality management",      "detail": "Review SPC charts; hold non-conforming material; issue NCR and initiate containment within 1 hour."},
            {"step": "Safety leadership",       "detail": "Conduct safety observation rounds; correct unsafe acts immediately; enforce LOTO and PPE compliance."},
            {"step": "Reporting & improvement", "detail": "Complete shift production report; lead 5-Why or A3 on top downtime events; update OEE dashboard."},
        ],
        "toolbox_requirements": {"mes": ["Plex MES", "SAP PP module", "Ignition SCADA"], "quality": ["SPC software", "GD&T gauging", "ISO 9001 NCR log"], "lean": ["VSM", "5S audit", "Kaizen board"]},
    },

    # ── 53 TRANSPORTATION ──────────────────────────────────────────────────────
    "53-3032.00": {
        "soc_code": "53-3032.00",
        "primary_directive": "Transport freight safely, on time, and in compliance with FMCSA regulations — maintaining vehicle readiness, managing hours of service, and delivering exceptional service.",
        "step_by_step_json": [
            {"step": "Pre-trip inspection",     "detail": "Complete FMCSA-required inspection of tractor and trailer: lights, brakes, tires, coupling, fluids."},
            {"step": "Load & secure",           "detail": "Verify BOL quantities; check load for weight distribution and cargo security per CVSA standards."},
            {"step": "Route & HOS management",  "detail": "Plan route via ELD and GPS; log duty status changes; take required breaks before HOS limits."},
            {"step": "Safe operation",          "detail": "Apply CDL best practices: speed management, space cushion, mirror scans, hazmat placard check."},
            {"step": "Delivery & close",        "detail": "Verify delivery address and receiver identity; obtain signed POD; complete post-trip inspection log."},
        ],
        "toolbox_requirements": {"compliance": ["ELD mandate (Omnitracs/KeepTruckin)", "FMCSA regulations 49 CFR 390-399"], "navigation": ["Rand McNally TND", "Trucker Path app"], "safety": ["DOT physical card", "HAZMAT endorsement (if req'd)"]},
    },

    # ── SAL VAULT IP ───────────────────────────────────────────────────────────
    "15-1299.08": {
        "soc_code": "15-1299.08",
        "primary_directive": "Vault-grade systems engineering: integrate agentic workflows with audit-ready SAL steps and proprietary controls.",
        "step_by_step_json": [
            {"step": "Classify workload", "detail": "Separate vault IP from market-standard modules; tag is_custom paths."},
            {"step": "Model interfaces",  "detail": "Define API, event, and data contracts with versioning."},
            {"step": "Harden execution",  "detail": "Apply least-privilege, secrets, and change windows."},
            {"step": "Validate logic",    "detail": "Cross-check primary directive against registry metadata."},
            {"step": "Publish evidence",  "detail": "Export inspector-ready artifacts for client review."},
        ],
        "toolbox_requirements": {"vault": ["Private registry", "SAL Inspector"], "integration": ["Service mesh or API gateway"]},
    },
}


def _mock_logic_for(soc: str) -> dict[str, Any]:
    title = next((str(r.get("title") or "Role") for r in _MOCK_REGISTRY if r.get("soc_code") == soc), "Role")
    return {
        "soc_code": soc,
        "primary_directive": f"Deliver {title} outcomes using SAL execution: clarify intent, execute controls, and evidence results.",
        "step_by_step_json": list(_MOCK_STEP_TEMPLATE),
        "toolbox_requirements": {"sal": ["Global Registry lookup", "Inspector export"], "collab": ["Issue tracker", "Runbook repo"]},
    }


def _demo_fetch_counts() -> dict[str, int]:
    return {"registry_metadata": 922, "agent_logic": 1095, "guardrails_and_compliance": 88}


def _demo_fetch_registry_roles(title_query: str, *, private_vault_only: bool, limit: int = 50) -> list[dict[str, Any]]:
    q = title_query.strip().lower()
    rows = [dict(r) for r in _MOCK_REGISTRY]
    if private_vault_only:
        rows = [r for r in rows if r.get("is_custom") is True]
    if q:
        rows = [
            r for r in rows
            if q in str(r.get("title") or "").lower()
            or q in str(r.get("description") or "").lower()
            or q in str(r.get("outlook") or "").lower()
        ]
    rows.sort(key=lambda r: str(r.get("title") or ""))
    return rows[:limit]


def _demo_fetch_registry_by_prefix(*, prefix2: str, query: str, private_vault_only: bool, limit: int) -> list[dict[str, Any]]:
    rows = [r for r in _MOCK_REGISTRY if str(r.get("soc_code") or "").startswith(f"{prefix2}-")]
    if private_vault_only:
        rows = [r for r in rows if r.get("is_custom") is True]
    else:
        # Global Registry — never expose proprietary Vault IP roles publicly
        rows = [r for r in rows if not r.get("is_custom")]
    t = query.strip().lower()
    if t:
        rows = [r for r in rows if t in str(r.get("title") or "").lower() or t in str(r.get("outlook") or "").lower()]
    rows.sort(key=lambda r: str(r.get("title") or ""))
    return [dict(r) for r in rows[:limit]]


def _demo_fetch_agent_logic_detail(soc_code: str) -> dict[str, Any] | None:
    if soc_code in _MOCK_LOGIC:
        return dict(_MOCK_LOGIC[soc_code])
    if any(r.get("soc_code") == soc_code for r in _MOCK_REGISTRY):
        return _mock_logic_for(soc_code)
    return None


@st.cache_data(show_spinner=False, ttl=300)
def fetch_registry_by_prefix(supabase_url: str, supabase_key: str, *, prefix2: str, query: str, private_vault_only: bool, limit: int) -> list[dict[str, Any]]:
    client = _make_client(supabase_url, supabase_key)
    q = client.table("registry_metadata").select("soc_code,title,is_custom,outlook").ilike("soc_code", f"{prefix2}-%")
    if private_vault_only:
        q = q.eq("is_custom", True)
    else:
        # Global Registry — never expose proprietary Vault IP roles publicly
        q = q.eq("is_custom", False)
    t = query.strip()
    if t:
        q = q.or_(f"title.ilike.%{t}%,outlook.ilike.%{t}%")
    res = q.order("title").limit(limit).execute()
    return res.data or []


def _openai_client_available() -> bool:
    key = (_secret_get("OPENAI_API_KEY") or os.getenv("OPENAI_API_KEY") or "").strip()
    return bool(key) and not _looks_like_placeholder(key)


def _get_openai_api_key() -> str:
    return (_secret_get("OPENAI_API_KEY") or os.getenv("OPENAI_API_KEY") or "").strip()


def sal_intent_hub_reply(*, client, user_request: str, vault_only: bool, demo_mode: bool = False, top_k: int = 8) -> dict[str, Any]:
    if demo_mode:
        candidates = _demo_fetch_registry_roles(user_request, private_vault_only=vault_only, limit=top_k)
    else:
        if client is None:
            return {"message": "Global Registry offline. Switch to live Supabase keys to enable matching.", "selected_soc": None, "candidates": []}
        candidates = fetch_registry_roles(client, user_request, private_vault_only=vault_only, limit=top_k)

    if not candidates:
        return {"message": "No close SOC match found in the Global Registry. Try a few keywords (domain + task).", "selected_soc": None, "candidates": []}

    selected = candidates[0]
    selected_soc = str(selected.get("soc_code") or "")

    if _openai_client_available():
        try:
            from openai import OpenAI  # type: ignore
            api_key = _get_openai_api_key()
            oa = OpenAI(api_key=api_key) if api_key else OpenAI()
            sys_prompt = (
                "You are the global concierge for SAL: Standard Agent Logic Registry. "
                "You match projects, programs, and outcomes to the best-fit SOC-coded logic standard "
                "in the Global Registry. Be precise, institutional, and authoritative. Output JSON only."
            )
            cand_lines = [{"soc_code": c.get("soc_code"), "title": c.get("title"), "outlook": c.get("outlook"), "description": c.get("description"), "is_custom": c.get("is_custom")} for c in candidates]
            user_msg = {"request": user_request, "candidates": cand_lines, "output_schema": {"selected_soc": "string SOC code from candidates", "rationale": "2-4 sentences", "shortlist": ["up to 3 SOC codes from candidates in order"]}}
            resp = oa.chat.completions.create(
                model=os.getenv("OPENAI_MODEL", "gpt-4o-mini"),
                messages=[{"role": "system", "content": sys_prompt}, {"role": "user", "content": json.dumps(user_msg)}],
                temperature=0.2,
            )
            content = resp.choices[0].message.content or "{}"
            data = json.loads(content)
            selected_soc = str(data.get("selected_soc") or selected_soc)
            rationale = str(data.get("rationale") or "").strip()
            shortlist = data.get("shortlist") or []
            msg = (
                f"**Global Registry match:** `{escape(selected_soc)}` — {escape(rationale)}\n\n"
                f"**Alternates:** {', '.join(f'`{escape(str(x))}`' for x in shortlist[:3])}"
            ).strip()
            return {"message": msg, "selected_soc": selected_soc, "candidates": candidates}
        except Exception:
            pass

    return {
        "message": f"**Global Registry match:** `{escape(selected_soc)}` — {escape(str(selected.get('title') or 'Best-fit SOC logic record'))}",
        "selected_soc": selected_soc,
        "candidates": candidates,
    }


# ── Render helpers ───────────────────────────────────────────────────────────

def _sync_active_role(rows: list[dict[str, Any]]) -> None:
    codes = [str(r.get("soc_code") or "") for r in rows if str(r.get("soc_code") or "")]
    if not codes:
        st.session_state["active_soc"] = None
        return
    current = str(st.session_state.get("active_soc") or "")
    if current not in codes:
        st.session_state["active_soc"] = codes[0]


def _render_sidebar_registry_directory(rows: list[dict[str, Any]], *, button_key_prefix: str = "") -> None:
    valid = [r for r in rows if str(r.get("soc_code") or "")]
    vault_rows   = [r for r in valid if str(r.get("soc_code", "")) == "15-1299.08"]
    regular_rows = [r for r in valid if str(r.get("soc_code", "")) != "15-1299.08"]

    # Vault entry: full-width priority row
    for r in vault_rows:
        soc   = str(r.get("soc_code", ""))
        title = str(r.get("title") or "(untitled)")
        is_active = str(st.session_state.get("active_soc") or "") == soc
        st.markdown(
            '<div class="sal-priority-badge">&#9733; PRIORITY &nbsp;&middot;&nbsp; VAULT IP &nbsp;&middot;&nbsp; 15-1299.08</div>',
            unsafe_allow_html=True,
        )
        if st.button(f"⬛ {title}", key=f"{button_key_prefix}sal_dir_{soc}",
                     use_container_width=True, type="primary" if is_active else "secondary"):
            st.session_state["active_soc"] = soc

    # Regular roles: 3-column grid across full page width
    _COLS = 3
    for i in range(0, len(regular_rows), _COLS):
        chunk = regular_rows[i : i + _COLS]
        cols  = st.columns(_COLS)
        for col, r in zip(cols, chunk):
            soc   = str(r.get("soc_code") or "")
            title = str(r.get("title") or "(untitled)")
            is_active = str(st.session_state.get("active_soc") or "") == soc
            with col:
                if st.button(title, key=f"{button_key_prefix}sal_dir_{soc}",
                             use_container_width=True,
                             type="primary" if is_active else "secondary"):
                    st.session_state["active_soc"] = soc


def _render_file_tree_panel(*, supabase_url: str, supabase_key: str, query: str, vault_only: bool, demo_mode: bool, button_key_prefix: str = "") -> None:
    st.markdown("##### O\u2217NET major groups")
    st.caption("Collapsible tree · SOC prefix folders · select a role to load the logic specification")

    for prefix2, label in SOC_MAJOR_GROUPS.items():
        expanded = st.session_state.get("active_prefix") == prefix2
        with st.expander(f"[{prefix2}] {label}", expanded=expanded):
            if st.button("Open folder", key=f"{button_key_prefix}open_{prefix2}", use_container_width=True):
                st.session_state["active_prefix"] = prefix2

            rows = (
                _demo_fetch_registry_by_prefix(prefix2=prefix2, query=query, private_vault_only=vault_only, limit=60)
                if demo_mode
                else fetch_registry_by_prefix(supabase_url, supabase_key, prefix2=prefix2, query=query, private_vault_only=vault_only, limit=60)
            )
            if not rows:
                st.caption("No matches in this folder.")
            else:
                if prefix2 == st.session_state.get("active_prefix"):
                    _sync_active_role(rows)
                _render_sidebar_registry_directory(rows, button_key_prefix=button_key_prefix)


def _steps_to_html(steps: list[Any]) -> str:
    if not steps:
        return "<p><em>No steps recorded.</em></p>"
    parts: list[str] = []
    for i, item in enumerate(steps, start=1):
        if isinstance(item, dict):
            label = item.get("step") or item.get("title") or item.get("name") or f"Step {i}"
            body = item.get("detail") or item.get("description") or item.get("text")
            inner = f"<strong>{escape(str(label))}</strong>"
            if body is not None:
                inner += f"<br><span style='margin-left:0.35rem;display:inline-block'>{escape(str(body))}</span>"
            parts.append(f"<li>{inner}</li>")
        elif isinstance(item, (list, tuple)) and len(item) == 2:
            parts.append(f"<li><strong>{escape(str(item[0]))}</strong><br><span style='margin-left:0.35rem;display:inline-block'>{escape(str(item[1]))}</span></li>")
        else:
            parts.append(f"<li>{escape(str(item))}</li>")
    return f"<ol class='sal-steps'>{''.join(parts)}</ol>"


def _render_logic_spec_html_card(*, selected_soc: str, chosen_row: dict[str, Any] | None, logic: dict[str, Any] | None, browse_mode: bool) -> None:
    display_title = str((chosen_row or {}).get("title") or "Select a role from the Federal Ledger")
    is_custom  = chosen_row is not None and chosen_row.get("is_custom") is True
    is_verified = chosen_row is not None  # every selected mock row is VERIFIED
    doc_class  = "sal-doc sal-gold-frame" if is_custom else "sal-doc"

    # ── Security Clearance badge (green glow when VERIFIED) ─────────────────
    if is_verified:
        clearance_badge = (
            "<div class='sal-clearance-badge'>"
            "<span class='sal-clearance-dot'></span>"
            "SECURITY CLEARANCE: ACTIVE"
            "</div>"
        )
    else:
        clearance_badge = (
            "<div class='sal-clearance-badge sal-clearance-inactive'>"
            "<span class='sal-clearance-dot'></span>"
            "AWAITING VERIFICATION"
            "</div>"
        )

    outlook = str((chosen_row or {}).get("outlook") or "").strip() if chosen_row else ""
    outlook_html = f"<div class='sal-outlook'>{escape(outlook)}</div>" if outlook else ""
    desc = str((chosen_row or {}).get("description") or "").strip() if chosen_row else ""
    mv   = chosen_row.get("market_value") if chosen_row else None
    mv_html = (
        f"<p style='margin:0.35rem 0 0;font-family:\"Courier New\",monospace;font-size:0.8rem'>"
        f"<strong>Market signal:</strong> {escape(str(mv))}</p>"
        if mv is not None else ""
    )

    if not chosen_row:
        onet_inner = (
            "<p style='color:#64748b;margin:0'>"
            "<em>Select a row in the Federal Ledger or SOC Folder Tree to load O\u2217NET context.</em>"
            "</p>"
        )
    elif not outlook and not desc and mv is None:
        onet_inner = "<p style='color:#64748b;margin:0'><em>No O\u2217NET outlook on file for this SOC.</em></p>"
    else:
        desc_html = (
            f"<p style='color:#475569;font-size:0.86rem;line-height:1.55;margin:0.5rem 0 0'>"
            f"{escape(desc)}</p>"
            if desc else ""
        )
        onet_inner = f"{outlook_html}{desc_html}{mv_html}".strip()

    onet_block = (
        f"<div class='sal-section sal-onet'>"
        f"<h5>O\u2217NET outlook &amp; occupation context</h5>{onet_inner}</div>"
    )

    pd = (logic or {}).get("primary_directive") if logic else None
    pd_html = (
        f"<div class='sal-section'><h5>Primary Directive</h5>"
        f"<p style='line-height:1.55;margin:0;font-size:0.86rem'>{escape(str(pd))}</p></div>"
        if pd else
        "<div class='sal-section'><h5>Primary Directive</h5>"
        "<p style='color:#64748b'><em>No directive on file for this SOC.</em></p></div>"
    )

    steps = _normalize_steps((logic or {}).get("step_by_step_json")) if logic else []
    steps_html = (
        f"<div class='sal-section'><h5>Execution Steps (SAL Protocol)</h5>{_steps_to_html(steps)}</div>"
    )

    tb = (logic or {}).get("toolbox_requirements") if logic else None
    _cap_style = (
        "font-family:'Courier New','Lucida Console',monospace;"
        "font-size:0.74rem;"
        "background:#071540;"
        "color:#93c5fd;"
        "border:1px solid #1d4ed8;"
        "border-left:4px solid #f59e0b;"
        "padding:0.75rem 0.85rem;"
        "border-radius:3px;"
        "line-height:1.55;"
        "margin:0.25rem 0 0;"
        "white-space:pre-wrap;"
        "word-break:break-word;"
        "display:block;"
        "overflow-x:auto;"
    )
    _cap_label = (
        "font-family:'Courier New',monospace;font-size:0.65rem;font-weight:700;"
        "letter-spacing:0.1em;color:#1d4ed8;text-transform:uppercase;"
        "border-bottom:2px double #1d4ed8;padding-bottom:0.25rem;margin-bottom:0.4rem;"
        "display:block;"
    )
    tb_html = ""
    if tb is not None and tb != "":
        # ── Render as Toolbox Manifest — grouped capability pills ──────────────
        def _tb_to_manifest(tb_data) -> str:
            """Convert toolbox_requirements dict/list into a pill-based manifest."""
            cat_rows = ""
            if isinstance(tb_data, dict):
                items = tb_data.items()
            elif isinstance(tb_data, list):
                items = [("tools", tb_data)]
            else:
                items = [("capabilities", [str(tb_data)])]
            for cat, vals in items:
                cat_label = escape(str(cat).replace("_", " ").upper())
                if isinstance(vals, list):
                    pills = "".join(
                        f"<span class='sal-toolbox-pill'>{escape(str(v))}</span>"
                        for v in vals
                    )
                else:
                    pills = f"<span class='sal-toolbox-pill'>{escape(str(vals))}</span>"
                cat_rows += (
                    f"<div class='sal-toolbox-category'>"
                    f"  <span class='sal-toolbox-cat-label'>\u25c8\u00a0{cat_label}</span>"
                    f"  <div class='sal-toolbox-pills'>{pills}</div>"
                    f"</div>"
                )
            return cat_rows

        tb_html = (
            f"<div class='sal-section'>"
            f"<span style='{_cap_label}'>TOOLBOX\u00a0MANIFEST\u00a0\u25c6\u00a0REQUIRED\u00a0CAPABILITIES</span>"
            f"<div class='sal-toolbox-manifest'>{_tb_to_manifest(tb)}</div>"
            f"</div>"
        )

    browse_note = (
        "<p style='font-family:\"Courier New\",monospace;font-size:0.72rem;color:#64748b;margin:0.6rem 0 0'>"
        "<em>SAL Mock Vault — sample logic. Add live Supabase keys for production mode.</em></p>"
        if browse_mode else ""
    )
    rendered_ts = escape(datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC"))

    _seal_stamp_uri = _great_seal_data_uri()
    st.markdown(f"""
<div class="{doc_class}">
  <div class="sal-watermark-layer" aria-hidden="true"><span>SAL: OFFICIAL SOURCE OF TRUTH</span></div>
  <div class="sal-doc-content">
    {clearance_badge}
    <img src="{_seal_stamp_uri}" class="sal-notary-seal" alt="Official Seal of SAL"/>
    <h4 style="margin-top:0;padding-right:7.5rem;padding-top:0.1rem;color:#0b2a6f">Logic Specification</h4>
    <p style="margin:0.2rem 0 0.4rem"><strong>{escape(display_title)}</strong><br>
    <code style="font-size:0.9rem">{escape(selected_soc or "\u2014")}</code></p>
    {onet_block}
    {pd_html}
    {steps_html}
    {tb_html}
    <p style="font-size:0.78rem;color:#64748b;margin:0.8rem 0 0">Rendered: {rendered_ts}</p>
    {browse_note}
  </div>
</div>
""", unsafe_allow_html=True)


# ── CSS ──────────────────────────────────────────────────────────────────────

def _inject_studio_styles() -> None:
    wm_light  = _wm_bg_url(0.055)
    wm_medium = _wm_bg_url(0.075)
    wm_dense  = _wm_bg_url(0.095)
    stamp_l   = _stamp_bg_url(0.13)
    stamp_m   = _stamp_bg_url(0.14)
    stamp_r   = _stamp_bg_url(0.15)
    truth_overlay = _truth_diagonal_stamp_url()
    st.markdown(f"""
<style>
  /* ── Full-width panel backgrounds (no columns — stacked layout) ── */
  /* Authority panel: seals + search + tree */
  div[data-testid="stVerticalBlock"]:has(div.sal-col-authority-anchor) {{
    position: relative;
    background-color: #fafbff;
    background-image: url("{stamp_m}"), url("{wm_medium}");
    background-size: 44% auto, auto;
    background-repeat: no-repeat, repeat;
    background-position: center 18%, 0 0;
    border: 1.5px solid #ccd4ef;
    border-radius: 6px;
    padding: 0.75rem 1rem;
    margin-bottom: 0.75rem;
    box-shadow: 0 1px 4px rgba(0,0,0,0.08), 0 6px 18px rgba(29,78,216,0.06), inset 0 1px 0 rgba(255,255,255,0.9);
  }}
  /* Diagonal truth stamp behind the seals area */
  div[data-testid="stVerticalBlock"]:has(div.sal-col-authority-anchor) .sal-authority-stamp-layer {{
    position: absolute;
    left: 0; right: 0; top: 2rem; bottom: 60%;
    z-index: 0; pointer-events: none;
    background-image: url("{truth_overlay}");
    background-size: 55% auto;
    background-repeat: no-repeat;
    background-position: center 40%;
  }}
</style>
""", unsafe_allow_html=True)
    st.markdown("""
<style>
  /* ── Layout ── */
  div[data-testid="stVerticalBlock"] > div:has(> iframe) { max-width: 100%; }

  /* ── Federal document card hardening ── */
  .sal-doc {
    border-radius: 4px !important;
    border: 1.5px solid #b8c6e0 !important;
    box-shadow: 0 1px 2px rgba(0,0,0,0.14), 0 3px 8px rgba(11,42,111,0.07),
                inset 0 0 0 1px rgba(255,255,255,0.6) !important;
  }

  /* ── SOC tree density ── */
  details { margin-bottom: 0.05rem !important; }
  details summary {
    padding: 0.18rem 0.55rem !important;
    font-size: 0.67rem !important;
    min-height: 1.55rem !important;
  }
  details > div { padding: 0.2rem 0.35rem !important; }

  /* ── Tighter sector tiles ── */
  .sal-sector-tile { padding: 0.45rem 0.4rem !important; margin-bottom: 0.25rem !important; border-radius: 4px !important; }
  .sal-sector-tile-icon { font-size: 1.35rem !important; }

  /* ── Denser table ── */
  .sal-lvl-table td { padding: 0.16rem 0.32rem !important; }
  .sal-lvl-table th { padding: 0.18rem 0.32rem !important; font-size: 0.62rem !important; }

  /* ── Proprietary gold frame ── */
  .sal-gold-frame {
    border: 2px solid #c9a227 !important;
    border-radius: 4px !important;
    padding: 0 !important;
    margin-bottom: 0.65rem !important;
    background: linear-gradient(145deg, #fffef8 0%, #ffffff 55%, #fffdf5 100%) !important;
    box-shadow: 0 2px 14px rgba(201,162,39,0.14) !important;
  }

  /* ── Sidebar compact buttons ── */
  [data-testid="stSidebar"] .stButton > button {
    font-size: 0.7rem !important;
    line-height: 1.12 !important;
    padding: 0.14rem 0.4rem !important;
    min-height: 1.45rem !important;
    white-space: normal !important;
    text-align: left !important;
  }
  [data-testid="stSidebar"] div[data-testid="stColumn"] { gap: 0.15rem !important; }
  [data-testid="stSidebar"] .stButton { margin-bottom: 0.08rem !important; }
  .sal-metric-wrap .stMetric { padding-top: 0.25rem; }

  /* ── Logic spec document card ── */
  .sal-doc {
    border: 1px solid #d7dbe8;
    border-radius: 14px;
    background: #ffffff;
    padding: 0;
    position: relative;
    box-shadow: 0 12px 30px rgba(16,24,40,0.08);
    box-sizing: border-box;
    overflow: hidden;
    min-height: 220px;
  }
  .sal-watermark-layer {
    position: absolute;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    pointer-events: none;
    z-index: 0;
    border-radius: 14px;
  }
  .sal-watermark-layer span {
    font-size: clamp(1.35rem,4.2vw,2.35rem);
    font-weight: 900;
    color: rgba(11,42,111,0.065);
    transform: rotate(-26deg);
    white-space: nowrap;
    letter-spacing: 0.05em;
    user-select: none;
  }
  .sal-doc-content {
    position: relative;
    z-index: 1;
    padding: 1.2rem 1.15rem 1.05rem 1.15rem;
  }
  .sal-doc h3, .sal-doc h4, .sal-doc h5 { color: #0b2a6f; }

  /* ── SVG Official SAL Seal (top-right of logic card) ── */
  .sal-notary-seal {
    position: absolute;
    top: 6px;
    right: 10px;
    width: 110px;
    height: 110px;
    z-index: 3;
    pointer-events: none;
    transform: rotate(-8deg);
    opacity: 0.88;
    mix-blend-mode: multiply;
    filter: drop-shadow(0 3px 10px rgba(29,78,216,0.35));
    border-radius: 50%;
  }

  /* ── Outlook pill ── */
  .sal-outlook {
    display: inline-block;
    border: 1px solid #b9c6ff;
    background: #eef2ff;
    color: #0b2a6f;
    padding: 0.18rem 0.5rem;
    border-radius: 999px;
    font-size: 0.78rem;
    margin-top: 0.25rem;
  }

  /* ── Logic steps ── */
  .sal-doc .sal-steps { margin: 0.5rem 0 0 1.1rem; padding: 0; color: #0b1220; }
  .sal-doc .sal-steps li { margin: 0.35rem 0; line-height: 1.35; }
  .sal-doc .sal-section { margin-top: 1rem; padding-top: 0.75rem; border-top: 1px solid #e8ecf4; }
  .sal-doc .sal-section:first-of-type { border-top: none; padding-top: 0; margin-top: 0.5rem; }

  /* ── Intelligence Hub ── */
  .sal-hub-wrap {
    max-width: 720px;
    margin: 0 auto 0.5rem auto;
    text-align: center;
  }
  .sal-hub-wrap h2 {
    color: #0b2a6f;
    font-weight: 800;
    letter-spacing: -0.02em;
    margin-bottom: 0.25rem;
  }
  .sal-hub-wrap .sal-hub-sub {
    color: #475569;
    font-size: 0.95rem;
    margin-bottom: 1rem;
    line-height: 1.45;
  }
  .sal-hub-form input,
  .sal-hub-form [data-baseweb="input"] input {
    font-size: 1.05rem !important;
    padding: 0.65rem 0.85rem !important;
  }

  /* ── Section labels ── */
  .sal-stack-label {
    font-size: 0.72rem;
    font-weight: 700;
    letter-spacing: 0.14em;
    color: #1d4ed8;
    margin: 0 0 0.35rem 0;
    text-transform: uppercase;
  }

  /* ── Bureau compact buttons ── */
  div[data-testid="stColumn"]:has(div.sal-bureau-anchor) .stButton > button {
    font-size: 0.7rem !important;
    line-height: 1.12 !important;
    padding: 0.14rem 0.4rem !important;
    min-height: 1.45rem !important;
    white-space: normal !important;
    text-align: left !important;
  }
  div[data-testid="stColumn"]:has(div.sal-bureau-anchor) .stButton { margin-bottom: 0.08rem !important; }

  /* ══════════════════════════════════════════════════════════════════════════
     ENGINE COLUMN — Digital Filing Cabinet (SOC Ledger)
     ══════════════════════════════════════════════════════════════════════════ */

  /* Filing cabinet manifest header */
  .sal-filing-hdr {
    display: flex; justify-content: space-between; align-items: center;
    background: #071540; color: #e2e8f0;
    padding: 0.22rem 0.5rem;
    font-family: 'Courier New','Lucida Console',monospace;
    font-size: 0.58rem; font-weight: 700; letter-spacing: 0.1em;
    margin-bottom: 0.2rem; border-radius: 2px;
    border-left: 3px solid #1d4ed8;
  }
  .sal-filing-hdr-code  { color: #93c5fd; font-size: 0.56rem; }
  .sal-filing-hdr-count { color: #60a5fa; opacity: 0.85; }

  /* Expander folders — ledger drawer rows */
  div[data-testid="stColumn"]:has(div.sal-col-engine-anchor) details {
    border-radius: 0 !important;
    border: none !important;
    border-top: 1px solid rgba(29,78,216,0.1) !important;
    margin: 0 0 0 0 !important;
    background: transparent !important;
    box-shadow: none !important;
  }
  div[data-testid="stColumn"]:has(div.sal-col-engine-anchor) details summary {
    font-family: 'Courier New','Lucida Console',monospace !important;
    font-size: 0.63rem !important; font-weight: 700 !important;
    color: #0b2a6f !important;
    background: rgba(11,42,111,0.055) !important;
    border-radius: 0 !important;
    padding: 0.16rem 0.45rem !important; min-height: 1.35rem !important;
    letter-spacing: 0.05em !important;
    border-left: 3px solid rgba(29,78,216,0.22) !important;
  }
  div[data-testid="stColumn"]:has(div.sal-col-engine-anchor) details[open] > summary {
    background: rgba(11,42,111,0.11) !important;
    border-left-color: #1d4ed8 !important;
  }

  /* Vertical hierarchy guide line inside open folder */
  div[data-testid="stColumn"]:has(div.sal-col-engine-anchor) details > div > div {
    border-left: 1px dashed rgba(29,78,216,0.22) !important;
    margin-left: 0.75rem !important;
    padding-left: 0.35rem !important;
    padding-top: 0 !important; padding-bottom: 0 !important;
  }

  /* Role buttons — ledger record rows */
  div[data-testid="stColumn"]:has(div.sal-col-engine-anchor) .stButton > button {
    font-family: 'Courier New','Lucida Console',monospace !important;
    font-size: 0.59rem !important; line-height: 1.15 !important;
    text-align: left !important;
    background: transparent !important;
    border: none !important;
    border-bottom: 1px solid rgba(29,78,216,0.07) !important;
    border-radius: 0 !important;
    padding: 0.1rem 0.3rem 0.1rem 0.45rem !important;
    min-height: 1.25rem !important;
    color: #1e3a5f !important; width: 100% !important; margin: 0 !important;
    white-space: nowrap !important; overflow: hidden !important;
    text-overflow: ellipsis !important;
  }
  div[data-testid="stColumn"]:has(div.sal-col-engine-anchor) .stButton > button:hover {
    background: rgba(29,78,216,0.07) !important;
    border-left: 2px solid #3b82f6 !important;
    color: #0b2a6f !important;
    padding-left: 0.28rem !important;
  }
  div[data-testid="stColumn"]:has(div.sal-col-engine-anchor) .stButton > button[kind="primary"] {
    background: rgba(11,42,111,0.1) !important;
    border-left: 3px solid #1d4ed8 !important;
    color: #0b2a6f !important; font-weight: 700 !important;
    padding-left: 0.25rem !important;
  }

  /* Filter input — monospaced ledger field */
  div[data-testid="stColumn"]:has(div.sal-col-engine-anchor) [data-testid="stTextInput"] input {
    font-family: 'Courier New',monospace !important;
    font-size: 0.66rem !important;
    border-radius: 2px !important; border-color: #b0c0e8 !important;
    padding: 0.18rem 0.4rem !important;
    background: rgba(248,250,255,0.95) !important;
    letter-spacing: 0.03em !important;
  }

  /* Suppress default tree caption — replaced by filing header */
  div[data-testid="stColumn"]:has(div.sal-col-engine-anchor) .stCaption { display: none !important; }

  /* ── Sovereign document header ──────────────────────────────────────────── */
  .sal-header-container {
    max-width: 100%;
    overflow: hidden;
    box-sizing: border-box;
  }
  .sal-sovereign-header {
    position: relative;
    text-align: center;
    padding: 0.45rem 0 0;
    border-top: 3px solid #1d4ed8;
    border-bottom: 3px double #1d4ed8;
    margin-bottom: 0.85rem;
    background: linear-gradient(180deg, rgba(11,42,111,0.04) 0%, transparent 55%);
  }
  .sal-serial {
    position: absolute; top: 0.3rem; right: 0.75rem;
    font-family: 'Courier New','Lucida Console',monospace;
    font-size: 0.5rem; font-weight: 700;
    color: #94a3b8; letter-spacing: 0.1em;
    user-select: none;
  }
  /* Serial: top-right of the 450px emblem box (same box as the seal PNG) */
  .sal-seal-emblem-wrap .sal-serial-pin {
    position: absolute;
    top: 0;
    right: 0;
    z-index: 4;
    font-family: 'Courier New', 'Lucida Console', monospace;
    font-size: 0.52rem;
    font-weight: 800;
    color: #0b2a6f;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    user-select: none;
    background: rgba(248,250,255,0.92);
    border: 1px solid #93c5fd;
    padding: 0.12rem 0.38rem;
    border-radius: 2px;
  }
  /* Emblem = image-only header art (all lettering is inside SAL_GREAT_SEAL.png pixels) */
  .sal-seal-emblem-wrap {
    position: relative;
    width: min(450px, 100%);
    max-width: 450px;
    margin: 0 auto;
    box-sizing: border-box;
  }
  .sal-eagle-wrap {
    display: flex; justify-content: center; align-items: flex-start;
    margin: 0 auto;
    overflow: visible;
    max-width: 100%;
  }
  .sal-great-seal-img {
    display: block;
    margin: 0 auto;
    width: 100%;
    max-width: 450px;
    height: auto;
    object-fit: contain;
    image-rendering: -webkit-optimize-contrast;
    image-rendering: crisp-edges;
  }
  .sal-eagle-wrap svg {
    max-width: 100%;
    height: auto;
  }
  .sal-ribbon-outer {
    position: relative;
    border: 2.5px solid #1d4ed8;
    border-radius: 1px;
    margin: 0 0.4rem 0.5rem;
    padding: 2.5px;
  }
  .sal-ribbon-inner {
    border: 1px solid #93c5fd;
    padding: 0.3rem 1rem;
    background: rgba(240,246,255,0.65);
  }
  .sal-ribbon-title {
    font-size: clamp(0.82rem, 1.65vw, 1.08rem);
    font-weight: 900; letter-spacing: 0.2em;
    color: #0b2a6f; text-transform: uppercase; line-height: 1.15;
  }
  .sal-ribbon-serial {
    font-family: 'Courier New', 'Lucida Console', monospace;
    font-size: 0.52rem; font-weight: 800;
    color: #0b2a6f; letter-spacing: 0.18em;
    text-transform: uppercase; margin: 0.12rem 0 0.06rem;
  }
  .sal-ribbon-sub {
    font-size: 0.57rem; font-weight: 700;
    color: #1d4ed8; letter-spacing: 0.14em;
    text-transform: uppercase; margin-top: 0.08rem;
  }
  /* Legacy plain header (kept as fallback) */
  .sal-main-header {
    text-align: center; font-size: clamp(0.78rem, 1.6vw, 1.05rem);
    font-weight: 900; letter-spacing: 0.22em; color: #0b2a6f;
    text-transform: uppercase; padding: 0.6rem 0 0.8rem;
    border-bottom: 2px solid #1d4ed8; margin-bottom: 1rem;
  }
  /* Center column section labels */
  .sal-center-section-label {
    font-size: 0.58rem; font-weight: 700; color: #0b2a6f;
    text-align: center; letter-spacing: 0.1em; text-transform: uppercase;
    margin: 0.5rem 0 0.25rem;
  }
  /* ── Three-Column Vertical Hub ──────────────────────────────────────────── */

  /* Column wrappers */
  .sal-col-wrap {
    position: relative;
    border-radius: 12px;
    padding: 1rem 0.8rem 1.2rem;
    min-height: 620px;
    overflow: hidden;
    box-sizing: border-box;
  }
  .sal-col-bureau    { background: linear-gradient(160deg,#f8faff 0%,#eef2ff 100%); border: 1px solid #c7d7fd; }
  .sal-col-authority { background: #ffffff; border: 1px solid #dde3f0; box-shadow: 0 4px 24px rgba(29,78,216,0.07); }
  .sal-col-engine    { background: linear-gradient(160deg,#f0f4ff 0%,#f8faff 100%); border: 1px solid #c7d7fd; }

  /* Watermark SVG inside each column (set as inline background) */
  .sal-col-content { position: relative; z-index: 1; }

  /* Stamp zone sits behind Sectors / Seals; stack Streamlit blocks above it */
  div[data-testid="stColumn"]:has(div.sal-col-authority-anchor) [data-testid="stVerticalBlock"] > div {
    position: relative;
    z-index: 1;
  }
  /* Full-width lock: sector + notary rows span entire center column */
  div[data-testid="stColumn"]:has(div.sal-col-authority-anchor) div[data-testid="stHorizontalBlock"] {
    width: 100% !important;
    max-width: 100% !important;
    min-width: 0 !important;
  }
  div[data-testid="stColumn"]:has(div.sal-col-authority-anchor) div[data-testid="column"] {
    flex: 1 1 0% !important;
    min-width: 0 !important;
  }

  /* Sector tiles (legacy, kept for compatibility) */
  .sal-sector-tile {
    border: 1px solid #c7d7fd;
    border-radius: 4px;
    padding: 0.4rem 0.35rem;
    background: rgba(255,255,255,0.55);
    text-align: center;
    margin-bottom: 0.3rem;
  }
  .sal-sector-tile-icon  { font-size: 1.2rem; display: block; margin-bottom: 0.1rem; }
  .sal-sector-tile-label { font-size: 0.6rem; font-weight: 800; color: #0b2a6f; text-transform: uppercase; letter-spacing: 0.08em; }
  .sal-sector-tile-desc  { font-size: 0.55rem; color: #475569; margin-top: 0.12rem; line-height: 1.25; }

  /* Sector quick-access divider in center column */
  .sal-sector-divider {
    display: flex; align-items: center; gap: 0.5rem;
    margin: 0.5rem 0 0.3rem;
  }
  .sal-sector-divider::before, .sal-sector-divider::after {
    content: ""; flex: 1; height: 1px; background: #b8caf8;
  }
  .sal-sector-divider span {
    font-family: 'Courier New', monospace;
    font-size: 0.52rem; font-weight: 800;
    color: #1d4ed8; letter-spacing: 0.12em;
    white-space: nowrap;
  }

  /* PRIORITY badge — vault IP entry in folder tree */
  .sal-priority-badge {
    font-family: 'Courier New', 'Lucida Console', monospace;
    font-size: 0.52rem; font-weight: 900;
    color: #ffffff;
    background: linear-gradient(90deg, #0b2a6f 0%, #1d4ed8 60%, #7c3aed 100%);
    border-left: 3px solid #f59e0b;
    padding: 0.1rem 0.4rem;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    margin-bottom: 0.05rem;
    display: block;
  }

  /* Authority center */
  .sal-authority-logo    { text-align: center; padding: 0.25rem 0 0.6rem; }
  .sal-authority-brand   { font-size: 1.7rem; font-weight: 900; color: #0b2a6f; text-align: center; letter-spacing: -0.01em; }
  .sal-authority-sub     { font-size: 0.68rem; font-weight: 800; color: #1d4ed8; letter-spacing: 0.14em; text-align: center; text-transform: uppercase; margin-top: 0.15rem; }

  /* Search anchor box */
  .sal-search-anchor {
    border: none;
    border-top: 2px solid #dde4f4;
    border-radius: 0;
    padding: 0.65rem 0 0.25rem;
    text-align: center;
    background: transparent;
    margin: 0.45rem 0 0.25rem;
  }
  .sal-search-anchor p { font-size: 0.72rem; font-weight: 900; color: #1d4ed8; letter-spacing: 0.14em; margin: 0 0 0.35rem; line-height: 1.3; font-family: 'Courier New', monospace; }

  /* Directory rule — replaces heavy navy filing cabinet header */
  .sal-dir-rule {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-top: 1.5px solid #b8caf8;
    border-bottom: 1px solid #dde4f4;
    padding: 0.3rem 0.1rem;
    margin: 0.5rem 0 0.3rem;
    font-family: 'Courier New', monospace;
    font-size: 0.62rem;
    font-weight: 800;
    color: #1d4ed8;
    letter-spacing: 0.1em;
    background: linear-gradient(90deg, rgba(219,234,254,0.5) 0%, transparent 100%);
  }
  .sal-dir-count {
    color: #64748b;
    font-weight: 600;
    font-size: 0.58rem;
    letter-spacing: 0.06em;
  }

  /* Latest Verified Logic table */
  .sal-lvl-table { width: 100%; border-collapse: collapse; font-size: 0.68rem; margin-top: 0.35rem; }
  .sal-lvl-table th { background: #0b2a6f; color: #ffffff; padding: 0.28rem 0.4rem; text-align: left; font-weight: 700; font-size: 0.65rem; }
  .sal-lvl-table td { padding: 0.22rem 0.4rem; border-bottom: 1px solid #e8ecf4; color: #1e293b; }
  .sal-lvl-table tr:nth-child(even) td { background: #f8faff; }
  .sal-verified-badge { background: #1d4ed8; color: #fff; font-size: 0.56rem; font-weight: 800; padding: 0.06rem 0.28rem; border-radius: 999px; letter-spacing: 0.06em; }

  /* Chat widget */
  .sal-chat-widget { border: 2px solid #1d4ed8; border-radius: 12px; background: #ffffff; padding: 0.6rem 0.7rem; margin-top: 1rem; box-shadow: 0 4px 14px rgba(29,78,216,0.12); }
  .sal-chat-title  { font-size: 0.72rem; font-weight: 800; color: #0b2a6f; margin-bottom: 0.3rem; }
  .sal-chat-prompt { font-size: 0.63rem; color: #64748b; margin-bottom: 0.35rem; }

  /* Bright Outlook chart */
  .sal-bright-outlook-wrap  { margin-top: 0.9rem; padding-top: 0.7rem; border-top: 1px solid #e8ecf4; }
  .sal-bright-outlook-title { font-size: 0.68rem; font-weight: 800; color: #0b2a6f; text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 0.4rem; }

  /* Footer */
  .sal-footer { text-align: center; padding: 1rem 0 0.6rem; font-size: 0.72rem; color: #64748b; border-top: 1px solid #e8ecf4; margin-top: 1.2rem; }
  .sal-footer-metric { font-size: 1.15rem; font-weight: 900; color: #0b2a6f; display: block; margin-bottom: 0.25rem; }

  /* Mobile: stack columns */
  @media (max-width: 768px) {
    div[data-testid="stColumn"] { width: 100% !important; flex: 100% !important; max-width: 100% !important; }
    .sal-col-wrap { min-height: unset; margin-bottom: 1rem; }
  }

  /* ══════════════════════════════════════════════════════════════════════════
     PHASE 4: SOVEREIGN INSTITUTIONAL REFINEMENTS
     ══════════════════════════════════════════════════════════════════════════ */

  /* ── HEADER: seal image sizing + blueprint watermark ── */
  .sal-sovereign-header {
    position: relative;
    text-align: center;
    padding: 1.2rem 0 0.6rem;
    border-top: 3px solid #1d4ed8;
    border-bottom: 3px double #1d4ed8;
    margin-bottom: 0.6rem;
    overflow: visible;
    background:
      url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='60' height='60'%3E%3Cpath d='M60 0L0 0 0 60' fill='none' stroke='%231d4ed8' stroke-width='0.4' opacity='0.07'/%3E%3Ccircle cx='0' cy='0' r='1.5' fill='%231d4ed8' opacity='0.1'/%3E%3C/svg%3E") repeat,
      linear-gradient(180deg,rgba(219,234,254,0.55) 0%,rgba(239,246,255,0.3) 60%,rgba(255,255,255,0) 100%);
  }
  .sal-sovereign-header::before {
    content: 'STANDARD AGENT LOGIC  ·  GLOBAL DNS FOR DIGITAL LABOR  ·  FEDERAL AUTHORIZED REGISTRY  ·  O\2217NET SOC COMPLIANT';
    position: absolute;
    bottom: 0.3rem; left: 0; right: 0;
    font-family: 'Courier New', monospace;
    font-size: 0.48rem;
    letter-spacing: 0.18em;
    color: #1d4ed8;
    opacity: 0.18;
    text-align: center;
    pointer-events: none;
    user-select: none;
  }
  .sal-sovereign-header::after {
    content: '';
    position: absolute;
    inset: 0;
    background: radial-gradient(ellipse 60% 50% at 50% 50%, rgba(29,78,216,0.05) 0%, transparent 70%);
    pointer-events: none;
  }
  .sal-great-seal-img {
    display: block !important;
    margin: 0 auto !important;
    width: auto !important;
    max-width: 400px !important;
    max-height: 360px !important;
    height: auto !important;
    object-fit: contain !important;
    position: relative;
    z-index: 1;
    filter: drop-shadow(0 4px 24px rgba(29,78,216,0.18));
    mix-blend-mode: multiply;
  }
  .sal-serial {
    position: absolute; top: 0.35rem; right: 0.9rem;
    font-family: 'Courier New','Lucida Console',monospace;
    font-size: 0.52rem; font-weight: 800;
    color: #0b2a6f; letter-spacing: 0.14em;
    text-transform: uppercase;
    background: rgba(240,246,255,0.92);
    border: 1px solid #93c5fd;
    padding: 0.1rem 0.36rem;
    border-radius: 2px;
    user-select: none;
  }
  .sal-ribbon-outer {
    border: 2.5px solid #1d4ed8;
    border-radius: 1px;
    margin: 0 0.5rem 0.55rem;
    padding: 2.5px;
  }
  .sal-ribbon-inner {
    border: 1px solid #93c5fd;
    padding: 0.32rem 1rem;
    background: rgba(240,246,255,0.7);
  }
  .sal-ribbon-title {
    font-family: 'Arial','Helvetica Neue',sans-serif;
    font-size: clamp(0.78rem, 1.6vw, 1.05rem);
    font-weight: 900; letter-spacing: 0.22em;
    color: #0b2a6f; text-transform: uppercase; line-height: 1.2;
  }
  .sal-ribbon-sub {
    font-family: 'Arial','Helvetica Neue',sans-serif;
    font-size: 0.56rem; font-weight: 700;
    color: #1d4ed8; letter-spacing: 0.15em;
    text-transform: uppercase; margin-top: 0.07rem;
  }

  /* ── LOGIC SPEC: high-security readout typography ── */
  .sal-doc-content code {
    font-family: 'Courier New','Lucida Console',monospace !important;
    font-size: 0.88rem;
    background: #f0f4ff;
    color: #0b2a6f;
    padding: 0.08rem 0.32rem;
    border-radius: 3px;
    border: 1px solid #c7d7fd;
    letter-spacing: 0.05em;
    font-weight: 700;
  }
  .sal-doc pre {
    font-family: 'Courier New','Lucida Console',monospace !important;
    font-size: 0.75rem !important;
    background: #071540 !important;
    color: #93c5fd !important;
    border: 1px solid #1d4ed8 !important;
    border-left: 4px solid #f59e0b !important;
    padding: 0.7rem 0.8rem !important;
    border-radius: 3px !important;
    line-height: 1.5 !important;
    margin: 0 !important;
    white-space: pre-wrap !important;
    word-break: break-word !important;
  }
  .sal-doc h4 {
    font-family: 'Arial','Helvetica Neue',sans-serif;
    font-size: 0.82rem; font-weight: 900;
    letter-spacing: 0.1em; text-transform: uppercase;
    color: #0b2a6f;
    border-bottom: 2px double #1d4ed8;
    padding-bottom: 0.25rem; margin-bottom: 0.5rem;
  }
  .sal-doc h5 {
    font-family: 'Courier New','Lucida Console',monospace;
    font-size: 0.66rem; font-weight: 800;
    letter-spacing: 0.12em; text-transform: uppercase;
    color: #1d4ed8; margin: 0 0 0.25rem;
  }

  /* ── SECTION DIVIDERS: double-line ribbon motif ── */
  .sal-section {
    border-top: 1px solid #e8ecf4 !important;
  }
  .sal-center-section-label {
    font-family: 'Arial','Helvetica Neue',sans-serif;
    font-size: 0.57rem; font-weight: 900; color: #0b2a6f;
    text-align: center; letter-spacing: 0.14em; text-transform: uppercase;
    margin: 0.55rem 0 0.28rem;
    border-top: 2px double #1d4ed8;
    border-bottom: 1px solid #b8caf8;
    padding: 0.18rem 0;
  }
  .sal-sector-divider {
    display: flex; align-items: center; gap: 0.5rem;
    margin: 0.45rem 0 0.28rem;
    border-top: 1px solid #b8caf8;
    padding-top: 0.3rem;
  }
  .sal-sector-divider::before, .sal-sector-divider::after {
    content: ""; flex: 1; height: 1px; background: #b8caf8;
  }
  .sal-sector-divider span {
    font-family: 'Courier New',monospace;
    font-size: 0.52rem; font-weight: 900;
    color: #1d4ed8; letter-spacing: 0.14em; white-space: nowrap;
  }

  /* ── NAV COLUMN BUTTONS: readable directory-list style ── */
  div[data-testid="stColumn"]:has(div.sal-col-authority-anchor) .stButton > button {
    font-family: 'Courier New','Lucida Console',monospace !important;
    font-size: 0.72rem !important;
    font-weight: 600 !important;
    letter-spacing: 0.02em !important;
    text-transform: none !important;
    text-align: left !important;
    border-radius: 2px !important;
    width: 100% !important;
    padding: 0.18rem 0.55rem !important;
    min-height: 1.6rem !important;
  }
  /* Sector seal selector buttons — keep centered since they're under seals */
  div[data-testid="stColumn"]:has(div.sal-col-authority-anchor) div[data-testid="stColumns"] .stButton > button {
    text-align: center !important;
    font-size: 0.65rem !important;
    font-weight: 700 !important;
    letter-spacing: 0.04em !important;
  }

  /* ── THREE-COLUMN TOP OFFSET LOCK ── */
  div[data-testid="stColumn"]:has(div.sal-col-bureau-anchor) > div,
  div[data-testid="stColumn"]:has(div.sal-col-authority-anchor) > div,
  div[data-testid="stColumn"]:has(div.sal-col-engine-anchor) > div {
    padding-top: 0.6rem !important;
    padding-left: 0.65rem !important;
    padding-right: 0.65rem !important;
    box-sizing: border-box !important;
  }

  /* ── STACK LABELS: official form all-caps ── */
  .sal-stack-label {
    font-family: 'Arial','Helvetica Neue',sans-serif !important;
    font-size: 0.65rem !important;
    font-weight: 900 !important;
    letter-spacing: 0.18em !important;
    color: #0b2a6f !important;
    text-transform: uppercase !important;
    border-bottom: 2px double #1d4ed8 !important;
    padding-bottom: 0.2rem !important;
    margin: 0 0 0.45rem 0 !important;
  }

  /* ── FILING CABINET HEADER: double-left border motif ── */
  .sal-filing-hdr {
    border-left: 4px double #1d4ed8 !important;
  }

  /* ══════════════════════════════════════════════════════════════════════════
     DATA TRANSFER LAYER — FEDERAL LEDGER CLICKABLE ROWS
     ══════════════════════════════════════════════════════════════════════════ */

  /* Ledger cell wrapper — gives each data cell a table-row feel */
  .sal-ledger-cell {
    padding: 0.18rem 0.3rem;
    min-height: 1.85rem;
    display: flex;
    align-items: center;
    border-bottom: 1px solid rgba(29,78,216,0.08);
    transition: background 0.1s;
  }
  .sal-ledger-soc {
    font-family: 'Courier New','Lucida Console',monospace !important;
    font-size: 0.58rem !important;
    font-weight: 800 !important;
    color: #0b2a6f !important;
    background: rgba(11,42,111,0.06) !important;
    border: 1px solid #c7d7fd !important;
    padding: 0.06rem 0.25rem !important;
    border-radius: 2px !important;
    letter-spacing: 0.04em !important;
  }
  .sal-ledger-title {
    font-size: 0.65rem;
    font-weight: 600;
    color: #1e293b;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    display: block;
    max-width: 100%;
  }
  .sal-ledger-salary {
    font-family: 'Courier New',monospace;
    font-size: 0.6rem;
    font-weight: 700;
    color: #475569;
  }

  /* Ledger row buttons — compact official-form style */
  div[data-testid="stColumn"]:has(div.sal-col-bureau-anchor) .stButton > button {
    font-family: 'Courier New','Lucida Console',monospace !important;
    font-size: 0.55rem !important;
    font-weight: 900 !important;
    letter-spacing: 0.1em !important;
    text-transform: uppercase !important;
    border-radius: 2px !important;
    padding: 0.12rem 0.2rem !important;
    min-height: 1.65rem !important;
    width: 100% !important;
  }
  /* Active row button gets a green glow */
  div[data-testid="stColumn"]:has(div.sal-col-bureau-anchor) .stButton > button[kind="primary"] {
    background: #166534 !important;
    border-color: #16a34a !important;
    color: #f0fdf4 !important;
    box-shadow: 0 0 8px rgba(22,163,74,0.45) !important;
  }

  /* Tighten column gaps inside ledger rows */
  div[data-testid="stColumn"]:has(div.sal-col-bureau-anchor) div[data-testid="stHorizontalBlock"] {
    gap: 0.1rem !important;
    margin-bottom: 0 !important;
  }
  div[data-testid="stColumn"]:has(div.sal-col-bureau-anchor) div[data-testid="stVerticalBlock"] {
    gap: 0 !important;
  }

  /* ══════════════════════════════════════════════════════════════════════════
     SECURITY CLEARANCE BADGE
     ══════════════════════════════════════════════════════════════════════════ */
  .sal-clearance-badge {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    font-family: 'Courier New','Lucida Console',monospace;
    font-size: 0.58rem;
    font-weight: 900;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: #f0fdf4;
    background: #14532d;
    border: 1px solid #16a34a;
    border-radius: 3px;
    padding: 0.18rem 0.55rem;
    margin-bottom: 0.55rem;
    box-shadow: 0 0 10px rgba(22,163,74,0.4), inset 0 0 6px rgba(22,163,74,0.15);
  }
  .sal-clearance-badge.sal-clearance-inactive {
    color: #94a3b8;
    background: #1e293b;
    border-color: #475569;
    box-shadow: none;
  }
  .sal-clearance-dot {
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: #22c55e;
    display: inline-block;
    box-shadow: 0 0 6px #22c55e;
    animation: sal-pulse 1.8s ease-in-out infinite;
    flex-shrink: 0;
  }
  .sal-clearance-badge.sal-clearance-inactive .sal-clearance-dot {
    background: #475569;
    box-shadow: none;
    animation: none;
  }
  @keyframes sal-pulse {
    0%, 100% { opacity: 1; box-shadow: 0 0 6px #22c55e; }
    50%       { opacity: 0.55; box-shadow: 0 0 2px #22c55e; }
  }

  /* ── Capabilities: Toolbox Manifest ── */
  .sal-toolbox-manifest {
    background: #04091a;
    border: 1px solid #1d4ed833;
    border-left: 3px solid #f59e0b;
    border-radius: 4px;
    padding: 0.6rem 0.75rem;
    margin: 0.3rem 0 0;
  }
  .sal-toolbox-category {
    margin: 0.35rem 0 0.2rem;
  }
  .sal-toolbox-cat-label {
    font-family: 'Courier New', monospace;
    font-size: 0.56rem;
    font-weight: 800;
    letter-spacing: 0.14em;
    color: #f59e0b;
    text-transform: uppercase;
    display: block;
    margin-bottom: 0.2rem;
  }
  .sal-toolbox-pills {
    display: flex;
    flex-wrap: wrap;
    gap: 0.25rem;
  }
  .sal-toolbox-pill {
    background: #071540;
    border: 1px solid #1d4ed844;
    border-radius: 2px;
    font-family: 'Courier New', monospace;
    font-size: 0.6rem;
    color: #93c5fd;
    padding: 0.18rem 0.45rem;
    letter-spacing: 0.04em;
  }

  /* ── SAL Command Interface ── */
  .sal-cmd-hdr {
    background: linear-gradient(90deg, #020c1b 0%, #0b2a6f 40%, #071540 70%, #020c1b 100%);
    border: 1px solid #1d4ed8;
    border-bottom: 1px solid #1d4ed844;
    border-radius: 6px 6px 0 0;
    padding: 0.42rem 0.85rem;
    display: flex;
    align-items: center;
    gap: 0.55rem;
    font-family: 'Courier New', monospace;
    font-size: 0.59rem;
    color: #60a5fa;
    letter-spacing: 0.09em;
    position: relative;
    overflow: hidden;
  }
  .sal-cmd-hdr::after {
    content: '';
    position: absolute; top: 0; left: -80%;
    width: 50%; height: 100%;
    background: linear-gradient(90deg, transparent, rgba(56,189,248,0.07), transparent);
    animation: sal-scan-line 5s linear infinite;
    pointer-events: none;
  }
  @keyframes sal-scan-line {
    0%   { left: -60%; }
    100% { left: 110%; }
  }
  .sal-cmd-live-dot {
    width: 7px; height: 7px;
    background: #22c55e;
    border-radius: 50%;
    display: inline-block;
    flex-shrink: 0;
    animation: sal-live-blink 1.6s ease-in-out infinite;
    box-shadow: 0 0 6px #22c55eaa;
  }
  @keyframes sal-live-blink {
    0%, 100% { opacity: 1; box-shadow: 0 0 7px #22c55e; }
    50%       { opacity: 0.25; box-shadow: none; }
  }
  .sal-cmd-live-txt  { color: #22c55e; font-weight: 900; letter-spacing: 0.12em; }
  .sal-cmd-sep       { color: #1d4ed8; opacity: 0.5; }
  .sal-cmd-title     { color: #e2e8f0; font-weight: 800; letter-spacing: 0.15em; }
  .sal-cmd-stat      { color: #93c5fd; }
  .sal-cmd-prompt {
    background: #030b19;
    border-left: 1px solid #1d4ed8;
    border-right: 1px solid #1d4ed8;
    padding: 0.3rem 0.85rem;
    font-family: 'Courier New', monospace;
    font-size: 0.62rem;
    color: #334155;
    letter-spacing: 0.05em;
    display: flex;
    align-items: center;
    gap: 0.4rem;
  }
  .sal-cmd-caret {
    color: #38bdf8;
    animation: sal-caret-blink 1.1s step-end infinite;
    font-size: 0.8rem;
  }
  @keyframes sal-caret-blink {
    0%, 100% { opacity: 1; } 50% { opacity: 0; }
  }
  /* Style the Streamlit text input inside the command interface zone */
  .sal-search-anchor ~ div div[data-testid="stTextInput"] > div {
    border: none !important;
    border-bottom: 1px solid #1d4ed855 !important;
    border-radius: 0 !important;
    background: #030b19 !important;
    padding: 0 !important;
  }
  .sal-search-anchor ~ div div[data-testid="stTextInput"] input {
    background: #030b19 !important;
    color: #e2e8f0 !important;
    font-family: 'Courier New', monospace !important;
    font-size: 0.88rem !important;
    caret-color: #38bdf8 !important;
    border: none !important;
    border-bottom: 1px solid transparent !important;
    border-radius: 0 !important;
    padding: 0.65rem 1rem !important;
    letter-spacing: 0.02em !important;
    transition: border-color 0.2s !important;
  }
  .sal-search-anchor ~ div div[data-testid="stTextInput"] input:focus {
    border-bottom-color: #38bdf8 !important;
    box-shadow: 0 1px 0 #38bdf855 !important;
    outline: none !important;
  }
  .sal-search-anchor ~ div div[data-testid="stTextInput"] input::placeholder {
    color: #1e3a5f !important;
    font-style: italic;
  }
  /* Dispatch button */
  .sal-search-anchor ~ div div[data-testid="stButton"] > button[kind="primary"] {
    background: linear-gradient(135deg,#1d4ed8 0%,#3730a3 100%) !important;
    border: 1px solid #3b82f655 !important;
    border-top: 1px solid #60a5fa33 !important;
    color: #fff !important;
    font-family: 'Courier New', monospace !important;
    font-size: 0.72rem !important;
    font-weight: 900 !important;
    letter-spacing: 0.18em !important;
    border-radius: 0 !important;
    padding: 0.55rem 1rem !important;
    transition: all 0.25s !important;
    position: relative !important;
    overflow: hidden !important;
    text-shadow: 0 0 12px rgba(96,165,250,0.6) !important;
  }
  .sal-search-anchor ~ div div[data-testid="stButton"] > button[kind="primary"]:hover {
    background: linear-gradient(135deg,#2563eb 0%,#4338ca 100%) !important;
    box-shadow: 0 0 18px rgba(59,130,246,0.45) !important;
    transform: none !important;
  }
  .sal-cmd-chips {
    background: #020c1b;
    border: 1px solid #1d4ed8;
    border-top: 1px solid #1d4ed822;
    border-radius: 0 0 6px 6px;
    padding: 0.45rem 0.7rem;
    display: flex;
    flex-wrap: wrap;
    gap: 0.3rem;
    margin-bottom: 0.5rem;
  }
  .sal-chip {
    background: #071540;
    border: 1px solid #1d4ed844;
    color: #60a5fa;
    font-family: 'Courier New', monospace;
    font-size: 0.56rem;
    letter-spacing: 0.08em;
    padding: 0.22rem 0.5rem;
    border-radius: 2px;
    cursor: default;
    white-space: nowrap;
    transition: background 0.2s, border-color 0.2s;
  }
  .sal-chip-bright  { border-color: #92400e44; color: #fbbf24; background: #120800; }
  .sal-chip-vault   { border-color: #5b21b644; color: #c4b5fd; background: #0d0720; }
  .sal-cmd-transmission {
    background: #020c1b;
    border: 1px solid #1d4ed844;
    border-left: 3px solid #38bdf8;
    border-radius: 0 4px 4px 0;
    padding: 0.5rem 0.85rem;
    margin: 0.3rem 0;
    font-family: 'Courier New', monospace;
    font-size: 0.7rem;
    color: #93c5fd;
    line-height: 1.55;
  }
  .sal-cmd-transmission-hdr {
    font-size: 0.56rem;
    font-weight: 900;
    letter-spacing: 0.14em;
    color: #38bdf8;
    margin-bottom: 0.25rem;
    display: block;
  }
  .sal-capabilities-block {
    font-family: 'Courier New','Lucida Console',monospace !important;
    font-size: 0.74rem !important;
    background: #071540 !important;
    color: #93c5fd !important;
    border: 1px solid #1d4ed8 !important;
    border-left: 4px solid #f59e0b !important;
    padding: 0.75rem 0.85rem !important;
    border-radius: 3px !important;
    line-height: 1.55 !important;
    margin: 0.25rem 0 0 !important;
    white-space: pre-wrap !important;
    word-break: break-word !important;
  }

  /* ── Bug 1: Loaded-role feedback bar (visible at tree level) ── */
  .sal-tree-loaded {
    display: flex;
    align-items: center;
    gap: 0.45rem;
    background: linear-gradient(90deg, #f0f7ff 0%, rgba(240,247,255,0) 100%);
    border-left: 3px solid #22c55e;
    border-top: 1px solid #bbf7d0;
    border-bottom: 1px solid #bbf7d044;
    padding: 0.28rem 0.6rem;
    font-family: 'Courier New', monospace;
    font-size: 0.58rem;
    letter-spacing: 0.06em;
    margin-bottom: 0.2rem;
    border-radius: 0 2px 2px 0;
    animation: sal-loaded-flash 0.5s ease-out;
  }
  @keyframes sal-loaded-flash {
    0%   { background: linear-gradient(90deg,#dcfce7,rgba(220,252,231,0)); opacity: 0.6; }
    100% { background: linear-gradient(90deg,#f0f7ff,rgba(240,247,255,0)); opacity: 1; }
  }
  .sal-tree-loaded-dot {
    width: 7px; height: 7px;
    background: #22c55e;
    border-radius: 50%;
    flex-shrink: 0;
    box-shadow: 0 0 5px #22c55e88;
  }
  .sal-tree-loaded-label {
    color: #166534;
    font-weight: 900;
    letter-spacing: 0.1em;
    flex-shrink: 0;
  }
  .sal-tree-loaded-title {
    color: #0b2a6f;
    font-weight: 700;
    flex: 1;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  .sal-tree-loaded-soc {
    font-family: 'Courier New', monospace;
    font-size: 0.55rem;
    background: #dbeafe;
    color: #1d4ed8;
    padding: 0.1rem 0.35rem;
    border-radius: 2px;
    flex-shrink: 0;
  }

  /* ── Bug 4: Active query filter pill above tree ── */
  .sal-tree-filter {
    display: flex;
    align-items: center;
    gap: 0.4rem;
    background: #fefce8;
    border: 1px solid #fde68a;
    border-left: 3px solid #f59e0b;
    padding: 0.25rem 0.6rem;
    font-family: 'Courier New', monospace;
    font-size: 0.58rem;
    letter-spacing: 0.05em;
    color: #78350f;
    border-radius: 0 2px 2px 0;
    margin-bottom: 0.25rem;
  }
  .sal-tree-filter-q {
    color: #0b2a6f;
    font-weight: 800;
  }
  .sal-tree-filter-hint {
    color: #92400e;
    opacity: 0.65;
  }
</style>
""", unsafe_allow_html=True)


# ── Section renderers ────────────────────────────────────────────────────────

def _render_hub(*, client, browse_mode: bool) -> None:
    """TOP — Intelligence Hub: centered hero + project-to-standard mapping."""
    st.markdown('<p class="sal-stack-label">Top &middot; SAL Intelligence Hub</p>', unsafe_allow_html=True)
    lc, cc, rc = st.columns([1, 2.35, 1])
    with cc:
        st.markdown(
            '<div class="sal-hub-wrap">'
            "<h2>SAL: Standard Agent Logic Registry</h2>"
            "<p class='sal-hub-sub'>Intelligence Hub &middot; Global Registry &mdash; map projects and programs to "
            "authenticated SOC logic standards in the Standardized Logic Library (1,095-role Global Registry).</p>"
            "</div>",
            unsafe_allow_html=True,
        )
        with st.form("sal_hub_project_map", clear_on_submit=False):
            st.markdown('<div class="sal-hub-form">', unsafe_allow_html=True)
            intent = st.text_input(
                "Project or standard",
                label_visibility="collapsed",
                placeholder="Describe the project, domain, or logic standard you need to operationalize\u2026",
            )
            st.markdown("</div>", unsafe_allow_html=True)
            submitted = st.form_submit_button("Map to logic standard", type="primary", use_container_width=True)
        if submitted and intent.strip():
            vault_only = bool(st.session_state.get("vault_only", False))
            reply = sal_intent_hub_reply(client=client, user_request=intent.strip(), vault_only=vault_only, demo_mode=browse_mode)
            st.session_state["sal_hub_last_reply"] = str(reply.get("message") or "")
            if reply.get("selected_soc"):
                st.session_state["active_soc"] = str(reply["selected_soc"])
        last = st.session_state.get("sal_hub_last_reply")
        if last:
            st.markdown("##### Global Registry mapping")
            st.markdown(str(last))


def _render_bureau(*, client, browse_mode: bool) -> None:
    """MIDDLE — Registry Bureau: SOC folder tree (left) + logic card (right)."""
    st.markdown('<p class="sal-stack-label">Middle &middot; The Registry Bureau</p>', unsafe_allow_html=True)
    st.markdown("#### The Bureau \u2014 Standardized Logic Library navigator")
    st.caption("O\u2217NET major-group folder tree (left) \u00b7 Logic specification document (right)")

    col_left, col_right = st.columns([0.38, 0.62], gap="large")

    with col_left:
        st.markdown('<div class="sal-bureau-anchor"></div>', unsafe_allow_html=True)
        query = st.text_input("Filter tree", key="sal_search", placeholder="Search titles / outlook\u2026")
        scope = st.radio(
            "Library scope",
            ["Global Registry", "Private Vault \U0001f3c6"],
            horizontal=True,
            help="Private Vault lists only proprietary roles (`is_custom = true`).",
            key="sal_scope",
        )
        vault_only = scope != "Global Registry"
        st.session_state["vault_only"] = vault_only
        _render_file_tree_panel(
            supabase_url=_resolve_supabase_url(),
            supabase_key=_resolve_supabase_key(),
            query=query,
            vault_only=vault_only,
            demo_mode=browse_mode,
            button_key_prefix="bureau_",
        )

    with col_right:
        selected_soc = str(st.session_state.get("active_soc") or "")
        chosen_row: dict[str, Any] | None = None
        if selected_soc:
            if browse_mode:
                chosen_row = next((dict(r) for r in _MOCK_REGISTRY if r.get("soc_code") == selected_soc), None)
            elif client is not None:
                try:
                    rr = client.table("registry_metadata").select("soc_code,title,market_value,outlook,is_custom,description").eq("soc_code", selected_soc).limit(1).execute()
                    if rr.data:
                        chosen_row = rr.data[0]
                except Exception:
                    chosen_row = None

        logic: dict[str, Any] | None = None
        if selected_soc:
            if browse_mode:
                logic = _demo_fetch_agent_logic_detail(selected_soc)
            elif client is not None:
                try:
                    logic = fetch_agent_logic_detail(client, selected_soc)
                except Exception as exc:
                    st.warning(escape(str(exc)))

        _render_logic_spec_html_card(selected_soc=selected_soc, chosen_row=chosen_row, logic=logic, browse_mode=browse_mode)


def _notary_seal_svg(code: str, title: str, bg: str, ring: str, accent: str, icon_svg: str) -> str:
    """Build a 200x200 SVG federal-grade notary seal — gold outer rim, gear teeth, arc text."""
    # Gold colour shared with main SAL seal for visual continuity
    GOLD = "#c9a227"
    GOLD_LIGHT = "#f0d060"
    teeth: list[str] = []
    n_teeth = 52
    for i in range(n_teeth):
        a1 = ((i * 360 / n_teeth) - 2.4) * math.pi / 180
        a2 = ((i * 360 / n_teeth) + 2.4) * math.pi / 180
        ri, ro = 91, 101
        pts = (
            f"{100 + ri * math.cos(a1):.2f},{100 + ri * math.sin(a1):.2f} "
            f"{100 + ri * math.cos(a2):.2f},{100 + ri * math.sin(a2):.2f} "
            f"{100 + ro * math.cos(a2):.2f},{100 + ro * math.sin(a2):.2f} "
            f"{100 + ro * math.cos(a1):.2f},{100 + ro * math.sin(a1):.2f}"
        )
        teeth.append(f'<polygon points="{pts}" fill="{GOLD}" opacity="0.92"/>')
    teeth_html = "\n  ".join(teeth)
    cid = f"s{code.replace('-','')}"
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200"'
        f' width="190" height="190" style="display:block;margin:0 auto;overflow:visible">\n'
        f'  <defs>\n'
        f'    <radialGradient id="bg{cid}" cx="34%" cy="28%" r="70%">\n'
        f'      <stop offset="0%" stop-color="#ffffff" stop-opacity="0.13"/>\n'
        f'      <stop offset="100%" stop-color="#000000" stop-opacity="0.0"/>\n'
        f'    </radialGradient>\n'
        f'    <linearGradient id="goldrim{cid}" x1="0%" y1="0%" x2="100%" y2="100%">\n'
        f'      <stop offset="0%" stop-color="{GOLD_LIGHT}"/>\n'
        f'      <stop offset="50%" stop-color="{GOLD}"/>\n'
        f'      <stop offset="100%" stop-color="#8a6a10"/>\n'
        f'    </linearGradient>\n'
        f'    <path id="topA{cid}" d="M100,100 m-66,0 a66,66 0 1,1 132,0"/>\n'
        f'    <path id="botA{cid}" d="M100,100 m-61,0 a61,61 0 0,0 122,0"/>\n'
        f'    <filter id="glo{cid}">\n'
        f'      <feGaussianBlur stdDeviation="1.6" result="b"/>\n'
        f'      <feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge>\n'
        f'    </filter>\n'
        f'    <filter id="shadow{cid}" x="-10%" y="-10%" width="120%" height="120%">\n'
        f'      <feDropShadow dx="0" dy="2" stdDeviation="3" flood-color="#000" flood-opacity="0.4"/>\n'
        f'    </filter>\n'
        f'  </defs>\n'
        # Outer gold medal rim (behind teeth)
        f'  <circle cx="100" cy="100" r="103" fill="url(#goldrim{cid})" opacity="0.35"/>\n'
        f'  {teeth_html}\n'
        # Gold ring just inside teeth
        f'  <circle cx="100" cy="100" r="90" fill="none" stroke="{GOLD}" stroke-width="1.8" opacity="0.7"/>\n'
        f'  <circle cx="100" cy="100" r="89" fill="{bg}" filter="url(#shadow{cid})"/>\n'
        f'  <circle cx="100" cy="100" r="89" fill="url(#bg{cid})"/>\n'
        # Ring details — sector colour + gold accents
        f'  <circle cx="100" cy="100" r="86" fill="none" stroke="{ring}" stroke-width="2.2"/>\n'
        f'  <circle cx="100" cy="100" r="81" fill="none" stroke="{GOLD}" stroke-width="0.8"'
        f'          stroke-dasharray="4 2.5" opacity="0.6"/>\n'
        f'  <circle cx="100" cy="100" r="76" fill="none" stroke="{ring}" stroke-width="1.1"/>\n'
        f'  <circle cx="100" cy="100" r="72" fill="none" stroke="{accent}" stroke-width="0.5"'
        f'          opacity="0.4"/>\n'
        f'  <g filter="url(#glo{cid})">{icon_svg}</g>\n'
        f'  <text font-family="\'Arial Narrow\',Arial,sans-serif" font-size="10" font-weight="900"'
        f'        letter-spacing="3" fill="{accent}" text-anchor="middle">\n'
        f'    <textPath href="#topA{cid}" startOffset="50%">{title.upper()}</textPath>\n'
        f'  </text>\n'
        f'  <text font-family="Arial,sans-serif" font-size="7.5" font-weight="700"'
        f'        letter-spacing="2.2" fill="{GOLD}" text-anchor="middle" opacity="0.9">\n'
        f'    <textPath href="#botA{cid}" startOffset="50%">SOC {code} \u00b7 O\u2217NET</textPath>\n'
        f'  </text>\n'
        f'  <text x="56"  y="160" text-anchor="middle" font-size="9" fill="{GOLD}" opacity="0.85">&#9733;</text>\n'
        f'  <text x="144" y="160" text-anchor="middle" font-size="9" fill="{GOLD}" opacity="0.85">&#9733;</text>\n'
        f'</svg>'
    )


# ── Per-sector icon SVG fragments ────────────────────────────────────────────
_SEAL_ICONS: dict[str, str] = {
    # Management (11) — Federal government building with columns + pediment
    "11": """
    <polygon points="84,108 116,108 100,88" fill="none" stroke="#c4b5fd" stroke-width="2.2"/>
    <rect x="87" y="108" width="26" height="23" fill="none" stroke="#a78bfa" stroke-width="1.8"/>
    <rect x="91" y="112" width="4" height="19" rx="0" fill="#a78bfa" opacity="0.55"/>
    <rect x="98" y="112" width="4" height="19" rx="0" fill="#a78bfa" opacity="0.55"/>
    <rect x="105" y="112" width="4" height="19" rx="0" fill="#a78bfa" opacity="0.55"/>
    <circle cx="100" cy="88" r="3.5" fill="#c4b5fd" opacity="0.9"/>
    <line x1="83" y1="131" x2="117" y2="131" stroke="#a78bfa" stroke-width="2.4"/>
    <line x1="80" y1="134" x2="120" y2="134" stroke="#a78bfa" stroke-width="1.5" opacity="0.6"/>
    <line x1="80" y1="136" x2="120" y2="136" stroke="#a78bfa" stroke-width="0.8" opacity="0.4"/>
    <line x1="86" y1="108" x2="86" y2="131" stroke="#c4b5fd" stroke-width="0.8" opacity="0.5" stroke-dasharray="2 2"/>
    <line x1="114" y1="108" x2="114" y2="131" stroke="#c4b5fd" stroke-width="0.8" opacity="0.5" stroke-dasharray="2 2"/>
    <text x="100" y="78" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7.8" font-weight="800" fill="#c4b5fd" letter-spacing="1.2">MANAGEMENT</text>""",

    # Engineering / Architecture (17) — Drafting compass + T-square + blueprint grid
    "17": """
    <line x1="78" y1="114" x2="122" y2="114" stroke="#fbbf24" stroke-width="2.2"/>
    <line x1="76" y1="108" x2="124" y2="108" stroke="#fbbf24" stroke-width="0.9" opacity="0.5" stroke-dasharray="3 2"/>
    <line x1="100" y1="84" x2="86" y2="131" stroke="#fde68a" stroke-width="2.0"/>
    <line x1="100" y1="84" x2="114" y2="131" stroke="#fde68a" stroke-width="2.0"/>
    <circle cx="100" cy="84" r="5" fill="#fbbf24"/>
    <circle cx="100" cy="84" r="2.5" fill="#0b2a6f"/>
    <polygon points="86,131 100,106 114,131" fill="none" stroke="#fbbf24" stroke-width="1.5" opacity="0.7"/>
    <line x1="88" y1="131" x2="88" y2="126" stroke="#fbbf24" stroke-width="1.2" opacity="0.7"/>
    <line x1="94" y1="131" x2="94" y2="127" stroke="#fbbf24" stroke-width="1.2" opacity="0.7"/>
    <line x1="106" y1="131" x2="106" y2="127" stroke="#fbbf24" stroke-width="1.2" opacity="0.7"/>
    <line x1="112" y1="131" x2="112" y2="126" stroke="#fbbf24" stroke-width="1.2" opacity="0.7"/>
    <text x="100" y="77" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7.5" font-weight="800" fill="#fbbf24" letter-spacing="1">ENGINEERING</text>""",

    # Finance (13) — Bar chart with grid lines + trend line + baseline
    "13": """
    <line x1="70" y1="83"  x2="130" y2="83"  stroke="#93c5fd" stroke-width="0.7" opacity="0.35" stroke-dasharray="2 2"/>
    <line x1="70" y1="97"  x2="130" y2="97"  stroke="#93c5fd" stroke-width="0.7" opacity="0.35" stroke-dasharray="2 2"/>
    <line x1="70" y1="111" x2="130" y2="111" stroke="#93c5fd" stroke-width="0.7" opacity="0.35" stroke-dasharray="2 2"/>
    <rect x="73"  y="108" width="10" height="23" rx="1" fill="#93c5fd" opacity="0.8"/>
    <rect x="87"  y="94"  width="10" height="37" rx="1" fill="#bfdbfe" opacity="0.9"/>
    <rect x="101" y="82"  width="10" height="49" rx="1" fill="#ffffff"/>
    <rect x="115" y="97"  width="10" height="34" rx="1" fill="#bfdbfe" opacity="0.9"/>
    <line x1="70" y1="131" x2="130" y2="131" stroke="#93c5fd" stroke-width="2.2"/>
    <line x1="68" y1="133" x2="132" y2="133" stroke="#93c5fd" stroke-width="0.8" opacity="0.5"/>
    <polyline points="78,118 92,103 106,83 120,97" fill="none" stroke="#ffffff"
              stroke-width="1.6" opacity="0.65" stroke-dasharray="3 1.5"/>
    <circle cx="106" cy="83" r="2" fill="#ffffff" opacity="0.8"/>
    <text x="100" y="75" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="8" font-weight="800" fill="#93c5fd" letter-spacing="1.5">FINANCE</text>""",

    # Technology / Computer (15) — IC chip with circuit-board pin array + terminal
    "15": """
    <rect x="81" y="82" width="38" height="36" rx="3" fill="none" stroke="#bfdbfe" stroke-width="2.2"/>
    <rect x="87" y="88" width="26" height="24" rx="2" fill="#071540" stroke="#93c5fd" stroke-width="1.5"/>
    <line x1="81" y1="90"  x2="74" y2="90"  stroke="#bfdbfe" stroke-width="1.9"/>
    <line x1="81" y1="96"  x2="74" y2="96"  stroke="#bfdbfe" stroke-width="1.9"/>
    <line x1="81" y1="102" x2="74" y2="102" stroke="#93c5fd" stroke-width="2.2"/>
    <line x1="81" y1="108" x2="74" y2="108" stroke="#bfdbfe" stroke-width="1.9"/>
    <line x1="81" y1="114" x2="74" y2="114" stroke="#bfdbfe" stroke-width="1.9"/>
    <line x1="119" y1="90"  x2="126" y2="90"  stroke="#bfdbfe" stroke-width="1.9"/>
    <line x1="119" y1="96"  x2="126" y2="96"  stroke="#bfdbfe" stroke-width="1.9"/>
    <line x1="119" y1="102" x2="126" y2="102" stroke="#93c5fd" stroke-width="2.2"/>
    <line x1="119" y1="108" x2="126" y2="108" stroke="#bfdbfe" stroke-width="1.9"/>
    <line x1="119" y1="114" x2="126" y2="114" stroke="#bfdbfe" stroke-width="1.9"/>
    <line x1="92"  y1="82" x2="92"  y2="75" stroke="#bfdbfe" stroke-width="1.9"/>
    <line x1="100" y1="82" x2="100" y2="75" stroke="#93c5fd" stroke-width="2.2"/>
    <line x1="108" y1="82" x2="108" y2="75" stroke="#bfdbfe" stroke-width="1.9"/>
    <line x1="92"  y1="118" x2="92"  y2="125" stroke="#bfdbfe" stroke-width="1.9"/>
    <line x1="100" y1="118" x2="100" y2="125" stroke="#93c5fd" stroke-width="2.2"/>
    <line x1="108" y1="118" x2="108" y2="125" stroke="#bfdbfe" stroke-width="1.9"/>
    <text x="100" y="99"  text-anchor="middle" font-family="monospace,Arial" font-size="7" font-weight="900" fill="#93c5fd">SAL</text>
    <rect x="90"  y="102" width="5" height="1.8" fill="#93c5fd" opacity="0.85"/>
    <text x="100" y="109" text-anchor="middle" font-family="monospace,Arial" font-size="5.5" fill="#bfdbfe" opacity="0.7">01101001</text>
    <text x="100" y="75"  text-anchor="middle" font-family="Arial,sans-serif"
          font-size="8" font-weight="800" fill="#93c5fd" letter-spacing="1.5">TECHNOLOGY</text>""",

    # Healthcare (29) — Bold cross + caduceus serpent curves + wings
    "29": """
    <rect x="93" y="79" width="14" height="42" rx="2" fill="#5ee8c8" opacity="0.88"/>
    <rect x="79" y="93" width="42" height="14" rx="2" fill="#5ee8c8" opacity="0.88"/>
    <path d="M97,84 Q92,92 97,100 Q102,108 97,116" fill="none" stroke="#07211e" stroke-width="2"/>
    <path d="M103,84 Q108,92 103,100 Q98,108 103,116" fill="none" stroke="#07211e" stroke-width="2"/>
    <circle cx="100" cy="100" r="9.5" fill="#07211e"/>
    <circle cx="100" cy="100" r="6"   fill="none" stroke="#5ee8c8" stroke-width="2.2"/>
    <circle cx="100" cy="100" r="2.5" fill="#5ee8c8" opacity="0.7"/>
    <path d="M93,83 Q86,79 84,85" fill="none" stroke="#5ee8c8" stroke-width="1.8" opacity="0.75"/>
    <path d="M107,83 Q114,79 116,85" fill="none" stroke="#5ee8c8" stroke-width="1.8" opacity="0.75"/>
    <circle cx="84" cy="85" r="1.5" fill="#5ee8c8" opacity="0.65"/>
    <circle cx="116" cy="85" r="1.5" fill="#5ee8c8" opacity="0.65"/>
    <text x="100" y="75" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="8" font-weight="800" fill="#5ee8c8" letter-spacing="1.8">HEALTHCARE</text>""",

    # Life, Physical & Social Science (19) — atom / orbital rings
    "19": """
    <circle cx="100" cy="106" r="6.5" fill="#86efac" opacity="0.9"/>
    <circle cx="100" cy="106" r="3" fill="#071a10"/>
    <ellipse cx="100" cy="106" rx="24" ry="8" fill="none" stroke="#86efac" stroke-width="1.8" opacity="0.85"/>
    <ellipse cx="100" cy="106" rx="24" ry="8" fill="none" stroke="#86efac" stroke-width="1.8" opacity="0.85" transform="rotate(60 100 106)"/>
    <ellipse cx="100" cy="106" rx="24" ry="8" fill="none" stroke="#86efac" stroke-width="1.8" opacity="0.85" transform="rotate(120 100 106)"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7.5" font-weight="800" fill="#86efac" letter-spacing="1">SCIENCE</text>""",

    # Community &amp; Social Service (21) — three linked nodes / community network
    "21": """
    <circle cx="100" cy="93" r="10" fill="none" stroke="#d8b4fe" stroke-width="2" opacity="0.85"/>
    <circle cx="87" cy="115" r="10" fill="none" stroke="#d8b4fe" stroke-width="2" opacity="0.85"/>
    <circle cx="113" cy="115" r="10" fill="none" stroke="#d8b4fe" stroke-width="2" opacity="0.85"/>
    <line x1="100" y1="103" x2="91" y2="109" stroke="#d8b4fe" stroke-width="1.8" opacity="0.65"/>
    <line x1="100" y1="103" x2="109" y2="109" stroke="#d8b4fe" stroke-width="1.8" opacity="0.65"/>
    <line x1="93" y1="112" x2="107" y2="112" stroke="#d8b4fe" stroke-width="1.2" opacity="0.4"/>
    <circle cx="100" cy="93" r="3.5" fill="#d8b4fe" opacity="0.8"/>
    <circle cx="87" cy="115" r="3.5" fill="#d8b4fe" opacity="0.8"/>
    <circle cx="113" cy="115" r="3.5" fill="#d8b4fe" opacity="0.8"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7.5" font-weight="800" fill="#d8b4fe" letter-spacing="1">COMMUNITY</text>""",

    # Legal (23) — scales of justice
    "23": """
    <line x1="100" y1="82" x2="100" y2="130" stroke="#fcd34d" stroke-width="2.5"/>
    <line x1="78" y1="90" x2="122" y2="90" stroke="#fcd34d" stroke-width="2"/>
    <line x1="78" y1="90" x2="82" y2="112" stroke="#fcd34d" stroke-width="1.6"/>
    <line x1="122" y1="90" x2="118" y2="112" stroke="#fcd34d" stroke-width="1.6"/>
    <ellipse cx="80" cy="114" rx="9" ry="3.5" fill="#fcd34d" opacity="0.5"/>
    <ellipse cx="120" cy="114" rx="9" ry="3.5" fill="#fcd34d" opacity="0.5"/>
    <line x1="71" y1="114" x2="89" y2="114" stroke="#fcd34d" stroke-width="1.5" opacity="0.7"/>
    <line x1="111" y1="114" x2="129" y2="114" stroke="#fcd34d" stroke-width="1.5" opacity="0.7"/>
    <circle cx="100" cy="90" r="4" fill="#fcd34d"/>
    <line x1="93" y1="130" x2="107" y2="130" stroke="#fcd34d" stroke-width="2.5" stroke-linecap="round"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="8" font-weight="800" fill="#fcd34d" letter-spacing="1.5">LEGAL</text>""",

    # Educational Instruction &amp; Library (25) — open book
    "25": """
    <rect x="78" y="88" width="22" height="32" rx="1" fill="none" stroke="#7dd3fc" stroke-width="2"/>
    <rect x="100" y="88" width="22" height="32" rx="1" fill="none" stroke="#7dd3fc" stroke-width="2"/>
    <line x1="100" y1="88" x2="100" y2="120" stroke="#7dd3fc" stroke-width="2.5"/>
    <line x1="83" y1="96" x2="97" y2="96" stroke="#7dd3fc" stroke-width="1.1" opacity="0.65"/>
    <line x1="83" y1="101" x2="97" y2="101" stroke="#7dd3fc" stroke-width="1.1" opacity="0.65"/>
    <line x1="83" y1="106" x2="97" y2="106" stroke="#7dd3fc" stroke-width="1.1" opacity="0.65"/>
    <line x1="83" y1="111" x2="97" y2="111" stroke="#7dd3fc" stroke-width="1.1" opacity="0.65"/>
    <line x1="103" y1="96" x2="119" y2="96" stroke="#7dd3fc" stroke-width="1.1" opacity="0.65"/>
    <line x1="103" y1="101" x2="119" y2="101" stroke="#7dd3fc" stroke-width="1.1" opacity="0.65"/>
    <line x1="103" y1="106" x2="119" y2="106" stroke="#7dd3fc" stroke-width="1.1" opacity="0.65"/>
    <line x1="103" y1="111" x2="119" y2="111" stroke="#7dd3fc" stroke-width="1.1" opacity="0.65"/>
    <line x1="76" y1="122" x2="124" y2="122" stroke="#7dd3fc" stroke-width="1.5" opacity="0.45"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7" font-weight="800" fill="#7dd3fc" letter-spacing="1">EDUCATION</text>""",

    # Arts, Design, Entertainment &amp; Media (27) — painter's palette + brush
    "27": """
    <ellipse cx="99" cy="107" rx="20" ry="18" fill="none" stroke="#f9a8d4" stroke-width="2"/>
    <circle cx="89" cy="98" r="3.5" fill="#f9a8d4" opacity="0.85"/>
    <circle cx="83" cy="108" r="3.5" fill="#f9a8d4" opacity="0.85"/>
    <circle cx="89" cy="118" r="3.5" fill="#f9a8d4" opacity="0.85"/>
    <circle cx="108" cy="97" r="3.5" fill="#f9a8d4" opacity="0.85"/>
    <circle cx="115" cy="108" r="3.5" fill="#f9a8d4" opacity="0.85"/>
    <ellipse cx="102" cy="116" rx="6" ry="4" fill="#f9a8d4" opacity="0.35"/>
    <line x1="113" y1="116" x2="126" y2="87" stroke="#f9a8d4" stroke-width="2.8" stroke-linecap="round"/>
    <circle cx="126" cy="87" r="3.5" fill="#f9a8d4" opacity="0.7"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7.5" font-weight="800" fill="#f9a8d4" letter-spacing="1">ARTS &amp; MEDIA</text>""",

    # Healthcare Support (31) — stethoscope
    "31": """
    <path d="M86,86 Q80,86 80,93 L80,108 Q80,124 100,124 Q120,124 120,108 L120,93 Q120,86 114,86"
          fill="none" stroke="#6ee7b7" stroke-width="2.5" stroke-linecap="round"/>
    <line x1="86" y1="86" x2="114" y2="86" stroke="#6ee7b7" stroke-width="2.5"/>
    <circle cx="100" cy="124" r="9" fill="none" stroke="#6ee7b7" stroke-width="2.5"/>
    <circle cx="100" cy="124" r="4" fill="#6ee7b7" opacity="0.7"/>
    <circle cx="80" cy="86" r="3.5" fill="#6ee7b7" opacity="0.5"/>
    <circle cx="120" cy="86" r="3.5" fill="#6ee7b7" opacity="0.5"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7" font-weight="800" fill="#6ee7b7" letter-spacing="1">HLTH SUPPORT</text>""",

    # Protective Service (33) — badge shield with star
    "33": """
    <path d="M100,85 L121,94 L121,113 Q121,128 100,135 Q79,128 79,113 L79,94 Z"
          fill="none" stroke="#a3e635" stroke-width="2.2"/>
    <path d="M100,91 L115,98 L115,112 Q115,124 100,129 Q85,124 85,112 L85,98 Z"
          fill="#a3e635" opacity="0.1"/>
    <polygon points="100,100 102.8,108.4 111.8,108.4 104.6,113.6 107.4,122 100,116.8 92.6,122 95.4,113.6 88.2,108.4 97.2,108.4"
             fill="#a3e635" opacity="0.9"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7" font-weight="800" fill="#a3e635" letter-spacing="1">PROTECTIVE</text>""",

    # Food Preparation &amp; Serving (35) — chef hat + brim
    "35": """
    <rect x="81" y="112" width="38" height="11" rx="1.5" fill="none" stroke="#fb923c" stroke-width="2.2"/>
    <path d="M83,112 Q83,92 100,92 Q117,92 117,112" fill="none" stroke="#fb923c" stroke-width="2"/>
    <ellipse cx="100" cy="92" rx="17" ry="14" fill="none" stroke="#fb923c" stroke-width="2"/>
    <ellipse cx="100" cy="92" rx="10" ry="8" fill="#fb923c" opacity="0.15"/>
    <line x1="89" y1="112" x2="89" y2="123" stroke="#fb923c" stroke-width="1" opacity="0.5"/>
    <line x1="97" y1="112" x2="97" y2="123" stroke="#fb923c" stroke-width="1" opacity="0.5"/>
    <line x1="103" y1="112" x2="103" y2="123" stroke="#fb923c" stroke-width="1" opacity="0.5"/>
    <line x1="111" y1="112" x2="111" y2="123" stroke="#fb923c" stroke-width="1" opacity="0.5"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7.5" font-weight="800" fill="#fb923c" letter-spacing="1">FOOD SERVICE</text>""",

    # Building &amp; Grounds (37) — rake over leaf cluster
    "37": """
    <line x1="100" y1="83" x2="100" y2="127" stroke="#bef264" stroke-width="2.2"/>
    <line x1="81" y1="127" x2="119" y2="127" stroke="#bef264" stroke-width="2.5"/>
    <line x1="87" y1="121" x2="87" y2="127" stroke="#bef264" stroke-width="1.6"/>
    <line x1="94" y1="119" x2="94" y2="127" stroke="#bef264" stroke-width="1.6"/>
    <line x1="100" y1="118" x2="100" y2="127" stroke="#bef264" stroke-width="1.6"/>
    <line x1="106" y1="119" x2="106" y2="127" stroke="#bef264" stroke-width="1.6"/>
    <line x1="113" y1="121" x2="113" y2="127" stroke="#bef264" stroke-width="1.6"/>
    <path d="M87,83 Q79,93 87,104 Q96,93 100,83" fill="#bef264" opacity="0.65"/>
    <path d="M113,83 Q121,93 113,104 Q104,93 100,83" fill="#bef264" opacity="0.65"/>
    <ellipse cx="100" cy="83" rx="5.5" ry="7" fill="#bef264" opacity="0.9"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="8" font-weight="800" fill="#bef264" letter-spacing="1.5">GROUNDS</text>""",

    # Personal Care &amp; Service (39) — figure with heart
    "39": """
    <circle cx="100" cy="90" r="9.5" fill="none" stroke="#fbcfe8" stroke-width="2"/>
    <path d="M83,130 Q83,113 100,113 Q117,113 117,130" fill="none" stroke="#fbcfe8" stroke-width="2"/>
    <path d="M100,107 Q94,102 92,106 Q90,113 100,120 Q110,113 108,106 Q106,102 100,107 Z"
          fill="#fbcfe8" opacity="0.85"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7" font-weight="800" fill="#fbcfe8" letter-spacing="1">PERSONAL CARE</text>""",

    # Sales &amp; Related (41) — rising trend line + dollar sign
    "41": """
    <line x1="73" y1="83" x2="73" y2="128" stroke="#fdba74" stroke-width="1.5" opacity="0.55"/>
    <line x1="71" y1="128" x2="129" y2="128" stroke="#fdba74" stroke-width="1.5" opacity="0.55"/>
    <line x1="73" y1="95" x2="129" y2="95" stroke="#fdba74" stroke-width="0.7" opacity="0.3" stroke-dasharray="3 2"/>
    <line x1="73" y1="108" x2="129" y2="108" stroke="#fdba74" stroke-width="0.7" opacity="0.3" stroke-dasharray="3 2"/>
    <polyline points="77,122 92,108 107,115 123,90" fill="none" stroke="#fdba74" stroke-width="2.5"/>
    <polygon points="123,90 117,96 127,96" fill="#fdba74"/>
    <text x="84" y="101" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="13" font-weight="900" fill="#fdba74" opacity="0.5">$</text>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="8" font-weight="800" fill="#fdba74" letter-spacing="1.5">SALES</text>""",

    # Office &amp; Administrative Support (43) — stacked document tray
    "43": """
    <rect x="80" y="118" width="40" height="12" rx="1" fill="none" stroke="#93c5fd" stroke-width="1.5" opacity="0.45"/>
    <rect x="80" y="107" width="40" height="12" rx="1" fill="none" stroke="#93c5fd" stroke-width="1.8" opacity="0.65"/>
    <rect x="80" y="94" width="40" height="14" rx="1.5" fill="#071428" stroke="#93c5fd" stroke-width="2"/>
    <line x1="85" y1="100" x2="112" y2="100" stroke="#93c5fd" stroke-width="1.4" opacity="0.85"/>
    <line x1="85" y1="104" x2="112" y2="104" stroke="#93c5fd" stroke-width="1.4" opacity="0.85"/>
    <line x1="85" y1="108" x2="103" y2="108" stroke="#93c5fd" stroke-width="1.1" opacity="0.55"/>
    <circle cx="116" cy="101" r="4" fill="none" stroke="#93c5fd" stroke-width="1.5" opacity="0.6"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7" font-weight="800" fill="#93c5fd" letter-spacing="1">ADMIN SUPPORT</text>""",

    # Farming, Fishing &amp; Forestry (45) — wheat sheaf
    "45": """
    <line x1="100" y1="88" x2="100" y2="128" stroke="#d9f99d" stroke-width="2.2"/>
    <path d="M100,97 Q87,90 84,82" fill="none" stroke="#d9f99d" stroke-width="1.8"/>
    <path d="M100,103 Q85,96 81,88" fill="none" stroke="#d9f99d" stroke-width="1.8"/>
    <path d="M100,97 Q113,90 116,82" fill="none" stroke="#d9f99d" stroke-width="1.8"/>
    <path d="M100,103 Q115,96 119,88" fill="none" stroke="#d9f99d" stroke-width="1.8"/>
    <ellipse cx="85" cy="81" rx="4" ry="6.5" fill="#d9f99d" opacity="0.85" transform="rotate(-28 85 81)"/>
    <ellipse cx="115" cy="81" rx="4" ry="6.5" fill="#d9f99d" opacity="0.85" transform="rotate(28 115 81)"/>
    <ellipse cx="80" cy="87" rx="3.5" ry="5.5" fill="#d9f99d" opacity="0.75" transform="rotate(-35 80 87)"/>
    <ellipse cx="120" cy="87" rx="3.5" ry="5.5" fill="#d9f99d" opacity="0.75" transform="rotate(35 120 87)"/>
    <ellipse cx="100" cy="80" rx="5" ry="7.5" fill="#d9f99d" opacity="0.9"/>
    <path d="M83,128 Q100,120 117,128" fill="none" stroke="#d9f99d" stroke-width="2.2" stroke-linecap="round"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="8" font-weight="800" fill="#d9f99d" letter-spacing="1.5">FARMING</text>""",

    # Construction &amp; Extraction (47) — hard hat
    "47": """
    <path d="M74,115 Q74,97 100,91 Q126,97 126,115 Z" fill="none" stroke="#fca5a5" stroke-width="2.2"/>
    <path d="M76,115 Q76,99 100,94 Q124,99 124,115 Z" fill="#fca5a5" opacity="0.12"/>
    <rect x="72" y="115" width="56" height="9" rx="2" fill="none" stroke="#fca5a5" stroke-width="2.5"/>
    <rect x="95" y="83" width="10" height="20" rx="1.5" fill="#fca5a5" opacity="0.85"/>
    <line x1="80" y1="111" x2="80" y2="123" stroke="#fca5a5" stroke-width="1" opacity="0.45"/>
    <line x1="91" y1="107" x2="91" y2="123" stroke="#fca5a5" stroke-width="1" opacity="0.45"/>
    <line x1="109" y1="107" x2="109" y2="123" stroke="#fca5a5" stroke-width="1" opacity="0.45"/>
    <line x1="120" y1="111" x2="120" y2="123" stroke="#fca5a5" stroke-width="1" opacity="0.45"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7" font-weight="800" fill="#fca5a5" letter-spacing="1">CONSTRUCTION</text>""",

    # Installation, Maintenance &amp; Repair (49) — wrench
    "49": """
    <path d="M115,82 Q126,82 126,92 Q126,99 119,101 L89,127 Q84,132 79,130 Q75,128 76,123 Q77,118 83,116 L113,90 Q114,85 115,82 Z"
          fill="none" stroke="#a5b4fc" stroke-width="2.2"/>
    <circle cx="83" cy="124" r="7" fill="none" stroke="#a5b4fc" stroke-width="2"/>
    <circle cx="83" cy="124" r="2.8" fill="#a5b4fc" opacity="0.65"/>
    <circle cx="116" cy="89" r="7" fill="none" stroke="#a5b4fc" stroke-width="2"/>
    <circle cx="116" cy="89" r="2.8" fill="#a5b4fc" opacity="0.65"/>
    <line x1="110" y1="94" x2="90" y2="114" stroke="#a5b4fc" stroke-width="3" opacity="0.25"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7" font-weight="800" fill="#a5b4fc" letter-spacing="1">MAINTENANCE</text>""",

    # Production (51) — precision gear / cog
    "51": """
    <circle cx="100" cy="107" r="16" fill="none" stroke="#fcd34d" stroke-width="2.5"/>
    <circle cx="100" cy="107" r="6.5" fill="none" stroke="#fcd34d" stroke-width="2"/>
    <circle cx="100" cy="107" r="2.8" fill="#fcd34d" opacity="0.55"/>
    <rect x="97" y="85" width="6" height="9" rx="1" fill="#fcd34d" opacity="0.85"/>
    <rect x="97" y="120" width="6" height="9" rx="1" fill="#fcd34d" opacity="0.85"/>
    <rect x="78" y="104" width="9" height="6" rx="1" fill="#fcd34d" opacity="0.85"/>
    <rect x="113" y="104" width="9" height="6" rx="1" fill="#fcd34d" opacity="0.85"/>
    <rect x="82" y="88" width="9" height="6" rx="1" fill="#fcd34d" opacity="0.7" transform="rotate(45 86.5 91)"/>
    <rect x="110" y="88" width="9" height="6" rx="1" fill="#fcd34d" opacity="0.7" transform="rotate(-45 114.5 91)"/>
    <rect x="82" y="116" width="9" height="6" rx="1" fill="#fcd34d" opacity="0.7" transform="rotate(-45 86.5 119)"/>
    <rect x="110" y="116" width="9" height="6" rx="1" fill="#fcd34d" opacity="0.7" transform="rotate(45 114.5 119)"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7.5" font-weight="800" fill="#fcd34d" letter-spacing="1">PRODUCTION</text>""",

    # Transportation &amp; Material Moving (53) — steering wheel
    "53": """
    <circle cx="100" cy="108" r="23" fill="none" stroke="#67e8f9" stroke-width="2.5"/>
    <circle cx="100" cy="108" r="8.5" fill="none" stroke="#67e8f9" stroke-width="2"/>
    <circle cx="100" cy="108" r="3" fill="#67e8f9" opacity="0.5"/>
    <line x1="100" y1="85" x2="100" y2="99.5" stroke="#67e8f9" stroke-width="2.5"/>
    <line x1="100" y1="116.5" x2="100" y2="131" stroke="#67e8f9" stroke-width="2.5"/>
    <line x1="77" y1="108" x2="91.5" y2="108" stroke="#67e8f9" stroke-width="2.5"/>
    <line x1="108.5" y1="108" x2="123" y2="108" stroke="#67e8f9" stroke-width="2.5"/>
    <line x1="83" y1="91" x2="93" y2="101" stroke="#67e8f9" stroke-width="2" opacity="0.65"/>
    <line x1="117" y1="91" x2="107" y2="101" stroke="#67e8f9" stroke-width="2" opacity="0.65"/>
    <line x1="83" y1="125" x2="93" y2="115" stroke="#67e8f9" stroke-width="2" opacity="0.65"/>
    <line x1="117" y1="125" x2="107" y2="115" stroke="#67e8f9" stroke-width="2" opacity="0.65"/>
    <text x="100" y="76" text-anchor="middle" font-family="Arial,sans-serif"
          font-size="7" font-weight="800" fill="#67e8f9" letter-spacing="1">TRANSPORT</text>""",
}


def _render_placement(*, client, browse_mode: bool) -> None:
    """BOTTOM — Sector Placement: high-resolution SVG notary seals + latest verified logic strip."""
    st.markdown('<p class="sal-stack-label">Bottom &middot; Sector Placement</p>', unsafe_allow_html=True)
    st.markdown("#### Sector Placement \u2014 sector authority & verified access")
    st.markdown("##### Federal sector authority seals")
    st.caption("High-resolution institutional notary seals \u2014 click to open the matching O\u2217NET folder in the Bureau")

    sectors = [
        ("13", "Finance",    "#060e1d", "#93c5fd", "#bfdbfe", "sal_badge_finance"),
        ("15", "Technology", "#060f36", "#3b5bdb", "#bfdbfe", "sal_badge_tech"),
        ("29", "Healthcare", "#07211e", "#0d9488", "#5ee8c8", "sal_badge_health"),
    ]
    s1, s2, s3 = st.columns(3)
    for col, (code, title, bg, ring, accent, uid) in zip((s1, s2, s3), sectors):
        with col:
            svg_code = _notary_seal_svg(code, title, bg, ring, accent, _SEAL_ICONS.get(code, ""))
            st.markdown(
                f'<div style="display:flex;flex-direction:column;align-items:center;margin-bottom:0.4rem;">'
                f'{svg_code}</div>',
                unsafe_allow_html=True,
            )
            if st.button(f"Open [{code}] in Bureau", key=uid, use_container_width=True, type="primary"):
                st.session_state["active_prefix"] = code

    st.markdown("##### Latest verified logic")
    st.caption("Quick-access strip \u00b7 authenticated logic records \u00b7 opens in the specification view")
    latest = fetch_latest_verified_logic(client, demo_mode=browse_mode, limit=12)
    if not latest:
        st.info("No verified logic rows to display.")
    else:
        chunk = 6
        for start in range(0, min(len(latest), 12), chunk):
            batch = latest[start: start + chunk]
            cols = st.columns(len(batch))
            for col, item in zip(cols, batch):
                with col:
                    soc = str(item.get("soc_code") or "")
                    tit = str(item.get("title") or soc)
                    label = tit if len(tit) <= 40 else tit[:37] + "\u2026"
                    if st.button(label, key=f"lv_{start}_{soc}", use_container_width=True, help=soc):
                        st.session_state["active_soc"] = soc


# ── Three-column helpers ─────────────────────────────────────────────────────

def _wm_bg_url(opacity: float) -> str:
    """Tiling diagonal watermark text — plain rgba() so it renders in Chrome CSS background-image."""
    c = f"rgba(11,42,111,{opacity})"
    svg = (
        "<svg xmlns='http://www.w3.org/2000/svg' width='340' height='80'>"
        "<defs>"
        "<pattern id='p' x='0' y='0' width='340' height='80' "
        "patternUnits='userSpaceOnUse' patternTransform='rotate(-28)'>"
        # Primary stamp line
        f"<text x='170' y='52' text-anchor='middle' "
        f"font-family='Arial Black,Arial,sans-serif' font-size='12' font-weight='900' "
        f"fill='{c}' letter-spacing='3.5'>SAL \u00b7 OFFICIAL SOURCE OF TRUTH</text>"
        # Ghost echo line (offset, lighter) for ink-bleed simulation
        f"<text x='171.4' y='53.4' text-anchor='middle' "
        f"font-family='Arial Black,Arial,sans-serif' font-size='12' font-weight='900' "
        f"fill='rgba(11,42,111,{round(opacity*0.35,4)})' letter-spacing='3.5'>"
        "SAL \u00b7 OFFICIAL SOURCE OF TRUTH</text>"
        "</pattern>"
        "</defs>"
        "<rect width='100%' height='100%' fill='url(%23p)'/>"
        "</svg>"
    )
    b64 = base64.b64encode(svg.encode("utf-8")).decode()
    return f"data:image/svg+xml;base64,{b64}"


def _stamp_bg_url(opacity: float = 0.13) -> str:
    """Large rotated 'OFFICIAL · SOURCE OF TRUTH' notary stamp — plain rgba(), no SVG filter."""
    c  = f"rgba(11,42,111,{opacity})"
    cl = f"rgba(11,42,111,{round(opacity*0.55,4)})"
    svg = (
        "<svg xmlns='http://www.w3.org/2000/svg' width='520' height='240'>"
        # Rotate the entire stamp group around the SVG centre
        "<g transform='rotate(-28,260,120)'>"
        # Outer double border
        f"<rect x='20' y='30' width='430' height='168' rx='4' fill='none' stroke='{c}' stroke-width='6.5'/>"
        f"<rect x='28' y='38' width='414' height='152' rx='2' fill='none' stroke='{cl}' stroke-width='1.8'/>"
        # Top ornament stars
        f"<text x='235' y='72' text-anchor='middle' "
        f"font-family='Arial,sans-serif' font-size='11' fill='{c}' letter-spacing='7'>"
        "\u2605 \u2605 \u2605 \u2605 \u2605</text>"
        # OFFICIAL — bold display text
        f"<text x='235' y='122' text-anchor='middle' "
        f"font-family='Arial Black,Arial,sans-serif' font-size='44' font-weight='900' "
        f"fill='{c}' letter-spacing='8'>OFFICIAL</text>"
        # Divider rules
        f"<line x1='35' y1='132' x2='162' y2='132' stroke='{c}' stroke-width='2.6'/>"
        f"<line x1='308' y1='132' x2='435' y2='132' stroke='{c}' stroke-width='2.6'/>"
        # SOURCE OF TRUTH — subtitle
        f"<text x='235' y='162' text-anchor='middle' "
        f"font-family='Arial,sans-serif' font-size='14' font-weight='800' "
        f"fill='{c}' letter-spacing='6'>SOURCE OF TRUTH</text>"
        # Bottom ornament
        f"<text x='235' y='186' text-anchor='middle' "
        f"font-family='Arial,sans-serif' font-size='9' fill='{cl}' letter-spacing='5'>"
        "STANDARD AGENT LOGIC \u00b7 REGISTRY</text>"
        "</g>"
        "</svg>"
    )
    b64 = base64.b64encode(svg.encode("utf-8")).decode()
    return f"data:image/svg+xml;base64,{b64}"


def _truth_diagonal_stamp_url() -> str:
    """Diagonal OFFICIAL SOURCE OF TRUTH — dark grey, −30°, serif (zone behind Sectors/Seals)."""
    c = "#3f3f46"
    svg = (
        "<svg xmlns='http://www.w3.org/2000/svg' width='880' height='560'>"
        "<g transform='rotate(-30 440 280)'>"
        "<text x='440' y='292' text-anchor='middle' "
        "font-family=\"Georgia, 'Times New Roman', Times, serif\" "
        "font-size='30' font-weight='700' "
        f"fill='{c}' fill-opacity='0.88' letter-spacing='0.14em'>"
        "OFFICIAL SOURCE OF TRUTH</text>"
        "</g></svg>"
    )
    b64 = base64.b64encode(svg.encode("utf-8")).decode()
    return f"data:image/svg+xml;base64,{b64}"


_SAL_GREAT_SEAL_PATH = _REPO_ROOT / "assets" / "SAL_GREAT_SEAL.png"


@st.cache_data(show_spinner=False)
def _great_seal_data_uri() -> str:
    """Single source: assets/SAL_GREAT_SEAL.png only (no fallbacks)."""
    path = _SAL_GREAT_SEAL_PATH
    if not path.is_file():
        raise FileNotFoundError(
            "Missing assets/SAL_GREAT_SEAL.png — add the seal raster to the assets folder."
        )
    raw = path.read_bytes()
    b64 = base64.b64encode(raw).decode("ascii")
    return f"data:image/png;base64,{b64}"


def _bright_outlook_svg() -> str:
    """Official agency-readout bar chart — all 22 SOC divisions, full-width, dark header."""
    groups = [
        ("MGMT",  "11", 72, 58),
        ("FIN",   "13", 80, 64),
        ("TECH",  "15", 88, 76),
        ("ENG",   "17", 70, 55),
        ("SCI",   "19", 74, 61),
        ("COMM",  "21", 58, 44),
        ("LEGAL", "23", 78, 62),
        ("EDU",   "25", 62, 49),
        ("ARTS",  "27", 55, 38),
        ("HLTH",  "29", 82, 70),
        ("SUPP",  "31", 68, 52),
        ("PROT",  "33", 65, 48),
        ("FOOD",  "35", 48, 32),
        ("GRND",  "37", 42, 28),
        ("CARE",  "39", 52, 38),
        ("SALE",  "41", 60, 42),
        ("ADMN",  "43", 65, 45),
        ("FARM",  "45", 45, 31),
        ("CNST",  "47", 56, 40),
        ("MECH",  "49", 61, 44),
        ("PROD",  "51", 52, 36),
        ("TRAN",  "53", 55, 38),
    ]
    W, H = 1100, 270
    lp, rp, tp, bp = 38, 12, 72, 46   # chart margins
    cw = W - lp - rp
    ch = H - tp - bp
    mono = "font-family='Courier New,Lucida Console,monospace'"
    sans = "font-family='Arial,sans-serif'"
    p: list[str] = []

    # ── Background & outer border ──────────────────────────────────────────
    p.append(f"<rect width='{W}' height='{H}' fill='#f4f7ff' rx='2'/>")
    p.append(f"<rect width='{W}' height='{H}' fill='none' stroke='#b8caf8' stroke-width='1' rx='2'/>")

    # ── Dark header bar ────────────────────────────────────────────────────
    p.append(f"<rect x='0' y='0' width='{W}' height='30' fill='#071540' rx='2'/>")
    p.append(f"<rect x='0' y='27' width='{W}' height='3' fill='#1d4ed8'/>")
    p.append(f"<text x='8' y='18' {mono} font-size='8' font-weight='700' fill='#93c5fd' letter-spacing='1'>DOL/O\u2217NET</text>")
    p.append(f"<text x='{W//2}' y='18' text-anchor='middle' {mono} font-size='9' font-weight='700' fill='#ffffff' letter-spacing='2'>BRIGHT OUTLOOK INDEX</text>")
    p.append(f"<text x='{W-8}' y='18' text-anchor='end' {mono} font-size='7.5' fill='#60a5fa'>FY2026</text>")

    # ── Stat pills row (between header bar and chart) ──────────────────────
    pill_y = 34
    pills = [
        ("1,095", "VERIFIED ROLES",  W * 0.18),
        ("88%",   "TOP SECTOR · TECH", W * 0.50),
        ("847",   "BRIGHT OUTLOOK ROLES", W * 0.82),
    ]
    for val, label, px in pills:
        p.append(f"<rect x='{px-38:.0f}' y='{pill_y}' width='76' height='28' rx='2' fill='rgba(11,42,111,0.06)' stroke='#c7d7fd' stroke-width='0.8'/>")
        p.append(f"<text x='{px:.0f}' y='{pill_y+13}' text-anchor='middle' {mono} font-size='11' font-weight='900' fill='#0b2a6f'>{val}</text>")
        p.append(f"<text x='{px:.0f}' y='{pill_y+24}' text-anchor='middle' {mono} font-size='5.5' fill='#64748b' letter-spacing='0.8'>{label}</text>")

    # ── Y-axis grid lines + percentage labels ──────────────────────────────
    for pct in [0, 25, 50, 75, 100]:
        y = tp + ch - (pct / 100) * ch
        dash = "stroke-dasharray='4 3'" if pct > 0 else ""
        clr  = "#c7d7fd" if pct > 0 else "#0b2a6f"
        sw   = "0.8"     if pct > 0 else "1.3"
        p.append(f"<line x1='{lp}' y1='{y:.1f}' x2='{W-rp}' y2='{y:.1f}' stroke='{clr}' stroke-width='{sw}' {dash}/>")
        p.append(f"<text x='{lp-4}' y='{y+3:.1f}' text-anchor='end' {mono} font-size='7' fill='#475569'>{pct}%</text>")

    # ── Y-axis spine ───────────────────────────────────────────────────────
    p.append(f"<line x1='{lp}' y1='{tp}' x2='{lp}' y2='{tp+ch}' stroke='#0b2a6f' stroke-width='1.4'/>")

    # ── Bars + value labels + X-axis labels ───────────────────────────────
    n   = len(groups)
    gw  = cw / n
    bw  = gw * 0.28

    for i, (label, soc, forecast, bright) in enumerate(groups):
        xc = lp + (i + 0.5) * gw
        fh = (forecast / 100) * ch
        bh = (bright / 100) * ch

        # Forecast bar (navy)
        fx = xc - bw - 1.5
        fy = tp + ch - fh
        p.append(f"<rect x='{fx:.1f}' y='{fy:.1f}' width='{bw:.1f}' height='{fh:.1f}' fill='#1d4ed8' opacity='0.9' rx='1'/>")
        p.append(f"<text x='{fx + bw/2:.1f}' y='{fy - 4:.1f}' text-anchor='middle' {mono} font-size='7.5' font-weight='700' fill='#1d4ed8'>{forecast}</text>")

        # Bright Outlook bar (sky)
        bx = xc + 1.5
        by = tp + ch - bh
        p.append(f"<rect x='{bx:.1f}' y='{by:.1f}' width='{bw:.1f}' height='{bh:.1f}' fill='#38bdf8' opacity='0.78' rx='1'/>")
        p.append(f"<text x='{bx + bw/2:.1f}' y='{by - 4:.1f}' text-anchor='middle' {mono} font-size='7.5' font-weight='700' fill='#0ea5e9'>{bright}</text>")

        # Tick mark on X-axis
        p.append(f"<line x1='{xc:.1f}' y1='{tp+ch}' x2='{xc:.1f}' y2='{tp+ch+3}' stroke='#0b2a6f' stroke-width='0.9'/>")
        # Sector short code
        p.append(f"<text x='{xc:.1f}' y='{tp+ch+13}' text-anchor='middle' {mono} font-size='7.5' font-weight='800' fill='#0b2a6f'>{label}</text>")
        # SOC prefix
        p.append(f"<text x='{xc:.1f}' y='{tp+ch+24}' text-anchor='middle' {mono} font-size='6' fill='#64748b'>{soc}</text>")

    # ── Legend ─────────────────────────────────────────────────────────────
    lx, ly = lp + 2, tp + 8
    p.append(f"<rect x='{lx}' y='{ly}' width='10' height='7' fill='#1d4ed8' opacity='0.9' rx='1'/>")
    p.append(f"<text x='{lx+14}' y='{ly+6.5}' {mono} font-size='7' fill='#334155'>FORECAST</text>")
    p.append(f"<rect x='{lx+82}' y='{ly}' width='10' height='7' fill='#38bdf8' opacity='0.78' rx='1'/>")
    p.append(f"<text x='{lx+96}' y='{ly+6.5}' {mono} font-size='7' fill='#334155'>BRIGHT OUTLOOK</text>")

    # ── Classification footer ──────────────────────────────────────────────
    p.append(f"<rect x='0' y='{H-18}' width='{W}' height='18' fill='rgba(7,21,64,0.07)'/>")
    p.append(f"<text x='{W//2}' y='{H-6}' text-anchor='middle' {mono} font-size='6' fill='#64748b' letter-spacing='1.2'>O\u2217NET SOC DATA \u00b7 SAL REGISTRY \u00b7 UNCLASSIFIED</text>")

    svg_str = (
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}">'
        f'{"".join(p)}</svg>'
    )
    b64 = base64.b64encode(svg_str.encode("utf-8")).decode()
    return (
        f'<img src="data:image/svg+xml;base64,{b64}" '
        f'style="display:block;width:100%;height:auto;border:1px solid #b8caf8;'
        f'border-radius:3px;margin-top:0.4rem" alt="Sector Performance Readout"/>'
    )


def _render_col_bureau(*, client, browse_mode: bool, counts: dict) -> None:
    """Left column (1.0): O*NET SOC Folder Tree — 22 divisions, collapsible.
    Federal Ledger removed. Tree is the primary role-selection interface.
    """
    # engine-anchor → tree expander + folder row CSS targets this column
    st.markdown('<div class="sal-col-engine-anchor"></div>', unsafe_allow_html=True)

    # Filing-cabinet manifest header
    st.markdown(
        '<div class="sal-filing-hdr">'
        '<span class="sal-filing-hdr-code">DOL/O\u2217NET \u00b7 SAL</span>'
        '<span>FEDERAL LABOR REGISTRY \u2014 SOC FILING CABINET</span>'
        '<span class="sal-filing-hdr-count">22 DIVISIONS \u00b7 1,095 RECORDS</span>'
        '</div>',
        unsafe_allow_html=True,
    )
    query = st.text_input(
        "Filter records", key="sal_bureau_filter",
        placeholder="\u25b6 FILTER RECORDS\u2026",
        label_visibility="collapsed",
    )
    vault_only = bool(st.session_state.get("vault_only", False))
    with st.expander(
        "\U0001f5c2\ufe0f  O\u2217NET SOC FOLDER TREE \u2014 DIVISIONS",
        expanded=True,
    ):
        _render_file_tree_panel(
            supabase_url=_resolve_supabase_url(),
            supabase_key=_resolve_supabase_key(),
            query=query,
            vault_only=vault_only,
            demo_mode=browse_mode,
            button_key_prefix="bureau_",
        )


# Unified sector seals — single source of truth for all sector access
# Each entry: (soc_prefix, label, seal_bg, ring_color, accent_color)
_UNIFIED_SEALS = [
    # Row 1 — SOC 11–21
    ("11", "Management",   "#0d1130", "#7c3aed", "#c4b5fd"),
    ("13", "Finance",      "#060e1d", "#1d4ed8", "#93c5fd"),
    ("15", "Technology",   "#060f36", "#6d28d9", "#c4b5fd"),
    ("17", "Engineering",  "#120b08", "#b45309", "#fbbf24"),
    ("19", "Science",      "#071a10", "#15803d", "#86efac"),
    ("21", "Community",    "#1a0b24", "#7e22ce", "#d8b4fe"),
    # Row 2 — SOC 23–33
    ("23", "Legal",        "#160f02", "#92400e", "#fcd34d"),
    ("25", "Education",    "#051228", "#0369a1", "#7dd3fc"),
    ("27", "Arts & Media", "#1a0820", "#be185d", "#f9a8d4"),
    ("29", "Healthcare",   "#07211e", "#0d9488", "#5ee8c8"),
    ("31", "Hlth Support", "#051a14", "#047857", "#6ee7b7"),
    ("33", "Protective",   "#0a0e02", "#4d7c0f", "#a3e635"),
    # Row 3 — SOC 35–45
    ("35", "Food Service", "#1f0c00", "#c2410c", "#fb923c"),
    ("37", "Grounds",      "#0a1700", "#3f6212", "#bef264"),
    ("39", "Personal Care","#1f0616", "#9d174d", "#fbcfe8"),
    ("41", "Sales",        "#1a0b00", "#b45309", "#fdba74"),
    ("43", "Admin",        "#071428", "#1e40af", "#93c5fd"),
    ("45", "Farming",      "#0e1400", "#365314", "#d9f99d"),
    # Row 4 — SOC 47–53
    ("47", "Construction", "#180800", "#991b1b", "#fca5a5"),
    ("49", "Maintenance",  "#0f1018", "#3730a3", "#a5b4fc"),
    ("51", "Production",   "#110805", "#78350f", "#fcd34d"),
    ("53", "Transport",    "#030e1e", "#0e7490", "#67e8f9"),
]


def render_unified_seals() -> None:
    """All 22 SOC division seals — rendered in 4 rows (6 · 6 · 6 · 4).
    Replaces both render_sector_tiles() + render_notary_seals() — no duplicate rows.
    Clicking sets active_prefix + jumps active_soc to first matching role.
    """
    # Pre-chunked rows matching _UNIFIED_SEALS comment structure
    row_sizes = [6, 6, 6, 4]
    idx = 0
    for row_n, rsize in enumerate(row_sizes):
        row_seals = _UNIFIED_SEALS[idx: idx + rsize]
        idx += rsize
        if not row_seals:
            break
        cols = st.columns(len(row_seals), gap="small")
        for col, (code, label, bg, ring, accent) in zip(cols, row_seals):
            is_active = st.session_state.get("active_prefix") == code
            icon = _SEAL_ICONS.get(code, "")
            svg  = _notary_seal_svg(code, label, bg, ring, accent, icon)
            # Scale seal to 105px — detailed enough to appreciate the inner icons
            svg_sm = svg.replace('width="190" height="190"', 'width="105" height="105"')
            # Active glow ring
            ring_style = (
                f"box-shadow:0 0 0 2px {accent},0 0 8px {accent}55;"
                f"border-radius:50%;display:inline-block;"
            ) if is_active else "border-radius:50%;display:inline-block;"
            with col:
                st.markdown(
                    f'<div style="text-align:center;padding:0.1rem 0">'
                    f'<span style="{ring_style}">{svg_sm}</span>'
                    f'</div>',
                    unsafe_allow_html=True,
                )
                if st.button(
                    f"{'▶ ' if is_active else ''}{label}",
                    key=f"unified_seal_{code}",
                    use_container_width=True,
                    type="primary" if is_active else "secondary",
                ):
                    st.session_state["active_prefix"] = code
                    first = next(
                        (r["soc_code"] for r in _MOCK_REGISTRY
                         if str(r.get("soc_code", "")).startswith(f"{code}-")),
                        None,
                    )
                    if first:
                        st.session_state["active_soc"] = first
        # thin rule between rows for breathing room
        if row_n < len(row_sizes) - 1:
            st.markdown(
                '<hr style="margin:0.25rem 0;border:none;border-top:1px solid #dde4f444"/>',
                unsafe_allow_html=True,
            )


# ── AI Displacement Sales Floor ─────────────────────────────────────────────
_AI_DISPLACEMENT = [
    # (soc_prefix, label, pct_automatable, risk_tier, key_technologies)
    ("43", "Admin & Office",   73, "CRITICAL", "NLP · RPA · Document AI"),
    ("53", "Transport",        70, "CRITICAL", "Autonomous Vehicles · Route AI"),
    ("51", "Production",       67, "CRITICAL", "Robotics · Computer Vision"),
    ("35", "Food Service",     61, "HIGH",     "Automation · AI Kiosks"),
    ("41", "Sales",            59, "HIGH",     "Conversational AI · CRM AI"),
    ("37", "Grounds",          54, "HIGH",     "Autonomous Equipment"),
    ("45", "Farming",          52, "HIGH",     "Precision Ag · Drone AI"),
    ("47", "Construction",     48, "HIGH",     "BIM AI · Autonomous Machinery"),
    ("23", "Legal",            44, "MEDIUM",   "LLM · Contract AI · eDiscovery"),
    ("49", "Maintenance",      44, "MEDIUM",   "Predictive AI · IoT Sensors"),
    ("25", "Education",        36, "MEDIUM",   "Adaptive Learning · AI Tutors"),
    ("13", "Finance",          35, "MEDIUM",   "Quant Models · Robo-Advisors"),
    ("31", "Hlth Support",     34, "MEDIUM",   "Care Robots · EHR AI"),
    ("39", "Personal Care",    32, "MEDIUM",   "Social Robots · Wearable AI"),
    ("27", "Arts & Media",     31, "MEDIUM",   "GenAI · Image Synthesis"),
    ("33", "Protective",       28, "LOW",      "Surveillance AI · Predictive Policing"),
    ("21", "Community",        22, "LOW",      "Mental Health AI · Case Mgmt AI"),
    ("17", "Engineering",      21, "LOW",      "Generative Design · CAE AI"),
    ("19", "Science",          21, "LOW",      "Lab Automation · ML Models"),
    ("29", "Healthcare",       18, "LOW",      "Diagnostic AI · Medical Imaging"),
    ("15", "Technology",       16, "LOW",      "AI Co-pilot (augment, not replace)"),
    ("11", "Management",       12, "MINIMAL",  "Decision Support AI · Analytics"),
]

_RISK_COLORS = {
    "CRITICAL": ("#7f1d1d", "#fca5a5", "#dc2626"),  # bg, text, bar
    "HIGH":     ("#78350f", "#fcd34d", "#d97706"),
    "MEDIUM":   ("#1e3a5f", "#93c5fd", "#3b82f6"),
    "LOW":      ("#14532d", "#86efac", "#16a34a"),
    "MINIMAL":  ("#1e1b4b", "#c4b5fd", "#7c3aed"),
}

def _render_ai_sales_floor() -> None:
    """AI Displacement Sales Floor — full-width sector cards sorted by automation risk."""
    st.markdown(
        '<div class="sal-sector-divider" style="margin-top:0.5rem">'
        '<span>&#9889;&nbsp;AI&nbsp;DISPLACEMENT&nbsp;SALES&nbsp;FLOOR&nbsp;&#9889;</span>'
        '<span style="font-size:0.6rem;opacity:0.7;margin-left:1rem">'
        'SECTORS RANKED BY AUTOMATION EXPOSURE &nbsp;&#9670;&nbsp; CLICK TO BROWSE</span>'
        '</div>',
        unsafe_allow_html=True,
    )
    cols_per_row = 4
    for row_start in range(0, len(_AI_DISPLACEMENT), cols_per_row):
        chunk = _AI_DISPLACEMENT[row_start : row_start + cols_per_row]
        cols  = st.columns(len(chunk), gap="small")
        for col, (prefix, label, pct, risk, tech) in zip(cols, chunk):
            bg, txt, bar = _RISK_COLORS.get(risk, ("#071540", "#93c5fd", "#1d4ed8"))
            bar_w = pct  # percentage width
            with col:
                st.markdown(
                    f'<div style="background:{bg};border:1px solid {bar}44;border-radius:6px;'
                    f'padding:0.7rem 0.75rem 0.6rem;cursor:pointer;position:relative;overflow:hidden;">'
                    # progress bar strip at bottom
                    f'<div style="position:absolute;bottom:0;left:0;height:3px;'
                    f'width:{bar_w}%;background:{bar};border-radius:0 0 0 6px;"></div>'
                    # risk badge
                    f'<div style="font-family:\'Courier New\',monospace;font-size:0.52rem;'
                    f'font-weight:800;color:{bar};letter-spacing:0.12em;margin-bottom:0.25rem">'
                    f'{risk}</div>'
                    # sector label
                    f'<div style="font-weight:800;font-size:0.82rem;color:{txt};'
                    f'line-height:1.2;margin-bottom:0.2rem">{escape(label)}</div>'
                    # big pct
                    f'<div style="font-family:\'Courier New\',monospace;font-size:1.6rem;'
                    f'font-weight:900;color:{bar};line-height:1;margin-bottom:0.2rem">'
                    f'{pct}<span style="font-size:0.7rem;font-weight:600">%</span></div>'
                    f'<div style="font-size:0.55rem;color:{txt}99;line-height:1.3">'
                    f'{escape(tech)}</div>'
                    f'</div>',
                    unsafe_allow_html=True,
                )
                # Invisible Streamlit button to open the sector in the tree
                if st.button(f"Browse {label}", key=f"ai_floor_{prefix}",
                             use_container_width=True, type="secondary"):
                    st.session_state["active_sector_filter"] = prefix


def _render_col_authority(*, client, browse_mode: bool) -> None:
    """Full-width: Search (greeting) → AI Sales Floor → Sector Seals → SOC Tree."""
    st.markdown(
        '<div class="sal-col-authority-anchor"></div>'
        '<div class="sal-authority-stamp-layer" aria-hidden="true"></div>',
        unsafe_allow_html=True,
    )

    # ── SAL Command Interface — greeting at the top ───────────────────────────
    _vault_active = bool(st.session_state.get("vault_only", False))
    _scope_label  = "PRIVATE VAULT \u25c6 RESTRICTED" if _vault_active else "GLOBAL REGISTRY \u25c6 1,095 ROLES"
    _scope_color  = "#c4b5fd" if _vault_active else "#93c5fd"
    st.markdown(
        f'<div class="sal-search-anchor"></div>'
        f'<div class="sal-cmd-hdr">'
        f'  <span class="sal-cmd-live-dot"></span>'
        f'  <span class="sal-cmd-live-txt">LIVE</span>'
        f'  <span class="sal-cmd-sep">\u00b7</span>'
        f'  <span class="sal-cmd-title">SAL\u00a0COMMAND\u00a0INTERFACE</span>'
        f'  <span class="sal-cmd-sep">\u00b7</span>'
        f'  <span class="sal-cmd-stat">22\u00a0DIVISIONS</span>'
        f'  <span class="sal-cmd-sep">\u25c6</span>'
        f'  <span style="color:{_scope_color};font-weight:700">{_scope_label}</span>'
        f'  <span class="sal-cmd-sep">\u25c6</span>'
        f'  <span class="sal-cmd-stat">O\u2217NET\u00a0FEDERAL\u00a0REGISTRY</span>'
        f'</div>'
        f'<div class="sal-cmd-prompt">'
        f'  <span class="sal-cmd-caret">\u25b8</span>'
        f'  <span>ENTER QUERY \u2014 job\u00a0title\u00a0\u00b7\u00a0SOC\u00a0code\u00a0\u00b7\u00a0skill\u00a0\u00b7\u00a0natural\u00a0language\u00a0\u00b7\u00a0capability</span>'
        f'</div>',
        unsafe_allow_html=True,
    )
    query = st.text_input(
        "SAL Command Interface",
        key="sal_unified_query",
        placeholder="e.g. \u201cFind me a data scientist with ML skills\u201d or \u201c15-1252\u201d or \u201cBright Outlook roles in healthcare\u201d\u2026",
        label_visibility="collapsed",
    )
    search_btn = st.button(
        "\u26a1\u00a0\u00a0DISPATCH\u00a0TO\u00a0REGISTRY",
        type="primary",
        use_container_width=True,
        key="sal_search_btn",
    )
    # Quick-action chip bar
    st.markdown(
        '<div class="sal-cmd-chips">'
        '  <span class="sal-chip">\u25c8\u00a0BY\u00a0TITLE</span>'
        '  <span class="sal-chip">\u25c8\u00a0SOC\u00a0CODE</span>'
        '  <span class="sal-chip sal-chip-bright">\u2605\u00a0BRIGHT\u00a0OUTLOOK</span>'
        '  <span class="sal-chip">\u25c8\u00a0BY\u00a0SKILL</span>'
        '  <span class="sal-chip">\u25c8\u00a0BY\u00a0SECTOR</span>'
        '  <span class="sal-chip">\u25c8\u00a0BUNDLE\u00a0EXPORT</span>'
        '  <span class="sal-chip sal-chip-vault">\u25c8\u00a0VAULT\u00a0ACCESS</span>'
        '</div>',
        unsafe_allow_html=True,
    )
    if search_btn and query.strip():
        vault_only = bool(st.session_state.get("vault_only", False))
        reply = sal_intent_hub_reply(
            client=client, user_request=query.strip(),
            vault_only=vault_only, demo_mode=browse_mode,
        )
        st.session_state["sal_hub_last_reply"] = str(reply.get("message") or "")
        if reply.get("selected_soc"):
            st.session_state["active_soc"] = str(reply["selected_soc"])
    last = st.session_state.get("sal_hub_last_reply")
    if last:
        # Bug 2 fix: escape raw text first, then promote **bold** and `code` to HTML
        _raw_last = str(last)[:400]
        _esc_last  = escape(_raw_last)
        _esc_last  = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', _esc_last)
        _esc_last  = re.sub(
            r'`([^`]+)`',
            r'<code style="font-size:0.67rem;background:#071540;color:#93c5fd;'
            r'padding:0.1rem 0.3rem;border-radius:2px">\1</code>',
            _esc_last,
        )
        st.markdown(
            f'<div class="sal-cmd-transmission">'
            f'  <span class="sal-cmd-transmission-hdr">'
            f'    \u25c6 TRANSMISSION\u00a0RECEIVED\u00a0\u00b7\u00a0SAL\u00a0REGISTRY\u00a0RESPONSE'
            f'  </span>'
            f'  {_esc_last}'
            f'</div>',
            unsafe_allow_html=True,
        )

    # ── AI Displacement Sales Floor ───────────────────────────────────────────
    _render_ai_sales_floor()

    # ── Sector Quick Access Seals ─────────────────────────────────────────────
    st.markdown(
        '<div class="sal-sector-divider"><span>SECTOR&nbsp;QUICK&nbsp;ACCESS</span></div>',
        unsafe_allow_html=True,
    )
    render_unified_seals()

    # ── O*NET SOC Directory — engine anchor for CSS ───────────────────────
    st.markdown('<div class="sal-col-engine-anchor"></div>', unsafe_allow_html=True)
    st.markdown(
        '<div class="sal-dir-rule">'
        '<span>O\u2217NET SOC DIRECTORY</span>'
        '<span class="sal-dir-count">22 DIVISIONS \u00b7 1,095 ROLES</span>'
        '</div>',
        unsafe_allow_html=True,
    )

    # Bug 1 fix: "LOADED" feedback bar — always visible at tree level
    _active_soc_fb = str(st.session_state.get("active_soc") or "")
    if _active_soc_fb:
        _fb_row   = next(
            (r for r in _MOCK_REGISTRY if str(r.get("soc_code", "")) == _active_soc_fb),
            None,
        )
        _fb_title = (_fb_row or {}).get("title", _active_soc_fb)
        st.markdown(
            f'<div class="sal-tree-loaded">'
            f'  <span class="sal-tree-loaded-dot"></span>'
            f'  <span class="sal-tree-loaded-label">SPEC\u00a0LOADED</span>'
            f'  <span class="sal-tree-loaded-title">{escape(str(_fb_title))}</span>'
            f'  <code class="sal-tree-loaded-soc">{escape(_active_soc_fb)}</code>'
            f'</div>',
            unsafe_allow_html=True,
        )

    # Bug 4 fix: active query filter pill — reminds user what is being filtered
    if query.strip():
        st.markdown(
            f'<div class="sal-tree-filter">'
            f'  <span>\u25c8\u00a0FILTERING:</span>'
            f'  <span class="sal-tree-filter-q">"{escape(query.strip())}"</span>'
            f'  <span class="sal-tree-filter-hint">\u2014 clear search to show all 1,095 roles</span>'
            f'</div>',
            unsafe_allow_html=True,
        )

    vault_only = bool(st.session_state.get("vault_only", False))
    _render_file_tree_panel(
        supabase_url=_resolve_supabase_url(),
        supabase_key=_resolve_supabase_key(),
        query=query,
        vault_only=vault_only,
        demo_mode=browse_mode,
        button_key_prefix="engine_",
    )

def _render_col_engine(*, client, browse_mode: bool) -> None:
    """Right column (1.2): Logic Specification card — reserved for active role details.
    Green Glow clearance badge + SAL Verified seal + dark terminal JSON block.
    """
    # ── Spec panel anchor — scroll target when a role is clicked ─────────────
    st.markdown('<div id="sal-spec-panel" class="sal-col-engine-right-anchor"></div>', unsafe_allow_html=True)

    # ── Auto-scroll DOWN to spec when a new role is selected ─────────────────
    _cur_soc  = str(st.session_state.get("active_soc") or "")
    _prev_soc = str(st.session_state.get("_prev_active_soc") or "")
    if _cur_soc and _cur_soc != _prev_soc:
        st.session_state["_prev_active_soc"] = _cur_soc
        _stc.html(
            """<script>
            (function() {
                function scrollToSpec() {
                    var anchor = window.parent.document.getElementById('sal-spec-panel');
                    var main   = window.parent.document.querySelector('[data-testid="stMain"]');
                    if (anchor && main) {
                        var mainRect   = main.getBoundingClientRect();
                        var anchorRect = anchor.getBoundingClientRect();
                        var target     = main.scrollTop + (anchorRect.top - mainRect.top) - 16;
                        main.scrollTo({top: target, behavior: 'smooth'});
                        return true;
                    }
                    return false;
                }
                // Try immediately, then retry after Streamlit finishes painting
                if (!scrollToSpec()) {
                    setTimeout(scrollToSpec, 400);
                } else {
                    setTimeout(scrollToSpec, 400);  // run again to correct for late layout
                }
            })();
            </script>""",
            height=1,
            scrolling=False,
        )

    # ── Logic Specification card ─────────────────────────────────────────────
    selected_soc = str(st.session_state.get("active_soc") or "")
    chosen_row: dict[str, Any] | None = None
    if selected_soc:
        if browse_mode:
            chosen_row = next(
                (dict(r) for r in _MOCK_REGISTRY if r.get("soc_code") == selected_soc),
                None,
            )
        elif client is not None:
            try:
                rr = (
                    client.table("registry_metadata")
                    .select("soc_code,title,market_value,outlook,is_custom,description")
                    .eq("soc_code", selected_soc)
                    .limit(1)
                    .execute()
                )
                if rr.data:
                    chosen_row = rr.data[0]
            except Exception:
                pass

    logic: dict[str, Any] | None = None
    if selected_soc:
        if browse_mode:
            logic = _demo_fetch_agent_logic_detail(selected_soc)
        elif client is not None:
            try:
                logic = fetch_agent_logic_detail(client, selected_soc)
            except Exception:
                pass

    _render_logic_spec_html_card(
        selected_soc=selected_soc,
        chosen_row=chosen_row,
        logic=logic,
        browse_mode=browse_mode,
    )

    # ── Agent Bundle — Shopping Cart ─────────────────────────────────────────
    bundle: list = st.session_state.get("agent_bundle", [])
    if selected_soc and chosen_row:
        already_in = any(r.get("soc_code") == selected_soc for r in bundle)
        role_title = str(chosen_row.get("title") or selected_soc)
        if already_in:
            if st.button("✖  Remove from Bundle", key="sal_bundle_remove",
                         use_container_width=True, type="secondary"):
                st.session_state["agent_bundle"] = [
                    r for r in bundle if r.get("soc_code") != selected_soc
                ]
                st.rerun()
        else:
            if st.button("＋  Add to Agent Bundle", key="sal_bundle_add",
                         use_container_width=True, type="primary"):
                st.session_state["agent_bundle"] = bundle + [
                    {"soc_code": selected_soc, "title": role_title}
                ]
                st.rerun()

    # ── Cart display ─────────────────────────────────────────────────────────
    bundle = st.session_state.get("agent_bundle", [])
    if bundle:
        st.markdown(
            f'<div style="background:#071540;border:1.5px solid #1d4ed8;border-radius:6px;'
            f'padding:0.75rem 0.85rem 0.5rem;margin-top:0.6rem">'
            f'<div style="font-family:\'Courier New\',monospace;font-size:0.62rem;'
            f'font-weight:800;color:#93c5fd;letter-spacing:0.14em;border-bottom:1px solid #1d4ed855;'
            f'padding-bottom:0.35rem;margin-bottom:0.5rem">'
            f'&#9632; AGENT BUNDLE &nbsp;&#9670;&nbsp; {len(bundle)} ROLE{"S" if len(bundle)!=1 else ""} QUEUED</div>',
            unsafe_allow_html=True,
        )
        for item in bundle:
            item_soc   = str(item.get("soc_code", ""))
            item_title = str(item.get("title", item_soc))
            prefix     = item_soc.split("-")[0] if "-" in item_soc else "??"
            # look up sector label
            sector_lbl = next(
                (lbl for p, lbl, *_ in _AI_DISPLACEMENT if p == prefix), prefix
            )
            c1, c2 = st.columns([5, 1])
            with c1:
                st.markdown(
                    f'<div style="padding:0.3rem 0;border-bottom:1px solid #1d4ed822">'
                    f'<span style="font-weight:700;font-size:0.83rem;color:#e2e8f0">{escape(item_title)}</span><br>'
                    f'<span style="font-family:\'Courier New\',monospace;font-size:0.65rem;color:#60a5fa">'
                    f'{escape(item_soc)}</span>'
                    f'<span style="font-size:0.62rem;color:#64748b;margin-left:0.5rem">{escape(sector_lbl)}</span>'
                    f'</div>',
                    unsafe_allow_html=True,
                )
            with c2:
                if st.button("✕", key=f"cart_rm_{item_soc}",
                             help=f"Remove {item_title}"):
                    st.session_state["agent_bundle"] = [
                        r for r in bundle if r.get("soc_code") != item_soc
                    ]
                    st.rerun()
        st.markdown("</div>", unsafe_allow_html=True)

        # Export bundle
        if st.session_state.get("agent_bundle"):
            bundle_data = st.session_state["agent_bundle"]
            import json as _json

            # ── Build full MCP spec for every bundled role ────────────────
            full_roles: list[dict] = []
            for entry in bundle_data:
                code = entry.get("soc_code", "")
                # Pull registry metadata
                reg_row: dict | None = None
                if browse_mode:
                    reg_row = next(
                        (dict(r) for r in _MOCK_REGISTRY if r.get("soc_code") == code),
                        None,
                    )
                elif client is not None:
                    try:
                        rr = (
                            client.table("registry_metadata")
                            .select("soc_code,title,market_value,outlook,description")
                            .eq("soc_code", code).limit(1).execute()
                        )
                        if rr.data:
                            reg_row = rr.data[0]
                    except Exception:
                        pass

                # Pull agent logic spec
                logic_row: dict | None = None
                if browse_mode:
                    logic_row = _demo_fetch_agent_logic_detail(code)
                elif client is not None:
                    try:
                        logic_row = fetch_agent_logic_detail(client, code)
                    except Exception:
                        pass

                full_roles.append({
                    "soc_code": code,
                    "title": entry.get("title", ""),
                    "registry": {
                        "market_value": (reg_row or {}).get("market_value"),
                        "outlook":      (reg_row or {}).get("outlook"),
                        "description":  (reg_row or {}).get("description"),
                    },
                    "mcp_spec": {
                        "primary_directive":  (logic_row or {}).get("primary_directive"),
                        "execution_steps":    _normalize_steps((logic_row or {}).get("step_by_step_json")),
                        "toolbox_requirements": (logic_row or {}).get("toolbox_requirements"),
                    },
                })

            bundle_json = _json.dumps(
                {
                    "format":          "MCP/SAL-v1.2",
                    "exported":        "2026-04-04",
                    "total_roles":     len(full_roles),
                    "sal_agent_bundle": full_roles,
                },
                indent=2,
                default=str,
            )
            st.download_button(
                label=f"\u21e9  Export Bundle ({len(bundle_data)} roles · full MCP spec)",
                data=bundle_json,
                file_name="sal_agent_bundle.json",
                mime="application/json",
                use_container_width=True,
                key="sal_bundle_export",
            )

# ── Sovereign document header ────────────────────────────────────────────────

def _sovereign_header_html() -> str:
    """Great Seal image + double-bordered ribbon + serial — sovereign document header."""
    seal = _great_seal_data_uri()
    return (
        '<div class="sal-header-container">'
        '<div class="sal-sovereign-header">'
        # Serial number — absolute top-right
        '<div class="sal-serial">SAL\u2011REG\u20112026\u2011X</div>'
        # The real Great Seal image
        '<div class="sal-eagle-wrap">'
        f'<img src="{seal}" class="sal-great-seal-img" alt="Great Seal of the United States"/>'
        '</div>'
        # Double-bordered ribbon title block — below the seal
        '<div class="sal-ribbon-outer">'
        '<div class="sal-ribbon-inner">'
        '<div class="sal-ribbon-title">STANDARD AGENT LOGIC REGISTRY</div>'
        '<div class="sal-ribbon-sub">'
        'FEDERAL\u2011GRADE PRECISION &nbsp;\u00b7&nbsp; AUTHENTICATED AI AGENT REGISTRY'
        '</div>'
        '</div>'
        '</div>'
        '</div>'
        '</div>'
    )


def main() -> None:
    # ── Session state initialisation (MUST run before any widget) ──
    if "active_soc" not in st.session_state:
        st.session_state["active_soc"] = "15-1299.08"
    if "active_prefix" not in st.session_state:
        st.session_state["active_prefix"] = "15"
    if "vault_only" not in st.session_state:
        st.session_state["vault_only"] = False
    if "agent_bundle" not in st.session_state:
        st.session_state["agent_bundle"] = []
    if "vault_unlocked" not in st.session_state:
        st.session_state["vault_unlocked"] = False

    _inject_studio_styles()

    if st.session_state.get("sal_stack_v") != 5:
        st.session_state["sal_stack_v"] = 5
        st.session_state.pop("hub_messages", None)
        st.session_state.pop("sal_hub_last_reply", None)

    browse_mode = use_demo_mode()
    client = None
    live_connected = False

    if browse_mode:
        counts = _demo_fetch_counts()
    else:
        try:
            client = get_supabase_client()
            client.table("agent_logic").select("soc_code").limit(1).execute()
            counts = fetch_live_table_counts(client)
            live_connected = True
        except Exception as exc:
            _audit_connection_failure(exc, "Supabase connect or live count fetch")
            browse_mode = True
            client = None
            counts = _demo_fetch_counts()

    # ── Sidebar ──
    with st.sidebar:
        if live_connected:
            st.success("**Live production mode** \u00b7 Supabase")
        else:
            st.caption("Browse mode \u00b7 mock metrics")
        st.markdown("##### Registry metrics")
        st.markdown('<div class="sal-metric-wrap">', unsafe_allow_html=True)
        c1, c2 = st.columns(2)
        c1.metric("Verified Agent Roles", counts["agent_logic"])
        c2.metric("Standardized Logic Library", counts["registry_metadata"])
        st.metric("Safety Guardrails", counts["guardrails_and_compliance"])
        st.markdown("</div>", unsafe_allow_html=True)
        # ── Vault access gate ────────────────────────────────────────────
        _vault_pw = (_secret_get("VAULT_PASSWORD") or "").strip()
        _has_vault_pw = bool(_vault_pw)

        if not _has_vault_pw:
            # No password configured — vault locked in production
            st.session_state["vault_unlocked"] = False
            st.session_state["vault_only"] = False
            st.radio("Library scope", ["Global Registry"], horizontal=True, key="sal_sidebar_scope")
            st.caption("\U0001f512 Private Vault — access restricted")
        elif st.session_state.get("vault_unlocked"):
            # Authenticated — show full scope toggle + lock button
            scope = st.radio(
                "Library scope", ["Global Registry", "Private Vault \U0001f3c6"],
                horizontal=True, key="sal_sidebar_scope",
            )
            st.session_state["vault_only"] = scope != "Global Registry"
            if st.button("\U0001f512 Lock Vault", use_container_width=True, key="sal_vault_lock"):
                st.session_state["vault_unlocked"] = False
                st.session_state["vault_only"] = False
                st.rerun()
        else:
            # Not yet authenticated — show password prompt
            st.session_state["vault_only"] = False
            st.radio("Library scope", ["Global Registry"], horizontal=True, key="sal_sidebar_scope")
            st.markdown(
                '<p style="font-size:0.65rem;color:#64748b;margin:0.3rem 0 0.15rem;'
                'font-family:\'Courier New\',monospace;letter-spacing:0.06em">'
                '\U0001f512 PRIVATE VAULT ACCESS</p>',
                unsafe_allow_html=True,
            )
            pw_input = st.text_input(
                "Vault key", type="password", label_visibility="collapsed",
                placeholder="Enter vault key\u2026", key="sal_vault_pw_input",
            )
            if st.button("Unlock", use_container_width=True, key="sal_vault_unlock_btn", type="primary"):
                if pw_input and pw_input == _vault_pw:
                    st.session_state["vault_unlocked"] = True
                    st.rerun()
                else:
                    st.error("Access denied.")

        with st.expander("Environment"):
            st.write(f"Browse mode: `{browse_mode}`")
            st.write(f"Live connected: `{live_connected}`")
            st.write(f"Vault unlocked: `{st.session_state.get('vault_unlocked', False)}`")
            st.write(f"SUPABASE_URL set: `{bool(_resolve_supabase_url())}`")
            st.write(f"SUPABASE_KEY set: `{bool(_resolve_supabase_key())}`")

    if browse_mode:
        st.info(
            "**Browse mode:** Supabase keys missing — mock Global Registry active. "
            "Set `.streamlit/secrets.toml` or environment variables for live production mode."
        )

    # ── Sovereign document header ──
    st.markdown(_sovereign_header_html(), unsafe_allow_html=True)

    # ── Full-width stacked layout: Authority (seals + search + tree) → Spec ──
    _render_col_authority(client=client, browse_mode=browse_mode)
    _render_col_engine(client=client, browse_mode=browse_mode)

    # ── Sector Performance Readout — full-width below both columns ────────────
    st.markdown(
        '<div class="sal-bright-outlook-wrap">'
        '<div class="sal-bright-outlook-title" '
        'style="font-family:\'Courier New\',monospace;letter-spacing:0.1em">'
        '&#9632; SECTOR PERFORMANCE READOUT &nbsp;&#x25C6;&nbsp; ALL 22 SOC DIVISIONS</div>'
        '</div>',
        unsafe_allow_html=True,
    )
    st.markdown(_bright_outlook_svg(), unsafe_allow_html=True)

    # ── Footer ──
    verified_count = counts.get("agent_logic", 1095)
    st.markdown(
        f'<div class="sal-footer">'
        f'<span class="sal-footer-metric">{verified_count:,} Verified Roles</span>'
        f'SAL v1.1.0 &nbsp;|&nbsp; Standard Agent Logic Registry &nbsp;|&nbsp; Federal-Grade Precision'
        f'</div>',
        unsafe_allow_html=True,
    )


main()
