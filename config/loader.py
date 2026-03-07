"""Configuration Loader - Carrega e valida configuracoes do ecossistema."""

from __future__ import annotations

import logging
from pathlib import Path
from typing import Any

import yaml

logger = logging.getLogger("config")

DEFAULT_CONFIG_PATH = Path(__file__).parent / "ecosystem.yaml"
WORKFLOWS_PATH = Path(__file__).parent / "workflows.yaml"


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
    """Carrega definicoes de workflows."""
    path = workflows_path or WORKFLOWS_PATH

    if not path.exists():
        logger.warning(f"Workflows file not found: {path}")
        return {"workflows": {}}

    with open(path) as f:
        workflows = yaml.safe_load(f)

    logger.info(f"Workflows loaded from {path}")
    return workflows


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
