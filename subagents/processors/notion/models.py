"""Data models for Notion Cleaner.

Estruturas de dados usadas pelo cleaner: paginas, resultados de auditoria,
relatorios. Separados para manter o cleaner principal enxuto.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from typing import Any


class PageAction(Enum):
    """Acoes possiveis para uma pagina."""

    KEEP = "keep"  # Esta no lugar certo
    RELOCATE = "relocate"  # Mover para outra secao/database
    MERGE = "merge"  # Fundir com outra pagina (duplicata)
    ARCHIVE = "archive"  # Arquivar (obsoleto/redundante)
    TAG = "tag"  # Adicionar tags/propriedades faltantes
    REVIEW = "review"  # Precisa decisao humana


@dataclass
class NotionPage:
    """Representacao local de uma pagina Notion (snapshot)."""

    page_id: str
    title: str
    database: str
    database_id: str
    url: str
    properties: dict[str, Any] = field(default_factory=dict)
    content_preview: str = ""  # Primeiros ~500 chars do conteudo
    content_hash: str = ""  # SHA256 do conteudo completo
    last_edited: str = ""
    created: str = ""
    parent_page_id: str = ""  # Se for subpagina
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
