"""Web Monitor - Monitora paginas web e feeds RSS para novidades."""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from typing import Any

from agents.core.base_agent import AgentStatus, BaseAgent, TaskResult

logger = logging.getLogger("subagent.web_monitor")


@dataclass
class MonitoredSource:
    """Uma fonte monitorada."""

    name: str
    url: str
    source_type: str  # rss, webpage, api, github
    check_interval_minutes: int = 60
    last_check: str | None = None
    last_hash: str | None = None
    filters: list[str] = field(default_factory=list)


class WebMonitorSubagent(BaseAgent):
    """Subagente que monitora fontes web em busca de novidades.

    Monitora:
    - Feeds RSS de blogs de AI
    - Paginas de releases no GitHub
    - APIs de noticias
    - Repositorios trending
    """

    def __init__(self) -> None:
        super().__init__(
            name="web_monitor",
            description="Monitora fontes web para novidades e atualizacoes",
        )
        self.sources: list[MonitoredSource] = []
        self.alerts: list[dict[str, Any]] = []

    def add_source(self, source: MonitoredSource) -> None:
        """Adiciona uma fonte para monitoramento."""
        self.sources.append(source)
        logger.info(f"Monitoring source added: {source.name}")

    async def execute(self, task: dict[str, Any]) -> TaskResult:
        """Executa verificacao de monitoramento."""
        self.status = AgentStatus.RUNNING
        action = task.get("action", "check_all")

        try:
            if action == "check_all":
                return await self._check_all_sources()
            elif action == "check_source":
                return await self._check_source(task.get("source_name", ""))
            elif action == "get_alerts":
                return TaskResult(success=True, data={"alerts": self.alerts})
            else:
                return TaskResult(success=False, error=f"Unknown action: {action}")
        finally:
            self.status = AgentStatus.IDLE

    async def plan(self, objective: str) -> list[dict[str, Any]]:
        return [
            {"step": 1, "action": "configure_sources", "description": "Configurar fontes"},
            {"step": 2, "action": "initial_scan", "description": "Scan inicial"},
            {"step": 3, "action": "schedule_monitoring", "description": "Agendar monitoramento"},
        ]

    async def _check_all_sources(self) -> TaskResult:
        """Verifica todas as fontes monitoradas."""
        results = []
        for source in self.sources:
            result = await self._check_source(source.name)
            results.append(result)

        return TaskResult(
            success=True,
            data={
                "sources_checked": len(self.sources),
                "alerts_generated": len(self.alerts),
            },
        )

    async def _check_source(self, source_name: str) -> TaskResult:
        """Verifica uma fonte especifica."""
        source = next((s for s in self.sources if s.name == source_name), None)
        if not source:
            return TaskResult(success=False, error=f"Source '{source_name}' not found")

        logger.info(f"Checking source: {source.name}")
        return TaskResult(success=True, data={"source": source.name, "status": "checked"})
