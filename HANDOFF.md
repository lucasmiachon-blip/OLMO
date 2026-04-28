# HANDOFF - Proxima sessao (S272)

> Reidrate por este arquivo primeiro. Nao leia `CHANGELOG.md` nem planos longos no inicio; use grep/range so quando a lane for escolhida.

## 0. Estado para reidratar em 90s

1. Rode `git status --short`.
2. Leia `.claude/context-essentials.md`.
3. Escolha UMA lane abaixo com Lucas.
4. Abra apenas o plano da lane escolhida, por secao/grep, nao inteiro.

**S271 closed** — audit governance loop fechado mecânicamente (5 commits S270+S271). Plans archived: `.claude/plans/archive/S270-audit-adversarial-15-findings.md` + `.claude/plans/archive/S271-audit-fix-criticos.md`. Stop[1] hook ativo aguarda soak test S272+. Catalog `.claude/CATALOG.md`: 6 `candidate-delete` skills (skill-creator/improve/automation/docs-audit/knowledge-ingest/nlm-skill) revisar S275-280 1-a-1 (audit §8 bulk delete proibido). Histórico completo: `CHANGELOG.md §S271`. Defer próximo audit pass: M1+M2+M3+B1+B3 (M4 já endereçado).

## 1. Lane A - Metanalise QA editorial

Triggers: "slides", "metanalise", "forest", "quality", "QA". Fonte: `content/aulas/metanalise/HANDOFF.md`. Plano: `.claude/plans/curious-enchanting-tarjan.md`.
Estado: `s-quality` DONE (S265 Phase A); pendentes `s-forest1`+`s-forest2` Phases B-G; `s-contrato` DEFERRED. Regra: 1 slide × 1 gate × 1 invocação (nunca batch).
Build/QA: `npm --prefix content/aulas run build:metanalise && node content/aulas/scripts/gemini-qa3.mjs --aula metanalise --slide {id} --inspect`.

## 2. Lane B - Research D-lite

Triggers: "research", "pernas", "D-lite", "agents vs scripts", "migrar .mjs". Reidratação: `docs/research/S269-dlite-rehydration.md` (open-gaps incluem Gemini 429, Opus triage, DOI verifier, cost matrix). Plano: `.claude/plans/sleepy-wandering-firefly.md` (apenas §S264.c + §S265 carryover).
Estado: KEEP-SEPARATE provisional; `.mjs` Gemini/Perplexity = hot path canônico; `codex-xhigh-researcher` thin-agent canônico Codex; D-lite agents/runner paralelos experimentais.
Gate: `node scripts/smoke/research-dlite-contract.mjs`.

## 3. Lane C - Infra / auditoria

Triggers: "auditoria", "hardening", "gate", "harness", "seguranca", "integrity". Relatório S267: `docs/audit/codex-adversarial-audit-S267.md`. Audit S270 fechado: `.claude/plans/archive/S270-audit-adversarial-15-findings.md` (15 findings: 10 closed S271 + 5 deferred M1+M2+M3+B1+B3).
Estado: residual M1 pytest nominal (remover ou smoke mínimo); opcional `bash content/aulas/scripts/install-hooks.sh` para `.git/hooks/pre-push` local.

## 4. Roadmap constante

Now:
- `[S267/S268 P0 metanalise]` `.claude/plans/curious-enchanting-tarjan.md` - s-forest1/s-forest2.
- `[S269 P0 D-lite]` `docs/research/sota-S269-agents-subagents-contract.md` + `.claude/scripts/research-dlite-runner.mjs` - local smoke PASS; next = optional live smoke/re-bench.
- `[P1 BACKGROUND]` `.claude/plans/immutable-gliding-galaxy.md` - referencia, nao abrir no start.
- `[S272+ soak test]` Stop[1] prompt hook validar tier-S Pre-mortem detection + scope-extension `[budget]` em uso real; calibrar prompt prose se false-positive recorrente.
- `[S275-280 catalog review]` `.claude/CATALOG.md` 6 `candidate-delete` skills decisão 1-a-1 com Lucas; bulk delete proibido (audit S270 §8).

Next:
- Lane B: quando Gemini quota voltar, rodar re-bench cost-gated Gemini/Perplexity/Codex em >=6 emits; comparar contra `.mjs`; promover D-lite so se thresholds do contrato passarem.
- Infra Lane C residual: M1 pytest nominal; opcional instalar hook local `pre-push`.

Later:
- Phases 6-8 master plan apos D-lite decision lock.
- Archived S268: `concurrent-nibbling-teacup.md`, `wobbly-foraging-pelican.md`, `S262-research-mjs-additive-migration.md`, `splendid-munching-swing.md`.

## 5. Regras de contexto

- `HANDOFF.md` + `.claude/context-essentials.md` sao suficientes para start.
- `CHANGELOG.md` e planos longos entram apenas por `rg -n "termo" arquivo`.
- Antes de editar state files: `git status --short`; se houver mudanca alheia, trabalhar com ela, nao reverter.
- Codex/Gemini default read-only no AGENTS; editar apenas quando Lucas aprovar escopo no thread atual.
