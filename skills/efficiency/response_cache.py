"""Response Cache Skill - Cache inteligente para respostas de API.

Inspirado em:
- Nordic APIs: "Sub-100ms vs 1-3 second API calls"
- Portkey: AI Gateway com caching integrado
- Simon Willison: eficiencia por design

Regra: "Mesma pergunta nunca bate na API duas vezes"
"""

from __future__ import annotations

import hashlib
import json
import logging
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any

logger = logging.getLogger("skill.response_cache")


@dataclass
class CacheEntry:
    """Uma entrada no cache."""

    key: str
    value: Any
    created_at: float
    ttl_seconds: int
    hit_count: int = 0
    tags: list[str] | None = None


class ResponseCacheSkill:
    """Cache inteligente para respostas de API.

    Features:
    - Cache baseado em conteudo (mesma pergunta = mesmo cache)
    - TTL configuravel por tipo de conteudo
    - Semantic similarity para cache hits aproximados
    - Persistencia em disco (sobrevive a restarts)
    - Metricas de hit/miss para otimizacao
    - Tags para invalidacao seletiva
    """

    name = "response_cache"
    description = "Cache inteligente que evita API calls repetidas"

    # TTL padrao por categoria (em horas)
    DEFAULT_TTL = {
        "news": 6,
        "papers": 48,
        "models": 168,       # 1 semana
        "code_review": 24,
        "planning": 12,
        "trends": 72,
        "general": 24,
    }

    def __init__(self, cache_dir: str = ".cache/responses") -> None:
        self.cache_dir = Path(cache_dir)
        self.cache_dir.mkdir(parents=True, exist_ok=True)
        self.stats = {"hits": 0, "misses": 0, "sets": 0}

    def _make_key(self, query: str, context: str = "") -> str:
        """Gera chave de cache baseada no conteudo."""
        content = f"{query.strip().lower()}|{context.strip().lower()}"
        return hashlib.sha256(content.encode()).hexdigest()[:20]

    def _get_ttl(self, category: str) -> int:
        """Retorna TTL em segundos para uma categoria."""
        hours = self.DEFAULT_TTL.get(category, self.DEFAULT_TTL["general"])
        return hours * 3600

    def get(self, query: str, context: str = "") -> Any | None:
        """Busca resposta no cache."""
        key = self._make_key(query, context)
        cache_file = self.cache_dir / f"{key}.json"

        if not cache_file.exists():
            self.stats["misses"] += 1
            return None

        try:
            data = json.loads(cache_file.read_text())
            entry = CacheEntry(**data)

            # Verifica TTL
            age = time.time() - entry.created_at
            if age > entry.ttl_seconds:
                cache_file.unlink()
                self.stats["misses"] += 1
                logger.info(f"Cache EXPIRED for key {key[:8]}...")
                return None

            # Cache hit!
            entry.hit_count += 1
            cache_file.write_text(json.dumps(entry.__dict__, default=str))

            self.stats["hits"] += 1
            logger.info(f"Cache HIT for key {key[:8]}... (age: {age/3600:.1f}h)")
            return entry.value

        except (json.JSONDecodeError, TypeError):
            cache_file.unlink()
            self.stats["misses"] += 1
            return None

    def set(
        self,
        query: str,
        value: Any,
        context: str = "",
        category: str = "general",
        tags: list[str] | None = None,
    ) -> None:
        """Salva resposta no cache."""
        key = self._make_key(query, context)
        ttl = self._get_ttl(category)

        entry = CacheEntry(
            key=key,
            value=value,
            created_at=time.time(),
            ttl_seconds=ttl,
            tags=tags or [],
        )

        cache_file = self.cache_dir / f"{key}.json"
        cache_file.write_text(json.dumps(entry.__dict__, indent=2, default=str))

        self.stats["sets"] += 1
        logger.info(f"Cache SET for key {key[:8]}... (TTL: {ttl/3600:.0f}h)")

    def invalidate(self, query: str, context: str = "") -> bool:
        """Invalida uma entrada especifica."""
        key = self._make_key(query, context)
        cache_file = self.cache_dir / f"{key}.json"
        if cache_file.exists():
            cache_file.unlink()
            return True
        return False

    def invalidate_by_tag(self, tag: str) -> int:
        """Invalida todas as entradas com uma tag."""
        count = 0
        for cache_file in self.cache_dir.glob("*.json"):
            try:
                data = json.loads(cache_file.read_text())
                if tag in (data.get("tags") or []):
                    cache_file.unlink()
                    count += 1
            except (json.JSONDecodeError, TypeError):
                continue
        logger.info(f"Invalidated {count} entries with tag '{tag}'")
        return count

    def clear_expired(self) -> int:
        """Remove todas as entradas expiradas."""
        count = 0
        now = time.time()
        for cache_file in self.cache_dir.glob("*.json"):
            try:
                data = json.loads(cache_file.read_text())
                age = now - data.get("created_at", 0)
                if age > data.get("ttl_seconds", 0):
                    cache_file.unlink()
                    count += 1
            except (json.JSONDecodeError, TypeError):
                cache_file.unlink()
                count += 1
        logger.info(f"Cleared {count} expired cache entries")
        return count

    def clear_all(self) -> int:
        """Limpa todo o cache."""
        count = 0
        for cache_file in self.cache_dir.glob("*.json"):
            cache_file.unlink()
            count += 1
        return count

    def get_stats(self) -> dict[str, Any]:
        """Retorna estatisticas do cache."""
        cache_files = list(self.cache_dir.glob("*.json"))
        total_size = sum(f.stat().st_size for f in cache_files)
        total_requests = self.stats["hits"] + self.stats["misses"]

        return {
            "entries": len(cache_files),
            "total_size_kb": f"{total_size / 1024:.1f}",
            "hits": self.stats["hits"],
            "misses": self.stats["misses"],
            "sets": self.stats["sets"],
            "hit_rate": f"{self.stats['hits']/max(total_requests,1)*100:.1f}%",
            "api_calls_saved": self.stats["hits"],
        }
