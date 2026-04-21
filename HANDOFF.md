# HANDOFF - Proxima Sessao

> S235 close: security-hygiene ciclo — KBP-28 (frame-bound testing) + CLAUDE.md §CC schema gotchas (timeout units, ask bug, bash -c gap). Commit cb434e6. Moratorium encerrado.

## HYDRATION (obrigatória, 3 passos)

1. Ler este HANDOFF completo.
2. Check APL banner: `QA: N/19 editorial | Proximo: <slide>`.
3. Escolher **UM foco** para a sessão: **(P0)** nova aula de grade, **(P0.5)** QA metanalise, **(P1)** R3 infra.

---

## P0 — Nova aula de grade (totalmente nova)

**Status:** P0 ABSOLUTO pós-pivot S234 Batch 2. **NÃO relacionada** ao legacy `content/aulas/grade/` (58 slides).

- **Brainstorm:** claude.ai (web, ChatGPT-style). Lucas dirige.
- **Implementation:** Claude Code (slides HTML + evidence HTML + QA pipeline).
- **Path livre em `content/aulas/`** (sugestão: `grade-v2/` ou similar). **NÃO editar** `content/aulas/grade/` legacy — referência apenas.
- **Pattern:** seguir `content/aulas/metanalise/` como referência (deck.js + GSAP + OKLCH tokens + manifest + scripts QA em `content/aulas/scripts/`).
- **Start:** criar `content/aulas/<slug>/` + `CLAUDE.md` da aula + estrutura mínima (slides/, evidence/, `_manifest.js`, CSS).

## P0.5 — QA editorial metanalise (paralelo)

16 slides pendentes (s-absoluto → próximos per APL). Scripts: `content/aulas/scripts/gemini-qa3.mjs`. ~½-1 sessão por slide.

## P1 sub — R3 infra + Anki

AnkiConnect addon (Anki Desktop > Tools > Add-ons > 2055492159) → Anki MCP (`npx -y @ankimcp/anki-mcp-server --stdio`) → 2 provas reais em `assets/provas/` + 1 SAP em `assets/sap/` → Anki cards reais (erro log + temas semana).

---

## Âncoras de leitura (read-only se dúvida)

- **BACKLOG:** `.claude/BACKLOG.md` §P0 + §Deferred
- **CHANGELOG recente:** `CHANGELOG.md §Sessao 235` + `§Sessao 234`
- **Aula pattern reference:** `content/aulas/metanalise/` + `content/aulas/CLAUDE.md`

---

## Estado factual

- **Git:** S235b commits `9ef3b78` (security fix shell-within-shell) + docs coherence. S235: `49d9070` (state docs) + `cb434e6` (KBP-28 + CC schema gotchas).
- **Aulas:** metanalise 19 slides (3 editorial done), cirrose 11, grade 58 (legacy, NÃO editar).
- **R3 Clínica Médica:** 224 dias (Dez/2026). Setup infra ainda em 0.

Coautoria: Lucas + Opus 4.7 | S235b security fix + docs coherence | 2026-04-20
