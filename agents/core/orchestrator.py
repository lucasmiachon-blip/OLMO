"""Orchestrator - Agente principal que coordena todo o ecossistema."""

from __future__ import annotations

import logging
from typing import Any

from agents.core.base_agent import AgentContext, AgentStatus, BaseAgent, TaskResult
from agents.core.mcp_safety import OperationMode, SafetyDecision, validate_operation

logger = logging.getLogger("orchestrator")


class Orchestrator(BaseAgent):
    """Orquestrador principal do ecossistema de agentes.

    Responsavel por:
    - Rotear tarefas para os agentes corretos
    - Gerenciar o ciclo de vida dos agentes
    - Compor workflows multi-agente
    - Manter o contexto global
    """

    def __init__(self) -> None:
        super().__init__(
            name="orchestrator",
            description="Agente principal que coordena todo o ecossistema de agentes AI",
        )
        self.agents: dict[str, BaseAgent] = {}
        self.workflows: dict[str, list[dict[str, Any]]] = {}
        self.context = AgentContext()

    def register_agent(self, agent: BaseAgent) -> None:
        """Registra um agente no ecossistema."""
        agent.set_context(self.context)
        self.agents[agent.name] = agent
        logger.info(f"Agent '{agent.name}' registered in ecosystem")

    async def route_task(self, task: dict[str, Any]) -> TaskResult:
        """Roteia uma tarefa para o agente mais adequado."""
        task_type = task.get("type", "")
        target_agent = task.get("agent")

        if target_agent and target_agent in self.agents:
            return await self.agents[target_agent].execute(task)

        # Roteamento automatico baseado no tipo
        routing_map: dict[str, str] = {
            "research": "cientifico",
            "automate": "automacao",
            "organize": "organizacao",
            "update": "atualizacao_ai",
            "analyze": "cientifico",
            "schedule": "organizacao",
            "monitor": "automacao",
        }

        agent_name = routing_map.get(task_type)
        if agent_name and agent_name in self.agents:
            return await self.agents[agent_name].execute(task)

        return TaskResult(
            success=False,
            error=f"No agent found for task type '{task_type}'",
        )

    async def execute(self, task: dict[str, Any]) -> TaskResult:
        """Executa uma tarefa, roteando para o agente adequado."""
        self.status = AgentStatus.RUNNING
        try:
            result = await self.route_task(task)
            self.context.add_to_history(self.name, "route_task", result)
            return result
        except Exception as e:
            self.status = AgentStatus.ERROR
            logger.error(f"Orchestrator error: {e}")
            return TaskResult(success=False, error=str(e))
        finally:
            self.status = AgentStatus.IDLE

    async def plan(self, objective: str) -> list[dict[str, Any]]:
        """Cria um plano multi-agente para atingir o objetivo."""
        return [
            {"step": 1, "action": "analyze", "agent": "cientifico", "input": objective},
            {"step": 2, "action": "plan", "agent": "organizacao", "input": objective},
            {"step": 3, "action": "execute", "agent": "automacao", "input": objective},
            {"step": 4, "action": "report", "agent": "cientifico", "input": objective},
        ]

    async def run_workflow(self, workflow_name: str, initial_data: Any = None) -> list[TaskResult]:
        """Executa um workflow definido."""
        if workflow_name not in self.workflows:
            return [TaskResult(success=False, error=f"Workflow '{workflow_name}' not found")]

        results: list[TaskResult] = []
        current_data = initial_data

        for step in self.workflows[workflow_name]:
            task = {**step, "data": current_data}
            result = await self.route_task(task)
            results.append(result)

            if not result.success:
                logger.error(f"Workflow '{workflow_name}' failed at step: {step}")
                break

            current_data = result.data

        return results

    def register_workflow(self, name: str, steps: list[dict[str, Any]]) -> None:
        """Registra um workflow no orquestrador."""
        self.workflows[name] = steps
        logger.info(f"Workflow '{name}' registered with {len(steps)} steps")

    def validate_mcp_step(self, step: dict[str, Any]) -> SafetyDecision:
        """Valida safety de um step MCP antes de executar."""
        mode_str = step.get("mode", "read_only")
        mode = OperationMode.WRITE if "write" in mode_str else OperationMode.READ_ONLY

        mcp_op = step.get("mcp_operation", step.get("action", ""))
        confidence = step.get("confidence", 1.0)

        check = validate_operation(mcp_op, mode, confidence)

        if check.decision == SafetyDecision.BLOCK:
            logger.warning(f"MCP safety BLOCK: {check.reason}")
        elif check.decision == SafetyDecision.NEEDS_HUMAN_REVIEW:
            logger.info(f"MCP safety REVIEW: {check.reason}")

        return check.decision

    def get_ecosystem_status(self) -> dict[str, Any]:
        """Retorna o status completo do ecossistema."""
        return {
            "orchestrator_status": self.status.value,
            "agents": {
                name: {
                    "status": agent.status.value,
                    "description": agent.description,
                    "skills": list(agent.skills.keys()),
                    "subagents": [s.name for s in agent.subagents],
                }
                for name, agent in self.agents.items()
            },
            "workflows": list(self.workflows.keys()),
            "history_size": len(self.context.history),
        }
