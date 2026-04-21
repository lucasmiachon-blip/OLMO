# HANDOFF - Proxima Sessao

> S236 close: dream+insights combined run + P007/P008/P009 executed + S230 registry reconciled. Commit `6a8ea3a`. Metrics.tsv voltou a coletar dados reais (primeira real-data row desde S223). Memória reindexada (counts corrigidos: KBPs 21→28, agents 10→9, skills 22→18, rules 199→271li, slides 17→19, plans 6/36→2/79).

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
- **CHANGELOG recente:** `CHANGELOG.md §Sessao 236` + `§Sessao 235b`
- **Aula pattern reference:** `content/aulas/metanalise/` + `content/aulas/CLAUDE.md`
- **S236 insights report:** `.claude/skills/insights/references/latest-report.md` (5 proposals P007-P011, 3 executed, 2 deferred com razão)

---

## Estado factual

- **Git:** S236 commit `6a8ea3a` (insights P007/P008/P009 + S230 reconciliation). S235b: `9ef3b78` (security shell-within-shell). S235: `49d9070` + `cb434e6`.
- **Aulas:** metanalise 19 slides (3 editorial done), cirrose 11, grade 58 (legacy, NÃO editar).
- **R3 Clínica Médica:** 223 dias (Dez/2026). Setup infra ainda em 0.
- **Memória:** 19/20 topic files, MEMORY.md reindexed S236.
- **Infra S236:** 9 agents, 18 skills, 30 hooks, 5 rules (271 li), 28 KBPs (next: KBP-30).

Coautoria: Lucas + Opus 4.7 | S236 close + all deliverables shipped | 2026-04-21
