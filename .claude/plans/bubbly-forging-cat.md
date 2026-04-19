# Plan: bubbly-forging-cat — OLMO Adversarial Audit & Simplification (S230)

> **Role:** auditor adversarial + arquiteto de simplificação.
> **Alvo:** OLMO menor, mais verdadeiro, mais próximo da taxonomia oficial Anthropic.
> **Date cutoff:** 2026-04-18. **Branch:** main. **Session:** 230.

---

## Context

Pós-S229 o runtime Python está tecnicamente limpo (1 agent + 1 subagent + 3 workflows, zero imports órfãos de agentes deletados). O problema mudou de runtime para **governança e verdade documental**: docs descrevem sistemas que não existem, a configuração de hooks vive num arquivo diferente do que CLAUDE.md afirma, há módulos Python órfãos de 309 linhas, skills declaradas em `ecosystem.yaml` divergem do filesystem, e a mesma regra é reiterada em 4 superfícies sem owner canônico.

Adversarial premise: **o ecossistema ficou mais simples em código, mas a documentação não acompanhou.** Essa divergência é o que contamina contexto, polui memória always-on, e degrada confiança. Primeira frente de trabalho é verdade, não features. Segunda é de-duplicação. Terceira é reduzir superfície órfã. Multimodel vem depois — com gate explícito.

**Objetivo mensurável:**
- 0 referências fantasma em docs ativos (agents, hooks, skills).
- CLAUDE.md + rules + skills + hooks ≤ 1 owner canônico por regra.
- 0 módulos Python sem consumer.
- Plans ACTIVE alinhados com arquitetura real ou arquivados.
- AGENTS.md explicitamente declarado como cross-CLI (Codex/Gemini), não Claude Code.

---

## Verification of User's 7 Stated Findings

| # | Finding | Status | Evidence |
|---|---|---|---|
| 1 | CLAUDE.md aponta hooks em `settings.local.json`, real está em `settings.json` | **CONFIRMED** | `CLAUDE.md:61`, `README.md:139`, `docs/ARCHITECTURE.md:64+209`. `.claude/settings.local.json` tem 12 linhas, sem chave `"hooks"`; `.claude/settings.json` (452 li) tem 34 registrations. |
| 2 | `.claude/hooks/README.md` documenta scripts fantasma/renomeados | **CONFIRMED** | 11 scripts documentados que não existem (`guard-pause.sh`, `guard-generated.sh`, `guard-product-files.sh`, `build-monitor.sh`, `cost-circuit-breaker.sh`, `momentum-brake-arm.sh`, `stop-crossref-check.sh`, `stop-detect-issues.sh`, `stop-chaos-report.sh`, `stop-hygiene.sh`, `stop-scorecard.sh`). 7 scripts existentes não documentados (`nudge-commit.sh`, `guard-write-unified.sh`, `guard-research-queries.sh`, `guard-mcp-queries.sh`, `post-bash-handler.sh`, `nudge-checkpoint.sh`, `coupling-proactive.sh`, `post-global-handler.sh`, `post-compact-reread.sh`, `session-end.sh`). |
| 3 | HANDOFF declara 2 agents+3 subagents+6 workflows; entrypoint sobe 1 agent+1 subagent | **REFUTED** | HANDOFF atual declara "1 agent + 1 subagent + 3 workflows" (corresponde ao runtime). Provável confusão do user com HANDOFF pré-S229. Mas `docs/ARCHITECTURE.md:27` ainda lista "Claude Code Subagents (8)" quando são 9 no filesystem — drift separado mantido em Batch 1. |
| 4 | `agents/core/orchestrator.py` ainda referencia agentes mortos | **REFUTED** | Grep em todos `.py` por `knowledge_organizer, notion_cleaner, organizacao, atualizacao_ai, cientifico, web_monitor, trend_analyzer`: zero ocorrências. Runtime limpo. |
| 5 | Memória fragmentada entre CLAUDE.md, rules, skills, plans, agent-memory, living HTML | **CONFIRMED com nuance** | Sim, mas específicamente: (a) regra "Proponha, espere OK" em 4 lugares sem canônico declarado; (b) `.claude/context-essentials.md` é 3º canal pós-compaction duplicando CLAUDE.md; (c) `.claude/agent-memory/evidence-researcher/` carrega always-on conteúdo que ACTIVE-S227 já identificou como devendo ser living-HTML há 3 sessões. |
| 6 | Valida se AGENTS.md tem import explícito; Claude Code lê CLAUDE.md | **PARTIAL** | AGENTS.md existe (105 li), **não** é órfão: é lido por Codex CLI e Gemini CLI (convenção própria desses CLIs). Problema real: (a) nenhum CLAUDE.md declara essa divisão; (b) AGENTS.md referencia `memory/patterns_adversarial_review.md` que não existe; (c) AGENTS.md tem quick commands duplicando CLAUDE.md. Não é órfão mas está mal-governado. |
| 7 | Diretórios fantasma e referências órfãs em agents/, subagents/, docs/, workflows, skills | **CONFIRMED parcial** | Python `workflows/` diretório: não existe (por design — workflows vivem em `config/workflows.yaml`). Agents/subagents Python: limpo. `agents/core/smart_scheduler.py` (309 li): órfão, 0 imports. `skills/efficiency/local_first.py`: órfão. `docs/ARCHITECTURE.md`: 11 scripts fantasma em diagramas Mermaid. `ecosystem.yaml`: 9 skills declaradas, 18 no filesystem. |

**Meta-finding:** user tinha ~70% do estado correto (5/7 confirmados). Os 2 refuted (#3, #4) eram memória stale de pré-S229 — runtime está clean, o problema virou documental/governança.

---

## Additional Findings Discovered (não listados pelo user)

1. **`_resolved_model` é teatro completo.** `agents/core/orchestrator.py:78` escreve `task_with_model = {**task, "_resolved_model": resolved_model}` mas `AutomationAgent.execute()` nunca lê a chave. `ModelRouter.resolve()` calcula e loga, resultado descartado. Documentado em BACKLOG #42 como "ModelRouter unused" há sessões, persiste.

2. **Routing map trivial.** `agents/core/orchestrator.py:68-72`: `routing_map = {"automate": "automacao", "monitor": "automacao"}` — 2 task types, ambos roteiam para o mesmo agent. Dispatcher sem dispatching real.

3. **KBP-26 viola KBP-16 dentro do próprio arquivo.** `known-bad-patterns.md:9` canoniza "pointer-only, prose vive no pointer target"; `known-bad-patterns.md:88` (KBP-26) tem 4 linhas de prose inline. O arquivo que define pointer-only contém prose inline.

4. **`settings.local.json` tem 3 de 5 entries problemáticas.** Linha 6: stale S226 mv hardcoded. Linhas 7-8: `Bash(git add *)` e `Bash(git commit -m ' *)` redundantes com `settings.json` allow `Bash(*)`. Linha 4: `Agent` duplica `settings.json:26`.

5. **`ecosystem.yaml` declara 9 skills, filesystem tem 18.** Metade das skills existe sem governança por config. Precisa decidir: (a) ecosystem.yaml declara todas e source of truth, ou (b) ecosystem.yaml declara só as Python-invocable e CC-only skills vivem por filesystem convention.

6. **`docs/ARCHITECTURE.md` Mermaid diagrams describing fictional stack.** `:50` lista 8 guards com 3 fantasma; `:52` lista 5 PostToolUse com 2 fantasma; `:53` lista 6 Stop com todos 5 primeiros fantasma (mergeados em stop-quality/stop-metrics). Primeira fonte consultada por novos colaboradores → primeiro contato com mentira.

7. **skills com trigger fraco.** `continuous-learning` (description genérica "Progressive learning and explanations") e `teaching` (sem frases de trigger) — candidatos a acionamento acidental. Revisar ou consolidar.

8. **`content/aulas/metanalise/CLAUDE.md` tem playbook inline (§QA Pipeline máquina de estados, 8 estados + 4 gates).** Playbook é conteúdo on-demand vivendo em always-on path-scoped. Candidato a DEMOTE-TO-SKILL `qa-pipeline`.

---

## Truth Matrix (consolidated)

Single source of truth para esta campanha. Status semantics: KEEP | FIX-REF | FIX-DOC | MERGE | DEMOTE | ARCHIVE | DELETE | DEFER.

### Runtime (Python)

| item | type | fs | runtime | docs | config | consumer | status |
|---|---|---|---|---|---|---|---|
| `Orchestrator` (dispatcher) | core | Y | Y | Y | Y | `orchestrator.py:37` | KEEP |
| `AutomationAgent` | agent | Y | Y | Y | Y | `orchestrator.py:41` | KEEP |
| `DataPipelineSubagent` | subagent | Y | Y | Y | Y | `orchestrator.py:47` | KEEP |
| `ModelRouter` | util | Y | Y (teatro) | Y | Y | NENHUM (key escrito, nunca lido) | **FIX ou DELETE** |
| `SmartScheduler` | util | Y | N (0 imports) | N | N | NENHUM | **DELETE** (309 li) |
| `agents/core/database.py` | util | Y | ambíguo | N | N | desconhecido | **DEFER investigação** |
| `skills/efficiency/local_first.py` | Python skill | Y | N | N | N | NENHUM | **DELETE** |
| `weekly_deep_review` | workflow | Y (yaml) | Y | Y | Y | loader | KEEP |
| `smart_query` | workflow | Y (yaml) | Y | Y | Y | loader | KEEP |
| `code_review` | workflow | Y (yaml) | Y | Y | Y | loader | KEEP |

### Claude Code subagents (`.claude/agents/*.md`)

| item | fs | docs | consumer | status |
|---|---|---|---|---|
| `evidence-researcher.md` | Y | Y | Task tool | KEEP |
| `qa-engineer.md` | Y | Y | Task tool | KEEP |
| `mbe-evaluator.md` | Y | Y | Task tool (FROZEN) | KEEP |
| `reference-checker.md` | Y | Y | Task tool | KEEP |
| `quality-gate.md` | Y | Y | Task tool | KEEP |
| `researcher.md` | Y | Y | Task tool | KEEP |
| `repo-janitor.md` | Y | Y | Task tool | KEEP |
| `sentinel.md` | Y | **N** | Task tool | **FIX-REF** (add to ARCHITECTURE.md table) |
| `systematic-debugger.md` | Y | **N** | Task tool | **FIX-REF** (add to ARCHITECTURE.md table) |
| `notion-ops` (phantom) | **N** | Y (4 refs) | NENHUM | **FIX-REF** (remove from ARCHITECTURE.md:40, README.md:25, AGENTS.md, wiki) |

### Hooks

| hook/script | fs | settings | README | status |
|---|---|---|---|---|
| Todos 29 scripts referenciados em `settings.json` | Y | Y | parcial | **FIX-DOC** README |
| 11 scripts documentados em README | **N** | N | Y | **DELETE README entries** |
| 2 hooks inline Stop (prompt + agent) | N/A | Y | **N** | **FIX-DOC** README |

### Memory layers

| layer | type_correto | type_atual | status |
|---|---|---|---|
| `/CLAUDE.md` root | always-on | always-on | KEEP |
| `content/aulas/CLAUDE.md` | path-scoped | path-scoped | KEEP |
| `content/aulas/metanalise/CLAUDE.md` | path-scoped | contém playbook inline | **DEMOTE** (QA Pipeline section → skill) |
| `.claude/context-essentials.md` | compaction-survival | duplica CLAUDE.md | **MERGE** (reduce to delta-only) |
| `.claude/rules/anti-drift.md` | global rule | global rule (canônico) | KEEP |
| `.claude/rules/known-bad-patterns.md` | pointer index | KBP-26 viola formato | **FIX** (extrair prose) |
| `.claude/rules/qa-pipeline.md` | path-scoped | path-scoped | KEEP |
| `.claude/rules/slide-rules.md` | path-scoped | overlap parcial com `design-reference.md` | **AUDIT overlap** |
| `.claude/rules/design-reference.md` | path-scoped | path-scoped | KEEP (after overlap audit) |
| `.claude/agent-memory/evidence-researcher/*` | on-demand | always-on (loaded per agent invoke) | **DEFER to BACKLOG #36** (Batch 6) |
| `AGENTS.md` | cross-CLI (Codex/Gemini) | não declarado como tal | **FIX-DOC** (declare no CLAUDE.md + remove dead refs) |

### Plans

| plan | active/archive | acionável | status |
|---|---|---|---|
| `ACTIVE-S225-SHIP-roadmap.md` | ACTIVE | NO (S229 executou diferente do plano) | **ARCHIVE** |
| `ACTIVE-S227-memory-to-living-html.md` | ACTIVE | YES (steps 1-6 executáveis) | KEEP (rename header) |
| 62 archive plans | ARCHIVE | N/A | KEEP (histórico) |

### Duplication rows (regras em 2+ lugares)

| regra | locais | canônico proposto |
|---|---|---|
| "Proponha, espere OK, execute" | CLAUDE.md:5, context-essentials.md:8, anti-drift.md §Propose-before-pour, ARCHITECTURE.md:23 | `anti-drift.md` (prose) + `CLAUDE.md:5` (anchor) — outros referenciam |
| Architecture "consumer-only" block | CLAUDE.md:18-26, README.md:15-21, ARCHITECTURE.md:7-25 | `ARCHITECTURE.md` canônico — CLAUDE/README apontam |
| Build antes QA | content/aulas/CLAUDE.md:1, context-essentials.md:10, metanalise/CLAUDE.md §QA | `content/aulas/CLAUDE.md` canônico para aulas |
| QA 1 slide/gate | aulas/CLAUDE.md:7, qa-pipeline.md:8, metanalise/CLAUDE.md:52 | `.claude/rules/qa-pipeline.md` canônico |
| KBP-23 First-turn | anti-drift.md prose + known-bad-patterns.md pointer | OK (sem conflito) |
| PMIDs ~56% erro | content/aulas/CLAUDE.md:6, design-reference.md, AGENTS.md | `design-reference.md` canônico para aulas; AGENTS.md mantém pra Codex/Gemini |

---

## Execution Batches

Ordem: menor risco/maior verdade → maior impacto. Cada batch pode ser aprovado/rejeitado independente.

### **Batch 1 — Doc↔Reality reconciliation (LOW risk, HIGH truth) [~45 min]**

Fix doc drift sem tocar runtime. Pure string surgery ancorada em file:line.

**Items:**

1. **CLAUDE.md:61** — substituir `"(config em .claude/settings.local.json)"` por `"(config hook em .claude/settings.json; overrides locais em .claude/settings.local.json)"`. Motivo: factual, minimal.

2. **README.md:139** — idem (mesma mentira). Mesmo fix.

3. **docs/ARCHITECTURE.md** — 7 edits distintos:
   - `:27` `(8)` → `(9)` e adicionar `sentinel`, `systematic-debugger` na tabela; remover linha `:40 notion-ops` (deletado S215).
   - `:50` — substituir `"8 guards: secrets · pause · generated · product-files · plan-exit · bash-secrets · bash-write · lint-before-build"` por lista real: `"guard-secrets · guard-write-unified · guard-read-secrets · guard-bash-write · guard-secrets (bash) · allow-plan-exit · guard-lint-before-build · guard-research-queries · guard-mcp-queries"`.
   - `:52` — remover `build-monitor`, `cost-breaker`; manter `chaos-inject-post`, `model-fallback-advisory`, `lint-on-edit`; adicionar `nudge-checkpoint`, `coupling-proactive`, `post-bash-handler`, `post-global-handler`.
   - `:53` — substituir `"crossref-check · detect-issues · chaos-report · hygiene · scorecard · notify"` por `"stop-quality (merged crossref+detect+hygiene) · stop-metrics (merged scorecard+chaos-report) · stop-notify · tools/integrity"`.
   - `:62` — reconciliar "31 hooks" com count real (contagem após Batch 1).
   - `:64` — `"Config: .claude/settings.local.json"` → `"Config: .claude/settings.json"`.
   - `:90` — remover linha `cost-circuit-breaker.sh` (não existe); marcar L3 como "removido" ou replanejar.
   - `:93` — remover `chaos-inject.sh`, `stop-chaos-report.sh` (não existem). Manter só `chaos-inject-post.sh`.
   - `:209-213` — atualizar counts: `settings.local.json # Local overrides (permissions only)`, `rules/ (5)` (não 10), `skills/ (18)` (não 20), `agents/ (9)` (não 8), `hooks/ (count real)`.

4. **README.md:25** — remover `notion-ops` da lista de subagents ativos (wrong since S215).

5. **.claude/hooks/README.md** — 2 operações:
   - Remover 11 scripts phantom (ver Finding 2 da matriz).
   - Adicionar seções/menções para 10 scripts existentes não documentados.
   - Anexar nota: "stop-quality.sh merged crossref+detect+hygiene (S??); stop-metrics.sh merged scorecard+chaos-report (S??)."

6. **wiki/topics/sistema-olmo/wiki/concepts/agent.md** — remover referência a notion-ops.

7. **AGENTS.md** — 3 operações:
   - Adicionar header explícito: `"⚠️ Claude Code NÃO lê este arquivo. Consumer: Codex CLI + Gemini CLI (convenção própria)."`
   - Linha 65: remover referência a `memory/patterns_adversarial_review.md` (não existe — substituir por anti-drift inline ou delete).
   - Linha 9: esclarecer "READ-ONLY" aplica-se a Codex/Gemini, não bloqueia Claude Code.

**Por que deletar > adaptar?**
Refs fantasma em ARCHITECTURE.md não podem ser "adaptadas" (os scripts não existem; adaptar seria inventar). Linhas inteiras saem. notion-ops: agent deletado há 15 sessões; manter referência é escolha ativa de mentir.

**Impacto em memória/governança/confiabilidade:**
- Memória: 0 kB delta (edits pequenos em docs, não reduz always-on).
- Governança: elimina ~20 referências mortas em 5 arquivos. Primeira fonte consultada (ARCHITECTURE.md) passa a refletir realidade.
- Confiabilidade: subagent invocations deixam de falhar por chamar `notion-ops` assumindo que existe.

**Verification:**
- `grep -rn "notion-ops" .` — retorna apenas CHANGELOG histórico + plans archive.
- `grep -rn "guard-pause\|guard-generated\|guard-product-files\|build-monitor\|cost-circuit-breaker\|momentum-brake-arm\|stop-crossref-check\|stop-detect-issues\|stop-chaos-report\|stop-hygiene\|stop-scorecard" .claude/hooks/README.md` — retorna 0.
- `grep -n "settings.local.json" CLAUDE.md README.md docs/ARCHITECTURE.md` — apenas quando contexto correto (overrides, não hooks).

**Risk:** LOW. Zero código tocado. Todas edits são doc-string-surgery. Rollback trivial por git revert.

---

### **Batch 2 — Memory de-duplication + owner canonization (LOW risk, HIGH governance)  [~30 min]**

Reduzir superfície de regras duplicadas. Cada regra ganha owner canônico declarado.

**Items:**

1. **"Proponha, espere OK, execute" canonization:**
   - `anti-drift.md §Propose-before-pour` permanece prose canônica.
   - `CLAUDE.md:5` permanece anchor (primacy).
   - `docs/ARCHITECTURE.md:23` — substituir prose por `"Regra: ver anti-drift.md §Propose-before-pour."` (pointer).
   - `.claude/context-essentials.md:8` — permanece (compaction-survival legítimo).

2. **`.claude/context-essentials.md` slim:**
   - Atual: 42 linhas, 6 seções.
   - Proposta: reduzir para ~15 linhas contendo APENAS o que é session-survival específico e NÃO está em CLAUDE.md: scripts reais a usar (gemini-qa3.mjs, build), decisions keys (Living HTML = source of truth, npm run build command), pending plan reminders. Remover regras generales (Antifragile, Curiosidade, Propose-OK — já em CLAUDE.md + anti-drift).
   - Renomear para deixar escopo claro: `compaction-survival-kit.md` (opcional, nice-to-have).

3. **KBP-26 prose inline extraction:**
   - Atual `known-bad-patterns.md:86-89`: 4 linhas de prose descrevendo CC 2.1.113 bug.
   - Proposta: reduzir a pointer: `## KBP-26 CC permissions.ask broken in 2.1.113 → .claude/BACKLOG.md #34 + .claude/plans/archive/S227-backlog-34-architecture.md`
   - Prose migra para o plan (se já não está lá).

4. **AGENTS.md deduplication:**
   - Seção "Quick Commands" (linhas 11-42): 70% overlap com scripts já acessíveis via skills (`janitor`, `docs-audit`, `review`). Reduzir a referências por skill name em vez de comandos literais.
   - Seção "Coauthorship" (linhas 101-104): keep — não duplica CLAUDE.md.

5. **`content/aulas/metanalise/CLAUDE.md` §QA Pipeline DEMOTE:**
   - Atual: 90 linhas, §QA Pipeline (estados + gates) ocupa ~20 linhas.
   - Proposta: extrair §QA Pipeline para skill nova `aulas-qa-pipeline` OU merge em `qa-pipeline.md` (já existe como rule). Manter em metanalise/CLAUDE.md apenas pointer.
   - **Decisão requerida:** skill vs rule? qa-pipeline já é rule — merge nela é caminho natural.

6. **Rules overlap audit `slide-rules.md` vs `design-reference.md`:**
   - Read ambos (não feito neste plan — exigiria mais context).
   - Se overlap >30%, merge um no outro.
   - Se overlap <30%, documentar boundary.
   - **Parking:** defer até revelar overlap real.

**Por que deletar > adaptar?**
Regras duplicadas não têm custo zero: cada instância pode divergir em manutenção. `context-essentials.md` foi criado S82 pós-compaction loss; hoje CLAUDE.md cobre 70% do mesmo conteúdo. Manter overlap = aceitar drift silencioso entre os dois.

**Impacto:**
- Memória always-on: `context-essentials.md` 42→15 linhas = ~1kB delta por session (reinjected post-compact).
- Governança: regra "Proponha OK" passa a ter 1 owner canônico + 3 pointers em vez de 4 versões concorrentes.
- Confiabilidade: KBP-26 volta a obedecer o formato que KBP-16 canoniza.

**Verification:**
- `wc -l .claude/context-essentials.md` — ~15 linhas.
- `grep -c "Proponha, espere OK" anti-drift.md` — >0; mesma busca em outros 3 arquivos — todos pointer.
- KBP-26 no known-bad-patterns.md — formato idêntico aos outros KBPs.

**Risk:** LOW. Edits em docs, possível merge em rule. Rollback via git.

---

### **Batch 3 — Runtime surface reduction (MEDIUM risk) [~45 min]**

Eliminar módulos Python sem consumer real. Decidir ModelRouter teatro.

**Items:**

1. **`agents/core/smart_scheduler.py` DELETE (309 li):**
   - Evidence: grep em todos `.py` confirma 0 imports. Nunca instanciado.
   - Alternativa considerada: adaptar para ser consumido por AutomationAgent (budget/cache helper). Rejeitada: 309 linhas para feature que AutomationAgent não demonstrou precisar em runtime atual; se precisar depois, YAGNI.
   - Ação: `git rm agents/core/smart_scheduler.py`.

2. **`skills/efficiency/local_first.py` DELETE:**
   - Python skill root `skills/` (não `.claude/skills/`) sem consumer. Pasta `skills/` em root é legado.
   - Ação: `git rm -r skills/` se pasta inteira órfã (verify primeiro).

3. **`agents/core/database.py` INVESTIGATE:**
   - Não confirmado órfão. Ler e decidir.
   - Se órfão → DELETE. Se consumido por fixtures/tests → KEEP.
   - Action item: não delete sem leitura.

4. **ModelRouter decision (BACKLOG #42 resolução):**
   - Estado: ModelRouter instanciado, `resolve()` chamado, `_resolved_model` key escrito, nenhum consumer lê. 2 opções:
     - **A) Fix teatro:** `AutomationAgent.execute()` lê `task.get("_resolved_model")` e usa como hint para LLM call. Implica touching AutomationAgent lógica.
     - **B) Delete teatro:** remover ModelRouter, routing block em orchestrator, `_resolved_model` key. ModelRouter = ~100 li deletadas.
   - **Recomendação adversarial: B (delete).** Justificativa: ModelRouter era antifragile-in-theory; em 6 sessões não foi wired. Build effective agents (Anthropic): "minimize surface, prove consumer before retain". Se Lucas decide depois que quer model routing real, rewrite com consumer claro.
   - **Decisão requerida do user.**

5. **`settings.local.json` cleanup:**
   - Remover linha 6 (stale S226 mv).
   - Remover linhas 7-8 (redundant com settings.json `Bash(*)`).
   - Remover linha 4 (`Agent` duplicado).
   - Manter linha 5 (`Bash(bash tools/integrity.sh)` — se não coberto por settings.json allow).
   - Resultado: ~4 linhas vs 12 atuais.

6. **`ecosystem.yaml` skills reconciliation:**
   - Decidir: (a) declarar todas 18 skills em ecosystem.yaml; ou (b) ecosystem.yaml declara apenas Python-invocable skills (orchestrator-visible), CC-only skills por filesystem convention.
   - **Recomendação: (b).** Justificativa: ecosystem.yaml é config do runtime Python; CC skills são autoridade do filesystem `.claude/skills/`. Ambas superfícies com ownership claro.
   - Ação: editar ecosystem.yaml para declarar escopo explícito no header.

**Por que deletar > adaptar?**
SmartScheduler tem 0 prova de necessidade em 6+ sessões. ModelRouter é pior: código ativo simulando comportamento que não existe. Teatro arquitetural é mais enganoso que ausência — leitor presume que routing funciona porque vê o código.

**Impacto:**
- Runtime: ~400-500 linhas Python removidas. Zero comportamento perdido (nada disso era consumido).
- Governança: BACKLOG #42 resolvido.
- Confiabilidade: leitor do código não mais presume features que não existem.

**Verification:**
- `ruff check .` + `mypy agents/` — clean pós-delete.
- `pytest tests/` — green (nenhum test desses módulos).
- `python -c "from orchestrator import build_ecosystem; build_ecosystem()"` — mesma saída antes/depois (verify via log diff).

**Risk:** MEDIUM. Delete de código requer confirmation de zero consumers. ModelRouter decision requer user input.

---

### **Batch 4 — Plans audit (LOW risk) [~15 min]**

**Items:**

1. **`ACTIVE-S225-SHIP-roadmap.md` → ARCHIVE:**
   - Evidence: S229 executou "daily exodus" não "Docling Phase 2" como o plano prescreve. S226/S227/S228 deliverables divergiram. Plano não acompanhou execução.
   - Alternativa considerada: rewrite o plano para refletir S229. Rejeitada: roadmaps de campanha são snapshots de intenção passada; reescrever retroativamente é falsificação documental. Melhor arquivar e escrever novo roadmap S230+ pós-aprovação deste plan.
   - Ação: `git mv .claude/plans/ACTIVE-S225-SHIP-roadmap.md .claude/plans/archive/S225-SHIP-roadmap.md`.
   - Após ARCHIVE: notar em CHANGELOG S230 que ACTIVE-S225 foi superseded. Futuro roadmap (se precisar) parte do estado atual.

2. **`ACTIVE-S227-memory-to-living-html.md`:**
   - KEEP ACTIVE (steps 1-6 ainda executáveis, problema ainda existe: agent-memory loading always-on).
   - Renomear header interno: remover "S226 — Migrar" → "S227+ — Migrar". Refletir reprogramming real.
   - Sinalizar em HANDOFF como next P1 concreto.

3. **S229 archive plan reference in HANDOFF:**
   - HANDOFF atual aponta `S229-slim-round-3-daily-exodus.md` — manter (HANDOFF S230 indica leitura).

**Por que arquivar > rewrite?**
Falsificação documental é pior que plano datado. Archive preserva contexto histórico com timestamp; rewrite retroativo destrói timestamp.

**Impacto:**
- Governança: plans ACTIVE representam apenas trabalho realmente acionável (2 → 1).
- Memória: HANDOFF não mais aponta para roadmap stale como orientação.

**Verification:**
- `ls .claude/plans/ACTIVE-*.md` — apenas `ACTIVE-S227-memory-to-living-html.md`.
- HANDOFF.md não referencia ACTIVE-S225.

**Risk:** LOW.

---

### **Batch 5 — Multimodel integration gate (DEFERRED) [scope varies]**

Não executar até Batches 1-4 fecharem. Pré-requisito: topologia limpa antes de adicionar superfícies.

**Framework obrigatório para cada proposta multimodel:**

| critério | requisito |
|---|---|
| **objetivo** | 1 frase declarativa: "o modelo X resolve Y que Claude Code não resolve bem" |
| **trigger** | condição objetiva/automática (não "quando parecer útil"). Ex: `/research-audit` skill invoke, ou Git pre-commit hook |
| **artefato** | arquivo concreto produzido (markdown, JSON, diff patch) com path canônico |
| **custo** | $/invocation ou token budget monthly cap |
| **risco** | blast radius: read-only? editing? shared state? |
| **eval** | como medimos que está entregando. Ex: "redução de FP rate em review 30% → 10%" |
| **rollback** | 1-line plan para desativar em 5 min |

**Candidatos atualmente no ecossistema:**

1. **Codex CLI (GPT-5.4) via plugin `codex:rescue`, `codex:setup`:**
   - Plugin já instalado. AGENTS.md define role "VALIDAR".
   - **Gap:** sem trigger claro (ad-hoc). Sem eval declarado. Sem budget cap.
   - Ação futura: formalizar trigger (ex: "pre-PR review automático" via hook pre-commit), registrar $ gasto, definir target FP rate.

2. **Gemini CLI:**
   - Não é plugin Claude Code. É CLI externo ($0 via OAuth).
   - Usado em QA pipeline (`gemini-qa3.mjs`) com trigger claro: `npm run qa`.
   - **Status:** já tem trigger, artefato, eval. Budget implícito (OAuth = $0). OK — único exemplo que passa o gate hoje.

3. **Antigravity:**
   - Não presente. User menciona como candidato.
   - **Recomendação:** NÃO incorporar agora. Artifacts + async multi-superfície exige custo de setup alto; sem use case concreto, é feature-shopping.
   - Trigger de reavaliação: se Lucas produzir 3+ artifacts grandes em 1 semana que exigiriam sandboxing ou reprodutibilidade multi-modal.

4. **ChatGPT "VALIDAR" (CLAUDE.md tool assignment):**
   - Sem plugin. Menção aspiracional na tabela de tools.
   - **Recomendação:** remover ou deflate. `ChatGPT=VALIDAR` na tabela de CLAUDE.md não é operacional — nenhum hook, nenhum trigger.
   - Ou: substituir por `Codex=VALIDAR` (que tem plugin real) e marcar ChatGPT como "manual conversational only".

**Por que deferir?**
Multimodel antes de topologia limpa amplifica confusão: mais superfícies injetando contexto num ecossistema que já tem AGENTS.md órfão, CLAUDE.md com referência errada de hooks, e ARCHITECTURE.md com Mermaid fictício. Primeiro limpar, depois escalar.

**Impacto (quando executado):**
Dependente do escopo específico aprovado.

**Risk:** varia. MEDIUM para Codex formalization; HIGH para Antigravity adoption.

---

### **Batch 6 — Living-HTML migration (BACKLOG #36, from ACTIVE-S227) [DEFERRED]**

Migrar `.claude/agent-memory/evidence-researcher/` (6 arquivos médicos) para Living HTML per-slide.

**Evidence:** ACTIVE-S227 plan descreve steps 1-6. Problema: evidence-researcher carrega always-on medical dossiers que só são relevantes a slides específicos.

**Pré-requisito:** Batches 1-4 fechados. Esta migration toca agent behavior + content/aulas/, pode desestabilizar QA pipeline se feita em ambiente documentalmente inconsistente.

**Ação:** executar seguindo plan S227 após Batches 1-4 verde.

**Risk:** MEDIUM (toca agent memory + per-slide content).

---

## Explicit Deferrals / Defensible Skips

Coisas que este plan NÃO faz, com justificativa:

1. **Não reescrevo HANDOFF ou CHANGELOG com "S230 audit findings" antes da aprovação.** HANDOFF rewrite só após Batches aprovados — evita poluir state-file com proposal que pode ser rejeitada.

2. **Não delete `docs/research/implementation-plan-S82.md` nem verify se existe.** Referenciado em CLAUDE.md:77 e context-essentials.md:41 como roadmap. Se não existe, virá em Batch 1. Se existe mas está stale, separate sessão.

3. **Não audit skills `continuous-learning` e `teaching` triggers fracos.** Identificado mas requer decisão de produto (delete skills ou strengthen triggers). Fora do escopo desta campanha de limpeza estrutural.

4. **Não executo `repo-janitor` subagent.** Poderia encontrar mais órfãos, mas seria scope creep. Campanha focada em findings evidence-backed, não exploração open-ended.

5. **Não toco `docs/research/chaos-engineering-L6.md` ou L6 claims.** ARCHITECTURE.md afirma L6 BASIC — chaos-inject.sh e stop-chaos-report.sh não existem, só chaos-inject-post.sh. Fix parcial em Batch 1 (Mermaid correction). Decisão "deletar L6 completo vs manter só post-inject" = separate triage.

6. **Não reviso o 7-layer antifragile claim em ARCHITECTURE.md:66-94.** HANDOFF mencionou "7-layer claim unaudited" como BACKLOG #45 (P2). Legítimo defer.

7. **Não propongo novos agents.** Hard_fail_condition #6 do user: "Não proponha novos agentes antes de fechar inventário, memória e hooks." Respeitado.

---

## Approval Model

**Recomendação:** aprovar batches independentemente, não em bulk.

- **Tier 1 (pode aprovar agora, risk baixo):** Batch 1 + Batch 2 + Batch 4. ~90 min total. Zero código tocado. 100% doc/config cleanup.
- **Tier 2 (precisa decisão sobre ModelRouter):** Batch 3. Depends on user decision ModelRouter fix-vs-delete.
- **Tier 3 (deferred até Tier 1-2 fecharem):** Batch 5 + Batch 6.

Questão principal ao Lucas: Batch 3, ModelRouter — **fix (A)** ou **delete (B)**?

---

## Verification (end-to-end, per batch)

**Batch 1:**
```bash
# All 11 phantom scripts removed from README
grep -c "guard-pause\|guard-generated\|guard-product-files\|build-monitor\|cost-circuit-breaker\|momentum-brake-arm\|stop-crossref-check\|stop-detect-issues\|stop-chaos-report\|stop-hygiene\|stop-scorecard" .claude/hooks/README.md
# Expected: 0

# notion-ops references gone from active docs
grep -rn "notion-ops" . --include="*.md" | grep -v "CHANGELOG\|archive"
# Expected: 0

# settings.local.json claim corrected
grep -n "settings.local.json" CLAUDE.md README.md docs/ARCHITECTURE.md
# Expected: only contexts about local overrides, not hooks config
```

**Batch 2:**
```bash
wc -l .claude/context-essentials.md  # target: ~15
grep -c "KBP-" .claude/rules/known-bad-patterns.md  # same count, KBP-26 now pointer-only
```

**Batch 3:**
```bash
# Runtime still builds
python -c "from orchestrator import build_ecosystem; e = build_ecosystem(); print(list(e.agents.keys()))"
# Expected: ['automacao']

# No broken imports
ruff check . && mypy agents/ subagents/

# Tests green
pytest tests/

# Orphans gone
test ! -f agents/core/smart_scheduler.py
test ! -d skills/
```

**Batch 4:**
```bash
ls .claude/plans/ACTIVE-*.md  # only ACTIVE-S227
```

---

## Critical Files

**To be modified (Batch 1-4):**
- `CLAUDE.md:61`
- `README.md:25, :139`
- `docs/ARCHITECTURE.md:27, :40, :50, :52, :53, :62, :64, :90, :93, :209-213`
- `.claude/hooks/README.md` (full drift fix)
- `wiki/topics/sistema-olmo/wiki/concepts/agent.md`
- `AGENTS.md:9, :65` + header addition
- `.claude/context-essentials.md` (slim)
- `.claude/rules/known-bad-patterns.md:86-89` (KBP-26 extract)
- `.claude/settings.local.json` (cleanup)
- `config/ecosystem.yaml` (skills scope declaration)
- `content/aulas/metanalise/CLAUDE.md` (§QA demote)
- `.claude/rules/qa-pipeline.md` (absorb §QA Pipeline from metanalise)

**To be deleted (Batch 3):**
- `agents/core/smart_scheduler.py`
- `skills/` (root dir, if fully orphan)
- Possibly `agents/core/database.py` (pending read)
- Possibly `agents/core/model_router.py` + model routing block in orchestrator (pending user decision)

**To be archived (Batch 4):**
- `.claude/plans/ACTIVE-S225-SHIP-roadmap.md` → `archive/`

---

## Session Metadata

- **Branch:** main (no branch switch needed — scope é cleanup, não feature)
- **Commit granularity:** 1 commit per batch mínimo; sub-commits OK dentro de batch
- **Coauthoring:** `Coautoria: Lucas + Opus 4.7` em cada commit
- **HANDOFF update:** apenas após todos batches aprovados fecharem — evita state-file drift mid-campaign
- **CHANGELOG entry:** 1 bullet por batch em CHANGELOG S230 ao final
