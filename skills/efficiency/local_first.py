"""Local-First Skill - Processa localmente antes de chamar API.

Inspirado em:
- Leon AI: self-hosted, privacy-first, funciona offline
- PyGPT: assistente desktop com modelos locais
- CrewAI: "stable pieces keep them simple, fast, and cheap"

Regra de ouro: se pode ser feito localmente, NAO gaste um API call.
"""

from __future__ import annotations

import json
import logging
import re
from datetime import datetime
from pathlib import Path
from typing import Any

logger = logging.getLogger("skill.local_first")


class LocalFirstSkill:
    """Skill que tenta resolver tarefas localmente antes de usar API.

    Categorias de processamento local:
    1. Text processing - regex, parsing, formatacao
    2. File operations - leitura, busca, organizacao
    3. Data analysis - contagens, filtros, agregacoes
    4. Knowledge lookup - base de conhecimento local
    5. Template rendering - preencher templates

    So chama API quando precisa de:
    - Raciocinio complexo
    - Geracao de texto criativo
    - Analise semantica
    - Sintese de multiplas fontes
    """

    name = "local_first"
    description = "Processa localmente antes de chamar API (custo zero)"

    def __init__(self, knowledge_dir: str = "data/knowledge") -> None:
        self.knowledge_dir = Path(knowledge_dir)
        self.knowledge_dir.mkdir(parents=True, exist_ok=True)

    def can_handle_locally(self, task_type: str) -> bool:
        """Verifica se a tarefa pode ser tratada localmente."""
        local_tasks = {
            "format_text",
            "parse_json",
            "parse_yaml",
            "count_words",
            "extract_urls",
            "extract_emails",
            "file_search",
            "file_read",
            "date_calc",
            "list_files",
            "filter_data",
            "sort_data",
            "template_render",
            "regex_match",
            "regex_replace",
            "json_transform",
            "csv_parse",
            "word_count",
            "char_count",
            "deduplicate",
            "merge_lists",
            "calculate",
        }
        return task_type in local_tasks

    # ------------------------------------------------------------------
    # Text Processing (custo: $0.00)
    # ------------------------------------------------------------------

    def extract_urls(self, text: str) -> list[str]:
        """Extrai URLs de um texto."""
        url_pattern = r'https?://[^\s<>"\')\]]*'
        return re.findall(url_pattern, text)

    def extract_emails(self, text: str) -> list[str]:
        """Extrai emails de um texto."""
        email_pattern = r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
        return re.findall(email_pattern, text)

    def count_words(self, text: str) -> dict[str, int]:
        """Conta palavras em um texto."""
        words = text.split()
        return {
            "total_words": len(words),
            "unique_words": len(set(words)),
            "characters": len(text),
            "lines": text.count("\n") + 1,
        }

    def format_text(self, text: str, fmt: str = "markdown") -> str:
        """Formata texto localmente."""
        if fmt == "uppercase":
            return text.upper()
        elif fmt == "lowercase":
            return text.lower()
        elif fmt == "title":
            return text.title()
        elif fmt == "strip":
            return "\n".join(line.strip() for line in text.split("\n"))
        return text

    def regex_search(self, text: str, pattern: str) -> list[str]:
        """Busca com regex."""
        return re.findall(pattern, text)

    def regex_replace(self, text: str, pattern: str, replacement: str) -> str:
        """Substitui com regex."""
        return re.sub(pattern, replacement, text)

    # ------------------------------------------------------------------
    # Data Processing (custo: $0.00)
    # ------------------------------------------------------------------

    def parse_json(self, text: str) -> Any:
        """Parse JSON localmente."""
        return json.loads(text)

    def filter_data(self, data: list[dict[str, Any]], key: str, value: Any) -> list[dict[str, Any]]:
        """Filtra lista de dicts."""
        return [item for item in data if item.get(key) == value]

    def sort_data(
        self, data: list[dict[str, Any]], key: str, reverse: bool = False
    ) -> list[dict[str, Any]]:
        """Ordena lista de dicts."""
        return sorted(data, key=lambda x: x.get(key, ""), reverse=reverse)

    def deduplicate(self, items: list[str]) -> list[str]:
        """Remove duplicatas mantendo ordem."""
        seen: set[str] = set()
        result = []
        for item in items:
            if item not in seen:
                seen.add(item)
                result.append(item)
        return result

    def merge_lists(self, *lists: list[Any]) -> list[Any]:
        """Merge multiplas listas."""
        result = []
        for lst in lists:
            result.extend(lst)
        return result

    # ------------------------------------------------------------------
    # File Operations (custo: $0.00)
    # ------------------------------------------------------------------

    def list_files(self, directory: str, pattern: str = "*", recursive: bool = True) -> list[str]:
        """Lista arquivos em um diretorio."""
        path = Path(directory)
        if not path.exists():
            return []
        if recursive:
            return [str(f) for f in path.rglob(pattern)]
        return [str(f) for f in path.glob(pattern)]

    def read_file(self, file_path: str) -> str:
        """Le um arquivo."""
        path = Path(file_path)
        if path.exists():
            return path.read_text()
        return ""

    def search_files(self, directory: str, query: str) -> list[dict[str, Any]]:
        """Busca texto em arquivos (grep local)."""
        results = []
        for file_path in Path(directory).rglob("*.py"):
            try:
                content = file_path.read_text()
                for i, line in enumerate(content.split("\n"), 1):
                    if query.lower() in line.lower():
                        results.append(
                            {
                                "file": str(file_path),
                                "line": i,
                                "content": line.strip(),
                            }
                        )
            except Exception:
                continue
        return results

    # ------------------------------------------------------------------
    # Knowledge Base Local (custo: $0.00)
    # ------------------------------------------------------------------

    def _safe_knowledge_path(self, key: str) -> Path:
        """Resolve path and reject traversal outside knowledge_dir."""
        file_path = (self.knowledge_dir / f"{key}.json").resolve()
        if not file_path.is_relative_to(self.knowledge_dir.resolve()):
            raise ValueError(f"Key '{key}' resolves outside knowledge_dir")
        return file_path

    def save_knowledge(self, key: str, data: Any) -> None:
        """Salva conhecimento local."""
        file_path = self._safe_knowledge_path(key)
        file_path.write_text(json.dumps(data, indent=2, ensure_ascii=False, default=str))

    def get_knowledge(self, key: str) -> Any:
        """Recupera conhecimento local."""
        file_path = self._safe_knowledge_path(key)
        if file_path.exists():
            return json.loads(file_path.read_text())
        return None

    def search_knowledge(self, query: str) -> list[dict[str, Any]]:
        """Busca na base de conhecimento local."""
        results = []
        for file_path in self.knowledge_dir.glob("*.json"):
            try:
                content = file_path.read_text()
                if query.lower() in content.lower():
                    results.append(
                        {
                            "key": file_path.stem,
                            "preview": content[:200],
                        }
                    )
            except Exception:
                continue
        return results

    # ------------------------------------------------------------------
    # Date/Time (custo: $0.00)
    # ------------------------------------------------------------------

    def current_datetime(self) -> dict[str, str]:
        """Retorna data/hora atual."""
        now = datetime.now()
        return {
            "iso": now.isoformat(),
            "date": now.strftime("%Y-%m-%d"),
            "time": now.strftime("%H:%M:%S"),
            "weekday": now.strftime("%A"),
            "week_number": str(now.isocalendar()[1]),
        }

    def get_status(self) -> dict[str, Any]:
        """Status da skill local-first."""
        knowledge_files = list(self.knowledge_dir.glob("*.json"))
        return {
            "knowledge_files": len(knowledge_files),
            "knowledge_dir": str(self.knowledge_dir),
            "capabilities": [
                "text_processing",
                "data_processing",
                "file_operations",
                "knowledge_base",
                "date_time",
            ],
            "cost_per_operation": "$0.00",
        }
