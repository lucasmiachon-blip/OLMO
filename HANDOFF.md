# HANDOFF - Proxima Sessao

> **CONTENT MORATORIUM ACTIVE** (S234 Batch 2 → até §Condições de saída) — meta-work congelado. Foco absoluto = produção.

## HYDRATION (obrigatória, 3 passos)

1. Ler este HANDOFF completo (bloco MORATORIUM abaixo).
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

## REGRA DURA — Commits só tocam

- `content/aulas/**`, `assets/provas/`, `assets/sap/`, Anki files.
- `HANDOFF.md` + `CHANGELOG.md` + `.claude/BACKLOG.md` (wrap obrigatório).

## NÃO TOCAR (durante moratorium)

`.claude/agents/`, `.claude/skills/`, `.claude/hooks/`, `.claude/rules/`, `config/`, `docs/`, `pyproject.toml`, `CLAUDE.md`, `README.md`.

Drift canonical detectado durante content work → anotar 1 linha em `.claude/BACKLOG.md §MORATORIUM-DEFERRED`; **NÃO corrigir**.

## Condições de saída do moratorium (UMA basta)

- (a) QA editorial metanalise = 19/19 (zerou).
- (b) R3 infra ativo: AnkiConnect + Anki MCP + 2 provas classificadas + ≥10 Anki cards rodando spaced rep real.
- (c) Lucas declara fim com rationale de bloqueio real (não "seria legal corrigir").

## Âncoras de leitura (read-only se dúvida)

- **Plano âncora:** `.claude/plans/S234-content-moratorium-active.md`
- **BACKLOG:** `.claude/BACKLOG.md` §P0 + §MORATORIUM-DEFERRED
- **CHANGELOG recente:** `CHANGELOG.md §Sessao 234` + `§Sessao 233`
- **Aula pattern reference:** `content/aulas/metanalise/` + `content/aulas/CLAUDE.md`

---

## Estado factual

- **Git:** last commit `beab5f6` (S234 batch 1 doc-hygiene). Batch 2 = moratorium kickoff (próximo commit desta sessão).
- **Aulas:** metanalise 19 slides (3 editorial done), cirrose 11, grade 58 (legacy, NÃO editar).
- **R3 Clínica Médica:** 224 dias (Dez/2026). Setup infra ainda em 0.

Coautoria: Lucas + Opus 4.7 | S234 Batch 2 moratorium kickoff | 2026-04-20
