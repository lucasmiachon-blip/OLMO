# Plan: replicated-jingling-llama — S230 Phase G RESUME (G.9 → G.6)

> **This file is a thin execution wrapper.** Canonical spec (600+ li, copy-paste commands, banner full source, gotchas): `.claude/plans/mutable-sprouting-tarjan.md`.

## Context

S230 (`bubbly-forging-cat`) PAUSED 2026-04-19 ~13:15 mid-Phase G, commit `4446ee8 S230 Phase G PAUSE`. `/insights` run in G.1 (commit `2634c0c`) produced 6 propostas identifying metrics teatro + avoidance signals:

| # | Finding | Phase | Status |
|---|---|---|---|
| P001 | momentum-brake zero firings 11d | G.4 | **BLOCKED** — Lucas quer investigar útil-vs-subutilizado antes de delete |
| P002 | KBP-23 violations (Read sem limit) = 27/11d | G.7 | APPROVED |
| P003 | KPI loop + Cost BLOCK zero firings | G.3 | APPROVED |
| P004 | metrics.tsv stale 7 sessões (regex bug) | G.2 | APPROVED |
| P005 | anti-meta-loop (5 sessões sem `content/aulas/`) | G.8 | APPROVED |
| P006 | /insights periodicity (bi-diária, não semanal) | G.5 | APPROVED |

Phase G.9 é infraestrutura (banner lib 6 níveis semânticos) que G.7/G.8/G.5 consomem — daí ordem.

## State verified (resume snapshot)

- Last commit: `4446ee8` (Phase G PAUSE). Working tree: `M .claude/.last-insights` (pre-existing residual G.1, não bloqueia).
- `hooks/lib/` existe com `hook-log.sh` → G.9 adiciona `banner.sh` sibling.
- `.claude/workers/` vazio → staging limpo para padrão Write→cp.
- Todos 6 target hook files presentes:
  - `hooks/post-tool-use-failure.sh` (36 li) → G.7
  - `hooks/session-start.sh` (75 li) → G.8+G.5 combined
  - `hooks/stop-metrics.sh` (263 li, linha 96 regex) → G.2
  - `.claude/hooks/post-global-handler.sh` (148 li) → G.3 delete lines 26-32 + 45-146
  - `.claude/hooks/momentum-brake-{enforce,clear}.sh` → G.4 (delete/fix/log decision)

## Execution order

Per canonical plan §RESUME ENTRYPOINT: **G.0 setup → G.9 → G.7 → G.8+G.5 → G.2 → G.3 → G.4 → G.6**.

0. **G.0 setup** [trivial, ~30s]
   - Write `.claude/.session-name` ← `bubbly-forging-cat` (confirmed não-existe; statusline precisa). Guard accepts this path (not in `hooks/` scope).
   - TaskCreate batch: 8 tasks (G.9, G.7, G.8+G.5, G.2, G.3, G.4-invest, G.4-decide, G.6).
   - Leave `M .claude/.last-insights` as-is (timestamp residual G.1, commit-worthy only if Lucas explicit).

1. **G.9 banner.sh lib** [NEW file, LOW risk, ~85 li] — `hooks/lib/banner.sh` com 6 funções (`banner_success/info/warn/attn/critical/decision`). Source inteiro em canonical §"banner.sh FULL SOURCE" (linhas 230-310, copy-paste ready). Smoke test: `. hooks/lib/banner.sh && banner_warn "TESTE" "l2" "l3"` → renderiza box amarelo.

2. **G.7 KBP-23 enforcement** [edit, LOW risk] — `hooks/post-tool-use-failure.sh`: adiciona conditional `if PATTERN=="Read" && DETAIL contains "exceeds maximum"` → `banner_warn "KBP-23 Read sem limit" ...`. Evidence freq=27/11d.

3. **G.8 + G.5 session-start.sh combined** [edit single deploy = -2 popups, LOW risk] — 2 blocos adicionados antes do exit:
   - G.8: `META_STREAK = commits total - commits content/aulas/` em last 5. 3-4→ATTN laranja. 5+ OR R3<100d→CRITICAL vermelho.
   - G.5: `gap_days = (now - .last-insights) / 86400`. gap≥2 → INFO cyan reminder (NUNCA auto-execute).

4. **G.2 metrics.tsv regex fix** [edit, LOW risk] — `hooks/stop-metrics.sh:96`: `^S([0-9]+):` → `^S([0-9]+)([[:space:]]|:)`. Pre-test via shell echo+grep antes deploy. Backfill manual S224-S230 em `.claude/apl/metrics.tsv` (Edit direto — metrics.tsv não está em hooks/, guard não bloqueia). 7 rows data_quality=backfill.

5. **G.3 slim VANITY** [delete, LOW risk, -107 li] — `.claude/hooks/post-global-handler.sh`: remove linhas 45-146 (KPI Reflection Loop) + linhas 26-32 (Cost BLOCK arm). Keep Cost WARN + momentum-arm. File 148 li → ~50 li. Verify: `grep -c 'KPI_INTERVAL\|KPI Reflection\|BLOCK_THRESHOLD'` == 0.

6. **G.4 momentum-brake decision** [BLOCKED — investigate first, risk DEPENDS on outcome]
   - **Step 1 investigation** (canonical §G.4): armed timestamp vs brake-fired entries em hook-log.jsonl; count Edit/Write tool calls S230 session (`871bd5a2-9777-4ddb-88af-5a193d8cdd58.jsonl`); read `momentum-brake-enforce.sh` confirma logging path.
   - **Step 2 decision matrix** (4 outcomes: TEATRO behavioral/técnico / SUBUTILIZADO / ÚTIL real).
   - **Step 3** pausa para Lucas decidir (🟣 DECISION banner once lib deployed).
   - **Step 4** execute: DELETE / FIX granular (Bash blanket→granular) / ADD logging.

7. **G.6 session close** [state files Edit + plan archive] — HANDOFF.md remove PAUSED header + atualiza ESTADO POS-S230; CHANGELOG.md append 7 phase bullets; `git mv .claude/plans/mutable-sprouting-tarjan.md .claude/plans/archive/S230-mutable-sprouting-tarjan-G-metrics.md`; this wrapper file também archived.

## Non-negotiable patterns (anti-drift enforcement)

- **Write→temp→cp per hook** — `guard-write-unified.sh:120-124` bloqueia Edit direto em `(hooks|.claude/hooks)/.*\.sh$`. Staging via `.claude/workers/*.sh.new` → `cp` → `rm` → `bash -n`. Infra técnica, não ritual.
- **EC loop pre-Edit/Write** (anti-drift.md): `[EC] Verificacao/Mudanca/Elite` antes de cada tool call que modifica file.
- **Momentum brake entre phases** (anti-drift.md §Momentum brake): após cada phase commit, STOP + report + esperar ordem Lucas. Dentro de uma phase aprovada, execução é contínua.
- **Decision gates reais** (onde Lucas pára pra decidir, não popup auto-approve):
  1. Antes de G.4 execution → investigation output + decision matrix → Lucas escolhe DELETE/FIX/LOG.
  2. Antes de G.6 close → confirmação de que HANDOFF + CHANGELOG + archive estão OK.
- **TaskCreate batch** (anti-drift §Plan execution): 8 tasks no G.0 setup. TaskUpdate in_progress at start, completed at commit.
- **Commits** — per canonical §commit template + `Coautoria: Lucas + Opus 4.7` + `Co-authored-by: Opus 4.7 <noreply@anthropic.com>`.

## Critical files to read before execution

- `.claude/plans/mutable-sprouting-tarjan.md` — canonical spec (already read full this session)
- `hooks/post-tool-use-failure.sh` — G.7 read full (36 li)
- `hooks/session-start.sh` — G.8+G.5 read full (75 li)
- `hooks/stop-metrics.sh` — G.2 read around line 96 (±20 li)
- `.claude/hooks/post-global-handler.sh` — G.3 read full (148 li)
- `.claude/hooks/momentum-brake-enforce.sh` — G.4 investigation
- `.claude/apl/metrics.tsv` — G.2 backfill header
- `success-log` + `git log` — G.2 backfill data

## Verification (end-to-end)

| Check | Command | Expected |
|---|---|---|
| banner lib syntax | `bash -n hooks/lib/banner.sh` | exit 0 |
| banner smoke test | `. hooks/lib/banner.sh && banner_warn "T" "L2" "L3"` | amarelo 4-5 li |
| G.7 hook still valid | `bash -n hooks/post-tool-use-failure.sh` | exit 0 |
| G.8+G.5 hook still valid | `bash -n hooks/session-start.sh` | exit 0 |
| G.2 regex works | `echo 'S230 Batch X:' \| grep -E '^S([0-9]+)([[:space:]]\|:)'` | match |
| G.2 metrics populated | `grep -c '^S22[4-9]\|^S230' .claude/apl/metrics.tsv` | ≥7 |
| G.3 slim confirmed | `wc -l .claude/hooks/post-global-handler.sh` | ~50 |
| G.3 no residual teatro | `grep -c 'KPI Reflection\|BLOCK_THRESHOLD' ...` | 0 |
| G.6 plan archived | `ls .claude/plans/archive/S230-*.md` | present |
| G.6 HANDOFF clean | `grep 'PAUSED' HANDOFF.md` | no match |

## Open decision (pre-exec)

**G.4 investigation timing:** execute investigation (reads apenas, no file changes) logo após G.9 deploy (so banner_decision disponível for results display), OR defer investigation até natural ordem G.4 position pós-G.3. Recommendation: **defer** — maintains linear execution; G.4 investigation com banner_decision available is stylistically coherent.

## Commits estimate

7 commits this session (G.9, G.7, G.8+G.5 combined, G.2, G.3, G.4, G.6). Phase G total including G.1: 8 commits. Net: ~150 li adicionadas (banner lib + enforcement) + ~150 li deletadas (KPI teatro + maybe brake) — linecount quase neutral, signal-to-noise positivo.

## Actual decision points (pontos de atenção reais)

| Momento | Decisão |
|---|---|
| G.0 | Aprovar plan como um todo (ExitPlanMode). Se aprovado, G.9 a G.3 são execução linear per canonical spec. |
| G.4 pós-investigation | Lucas escolhe: DELETE / FIX granular / ADD logging / KEEP. Output da investigation + matriz de decisão apresentada via `banner_decision`. |
| G.6 pré-archive | Confirmar HANDOFF+CHANGELOG state files corretos antes de `git mv` plan pra archive. |

## Pedagogical rationale — G.3 (current batch)

**O QUE deletar (`.claude/hooks/post-global-handler.sh` — 148 li):**

1. **Lines 45-146 (~100 li) — KPI Reflection Loop**
   - Compara sessão atual vs baseline (média últimas 5 sessões `data_quality=full`) a cada 200 tool calls
   - Métricas: rework files, backlog open, handoff pendentes, eficiência (calls/changelog_line), ctx %
   - Output: `[KPI:200] ALERTA: handoff crescendo...` ou `[KPI:200] OK — rework:N backlog:M...`
   - Threshold: `CC_KPI_INTERVAL=200` (a cada 200 tool calls)

2. **Lines 26-32 (~7 li) — Cost BLOCK arm**
   - Ativa brake quando COUNT ≥ BLOCK_THRESHOLD (default 400)
   - Cria `/tmp/olmo-cost-brake/armed` + printa `[cost-brake] N tool calls — brake armado`

**POR QUE é teatro (evidence `/insights P003`):**

- KPI loop: **ZERO firings em 11 dias.** Threshold 200 é inatingível em sessões típicas do Lucas (sessões curtas focadas, raramente atingem 200 tool calls).
- Cost BLOCK: **ZERO firings.** 400 calls é ainda mais longe.
- Ambos = código que existe (105+ li), é parseado a cada tool call via source, mas NUNCA executa o comportamento protetivo em 11 dias de uso real.

**POR QUE o sistema melhora com a deleção:**

1. **Sinal honesto:** o que sobra = o que realmente roda. Remove proteção ficcional que dava falsa sensação de safety net.
2. **Superfície de bug menor:** -107 li = menos código pra regredir em edits futuros. Cada linha é potencial falso positivo / edge case.
3. **Carga cognitiva reduzida:** futuros leitores (inclusive eu pós-/clear) não gastam tempo entendendo código morto.
4. **Consistência de paradigma:** mesma lógica aplicada em Phase D (ModelRouter teatro -75 li S230 Batch 3c) e S229 slim (Notion crosstalk eliminou Python sync). Sistema convergindo para "só o que honestamente roda".

**O QUE sobra e POR QUÊ:**

- Lines 14-24 (counter setup) — dependência do Cost WARN que fica
- Lines 33-38 (**Cost WARN**, ≥100 calls periodic a cada 50) — **fires em sessões médias, útil, não teatro.** Confirma que o contador funciona.
- Lines 40-43 (**Momentum brake arm**, escreve `/tmp/olmo-momentum-brake/armed`) — **dependência da investigação G.4.** Deletar agora quebraria o brake antes da decisão evidence-based.

**Risk map:**

| Aspect | Risk | Mitigation |
|---|---|---|
| Runtime break | LOW | Código deletado tem zero firings — não tem runtime pra quebrar |
| set -euo pipefail abort | LOW | `bash -n` antes do commit + Cost WARN + momentum-arm preservados intactos |
| G.4 dependency | MITIGATED | Momentum brake arm (40-43) explicitamente preservado |
| Dashboard break | ZERO | metrics dashboard lê metrics.tsv (G.2), não post-global-handler.sh |

**Execução proposta:**

1. Compose via `{ head -n 25 <file>; sed -n '33,44p' <file>; tail -n +147 <file>; } > workers/post-global-handler.sh.new`
2. Verify diff: deve mostrar remoção de 2 blocos (Cost BLOCK + KPI loop), tudo mais intacto
3. Deploy combined: cat redirect + chmod + rm + bash -n (G.9b pattern pós-KBP-26)
4. Verify: `grep -c 'KPI_INTERVAL\|KPI Reflection\|BLOCK_THRESHOLD' .claude/hooks/post-global-handler.sh` == 0
5. Update plan tracking (G.3 DONE, G.4 NEXT)
6. Commit hook + plan juntos

**G.3 RESULTADO (commit `0780061`):** file 148→35 li (-113, melhor que -107 planejado — incluiu remoção de `BLOCK_THRESHOLD` var + `COST_BRAKE_DIR` var + `(limite: %d)` printf misleading).

## Pedagogical rationale — G.4 (next batch)

**CONTEXTO — O que é o momentum brake system:**

Sistema de 3 hooks interconectados em `.claude/hooks/`:
- `post-global-handler.sh:33-36` (preservado G.3) — **arma** o brake escrevendo timestamp em `/tmp/olmo-momentum-brake/armed` a cada tool call
- `momentum-brake-enforce.sh` (PreToolUse) — lê armed timestamp + compara com último UserPromptSubmit. Se Lucas falou recentemente E próximo tool call é destrutivo → brake dispara, pede confirmação
- `momentum-brake-clear.sh` (UserPromptSubmit) — apaga o armed file quando Lucas envia nova mensagem (reset cycle)

**Intent original:** forçar pause reflexivo entre tool calls autonomous, prevenir "velocity over comprehension" (KBP-14 anti-pattern).

**O QUE A EVIDÊNCIA DIZ (`/insights P001`):**

- **Zero brake firings em 11 dias** de hook-log.jsonl
- armed file sempre existe (brake continuamente armado)
- Sessões S223-S230 com dezenas de Edit/Write sem nenhuma interrupção do brake

**POR QUE AMBÍGUO — 4 hipóteses concorrentes:**

1. **TEATRO BEHAVIORAL** — Brake dispara silenciosamente, Lucas auto-aprova sem refletir. Popup existe mas não muda comportamento efetivo.
2. **TEATRO TÉCNICO** — Brake tenta disparar mas tem bug no enforce (ex: Bash blanket-exempt faz quase nada ativar a verificação). Nunca roda o caminho protetivo.
3. **SUBUTILIZADO** — Brake funcionaria, mas exemption blanket (todos Bash commands) remove ~99% dos tool calls do radar. Conceito certo, implementação preguiçosa.
4. **ÚTIL REAL** — Brake tá disparando corretamente quando deve, sessões têm sido Read-heavy (não precisam armar). Silent = working.

Sem investigação, não sabemos qual é. Deletar sem evidence = risco de remover proteção útil. Manter sem evidence = risco de código teatro acumulando.

**INVESTIGAÇÃO PROPOSTA (readonly, 4 tests, ~5min):**

| Test | Comando/Ação | O que revela |
|---|---|---|
| T1: armed timing | `ls -la /tmp/olmo-momentum-brake/armed` + compare com clear cycle | Último arm. Ciclo arm-clear funcionando? |
| T2: hook-log events | `grep -i momentum-brake .claude/hook-log.jsonl` | Brake alguma vez logou fire? Se sim → ÚTIL ou TEATRO BEHAVIORAL |
| T3: Edit/Write count | `grep -c '"tool_name":"Edit"\|"tool_name":"Write"' <session jsonl>` | Se S230 teve N Edits e brake 0 firings → TEATRO TÉCNICO ou SUBUTILIZADO |
| T4: exempt logic | `Read momentum-brake-enforce.sh` full | Onde Bash/outras tools são exemptadas? Blanket → SUBUTILIZADO confirmado |

**4 DECISÕES POSSÍVEIS (Lucas escolhe após ver evidence):**

| Outcome | Ação | Justificativa | Risk |
|---|---|---|---|
| TEATRO BEHAVIORAL | **DELETE** 2 hooks + settings.json regs + post-global-handler:40-43 arm | Popup sem efeito = noise | MEDIUM (if diagnosis wrong) |
| TEATRO TÉCNICO (bug) | **ADD LOGGING** primeiro (cada fire → jsonl) + decidir S232 evidence-based | Pode estar "quase funcionando" | LOW (no behavior change) |
| SUBUTILIZADO | **FIX granular** (Bash blanket → só Read/Glob/Grep exempt, armar em git/rm/mv/echo) | Conceito certo, implementação preguiçosa | MEDIUM (more popups) |
| ÚTIL REAL | **KEEP** as-is | Evidence mostrou funcionamento legítimo | ZERO |

**POR QUE o sistema melhora com cada outcome (não há outcome "ruim"):**

- **DELETE**: -~80 li de código "proteção teatro". Mesma filosofia de G.3 e ModelRouter (Batch 3c S230). Sinal honesto: só o que roda.
- **ADD LOGGING**: visibility pra decisão evidence-based em S232. "Measure first, decide later". Antifragile principle.
- **FIX GRANULAR**: proteção real ativa contra KBP-14 velocity drift. Hook passa de teatro a útil. Melhor outcome se aplicável.
- **KEEP**: validação de que funcionamento é correto mesmo parecendo silent. Confidence boost no sistema atual.

O valor pedagógico é **a decisão baseada em evidence**, não a ação em si.

**EXECUÇÃO PROPOSTA (3 etapas):**

**Etapa 1 — INVESTIGATION** (readonly, ~5min):
1. Read `.claude/hooks/momentum-brake-enforce.sh` full
2. Read `.claude/hooks/momentum-brake-clear.sh` full
3. Bash: check armed timestamp (T1) + brake events no hook-log (T2) + Edit/Write count session S230 (T3)
4. Present evidence map com dados reais → identificar qual das 4 hipóteses é correta

**Etapa 2 — 🟣 DECISION GATE (Lucas input needed):**
- Mostro evidence via `banner_decision` (da G.9)
- Lucas escolhe: DELETE / ADD LOGGING / FIX GRANULAR / KEEP
- Pode também ser híbrido (ex: ADD LOGGING + defer DELETE decision to S232)

**Etapa 3 — EXECUÇÃO conforme outcome:**
- Steps concretos ajustados per outcome escolhido
- TaskUpdate per step
- Commit + plan tracking update

**Commits esperados:** 1-2 (1 se investigação + decisão + execução simples; 2 se investigation findings commit separado for útil documentalmente)

**RISK GUARDRAIL:** se após T1-T4 os dados forem inconclusivos, default seguro = ADD LOGGING (preserva funcionamento, coleta evidence pra S232). Não DELETE sem certeza.

**G.4 RESULTADO (commit `31815ff`):** ADD LOGGING outcome. enforce.sh 53→60 li (+7). Investigation revelou brake funciona mecanicamente; "zero firings" é artefato de (a) auto mode silencia asks, (b) enforce.sh não logava. Agora loga → S232 /insights terá dados reais.

## Pedagogical rationale — G.6 (final batch — session close)

**CONTEXTO — o que é "session close":**

Convenção do projeto (`anti-drift.md §Session docs`): após trabalho substancial, encerrar sessão atualizando 3 state files + arquivando plano. Os 3 files são o **entry point da próxima sessão** — precisam refletir reality, não intenção.

**ARTEFATOS A ATUALIZAR:**

1. **`HANDOFF.md`** (max ~50 li, pendências only):
   - **Remover header `⏸️ PAUSED`** — sessão completou Phase G
   - **Remover seção `RESUME AQUI`** (obsoleta pós-completion)
   - **Atualizar `ESTADO POS-S230`**: Phase G concluída + 8 commits novos adicionados
   - **Preservar `S231 START HERE` priority list** (P1 items ainda válidos)
   - **Usar Edit (não Write)** per anti-drift §State files — preserva seções

2. **`CHANGELOG.md`** (append-only):
   - Sessão 230 já existe (Batches 1-4). **Adicionar sub-seção "Phase G — metrics infrastructure rationalized"**
   - 8 commits bulleted com SHA + mudança (incluindo G.1 do pre-session 2634c0c + G PAUSE 4446ee8 + todos G.X recent)
   - **Aprendizados + residual** ≤5 li (anti-drift §Session docs)

3. **Plan archive** via `git mv`:
   - `.claude/plans/mutable-sprouting-tarjan.md` → `.claude/plans/archive/S230-mutable-sprouting-tarjan-G-metrics.md`
   - `.claude/plans/replicated-jingling-llama.md` (this wrapper) → `.claude/plans/archive/S230-replicated-jingling-llama-G-wrapper.md`
   - Mantém `.claude/plans/` limpo para próxima sessão, preserva history

**POR QUE o sistema melhora com session close correto:**

1. **Continuidade barata na próxima sessão:** HANDOFF.md é lido automaticamente pelo `session-start.sh` hook. HANDOFF stale = S231 começa lendo "PAUSED" e tentando retomar algo já completo → 30min perdidos reconciliando.

2. **History searchability:** CHANGELOG.md é o "diário" do projeto. "Quando mudou o banner system?" → grep CHANGELOG → "S230 Phase G.9". Sem append, futuro tu perdeu o ponteiro.

3. **Plan lifecycle hygiene:** `.claude/plans/` deve ter APENAS active plans (currently S227-memory-to-living-html é o único active pós-G.6). Archive preserva decisões + execução real (útil para padrões tipo G.9b KBP-26 discovery).

4. **Explicit completion:** sem remover PAUSED, sistema trata sessão como "in progress limbo" → auto-inferências erradas em hooks/prompts futuros.

5. **Commit atomic**: tudo em 1 commit "S230 Phase G close" = git archaeology fácil. "Onde Phase G terminou?" → este commit.

**O QUE NÃO fazer (anti-patterns):**

- ❌ Write em HANDOFF/CHANGELOG (apaga seções silenciosamente — violação §State files)
- ❌ Esquecer de arquivar plan files (ACTIVE vira ruído acumulado — KBP-02 Context Overflow eventual)
- ❌ Commit separado por state file (quebra atomicidade — archaeology fica confusa)
- ❌ Deixar PAUSED header (sistema futuro auto-infere estado errado)

**RISK MAP:**

| Aspect | Risk | Mitigation |
|---|---|---|
| HANDOFF seção perdida | MEDIUM (usar Write em vez de Edit) | Edit targeted, verify section presence antes/depois |
| CHANGELOG Aprendizados >5 li | LOW (drift incremental) | Contar linhas antes commit, trim se overflow |
| Plan archive esquecido | LOW (easy fix depois) | Checklist explícito nos steps |
| Commit scope creep | LOW (só G.6 touching state files) | Explicit `git add` list antes commit |

**EXECUÇÃO PROPOSTA (single commit, 5 steps):**

1. **Compose HANDOFF.md changes** (targeted Edits ≥2):
   - Remove/replace `⏸️ PAUSED` header block
   - Remove `RESUME AQUI` section
   - Update `ESTADO POS-S230` with Phase G complete summary

2. **Compose CHANGELOG.md append** (Edit adding Phase G sub-section under Sessao 230 existing):
   ```
   ### Phase G — metrics infrastructure rationalized (8 commits)
   - G.1 (2634c0c): /insights restored after 11d gap — 6 propostas P001-P006
   - G.9 (44f8751 + a8a87be + c5aacd1): banner.sh lib 6 niveis + doc fix KBP-26 + plan refresh
   - G.7 (33b59e7): KBP-23 Read-sem-limit auto-warn (27 violations/11d)
   - G.8+G.5 (c405a1a): anti-meta-loop + /insights bi-diario reminder (session-start.sh)
   - G.2 (64a9338): stop-metrics.sh regex fix + 7 rows backfill metrics.tsv (local)
   - G.3 (0780061): slim VANITY post-global-handler 148→35 li (-113)
   - G.4 (31815ff): momentum-brake ADD LOGGING (defer DELETE to S232)
   ```
   + 3-5 li Aprendizados (KBP-26 cp deny broke canonical pattern, "teatro honesto" é distinção evidence-based, logging precede decisão irreversível)

3. **Archive plan files** (2 × git mv):
   - `git mv .claude/plans/mutable-sprouting-tarjan.md .claude/plans/archive/S230-mutable-sprouting-tarjan-G-metrics.md`
   - `git mv .claude/plans/replicated-jingling-llama.md .claude/plans/archive/S230-replicated-jingling-llama-G-wrapper.md`

4. **Verify** antes commit:
   - `grep PAUSED HANDOFF.md` → 0
   - `ls .claude/plans/*.md` → só S227-memory-to-living-html (ACTIVE)
   - `ls .claude/plans/archive/S230-*` → 2 files novos

5. **Commit** atomic:
   - `git add HANDOFF.md CHANGELOG.md .claude/plans/` (archive moves incluídos no diff automaticamente)
   - Message: "S230 Phase G close: metrics infrastructure rationalized"

**Commits esperados:** 1 final (G.6 single atomic close)

**DECISION GATE (pré-archive per plan original):** Lucas revisa HANDOFF+CHANGELOG state antes do `git mv` — last chance pra catch drift.
