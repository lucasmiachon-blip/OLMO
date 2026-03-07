"""Data Pipeline Subagent - Processa dados em pipelines configuráveis."""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from typing import Any, Callable, Coroutine

from agents.core.base_agent import AgentStatus, BaseAgent, TaskResult

logger = logging.getLogger("subagent.data_pipeline")


@dataclass
class PipelineStep:
    """Um passo de um pipeline de dados."""

    name: str
    step_type: str  # transform, filter, aggregate, enrich, validate
    config: dict[str, Any] = field(default_factory=dict)
    enabled: bool = True


@dataclass
class Pipeline:
    """Um pipeline de processamento de dados."""

    name: str
    steps: list[PipelineStep] = field(default_factory=list)
    input_format: str = "json"
    output_format: str = "json"


class DataPipelineSubagent(BaseAgent):
    """Subagente de pipelines de dados.

    Processa dados atraves de pipelines configuráveis com
    transformacao, filtragem, enriquecimento e validacao.
    """

    def __init__(self) -> None:
        super().__init__(
            name="data_pipeline",
            description="Processa dados em pipelines configuraveis",
        )
        self.pipelines: dict[str, Pipeline] = {}
        self.processors: dict[str, Callable[..., Coroutine[Any, Any, Any]]] = {}

    def register_pipeline(self, pipeline: Pipeline) -> None:
        """Registra um pipeline."""
        self.pipelines[pipeline.name] = pipeline
        logger.info(f"Pipeline '{pipeline.name}' registered with {len(pipeline.steps)} steps")

    async def execute(self, task: dict[str, Any]) -> TaskResult:
        """Executa um pipeline."""
        self.status = AgentStatus.RUNNING
        pipeline_name = task.get("pipeline", "")
        data = task.get("data")

        try:
            pipeline = self.pipelines.get(pipeline_name)
            if not pipeline:
                return TaskResult(success=False, error=f"Pipeline '{pipeline_name}' not found")

            result = await self._run_pipeline(pipeline, data)
            return result
        except Exception as e:
            self.status = AgentStatus.ERROR
            return TaskResult(success=False, error=str(e))
        finally:
            self.status = AgentStatus.IDLE

    async def plan(self, objective: str) -> list[dict[str, Any]]:
        return [
            {"step": 1, "action": "design_pipeline"},
            {"step": 2, "action": "configure_steps"},
            {"step": 3, "action": "test_pipeline"},
            {"step": 4, "action": "deploy"},
        ]

    async def _run_pipeline(self, pipeline: Pipeline, data: Any) -> TaskResult:
        """Executa os passos de um pipeline."""
        current = data
        executed_steps = []

        for step in pipeline.steps:
            if not step.enabled:
                continue

            processor = self.processors.get(step.step_type)
            if processor:
                current = await processor(current, step.config)
            executed_steps.append(step.name)

        return TaskResult(
            success=True,
            data={"result": current, "steps_executed": executed_steps},
        )
