"""Model Router - Enforce model assignments from ecosystem.yaml."""

from __future__ import annotations

import logging
from typing import Any

logger = logging.getLogger("core.model_router")

# Routing por complexidade (CLAUDE.md: trivial→Ollama, simple→Haiku, medium→Sonnet, complex→Opus)
COMPLEXITY_MODELS: dict[str, str] = {
    "trivial": "local-ollama",
    "simple": "claude-haiku-4-5",
    "medium": "claude-sonnet-4-6",
    "complex": "claude-opus-4-6",
}

DEFAULT_MODEL = "claude-sonnet-4-6"


class ModelRouter:
    """Roteia tasks para o modelo correto baseado em config e complexidade."""

    def __init__(self, agents_config: dict[str, Any] | None = None) -> None:
        self.agent_models: dict[str, str] = {}
        if agents_config:
            self._load_agent_models(agents_config)

    def _load_agent_models(self, agents_config: dict[str, Any]) -> None:
        for name, cfg in agents_config.items():
            if isinstance(cfg, dict) and "model" in cfg:
                self.agent_models[name] = cfg["model"]
                logger.debug(f"Router: {name} → {cfg['model']}")

    def get_model_for_agent(self, agent_name: str) -> str:
        """Retorna o modelo atribuido ao agente no config."""
        model = self.agent_models.get(agent_name, DEFAULT_MODEL)
        return model

    def get_model_for_complexity(self, complexity: str) -> str:
        """Retorna modelo baseado na complexidade da task."""
        return COMPLEXITY_MODELS.get(complexity, DEFAULT_MODEL)

    def resolve(self, agent_name: str, task: dict[str, Any]) -> str:
        """Resolve modelo final: task complexity override > agent config > default."""
        complexity = task.get("complexity")
        if complexity and complexity in COMPLEXITY_MODELS:
            model = COMPLEXITY_MODELS[complexity]
            logger.info(f"Route: {agent_name} task complexity={complexity} → {model}")
            return model

        model = self.get_model_for_agent(agent_name)
        logger.info(f"Route: {agent_name} → {model} (config)")
        return model
