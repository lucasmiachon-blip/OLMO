"""Agente Cientifico - Pesquisa, analise e sintese de conhecimento."""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from typing import Any

from agents.core.base_agent import AgentStatus, BaseAgent, TaskResult

logger = logging.getLogger("agent.cientifico")


@dataclass
class ResearchPaper:
    """Representa um paper de pesquisa."""

    title: str
    authors: list[str]
    abstract: str
    url: str
    source: str  # arxiv, pubmed, semantic_scholar
    year: int
    tags: list[str] = field(default_factory=list)
    relevance_score: float = 0.0
    notes: str = ""


@dataclass
class KnowledgeBase:
    """Base de conhecimento do agente cientifico."""

    papers: list[ResearchPaper] = field(default_factory=list)
    topics: dict[str, list[str]] = field(default_factory=dict)
    summaries: dict[str, str] = field(default_factory=dict)
    connections: list[dict[str, Any]] = field(default_factory=list)

    def add_paper(self, paper: ResearchPaper) -> None:
        self.papers.append(paper)
        for tag in paper.tags:
            if tag not in self.topics:
                self.topics[tag] = []
            self.topics[tag].append(paper.title)

    def search(self, query: str) -> list[ResearchPaper]:
        query_lower = query.lower()
        return [
            p for p in self.papers
            if query_lower in p.title.lower() or query_lower in p.abstract.lower()
        ]


class ScientificAgent(BaseAgent):
    """Agente para pesquisa e analise cientifica.

    Capacidades:
    - Busca em arXiv, PubMed, Semantic Scholar
    - Analise e sumarizacao de papers
    - Identificacao de tendencias
    - Criacao de revisoes de literatura
    - Mapeamento de conexoes entre pesquisas
    - Geracao de hipoteses
    """

    def __init__(self) -> None:
        super().__init__(
            name="cientifico",
            description="Pesquisa, analisa e sintetiza conhecimento cientifico",
        )
        self.knowledge_base = KnowledgeBase()
        self.research_areas: list[str] = [
            "artificial_intelligence",
            "machine_learning",
            "natural_language_processing",
            "computer_vision",
            "robotics",
            "neuroscience",
        ]

    async def execute(self, task: dict[str, Any]) -> TaskResult:
        """Executa uma tarefa de pesquisa cientifica."""
        self.status = AgentStatus.RUNNING
        action = task.get("action", "search")

        try:
            if action == "search":
                return await self._search_papers(task.get("query", ""), task.get("sources", []))
            elif action == "analyze":
                return await self._analyze_paper(task.get("paper_url", ""))
            elif action == "summarize":
                return await self._summarize_topic(task.get("topic", ""))
            elif action == "literature_review":
                return await self._create_literature_review(task.get("topic", ""))
            elif action == "find_trends":
                return await self._find_trends(task.get("area", ""))
            elif action == "generate_hypothesis":
                return await self._generate_hypothesis(task.get("observations", []))
            else:
                return TaskResult(success=False, error=f"Unknown action: {action}")
        except Exception as e:
            self.status = AgentStatus.ERROR
            logger.error(f"Scientific agent error: {e}")
            return TaskResult(success=False, error=str(e))
        finally:
            self.status = AgentStatus.IDLE

    async def plan(self, objective: str) -> list[dict[str, Any]]:
        """Planeja uma pesquisa cientifica."""
        return [
            {"step": 1, "action": "define_scope", "description": "Definir escopo da pesquisa"},
            {"step": 2, "action": "search", "description": "Buscar papers relevantes"},
            {"step": 3, "action": "analyze", "description": "Analisar papers encontrados"},
            {"step": 4, "action": "synthesize", "description": "Sintetizar conhecimento"},
            {"step": 5, "action": "report", "description": "Gerar relatorio final"},
        ]

    async def _search_papers(
        self, query: str, sources: list[str] | None = None
    ) -> TaskResult:
        """Busca papers em multiplas fontes."""
        if sources is None:
            sources = ["arxiv", "semantic_scholar"]

        # Primeiro busca na base local
        local_results = self.knowledge_base.search(query)
        if local_results:
            return TaskResult(
                success=True,
                data={"local_results": local_results, "query": query},
            )

        # Busca externa seria delegada para subagentes/skills
        return TaskResult(
            success=True,
            data={
                "query": query,
                "sources": sources,
                "status": "search_initiated",
                "local_results": [],
            },
        )

    async def _analyze_paper(self, paper_url: str) -> TaskResult:
        """Analisa um paper especifico."""
        return TaskResult(
            success=True,
            data={
                "url": paper_url,
                "analysis": {
                    "methodology": "pending",
                    "key_findings": "pending",
                    "limitations": "pending",
                    "relevance": "pending",
                },
            },
        )

    async def _summarize_topic(self, topic: str) -> TaskResult:
        """Cria um resumo sobre um topico."""
        papers = self.knowledge_base.topics.get(topic, [])
        return TaskResult(
            success=True,
            data={
                "topic": topic,
                "paper_count": len(papers),
                "papers": papers,
                "summary": self.knowledge_base.summaries.get(topic, "No summary available"),
            },
        )

    async def _create_literature_review(self, topic: str) -> TaskResult:
        """Cria uma revisao de literatura."""
        return TaskResult(
            success=True,
            data={
                "topic": topic,
                "sections": [
                    "introduction",
                    "background",
                    "methodology",
                    "findings",
                    "discussion",
                    "conclusion",
                ],
                "status": "template_created",
            },
        )

    async def _find_trends(self, area: str) -> TaskResult:
        """Identifica tendencias em uma area."""
        return TaskResult(
            success=True,
            data={"area": area, "status": "analysis_initiated"},
        )

    async def _generate_hypothesis(self, observations: list[str]) -> TaskResult:
        """Gera hipoteses baseadas em observacoes."""
        return TaskResult(
            success=True,
            data={
                "observations": observations,
                "hypotheses": [],
                "status": "generation_initiated",
            },
        )
