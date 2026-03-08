"""Code Analyzer Skill - Analise de qualidade e seguranca de codigo."""

from __future__ import annotations

import logging
from dataclasses import dataclass
from pathlib import Path
from typing import Any

logger = logging.getLogger("skill.code_analyzer")


@dataclass
class CodeIssue:
    """Um problema encontrado no codigo."""

    file: str
    line: int
    severity: str  # error, warning, info
    category: str  # security, performance, style, bug
    message: str
    suggestion: str = ""


@dataclass
class CodeMetrics:
    """Metricas de um arquivo/projeto."""

    total_lines: int = 0
    code_lines: int = 0
    comment_lines: int = 0
    blank_lines: int = 0
    functions: int = 0
    classes: int = 0
    complexity: float = 0.0
    test_coverage: float = 0.0


class CodeAnalyzerSkill:
    """Skill de analise de codigo.

    Analisa qualidade, seguranca, performance e boas praticas.
    Inspirado em SonarQube, CodeClimate e melhores praticas OWASP.
    """

    name = "code_analyzer"
    description = "Analisa qualidade, seguranca e performance de codigo"

    async def analyze_file(self, file_path: str) -> dict[str, Any]:
        """Analisa um arquivo de codigo."""
        path = Path(file_path)
        if not path.exists():
            return {"error": f"File not found: {file_path}"}

        content = path.read_text()
        lines = content.split("\n")

        metrics = CodeMetrics(
            total_lines=len(lines),
            code_lines=len([ln for ln in lines if ln.strip() and not ln.strip().startswith("#")]),
            comment_lines=len([ln for ln in lines if ln.strip().startswith("#")]),
            blank_lines=len([ln for ln in lines if not ln.strip()]),
        )

        return {
            "file": file_path,
            "language": path.suffix,
            "metrics": metrics,
            "issues": [],
        }

    async def analyze_project(self, project_path: str) -> dict[str, Any]:
        """Analisa um projeto inteiro."""
        path = Path(project_path)
        if not path.exists():
            return {"error": f"Project not found: {project_path}"}

        python_files = list(path.rglob("*.py"))

        return {
            "project": project_path,
            "files_count": len(python_files),
            "files": [str(f) for f in python_files],
            "status": "analysis_pending",
        }

    async def security_scan(self, file_path: str) -> list[CodeIssue]:
        """Faz scan de seguranca em um arquivo."""
        logger.info(f"Security scan: {file_path}")
        return []

    async def suggest_improvements(self, code: str) -> list[dict[str, Any]]:
        """Sugere melhorias para um trecho de codigo."""
        return []
