"""Shared fixtures for the test suite."""

from __future__ import annotations

from pathlib import Path
from typing import Any

import pytest

from agents.core.base_agent import BaseAgent, TaskResult


class MockAgent(BaseAgent):
    """Concrete BaseAgent for testing."""

    async def execute(self, task: dict[str, Any]) -> TaskResult:
        return TaskResult(success=True, data={"task": task})

    async def plan(self, objective: str) -> list[dict[str, Any]]:
        return [{"step": 1, "action": "mock", "input": objective}]


@pytest.fixture
def mock_agent() -> MockAgent:
    return MockAgent(name="test_agent", description="Agent for testing")


@pytest.fixture
def tmp_config_dir(tmp_path: Path) -> Path:
    """Create a temporary config directory with sample YAML files."""
    config_dir = tmp_path / "config"
    config_dir.mkdir()

    ecosystem_yaml = config_dir / "ecosystem.yaml"
    ecosystem_yaml.write_text(
        "ecosystem:\n"
        "  name: Test Ecosystem\n"
        "  version: '0.1.0'\n"
        "agents:\n"
        "  test_agent:\n"
        "    model: claude-haiku-4-5\n"
        "    enabled: true\n"
    )

    workflows_yaml = config_dir / "workflows.yaml"
    workflows_yaml.write_text("workflows:\n  test_workflow:\n    steps:\n      - action: test\n")

    return config_dir
