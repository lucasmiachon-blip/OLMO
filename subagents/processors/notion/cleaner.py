"""Notion Cleaner Subagent - Organiza Notion com seguranca (modelo harsh).

Fluxo OBRIGATORIO (anti-perda):
1. SNAPSHOT  -> Le TUDO do Notion (todas paginas, databases, properties)
2. INVENTARIO -> Gera arquivo local data/notion_snapshot.md com tudo lido
3. ANALISE   -> Classifica cada pagina (Sonnet/5.4 triagem, Opus ambiguas)
4. PLANO     -> Gera plano de acoes com confirmacao humana
5. EXECUCAO  -> So apos aprovacao, executa acoes (com checkpoint por step)

NUNCA pular o snapshot. NUNCA deletar (apenas arquivar).
Toda operacao destrutiva requer confirmacao humana.
"""

from __future__ import annotations

import json
import logging
import sqlite3
from datetime import datetime
from typing import Any, ClassVar

from agents.core.base_agent import AgentStatus, BaseAgent, TaskResult
from agents.core.database import get_connection
from agents.core.mcp_safety import OperationMode

from .analysis import AnalysisMixin
from .executor import ExecutorMixin
from .models import CleanupReport, NotionPage, PageAction, PageAuditResult
from .snapshot import SNAPSHOT_DIR, SNAPSHOT_MD, SnapshotMixin

logger = logging.getLogger("subagent.notion_cleaner")


class NotionCleanerSubagent(SnapshotMixin, AnalysisMixin, ExecutorMixin, BaseAgent):
    """Subagente que limpa e organiza Notion com modelo harsh (seguro)."""

    LOCATION_RULES: ClassVar[dict[str, str]] = {
        "paper": "Knowledge Base Medica",
        "evidence": "Knowledge Base Medica",
        "guideline": "Knowledge Base Medica",
        "nota_clinica": "Knowledge Base Medica",
        "inbox_item": "Inbox Medico",
        "digest": "Digests Semanais",
        "projeto": "Projetos de Pesquisa",
        "rascunho": "Inbox Medico",
        "template": "Templates",
        "pessoal": "Pessoal",
    }

    REQUIRED_PROPERTIES: ClassVar[dict[str, list[str]]] = {
        "Knowledge Base Medica": ["Tipo", "Especialidade", "Tags", "Status"],
        "Inbox Medico": ["Fonte", "Prioridade", "Acao"],
        "Digests Semanais": ["Semana", "Ano"],
        "Projetos de Pesquisa": ["Status", "Deadline"],
    }

    PROTECTED_FILTERS: ClassVar[list[str]] = []

    def __init__(self) -> None:
        super().__init__(
            name="notion_cleaner",
            description="Limpa e organiza Notion com seguranca (modelo harsh)",
        )
        self._snapshot: list[NotionPage] = []
        self._audit_results: list[PageAuditResult] = []
        self._report = CleanupReport()
        self._duplicate_groups: dict[str, list[str]] = {}
        self._snapshot_taken = False
        self._checkpoint_file = SNAPSHOT_DIR / "cleanup_checkpoint.json"
        self._mcp_client: Any = None
        self._db: sqlite3.Connection | None = None
        self._operation_mode = OperationMode.READ_ONLY

    async def execute(self, task: dict[str, Any]) -> TaskResult:
        """Executa tarefa de limpeza do Notion."""
        self.status = AgentStatus.RUNNING
        action = task.get("action", "")

        try:
            actions_map = {
                "snapshot": self._take_snapshot,
                "inventario": self._generate_inventory_md,
                "analyze": self._analyze_all,
                "plan_actions": self._plan_actions,
                "execute_plan": self._execute_approved_plan,
                "report": self._generate_report,
                "full_cleanup": self._full_cleanup,
            }

            handler = actions_map.get(action)
            if handler:
                result: TaskResult = await handler(task)
                return result
            return TaskResult(success=False, error=f"Unknown action: {action}")
        except Exception as e:
            self.status = AgentStatus.ERROR
            logger.error(f"Notion cleaner error: {e}")
            return TaskResult(success=False, error=str(e))
        finally:
            self.status = AgentStatus.IDLE

    async def plan(self, objective: str) -> list[dict[str, Any]]:
        return [
            {"step": 1, "action": "snapshot", "desc": "Ler TUDO do Notion"},
            {"step": 2, "action": "inventario", "desc": "Gerar notion_snapshot.md"},
            {"step": 3, "action": "analyze", "desc": "Classificar cada pagina"},
            {"step": 4, "action": "plan_actions", "desc": "Plano para aprovacao humana"},
            {
                "step": 5,
                "action": "execute_plan",
                "desc": "Executar aprovadas (checkpoints)",
            },
            {"step": 6, "action": "report", "desc": "Gerar relatorio final"},
        ]

    def set_mcp_client(self, client: Any) -> None:
        """Injeta o client MCP do Notion (passado pelo orchestrator)."""
        self._mcp_client = client

    def _ensure_db(self) -> sqlite3.Connection:
        """Garante conexao com SQLite."""
        if self._db is None:
            self._db = get_connection()
        return self._db

    def _is_protected(self, page: NotionPage, protected: list[str]) -> bool:
        """Verifica se a pagina esta protegida."""
        if not protected:
            return False
        title_lower = page.title.lower()
        db_lower = page.database.lower()
        raw_tags = page.properties.get("Tags", [])
        tags = [t.lower() for t in raw_tags] if isinstance(raw_tags, list) else []

        for term in protected:
            term_lower = term.lower()
            if term_lower in title_lower or term_lower in db_lower or term_lower in tags:
                return True
        return False

    async def _plan_actions(self, task: dict[str, Any]) -> TaskResult:
        """Gera plano de acoes para aprovacao humana."""
        if not self._audit_results:
            return TaskResult(
                success=False,
                error="Analise nao foi feita. Execute 'analyze' primeiro.",
            )

        plan: dict[str, list[dict[str, Any]]] = {
            "auto_execute": [],
            "needs_confirmation": [],
            "needs_review": [],
        }

        for audit in self._audit_results:
            if audit.action == PageAction.KEEP:
                continue

            action_item = {
                "page_id": audit.page_id,
                "title": audit.title,
                "action": audit.action.value,
                "from": audit.current_location,
                "to": audit.suggested_location,
                "reason": audit.reason,
                "confidence": audit.confidence,
                "duplicates": audit.duplicates,
                "missing_props": audit.missing_properties,
                "suggested_tags": audit.suggested_tags,
            }

            if audit.confidence >= 0.95:
                plan["auto_execute"].append(action_item)
            elif audit.confidence >= 0.70:
                plan["needs_confirmation"].append(action_item)
            else:
                plan["needs_review"].append(action_item)

        plan_file = SNAPSHOT_DIR / "cleanup_plan.json"
        SNAPSHOT_DIR.mkdir(parents=True, exist_ok=True)
        plan_file.write_text(json.dumps(plan, indent=2, ensure_ascii=False))

        total_actions = sum(len(v) for v in plan.values())

        return TaskResult(
            success=True,
            data={
                "plan_file": str(plan_file),
                "total_actions": total_actions,
                "auto_execute": len(plan["auto_execute"]),
                "needs_confirmation": len(plan["needs_confirmation"]),
                "needs_review": len(plan["needs_review"]),
                "plan": plan,
                "message": (
                    f"Plano gerado: {total_actions} acoes. "
                    f"{len(plan['auto_execute'])} auto, "
                    f"{len(plan['needs_confirmation'])} precisam confirmacao, "
                    f"{len(plan['needs_review'])} precisam review humano. "
                    f"Revise o plano em {plan_file} antes de executar."
                ),
            },
        )

    async def _generate_report(self, task: dict[str, Any]) -> TaskResult:
        """Gera relatorio completo da limpeza."""
        self._report.finished_at = datetime.now().isoformat()
        self._report.pages_need_review = len(
            [a for a in self._audit_results if a.action == PageAction.REVIEW]
        )

        needs_review = [
            {
                "title": a.title,
                "current": a.current_location,
                "suggested": a.suggested_location,
                "reason": a.reason,
                "confidence": a.confidence,
            }
            for a in self._audit_results
            if a.action == PageAction.REVIEW
        ]

        return TaskResult(
            success=True,
            data={
                "total_pages": self._report.total_pages,
                "ok": self._report.pages_ok,
                "relocated": self._report.pages_relocated,
                "merged": self._report.pages_merged,
                "archived": self._report.pages_archived,
                "tagged": self._report.pages_tagged,
                "needs_review": self._report.pages_need_review,
                "duplicates_found": self._report.duplicates_found,
                "review_items": needs_review,
                "snapshot_path": self._report.snapshot_path,
                "snapshot_md": str(SNAPSHOT_MD),
                "started": self._report.started_at,
                "finished": self._report.finished_at,
            },
        )

    async def _full_cleanup(self, task: dict[str, Any]) -> TaskResult:
        """Executa limpeza completa. PARA na etapa 4 para aprovacao humana."""
        steps = [
            ("snapshot", self._take_snapshot),
            ("inventario", self._generate_inventory_md),
            ("analyze", self._analyze_all),
            ("plan_actions", self._plan_actions),
        ]

        results: dict[str, Any] = {}
        for step_name, handler in steps:
            logger.info(f"Cleanup step: {step_name}")
            result = await handler(task)
            results[step_name] = result.data
            if not result.success:
                return TaskResult(
                    success=False,
                    error=f"Failed at step '{step_name}': {result.error}",
                    data=results,
                )

        return TaskResult(
            success=True,
            data={
                **results,
                "status": "AGUARDANDO_APROVACAO_HUMANA",
                "next_step": (
                    "Revise cleanup_plan.json e chame 'execute_plan' com approved_actions"
                ),
                "snapshot_md": str(SNAPSHOT_MD),
            },
        )
