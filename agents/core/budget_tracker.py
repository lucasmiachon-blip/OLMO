"""Budget Tracker - Rastreia uso e custo de API calls.

Inspirado em:
- Simon Willison: rastreia custo por projeto (ex: $0.61 por 17 min)
- Anthropic Agent SDK: max_budget_usd
- Portkey: AI Gateway com fallback entre provedores
"""

from __future__ import annotations

import json
import logging
from dataclasses import dataclass
from datetime import datetime, timedelta
from pathlib import Path
from typing import Any

logger = logging.getLogger("budget_tracker")


@dataclass
class APICallRecord:
    """Registro de uma chamada de API."""

    timestamp: str
    provider: str
    model: str
    input_tokens: int
    output_tokens: int
    cost_usd: float
    agent: str
    action: str
    cached: bool = False
    duration_ms: int = 0


# Precos por 1M tokens (marco 2026)
MODEL_PRICING: dict[str, dict[str, float]] = {
    "claude-opus-4-6": {"input": 15.0, "output": 75.0},
    "claude-sonnet-4-6": {"input": 3.0, "output": 15.0},
    "claude-haiku-4-5": {"input": 0.80, "output": 4.0},
    "gpt-4o": {"input": 2.50, "output": 10.0},
    "gpt-4o-mini": {"input": 0.15, "output": 0.60},
    "local-ollama": {"input": 0.0, "output": 0.0},
}


class BudgetTracker:
    """Rastreia custos de API e sugere otimizacoes.

    Funcionalidades:
    - Registra cada chamada com custo estimado
    - Relatorios por agente, modelo, periodo
    - Alertas quando se aproxima do limite
    - Sugestoes de otimizacao (modelo mais barato, cache, batch)
    - Historico persistente em JSON
    """

    def __init__(self, data_dir: str = ".cache/budget") -> None:
        self.data_dir = Path(data_dir)
        self.data_dir.mkdir(parents=True, exist_ok=True)
        self.records: list[APICallRecord] = []
        self.max_daily_usd: float = 1.0   # Limite diario em USD
        self.max_weekly_usd: float = 5.0  # Limite semanal em USD
        self._load_records()

    def _load_records(self) -> None:
        """Carrega historico do disco."""
        records_file = self.data_dir / "records.json"
        if records_file.exists():
            data = json.loads(records_file.read_text())
            self.records = [APICallRecord(**r) for r in data]

    def _save_records(self) -> None:
        """Salva historico no disco."""
        records_file = self.data_dir / "records.json"
        records_file.write_text(json.dumps(
            [r.__dict__ for r in self.records[-1000:]],  # Mantem ultimos 1000
            indent=2,
        ))

    def estimate_cost(self, model: str, input_tokens: int, output_tokens: int) -> float:
        """Estima custo de uma chamada."""
        pricing = MODEL_PRICING.get(model, {"input": 5.0, "output": 15.0})
        input_cost = (input_tokens / 1_000_000) * pricing["input"]
        output_cost = (output_tokens / 1_000_000) * pricing["output"]
        return input_cost + output_cost

    def record_call(
        self,
        provider: str,
        model: str,
        input_tokens: int,
        output_tokens: int,
        agent: str,
        action: str,
        cached: bool = False,
        duration_ms: int = 0,
    ) -> APICallRecord:
        """Registra uma chamada de API."""
        cost = 0.0 if cached else self.estimate_cost(model, input_tokens, output_tokens)

        record = APICallRecord(
            timestamp=datetime.now().isoformat(),
            provider=provider,
            model=model,
            input_tokens=input_tokens,
            output_tokens=output_tokens,
            cost_usd=cost,
            agent=agent,
            action=action,
            cached=cached,
            duration_ms=duration_ms,
        )

        self.records.append(record)
        self._save_records()

        # Verifica alertas
        self._check_alerts()

        return record

    def _check_alerts(self) -> None:
        """Verifica se esta perto dos limites."""
        daily = self.get_daily_cost()
        weekly = self.get_weekly_cost()

        if daily > self.max_daily_usd * 0.8:
            logger.warning(
                f"ALERTA: Custo diario ${daily:.4f} esta em "
                f"{daily/self.max_daily_usd*100:.0f}% do limite"
            )

        if weekly > self.max_weekly_usd * 0.8:
            logger.warning(
                f"ALERTA: Custo semanal ${weekly:.4f} esta em "
                f"{weekly/self.max_weekly_usd*100:.0f}% do limite"
            )

    def get_daily_cost(self) -> float:
        """Custo total do dia."""
        today = datetime.now().strftime("%Y-%m-%d")
        return sum(r.cost_usd for r in self.records if r.timestamp.startswith(today))

    def get_weekly_cost(self) -> float:
        """Custo total da semana."""
        now = datetime.now()
        week_start = now - timedelta(days=now.weekday())
        week_start_str = week_start.strftime("%Y-%m-%d")
        return sum(
            r.cost_usd for r in self.records
            if r.timestamp[:10] >= week_start_str
        )

    def get_report(self, period: str = "daily") -> dict[str, Any]:
        """Gera relatorio de uso."""
        if period == "daily":
            today = datetime.now().strftime("%Y-%m-%d")
            filtered = [r for r in self.records if r.timestamp.startswith(today)]
        elif period == "weekly":
            now = datetime.now()
            week_start = now - timedelta(days=now.weekday())
            week_start_str = week_start.strftime("%Y-%m-%d")
            filtered = [r for r in self.records if r.timestamp[:10] >= week_start_str]
        else:
            filtered = self.records

        total_cost = sum(r.cost_usd for r in filtered)
        total_tokens = sum(r.input_tokens + r.output_tokens for r in filtered)
        cached_count = sum(1 for r in filtered if r.cached)

        # Por agente
        by_agent: dict[str, float] = {}
        for r in filtered:
            by_agent[r.agent] = by_agent.get(r.agent, 0) + r.cost_usd

        # Por modelo
        by_model: dict[str, int] = {}
        for r in filtered:
            by_model[r.model] = by_model.get(r.model, 0) + 1

        return {
            "period": period,
            "total_calls": len(filtered),
            "cached_calls": cached_count,
            "cache_hit_rate": f"{cached_count/max(len(filtered),1)*100:.1f}%",
            "total_cost_usd": f"${total_cost:.4f}",
            "total_tokens": total_tokens,
            "by_agent": {k: f"${v:.4f}" for k, v in sorted(by_agent.items(), key=lambda x: -x[1])},
            "by_model": by_model,
            "savings_from_cache": f"${sum(r.cost_usd for r in filtered if r.cached):.4f}",
        }

    def suggest_optimizations(self) -> list[str]:
        """Sugere otimizacoes baseado no uso."""
        suggestions = []
        report = self.get_report("weekly")

        # Se muitas chamadas para o mesmo agente
        by_agent = report.get("by_agent", {})
        if by_agent:
            top_agent = max(by_agent.items(), key=lambda x: float(x[1].replace("$", "")))
            if float(top_agent[1].replace("$", "")) > self.max_weekly_usd * 0.5:
                suggestions.append(
                    f"Agente '{top_agent[0]}' consome {top_agent[1]} - "
                    f"considere caching mais agressivo ou modelo mais barato"
                )

        # Se cache hit rate baixo
        cache_rate = float(report.get("cache_hit_rate", "0%").replace("%", ""))
        if cache_rate < 20:
            suggestions.append(
                "Cache hit rate abaixo de 20% - habilite caching para mais tarefas"
            )

        # Se usando modelo caro para tarefas simples
        by_model = report.get("by_model", {})
        if by_model.get("claude-opus-4-6", 0) > 10:
            suggestions.append(
                "Considere usar claude-sonnet-4-6 ou haiku para tarefas simples "
                "(5x-18x mais barato)"
            )

        if not suggestions:
            suggestions.append("Uso esta otimizado! Continue assim.")

        return suggestions

    def recommend_model(self, task_complexity: str) -> str:
        """Recomenda o modelo mais custo-efetivo para a complexidade."""
        recommendations = {
            "simple": "claude-haiku-4-5",       # Classificacao, extracao simples
            "medium": "claude-sonnet-4-6",      # Sumarizacao, codigo simples
            "complex": "claude-opus-4-6",       # Raciocinio, pesquisa, codigo complexo
            "trivial": "local-ollama",          # Formatacao, parsing, regex
        }
        return recommendations.get(task_complexity, "claude-sonnet-4-6")
