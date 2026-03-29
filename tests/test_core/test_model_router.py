"""Tests for ModelRouter — priority 2.

ModelRouter decide qual modelo AI usar para cada tarefa.
Tres caminhos de resolucao (resolve):
1. Task tem complexity → usa COMPLEXITY_MODELS
2. Agent tem modelo no config → usa config
3. Nenhum dos dois → usa DEFAULT_MODEL (Sonnet)
"""

from __future__ import annotations

from agents.core.model_router import COMPLEXITY_MODELS, DEFAULT_MODEL, ModelRouter


class TestModelRouterInit:
    """Testa criacao do router com e sem config."""

    def test_empty_init(self) -> None:
        router = ModelRouter()
        assert router.agent_models == {}

    def test_none_config(self) -> None:
        router = ModelRouter(agents_config=None)
        assert router.agent_models == {}

    def test_loads_agent_models(self) -> None:
        config = {
            "cientifico": {"model": "claude-sonnet-4-6", "enabled": True},
            "automacao": {"model": "claude-haiku-4-5"},
        }
        router = ModelRouter(agents_config=config)
        assert router.agent_models["cientifico"] == "claude-sonnet-4-6"
        assert router.agent_models["automacao"] == "claude-haiku-4-5"

    def test_skips_entries_without_model(self) -> None:
        """Config entries sem 'model' key sao ignoradas."""
        config = {
            "with_model": {"model": "claude-haiku-4-5"},
            "no_model": {"enabled": True},
            "string_value": "not-a-dict",
        }
        router = ModelRouter(agents_config=config)
        assert "with_model" in router.agent_models
        assert "no_model" not in router.agent_models
        assert "string_value" not in router.agent_models


class TestGetModelForAgent:
    """Testa busca de modelo por nome do agente."""

    def test_known_agent(self) -> None:
        router = ModelRouter(agents_config={"test": {"model": "claude-opus-4-6"}})
        assert router.get_model_for_agent("test") == "claude-opus-4-6"

    def test_unknown_agent_returns_default(self) -> None:
        router = ModelRouter()
        assert router.get_model_for_agent("inexistente") == DEFAULT_MODEL


class TestGetModelForComplexity:
    """Testa busca de modelo por nivel de complexidade."""

    def test_all_complexity_levels(self) -> None:
        router = ModelRouter()
        for level, expected in COMPLEXITY_MODELS.items():
            assert router.get_model_for_complexity(level) == expected

    def test_unknown_complexity_returns_default(self) -> None:
        router = ModelRouter()
        assert router.get_model_for_complexity("impossible") == DEFAULT_MODEL


class TestResolve:
    """Testa resolve() — o metodo principal que decide o modelo final.

    Prioridade: task complexity > agent config > default.
    """

    def test_complexity_overrides_config(self) -> None:
        """Se task tem complexity, ignora config do agente."""
        router = ModelRouter(agents_config={"agent_a": {"model": "claude-haiku-4-5"}})
        model = router.resolve("agent_a", {"complexity": "complex"})
        assert model == "claude-opus-4-6"

    def test_agent_config_when_no_complexity(self) -> None:
        """Sem complexity, usa modelo do config."""
        router = ModelRouter(agents_config={"agent_a": {"model": "claude-haiku-4-5"}})
        model = router.resolve("agent_a", {"task": "simple"})
        assert model == "claude-haiku-4-5"

    def test_default_when_no_complexity_no_config(self) -> None:
        """Sem complexity e sem config, usa DEFAULT_MODEL."""
        router = ModelRouter()
        model = router.resolve("unknown_agent", {"task": "anything"})
        assert model == DEFAULT_MODEL

    def test_invalid_complexity_falls_to_config(self) -> None:
        """Complexity invalida nao esta em COMPLEXITY_MODELS, cai pro config."""
        router = ModelRouter(agents_config={"agent_a": {"model": "claude-opus-4-6"}})
        model = router.resolve("agent_a", {"complexity": "legendary"})
        assert model == "claude-opus-4-6"

    def test_empty_task(self) -> None:
        router = ModelRouter()
        model = router.resolve("any", {})
        assert model == DEFAULT_MODEL
