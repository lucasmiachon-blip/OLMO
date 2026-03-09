"""Configuration Loader - Carrega e valida configuracoes do ecossistema."""

from __future__ import annotations

import logging
from pathlib import Path
from typing import Any

import yaml

logger = logging.getLogger("config")

DEFAULT_CONFIG_PATH = Path(__file__).parent / "ecosystem.yaml"
RATE_LIMITS_PATH = Path(__file__).parent / "rate_limits.yaml"
PROJECT_ROOT = Path(__file__).parent.parent
# Fonte unica de verdade: config/workflows.yaml (consolidado)
WORKFLOW_SOURCES = [
    Path(__file__).parent / "workflows.yaml",
]


def load_config(config_path: Path | None = None) -> dict[str, Any]:
    """Carrega configuracao do ecossistema."""
    path = config_path or DEFAULT_CONFIG_PATH

    if not path.exists():
        logger.warning(f"Config file not found: {path}, using defaults")
        return _default_config()

    with open(path) as f:
        config = yaml.safe_load(f)

    logger.info(f"Configuration loaded from {path}")
    return config


def load_workflows(workflows_path: Path | None = None) -> dict[str, Any]:
    """Carrega e mergea workflows de todas as fontes."""
    if workflows_path:
        sources = [workflows_path]
    else:
        sources = WORKFLOW_SOURCES

    merged: dict[str, Any] = {}

    for path in sources:
        if not path.exists():
            logger.debug(f"Workflow file not found (skipped): {path}")
            continue

        with open(path) as f:
            data = yaml.safe_load(f)

        if data and "workflows" in data:
            for name, wf in data["workflows"].items():
                if name in merged:
                    logger.warning(f"Duplicate workflow '{name}' in {path}, overwriting")
                merged[name] = wf
            logger.info(f"Workflows loaded from {path}")

    return {"workflows": merged}


def load_rate_limits(path: Path | None = None) -> dict[str, Any]:
    """Carrega configuracao de rate limits e budget."""
    rate_path = path or RATE_LIMITS_PATH

    if not rate_path.exists():
        logger.warning(f"Rate limits file not found: {rate_path}, using defaults")
        return {"budget": {"monthly": {"max_cost_usd": 100.0}}}

    with open(rate_path) as f:
        config = yaml.safe_load(f)

    logger.info(f"Rate limits loaded from {rate_path}")
    return config


def _default_config() -> dict[str, Any]:
    """Retorna configuracao padrao."""
    return {
        "ecosystem": {
            "name": "AI Agent Ecosystem",
            "version": "0.1.0",
            "log_level": "INFO",
        },
        "agents": {},
        "skills": {},
        "ai_models": {
            "primary": {
                "provider": "anthropic",
                "model": "claude-opus-4-6",
            }
        },
    }
