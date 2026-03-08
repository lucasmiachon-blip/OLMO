"""Agente de Organizacao Pessoal - Gestao completa de vida pessoal e profissional."""

from __future__ import annotations

import asyncio
import logging
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Any

from agents.core.base_agent import AgentStatus, BaseAgent, TaskResult

logger = logging.getLogger("agent.organizacao")


class Priority(Enum):
    CRITICAL = "critical"
    HIGH = "high"
    MEDIUM = "medium"
    LOW = "low"


class TaskStatus(Enum):
    TODO = "todo"
    IN_PROGRESS = "in_progress"
    BLOCKED = "blocked"
    DONE = "done"
    CANCELLED = "cancelled"


@dataclass
class PersonalTask:
    """Uma tarefa pessoal ou profissional."""

    title: str
    description: str = ""
    priority: Priority = Priority.MEDIUM
    status: TaskStatus = TaskStatus.TODO
    due_date: str | None = None
    tags: list[str] = field(default_factory=list)
    project: str = ""
    created_at: str = field(default_factory=lambda: datetime.now().isoformat())
    completed_at: str | None = None
    subtasks: list[PersonalTask] = field(default_factory=list)
    notes: list[str] = field(default_factory=list)


@dataclass
class Project:
    """Um projeto com multiplas tarefas."""

    name: str
    description: str
    tasks: list[PersonalTask] = field(default_factory=list)
    goals: list[str] = field(default_factory=list)
    status: str = "active"
    deadline: str | None = None


@dataclass
class DailyPlan:
    """Plano diario."""

    date: str
    focus_areas: list[str] = field(default_factory=list)
    tasks: list[PersonalTask] = field(default_factory=list)
    habits: list[dict[str, Any]] = field(default_factory=list)
    reflections: str = ""
    energy_level: int = 5  # 1-10


class OrganizationAgent(BaseAgent):
    """Agente de organizacao pessoal.

    Capacidades:
    - Gestao de tarefas (GTD - Getting Things Done)
    - Planejamento diario/semanal/mensal
    - Gestao de projetos pessoais
    - Sistema de notas e knowledge management
    - Rastreamento de habitos
    - Priorizacao inteligente (Eisenhower Matrix)
    - Reviews semanais automaticas
    """

    def __init__(self) -> None:
        super().__init__(
            name="organizacao",
            description="Gestao pessoal completa: tarefas, projetos, habitos e planejamento",
        )
        self.tasks: list[PersonalTask] = []
        self.projects: dict[str, Project] = {}
        self.daily_plans: dict[str, DailyPlan] = {}
        self.inbox: list[dict[str, Any]] = []  # GTD inbox
        self.someday_maybe: list[str] = []

    async def execute(self, task: dict[str, Any]) -> TaskResult:
        """Executa uma tarefa de organizacao."""
        self.status = AgentStatus.RUNNING
        action = task.get("action", "")

        try:
            actions: dict[str, Any] = {
                "add_task": lambda: self._add_task(task),
                "complete_task": lambda: self._complete_task(task.get("task_id", 0)),
                "plan_day": lambda: self._plan_day(task.get("date", "")),
                "plan_week": lambda: self._plan_week(task.get("start_date", "")),
                "review_week": lambda: self._weekly_review(),
                "prioritize": lambda: self._prioritize_tasks(),
                "add_project": lambda: self._add_project(task),
                "inbox_process": lambda: self._process_inbox(),
                "capture": lambda: self._capture_to_inbox(task.get("item", "")),
                "status_report": lambda: self._status_report(),
            }

            handler = actions.get(action)
            if handler:
                call_result = handler()
                if asyncio.iscoroutine(call_result):
                    call_result = await call_result
                return call_result if isinstance(call_result, TaskResult) else TaskResult(success=True, data=call_result)
            return TaskResult(success=False, error=f"Unknown action: {action}")
        except Exception as e:
            self.status = AgentStatus.ERROR
            logger.error(f"Organization agent error: {e}")
            return TaskResult(success=False, error=str(e))
        finally:
            self.status = AgentStatus.IDLE

    async def plan(self, objective: str) -> list[dict[str, Any]]:
        """Planeja como organizar algo."""
        return [
            {"step": 1, "action": "capture", "description": "Capturar todas as tarefas"},
            {"step": 2, "action": "clarify", "description": "Clarificar cada item"},
            {"step": 3, "action": "organize", "description": "Organizar por contexto/projeto"},
            {"step": 4, "action": "reflect", "description": "Revisar e priorizar"},
            {"step": 5, "action": "engage", "description": "Executar com foco"},
        ]

    def _add_task(self, task_data: dict[str, Any]) -> TaskResult:
        """Adiciona uma nova tarefa."""
        new_task = PersonalTask(
            title=task_data.get("title", ""),
            description=task_data.get("description", ""),
            priority=Priority(task_data.get("priority", "medium")),
            tags=task_data.get("tags", []),
            project=task_data.get("project", ""),
            due_date=task_data.get("due_date"),
        )
        self.tasks.append(new_task)
        logger.info(f"Task added: {new_task.title}")
        return TaskResult(success=True, data={"task": new_task.title, "index": len(self.tasks) - 1})

    def _complete_task(self, task_id: int) -> TaskResult:
        """Marca uma tarefa como concluida."""
        if 0 <= task_id < len(self.tasks):
            self.tasks[task_id].status = TaskStatus.DONE
            self.tasks[task_id].completed_at = datetime.now().isoformat()
            return TaskResult(success=True, data={"completed": self.tasks[task_id].title})
        return TaskResult(success=False, error="Task not found")

    def _plan_day(self, date: str) -> TaskResult:
        """Cria o plano do dia."""
        if not date:
            date = datetime.now().strftime("%Y-%m-%d")

        # Filtra tarefas pendentes prioritarias
        pending = [t for t in self.tasks if t.status == TaskStatus.TODO]
        high_priority = [t for t in pending if t.priority in (Priority.CRITICAL, Priority.HIGH)]
        medium_priority = [t for t in pending if t.priority == Priority.MEDIUM]

        daily_tasks = high_priority[:3] + medium_priority[:2]  # Max 5 tarefas/dia

        plan = DailyPlan(
            date=date,
            tasks=daily_tasks,
            focus_areas=[t.project for t in daily_tasks if t.project],
        )
        self.daily_plans[date] = plan

        return TaskResult(
            success=True,
            data={
                "date": date,
                "task_count": len(daily_tasks),
                "tasks": [t.title for t in daily_tasks],
                "focus_areas": plan.focus_areas,
            },
        )

    def _plan_week(self, start_date: str) -> TaskResult:
        """Cria o plano semanal."""
        return TaskResult(
            success=True,
            data={
                "week_start": start_date,
                "total_pending": len([t for t in self.tasks if t.status == TaskStatus.TODO]),
                "projects_active": len([p for p in self.projects.values() if p.status == "active"]),
            },
        )

    def _weekly_review(self) -> TaskResult:
        """Executa a revisao semanal (GTD)."""
        completed = [t for t in self.tasks if t.status == TaskStatus.DONE]
        pending = [t for t in self.tasks if t.status == TaskStatus.TODO]
        blocked = [t for t in self.tasks if t.status == TaskStatus.BLOCKED]

        return TaskResult(
            success=True,
            data={
                "review_type": "weekly",
                "completed_count": len(completed),
                "pending_count": len(pending),
                "blocked_count": len(blocked),
                "inbox_items": len(self.inbox),
                "someday_items": len(self.someday_maybe),
            },
        )

    def _prioritize_tasks(self) -> TaskResult:
        """Prioriza tarefas usando Eisenhower Matrix."""
        pending = [t for t in self.tasks if t.status == TaskStatus.TODO]

        matrix = {
            "urgent_important": [],     # Do first
            "not_urgent_important": [],  # Schedule
            "urgent_not_important": [],  # Delegate
            "not_urgent_not_important": [],  # Eliminate
        }

        for task in pending:
            if task.priority == Priority.CRITICAL:
                matrix["urgent_important"].append(task.title)
            elif task.priority == Priority.HIGH:
                matrix["not_urgent_important"].append(task.title)
            elif task.priority == Priority.MEDIUM:
                matrix["urgent_not_important"].append(task.title)
            else:
                matrix["not_urgent_not_important"].append(task.title)

        return TaskResult(success=True, data={"eisenhower_matrix": matrix})

    def _add_project(self, data: dict[str, Any]) -> TaskResult:
        """Adiciona um novo projeto."""
        project = Project(
            name=data.get("name", ""),
            description=data.get("description", ""),
            goals=data.get("goals", []),
            deadline=data.get("deadline"),
        )
        self.projects[project.name] = project
        return TaskResult(success=True, data={"project": project.name})

    def _process_inbox(self) -> TaskResult:
        """Processa items da inbox (GTD)."""
        processed = len(self.inbox)
        self.inbox.clear()
        return TaskResult(success=True, data={"processed": processed})

    def _capture_to_inbox(self, item: str) -> TaskResult:
        """Captura um item na inbox."""
        self.inbox.append({"item": item, "captured_at": datetime.now().isoformat()})
        return TaskResult(success=True, data={"captured": item})

    def _status_report(self) -> TaskResult:
        """Gera relatorio de status."""
        return TaskResult(
            success=True,
            data={
                "total_tasks": len(self.tasks),
                "by_status": {
                    s.value: len([t for t in self.tasks if t.status == s])
                    for s in TaskStatus
                },
                "by_priority": {
                    p.value: len([t for t in self.tasks if t.priority == p])
                    for p in Priority
                },
                "active_projects": len([p for p in self.projects.values() if p.status == "active"]),
                "inbox_size": len(self.inbox),
            },
        )
