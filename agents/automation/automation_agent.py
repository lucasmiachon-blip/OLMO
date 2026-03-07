"""Agente de Automacao - Gerencia e executa automacoes do ecossistema."""

from __future__ import annotations

import asyncio
import logging
from dataclasses import dataclass, field
from typing import Any, Callable, Coroutine

from agents.core.base_agent import AgentStatus, BaseAgent, TaskResult

logger = logging.getLogger("agent.automacao")


@dataclass
class AutomationRule:
    """Define uma regra de automacao."""

    name: str
    trigger: str  # cron, event, webhook, manual
    trigger_config: dict[str, Any] = field(default_factory=dict)
    actions: list[dict[str, Any]] = field(default_factory=list)
    enabled: bool = True
    last_run: str | None = None


class AutomationAgent(BaseAgent):
    """Agente responsavel por automacoes.

    Capacidades:
    - Execucao de tarefas agendadas (cron-like)
    - Automacao baseada em eventos
    - Pipelines de processamento de dados
    - Integracoes com APIs externas
    - Monitoramento e alertas
    """

    def __init__(self) -> None:
        super().__init__(
            name="automacao",
            description="Automatiza tarefas, workflows e integracoes",
        )
        self.rules: dict[str, AutomationRule] = {}
        self.handlers: dict[str, Callable[..., Coroutine[Any, Any, TaskResult]]] = {}

    def register_rule(self, rule: AutomationRule) -> None:
        """Registra uma regra de automacao."""
        self.rules[rule.name] = rule
        logger.info(f"Automation rule '{rule.name}' registered (trigger: {rule.trigger})")

    def register_handler(
        self, event_type: str, handler: Callable[..., Coroutine[Any, Any, TaskResult]]
    ) -> None:
        """Registra um handler para um tipo de evento."""
        self.handlers[event_type] = handler

    async def execute(self, task: dict[str, Any]) -> TaskResult:
        """Executa uma tarefa de automacao."""
        self.status = AgentStatus.RUNNING
        action = task.get("action", "run_rule")

        try:
            if action == "run_rule":
                return await self._run_rule(task.get("rule_name", ""))
            elif action == "trigger_event":
                return await self._trigger_event(
                    task.get("event_type", ""),
                    task.get("event_data", {}),
                )
            elif action == "run_pipeline":
                return await self._run_pipeline(task.get("pipeline", []), task.get("data"))
            elif action == "schedule":
                return self._schedule_task(task)
            else:
                return TaskResult(success=False, error=f"Unknown action: {action}")
        except Exception as e:
            self.status = AgentStatus.ERROR
            logger.error(f"Automation error: {e}")
            return TaskResult(success=False, error=str(e))
        finally:
            self.status = AgentStatus.IDLE

    async def plan(self, objective: str) -> list[dict[str, Any]]:
        """Planeja automacoes necessarias para o objetivo."""
        return [
            {"step": 1, "action": "identify_tasks", "description": "Identificar tarefas repetitivas"},
            {"step": 2, "action": "create_rules", "description": "Criar regras de automacao"},
            {"step": 3, "action": "setup_triggers", "description": "Configurar gatilhos"},
            {"step": 4, "action": "test_automation", "description": "Testar automacoes"},
            {"step": 5, "action": "monitor", "description": "Monitorar execucao"},
        ]

    async def _run_rule(self, rule_name: str) -> TaskResult:
        """Executa uma regra de automacao."""
        rule = self.rules.get(rule_name)
        if not rule:
            return TaskResult(success=False, error=f"Rule '{rule_name}' not found")

        if not rule.enabled:
            return TaskResult(success=False, error=f"Rule '{rule_name}' is disabled")

        results = []
        for action in rule.actions:
            action_type = action.get("type", "")
            if action_type in self.handlers:
                result = await self.handlers[action_type](action)
                results.append(result)

        return TaskResult(success=True, data=results)

    async def _trigger_event(self, event_type: str, event_data: dict[str, Any]) -> TaskResult:
        """Dispara um evento no sistema."""
        handler = self.handlers.get(event_type)
        if handler:
            return await handler(event_data)
        return TaskResult(success=False, error=f"No handler for event '{event_type}'")

    async def _run_pipeline(self, pipeline: list[dict[str, Any]], data: Any) -> TaskResult:
        """Executa um pipeline de transformacao de dados."""
        current_data = data
        for step in pipeline:
            step_type = step.get("type", "")
            handler = self.handlers.get(step_type)
            if handler:
                result = await handler({"data": current_data, **step})
                if not result.success:
                    return result
                current_data = result.data
        return TaskResult(success=True, data=current_data)

    def _schedule_task(self, task: dict[str, Any]) -> TaskResult:
        """Agenda uma tarefa para execucao futura."""
        rule = AutomationRule(
            name=task.get("name", "scheduled_task"),
            trigger="cron",
            trigger_config={"schedule": task.get("schedule", "0 * * * *")},
            actions=task.get("actions", []),
        )
        self.register_rule(rule)
        return TaskResult(success=True, data={"scheduled": rule.name})
