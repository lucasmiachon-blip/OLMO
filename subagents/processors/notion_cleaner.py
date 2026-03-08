"""Notion Cleaner Subagent - Organiza Notion pagina por pagina em background.

Varre todo o workspace Notion, identifica:
- Paginas fora do lugar (move para database/secao correta)
- Duplicatas e redundancias (merge ou arquiva)
- Paginas sem tags/propriedades (classifica automaticamente)
- Conteudo orfao (sem links, sem database)

Roda em background via Sonnet/ChatGPT 5.4 (triagem barata).
Opus so para decisoes ambiguas de merge/classificacao.
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Any

from agents.core.base_agent import AgentStatus, BaseAgent, TaskResult

logger = logging.getLogger("subagent.notion_cleaner")


class PageAction(Enum):
    """Acoes possiveis para uma pagina."""

    KEEP = "keep"              # Esta no lugar certo
    RELOCATE = "relocate"      # Mover para outra secao/database
    MERGE = "merge"            # Fundir com outra pagina (duplicata)
    ARCHIVE = "archive"        # Arquivar (obsoleto/redundante)
    TAG = "tag"                # Adicionar tags/propriedades faltantes
    REVIEW = "review"          # Precisa decisao humana


@dataclass
class PageAuditResult:
    """Resultado da auditoria de uma pagina."""

    page_id: str
    title: str
    current_location: str
    suggested_location: str
    action: PageAction
    reason: str
    duplicates: list[str] = field(default_factory=list)
    missing_properties: list[str] = field(default_factory=list)
    suggested_tags: list[str] = field(default_factory=list)
    confidence: float = 0.0  # 0-1, abaixo de 0.7 vai pra REVIEW


@dataclass
class CleanupReport:
    """Relatorio completo de limpeza."""

    total_pages: int = 0
    pages_ok: int = 0
    pages_relocated: int = 0
    pages_merged: int = 0
    pages_archived: int = 0
    pages_tagged: int = 0
    pages_need_review: int = 0
    duplicates_found: int = 0
    started_at: str = ""
    finished_at: str = ""
    details: list[dict[str, Any]] = field(default_factory=list)


class NotionCleanerSubagent(BaseAgent):
    """Subagente que limpa e organiza Notion em background.

    Fluxo:
    1. audit    - Varre todas as paginas, classifica estado de cada uma
    2. dedupe   - Identifica e resolve duplicatas
    3. relocate - Move paginas para o lugar correto
    4. tag      - Preenche propriedades faltantes
    5. archive  - Arquiva conteudo obsoleto
    6. report   - Gera relatorio do que fez/precisa de review

    Usa Sonnet/ChatGPT 5.4 para triagem (barato).
    Opus so quando confidence < 0.7 (decisao ambigua).
    """

    # Mapeamento de onde cada tipo de conteudo deve estar
    LOCATION_RULES: dict[str, str] = {
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

    # Propriedades obrigatorias por database
    REQUIRED_PROPERTIES: dict[str, list[str]] = {
        "Knowledge Base Medica": ["Tipo", "Especialidade", "Tags", "Status"],
        "Inbox Medico": ["Fonte", "Prioridade", "Acao"],
        "Digests Semanais": ["Semana", "Ano"],
        "Projetos de Pesquisa": ["Status", "Deadline"],
    }

    def __init__(self) -> None:
        super().__init__(
            name="notion_cleaner",
            description="Limpa e organiza Notion pagina por pagina em background",
        )
        self.audit_results: list[PageAuditResult] = []
        self.report = CleanupReport()
        self._duplicate_groups: dict[str, list[str]] = {}  # title_hash -> [page_ids]

    async def execute(self, task: dict[str, Any]) -> TaskResult:
        """Executa tarefa de limpeza do Notion."""
        self.status = AgentStatus.RUNNING
        action = task.get("action", "")

        try:
            actions_map = {
                "audit": self._audit_pages,
                "deduplicate": self._deduplicate,
                "relocate": self._relocate_pages,
                "tag": self._fill_missing_tags,
                "archive": self._archive_obsolete,
                "report": self._generate_report,
                "full_cleanup": self._full_cleanup,
            }

            handler = actions_map.get(action)
            if handler:
                return await handler(task)
            return TaskResult(success=False, error=f"Unknown action: {action}")
        except Exception as e:
            self.status = AgentStatus.ERROR
            logger.error(f"Notion cleaner error: {e}")
            return TaskResult(success=False, error=str(e))
        finally:
            self.status = AgentStatus.IDLE

    async def plan(self, objective: str) -> list[dict[str, Any]]:
        return [
            {"step": 1, "action": "audit", "desc": "Varrer todas as paginas"},
            {"step": 2, "action": "deduplicate", "desc": "Resolver duplicatas"},
            {"step": 3, "action": "relocate", "desc": "Mover paginas mal posicionadas"},
            {"step": 4, "action": "tag", "desc": "Preencher propriedades faltantes"},
            {"step": 5, "action": "archive", "desc": "Arquivar conteudo obsoleto"},
            {"step": 6, "action": "report", "desc": "Gerar relatorio"},
        ]

    # ------------------------------------------------------------------
    # Core Actions
    # ------------------------------------------------------------------

    async def _audit_pages(self, task: dict[str, Any]) -> TaskResult:
        """Varre todas as paginas e classifica o estado de cada uma.

        Usa Notion MCP para listar paginas, depois Sonnet/5.4
        para classificar cada uma (tipo, localizacao, qualidade).
        """
        self.report.started_at = datetime.now().isoformat()
        self.audit_results.clear()

        # TODO: Integrar com Notion MCP para listar paginas reais
        # Por enquanto, estrutura pronta para receber dados do MCP
        #
        # Fluxo real:
        # 1. notion.search() -> lista todas as paginas
        # 2. Para cada pagina: notion.get_page(page_id) -> conteudo
        # 3. Sonnet classifica: tipo, localizacao correta, tags
        # 4. Se confidence < 0.7: marca como REVIEW (decisao humana)

        pages = task.get("pages", [])
        for page in pages:
            audit = self._classify_page(page)
            self.audit_results.append(audit)

        self.report.total_pages = len(self.audit_results)
        self.report.pages_ok = len([
            a for a in self.audit_results if a.action == PageAction.KEEP
        ])

        logger.info(
            f"Audit complete: {self.report.total_pages} pages, "
            f"{self.report.pages_ok} OK"
        )

        return TaskResult(
            success=True,
            data={
                "total_pages": self.report.total_pages,
                "pages_ok": self.report.pages_ok,
                "needs_action": self.report.total_pages - self.report.pages_ok,
                "actions_summary": self._summarize_actions(),
            },
        )

    async def _deduplicate(self, task: dict[str, Any]) -> TaskResult:
        """Identifica e resolve paginas duplicadas.

        Estrategia:
        - Titulos muito similares (fuzzy match > 85%)
        - Conteudo com overlap > 70%
        - Decisao: manter a mais completa, arquivar a outra
        - Se ambiguo (confidence < 0.7): marca pra review humano
        """
        duplicates_found = 0
        merged = 0

        # Agrupar por similaridade de titulo
        for audit in self.audit_results:
            if audit.duplicates:
                duplicates_found += len(audit.duplicates)
                if audit.confidence >= 0.7:
                    # Auto-merge: manter pagina mais completa
                    audit.action = PageAction.MERGE
                    merged += 1
                else:
                    # Precisa review humano
                    audit.action = PageAction.REVIEW

        self.report.duplicates_found = duplicates_found
        self.report.pages_merged = merged

        return TaskResult(
            success=True,
            data={
                "duplicates_found": duplicates_found,
                "auto_merged": merged,
                "needs_review": duplicates_found - merged,
            },
        )

    async def _relocate_pages(self, task: dict[str, Any]) -> TaskResult:
        """Move paginas para o database/secao correta."""
        relocated = 0

        for audit in self.audit_results:
            if audit.action == PageAction.RELOCATE and audit.confidence >= 0.7:
                # TODO: Notion MCP move_page(page_id, target_database)
                logger.info(
                    f"Relocate: '{audit.title}' "
                    f"{audit.current_location} -> {audit.suggested_location}"
                )
                relocated += 1

        self.report.pages_relocated = relocated

        return TaskResult(
            success=True,
            data={"relocated": relocated},
        )

    async def _fill_missing_tags(self, task: dict[str, Any]) -> TaskResult:
        """Preenche propriedades e tags faltantes nas paginas.

        Usa Sonnet/5.4 para inferir tags baseado no conteudo.
        """
        tagged = 0

        for audit in self.audit_results:
            if audit.action == PageAction.TAG:
                # TODO: Notion MCP update_page(page_id, properties)
                logger.info(
                    f"Tag: '{audit.title}' + {audit.suggested_tags}"
                )
                tagged += 1

        self.report.pages_tagged = tagged

        return TaskResult(
            success=True,
            data={"tagged": tagged, "properties_filled": tagged},
        )

    async def _archive_obsolete(self, task: dict[str, Any]) -> TaskResult:
        """Arquiva paginas obsoletas ou redundantes."""
        archived = 0

        for audit in self.audit_results:
            if audit.action == PageAction.ARCHIVE and audit.confidence >= 0.7:
                # TODO: Notion MCP archive_page(page_id)
                logger.info(f"Archive: '{audit.title}' - {audit.reason}")
                archived += 1

        self.report.pages_archived = archived

        return TaskResult(
            success=True,
            data={"archived": archived},
        )

    async def _generate_report(self, task: dict[str, Any]) -> TaskResult:
        """Gera relatorio completo da limpeza."""
        self.report.finished_at = datetime.now().isoformat()
        self.report.pages_need_review = len([
            a for a in self.audit_results if a.action == PageAction.REVIEW
        ])

        # Paginas que precisam decisao humana
        needs_review = [
            {
                "title": a.title,
                "current": a.current_location,
                "suggested": a.suggested_location,
                "reason": a.reason,
                "confidence": a.confidence,
            }
            for a in self.audit_results
            if a.action == PageAction.REVIEW
        ]

        return TaskResult(
            success=True,
            data={
                "total_pages": self.report.total_pages,
                "ok": self.report.pages_ok,
                "relocated": self.report.pages_relocated,
                "merged": self.report.pages_merged,
                "archived": self.report.pages_archived,
                "tagged": self.report.pages_tagged,
                "needs_review": self.report.pages_need_review,
                "duplicates_found": self.report.duplicates_found,
                "review_items": needs_review,
                "started": self.report.started_at,
                "finished": self.report.finished_at,
            },
        )

    async def _full_cleanup(self, task: dict[str, Any]) -> TaskResult:
        """Executa limpeza completa em sequencia."""
        steps = [
            ("audit", self._audit_pages),
            ("deduplicate", self._deduplicate),
            ("relocate", self._relocate_pages),
            ("tag", self._fill_missing_tags),
            ("archive", self._archive_obsolete),
            ("report", self._generate_report),
        ]

        results = {}
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

        return TaskResult(success=True, data=results)

    # ------------------------------------------------------------------
    # Helpers
    # ------------------------------------------------------------------

    def _classify_page(self, page: dict[str, Any]) -> PageAuditResult:
        """Classifica uma pagina individual.

        Na integracao real, isso chama Sonnet/5.4 para:
        1. Ler o conteudo da pagina
        2. Determinar o tipo (paper, nota, guideline, etc)
        3. Verificar se esta no database certo
        4. Checar propriedades faltantes
        5. Buscar duplicatas por titulo similar
        """
        title = page.get("title", "")
        current_loc = page.get("database", "")
        page_type = page.get("type", "")
        properties = page.get("properties", {})

        # Determinar localizacao correta
        suggested_loc = self.LOCATION_RULES.get(page_type, "Inbox Medico")

        # Verificar propriedades faltantes
        required = self.REQUIRED_PROPERTIES.get(suggested_loc, [])
        missing = [p for p in required if p not in properties]

        # Determinar acao
        if current_loc == suggested_loc and not missing:
            action = PageAction.KEEP
            confidence = 1.0
            reason = "Pagina OK"
        elif current_loc != suggested_loc:
            action = PageAction.RELOCATE
            confidence = 0.8 if page_type else 0.5
            reason = f"Deveria estar em '{suggested_loc}'"
        elif missing:
            action = PageAction.TAG
            confidence = 0.9
            reason = f"Faltam propriedades: {', '.join(missing)}"
        else:
            action = PageAction.REVIEW
            confidence = 0.4
            reason = "Classificacao incerta"

        return PageAuditResult(
            page_id=page.get("id", ""),
            title=title,
            current_location=current_loc,
            suggested_location=suggested_loc,
            action=action,
            reason=reason,
            missing_properties=missing,
            confidence=confidence,
        )

    def _summarize_actions(self) -> dict[str, int]:
        """Resume acoes pendentes por tipo."""
        summary: dict[str, int] = {}
        for audit in self.audit_results:
            key = audit.action.value
            summary[key] = summary.get(key, 0) + 1
        return summary
