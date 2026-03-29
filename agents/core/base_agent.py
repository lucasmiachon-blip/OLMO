"""Base Agent - Classe base para todos os agentes do ecossistema."""

from __future__ import annotations

import logging
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Any


class AgentStatus(Enum):
    IDLE = "idle"
    RUNNING = "running"
    ERROR = "error"
    COMPLETED = "completed"
    WAITING = "waiting"


@dataclass
class AgentContext:
    """Contexto compartilhado entre agentes."""

    session_id: str = ""
    user_preferences: dict[str, Any] = field(default_factory=dict)
    shared_memory: dict[str, Any] = field(default_factory=dict)
    history: list[dict[str, Any]] = field(default_factory=list)

    def add_to_history(self, agent_name: str, action: str, result: Any) -> None:
        self.history.append(
            {
                "timestamp": datetime.now().isoformat(),
                "agent": agent_name,
                "action": action,
                "result": result,
            }
        )


@dataclass
class TaskResult:
    """Resultado padronizado de uma tarefa."""

    success: bool
    data: Any = None
    error: str | None = None
    metadata: dict[str, Any] = field(default_factory=dict)


class BaseAgent(ABC):
    """Classe base abstrata para todos os agentes."""

    def __init__(self, name: str, description: str, model: str | None = None) -> None:
        self.name = name
        self.description = description
        self.model = model
        self.status = AgentStatus.IDLE
        self.logger = logging.getLogger(f"agent.{name}")
        self.skills: dict[str, Any] = {}
        self.subagents: list[BaseAgent] = []
        self.context: AgentContext | None = None

    def configure_from_yaml(self, config: dict[str, Any]) -> None:
        """Aplica configuracao do ecosystem.yaml ao agente."""
        if "model" in config:
            self.model = config["model"]
            self.logger.info(f"Model set to '{self.model}'")

    @abstractmethod
    async def execute(self, task: dict[str, Any]) -> TaskResult:
        """Executa a tarefa principal do agente."""

    @abstractmethod
    async def plan(self, objective: str) -> list[dict[str, Any]]:
        """Cria um plano de acao para atingir o objetivo."""

    async def delegate(self, subagent_name: str, task: dict[str, Any]) -> TaskResult:
        """Delega uma tarefa para um subagente."""
        for subagent in self.subagents:
            if subagent.name == subagent_name:
                self.logger.info(f"Delegating to {subagent_name}: {task}")
                return await subagent.execute(task)
        return TaskResult(success=False, error=f"Subagent '{subagent_name}' not found")

    def register_skill(self, skill_name: str, skill: Any) -> None:
        """Registra uma skill no agente."""
        self.skills[skill_name] = skill
        self.logger.info(f"Skill '{skill_name}' registered")

    def add_subagent(self, subagent: BaseAgent) -> None:
        """Adiciona um subagente."""
        self.subagents.append(subagent)
        self.logger.info(f"Subagent '{subagent.name}' added")

    def set_context(self, context: AgentContext) -> None:
        """Define o contexto compartilhado."""
        self.context = context

    def __repr__(self) -> str:
        return f"<{self.__class__.__name__} name='{self.name}' status={self.status.value}>"
