"""Notion Cleaner subpackage — decomposed from notion_cleaner.py (1078 lines).

Modules:
- models.py    — Data structures (NotionPage, PageAction, etc.)
- snapshot.py  — Snapshot + inventory (Steps 1-2)
- analysis.py  — Classification + audit (Step 3)
- executor.py  — Execution with MCP safety (Step 5)
- cleaner.py   — Main class orchestrating all steps
"""

from .cleaner import NotionCleanerSubagent
from .models import CleanupReport, NotionPage, PageAction, PageAuditResult

__all__ = [
    "CleanupReport",
    "NotionCleanerSubagent",
    "NotionPage",
    "PageAction",
    "PageAuditResult",
]
