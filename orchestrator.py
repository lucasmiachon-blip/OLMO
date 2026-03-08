"""Entry point principal do Ecossistema de Agentes AI.

Usage:
    python -m orchestrator run          # Inicia o ecossistema
    python -m orchestrator status       # Mostra status dos agentes
    python -m orchestrator workflow <n> # Executa um workflow
"""

from __future__ import annotations

import asyncio
import logging
import sys
from typing import Any

from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from rich.tree import Tree

from agents.core.orchestrator import Orchestrator
from agents.automation.automation_agent import AutomationAgent
from agents.scientific.scientific_agent import ScientificAgent
from agents.organization.organization_agent import OrganizationAgent
from agents.ai_update.ai_update_agent import AIUpdateAgent
from subagents.monitors.web_monitor import WebMonitorSubagent
from subagents.processors.data_pipeline import DataPipelineSubagent
from subagents.processors.notion_cleaner import NotionCleanerSubagent
from subagents.analyzers.trend_analyzer import TrendAnalyzerSubagent
from config.loader import load_config, load_workflows

console = Console()
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(name)s] %(levelname)s: %(message)s")
logger = logging.getLogger("orchestrator")


def build_ecosystem() -> Orchestrator:
    """Constroi e configura o ecossistema completo de agentes."""
    config = load_config()
    workflows_config = load_workflows()

    # Criar orquestrador
    orch = Orchestrator()

    # Criar agentes principais
    agents = [
        ScientificAgent(),
        AutomationAgent(),
        OrganizationAgent(),
        AIUpdateAgent(),
    ]

    # Criar subagentes
    subagents = [
        WebMonitorSubagent(),
        DataPipelineSubagent(),
        TrendAnalyzerSubagent(),
        NotionCleanerSubagent(),
    ]

    # Aplicar config do YAML e registrar agentes
    agents_config = config.get("agents", {})
    for agent in agents:
        if agent.name in agents_config:
            agent.configure_from_yaml(agents_config[agent.name])
        orch.register_agent(agent)

    # Aplicar config do YAML aos subagentes e adicionar aos pais
    subagents_config = config.get("subagents", {})
    subagent_to_parent = {
        "web_monitor": "atualizacao_ai",
        "data_pipeline": "automacao",
        "trend_analyzer": "cientifico",
        "notion_cleaner": "organizacao",
    }
    for subagent in subagents:
        if subagent.name in subagents_config:
            subagent.configure_from_yaml(subagents_config[subagent.name])
        parent_name = subagent_to_parent.get(subagent.name)
        if parent_name and parent_name in orch.agents:
            orch.agents[parent_name].add_subagent(subagent)
        else:
            logger.warning(f"Parent '{parent_name}' not found for subagent '{subagent.name}'")

    # Registrar workflows
    for wf_name, wf_config in workflows_config.get("workflows", {}).items():
        orch.register_workflow(wf_name, wf_config.get("steps", []))

    return orch


def display_status(orch: Orchestrator) -> None:
    """Exibe status do ecossistema no terminal."""
    status = orch.get_ecosystem_status()

    # Header
    console.print(Panel.fit(
        "[bold cyan]AI Agent Ecosystem[/bold cyan]\n"
        f"Status: [green]{status['orchestrator_status']}[/green]",
        border_style="cyan",
    ))

    # Arvore de agentes
    tree = Tree("[bold]Ecossistema de Agentes[/bold]")

    for name, info in status["agents"].items():
        agent_branch = tree.add(
            f"[bold yellow]{name}[/bold yellow] "
            f"[dim]({info['status']})[/dim] - {info['description']}"
        )

        if info["skills"]:
            skills_branch = agent_branch.add("[cyan]Skills[/cyan]")
            for skill in info["skills"]:
                skills_branch.add(f"[dim]{skill}[/dim]")

        if info["subagents"]:
            sub_branch = agent_branch.add("[magenta]Subagentes[/magenta]")
            for sub in info["subagents"]:
                sub_branch.add(f"[dim]{sub}[/dim]")

    console.print(tree)

    # Workflows
    if status["workflows"]:
        table = Table(title="Workflows Registrados")
        table.add_column("Nome", style="cyan")
        for wf in status["workflows"]:
            table.add_row(wf)
        console.print(table)


async def run_ecosystem(orch: Orchestrator) -> None:
    """Executa o ecossistema em modo interativo."""
    display_status(orch)

    console.print("\n[bold green]Ecossistema iniciado![/bold green]")
    console.print("[dim]Pressione Ctrl+C para sair[/dim]\n")

    # Executa workflow de revisao matinal como demonstracao
    console.print("[yellow]Executando revisao matinal...[/yellow]")
    results = await orch.run_workflow("morning_review")
    for i, result in enumerate(results):
        status_icon = "[green]OK[/green]" if result.success else "[red]FAIL[/red]"
        console.print(f"  Step {i + 1}: {status_icon}")


async def run_workflow(orch: Orchestrator, workflow_name: str) -> None:
    """Executa um workflow especifico."""
    console.print(f"[yellow]Executando workflow: {workflow_name}[/yellow]")
    results = await orch.run_workflow(workflow_name)

    for i, result in enumerate(results):
        status_icon = "[green]OK[/green]" if result.success else "[red]FAIL[/red]"
        console.print(f"  Step {i + 1}: {status_icon}")
        if result.data:
            console.print(f"    [dim]{result.data}[/dim]")


def main() -> None:
    """Ponto de entrada principal."""
    orch = build_ecosystem()

    if len(sys.argv) < 2:
        display_status(orch)
        return

    command = sys.argv[1]

    if command == "status":
        display_status(orch)
    elif command == "run":
        asyncio.run(run_ecosystem(orch))
    elif command == "workflow":
        if len(sys.argv) < 3:
            console.print("[red]Usage: orchestrator workflow <name>[/red]")
            return
        asyncio.run(run_workflow(orch, sys.argv[2]))
    else:
        console.print(f"[red]Unknown command: {command}[/red]")
        console.print("Commands: run, status, workflow <name>")


if __name__ == "__main__":
    main()
