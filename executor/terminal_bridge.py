from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path
from typing import Iterable, List, Sequence

from executor.find_psql import ensure_psql_on_path


ROOT_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ROOT_DIR / "data"


def _run_command(command: Sequence[str], *, skill_name: str | None = None) -> int:
    """
    Execute a terminal command and print stdout/stderr.
    If the exit code is 0 and a skill_name is provided, print the unlock notification.
    """
    cmd_list = list(command)
    try:
        process = subprocess.run(
            " ".join(cmd_list),
            text=True,
            capture_output=True,
            shell=True,
        )
    except FileNotFoundError:
        # Windows-specific resolution failure (e.g., psql not in PATH)
        executable = cmd_list[0] if cmd_list else "psql"
        print(
            f"ERROR: {executable} not found in PATH. "
            "Please install PostgreSQL or provide the full path to the CLI.",
            file=sys.stderr,
        )
        return 1

    if process.stdout:
        print(process.stdout, end="")
    if process.stderr:
        print(process.stderr, file=sys.stderr, end="")

    if process.returncode == 0 and skill_name:
        print(f"*** NEW SKILL UNLOCKED: {skill_name} ***")

    return process.returncode


def _discover_sql_files(data_dir: Path | None = None) -> List[Path]:
    """
    Find .sql files in the given data directory (non-recursive).
    """
    base = data_dir or DATA_DIR
    if not base.exists():
        return []
    return sorted(p for p in base.iterdir() if p.is_file() and p.suffix.lower() == ".sql")


def inject_sql_files(
    *,
    db_cli: str | None = None,
    cli_args: Iterable[str] | None = None,
    data_dir: Path | None = None,
) -> None:
    """
    Execute all .sql files in the /data directory using the configured DB CLI.

    Parameters
    ----------
    db_cli:
        The database CLI executable to use (e.g. "psql", "mysql").
        Defaults to the DB_CLI environment variable, or "psql" if unset.
    cli_args:
        Additional arguments to pass to the CLI for every invocation
        (e.g. connection string, host, user).
    data_dir:
        Optional override for the data directory containing .sql files.
    """
    executable = db_cli or os.environ.get("DB_CLI", "psql")
    extra_args = list(cli_args or [])

    if Path(executable).name.lower() in {"psql", "psql.exe"}:
        resolved = ensure_psql_on_path()
        if not resolved:
            print(
                "ERROR: psql not found in PATH. Please install PostgreSQL or provide full path.",
                file=sys.stderr,
            )
            return
        if not db_cli:
            executable = resolved

        # Allow zero-arg execution by using DATABASE_URL automatically.
        if not extra_args:
            db_url = os.environ.get("DATABASE_URL") or os.environ.get("SUPABASE_DB_URL")
            if db_url:
                extra_args = [db_url]

    sql_files = _discover_sql_files(data_dir)
    if not sql_files:
        print(f"No .sql files found in {data_dir or DATA_DIR}")
        return

    for sql_file in sql_files:
        skill_name = sql_file.stem.replace("_", " ").title()
        command = [executable, *extra_args, "-f", str(sql_file)]
        print(f"Running: {' '.join(command)}")
        exit_code = _run_command(command, skill_name=skill_name)
        if exit_code != 0:
            print(f"Command failed with exit code {exit_code} for {sql_file.name}", file=sys.stderr)


def main(argv: Sequence[str] | None = None) -> int:
    """
    Minimal CLI entry point.

    Usage:
        python -m executor.terminal_bridge [DB_CLI [CLI_ARGS...]]

    If DB_CLI is omitted, the script falls back to DB_CLI env var or "psql".
    Any additional arguments are forwarded directly to the underlying CLI.
    """
    args = list(argv or sys.argv[1:])
    db_cli: str | None = None
    cli_args: List[str] | None = None

    if args:
        db_cli = args[0]
        cli_args = args[1:]

    inject_sql_files(db_cli=db_cli, cli_args=cli_args)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

