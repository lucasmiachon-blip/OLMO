"""Tests for MCP safety gates — priority 1.

Each branch in validate_operation() is covered:
- Blocked operations
- Read-only operations
- Write in read-only mode
- Batch > 5
- Page age > 30 days
- Confidence thresholds (harsh model): <0.50, <0.70, <0.95, >=0.95
- Unknown operations
"""

from __future__ import annotations

from agents.core.mcp_safety import (
    OperationMode,
    SafetyCheck,
    SafetyDecision,
    validate_move,
    validate_operation,
)


class TestBlockedOperations:
    def test_delete_page_blocked(self) -> None:
        result = validate_operation("notion-delete-page")
        assert result.decision == SafetyDecision.BLOCK
        assert "bloqueada" in result.reason.lower()

    def test_delete_database_blocked(self) -> None:
        result = validate_operation("notion-delete-database")
        assert result.decision == SafetyDecision.BLOCK

    def test_bulk_write_blocked(self) -> None:
        result = validate_operation("notion-bulk-write")
        assert result.decision == SafetyDecision.BLOCK


class TestReadOnlyOperations:
    def test_search_allowed(self) -> None:
        result = validate_operation("notion-search")
        assert result.decision == SafetyDecision.ALLOW

    def test_fetch_allowed(self) -> None:
        result = validate_operation("notion-fetch")
        assert result.decision == SafetyDecision.ALLOW

    def test_get_comments_allowed(self) -> None:
        result = validate_operation("notion-get-comments")
        assert result.decision == SafetyDecision.ALLOW

    def test_read_ops_ignore_mode(self) -> None:
        """Read-only ops should pass regardless of mode."""
        result = validate_operation("notion-search", OperationMode.WRITE)
        assert result.decision == SafetyDecision.ALLOW


class TestWriteInReadOnlyMode:
    def test_create_page_blocked_in_read_mode(self) -> None:
        result = validate_operation("notion-create-pages", OperationMode.READ_ONLY)
        assert result.decision == SafetyDecision.BLOCK
        assert "READ_ONLY" in result.reason

    def test_update_page_blocked_in_read_mode(self) -> None:
        result = validate_operation("notion-update-page", OperationMode.READ_ONLY)
        assert result.decision == SafetyDecision.BLOCK

    def test_move_pages_blocked_in_read_mode(self) -> None:
        result = validate_operation("notion-move-pages", OperationMode.READ_ONLY)
        assert result.decision == SafetyDecision.BLOCK


class TestBatchSize:
    def test_batch_over_5_needs_review(self) -> None:
        result = validate_operation("notion-create-pages", OperationMode.WRITE, batch_size=6)
        assert result.decision == SafetyDecision.NEEDS_HUMAN_REVIEW
        assert "6" in result.reason

    def test_batch_5_or_less_passes(self) -> None:
        result = validate_operation(
            "notion-create-pages", OperationMode.WRITE, confidence=0.99, batch_size=5
        )
        assert result.decision == SafetyDecision.ALLOW


class TestPageAge:
    def test_old_page_needs_review(self) -> None:
        result = validate_operation("notion-update-page", OperationMode.WRITE, page_age_days=60)
        assert result.decision == SafetyDecision.NEEDS_HUMAN_REVIEW
        assert "60" in result.reason

    def test_recent_page_passes(self) -> None:
        result = validate_operation(
            "notion-update-page", OperationMode.WRITE, confidence=0.99, page_age_days=10
        )
        assert result.decision == SafetyDecision.ALLOW


class TestConfidenceThresholds:
    """Harsh model: <0.50=block+urgent, <0.70=block, <0.95=review, >=0.95=allow."""

    def test_very_low_confidence_blocks(self) -> None:
        result = validate_operation("notion-create-pages", OperationMode.WRITE, confidence=0.30)
        assert result.decision == SafetyDecision.BLOCK
        assert "0.50" in result.reason

    def test_low_confidence_blocks(self) -> None:
        result = validate_operation("notion-create-pages", OperationMode.WRITE, confidence=0.60)
        assert result.decision == SafetyDecision.BLOCK
        assert "0.70" in result.reason

    def test_medium_confidence_needs_review(self) -> None:
        result = validate_operation("notion-create-pages", OperationMode.WRITE, confidence=0.85)
        assert result.decision == SafetyDecision.NEEDS_HUMAN_REVIEW
        assert result.requires_cross_validation

    def test_high_confidence_allowed(self) -> None:
        result = validate_operation("notion-create-pages", OperationMode.WRITE, confidence=0.99)
        assert result.decision == SafetyDecision.ALLOW

    def test_exact_threshold_095(self) -> None:
        result = validate_operation("notion-create-pages", OperationMode.WRITE, confidence=0.95)
        assert result.decision == SafetyDecision.ALLOW


class TestUnknownOperations:
    def test_unknown_op_blocked(self) -> None:
        result = validate_operation("notion-something-new")
        assert result.decision == SafetyDecision.BLOCK
        assert "desconhecida" in result.reason.lower()


class TestValidateMove:
    def test_move_returns_3_steps(self) -> None:
        steps = validate_move("page_123", "parent_456", confidence=0.99)
        assert len(steps) == 3

    def test_move_first_step_is_read(self) -> None:
        steps = validate_move("page_123", "parent_456", confidence=0.99)
        assert steps[0].decision == SafetyDecision.ALLOW
        assert steps[0].operation == "notion-retrieve-page"

    def test_move_second_step_is_write(self) -> None:
        steps = validate_move("page_123", "parent_456", confidence=0.99)
        assert steps[1].operation == "notion-move-pages"

    def test_move_low_confidence_blocks_write(self) -> None:
        steps = validate_move("page_123", "parent_456", confidence=0.30)
        assert steps[1].decision == SafetyDecision.BLOCK


class TestInputValidation:
    """S51: NaN/negative/empty bypass prevention."""

    def test_nan_confidence_blocks(self) -> None:
        """NaN in confidence must BLOCK, not bypass thresholds (IEEE 754 comparison trap)."""
        result = validate_operation(
            "notion-create-pages", OperationMode.WRITE, confidence=float("nan")
        )
        assert result.decision == SafetyDecision.BLOCK

    def test_inf_confidence_blocks(self) -> None:
        result = validate_operation(
            "notion-create-pages", OperationMode.WRITE, confidence=float("inf")
        )
        assert result.decision == SafetyDecision.BLOCK

    def test_negative_batch_size_blocks(self) -> None:
        result = validate_operation("notion-create-pages", OperationMode.WRITE, batch_size=-1)
        assert result.decision == SafetyDecision.BLOCK

    def test_negative_page_age_blocks(self) -> None:
        result = validate_operation("notion-update-page", OperationMode.WRITE, page_age_days=-100)
        assert result.decision == SafetyDecision.BLOCK

    def test_validate_move_empty_page_id_blocks(self) -> None:
        steps = validate_move("", "parent_456", confidence=0.99)
        assert len(steps) == 1
        assert steps[0].decision == SafetyDecision.BLOCK

    def test_validate_move_empty_target_blocks(self) -> None:
        steps = validate_move("page_123", "  ", confidence=0.99)
        assert len(steps) == 1
        assert steps[0].decision == SafetyDecision.BLOCK


class TestSafetyCheckDataclass:
    def test_defaults(self) -> None:
        check = SafetyCheck(
            decision=SafetyDecision.ALLOW,
            reason="test",
            operation="test-op",
        )
        assert check.confidence == 1.0
        assert check.requires_cross_validation is False
