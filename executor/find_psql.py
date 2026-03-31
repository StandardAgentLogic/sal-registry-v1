from __future__ import annotations

import os
import shutil
from pathlib import Path


def _candidate_roots() -> list[Path]:
    roots: list[Path] = []
    for key in ("ProgramFiles", "ProgramFiles(x86)", "LocalAppData"):
        value = os.environ.get(key)
        if value:
            roots.append(Path(value))
    roots.append(Path(r"C:\Program Files"))
    roots.append(Path(r"C:\Program Files (x86)"))
    return roots


def find_psql_exe() -> Path | None:
    """
    Search common Windows installation locations for psql.exe.
    """
    for root in _candidate_roots():
        patterns = [
            "PostgreSQL/*/bin/psql.exe",
            "Postgres/*/bin/psql.exe",
        ]
        for pattern in patterns:
            matches = sorted(root.glob(pattern), reverse=True)
            if matches:
                return matches[0]
    return None


def ensure_psql_on_path() -> str | None:
    """
    Add psql's bin directory to current process PATH if needed.
    Returns resolved psql executable path or None.
    """
    existing = shutil.which("psql")
    if existing:
        return existing

    psql_path = find_psql_exe()
    if not psql_path:
        return None

    bin_dir = str(psql_path.parent)
    path_value = os.environ.get("PATH", "")
    path_parts = path_value.split(os.pathsep) if path_value else []
    if bin_dir not in path_parts:
        os.environ["PATH"] = f"{bin_dir}{os.pathsep}{path_value}" if path_value else bin_dir

    return shutil.which("psql") or str(psql_path)

