"""Tests for config/loader.py — priority 4.

O loader carrega configuracoes YAML que controlam o ecossistema.
Testa: fallback para defaults, ConfigError em YAML invalido, rate_limits.
"""

from __future__ import annotations

from pathlib import Path

import pytest

from agents.core.exceptions import ConfigError
from config.loader import load_config, load_rate_limits


class TestLoadConfig:
    """Testa carregamento de ecosystem.yaml."""

    def test_fallback_when_file_missing(self, tmp_path: Path) -> None:
        """Se arquivo nao existe, retorna config padrao sem crashar."""
        result = load_config(tmp_path / "nao_existe.yaml")
        assert "ecosystem" in result
        assert result["ecosystem"]["name"] == "AI Agent Ecosystem"

    def test_loads_valid_yaml(self, tmp_config_dir: Path) -> None:
        """Carrega YAML valido corretamente."""
        result = load_config(tmp_config_dir / "ecosystem.yaml")
        assert result["ecosystem"]["name"] == "Test Ecosystem"

    def test_invalid_yaml_raises_config_error(self, tmp_path: Path) -> None:
        """YAML malformado deve lancar ConfigError, nao yaml.YAMLError."""
        bad_yaml = tmp_path / "bad.yaml"
        bad_yaml.write_text("key: [unclosed bracket")
        with pytest.raises(ConfigError, match="Invalid YAML"):
            load_config(bad_yaml)

    def test_default_config_structure(self, tmp_path: Path) -> None:
        """Config padrao tem todas as chaves esperadas."""
        result = load_config(tmp_path / "missing.yaml")
        assert "agents" in result
        assert "skills" in result
        assert "ai_models" in result


class TestLoadRateLimits:
    """Testa carregamento de rate_limits.yaml."""

    def test_fallback_when_missing(self, tmp_path: Path) -> None:
        """Se arquivo nao existe, retorna budget padrao."""
        result = load_rate_limits(tmp_path / "missing.yaml")
        assert result["budget"]["monthly"]["max_cost_usd"] == 100.0

    def test_loads_valid_rate_limits(self, tmp_path: Path) -> None:
        rate_file = tmp_path / "rates.yaml"
        rate_file.write_text("budget:\n  monthly:\n    max_cost_usd: 50.0\n")
        result = load_rate_limits(rate_file)
        assert result["budget"]["monthly"]["max_cost_usd"] == 50.0
