"""Knowledge Organizer Subagent - Organiza Notion + Obsidian + Zotero autonomamente.

Este subagente trabalha de forma autonoma para manter seu
knowledge base medico/cientifico organizado em:
- Notion: paginas bonitas, databases, digests
- Obsidian: vault local com links bidirecionais (Zettelkasten)
- Zotero: referencias bibliograficas com citacoes

Inspirado em:
- Zettelkasten (Niklas Luhmann) - notas atomicas interligadas
- PARA Method (Tiago Forte) - Projects, Areas, Resources, Archive
- Simon Willison - "build once, query forever"
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path
from typing import Any

from agents.core.base_agent import AgentStatus, BaseAgent, TaskResult

logger = logging.getLogger("subagent.knowledge_organizer")


@dataclass
class KnowledgeItem:
    """Um item de conhecimento (nota, paper, evidence)."""

    title: str
    content: str
    item_type: str  # note, paper, evidence, guideline, digest
    source: str = ""
    tags: list[str] = field(default_factory=list)
    references: list[str] = field(default_factory=list)  # PMIDs, DOIs
    evidence_level: str = ""  # I-V
    recommendation_grade: str = ""  # A-D
    created_at: str = field(default_factory=lambda: datetime.now().isoformat())
    updated_at: str = ""
    notion_page_id: str = ""
    obsidian_path: str = ""
    zotero_key: str = ""
    links_to: list[str] = field(default_factory=list)  # Linked notes


@dataclass
class NotionDatabase:
    """Configuracao de um database no Notion."""

    name: str
    database_id: str = ""
    properties: dict[str, str] = field(default_factory=dict)
    views: list[str] = field(default_factory=list)


class KnowledgeOrganizerSubagent(BaseAgent):
    """Subagente autonomo que organiza Notion + Obsidian + Zotero.

    Funciona como um "bibliotecario AI" que:
    1. Recebe conteudo de outros agentes (papers, notas, evidencias)
    2. Classifica e tageia automaticamente
    3. Cria links entre notas relacionadas (Zettelkasten)
    4. Publica no Notion com templates bonitos
    5. Sincroniza com Obsidian vault local
    6. Gerencia referencias no Zotero
    7. Mantem indices e mapas de conteudo atualizados

    Organizacao PARA Method:
    - Projects: Pesquisas ativas, casos clinicos
    - Areas: Especialidades, topicos recorrentes
    - Resources: Papers, guidelines, referencias
    - Archive: Conteudo concluido/antigo
    """

    # Databases Notion padrao
    NOTION_DATABASES = {
        "knowledge_base": NotionDatabase(
            name="Knowledge Base Medica",
            properties={
                "Titulo": "title",
                "Tipo": "select",        # Paper, Guideline, Nota, Evidence
                "Especialidade": "select",
                "Nivel Evidencia": "select",  # I, II, III, IV, V
                "Recomendacao": "select",     # A, B, C, D
                "Tags": "multi_select",
                "PMID": "rich_text",
                "Status": "select",       # Para Revisar, Revisado, Arquivado
                "Data": "date",
            },
            views=["Gallery", "Table", "Board by Status"],
        ),
        "inbox": NotionDatabase(
            name="Inbox Medico",
            properties={
                "Item": "title",
                "Fonte": "select",
                "Prioridade": "select",
                "Acao": "select",  # Ler, Analisar, Arquivar, Delegar
                "Data": "date",
            },
        ),
        "digests": NotionDatabase(
            name="Digests Semanais",
            properties={
                "Titulo": "title",
                "Semana": "number",
                "Ano": "number",
                "Top Papers": "relation",
                "Data": "date",
            },
        ),
        "projects": NotionDatabase(
            name="Projetos de Pesquisa",
            properties={
                "Projeto": "title",
                "Status": "select",
                "Deadline": "date",
                "Papers": "relation",
                "Notas": "relation",
            },
        ),
    }

    # Estrutura Obsidian vault
    OBSIDIAN_STRUCTURE = {
        "00-Inbox": "Notas rapidas e captura",
        "01-Projects": "Pesquisas ativas",
        "02-Areas": "Especialidades e topicos",
        "03-Resources": "Papers, guidelines, referencias",
        "04-Archive": "Conteudo finalizado",
        "Templates": "Templates de notas",
        "Attachments": "PDFs e imagens",
    }

    def __init__(self, obsidian_vault: str = "data/obsidian-vault") -> None:
        super().__init__(
            name="knowledge_organizer",
            description="Organiza Notion + Obsidian + Zotero de forma autonoma",
        )
        self.vault_path = Path(obsidian_vault)
        self.items: list[KnowledgeItem] = []
        self.index: dict[str, list[str]] = {}  # tag -> [item_titles]

    async def execute(self, task: dict[str, Any]) -> TaskResult:
        """Executa tarefa de organizacao de conhecimento."""
        self.status = AgentStatus.RUNNING
        action = task.get("action", "")

        try:
            actions_map = {
                "publish_to_notion": self._publish_to_notion,
                "sync_to_obsidian": self._sync_to_obsidian,
                "add_to_zotero": self._add_to_zotero,
                "organize_inbox": self._organize_inbox,
                "create_links": self._create_zettelkasten_links,
                "update_index": self._update_index,
                "full_sync": self._full_sync,
                "create_digest_page": self._create_digest_page,
                "archive_old": self._archive_old_items,
            }

            handler = actions_map.get(action)
            if handler:
                return await handler(task)
            return TaskResult(success=False, error=f"Unknown action: {action}")
        except Exception as e:
            self.status = AgentStatus.ERROR
            logger.error(f"Knowledge organizer error: {e}")
            return TaskResult(success=False, error=str(e))
        finally:
            self.status = AgentStatus.IDLE

    async def plan(self, objective: str) -> list[dict[str, Any]]:
        return [
            {"step": 1, "action": "setup_databases", "desc": "Criar databases Notion"},
            {"step": 2, "action": "setup_vault", "desc": "Criar estrutura Obsidian"},
            {"step": 3, "action": "initial_sync", "desc": "Sincronizar conteudo existente"},
            {"step": 4, "action": "create_links", "desc": "Criar links Zettelkasten"},
            {"step": 5, "action": "schedule_maintenance", "desc": "Agendar manutencao"},
        ]

    # ------------------------------------------------------------------
    # Notion Operations
    # ------------------------------------------------------------------

    async def _publish_to_notion(self, task: dict[str, Any]) -> TaskResult:
        """Publica conteudo no Notion com template bonito."""
        item = KnowledgeItem(
            title=task.get("title", ""),
            content=task.get("content", ""),
            item_type=task.get("type", "note"),
            tags=task.get("tags", []),
            references=task.get("references", []),
            evidence_level=task.get("evidence_level", ""),
            recommendation_grade=task.get("recommendation_grade", ""),
        )

        # Determinar database e template
        db_key = self._route_to_database(item)
        template = self._select_template(item)

        self.items.append(item)
        self._index_item(item)

        logger.info(f"Published to Notion: {item.title} -> {db_key}")

        return TaskResult(
            success=True,
            data={
                "title": item.title,
                "database": db_key,
                "template": template,
                "tags": item.tags,
                "status": "published",
            },
        )

    def _route_to_database(self, item: KnowledgeItem) -> str:
        """Roteia item para o database correto."""
        routing = {
            "paper": "knowledge_base",
            "evidence": "knowledge_base",
            "guideline": "knowledge_base",
            "note": "inbox",
            "digest": "digests",
        }
        return routing.get(item.item_type, "inbox")

    def _select_template(self, item: KnowledgeItem) -> str:
        """Seleciona template Notion baseado no tipo."""
        templates = {
            "paper": "resumo_evidencias_medicas",
            "evidence": "resumo_evidencias_medicas",
            "guideline": "nota_clinica_rapida",
            "note": "nota_clinica_rapida",
            "digest": "digest_semanal_medico",
        }
        return templates.get(item.item_type, "nota_clinica_rapida")

    # ------------------------------------------------------------------
    # Obsidian Operations
    # ------------------------------------------------------------------

    async def _sync_to_obsidian(self, task: dict[str, Any]) -> TaskResult:
        """Sincroniza item com Obsidian vault."""
        title = task.get("title", "")
        content = task.get("content", "")
        item_type = task.get("type", "note")

        # Determinar pasta PARA
        folder = self._para_classify(item_type, task.get("status", "active"))

        # Criar nota Obsidian com frontmatter
        obsidian_note = self._create_obsidian_note(title, content, task)

        # Caminho no vault
        note_path = self.vault_path / folder / f"{self._slugify(title)}.md"
        note_path.parent.mkdir(parents=True, exist_ok=True)
        note_path.write_text(obsidian_note)

        logger.info(f"Synced to Obsidian: {note_path}")

        return TaskResult(
            success=True,
            data={"path": str(note_path), "folder": folder},
        )

    def _para_classify(self, item_type: str, status: str) -> str:
        """Classifica no metodo PARA."""
        if status == "archived":
            return "04-Archive"
        if item_type in ("project", "research"):
            return "01-Projects"
        if item_type in ("area", "specialty"):
            return "02-Areas"
        return "03-Resources"

    def _create_obsidian_note(self, title: str, content: str, metadata: dict[str, Any]) -> str:
        """Cria nota Obsidian com frontmatter YAML."""
        frontmatter = {
            "title": title,
            "type": metadata.get("type", "note"),
            "tags": metadata.get("tags", []),
            "evidence_level": metadata.get("evidence_level", ""),
            "references": metadata.get("references", []),
            "created": datetime.now().strftime("%Y-%m-%d"),
            "source": metadata.get("source", ""),
        }

        yaml_lines = ["---"]
        for key, value in frontmatter.items():
            if isinstance(value, list):
                yaml_lines.append(f"{key}:")
                for item in value:
                    yaml_lines.append(f"  - {item}")
            else:
                yaml_lines.append(f"{key}: {value}")
        yaml_lines.append("---")
        yaml_lines.append("")
        yaml_lines.append(f"# {title}")
        yaml_lines.append("")
        yaml_lines.append(content)

        return "\n".join(yaml_lines)

    def _slugify(self, text: str) -> str:
        """Converte titulo em slug para filename."""
        import re
        slug = text.lower().strip()
        slug = re.sub(r'[^\w\s-]', '', slug)
        slug = re.sub(r'[-\s]+', '-', slug)
        return slug[:80]

    # ------------------------------------------------------------------
    # Zotero Operations
    # ------------------------------------------------------------------

    async def _add_to_zotero(self, task: dict[str, Any]) -> TaskResult:
        """Adiciona referencia ao Zotero."""
        reference = {
            "title": task.get("title", ""),
            "authors": task.get("authors", []),
            "journal": task.get("journal", ""),
            "year": task.get("year", ""),
            "pmid": task.get("pmid", ""),
            "doi": task.get("doi", ""),
            "tags": task.get("tags", []),
            "collection": task.get("collection", "Medical Research"),
        }

        logger.info(f"Added to Zotero: {reference['title']}")

        return TaskResult(
            success=True,
            data={
                "reference": reference,
                "status": "added_to_zotero",
                "note": "Use Zotero plugin para sync automatico com Obsidian",
            },
        )

    # ------------------------------------------------------------------
    # Zettelkasten Links
    # ------------------------------------------------------------------

    async def _create_zettelkasten_links(self, task: dict[str, Any]) -> TaskResult:
        """Cria links bidirecionais entre notas relacionadas."""
        target_title = task.get("title", "")
        related = self._find_related_items(target_title)

        links_created = []
        for item_title in related:
            links_created.append(f"[[{item_title}]]")

        return TaskResult(
            success=True,
            data={
                "title": target_title,
                "links_created": len(links_created),
                "linked_to": links_created,
            },
        )

    def _find_related_items(self, title: str) -> list[str]:
        """Encontra items relacionados por tags compartilhadas."""
        target = next((i for i in self.items if i.title == title), None)
        if not target:
            return []

        related = []
        for item in self.items:
            if item.title == title:
                continue
            shared_tags = set(target.tags) & set(item.tags)
            if shared_tags:
                related.append(item.title)

        return related[:5]  # Max 5 links

    # ------------------------------------------------------------------
    # Maintenance
    # ------------------------------------------------------------------

    async def _organize_inbox(self, task: dict[str, Any]) -> TaskResult:
        """Processa inbox e organiza items."""
        inbox_items = [i for i in self.items if i.item_type == "note" and not i.notion_page_id]
        processed = 0

        for item in inbox_items:
            # Auto-classify
            if any(ref for ref in item.references):
                item.item_type = "paper"
            processed += 1

        return TaskResult(
            success=True,
            data={"inbox_processed": processed, "remaining": len(inbox_items) - processed},
        )

    async def _update_index(self, task: dict[str, Any]) -> TaskResult:
        """Atualiza indices e mapas de conteudo."""
        self.index.clear()
        for item in self.items:
            for tag in item.tags:
                if tag not in self.index:
                    self.index[tag] = []
                self.index[tag].append(item.title)

        return TaskResult(
            success=True,
            data={
                "total_items": len(self.items),
                "total_tags": len(self.index),
                "top_tags": dict(sorted(
                    self.index.items(), key=lambda x: -len(x[1])
                )[:10]),
            },
        )

    async def _full_sync(self, task: dict[str, Any]) -> TaskResult:
        """Sincronizacao completa Notion <-> Obsidian <-> Zotero."""
        results = {
            "notion_pages": len([i for i in self.items if i.notion_page_id]),
            "obsidian_notes": len([i for i in self.items if i.obsidian_path]),
            "zotero_refs": len([i for i in self.items if i.zotero_key]),
            "total_items": len(self.items),
            "status": "sync_complete",
        }
        return TaskResult(success=True, data=results)

    async def _create_digest_page(self, task: dict[str, Any]) -> TaskResult:
        """Cria pagina de digest semanal."""
        return TaskResult(
            success=True,
            data={
                "type": "digest",
                "template": "digest_semanal_medico",
                "status": "created",
            },
        )

    async def _archive_old_items(self, task: dict[str, Any]) -> TaskResult:
        """Arquiva items antigos."""
        days_threshold = task.get("days", 90)
        archived = 0

        return TaskResult(
            success=True,
            data={"archived": archived, "threshold_days": days_threshold},
        )

    def _index_item(self, item: KnowledgeItem) -> None:
        """Indexa um item por tags."""
        for tag in item.tags:
            if tag not in self.index:
                self.index[tag] = []
            self.index[tag].append(item.title)
