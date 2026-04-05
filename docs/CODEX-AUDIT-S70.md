# Codex Adversarial Audit — S70

> 2026-04-04 | 3 batches: root+docs, rules+agents, aulas
> Total: 6 HIGH, 39 MEDIUM, 6 LOW

## Batch 1: Root + docs/

### HIGH (3)
1. `docs/GETTING_STARTED.md` L18: `cd organizacao` — repo renomeado para OLMO
2. `docs/OBSIDIAN_CLI_PLAN.md` L42,45: `scripts\obsidian.cmd` nao existe
3. `docs/OBSIDIAN_CLI_PLAN.md` L68,88,129: hardcodes `C:\Dev\Projetos\Organizacao...` — stale apos rename

### MEDIUM (31)
| # | Arquivo | Linha(s) | Problema |
|---|---------|----------|----------|
| 1 | CHANGELOG.md | 165,254,266 | Refs a `docs/CODEX-MEMORY-AUDIT-S61.md`, `CODEX-FIXES-S58.md`, `CODEX-AUDIT-S57.md` — movidos para `.archive/` |
| 2 | CHANGELOG.md | 717,794 | Refs a `docs/CODEX-REVIEW-S37.md`, `CODEX-REVIEW-S33.md` — nao existem |
| 3 | docs/ARCHITECTURE.md | 100,102 | MCP block stale: Gemini marcado `removed`, contagem nao bate |
| 4 | docs/ARCHITECTURE.md | 124 | Diz 14 skills — atual: 20 |
| 5 | docs/ARCHITECTURE.md | 172-176 | Inventario .claude/ stale: rules 9 (nao 8), skills 20 (nao 14), agents 10 (nao 4) |
| 6 | docs/ARCHITECTURE.md | 195 | Diz cirrose 44 slides producao — atual: 11 ativos + 35 archived |
| 7 | docs/TREE.md | 87 | cirrose/_archive/ diz 33 — atual: 35 |
| 8 | docs/TREE.md | 144 | Diz 47 testes — atual: 53 |
| 9 | docs/TREE.md | 162 | `docs/BEST_PRACTICES.md` movido para `.archive/` |
| 10 | docs/TREE.md | 179,180 | agents/ diz 7 (atual: 10), lista `literature.md` que nao existe |
| 11 | docs/TREE.md | 185 | hooks/ diz 7 — atual: 9 |
| 12 | docs/TREE.md | 187 | Lista `efficiency.md`, `quality.md` — ambos removidos |
| 13 | docs/SYNC-NOTION-REPO.md | 4,38,41 | Ref `evidence-db.md` sem path completo |
| 14 | docs/SYNC-NOTION-REPO.md | 12-17 | Paths `cirrose/references/...` sem `content/aulas/` prefix |
| 15 | docs/SYNC-NOTION-REPO.md | 42,51,57 | Ref `must-read-trials.md` — nao existe na raiz |
| 16 | docs/GETTING_STARTED.md | 35,38,40 | MCP inventory stale (Gemini como connected) |
| 17 | docs/GETTING_STARTED.md | 82 | Ref `data/extracted/` — nao existe |
| 18 | docs/GETTING_STARTED.md | 88-90 | Tree usa `organizacao/`, CLAUDE.md ~74 lines stale |
| 19 | docs/GETTING_STARTED.md | 108 | cirrose 44 slides stale |
| 20 | docs/GETTING_STARTED.md | 114-116 | .claude/ counts stale, `literature` agent nao existe |
| 21 | docs/CHANGELOG-archive.md | 21 | `grade/scripts/qa-batch-screenshot.mjs` sem `content/aulas/` |
| 22 | docs/CHANGELOG-archive.md | 115 | `config/keys/keys_setup.md` — real: `docs/keys_setup.md` |
| 23 | docs/keys_setup.md | 3,12,16 | Gemini MCP listado como ativo — marcado `removed` |
| 24 | docs/S63-AUDIT-REPORT.md | 223,232,238,239 | Refs a `.claude/tmp/codex-round2*.md` — nao existem |
| 25 | docs/aulas/css-error-codes.md | 3 | `docs/prompts/error-digest.md` — dir nao existe |
| 26 | docs/aulas/css-error-codes.md | 4 | `aulas/cirrose/ERROR-LOG.md` sem `content/` prefix |
| 27 | docs/aulas/HARDENING-SCRIPTS.md | 187 | `docs/prompts/gemini-gate0-inspector.md` — nao existe |
| 28 | docs/aulas/HARDENING-SCRIPTS.md | 580 | `docs/prompts/gemini-gate4-editorial.md` — nao existe |

### LOW (5)
| # | Arquivo | Problema |
|---|---------|----------|
| 1 | CHANGELOG.md L401,414 | Refs a `ADVERSARIAL-FIX-S51.md`, `ADVERSARIAL-REVIEW-S50.md` — nao existem |
| 2 | CHANGELOG.md L806 | Ref a `~/.claude/skills/dream/` — path nao verificavel |
| 3 | docs/TREE.md L13 | CHANGELOG.md duplicado no tree |
| 4 | docs/CHANGELOG-archive.md L106 | Refs a `apps/api/`, `apps/web/`, `content/blog/` — scaffold removido |
| 5 | docs/CHANGELOG-archive.md L210 | Ref a `.claude/skills/teaching-improvement/` removido |

---

## Batch 2: .claude/rules/ + .claude/agents/

### HIGH (3)
1. `qa-pipeline.md` L69-93: paths `narrative.md`/`evidence-db.md` apontam raiz da aula — deveria ser `references/`
2. `reference-checker.md` L30: `{aula}/evidence-db.md` → `{aula}/references/evidence-db.md`
3. `qa-engineer.md` L52-54: `browser_click`/`browser_console_messages` nao nas permissoes settings.local.json

### MEDIUM (8)
| # | Arquivo | Problema |
|---|---------|----------|
| 1 | slide-rules.md L114 | `shared/js/deck.js` → `content/aulas/shared/js/deck.js` |
| 2 | qa-pipeline.md L48,85 | Ref a `WT-OPERATING.md` (removido S69) |
| 3 | qa-pipeline.md L100 | Ref a `metanalise/NOTES.md` (removido S69) |
| 4 | design-reference.md L65 | Contradicao: living HTML vs evidence-db.md |
| 5 | qa-engineer.md L33 | `cirrose/HANDOFF.md` → `HANDOFF-CIRROSE.md` |
| 6 | qa-engineer.md L70 | `{aula}/CLAUDE.md` nao existe para cirrose |
| 7 | qa-engineer.md L96,181 | paths `narrative.md` sem `references/` |
| 8 | medical-researcher.md L182 | Output target evidence-db.md contradiz living HTML |

### LOW (1)
| # | Arquivo | Problema |
|---|---------|----------|
| 1 | qa-engineer.md L164 | `AUDIT-VISUAL.md` so existe para cirrose |

## Batch 3: content/aulas/

Despachado ao Codex mas nao retornou findings concretos. Re-rodar se necessario.

---
Coautoria: Lucas + Opus 4.6 (orquestrador) + Codex (adversarial) | 2026-04-04
