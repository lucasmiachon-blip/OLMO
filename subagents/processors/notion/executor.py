"""Execution methods for Notion Cleaner with MCP safety gates.

Step 5 (EXECUTE): Executa acoes aprovadas com checkpoint por step.
Cada write e validado pelo MCP safety protocol.
"""

from __future__ import annotations

import json
import logging
import sqlite3
from pathlib import Path
from typing import TYPE_CHECKING, Any

from agents.core.base_agent import TaskResult
from agents.core.database import log_mcp_operation
from agents.core.mcp_safety import SafetyDecision, validate_operation

if TYPE_CHECKING:
    from .cleaner import NotionCleanerSubagent

logger = logging.getLogger("subagent.notion_cleaner")

SNAPSHOT_DIR = Path("data/snapshots")


class ExecutorMixin:
    """Mixin with execution methods for NotionCleanerSubagent."""

    async def _execute_approved_plan(
        self: NotionCleanerSubagent, task: dict[str, Any]
    ) -> TaskResult:
        """Executa acoes aprovadas pelo humano, com checkpoint por step."""
        if not self._snapshot_taken:
            return TaskResult(
                success=False,
                error=(
                    "Snapshot nao foi feito. Fluxo obrigatorio: "
                    "snapshot -> inventario -> analyze -> plan -> execute."
                ),
            )

        approved = task.get("approved_actions", [])
        if not approved:
            return TaskResult(
                success=False,
                error="Nenhuma acao aprovada. Passe 'approved_actions' com IDs aprovadas.",
            )

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

            if page_id in completed_ids:
                skipped += 1
                continue

            action_type = action.get("action", "")

            try:
                is_update = action_type in ("archive", "tag")
                op = "notion-update-page" if is_update else "notion-create-page"
                safety = validate_operation(
                    op,
                    self._operation_mode,
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
                    await _mcp_relocate(self._mcp_client, page_id, action, db)
                    self._report.pages_relocated += 1
                elif action_type == "merge":
                    await _mcp_archive(self._mcp_client, page_id, action, db)
                    self._report.pages_merged += 1
                elif action_type == "archive":
                    await _mcp_archive(self._mcp_client, page_id, action, db)
                    self._report.pages_archived += 1
                elif action_type == "tag":
                    await _mcp_tag(self._mcp_client, page_id, action, db)
                    self._report.pages_tagged += 1

                executed += 1
                completed_ids.add(page_id)
                _save_checkpoint(self._checkpoint_file, completed_ids)

            except Exception as e:
                errors.append({"page_id": page_id, "error": str(e)})
                logger.error(f"Error executing action on {page_id}: {e}")
                _save_checkpoint(self._checkpoint_file, completed_ids)
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


def _save_checkpoint(checkpoint_file: Path, completed_ids: set[str]) -> None:
    """Salva checkpoint para resume em caso de falha."""
    from datetime import datetime

    SNAPSHOT_DIR.mkdir(parents=True, exist_ok=True)
    checkpoint_file.write_text(
        json.dumps(
            {
                "completed": list(completed_ids),
                "timestamp": datetime.now().isoformat(),
            }
        )
    )


async def _mcp_relocate(
    mcp_client: Any, page_id: str, action: dict[str, Any], db: sqlite3.Connection
) -> None:
    """Relocar pagina: READ -> CREATE no destino -> ARCHIVE original."""
    title = action.get("title", "")
    target_db = action.get("to", "")
    logger.info(f"RELOCATE: '{title}' -> {target_db}")

    if not mcp_client:
        logger.info(f"[DRY-RUN] Would relocate '{title}' to '{target_db}'")
        return

    original = await mcp_client.call_tool("notion-retrieve-page", {"page_id": page_id})
    state_before = json.dumps(original, ensure_ascii=False, default=str)

    new_page = await mcp_client.call_tool(
        "notion-create-page",
        {
            "parent": {"database_id": target_db},
            "properties": original.get("properties", {}),
        },
    )

    new_page_id = new_page.get("id", "") if isinstance(new_page, dict) else ""
    if new_page_id:
        verify = await mcp_client.call_tool("notion-retrieve-page", {"page_id": new_page_id})
        if not verify:
            raise RuntimeError(f"Verificacao falhou para nova pagina {new_page_id}")

    await mcp_client.call_tool("notion-update-page", {"page_id": page_id, "archived": True})

    state_after = json.dumps({"relocated_to": new_page_id, "archived": page_id}, default=str)
    log_mcp_operation(db, "notion", "relocate", page_id, state_before, state_after)


async def _mcp_archive(
    mcp_client: Any, page_id: str, action: dict[str, Any], db: sqlite3.Connection
) -> None:
    """Arquiva pagina (soft-delete, reversivel 30 dias)."""
    title = action.get("title", "")
    logger.info(f"ARCHIVE: '{title}'")

    if not mcp_client:
        logger.info(f"[DRY-RUN] Would archive '{title}'")
        return

    original = await mcp_client.call_tool("notion-retrieve-page", {"page_id": page_id})
    state_before = json.dumps(original, ensure_ascii=False, default=str)

    await mcp_client.call_tool("notion-update-page", {"page_id": page_id, "archived": True})

    log_mcp_operation(db, "notion", "archive", page_id, state_before, '{"archived": true}')


async def _mcp_tag(
    mcp_client: Any, page_id: str, action: dict[str, Any], db: sqlite3.Connection
) -> None:
    """Adiciona tags/propriedades faltantes a uma pagina."""
    title = action.get("title", "")
    tags = action.get("suggested_tags", [])
    logger.info(f"TAG: '{title}' + {tags}")

    if not mcp_client:
        logger.info(f"[DRY-RUN] Would tag '{title}' with {tags}")
        return

    original = await mcp_client.call_tool("notion-retrieve-page", {"page_id": page_id})
    state_before = json.dumps(original, ensure_ascii=False, default=str)

    properties: dict[str, Any] = {}
    if tags:
        properties["Tags"] = {"multi_select": [{"name": tag} for tag in tags]}

    missing_props = action.get("missing_props", [])
    for prop in missing_props:
        if prop not in properties:
            properties[prop] = {"rich_text": [{"text": {"content": "TODO"}}]}

    await mcp_client.call_tool("notion-update-page", {"page_id": page_id, "properties": properties})

    updated = await mcp_client.call_tool("notion-retrieve-page", {"page_id": page_id})
    state_after = json.dumps(updated, ensure_ascii=False, default=str)

    log_mcp_operation(db, "notion", "tag", page_id, state_before, state_after)
