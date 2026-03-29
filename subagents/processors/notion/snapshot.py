"""Snapshot and inventory methods for Notion Cleaner.

Step 1 (SNAPSHOT): Le TODAS as paginas do Notion via MCP.
Step 2 (INVENTARIO): Gera arquivo MD legivel como backup local.
"""

from __future__ import annotations

import hashlib
import json
import logging
from datetime import datetime
from pathlib import Path
from typing import TYPE_CHECKING, Any

from agents.core.mcp_safety import OperationMode, SafetyDecision, validate_operation

from .models import NotionPage

if TYPE_CHECKING:
    from .cleaner import NotionCleanerSubagent

logger = logging.getLogger("subagent.notion_cleaner")

SNAPSHOT_DIR = Path("data/snapshots")
SNAPSHOT_MD = Path("data/notion_snapshot.md")


class SnapshotMixin:
    """Mixin with snapshot and inventory methods for NotionCleanerSubagent."""

    async def _fetch_via_mcp(self: NotionCleanerSubagent) -> list[dict[str, Any]]:
        """Busca TODAS as paginas do Notion via MCP (read-only, paginado)."""
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

    async def _take_snapshot(self: NotionCleanerSubagent, task: dict[str, Any]) -> Any:
        """Le TODAS as paginas e databases do Notion via MCP."""
        from agents.core.base_agent import TaskResult

        self._report.started_at = datetime.now().isoformat()
        self._snapshot.clear()
        self._operation_mode = OperationMode.READ_ONLY

        protected = task.get("protected", self.PROTECTED_FILTERS)

        SNAPSHOT_DIR.mkdir(parents=True, exist_ok=True)

        if self._mcp_client:
            raw_pages = await self._fetch_via_mcp()
            pages_data = _normalize_mcp_pages(raw_pages)
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
                (
                    page.page_id,
                    page.title,
                    page.database,
                    page.content_hash,
                    json.dumps(page.properties, ensure_ascii=False),
                    json.dumps({"content_preview": page.content_preview}, ensure_ascii=False),
                ),
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

    async def _generate_inventory_md(self: NotionCleanerSubagent, task: dict[str, Any]) -> Any:
        """Gera arquivo MD com inventario completo do Notion."""
        from agents.core.base_agent import TaskResult

        if not self._snapshot_taken:
            return TaskResult(
                success=False,
                error="Snapshot nao foi feito. Execute 'snapshot' primeiro (anti-perda).",
            )

        by_database: dict[str, list[NotionPage]] = {}
        orphan_pages: list[NotionPage] = []

        for page in self._snapshot:
            if page.database:
                by_database.setdefault(page.database, []).append(page)
            else:
                orphan_pages.append(page)

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

        lines.append("## Resumo por Database")
        lines.append("")
        lines.append("| Database | Paginas | Arquivadas |")
        lines.append("|----------|---------|------------|")
        for db_name, pages in sorted(by_database.items()):
            archived = len([p for p in pages if p.archived])
            lines.append(f"| {db_name} | {len(pages)} | {archived} |")
        lines.append("")

        for db_name, pages in sorted(by_database.items()):
            lines.append(f"## {db_name}")
            lines.append("")
            lines.append("| # | Titulo | Properties | Editado | Hash |")
            lines.append("|---|--------|------------|---------|------|")

            sorted_pages = sorted(
                pages,
                key=lambda p: p.last_edited or "",
                reverse=True,
            )
            for i, page in enumerate(sorted_pages, 1):
                props_summary = ", ".join(page.properties.keys())[:60]
                edited = page.last_edited[:10] if page.last_edited else "?"
                short_hash = page.content_hash[:8] if page.content_hash else "-"
                archived_flag = " [ARCHIVED]" if page.archived else ""
                row = (
                    f"| {i} | {page.title}{archived_flag} "
                    f"| {props_summary} | {edited} | {short_hash} |"
                )
                lines.append(row)

            lines.append("")

            lines.append("<details>")
            lines.append(f"<summary>Preview de conteudo ({len(pages)} paginas)</summary>")
            lines.append("")
            for page in pages:
                if page.content_preview:
                    lines.append(f"### {page.title}")
                    lines.append(f"- **ID**: `{page.page_id}`")
                    lines.append(f"- **URL**: {page.url}")
                    props_json = json.dumps(
                        page.properties,
                        ensure_ascii=False,
                    )
                    lines.append(f"- **Properties**: {props_json}")
                    lines.append("- **Preview**:")
                    lines.append("```")
                    lines.append(page.content_preview)
                    lines.append("```")
                    lines.append("")
            lines.append("</details>")
            lines.append("")

        if orphan_pages:
            lines.append("## Paginas Orfas (sem database)")
            lines.append("")
            lines.append(
                "Estas paginas nao estao em nenhum database. Provavelmente precisam ser realocadas."
            )
            lines.append("")
            for page in orphan_pages:
                lines.append(f"- **{page.title}** (`{page.page_id}`)")
                if page.content_preview:
                    lines.append(f"  > {page.content_preview[:200]}...")
                lines.append("")

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

        SNAPSHOT_DIR.mkdir(parents=True, exist_ok=True)
        SNAPSHOT_MD.write_text("\n".join(lines), encoding="utf-8")

        self._duplicate_groups = {h: [p.page_id for p in pages] for h, pages in duplicates.items()}

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


def _normalize_mcp_pages(raw_pages: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """Converte formato MCP Notion para formato interno."""
    normalized = []
    for raw in raw_pages:
        props = raw.get("properties", {})
        title = ""
        for _prop_name, prop_val in props.items():
            if isinstance(prop_val, dict) and prop_val.get("type") == "title":
                title_parts = prop_val.get("title", [])
                title = "".join(t.get("plain_text", "") for t in title_parts)
                break

        parent = raw.get("parent", {})
        database_id = parent.get("database_id", "")

        normalized.append(
            {
                "id": raw.get("id", ""),
                "title": title or raw.get("id", "untitled"),
                "database": database_id,
                "database_id": database_id,
                "url": raw.get("url", ""),
                "properties": props,
                "content": "",
                "last_edited": raw.get("last_edited_time", ""),
                "created": raw.get("created_time", ""),
                "parent_page_id": parent.get("page_id", ""),
                "archived": raw.get("archived", False),
            }
        )
    return normalized
