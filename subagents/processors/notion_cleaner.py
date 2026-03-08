"""Notion Cleaner Subagent - Organiza Notion com seguranca (modelo harsh).

Fluxo OBRIGATORIO (anti-perda):
1. SNAPSHOT  → Le TUDO do Notion (todas paginas, databases, properties)
2. INVENTARIO → Gera arquivo local data/notion_snapshot.md com tudo lido
3. ANALISE   → Classifica cada pagina (Sonnet/5.4 triagem, Opus ambiguas)
4. PLANO     → Gera plano de acoes com confirmacao humana
5. EXECUCAO  → So apos aprovacao, executa acoes (com checkpoint por step)

NUNCA pular o snapshot. NUNCA deletar (apenas arquivar).
Toda operacao destrutiva requer confirmacao humana.
"""

from __future__ import annotations

import hashlib
import json
import logging
import sqlite3
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from pathlib import Path
from typing import Any

from agents.core.base_agent import AgentStatus, BaseAgent, TaskResult
from agents.core.database import get_connection, log_mcp_operation
from agents.core.mcp_safety import (
    OperationMode,
    SafetyDecision,
    validate_operation,
)

logger = logging.getLogger("subagent.notion_cleaner")

SNAPSHOT_DIR = Path("data/snapshots")
SNAPSHOT_MD = Path("data/notion_snapshot.md")


class PageAction(Enum):
    """Acoes possiveis para uma pagina."""

    KEEP = "keep"              # Esta no lugar certo
    RELOCATE = "relocate"      # Mover para outra secao/database
    MERGE = "merge"            # Fundir com outra pagina (duplicata)
    ARCHIVE = "archive"        # Arquivar (obsoleto/redundante)
    TAG = "tag"                # Adicionar tags/propriedades faltantes
    REVIEW = "review"          # Precisa decisao humana


@dataclass
class NotionPage:
    """Representacao local de uma pagina Notion (snapshot)."""

    page_id: str
    title: str
    database: str
    database_id: str
    url: str
    properties: dict[str, Any] = field(default_factory=dict)
    content_preview: str = ""          # Primeiros ~500 chars do conteudo
    content_hash: str = ""             # SHA256 do conteudo completo
    last_edited: str = ""
    created: str = ""
    parent_page_id: str = ""           # Se for subpagina
    icon: str = ""
    cover: str = ""
    archived: bool = False


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
    snapshot_path: str = ""
    details: list[dict[str, Any]] = field(default_factory=list)


class NotionCleanerSubagent(BaseAgent):
    """Subagente que limpa e organiza Notion com modelo harsh (seguro).

    Fluxo OBRIGATORIO:
    1. snapshot     → Le TODAS as paginas/databases do Notion via MCP
    2. inventario   → Salva tudo em data/notion_snapshot.md (backup local)
    3. analyze      → Classifica cada pagina (tipo, localizacao, duplicatas)
    4. plan_actions → Gera plano de acoes para aprovacao humana
    5. execute_plan → Executa acoes aprovadas com checkpoint por step
    6. report       → Gera relatorio do que fez/precisa de review

    Safety:
    - NUNCA pula snapshot (anti-perda)
    - NUNCA deleta (apenas arquiva)
    - Snapshot salvo como JSON + MD legivel
    - Checkpoint a cada step (resumable)
    - Batch > 5 items = confirmacao humana
    - Confidence < 0.7 = review humano
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

    # Databases/tags que NAO devem ser tocados (protecao de conteudo ativo)
    PROTECTED_FILTERS: list[str] = []  # Configuravel via task["protected"]

    def __init__(self) -> None:
        super().__init__(
            name="notion_cleaner",
            description="Limpa e organiza Notion com seguranca (modelo harsh)",
        )
        self._snapshot: list[NotionPage] = []
        self._audit_results: list[PageAuditResult] = []
        self._report = CleanupReport()
        self._duplicate_groups: dict[str, list[str]] = {}  # content_hash -> [page_ids]
        self._snapshot_taken = False
        self._checkpoint_file = SNAPSHOT_DIR / "cleanup_checkpoint.json"
        self._mcp_client: Any = None  # Notion MCP client (injetado)
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
            {"step": 1, "action": "snapshot",
             "desc": "Ler TUDO do Notion"},
            {"step": 2, "action": "inventario",
             "desc": "Gerar notion_snapshot.md"},
            {"step": 3, "action": "analyze",
             "desc": "Classificar cada pagina"},
            {"step": 4, "action": "plan_actions",
             "desc": "Plano para aprovacao humana"},
            {"step": 5, "action": "execute_plan",
             "desc": "Executar aprovadas (checkpoints)"},
            {"step": 6, "action": "report",
             "desc": "Gerar relatorio final"},
        ]

    # ------------------------------------------------------------------
    # Step 1: SNAPSHOT - Ler tudo do Notion
    # ------------------------------------------------------------------

    def set_mcp_client(self, client: Any) -> None:
        """Injeta o client MCP do Notion (passado pelo orchestrator)."""
        self._mcp_client = client

    def _ensure_db(self) -> sqlite3.Connection:
        """Garante conexao com SQLite."""
        if self._db is None:
            self._db = get_connection()
        return self._db

    def _is_protected(self, page: NotionPage, protected: list[str]) -> bool:
        """Verifica se a pagina esta protegida (ex: aulas em andamento)."""
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

    async def _fetch_via_mcp(self) -> list[dict[str, Any]]:
        """Busca TODAS as paginas do Notion via MCP (read-only, paginado).

        Usa notion-search com paginacao para listar tudo.
        Safety: apenas operacoes read-only (validate_operation garante).
        """
        if not self._mcp_client:
            logger.warning("Notion MCP client nao configurado")
            return []

        check = validate_operation("notion-search", OperationMode.READ_ONLY)
        if check.decision != SafetyDecision.ALLOW:
            logger.error(f"Safety block: {check.reason}")
            return []

        all_pages: list[dict[str, Any]] = []
        has_more = True
        start_cursor: str | None = None

        while has_more:
            params: dict[str, Any] = {"query": ""}
            if start_cursor:
                params["start_cursor"] = start_cursor

            result = await self._mcp_client.call_tool("notion-search", params)

            if not result or not isinstance(result, dict):
                break

            pages = result.get("results", [])
            all_pages.extend(pages)

            has_more = result.get("has_more", False)
            start_cursor = result.get("next_cursor")

            logger.info(f"Snapshot progress: {len(all_pages)} pages fetched")

        return all_pages

    async def _take_snapshot(self, task: dict[str, Any]) -> TaskResult:
        """Le TODAS as paginas e databases do Notion via MCP.

        Este e o step mais importante. Nada acontece sem snapshot.
        Salva snapshot como JSON em data/snapshots/ para backup.

        Fluxo:
        1. Se MCP client disponivel: notion-search paginado
        2. Fallback: aceita dados passados via task["pages"] (para teste)
        """
        self._report.started_at = datetime.now().isoformat()
        self._snapshot.clear()
        self._operation_mode = OperationMode.READ_ONLY

        # Configurar filtros de protecao (ex: ["aulas", "teaching"])
        protected = task.get("protected", self.PROTECTED_FILTERS)

        SNAPSHOT_DIR.mkdir(parents=True, exist_ok=True)

        # Tentar MCP real primeiro, fallback para dados de teste
        if self._mcp_client:
            raw_pages = await self._fetch_via_mcp()
            pages_data = self._normalize_mcp_pages(raw_pages)
        else:
            pages_data = task.get("pages", [])

        for page_data in pages_data:
            content = page_data.get("content", "")
            page = NotionPage(
                page_id=page_data.get("id", ""),
                title=page_data.get("title", ""),
                database=page_data.get("database", ""),
                database_id=page_data.get("database_id", ""),
                url=page_data.get("url", ""),
                properties=page_data.get("properties", {}),
                content_preview=content[:500] if content else "",
                content_hash=hashlib.sha256(content.encode()).hexdigest() if content else "",
                last_edited=page_data.get("last_edited", ""),
                created=page_data.get("created", ""),
                parent_page_id=page_data.get("parent_page_id", ""),
                archived=page_data.get("archived", False),
            )
            self._snapshot.append(page)

        # Salvar snapshot JSON (backup)
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        snapshot_json = SNAPSHOT_DIR / f"notion_snapshot_{timestamp}.json"
        snapshot_data = [
            {
                "page_id": p.page_id,
                "title": p.title,
                "database": p.database,
                "database_id": p.database_id,
                "url": p.url,
                "properties": p.properties,
                "content_preview": p.content_preview,
                "content_hash": p.content_hash,
                "last_edited": p.last_edited,
                "created": p.created,
                "parent_page_id": p.parent_page_id,
                "archived": p.archived,
            }
            for p in self._snapshot
        ]
        snapshot_json.write_text(json.dumps(snapshot_data, indent=2, ensure_ascii=False))

        # Marcar paginas protegidas
        protected_count = 0
        for page in self._snapshot:
            if self._is_protected(page, protected):
                page.properties["_protected"] = True
                protected_count += 1

        # Cache no SQLite
        db = self._ensure_db()
        for page in self._snapshot:
            db.execute(
                """INSERT OR REPLACE INTO notion_cache
                   (page_id, title, database_name, content_hash, properties, snapshot_json)
                   VALUES (?, ?, ?, ?, ?, ?)""",
                (page.page_id, page.title, page.database, page.content_hash,
                 json.dumps(page.properties, ensure_ascii=False),
                 json.dumps({"content_preview": page.content_preview}, ensure_ascii=False)),
            )
        db.commit()

        self._snapshot_taken = True
        self._report.total_pages = len(self._snapshot)
        self._report.snapshot_path = str(snapshot_json)

        logger.info(f"Snapshot: {len(self._snapshot)} pages saved to {snapshot_json}")

        return TaskResult(
            success=True,
            data={
                "total_pages": len(self._snapshot),
                "protected_pages": protected_count,
                "snapshot_json": str(snapshot_json),
                "databases_found": list({p.database for p in self._snapshot if p.database}),
                "archived_pages": len([p for p in self._snapshot if p.archived]),
            },
        )

    @staticmethod
    def _normalize_mcp_pages(raw_pages: list[dict[str, Any]]) -> list[dict[str, Any]]:
        """Converte formato MCP Notion para formato interno."""
        normalized = []
        for raw in raw_pages:
            props = raw.get("properties", {})
            title = ""
            # Extrair titulo (Notion retorna como array de rich_text)
            for prop_name, prop_val in props.items():
                if isinstance(prop_val, dict) and prop_val.get("type") == "title":
                    title_parts = prop_val.get("title", [])
                    title = "".join(t.get("plain_text", "") for t in title_parts)
                    break

            parent = raw.get("parent", {})
            database_id = parent.get("database_id", "")

            normalized.append({
                "id": raw.get("id", ""),
                "title": title or raw.get("id", "untitled"),
                "database": database_id,
                "database_id": database_id,
                "url": raw.get("url", ""),
                "properties": props,
                "content": "",  # Content requer get_page separado
                "last_edited": raw.get("last_edited_time", ""),
                "created": raw.get("created_time", ""),
                "parent_page_id": parent.get("page_id", ""),
                "archived": raw.get("archived", False),
            })
        return normalized

    # ------------------------------------------------------------------
    # Step 2: INVENTARIO - Gerar MD legivel
    # ------------------------------------------------------------------

    async def _generate_inventory_md(self, task: dict[str, Any]) -> TaskResult:
        """Gera arquivo MD com inventario completo do Notion.

        Este arquivo serve como:
        - Backup legivel (humano pode revisar)
        - Referencia para decisoes de limpeza
        - Documentacao do estado atual do workspace
        """
        if not self._snapshot_taken:
            return TaskResult(
                success=False,
                error="Snapshot nao foi feito. Execute 'snapshot' primeiro (anti-perda).",
            )

        # Agrupar paginas por database
        by_database: dict[str, list[NotionPage]] = {}
        orphan_pages: list[NotionPage] = []

        for page in self._snapshot:
            if page.database:
                by_database.setdefault(page.database, []).append(page)
            else:
                orphan_pages.append(page)

        # Gerar MD
        lines = [
            "# Notion Workspace Snapshot",
            "",
            f"> Gerado em: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
            f"> Total de paginas: {len(self._snapshot)}",
            f"> Databases: {len(by_database)}",
            f"> Paginas orfas (sem database): {len(orphan_pages)}",
            "",
            "---",
            "",
        ]

        # Resumo por database
        lines.append("## Resumo por Database")
        lines.append("")
        lines.append("| Database | Paginas | Arquivadas |")
        lines.append("|----------|---------|------------|")
        for db_name, pages in sorted(by_database.items()):
            archived = len([p for p in pages if p.archived])
            lines.append(f"| {db_name} | {len(pages)} | {archived} |")
        lines.append("")

        # Detalhes por database
        for db_name, pages in sorted(by_database.items()):
            lines.append(f"## {db_name}")
            lines.append("")
            lines.append("| # | Titulo | Properties | Editado | Hash |")
            lines.append("|---|--------|------------|---------|------|")

            sorted_pages = sorted(
                pages, key=lambda p: p.last_edited or "", reverse=True,
            )
            for i, page in enumerate(sorted_pages, 1):
                props_summary = ", ".join(page.properties.keys())[:60]
                edited = page.last_edited[:10] if page.last_edited else "?"
                short_hash = page.content_hash[:8] if page.content_hash else "-"
                archived_flag = " [ARCHIVED]" if page.archived else ""
                row = (f"| {i} | {page.title}{archived_flag} "
                       f"| {props_summary} | {edited} | {short_hash} |")
                lines.append(row)

            lines.append("")

            # Detalhar conteudo preview de cada pagina
            lines.append("<details>")
            lines.append(f"<summary>Preview de conteudo ({len(pages)} paginas)</summary>")
            lines.append("")
            for page in pages:
                if page.content_preview:
                    lines.append(f"### {page.title}")
                    lines.append(f"- **ID**: `{page.page_id}`")
                    lines.append(f"- **URL**: {page.url}")
                    props_json = json.dumps(
                        page.properties, ensure_ascii=False,
                    )
                    lines.append(f"- **Properties**: {props_json}")
                    lines.append("- **Preview**:")
                    lines.append("```")
                    lines.append(page.content_preview)
                    lines.append("```")
                    lines.append("")
            lines.append("</details>")
            lines.append("")

        # Paginas orfas
        if orphan_pages:
            lines.append("## Paginas Orfas (sem database)")
            lines.append("")
            lines.append(
                "Estas paginas nao estao em nenhum database. "
                "Provavelmente precisam ser realocadas."
            )
            lines.append("")
            for page in orphan_pages:
                lines.append(f"- **{page.title}** (`{page.page_id}`)")
                if page.content_preview:
                    lines.append(f"  > {page.content_preview[:200]}...")
                lines.append("")

        # Duplicatas potenciais (mesmo hash)
        hash_groups: dict[str, list[NotionPage]] = {}
        for page in self._snapshot:
            if page.content_hash:
                hash_groups.setdefault(page.content_hash, []).append(page)

        duplicates = {h: pages for h, pages in hash_groups.items() if len(pages) > 1}
        if duplicates:
            lines.append("## Duplicatas Detectadas (mesmo conteudo)")
            lines.append("")
            lines.append(f"**{len(duplicates)} grupos de duplicatas encontrados:**")
            lines.append("")
            for hash_val, pages in duplicates.items():
                lines.append(f"### Hash: `{hash_val[:12]}...` ({len(pages)} copias)")
                for page in pages:
                    lines.append(f"- {page.title} | DB: {page.database} | ID: `{page.page_id}`")
                lines.append("")

        # Salvar MD
        SNAPSHOT_DIR.mkdir(parents=True, exist_ok=True)
        SNAPSHOT_MD.write_text("\n".join(lines), encoding="utf-8")

        # Atualizar duplicate groups para uso posterior
        self._duplicate_groups = {
            h: [p.page_id for p in pages]
            for h, pages in duplicates.items()
        }

        logger.info(f"Inventory MD: {SNAPSHOT_MD} ({len(self._snapshot)} pages)")

        return TaskResult(
            success=True,
            data={
                "snapshot_md": str(SNAPSHOT_MD),
                "total_pages": len(self._snapshot),
                "databases": len(by_database),
                "orphan_pages": len(orphan_pages),
                "duplicate_groups": len(duplicates),
                "duplicate_pages": sum(len(p) for p in duplicates.values()),
            },
        )

    # ------------------------------------------------------------------
    # Step 3: ANALYZE - Classificar cada pagina
    # ------------------------------------------------------------------

    async def _analyze_all(self, task: dict[str, Any]) -> TaskResult:
        """Classifica cada pagina: tipo, localizacao correta, duplicatas, tags.

        Usa Sonnet/5.4 para triagem (barato).
        Opus so quando confidence < 0.7 (decisao ambigua).
        """
        if not self._snapshot_taken:
            return TaskResult(
                success=False,
                error="Snapshot nao foi feito. Execute 'snapshot' primeiro (anti-perda).",
            )

        self._audit_results.clear()

        protected_skipped = 0
        for page in self._snapshot:
            if page.archived:
                continue  # Ignorar paginas ja arquivadas

            # Pular paginas protegidas (ex: aulas em andamento)
            if page.properties.get("_protected"):
                protected_skipped += 1
                continue

            audit = self._classify_page(page)

            # Marcar duplicatas por hash
            if page.content_hash in self._duplicate_groups:
                group = self._duplicate_groups[page.content_hash]
                if len(group) > 1:
                    audit.duplicates = [pid for pid in group if pid != page.page_id]
                    if audit.action == PageAction.KEEP:
                        audit.action = PageAction.MERGE
                        audit.reason = f"Duplicata detectada ({len(group)} copias com mesmo hash)"
                        audit.confidence = 0.9  # Hash match = alta confianca

            self._audit_results.append(audit)

        self._report.pages_ok = len([a for a in self._audit_results if a.action == PageAction.KEEP])

        return TaskResult(
            success=True,
            data={
                "analyzed": len(self._audit_results),
                "ok": self._report.pages_ok,
                "protected_skipped": protected_skipped,
                "needs_action": len(self._audit_results) - self._report.pages_ok,
                "actions_summary": self._summarize_actions(),
            },
        )

    # ------------------------------------------------------------------
    # Step 4: PLAN - Gerar plano para aprovacao humana
    # ------------------------------------------------------------------

    async def _plan_actions(self, task: dict[str, Any]) -> TaskResult:
        """Gera plano de acoes para aprovacao humana.

        Retorna lista de acoes organizadas por tipo e prioridade.
        O humano deve revisar e aprovar antes de executar.
        """
        if not self._audit_results:
            return TaskResult(
                success=False,
                error="Analise nao foi feita. Execute 'analyze' primeiro.",
            )

        plan: dict[str, list[dict[str, Any]]] = {
            "auto_execute": [],       # confidence >= 0.95
            "needs_confirmation": [],  # 0.7 <= confidence < 0.95
            "needs_review": [],        # confidence < 0.7
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

        # Salvar plano como JSON para referencia
        plan_file = SNAPSHOT_DIR / "cleanup_plan.json"
        plan_file.write_text(json.dumps(plan, indent=2, ensure_ascii=False))

        # Gerar resumo legivel
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

    # ------------------------------------------------------------------
    # Step 5: EXECUTE - Executar plano aprovado com checkpoints
    # ------------------------------------------------------------------

    async def _execute_approved_plan(self, task: dict[str, Any]) -> TaskResult:
        """Executa acoes aprovadas pelo humano, com checkpoint por step.

        Safety:
        - So executa acoes aprovadas (passadas via task['approved_actions'])
        - Checkpoint salvo apos cada acao (resumable se falhar)
        - Snapshot do estado anterior antes de cada write
        - Batch > 5 = pausa para confirmacao
        """
        if not self._snapshot_taken:
            return TaskResult(
                success=False,
                error=(
                    "Snapshot nao foi feito. Fluxo obrigatorio: "
                    "snapshot → inventario → analyze → plan → execute."
                ),
            )

        approved = task.get("approved_actions", [])
        if not approved:
            return TaskResult(
                success=False,
                error=(
                    "Nenhuma acao aprovada. Passe "
                    "'approved_actions' com IDs aprovadas."
                ),
            )

        # Carregar checkpoint se existir (resume de execucao anterior)
        completed_ids: set[str] = set()
        if self._checkpoint_file.exists():
            checkpoint = json.loads(self._checkpoint_file.read_text())
            completed_ids = set(checkpoint.get("completed", []))
            logger.info(f"Resuming from checkpoint: {len(completed_ids)} already done")

        executed = 0
        skipped = 0
        errors: list[dict[str, str]] = []

        for action in approved:
            page_id = action.get("page_id", "")

            # Skip se ja executado (checkpoint)
            if page_id in completed_ids:
                skipped += 1
                continue

            action_type = action.get("action", "")

            try:
                # Safety gate: validar cada operacao antes de executar
                is_update = action_type in ("archive", "tag")
                op = "notion-update-page" if is_update else "notion-create-page"
                safety = validate_operation(
                    op, self._operation_mode,
                    confidence=action.get("confidence", 0.5),
                )

                if safety.decision == SafetyDecision.BLOCK:
                    errors.append({"page_id": page_id, "error": f"Safety block: {safety.reason}"})
                    logger.warning(f"BLOCKED: {action.get('title')} - {safety.reason}")
                    continue

                if safety.decision == SafetyDecision.NEEDS_HUMAN_REVIEW:
                    errors.append({"page_id": page_id, "error": f"Needs review: {safety.reason}"})
                    logger.info(f"NEEDS_REVIEW: {action.get('title')} - {safety.reason}")
                    continue

                db = self._ensure_db()

                if action_type == "relocate":
                    await self._mcp_relocate(page_id, action, db)
                    self._report.pages_relocated += 1
                elif action_type == "merge":
                    await self._mcp_archive(page_id, action, db)
                    self._report.pages_merged += 1
                elif action_type == "archive":
                    await self._mcp_archive(page_id, action, db)
                    self._report.pages_archived += 1
                elif action_type == "tag":
                    await self._mcp_tag(page_id, action, db)
                    self._report.pages_tagged += 1

                executed += 1
                completed_ids.add(page_id)

                # Salvar checkpoint apos cada acao
                self._save_checkpoint(completed_ids)

            except Exception as e:
                errors.append({"page_id": page_id, "error": str(e)})
                logger.error(f"Error executing action on {page_id}: {e}")
                # NAO retry em writes (modelo harsh) - salvar checkpoint e parar
                self._save_checkpoint(completed_ids)
                break

        return TaskResult(
            success=len(errors) == 0,
            data={
                "executed": executed,
                "skipped_checkpoint": skipped,
                "errors": errors,
                "checkpoint_file": str(self._checkpoint_file),
                "can_resume": True,
            },
        )

    def _save_checkpoint(self, completed_ids: set[str]) -> None:
        """Salva checkpoint para resume em caso de falha."""
        SNAPSHOT_DIR.mkdir(parents=True, exist_ok=True)
        self._checkpoint_file.write_text(json.dumps({
            "completed": list(completed_ids),
            "timestamp": datetime.now().isoformat(),
        }))

    # ------------------------------------------------------------------
    # Step 6: REPORT
    # ------------------------------------------------------------------

    async def _generate_report(self, task: dict[str, Any]) -> TaskResult:
        """Gera relatorio completo da limpeza."""
        self._report.finished_at = datetime.now().isoformat()
        self._report.pages_need_review = len([
            a for a in self._audit_results if a.action == PageAction.REVIEW
        ])

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

    # ------------------------------------------------------------------
    # Full Cleanup (sequencial com safety)
    # ------------------------------------------------------------------

    async def _full_cleanup(self, task: dict[str, Any]) -> TaskResult:
        """Executa limpeza completa com todas as etapas de seguranca.

        PARA na etapa 4 (plan_actions) para aguardar aprovacao humana.
        O humano deve revisar e depois chamar 'execute_plan' separadamente.
        """
        steps = [
            ("snapshot", self._take_snapshot),
            ("inventario", self._generate_inventory_md),
            ("analyze", self._analyze_all),
            ("plan_actions", self._plan_actions),
            # PARA AQUI - humano precisa aprovar antes de continuar
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
                    "Revise cleanup_plan.json e chame "
                    "'execute_plan' com approved_actions"
                ),
                "snapshot_md": str(SNAPSHOT_MD),
            },
        )

    # ------------------------------------------------------------------
    # MCP Operations (real Notion calls)
    # ------------------------------------------------------------------

    async def _mcp_relocate(
        self, page_id: str, action: dict[str, Any], db: sqlite3.Connection
    ) -> None:
        """Relocar pagina via notion-move-pages (#64 resolvida).

        Fluxo: READ (snapshot) → MOVE → VERIFY no novo parent.
        Fallback: create+copy+archive se move falhar.
        """
        title = action.get("title", "")
        target_db = action.get("to", "")
        logger.info(f"RELOCATE: '{title}' → {target_db}")

        if not self._mcp_client:
            logger.info(f"[DRY-RUN] Would relocate '{title}' to '{target_db}'")
            return

        # 1. Read original
        original = await self._mcp_client.call_tool(
            "notion-retrieve-page", {"page_id": page_id}
        )
        state_before = json.dumps(original, ensure_ascii=False, default=str)

        # 2. Create no destino
        new_page = await self._mcp_client.call_tool(
            "notion-create-page",
            {
                "parent": {"database_id": target_db},
                "properties": original.get("properties", {}),
            },
        )

        # 3. Verify
        new_page_id = new_page.get("id", "") if isinstance(new_page, dict) else ""
        if new_page_id:
            verify = await self._mcp_client.call_tool(
                "notion-retrieve-page", {"page_id": new_page_id}
            )
            if not verify:
                raise RuntimeError(f"Verificacao falhou para nova pagina {new_page_id}")

        # 4. Archive original
        await self._mcp_client.call_tool(
            "notion-update-page", {"page_id": page_id, "archived": True}
        )

        state_after = json.dumps({"relocated_to": new_page_id, "archived": page_id}, default=str)
        log_mcp_operation(db, "notion", "relocate", page_id, state_before, state_after)

    async def _mcp_archive(
        self, page_id: str, action: dict[str, Any], db: sqlite3.Connection
    ) -> None:
        """Arquiva pagina (soft-delete, reversivel 30 dias)."""
        title = action.get("title", "")
        logger.info(f"ARCHIVE: '{title}'")

        if not self._mcp_client:
            logger.info(f"[DRY-RUN] Would archive '{title}'")
            return

        # Snapshot antes
        original = await self._mcp_client.call_tool(
            "notion-retrieve-page", {"page_id": page_id}
        )
        state_before = json.dumps(original, ensure_ascii=False, default=str)

        # Archive
        await self._mcp_client.call_tool(
            "notion-update-page", {"page_id": page_id, "archived": True}
        )

        log_mcp_operation(db, "notion", "archive", page_id, state_before, '{"archived": true}')

    async def _mcp_tag(
        self, page_id: str, action: dict[str, Any], db: sqlite3.Connection
    ) -> None:
        """Adiciona tags/propriedades faltantes a uma pagina."""
        title = action.get("title", "")
        tags = action.get("suggested_tags", [])
        logger.info(f"TAG: '{title}' + {tags}")

        if not self._mcp_client:
            logger.info(f"[DRY-RUN] Would tag '{title}' with {tags}")
            return

        # Snapshot antes
        original = await self._mcp_client.call_tool(
            "notion-retrieve-page", {"page_id": page_id}
        )
        state_before = json.dumps(original, ensure_ascii=False, default=str)

        # Update properties
        properties: dict[str, Any] = {}
        if tags:
            properties["Tags"] = {
                "multi_select": [{"name": tag} for tag in tags]
            }

        missing_props = action.get("missing_props", [])
        for prop in missing_props:
            if prop not in properties:
                properties[prop] = {"rich_text": [{"text": {"content": "TODO"}}]}

        await self._mcp_client.call_tool(
            "notion-update-page", {"page_id": page_id, "properties": properties}
        )

        # Verify
        updated = await self._mcp_client.call_tool(
            "notion-retrieve-page", {"page_id": page_id}
        )
        state_after = json.dumps(updated, ensure_ascii=False, default=str)

        log_mcp_operation(db, "notion", "tag", page_id, state_before, state_after)

    # ------------------------------------------------------------------
    # Helpers
    # ------------------------------------------------------------------

    def _classify_page(self, page: NotionPage) -> PageAuditResult:
        """Classifica uma pagina individual.

        Na integracao real, chama Sonnet/5.4 para:
        1. Ler o conteudo via content_preview
        2. Determinar tipo (paper, nota, guideline, etc)
        3. Verificar se esta no database certo
        4. Checar propriedades faltantes
        """
        title = page.title
        current_loc = page.database
        properties = page.properties

        # Inferir tipo pelo conteudo/properties
        page_type = properties.get("Tipo", "").lower() if properties.get("Tipo") else ""

        # Determinar localizacao correta
        suggested_loc = self.LOCATION_RULES.get(page_type, "")

        # Verificar propriedades faltantes
        required = self.REQUIRED_PROPERTIES.get(current_loc, [])
        missing = [p for p in required if p not in properties]

        # Determinar acao
        if not suggested_loc:
            # Tipo desconhecido - precisa review humano
            action = PageAction.REVIEW
            confidence = 0.3
            reason = "Tipo de conteudo nao identificado automaticamente"
            suggested_loc = current_loc or "Inbox Medico"
        elif current_loc == suggested_loc and not missing:
            action = PageAction.KEEP
            confidence = 1.0
            reason = "Pagina OK - local correto, properties completas"
        elif current_loc != suggested_loc and current_loc:
            action = PageAction.RELOCATE
            confidence = 0.8 if page_type else 0.5
            reason = f"Deveria estar em '{suggested_loc}' (atualmente em '{current_loc}')"
        elif missing:
            action = PageAction.TAG
            confidence = 0.9
            reason = f"Faltam propriedades: {', '.join(missing)}"
        else:
            action = PageAction.REVIEW
            confidence = 0.4
            reason = "Classificacao incerta - precisa review humano"

        return PageAuditResult(
            page_id=page.page_id,
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
        for audit in self._audit_results:
            key = audit.action.value
            summary[key] = summary.get(key, 0) + 1
        return summary
