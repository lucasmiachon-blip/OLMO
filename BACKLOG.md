# BACKLOG — Proxima Semana+

> Items para resolver na proxima semana ou adiante. Nao urgente.
> Cross-ref: `HANDOFF.md` (sessao imediata) | `CHANGELOG.md` (historico)

## Semana 1 (07-11 Abr)

### Security
- [ ] SEC-004: Pinnar versoes MCP servers em config/mcp/servers.json (npx sem versao = supply chain risk)

### Agent Hardening
- [ ] quality-gate: criar JS/CSS lint scripts (unico agente FROZEN)

### Dead Code Cleanup
- [x] qa-video.js: removido S83 (`d7bb0cc`)
- [ ] evidence-db.md (cirrose): migrar para living HTML ou remover

## Semana 2+ (backlog longo)

### Tooling
- [ ] Obsidian CLI integration
- [ ] Google Drive MCP (OAuth credentials)
- [ ] Presenter.js rewrite (nao funciona com deck.js)
- [ ] Anki MCP setup (spaced repetition para concurso)

### Low Priority
- [ ] SEC-005: CHATGPT_MCP_URL validacao (server `planned`, non-issue ate connect)

### Agent Hardening (da pesquisa best practices S83)
- [ ] Agent model routing: evidence-researcher→sonnet, reference-checker→haiku, notion-ops→haiku
- [ ] PreCompact hook migration (pre-compact-checkpoint.sh de Stop → PreCompact)
- [ ] Agent memory: project para qa-engineer e reference-checker
- [ ] context: fork em skills pesadas (/research, /medical-researcher, /deep-search)

## Research Outputs (S82-S83, acionaveis incorporados ao implementation-plan)

5 pesquisas completas. Items acionaveis movidos para `docs/research/implementation-plan-S82.md` Tier 1.
- `docs/research/anti-drift-tools-2026.md` (449 linhas)
- `docs/research/agent-self-improvement-2026.md` (811 linhas)
- `docs/research/claude-md-best-practices-2026.md` (414 linhas)
- `docs/research/memory-best-practices-2026.md` (736 linhas)
- `docs/research/claude-code-best-practices-2026.md` (1076 linhas)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-06
