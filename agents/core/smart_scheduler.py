"""Smart Scheduler - Otimiza uso de API para usuarios com poucos requests.

Inspirado em:
- CrewAI: "Flows deterministicos + inteligencia seletiva"
- Simon Willison: rastreia custo por projeto ($0.61 por 17 min)
- Anthropic Agent SDK: max_budget_usd para controle de custo
- Nordic APIs: caching, batching, load balancing entre provedores
"""

from __future__ import annotations

import hashlib
import json
import logging
from dataclasses import dataclass, field
from datetime import datetime, timedelta
from enum import Enum
from pathlib import Path
from typing import Any

logger = logging.getLogger("scheduler")


class TaskPriority(Enum):
    """Prioridade da tarefa para alocacao de budget."""

    CRITICAL = 1  # Executa sempre (ex: alertas, bugs criticos)
    HIGH = 2  # Executa se tiver budget (ex: pesquisa principal)
    MEDIUM = 3  # Batcha com outras tarefas (ex: resumos, organizacao)
    LOW = 4  # Defer para quando houver budget sobrando
    BACKGROUND = 5  # Usa modelo local ou aguarda budget reset


@dataclass
class ScheduledTask:
    """Tarefa agendada com metadados de custo."""

    task_id: str
    agent: str
    action: str
    params: dict[str, Any] = field(default_factory=dict)
    priority: TaskPriority = TaskPriority.MEDIUM
    estimated_tokens: int = 1000
    cacheable: bool = True
    batch_key: str = ""  # Tarefas com mesmo batch_key sao combinadas
    created_at: str = field(default_factory=lambda: datetime.now().isoformat())
    max_age_hours: int = 24  # Resultado cache valido por X horas


@dataclass
class APIBudget:
    """Orcamento de API por periodo."""

    daily_limit: int = 50  # Requests por dia (sync with rate_limits.yaml)
    weekly_limit: int = 250  # Requests por semana (sync with rate_limits.yaml)
    daily_used: int = 0
    weekly_used: int = 0
    last_daily_reset: str = ""
    last_weekly_reset: str = ""
    total_tokens_used: int = 0
    estimated_cost_usd: float = 0.0


class SmartScheduler:
    """Agendador inteligente que maximiza valor com minimo de API calls.

    Estrategias (baseado em pesquisa dos melhores devs):
    1. Cache agressivo - mesma pergunta nunca bate na API 2x
    2. Batching - combina perguntas relacionadas em 1 chamada
    3. Local-first - usa processamento local para tarefas simples
    4. Priorizacao - tarefas criticas primeiro, background por ultimo
    5. Deferimento - adia tarefas de baixa prioridade para reset de budget
    6. Fallback - modelo local (Ollama) para tarefas que nao precisam de API
    """

    def __init__(self, cache_dir: str = ".cache/scheduler") -> None:
        self.cache_dir = Path(cache_dir)
        self.cache_dir.mkdir(parents=True, exist_ok=True)
        self.budget = APIBudget()
        self.queue: list[ScheduledTask] = []
        self.batch_buffer: dict[str, list[ScheduledTask]] = {}
        self._load_budget()

    # ------------------------------------------------------------------
    # Budget Management
    # ------------------------------------------------------------------

    def _load_budget(self) -> None:
        """Carrega budget do disco."""
        budget_file = self.cache_dir / "budget.json"
        if budget_file.exists():
            try:
                data = json.loads(budget_file.read_text())
                self.budget = APIBudget(**data)
            except (json.JSONDecodeError, TypeError) as e:
                logger.warning(f"Corrupted budget.json, using defaults: {e}")
        self._check_reset()

    def _save_budget(self) -> None:
        """Salva budget no disco."""
        budget_file = self.cache_dir / "budget.json"
        budget_file.write_text(json.dumps(self.budget.__dict__, indent=2))

    def _check_reset(self) -> None:
        """Reseta contadores se passou o periodo."""
        now = datetime.now()
        today = now.strftime("%Y-%m-%d")

        if self.budget.last_daily_reset != today:
            self.budget.daily_used = 0
            self.budget.last_daily_reset = today
            logger.info("Daily budget reset")

        # Reset semanal (segunda-feira)
        week_start = (now - timedelta(days=now.weekday())).strftime("%Y-%m-%d")
        if self.budget.last_weekly_reset != week_start:
            self.budget.weekly_used = 0
            self.budget.last_weekly_reset = week_start
            logger.info("Weekly budget reset")

    def has_budget(self) -> bool:
        """Verifica se ainda tem budget disponivel."""
        self._check_reset()
        return (
            self.budget.daily_used < self.budget.daily_limit
            and self.budget.weekly_used < self.budget.weekly_limit
        )

    def remaining_daily(self) -> int:
        """Requests restantes hoje."""
        self._check_reset()
        return max(0, self.budget.daily_limit - self.budget.daily_used)

    def remaining_weekly(self) -> int:
        """Requests restantes esta semana."""
        self._check_reset()
        return max(0, self.budget.weekly_limit - self.budget.weekly_used)

    def record_usage(self, tokens: int = 0, cost_usd: float = 0.0) -> None:
        """Registra uso de API."""
        self.budget.daily_used += 1
        self.budget.weekly_used += 1
        self.budget.total_tokens_used += tokens
        self.budget.estimated_cost_usd += cost_usd
        self._save_budget()
        logger.info(
            f"API used: {self.budget.daily_used}/{self.budget.daily_limit} daily, "
            f"{self.budget.weekly_used}/{self.budget.weekly_limit} weekly"
        )

    # ------------------------------------------------------------------
    # Caching
    # ------------------------------------------------------------------

    def _cache_key(self, task: ScheduledTask) -> str:
        """Gera chave de cache para uma tarefa."""
        content = f"{task.agent}:{task.action}:{json.dumps(task.params, sort_keys=True)}"
        return hashlib.sha256(content.encode()).hexdigest()[:16]

    def get_cached(self, task: ScheduledTask) -> dict[str, Any] | None:
        """Busca resultado em cache."""
        if not task.cacheable:
            return None

        key = self._cache_key(task)
        cache_file = self.cache_dir / f"{key}.json"

        if not cache_file.exists():
            return None

        try:
            cached = json.loads(cache_file.read_text())
        except json.JSONDecodeError:
            cache_file.unlink()
            return None
        cached_at = datetime.fromisoformat(cached.get("cached_at", "2000-01-01"))
        max_age = timedelta(hours=task.max_age_hours)

        if datetime.now() - cached_at > max_age:
            cache_file.unlink()  # Expirado
            return None

        logger.info(f"Cache HIT for {task.agent}:{task.action}")
        result = cached.get("result")
        if result is not None and not isinstance(result, dict):
            return None
        return result

    def set_cache(self, task: ScheduledTask, result: Any) -> None:
        """Salva resultado em cache."""
        if not task.cacheable:
            return

        key = self._cache_key(task)
        cache_file = self.cache_dir / f"{key}.json"
        cache_file.write_text(
            json.dumps(
                {
                    "cached_at": datetime.now().isoformat(),
                    "task": {"agent": task.agent, "action": task.action},
                    "result": result,
                },
                indent=2,
                default=str,
            )
        )

    # ------------------------------------------------------------------
    # Batching
    # ------------------------------------------------------------------

    def add_to_batch(self, task: ScheduledTask) -> None:
        """Adiciona tarefa ao buffer de batching."""
        if task.batch_key:
            if task.batch_key not in self.batch_buffer:
                self.batch_buffer[task.batch_key] = []
            self.batch_buffer[task.batch_key].append(task)
            logger.info(f"Task batched under key '{task.batch_key}'")
        else:
            self.queue.append(task)

    def get_batch(self, batch_key: str) -> list[ScheduledTask]:
        """Retorna e limpa um batch de tarefas."""
        tasks = self.batch_buffer.pop(batch_key, [])
        return tasks

    def get_all_batches(self) -> dict[str, list[ScheduledTask]]:
        """Retorna todos os batches pendentes."""
        batches = dict(self.batch_buffer)
        self.batch_buffer.clear()
        return batches

    # ------------------------------------------------------------------
    # Scheduling & Prioritization
    # ------------------------------------------------------------------

    def schedule(self, task: ScheduledTask) -> dict[str, Any]:
        """Decide o que fazer com uma tarefa.

        Retorna:
            {"action": "execute"|"cache_hit"|"batch"|"defer"|"local", ...}
        """
        # 1. Verifica cache primeiro
        cached = self.get_cached(task)
        if cached is not None:
            return {"action": "cache_hit", "result": cached}

        # 2. Se nao tem budget
        if not self.has_budget():
            if task.priority == TaskPriority.CRITICAL:
                return {"action": "execute", "note": "critical_override"}
            elif task.priority == TaskPriority.BACKGROUND:
                return {"action": "local", "note": "use_local_model"}
            else:
                return {"action": "defer", "note": "no_budget", "retry_after": "budget_reset"}

        # 3. Tarefas batchaveis
        if task.batch_key and task.priority.value >= TaskPriority.MEDIUM.value:
            self.add_to_batch(task)
            return {"action": "batch", "batch_key": task.batch_key}

        # 4. Tarefas de baixa prioridade - tenta local primeiro
        if task.priority == TaskPriority.BACKGROUND:
            return {"action": "local", "note": "try_local_first"}

        # 5. Executa via API
        return {"action": "execute"}

    def get_next_tasks(self, max_tasks: int = 5) -> list[ScheduledTask]:
        """Retorna as proximas tarefas priorizadas para execucao."""
        # Ordena por prioridade
        self.queue.sort(key=lambda t: t.priority.value)
        remaining = self.remaining_daily()

        # Retorna no maximo o que o budget permite
        count = min(max_tasks, remaining, len(self.queue))
        tasks = self.queue[:count]
        self.queue = self.queue[count:]
        return tasks

    def get_status(self) -> dict[str, Any]:
        """Status completo do scheduler."""
        self._check_reset()
        return {
            "budget": {
                "daily": f"{self.budget.daily_used}/{self.budget.daily_limit}",
                "weekly": f"{self.budget.weekly_used}/{self.budget.weekly_limit}",
                "remaining_today": self.remaining_daily(),
                "remaining_week": self.remaining_weekly(),
                "total_tokens": self.budget.total_tokens_used,
                "total_cost_usd": f"${self.budget.estimated_cost_usd:.4f}",
            },
            "queue_size": len(self.queue),
            "batches_pending": {k: len(v) for k, v in self.batch_buffer.items()},
            "cache_files": len(list(self.cache_dir.glob("*.json"))) - 1,  # -1 for budget.json
        }
