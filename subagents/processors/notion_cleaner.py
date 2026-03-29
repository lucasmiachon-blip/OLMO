"""Backward-compat re-export. Real code lives in notion/ subpackage."""

from subagents.processors.notion import NotionCleanerSubagent

__all__ = ["NotionCleanerSubagent"]
