# HANDOFF - Proxima Sessao

> Sessao 30 | 2026-03-31

## ESTADO ATUAL

Monorepo funcional. CI verde. Legacy repos arquivados.

**Python** — ruff clean, mypy OK, 47 testes. Agents scaffolds (~30%), config/safety/routing 100%.

**Aulas** — 4 aulas (deck.js unificado):
- `cirrose/` — 44 slides, producao. Pendente: coagulopatia, fix albumina/HDA, cACLD.
- `metanalise/` — 18 slides, 3/18 QA DONE, 14 LINT-PASS.
- `grade/` — 58 slides, ilegivel (9/10 falham C8). Precisa redesign.
- `osteoporose/` — 70 slides Reveal.js em legacy/. Frozen. Decidir formato.
- `shared/` — design system OKLCH + GSAP + decision-protocol + coautoria. Vite: 4100-4102.

**Skills** — 18 skills em `.claude/skills/`:
- `skill-creator` — versao oficial Anthropic (com eval pipeline, benchmark scripts)
- `slide-authoring` — nova, 65 linhas + patterns.md (Assertion-Evidence, deck.js)
- 16 existentes (muitas aspiracionais, auditoria pendente)

**Concurso R3 dez/2026** — Pipeline desenhado, nao iniciado.

## PROXIMO

1. **Auditar 16 skills existentes** — podar redundantes, refinar uteis, padronizar formato SKILL.md
2. **Cirrose: migrar conteudo** + feedback pos-aula (coagulopatia, albumina/HDA)
3. **Metanalise QA** — QA restantes (14 slides)
4. **Grade readability redesign** — curadoria slide-a-slide
5. **claude-mem install** — sessao dedicada (pesado, 6 hooks, worker service)

## DECISOES ATIVAS

- CSS: tokens (base.css) + composicao livre por slide. Sem archetypes.
- Skills: formato SKILL.md (oficial), descriptions "pushy" anti-undertrigger.
- Maio/2026: foco total concurso. Abril = housekeeping aulas.
- Engine: deck.js. STRATEGY.md fase 1 adiada ate grade legivel.
- Hooks: 3 ativos (notify, stop-hygiene, stop-notify). Paths absolutos.
- claude-mem: avaliado (44K stars), instalar em sessao dedicada.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Grade tem 404 JS errors (recursos faltando).
- Vite: outro projeto deve usar range diferente (ex: 4200+).
- Hooks usam paths absolutos — funciona independente do CWD.
- skill-creator scripts excluidos do ruff (codigo externo Anthropic).

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] BudgetTracker (SQLite, configurado mas inativo)
- [ ] claude-task-master (MCP GTD)
- [ ] Font-size audit cirrose: 12+ valores abaixo 28px threshold
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-03-31
