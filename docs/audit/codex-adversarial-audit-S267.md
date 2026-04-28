# Codex Adversarial Audit S267

> Escopo: auditoria adversarial read-only do repo OLMO feita em S267, depois persistida para reidratação. Evidência > intenção; este arquivo é o artefato auditável, `HANDOFF.md` só roteia.

## 1. TL;DR

- Estado geral: o repo tem disciplina documental forte, mas gates e contratos críticos ainda aceitam teatro operacional.
- Risco maior remanescente: done-gates/integrity prometem bloqueio/verificação, mas ainda há comandos inexistentes e hooks shell quebrados.
- S268 follow-up: C1 corrigido em `.claude/hooks/guard-write-unified.sh` + `scripts/smoke/hooks-health.sh`; `bash scripts/smoke/hooks-health.sh` PASS 16/16.
- Próxima ação barata: resolver C2 (`done:cirrose:strict`/pre-push) ou A1 (`tools/integrity.sh` vermelho por hooks CRLF/syntax).

## 2. Steelman

O status quo tenta resolver um problema real: Lucas opera múltiplos CLIs/agentes, e o repo precisa de contratos legíveis para que Claude, Codex e Gemini não pisem no mesmo escopo. A separação entre `HANDOFF.md`, plans e `context-essentials.md` é defensável como arquitetura de memória: curto no start, profundo sob demanda, histórico no changelog.

Também é defensável manter `.mjs` e agents em paralelo no research por enquanto. A evidência do bench diz que `.mjs` Gemini/Perplexity emitiu 9/9 no hot path, enquanto wrappers agentes ainda são experimentais. Migrar tudo por estética "agentic" antes do re-bench seria regressão, não modernização.

## 3. Findings por severidade

### FOLLOW-UP S268

**C1 — FIXED.** `guard-write-unified.sh` agora bloqueia `Write/Edit` fora do repo e transforma path interno não classificado em `permissionDecision:"ask"` em vez de allow silencioso. Regressões adicionadas: T9b (`scratch/untracked-note.md` -> ask) e T9c (`C:/Users/lucas/outside.txt` -> block) em `scripts/smoke/hooks-health.sh`. Verificação: mocks específicos PASS + `bash scripts/smoke/hooks-health.sh` PASS 16/16 + `bash -n` nos dois scripts PASS + `git diff --check` PASS.

### CRITICO

**C1 — Boundary de escrita é permitido por config e fail-open por default.**
Evidência: `.claude/settings.json:24-25` permite `Write` e `Edit`; `.claude/hooks/guard-write-unified.sh:18` sai 0 fora de git repo, `:35` sai 0 sem `FILE_PATH`, e `:153-154` declara "Not a guarded file" e permite silenciosamente. Impacto: um path fora das regras não é bloqueado por política positiva; a segurança depende de pattern coverage perfeita. Fix: trocar allow silencioso final por ask/block para paths fora de whitelist explícita e adicionar fixture `Write C:/Users/lucas/outside.txt` esperado BLOCK.

**C2 — Done gate de cirrose promete strict/pre-push que não existe.**
Evidência: `content/aulas/cirrose/DONE-GATE.md:5`, `:66-68` e `:80` exigem `npm run done:cirrose:strict` e pre-push automático; `content/aulas/package.json:24` só define `done:cirrose`; `Test-Path content/aulas/scripts/pre-push.sh` e `Test-Path .git/hooks/pre-push` retornaram `False`. Impacto: push/handoff podem ocorrer sem o gate prometido. Fix: ou implementar `done:cirrose:strict` + hook versionado, ou rebaixar o contrato removendo a promessa.

### ALTO

**A1 — `tools/integrity.sh` falha por hooks com CRLF/syntax error apesar de `.gitattributes`.**
Evidência: `.gitattributes:8` força `* text=auto eol=lf`; `git ls-files --eol hooks/apl-cache-refresh.sh hooks/stop-failure-log.sh` mostrou `w/crlf`; `bash -n hooks/apl-cache-refresh.sh` falhou em `hooks/apl-cache-refresh.sh:38`; `bash -n hooks/stop-failure-log.sh` falhou com EOF. Impacto: audit de integridade não fecha; hook runtime pode estar quebrado sem o operador perceber. Fix: normalizar LF, corrigir EOF/sintaxe, rodar `bash -n hooks/*.sh` como gate.

**A2 — Done gate Node falha no Windows por chamada direta `execFileSync('npm', ...)`.**
Evidência: `content/aulas/scripts/done-gate.js:16` importa `execFileSync`; `:74` e `:76` chamam bin `npm`; `:88` executa `execFileSync(bin, ...)`. Na auditoria, `node content/aulas/scripts/done-gate.js cirrose/metanalise` falhou, enquanto `npm --prefix content/aulas run build:{aula}` passou. Impacto: gate automatizado vira falso negativo em Windows, e o operador contorna manualmente. Fix: usar `npm.cmd` em `process.platform === 'win32'` ou `shell:true` com comando controlado.

### MEDIO

**M1 — Test suite Python declarada como harness existe só nominalmente.**
Evidência: `uv run pytest -q` retornou `no tests ran`. README vende ruff/mypy como dev helpers, mas não há teste Python ativo para validar scripts críticos. Impacto: mudanças em scripts podem passar lint/type-check e ainda quebrar comportamento. Fix: ou remover pytest do repertório operacional, ou adicionar smoke tests mínimos para gates/scripts que hoje são chamados como contrato.

### BAIXO

**B1 — Reidratação anterior carregava histórico demais.**
Evidência: `HANDOFF.md` pré-S267 misturava bench, metanálise, cautions e retake protocol em ~100 linhas; `CHANGELOG.md` já tinha histórico completo. Impacto: cada sessão começava consumindo contexto com decisões antigas. Fix aplicado em S267 docs: `HANDOFF.md` virou roteador de lanes e `context-essentials.md` virou survival kit curto.

## 4. Duplicacoes e contradicoes

| tema | arquivo A | arquivo B | divergencia |
|---|---|---|---|
| Write/Edit boundary | `.claude/settings.json:24-25` | `.claude/hooks/guard-write-unified.sh:153-154` | Config permite ferramenta; hook permite silenciosamente paths não cobertos. |
| Strict done gate | `content/aulas/cirrose/DONE-GATE.md:5` | `content/aulas/package.json:24` | Contrato cita `done:cirrose:strict`; npm script ausente. |
| Pre-push automático | `content/aulas/cirrose/DONE-GATE.md:80` | comando `Test-Path .git/hooks/pre-push` | Doc promete hook; hook local ausente. |
| LF enforcement | `.gitattributes:8` | `git ls-files --eol hooks/*.sh` | Política diz LF; working tree mostra CRLF. |
| QA gate Windows | `done-gate.js:74-88` | comando direto `npm --prefix ...` | Gate falha chamando `npm`; build direto funciona. |

## 5. Aspiracional vs operacional

| afirmacao | arquivo | evidencia de aplicacao real | veredicto |
|---|---|---|---|
| `pre-push` roda done-gate strict | `content/aulas/cirrose/DONE-GATE.md:80` | `.git/hooks/pre-push` ausente | ASPIRACIONAL |
| `done:cirrose:strict` existe | `content/aulas/cirrose/DONE-GATE.md:5` | `package.json` tem só `done:cirrose` | ASPIRACIONAL |
| Hooks shell íntegros | `tools/integrity.sh` como gate operacional | `bash -n` falha em 2 hooks | QUEBRADO |
| Write/Edit guard protege boundary | `.claude/hooks/guard-write-unified.sh` | S268 mocks: protected block, product ask, unclassified ask, outside-repo block | FIXED |
| pytest como verificação | comando operacional auditado | `no tests ran` | DECORATIVO |

## 6. Pre-mortem

1. Em 6 meses, o repo confia em gates que ninguém roda de fato. Sinal barato agora: `make integrity`/`tools/integrity.sh` precisa sair 0 em máquina limpa.
2. Um agente escreve fora do escopo por path não guardado. Sinal barato agora: fixture negativa para `Write` fora do repo deve bloquear.
3. A migração research vira teatro: agents chatty substituem `.mjs` que funcionava. Sinal barato agora: D-lite re-bench deve exigir JSON emit limpo antes de trocar canonical path.

## 7. Acoes recomendadas

| acao | impacto | custo | risco de nao fazer |
|---|---|---:|---|
| ~~Fail-closed em `guard-write-unified.sh` para paths não whitelistados + fixtures~~ | Alto | M | **DONE S268** — T9b/T9c em `hooks-health.sh`. |
| Resolver contrato `done:cirrose:strict`/pre-push | Alto | P-M | Handoff/push sem gate real. |
| Normalizar hooks shell para LF e corrigir syntax | Alto | P | Integrity gate sempre vermelho ou ignorado. |
| Corrigir `done-gate.js` para Windows | Médio | P | Gate contornado manualmente. |
| Decidir pytest: remover ou adicionar smoke mínimo | Médio | P | Comando decorativo polui confiança. |

## 8. O que NAO fazer

- Não migrar `.mjs` para agents antes do D-lite re-bench; a dor atual é emissão flaky dos wrappers, não falta de abstração.
- Não adicionar mais hooks sem primeiro provar consumer e exit behavior; hook silencioso sem consumidor é teatro.
- Não transformar `HANDOFF.md` em changelog paralelo; histórico longo fica em `CHANGELOG.md`.
