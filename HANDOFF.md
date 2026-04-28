# HANDOFF - Proxima sessao (S269)

> Reidrate por este arquivo primeiro. Nao leia `CHANGELOG.md` nem planos longos no inicio; use grep/range so quando a lane for escolhida.

## 0. Estado para reidratar em 90s

1. Rode `git status --short`.
2. Leia `.claude/context-essentials.md`.
3. Escolha UMA lane abaixo com Lucas.
4. Abra apenas o plano da lane escolhida, por secao/grep, nao inteiro.

Estado local conhecido deste handoff:
- S269 Lane B: Research Agent Contract criado; D-lite novo adicionado sem deletar legado (`research-dlite-runner.mjs`, `gemini-dlite-research`, `perplexity-dlite-research`, smoke `research-dlite-contract.mjs`). Smoke local PASS.
- S269 live smoke: Perplexity D-lite PASS com JSON valido + NCBI 2/2 PMIDs; Codex xhigh PASS via `--validate-file --verify-pmids` + NCBI 4/4 PMIDs; Gemini bloqueado por `429 RESOURCE_EXHAUSTED` depois de uma falha anterior por JSON truncado.
- S269 correction: D-lite agora e capture-first. Novo schema `.claude/schemas/research-candidate-set.json` preserva recall/novelty dos scripts antigos antes de triagem Opus/MCP. Codex/ChatGPT-5.5 xhigh e perna #7 explicita para captura cross-family e validacao critica.
- S269 Lane D `s269-document-conversion`: skill `.claude/skills/document-conversion/` criado (Pandoc 3.9.0.2 + xelatex MiKTeX 25.12 / Docling 2.91.0 / Calibre 9.7.0). EPUB Fletcher Epidemiologia 6ed → PDF 372pp/22.6MB A4 (~/Downloads, fora git por copyright). Docling em venv isolado `~/.venvs/document-conversion/` via uv 0.11.8 (pip-audit clean). Pandoc `--sandbox` default mitigation CVE-2025-51591. Plan `.claude/plans/toasty-greeting-crown.md`, case `examples/fletcher-epidemiologia-2026-04-27.md`.
- S268 fechado: EC loop expandido, C1 guard-write fix, docs hygiene + plan archive.
- S268 follow-up Lane C: C2/A1/A2 corrigidos; `done:cirrose:strict` existe, `pre-push.sh` versionado existe, `done-gate.js` funciona no Windows, hooks LF/syntax passam e `tools/integrity.sh` PASS 0 violations.
- `.claude/statusline.sh` modificado em S267: adiciona barras de contexto e cota para Claude Code.
- `C:\Users\lucas\.codex\config.toml` global atualizado fora do repo: `status_line = ["model-name", "context-used", "five-hour-limit", "weekly-limit", "used-tokens"]`; backup `config.toml.bak-statusline-20260427-211428`.
- `.claude/.research-tmp/` existe como temp local ignorado; substrate canonico de bench fica em `.claude/.parallel-runs/2026-04-27-ma-types/`.
- Codex CLI local: `@openai/codex@0.125.0`; statusline aceita lista de strings, nao array de objetos.
- EC loop master: `.claude/rules/anti-drift.md §EC loop`. Fork vivo: `AGENTS.md` (Codex/Gemini cross-CLI). Pointers: `CLAUDE.md` ENFORCEMENT #7, `.claude/context-essentials.md`.
- Audit adversarial S270 done: 15 findings em `.claude/plans/snazzy-purring-dream.md` (1 CRITICO L3 Mermaid `fill:#2ecc71` mente vs texto NOT IMPL; 7 ALTO incl. subagent count drift 21/19/19, EC loop body 5x sem master, Pre-mortem 0 aplicacoes em 10 sessoes, `[budget]` gate 0 hits, broken refs KBP-06/15 → `feedback_*.md` ausentes, HANDOFF 109 li vs cap 50, catalog inflation 13/19 skills + 11/21 agents zero-use 27d). Top action 30s = `ARCHITECTURE.md:99` `fill:#2ecc71` → `#95a5a6` + `[NOT IMPL]`.
- S271 audit-fix done: C1 Mermaid L3 cinza `#95a5a6` + `[NOT IMPL]` label; A1 counts 21/19 sync (README/ARCHITECTURE); A2 EC loop master `anti-drift.md §EC loop` + 3 pointers (CLAUDE/HANDOFF/context-essentials) + 1 fork header (AGENTS); A5 KBP-06/15 redirecionados para anti-drift sections (broken refs eliminadas; `~/.claude/memory/` confirmado inexistente); B2 `(16 agents pendentes)` removido. **INV-4 count-integrity** adicionado em `tools/integrity.sh` (Stop[5] valida FS=21/19 vs declarative claims em CLAUDE/README/ARCHITECTURE — previne Cenário 1 do pre-mortem). Plan: `.claude/plans/elegant-crafting-marshmallow.md`. Defer governance: A3 Pre-mortem aplicar/downgrade, A4 `[budget]` aplicar/downgrade, A6 HANDOFF cap, A7 catalog inflation triage.

## 1. Lane A - Metanalise QA editorial

Quando Lucas disser "slides", "metanalise", "forest", "quality" ou "QA".

Fonte curta: `content/aulas/metanalise/HANDOFF.md`.
Plano de execucao: `.claude/plans/curious-enchanting-tarjan.md`.

Estado:
- `s-quality` DONE apos S265 Phase A: wrapper `.term-content-block`, contraste ajustado, lint+build PASS.
- Pendentes reais: `s-forest1` e `s-forest2` Phases B-G.
- `s-contrato` R11=5.9 segue REOPEN, mas esta DEFERRED.
- Regra: 1 slide x 1 gate x 1 invocacao; nao batch.

Comandos minimos:
```bash
npm --prefix content/aulas run build:metanalise
node content/aulas/scripts/lint-slides.js metanalise
node content/aulas/scripts/gemini-qa3.mjs --aula metanalise --slide {id} --inspect
```

## 2. Lane B - Research D-lite / migracao .mjs vs agents

Quando Lucas disser "research", "pernas", "D-lite", "agents vs scripts" ou "migrar .mjs".

Reidratacao completa da lane: `docs/research/S269-dlite-rehydration.md` (ler antes de editar runner/agents/skill).
Plano de execucao: `.claude/plans/sleepy-wandering-firefly.md` somente secoes `S264.c` e `S265 carryover`.

Estado:
- Decisao atual: KEEP-SEPARATE provisional.
- `.mjs` Gemini/Perplexity = hot path canonico empirico (9/9 emits).
- `codex-xhigh-researcher` = thin-agent canonico para Codex.
- `gemini-deep-research` e `perplexity-sonar-research` = EXPERIMENTAL legado; nao deletar.
- S269 D-lite novo = thin runner + agents paralelos: `.claude/scripts/research-dlite-runner.mjs`, `.claude/agents/gemini-dlite-research.md`, `.claude/agents/perplexity-dlite-research.md`.
- Runner agora tem `--verify-pmids` e `--validate-file` para separar descoberta livre de confirmacao rigorosa e incluir a perna Codex no mesmo boundary.
- Runner default = `--output-kind candidates` para capturar muitos candidatos Tier 1/livros/guidelines/landmark trials/SOTA; `--output-kind final` so depois da triagem/verificacao.
- Contrato profissional: `docs/research/sota-S269-agents-subagents-contract.md` inclui diagrama ASCII + comparison plan legacy `.mjs` vs D-lite.
- Gaps principais resumidos: Gemini API 429/quota; sem candidate-first live re-bench; sem comparacao head-to-head; sem Opus triage runner; sem DOI/URL/ISBN verifier; sem matriz cost/latency/recall. Lista completa: `docs/research/S269-dlite-rehydration.md#open-gaps`.
- Nao formalizar KBP-Candidate-D/E sem transcript/stop_reason proof ou re-bench.

Gate barato:
```bash
codex --version
rg -n "D-lite|KEEP-SEPARATE|S265 carryover|Phase 9" .claude/plans/sleepy-wandering-firefly.md
node scripts/smoke/research-dlite-contract.mjs
```

## 3. Lane C - Infra / auditoria Codex desta sessao

Quando Lucas disser "auditoria", "hardening", "gate", "harness", "seguranca" ou "integrity".

Relatorio auditavel: `docs/audit/codex-adversarial-audit-S267.md`.

Findings materiais ainda nao corrigidos:
- `uv run pytest -q` retornou `no tests ran`.
- `.git/hooks/pre-push` local nao foi instalado nesta sessao; o script versionado existe. Se quiser hook local automatico, rodar deliberadamente `bash content/aulas/scripts/install-hooks.sh`.

Resolvido S268:
- C1 guard-write boundary: fora do repo -> block; path interno nao classificado -> ask; `bash scripts/smoke/hooks-health.sh` PASS 16/16.
- C2 done-gate strict/pre-push: `done:cirrose:strict` adicionado, `content/aulas/scripts/pre-push.sh` criado, `install-hooks.sh` agora fail-closed se script versionado faltar.
- A1 integrity hooks: `hooks/apl-cache-refresh.sh` e `hooks/stop-failure-log.sh` normalizados LF; `bash -n` PASS; `bash tools/integrity.sh` PASS 0 violations.
- A2 Windows npm gate: `done-gate.js` usa `cmd.exe /d /s /c npm ...` no Windows; `npm --prefix content/aulas run done:cirrose` PASS Gate 1.

Primeiro fix recomendado se esta lane continuar: M1 pytest nominal (remover do repertorio ou adicionar smoke minimo). Senao, voltar para Lane B D-lite.

## 4. Roadmap constante

Now:
- `[S267/S268 P0 metanalise]` `.claude/plans/curious-enchanting-tarjan.md` - s-forest1/s-forest2.
- `[S269 P0 D-lite]` `docs/research/sota-S269-agents-subagents-contract.md` + `.claude/scripts/research-dlite-runner.mjs` - local smoke PASS; next = optional live smoke/re-bench.
- `[P1 BACKGROUND]` `.claude/plans/immutable-gliding-galaxy.md` - referencia, nao abrir no start.
- `[S270 P0 audit-adversarial]` `.claude/plans/snazzy-purring-dream.md` - decidir entre (a) C1 L3 Mermaid + A2 EC loop master+pointer 15min, (b) governance Pre-mortem/`[budget]` downgrade vs aplicacao, (c) defer findings e voltar Lane A/B/C.

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
