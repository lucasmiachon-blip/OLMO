"""Git Manager Skill - Gestao de repositorios Git."""

from __future__ import annotations

import asyncio
import logging
from typing import Any

logger = logging.getLogger("skill.git_manager")


class GitManagerSkill:
    """Skill de gestao de repositorios Git.

    Automatiza operacoes comuns de Git e GitHub.
    """

    name = "git_manager"
    description = "Gerencia repositorios Git e operacoes GitHub"

    async def get_status(self, repo_path: str = ".") -> dict[str, Any]:
        """Retorna status do repositorio."""
        try:
            proc = await asyncio.create_subprocess_exec(
                "git", "status", "--porcelain",
                cwd=repo_path,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )
            stdout, stderr = await proc.communicate()

            if proc.returncode != 0:
                return {"error": stderr.decode()}

            files = stdout.decode().strip().split("\n") if stdout.decode().strip() else []
            return {
                "changed_files": len(files),
                "files": files,
                "clean": len(files) == 0,
            }
        except Exception as e:
            return {"error": str(e)}

    async def get_log(self, repo_path: str = ".", count: int = 10) -> dict[str, Any]:
        """Retorna log de commits."""
        try:
            proc = await asyncio.create_subprocess_exec(
                "git", "log", "--oneline", f"-{count}",
                cwd=repo_path,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )
            stdout, _ = await proc.communicate()

            commits = stdout.decode().strip().split("\n") if stdout.decode().strip() else []
            return {"commits": commits, "count": len(commits)}
        except Exception as e:
            return {"error": str(e)}

    async def get_diff(self, repo_path: str = ".", staged: bool = False) -> dict[str, Any]:
        """Retorna diff atual."""
        try:
            cmd = ["git", "diff"]
            if staged:
                cmd.append("--staged")

            proc = await asyncio.create_subprocess_exec(
                *cmd,
                cwd=repo_path,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )
            stdout, _ = await proc.communicate()

            return {"diff": stdout.decode()[:5000]}  # Limita tamanho
        except Exception as e:
            return {"error": str(e)}
