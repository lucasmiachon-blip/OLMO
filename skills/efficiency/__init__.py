"""Efficiency Skills - Otimizacao de uso de API e recursos."""

from skills.efficiency.batch_processor import BatchProcessorSkill
from skills.efficiency.local_first import LocalFirstSkill
from skills.efficiency.response_cache import ResponseCacheSkill

__all__ = ["BatchProcessorSkill", "LocalFirstSkill", "ResponseCacheSkill"]
