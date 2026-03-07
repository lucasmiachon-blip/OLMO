"""Batch Processor Skill - Combina multiplas queries em chamadas eficientes.

Inspirado em:
- Nordic APIs: "Pack multiple prompts into one API call for bulk operations"
- CrewAI: "Stable pieces keep them simple, fast, and cheap"
- Portkey: batching e load balancing entre provedores
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from typing import Any

logger = logging.getLogger("skill.batch_processor")


@dataclass
class BatchItem:
    """Um item em um batch de queries."""

    query_id: str
    query: str
    context: str = ""
    priority: int = 3  # 1=highest
    metadata: dict[str, Any] = field(default_factory=dict)


@dataclass
class BatchResult:
    """Resultado de um batch processado."""

    batch_id: str
    items_count: int
    api_calls_saved: int
    results: dict[str, Any] = field(default_factory=dict)


class BatchProcessorSkill:
    """Skill que combina multiplas queries em chamadas API eficientes.

    Estrategias:
    1. Combina perguntas relacionadas em um unico prompt
    2. Reutiliza contexto compartilhado entre queries
    3. Agrupa por topico para maximizar coerencia
    4. Reduz API calls de N para ceil(N/batch_size)

    Exemplo: 5 perguntas sobre AI news = 1 API call em vez de 5
    """

    name = "batch_processor"
    description = "Combina multiplas queries em chamadas API eficientes"

    def __init__(self, max_batch_size: int = 5) -> None:
        self.max_batch_size = max_batch_size
        self.pending: dict[str, list[BatchItem]] = {}  # Agrupado por topico

    def add_item(self, item: BatchItem, topic: str = "default") -> None:
        """Adiciona um item ao batch."""
        if topic not in self.pending:
            self.pending[topic] = []
        self.pending[topic].append(item)
        logger.info(f"Item '{item.query_id}' added to batch topic '{topic}'")

    def get_ready_batches(self) -> list[tuple[str, list[BatchItem]]]:
        """Retorna batches prontos para processamento."""
        ready = []
        for topic, items in list(self.pending.items()):
            if len(items) >= self.max_batch_size:
                ready.append((topic, items[:self.max_batch_size]))
                self.pending[topic] = items[self.max_batch_size:]
                if not self.pending[topic]:
                    del self.pending[topic]
        return ready

    def flush_all(self) -> list[tuple[str, list[BatchItem]]]:
        """Forca processamento de todos os batches pendentes."""
        batches = [(topic, items) for topic, items in self.pending.items()]
        self.pending.clear()
        return batches

    def create_combined_prompt(self, items: list[BatchItem]) -> str:
        """Cria um prompt combinado a partir de multiplos items.

        Em vez de N chamadas separadas, cria 1 prompt que pede
        respostas para todas as queries de uma vez.
        """
        prompt_parts = [
            "Responda cada uma das seguintes perguntas de forma concisa.",
            "Formate como uma lista numerada correspondendo a cada pergunta.",
            "",
        ]

        shared_context = set()
        for item in items:
            if item.context:
                shared_context.add(item.context)

        if shared_context:
            prompt_parts.append("Contexto compartilhado:")
            for ctx in shared_context:
                prompt_parts.append(f"- {ctx}")
            prompt_parts.append("")

        prompt_parts.append("Perguntas:")
        for i, item in enumerate(items, 1):
            prompt_parts.append(f"{i}. {item.query}")

        return "\n".join(prompt_parts)

    def estimate_savings(self, items_count: int) -> dict[str, Any]:
        """Estima economia de API calls com batching."""
        import math
        batches_needed = math.ceil(items_count / self.max_batch_size)
        calls_saved = items_count - batches_needed
        savings_pct = (calls_saved / max(items_count, 1)) * 100

        return {
            "total_items": items_count,
            "api_calls_without_batch": items_count,
            "api_calls_with_batch": batches_needed,
            "calls_saved": calls_saved,
            "savings_percentage": f"{savings_pct:.0f}%",
        }

    def get_status(self) -> dict[str, Any]:
        """Status do processador de batch."""
        return {
            "pending_topics": len(self.pending),
            "pending_items": sum(len(items) for items in self.pending.values()),
            "topics": {k: len(v) for k, v in self.pending.items()},
            "max_batch_size": self.max_batch_size,
        }
