"""Analysis and classification methods for Notion Cleaner.

Step 3 (ANALYZE): Classifica cada pagina por tipo, localizacao, duplicatas.
"""

from __future__ import annotations

import logging
from typing import TYPE_CHECKING, Any

from agents.core.base_agent import TaskResult

from .models import NotionPage, PageAction, PageAuditResult

if TYPE_CHECKING:
    from .cleaner import NotionCleanerSubagent

logger = logging.getLogger("subagent.notion_cleaner")


class AnalysisMixin:
    """Mixin with analysis methods for NotionCleanerSubagent."""

    async def _analyze_all(self: NotionCleanerSubagent, task: dict[str, Any]) -> TaskResult:  # type: ignore[misc]
        """Classifica cada pagina: tipo, localizacao correta, duplicatas, tags."""
        if not self._snapshot_taken:
            return TaskResult(
                success=False,
                error="Snapshot nao foi feito. Execute 'snapshot' primeiro (anti-perda).",
            )

        self._audit_results.clear()

        protected_skipped = 0
        for page in self._snapshot:
            if page.archived:
                continue

            if page.properties.get("_protected"):
                protected_skipped += 1
                continue

            audit = _classify_page(page, self.LOCATION_RULES, self.REQUIRED_PROPERTIES)

            if page.content_hash in self._duplicate_groups:
                group = self._duplicate_groups[page.content_hash]
                if len(group) > 1:
                    audit.duplicates = [pid for pid in group if pid != page.page_id]
                    if audit.action == PageAction.KEEP:
                        audit.action = PageAction.MERGE
                        audit.reason = f"Duplicata detectada ({len(group)} copias com mesmo hash)"
                        audit.confidence = 0.9

            self._audit_results.append(audit)

        self._report.pages_ok = len([a for a in self._audit_results if a.action == PageAction.KEEP])

        return TaskResult(
            success=True,
            data={
                "analyzed": len(self._audit_results),
                "ok": self._report.pages_ok,
                "protected_skipped": protected_skipped,
                "needs_action": len(self._audit_results) - self._report.pages_ok,
                "actions_summary": _summarize_actions(self._audit_results),
            },
        )


def _classify_page(
    page: NotionPage,
    location_rules: dict[str, str],
    required_properties: dict[str, list[str]],
) -> PageAuditResult:
    """Classifica uma pagina individual."""
    title = page.title
    current_loc = page.database
    properties = page.properties

    page_type = properties.get("Tipo", "").lower() if properties.get("Tipo") else ""

    suggested_loc = location_rules.get(page_type, "")

    required = required_properties.get(current_loc, [])
    missing = [p for p in required if p not in properties]

    if not suggested_loc:
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


def _summarize_actions(audit_results: list[PageAuditResult]) -> dict[str, int]:
    """Resume acoes pendentes por tipo."""
    summary: dict[str, int] = {}
    for audit in audit_results:
        key = audit.action.value
        summary[key] = summary.get(key, 0) + 1
    return summary
