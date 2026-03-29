"""Custom exceptions for the AI Agent Ecosystem."""

from __future__ import annotations


class EcosystemError(Exception):
    """Base exception for all ecosystem errors."""


class AgentError(EcosystemError):
    """Agent execution failure."""


class RoutingError(AgentError):
    """No agent found for task type."""


class ConfigError(EcosystemError):
    """Configuration loading or validation failure."""


class WorkflowError(EcosystemError):
    """Workflow step execution failure."""


class MCPSafetyError(EcosystemError):
    """MCP operation blocked by safety protocol."""


class BudgetExhaustedError(EcosystemError):
    """API budget limit reached."""
