# HANDOFF - Proxima Sessao

> S237 C1: state docs refresh — P0 re-scope para grade-v2 + shared-v2 + qa-pipeline v2 (decisões D2-D8 consolidadas claude.ai madrugada 21/abr). Deadline grade-v2: **30/abr/2026 (T-9d)**. Base commit `2e04cae` (S236 close).

## HYDRATION (obrigatória, 3 passos)

1. Ler este HANDOFF completo.
2. Check APL banner: `QA: N/19 editorial | Proximo: <slide>`.
3. Escolher **UM foco** para a sessão: **(P0)** nova aula de grade, **(P0.5)** QA metanalise, **(P1)** R3 infra.

---

## P0 — grade-v2 sobre shared-v2 (3 subsistemas paralelos)

**Status:** P0 ABSOLUTO. Decisões D2-D8 consolidadas claude.ai madrugada 21/abr. Deadline grade-v2: **30/abr/2026 (T-9d)**. Legacy `content/aulas/grade/` (58 slides) = read-only reference; será arquivada em C2 (branch+tag+rm+.claudeignore).

### P0a — grade-v2 (conteúdo)

- **Path:** `content/aulas/grade-v2/` (greenfield)
- **Alvo:** 15–18 slides, 30–40 min
- **Depende:** P0b shared-v2 Day 1+2 operacional (scaffold em C6; slides ~2/dia a partir de C8)

### P0b — shared-v2 greenfield (infra CSS/JS)

- **Path:** `content/aulas/shared-v2/` (greenfield; `shared/` atual intocada)
- **Stack:** tokens 3-camadas + fluid type cqi + container queries + motion WAAPI + View Transitions + presenter-safe.js
- **Justificativa:** elimina `scaleDeck()` bug por design. Cirrose/metanalise migram de `shared/` para `shared-v2/` pós-30/abr, após validação em grade-v2.
- **Phases:** Day 1 (C4) tokens+layout+motion scaffold; Day 2 (C5) deck-v2 + presenter-safe + reveal-v2 + HDMI ensaio

### P0c — qa-pipeline v2 escalonado (QA)

- **Path:** `content/aulas/scripts/qa-pipeline/` (módulo novo)
- **Gates:** Gate 0 preflight + Gate 1 Flash defects **obrigatórios**; Gate 2 Pro accuracy + Gate 3 Designer visual **skippable por slide** via `--skip-gate2`/`--skip-gate3` se deadline apertar
- **Entrega:** C7 (Gate 0+1); Gate 2+3 skeleton implementados mas opt-in

## P0.5 — QA editorial metanalise (paralelo)

16 slides pendentes (s-absoluto → próximos per APL). Scripts: `content/aulas/scripts/gemini-qa3.mjs` (v1); migra para qa-pipeline v2 assim que P0c Gate 0+1 operacional. ~½-1 sessão por slide.

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

- **Git:** HEAD `2e04cae` (S236 close). S237 C1 pendente commit após este Edit.
- **Aulas:** metanalise 19 slides (3 editorial done), cirrose 11 (intocada em `shared/` atual; migração pós-30/abr após shared-v2 validado em grade-v2), grade-v1 legacy 58 slides (será archived em C2, read-only ref até lá).
- **Deadline grade-v2:** 30/abr/2026 (T-9d).
- **R3 Clínica Médica:** 223 dias (Dez/2026). Setup infra ainda em 0.
- **Memória:** 19/20 topic files, MEMORY.md reindexed S236.
- **Infra S236:** 9 agents, 18 skills, 30 hooks, 5 rules (271 li), 28 KBPs (next: KBP-30).

Coautoria: Lucas + Opus 4.7 | S237 C1 state docs refresh — P0 re-scope grade-v2 + shared-v2 + qa-pipeline v2 | 2026-04-21
