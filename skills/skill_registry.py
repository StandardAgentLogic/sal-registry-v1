from __future__ import annotations

import importlib
import json
import os
import pkgutil
import subprocess
import sys
from dataclasses import dataclass
from types import ModuleType
from typing import Any, Dict, Iterable, List


def load_skills(package_name: str = "skills") -> Dict[str, ModuleType]:
    """
    Dynamically load all Python modules in the given skills package.

    Returns a mapping of skill name -> imported module.
    """
    package = importlib.import_module(package_name)

    skills: Dict[str, ModuleType] = {}
    for module_info in pkgutil.iter_modules(package.__path__, package.__name__ + "."):
        name = module_info.name.rsplit(".", 1)[-1]
        if name.startswith("_"):
            continue

        module = importlib.import_module(module_info.name)
        skills[name] = module

    return skills


def iter_skill_names(package_name: str = "skills") -> Iterable[str]:
    """
    Yield the names of all available skills without importing them.
    """
    package = importlib.import_module(package_name)
    for module_info in pkgutil.iter_modules(package.__path__, package.__name__ + "."):
        name = module_info.name.rsplit(".", 1)[-1]
        if name.startswith("_"):
            continue
        yield name


@dataclass
class Tool:
    """
    Minimal runtime tool generated from database skill metadata.
    """

    name: str
    role: str
    soc_code: str
    verification_logic: Dict[str, Any]
    safety_protocols: List[str]

    def __call__(self, prompt: str) -> str:
        """
        Simple callable behavior for agent usage.
        """
        lower_prompt = prompt.lower()
        wants_safety = "safety protocol" in lower_prompt or "protocol" in lower_prompt
        wants_count_5 = "5" in lower_prompt or "five" in lower_prompt

        if wants_safety:
            items = self.safety_protocols[:5] if wants_count_5 else self.safety_protocols
            if not items:
                return f"{self.role}: No safety protocols found."
            lines = [f"As a {self.role}, the safety protocols are:"]
            lines.extend(f"{idx}. {item}" for idx, item in enumerate(items, start=1))
            return "\n".join(lines)

        return (
            f"Tool '{self.name}' is active for {self.role} ({self.soc_code}). "
            "Ask for safety protocols or compliance checks."
        )


def _run_psql_json_rows(sql: str, db_url: str | None = None) -> List[Dict[str, Any]]:
    """
    Execute SQL via psql and parse JSON-line records.
    """
    database_url = db_url or os.environ.get("DATABASE_URL") or os.environ.get("SUPABASE_DB_URL")
    if not database_url:
        raise RuntimeError("DATABASE_URL or SUPABASE_DB_URL must be set.")

    command = [
        "psql",
        database_url,
        "-t",
        "-A",
        "-F",
        "\t",
        "-c",
        sql,
    ]
    result = subprocess.run(command, text=True, capture_output=True)
    if result.returncode != 0:
        stderr = result.stderr.strip()
        raise RuntimeError(f"psql query failed: {stderr or 'unknown error'}")

    rows: List[Dict[str, Any]] = []
    for line in result.stdout.splitlines():
        payload = line.strip()
        if not payload:
            continue
        rows.append(json.loads(payload))
    return rows


def fetch_db_skills(db_url: str | None = None) -> Dict[str, Tool]:
    """
    Query registry_metadata and produce dynamic tools from verification_logic JSONB.

    Note:
    verification_logic is sourced from guardrails_and_compliance and linked to
    registry_metadata by SOC code.
    """
    query = """
    SELECT json_build_object(
      'soc_code', rm.soc_code,
      'title', rm.title,
      'verification_logic', gc.verification_logic,
      'safety_protocols', gc.safety_protocols
    )::text
    FROM registry_metadata rm
    JOIN guardrails_and_compliance gc
      ON gc.verification_logic->>'soc_code' = rm.soc_code
    WHERE gc.verification_logic IS NOT NULL;
    """
    rows = _run_psql_json_rows(query, db_url=db_url)

    tools: Dict[str, Tool] = {}
    for row in rows:
        logic = row.get("verification_logic") or {}
        role = (
            logic.get("title")
            or logic.get("role")
            or row.get("title")
            or "Unknown Role"
        )
        soc_code = str(row.get("soc_code") or logic.get("soc_code") or "unknown")
        tool_name = f"{role.lower().replace(',', '').replace(' ', '_')}_tool"
        safety_protocols = list(row.get("safety_protocols") or [])

        tools[tool_name] = Tool(
            name=tool_name,
            role=role,
            soc_code=soc_code,
            verification_logic=logic,
            safety_protocols=safety_protocols,
        )

    return tools


def answer_with_db_skills(question: str, db_url: str | None = None) -> str:
    """
    Route a question to the most relevant dynamically generated tool.
    """
    tools = fetch_db_skills(db_url=db_url)
    if not tools:
        return "No database skills found."

    lower_question = question.lower()
    for tool in tools.values():
        if tool.role.lower() in lower_question:
            return tool(question)

    # Fallback: legal-family routing if explicit role text is not present.
    if "judicial law clerk" in lower_question:
        for tool in tools.values():
            if "judicial law clerks" in tool.role.lower():
                return tool(question)

    first_tool = next(iter(tools.values()))
    return first_tool(question)


if __name__ == "__main__":
    prompt = " ".join(sys.argv[1:]).strip() or (
        "As a Legal Specialist, what are the 5 safety protocols for a Judicial Law Clerk?"
    )
    print(answer_with_db_skills(prompt))

