# HANDOFF - Proxima Sessao

> Sessao 32 | 2026-03-31

## ESTADO ATUAL

Monorepo funcional. CI verde. Legacy repos arquivados.

**Python** — ruff clean, mypy OK, 47 testes. Agents scaffolds (~30%), config/safety/routing 100%.

**Aulas** — 4 aulas (deck.js unificado). Metanalise deadline 15/abr (15 dias).
- `metanalise/` — 18 slides, 3/18 QA DONE, 14 LINT-PASS. **Prioridade: retomar QA.**
- `cirrose/` — 44 slides, producao. Pendente: coagulopatia, fix albumina/HDA, cACLD.
- `grade/` — 58 slides, ilegivel (9/10 falham C8). Precisa redesign.
- `shared/` — design system OKLCH + GSAP. Vite: 4100-4102.

**Skills** — 15 skills em `.claude/skills/`, todas SKILL.md (formato oficial).
- Nova: `systematic-debugging` (4 fases, adaptada de superpowers 128K stars)
- `dream-skill` instalada global (~/.claude/skills/dream/), hook Stop ativo, auto-trigger 24h
- Codex plugin completo: CLI v0.118.0 + plugin-cc + auth OK. Commands: `/codex:review`, `/codex:rescue`
- Gap: NotebookLM skill (workflow de estudo)

**Notion** — Calendario DB + Tasks DB (Ultimate Brain) mapeados. Calendario dentro de path Archived (precisa mover).

## PROXIMO

1. **Metanalise QA** — 14 slides restantes (deadline 15/abr)
2. **Notion cleanup** — mover Calendario, criar views Today/Tomorrow, consolidar
3. **Cirrose: migrar conteudo** + feedback pos-aula
4. **NotebookLM skill** — workflow de estudo
5. **Grade readability redesign** — curadoria slide-a-slide

## DECISOES ATIVAS

- CSS: tokens (base.css) + composicao livre por slide. Sem archetypes.
- Skills: formato SKILL.md (oficial), descriptions "pushy" anti-undertrigger.
- Maio/2026: foco total concurso. Abril = housekeeping aulas.
- GSD descartado (dev workflow, nao organizacao). Superpowers: cherry-picked.
- Hooks: 3 ativos projeto (notify, stop-hygiene, stop-notify) + 1 global (dream Stop). Paths absolutos.
- Codex billing: API key pay-per-use (centavos/review). Monitorar em platform.openai.com/usage.
- Dream: Auto Dream oficial (Anthropic) rolling out — dream-skill e ponte. claude-mem descartado.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Grade tem 404 JS errors (recursos faltando).
- Vite: outro projeto deve usar range diferente (ex: 4200+).
- skill-creator scripts excluidos do ruff (codigo externo Anthropic).
- Notion Calendario DB: `collection://308dfe68-59a8-81c2-8d7f-000bf3da6ec4`
- Notion Tasks DB: `collection://2f6dfe68-59a8-81df-943b-000b7f7098cf`

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] BudgetTracker (SQLite, configurado mas inativo)
- [ ] claude-task-master (MCP GTD)
- [ ] Font-size audit cirrose: 12+ valores abaixo 28px threshold
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] daily-briefing: adicionar Notion Calendario + Tasks "Due Today"

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-03-31
