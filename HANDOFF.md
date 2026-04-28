# HANDOFF - Proxima sessao (S267)

> Reidrate por este arquivo primeiro. Nao leia `CHANGELOG.md` nem planos longos no inicio; use grep/range so quando a lane for escolhida.

## 0. Estado para reidratar em 90s

1. Rode `git status --short`.
2. Leia `.claude/context-essentials.md`.
3. Escolha UMA lane abaixo com Lucas.
4. Abra apenas o plano da lane escolhida, por secao/grep, nao inteiro.

Estado local conhecido deste handoff:
- `.claude/statusline.sh` modificado nesta sessao: adiciona barras de contexto e cota para Claude Code.
- `C:\Users\lucas\.codex\config.toml` global atualizado fora do repo: `status_line = ["model-name", "context-used", "five-hour-limit", "weekly-limit", "used-tokens"]`; backup `config.toml.bak-statusline-20260427-211428`.
- `.claude/.research-tmp/` existe como temp local ignorado; substrate canonico de bench fica em `.claude/.parallel-runs/2026-04-27-ma-types/`.
- Codex CLI local: `@openai/codex@0.125.0`; statusline aceita lista de strings, nao array de objetos.

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

Plano de execucao: `.claude/plans/sleepy-wandering-firefly.md` somente secoes `S264.c` e `S265 carryover`.

Estado:
- Decisao atual: KEEP-SEPARATE provisional.
- `.mjs` Gemini/Perplexity = hot path canonico empirico (9/9 emits).
- `codex-xhigh-researcher` = thin-agent canonico para Codex.
- `gemini-deep-research` e `perplexity-sonar-research` = EXPERIMENTAL ate D-lite refactor + re-bench.
- Nao formalizar KBP-Candidate-D/E sem transcript/stop_reason proof ou re-bench.

Gate barato:
```bash
codex --version
rg -n "D-lite|KEEP-SEPARATE|S265 carryover|Phase 9" .claude/plans/sleepy-wandering-firefly.md
```

## 3. Lane C - Infra / auditoria Codex desta sessao

Quando Lucas disser "auditoria", "hardening", "gate", "harness", "seguranca" ou "integrity".

Relatorio auditavel: `docs/audit/codex-adversarial-audit-S267.md`.

Findings materiais ainda nao corrigidos:
- `.claude/settings.json` permite `Write`/`Edit`, mas `.claude/hooks/guard-write-unified.sh` deixou path nao guardado passar em teste sintetico.
- `content/aulas/cirrose/DONE-GATE.md` promete `pre-push` e `done:cirrose:strict`, mas `content/aulas/scripts/pre-push.sh`, `.git/hooks/pre-push` e script npm strict nao existem.
- `tools/integrity.sh` falhou por syntax errors em `hooks/apl-cache-refresh.sh` e `hooks/stop-failure-log.sh`; ambos aparecem `w/crlf`.
- `node content/aulas/scripts/done-gate.js {aula}` falhou no Windows por `execFileSync('npm', ...)`; `npm --prefix content/aulas run build:{aula}` funcionou.
- `uv run pytest -q` retornou `no tests ran`.

Primeiro fix recomendado se esta lane for escolhida: corrigir o gate que promete bloquear write externo e provar com fixture negativa/positiva.

## 4. Planos ativos

- `[S267 P0 metanalise]` `.claude/plans/curious-enchanting-tarjan.md` - s-forest1/s-forest2.
- `[S267 P0 D-lite]` `.claude/plans/sleepy-wandering-firefly.md` - re-bench agents wrappers.
- `[P1 BACKGROUND]` `.claude/plans/immutable-gliding-galaxy.md` - referencia, nao abrir no start.

Pendentes de archive so sob demanda: `concurrent-nibbling-teacup.md`, `wobbly-foraging-pelican.md`, `S262-research-mjs-additive-migration.md`, `splendid-munching-swing.md`.

## 5. Regras de contexto

- `HANDOFF.md` + `.claude/context-essentials.md` sao suficientes para start.
- `CHANGELOG.md` e planos longos entram apenas por `rg -n "termo" arquivo`.
- Antes de editar state files: `git status --short`; se houver mudanca alheia, trabalhar com ela, nao reverter.
- Codex/Gemini default read-only no AGENTS; editar apenas quando Lucas aprovar escopo no thread atual.
