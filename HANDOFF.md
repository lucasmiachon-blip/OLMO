# HANDOFF - Proxima Sessao

> Sessao 29 | 2026-03-31

## ESTADO ATUAL

Monorepo funcional. CI verde. Legacy repos arquivados.

**Python** — ruff clean, mypy OK, 47 testes. Agents scaffolds (~30%), config/safety/routing 100%.

**Aulas** — 3 aulas live (deck.js unificado):
- `cirrose/` — 44 slides, producao. Aula dada 2026-03-31 (feedback em NOTES.md). Pendente: coagulopatia, fix albumina/HDA.
- `metanalise/` — 18 slides, lint clean, server OK. 3/18 QA DONE, 14 LINT-PASS.
- `grade/` — 58 slides, ilegivel (9/10 falham C8). Precisa redesign.
- `shared/` — design system + GSAP + Lottie + D3 + decision-protocol + coautoria. Vite: 4100/4101/4102.
- `presenter.js` criado mas NAO integrado — precisa reescrever (HTML separado, timer fix).

**Concurso R3 dez/2026** — Pipeline desenhado, nao iniciado.

**Legacy** — `aulas-magnas` e `wt-metanalise` movidos para `/c/Dev/Projetos/legacy/`. Licoes extraidas para slide-rules.md e ERROR-LOG.md.

## PROXIMO

1. **Cirrose: migrar conteudo completo** de legacy/aulas-magnas + incorporar feedback pos-aula (coagulopatia, albumina/HDA, cACLD).
2. **Metanalise QA** — QA s-checkpoint-1 (screenshots + scorecard 14-dim), depois 14 restantes.
3. **Grade readability redesign** — Curadoria slide-a-slide.
4. **Presenter.js rewrite** — Separar HTML, corrigir timer, corrigir async import.
5. **Anki MCP setup** — AnkiConnect (add-on 2055492159) + validar MCP.

## DECISOES ATIVAS

- CSS: tokens (base.css) + composicao livre por slide. Sem archetypes.
- Maio/2026: foco total concurso. Abril = housekeeping aulas.
- Engine: deck.js. STRATEGY.md fase 1 adiada ate grade legivel.
- Hooks: 3 ativos (notify, stop-hygiene, stop-notify). Paths absolutos.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Grade tem 404 JS errors (recursos faltando).
- Vite: outro projeto deve usar range diferente (ex: 4200+).
- Hooks usam paths absolutos — funciona independente do CWD.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] BudgetTracker (SQLite, configurado mas inativo)
- [ ] claude-task-master (MCP GTD)
- [ ] Osteoporose (70 slides Reveal.js, em legacy/aulas-magnas). Decidir formato.
- [ ] Font-size audit cirrose: 12+ valores abaixo 28px threshold

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-03-31
