"""MCP Safety Gates - Validacao de operacoes MCP antes da execucao.

Implementa o protocolo de .claude/rules/mcp_safety.md:
- Read-only por padrao
- Nunca batch writes
- Nunca retry em erro de write
- Confidence thresholds (harsh model)
- Cross-validation para operacoes criticas
"""

from __future__ import annotations

import logging
import math
from dataclasses import dataclass
from enum import Enum

logger = logging.getLogger("core.mcp_safety")


class OperationMode(Enum):
    READ_ONLY = "read_only"
    WRITE = "write"


class SafetyDecision(Enum):
    ALLOW = "allow"
    BLOCK = "block"
    NEEDS_HUMAN_REVIEW = "needs_human_review"


# Operacoes que sao sempre read-only (seguras)
# Synced with actual Notion MCP API names (2026-03-31)
READ_ONLY_OPERATIONS = frozenset(
    {
        "notion-search",
        "notion-fetch",
        "notion-get-comments",
        "notion-get-users",
        "notion-get-teams",
        "notion-query-database-view",
        "notion-query-meeting-notes",
        "notion-retrieve-page",  # usado em validate_move + executor
    }
)

# Operacoes de write (requerem validacao)
# Synced with actual Notion MCP API names (2026-03-31)
WRITE_OPERATIONS = frozenset(
    {
        "notion-create-pages",
        "notion-update-page",
        "notion-create-comment",
        "notion-create-database",
        "notion-create-view",
        "notion-update-view",
        "notion-update-data-source",
        "notion-duplicate-page",
        "notion-move-pages",
    }
)

# Operacoes de move (agora existem — #64 resolvida)
MOVE_OPERATIONS = frozenset(
    {
        "notion-move-pages",  # API de move agora funcional
    }
)

# Operacoes proibidas (nao existem ou sao inseguras)
BLOCKED_OPERATIONS = frozenset(
    {
        "notion-delete-page",  # Apenas archive, nunca delete
        "notion-delete-database",  # Bloqueado pela API (safety feature)
        "notion-bulk-write",  # Falha (#74), fazer 1 por 1
    }
)


@dataclass
class SafetyCheck:
    """Resultado de uma verificacao de seguranca."""

    decision: SafetyDecision
    reason: str
    operation: str
    confidence: float = 1.0
    requires_cross_validation: bool = False


def validate_operation(
    operation: str,
    mode: OperationMode = OperationMode.READ_ONLY,
    confidence: float = 1.0,
    batch_size: int = 1,
    page_age_days: int = 0,
) -> SafetyCheck:
    """Valida uma operacao MCP antes de executar.

    Implementa o modelo harsh de .claude/rules/mcp_safety.md:
    - >= 0.95: auto-execute
    - 0.70-0.94: human review
    - < 0.70: block
    - < 0.50: block + alerta urgente
    """
    # Operacoes bloqueadas (nunca permitir)
    if operation in BLOCKED_OPERATIONS:
        return SafetyCheck(
            decision=SafetyDecision.BLOCK,
            reason=f"Operacao '{operation}' bloqueada (nao existe ou insegura). "
            f"Ver .claude/rules/mcp_safety.md",
            operation=operation,
        )

    # Read-only sempre permitido
    if operation in READ_ONLY_OPERATIONS:
        return SafetyCheck(
            decision=SafetyDecision.ALLOW,
            reason="Operacao read-only (segura)",
            operation=operation,
        )

    # Write em modo read-only = block
    if operation in WRITE_OPERATIONS and mode == OperationMode.READ_ONLY:
        return SafetyCheck(
            decision=SafetyDecision.BLOCK,
            reason="Operacao de write bloqueada em modo READ_ONLY. "
            "Troque para modo WRITE apos snapshot + aprovacao humana.",
            operation=operation,
        )

    # Input validation: NaN/negative bypass prevention
    if math.isnan(confidence) or math.isinf(confidence):
        return SafetyCheck(
            decision=SafetyDecision.BLOCK,
            reason=f"Confidence invalido ({confidence}). BLOQUEADO.",
            operation=operation,
            confidence=0.0,
        )
    if batch_size < 0:
        return SafetyCheck(
            decision=SafetyDecision.BLOCK,
            reason=f"batch_size negativo ({batch_size}). BLOQUEADO.",
            operation=operation,
        )
    if page_age_days < 0:
        return SafetyCheck(
            decision=SafetyDecision.BLOCK,
            reason=f"page_age_days negativo ({page_age_days}). BLOQUEADO.",
            operation=operation,
        )

    # Batch > 5 = precisa confirmacao humana
    if batch_size > 5:
        return SafetyCheck(
            decision=SafetyDecision.NEEDS_HUMAN_REVIEW,
            reason=f"Batch com {batch_size} items (> 5). Confirmacao humana obrigatoria.",
            operation=operation,
            confidence=confidence,
        )

    # Pagina antiga (> 30 dias) = confirmacao antes de editar
    if page_age_days > 30 and operation in WRITE_OPERATIONS:
        return SafetyCheck(
            decision=SafetyDecision.NEEDS_HUMAN_REVIEW,
            reason=f"Pagina com {page_age_days} dias (> 30). Confirmacao antes de editar.",
            operation=operation,
            confidence=confidence,
        )

    # Modelo harsh: thresholds de confianca
    if operation in WRITE_OPERATIONS:
        if confidence < 0.50:
            return SafetyCheck(
                decision=SafetyDecision.BLOCK,
                reason=f"Confidence {confidence:.2f} < 0.50. BLOQUEADO + alerta urgente.",
                operation=operation,
                confidence=confidence,
            )
        if confidence < 0.70:
            return SafetyCheck(
                decision=SafetyDecision.BLOCK,
                reason=f"Confidence {confidence:.2f} < 0.70. Operacao bloqueada.",
                operation=operation,
                confidence=confidence,
            )
        if confidence < 0.95:
            return SafetyCheck(
                decision=SafetyDecision.NEEDS_HUMAN_REVIEW,
                reason=f"Confidence {confidence:.2f} (0.70-0.94). Requer review humano.",
                operation=operation,
                confidence=confidence,
                requires_cross_validation=True,
            )

        # >= 0.95: auto-execute
        return SafetyCheck(
            decision=SafetyDecision.ALLOW,
            reason=f"Confidence {confidence:.2f} >= 0.95. Auto-execute permitido.",
            operation=operation,
            confidence=confidence,
        )

    # Operacao desconhecida = block por seguranca
    return SafetyCheck(
        decision=SafetyDecision.BLOCK,
        reason=f"Operacao desconhecida: '{operation}'. Bloqueada por seguranca.",
        operation=operation,
    )


def validate_move(
    page_id: str,
    target_parent_id: str,
    confidence: float,
) -> list[SafetyCheck]:
    """Valida move de pagina via notion-move-pages (#64 resolvida).

    Fluxo: READ (snapshot) → MOVE → VERIFY no novo parent.
    page_id e target_parent_id sao validados: nao podem ser vazios.
    """
    if not page_id or not page_id.strip():
        return [
            SafetyCheck(
                decision=SafetyDecision.BLOCK,
                reason="page_id vazio. BLOQUEADO.",
                operation="notion-move-pages",
            )
        ]
    if not target_parent_id or not target_parent_id.strip():
        return [
            SafetyCheck(
                decision=SafetyDecision.BLOCK,
                reason="target_parent_id vazio. BLOQUEADO.",
                operation="notion-move-pages",
            )
        ]

    steps = [
        validate_operation("notion-retrieve-page", OperationMode.READ_ONLY),
        validate_operation("notion-move-pages", OperationMode.WRITE, confidence),
        validate_operation("notion-retrieve-page", OperationMode.READ_ONLY),
    ]
    return steps
