# Ecosystem Study — S115

**Data**: 2026-04-08
**Objetivo**: Gap analysis OLMO vs Claude Code ecosystem
**Base**: raw study pre ADR-0001 + pesquisa repos (snapshot 2026-04-08)
**Coautoria**: Lucas + Opus 4.6

---

## Summary

OLMO is ahead of the ecosystem on hooks (34 vs 5-10 typical), memory governance (wiki-index + Dream), and adversarial review. Main gaps: skill descriptions lack MANDATORY TRIGGERS, no formal skill evals, no progressive disclosure (resources/).

## Gap Table

| # | Gap | Current | Target | Priority | Effort |
|---|-----|---------|--------|----------|--------|
| 1 | MANDATORY TRIGGERS in skill descriptions | Narrative descriptions | Explicit keywords in description field | High | Low |
| 2 | Skill evaluation suite | No formal testing | 3-5 trigger + 2-3 anti-trigger prompts per skill | Medium | Medium |
| 3 | Trail of Bits security patterns | /review + sentinel | Structured OWASP skill from ToB patterns | Medium | Low |
| 4 | Progressive disclosure (resources/) | SKILL.md only | resources/ dir for templates and examples | Medium | Low |

## Where OLMO Leads

- **Hooks**: 34 registrations, 6 event types, guards + proactive + chaos + circuit breaker
- **Memory governance**: 20-file cap, wiki-index with "Load when" triggers, Dream consolidation
- **Adversarial review**: 3-leg parallel (sentinel + 2 general-purpose), KBP system
- **Multi-window**: Worker mode with guard-worker-write hook (tested, functional). Worktree isolation evaluated and deferred — current system is simpler and safer for read-only workers.
- **Self-healing**: stop-detect-issues + pending-fixes + session-start surfacing

## Actionable Items (prioritized)

### Quick wins (this session or next)
1. **MANDATORY TRIGGERS**: Add keyword triggers to top 5 skills descriptions
2. **Progressive disclosure audit**: Check which SKILL.md files >300 lines need resources/

### Near-term (S116-S118)
3. **Skill eval prompts**: Create test matrix for 5 most-used skills
4. **Trail of Bits patterns**: WebSearch + extract for /review hardening

### Future (S120+)
5. **Vector memory**: Only if wiki exceeds 40 files or retrieval accuracy drops

## Repos Studied

| Repo | Stars | Key Pattern |
|------|-------|-------------|
| anthropics/skills | ~113k | Official skill structure, marketplace |
| awesome-claude-code-toolkit | — | 135 agents, 35 skills catalog |
| awesome-claude-code | ~37k | Community curation, ToB security |
| VoltAgent/awesome-agent-skills | — | 1000+ cross-tool skills |

## Decisions

- **Worktree isolation**: Evaluated, DEFERRED. Current worker-mode (read-only + flag + hook guard) is simpler, safer, and sufficient. Worktree adds branch management complexity without clear benefit for read-only workers.
- **MANDATORY TRIGGERS**: Implement now — low effort, high trigger accuracy improvement.
- **Plugin marketplace**: Defer — single-project, no cross-project reuse needed.
- **Vector memory**: Explicitly NOT needed at 20 files — wiki-index is sufficient.
