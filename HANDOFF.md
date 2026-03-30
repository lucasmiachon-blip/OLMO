# HANDOFF - Proxima Sessao

> Sessao 24 | 2026-03-29

## ESTADO ATUAL

Monorepo funcional. 2 subsistemas validados end-to-end:

**Python** — CI verde: ruff clean, mypy OK, 47 testes passando. Agents sao scaffolds (~30% implementados), config/safety/routing 100%.

**Aulas** — 2 aulas live em deck.js unificado:
- `cirrose/` — 44 slides, GSAP animacoes, case-panel, assertion-evidence. Producao. Lint clean.
- `grade/` — 58 slides, migrada de Reveal.js→deck.js (sessao 24). **QA diagnosticou ilegibilidade: 9/10 slides falham C8 (font <18px a 5m). Precisa redesign.**
- `shared/` — promovido para `content/aulas/shared/` (design system, deck.js, engine.js, fonts). Ambas aulas compartilham.
- Infra: npm install OK (229 pkgs), vite dev :3000, build PowerShell, lint-slides clean.

**Concurso R3 Clinica Medica** — Mapeado, nao iniciado. Anki MCP pesquisado (v0.15.0, 18 tools), config pronta em servers.json. Falta: instalar AnkiConnect + colocar provas.

## PROXIMO

1. **Grade readability redesign** — Curadoria slide-a-slide: reduzir texto, aumentar fontes, quebrar slides densos. Rodar `npm run qa:screenshots:grade` apos cada batch para validar progresso.
2. **Anki MCP setup** — Instalar AnkiConnect (add-on 2055492159) + configurar MCP
3. **Provas + SAPs em assets/** — Lucas coloca PDFs de bancas R3 e MKSAP
4. **Trazer metanalise/osteoporose** — Mesmo pattern da grade (copiar de aulas-magnas, rewrite template)

## DECISOES ATIVAS

- Abril/2026: foco total concurso. Ate la, 2 frentes (aulas + concurso).
- Engine unificado: deck.js (nao Reveal.js). Toda aula nova usa o mesmo template pattern.
- STRATEGY.md fase 1 (CSS @layer) adiada ate grade estar legivel.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — Lucas roda dev server em paralelo. Matar por PID especifico.
- Grade tem 404 JS errors (recursos faltando) — investigar na sessao de redesign.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] BudgetTracker (SQLite, configurado mas inativo)
- [ ] claude-task-master (MCP GTD)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-03-29
