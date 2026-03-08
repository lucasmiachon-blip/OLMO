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
READ_ONLY_OPERATIONS = frozenset({
    "notion-search",
    "notion-fetch",
    "notion-get-comments",
    "notion-retrieve-page",
    "notion-retrieve-database",
    "notion-query-database",
    "notion-list-databases",
})

# Operacoes de write (requerem validacao)
WRITE_OPERATIONS = frozenset({
    "notion-create-page",
    "notion-update-page",
    "notion-append-block",
    "notion-delete-block",
    "notion-create-database",
})

# Operacoes proibidas (nao existem ou sao inseguras)
BLOCKED_OPERATIONS = frozenset({
    "notion-move-page",       # NAO EXISTE na API (#64)
    "notion-delete-page",     # Apenas archive, nunca delete
    "notion-delete-database", # Bloqueado pela API (safety feature)
    "notion-bulk-write",      # Falha (#74), fazer 1 por 1
})


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


def validate_relocate_workaround(
    source_page_id: str,
    target_database: str,
    confidence: float,
) -> list[SafetyCheck]:
    """Valida o workaround de 'mover' pagina (create+copy+verify+archive).

    Como NAO existe API de move (#64), o fluxo seguro e:
    1. READ pagina original (snapshot)
    2. CREATE nova pagina no destino
    3. VERIFY nova pagina (re-ler e comparar)
    4. ARCHIVE original (soft-delete, reversivel)
    """
    steps = [
        validate_operation("notion-retrieve-page", OperationMode.READ_ONLY),
        validate_operation("notion-create-page", OperationMode.WRITE, confidence),
        validate_operation("notion-retrieve-page", OperationMode.READ_ONLY),
        validate_operation("notion-update-page", OperationMode.WRITE, confidence),
    ]
    return steps
