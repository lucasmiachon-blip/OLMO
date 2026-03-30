# HANDOFF - Proxima Sessao

> Sessao 27 | 2026-03-29

## ESTADO ATUAL

Monorepo funcional. Arvore limpa (5 stubs removidos, paths fixados, TREE.md criado). CI verde.

**Python** — ruff clean, mypy OK, 47 testes. Agents scaffolds (~30%), config/safety/routing 100%.

**Aulas** — 2 aulas live (deck.js unificado):
- `cirrose/` — 44 slides, producao, lint clean. 7 reference docs cross-linked.
- `grade/` — 58 slides, ilegivel (9/10 falham C8). Precisa redesign.
- `shared/` — design system compartilhado. Vite: cirrose=4100, grade=4101 (strictPort).

**Concurso R3 dez/2026** — Pipeline desenhado, nao iniciado. Anki MCP config pronta, falta instalar.

## PROXIMO

1. **Grade readability redesign** — Curadoria slide-a-slide. QA: `npm run qa:screenshots:grade`.
2. **Resgatar metanalise** — Branch `feat/metanalise-mvp` (wt-metanalise). 18 slides deck.js.
3. **Anki MCP setup** — AnkiConnect (add-on 2055492159) + validar MCP.

## DECISOES ATIVAS

- Maio/2026: foco total concurso. Abril = housekeeping aulas + preparar terreno.
- Osteoporose congelada (70 slides Reveal.js, repo aulas-magnas). Decidir formato.
- Engine: deck.js. STRATEGY.md fase 1 adiada ate grade legivel.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Grade tem 404 JS errors (recursos faltando).
- Vite: outro projeto deve usar range diferente (ex: 4200+) para evitar colisao.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] BudgetTracker (SQLite, configurado mas inativo)
- [ ] claude-task-master (MCP GTD)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-03-29
