# HANDOFF - Proxima Sessao

> Sessao 26 | 2026-03-29

## ESTADO ATUAL

Monorepo funcional. Hardening documental completo (sessao 26). Vite isolado por porta.

**Python** — CI verde: ruff clean, mypy OK, 47 testes. Agents scaffolds (~30%), config/safety/routing 100%.

**Aulas** — 2 aulas live (deck.js unificado):
- `cirrose/` — 44 slides, producao, lint clean. 7 reference docs cross-linked.
- `grade/` — 58 slides, ilegivel (9/10 falham C8). Precisa redesign.
- `shared/` — design system compartilhado. Vite: cirrose=4100, grade=4101 (strictPort).

**Concurso R3 dez/2026** — Pipeline desenhado, nao iniciado. Anki MCP config pronta, falta instalar.

## PROXIMO

1. **Grade readability redesign** — Curadoria slide-a-slide. QA: `npm run qa:screenshots:grade`.
2. **Resgatar metanalise** — Worktree perdida em aulas_magnas. Localizar e importar.
3. **Anki MCP setup** — AnkiConnect (add-on 2055492159) + validar MCP.
4. **Scripts Python: path stale** — `atualizar_tema.py`, `knowledge_organizer.py`, `workflows.yaml` referenciam `03-Resources/`.

## DECISOES ATIVAS

- Maio/2026: foco total concurso. Abril = housekeeping aulas + preparar terreno.
- Osteoporose congelada. Metanalise entra em breve.
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
