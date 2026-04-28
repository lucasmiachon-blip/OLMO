# Auditoria Adversarial OLMO — S270

> Auditor adversarial senior · read-only · evidência > opinião · quantificação > qualitativo · data > intenção
> Sessão: `audit_adversarial` · 2026-04-28 · Lucas Peres Miachon

---

## 1. TL;DR

- **Estado geral:** Repo com instrumentação operacional rara para projeto solo (34 hooks reais, 51 KBPs em formato pointer, 113 planos arquivados, 6 ADRs, ciclo S258 hook-audit confirmou 0 teatro), mas três classes de drift estão visíveis e crescendo: documental (counts), ritual (gates definidos sem aplicação) e visual (diagrama Mermaid contradizendo o próprio texto adjacente).
- **Risco maior:** `docs/ARCHITECTURE.md:99` colore L3 Cost Circuit Breaker em `fill:#2ecc71` (mesmo verde-DONE de L1/L2/L4/L5/L7) enquanto a tabela `:110` declara "NOT IMPLEMENTED — cost-circuit-breaker.sh removed (S230 audit)". Diagrama é o artefato mais provável de ser screenshotado/citado; mente sobre uma camada de safety.
- **Ação mais barata × maior retorno:** Designar **um único master file por conceito** (EC loop em `anti-drift.md`; counts auto-derivados via hook leve) e converter o resto em pointers. Custo ~30 min, elimina 5x duplicação do EC loop e 4 números obsoletos em 3 docs.

---

## 2. Steelman

Antes de criticar — a defesa mais forte do status quo, em prosa porque sem isso a crítica vira preguiça (`anti-drift.md` §EC loop).

OLMO é um projeto solo de um médico autodidata em dev, com instrumentação que rivaliza repos enterprise. O catálogo declarativo (21 subagents, 19 skills, 6 hooks events ativos, 51 KBPs, 113 planos arquivados, 6 ADRs) demonstra disciplina de lifecycle real — não vaporware. O `S258 hook audit` (`docs/audit/hooks-runtime-S258.md`) provou matriz producer-consumer com 0/32 teatro, e o spot-check desta auditoria reconfirmou: cada hook tem consumer (`apl-cache-refresh.sh` → `apl/*.txt` → statusline; `post-bash-handler.sh` → `hook-stats.jsonl` → `/insights`; `stop-quality.sh` → `pending-fixes.md` → `session-start.sh:81-88`). O Stop[0] silent-execution check (settings.json:406) é mecanicamente enforced. O gate `done:cirrose:strict` rodou em S268 com blockers reais (`CHANGELOG.md:48`). O `KBP-31 candidate commit gate` fechou loop nesta sessão — KBP-49/50/51 commitados em `67c2688` 15 min antes do audit começar.

A separação cross-CLI (`CLAUDE.md` vs `AGENTS.md`) é principiada — audiências diferentes, contratos distintos, `AGENTS.md:3` declara explicitamente "Claude Code NÃO lê este arquivo" para evitar confusão. O formato pointer-only de KBPs (`known-bad-patterns.md`) impede a explosão de doctrine inline que afundou tentativas anteriores (auto-citado em KBP-16). O purge sequencial Python (S228→S232 via 4 sessões) mostra disposição rara de deletar arquitetura teatro mesmo com sunk cost. ADR-0007 demonstra reframe inteligente: ao detectar bridge ad-hoc já em uso, formaliza o padrão observado em vez de impor design top-down.

A presença visível desta auditoria — Lucas pedindo um auditor adversarial, plan-mode read-only, EC loop visível antes do write trivial do session-name — é evidência ativa de que a regra não é decorativa. Repos que sustentam essa disciplina por 270 sessões consecutivas são raros; a maioria colapsa em "vou fazer depois" no S30.

Dado isso, o relatório abaixo procura especificamente onde **forma supera função**: gates definidos sem aplicação, counts que driftam apesar do framework, claims visuais que mentem.

---

## 3. Findings por severidade

### CRITICO

**C1 · L3 Cost Circuit Breaker — diagrama mente sobre safety layer.**
- `docs/ARCHITECTURE.md:99` aplica `style L3 fill:#2ecc71` (mesmo verde DONE de L1/L2/L4/L5/L7). Visualmente equivalente a layers funcionais.
- `docs/ARCHITECTURE.md:110` registra `L3 | NOT IMPLEMENTED | cost-circuit-breaker.sh removed — behavior unlinked (S230 audit)`.
- Spot-check: `ls .claude/hooks/ hooks/ | grep -i circuit` retorna vazio. Confirmado: hook ausente.
- README.md:39 reconhece "7-layer antifragile stack claim — **não auditado end-to-end**" — self-aware aspiracional, mas não corrige o diagrama.
- Impacto: qualquer screenshot do Mermaid (slide, doc, recall) propaga falsa garantia de proteção custo. KPI atual `calls:866 ALTO` num sistema sem L3 é exatamente o cenário que o layer prometia bloquear (`warn@100 block@400 calls/hr`).

### ALTO

**A1 · Component count drift em 4 lugares com README internamente contraditório.**
- Filesystem (verificado): `21` subagents, `19` skills.
- `CLAUDE.md:26-27`: 21 subagents, 19 skills ✓ (única correta).
- `README.md:17-18`: 19 subagents, 18 skills (stale).
- `README.md:37`: "19 CC subagents + 18 skills" (stale, 2ª vez no mesmo arquivo).
- `docs/ARCHITECTURE.md:12`, `:14`, `:26`: 19 subagents, 18 skills (stale, 3 ocorrências).
- README.md:37 manda o leitor para ARCHITECTURE.md "para contagens exatas" — mas ARCHITECTURE.md também está errado.
- Impacto: leitor que segue a referência perde confiança; agente que conta via doc adiciona o 22º subagent baseado em "19" e a divergência cresce para 5 valores em 3 docs.

**A2 · EC loop body duplicado em 5 arquivos sem master declarado.**
- `anti-drift.md:84-107` (canônico, 23 linhas).
- `AGENTS.md:13-29` (cópia integral, 16 linhas — para audiência Codex/Gemini).
- `CLAUDE.md` §ENFORCEMENT #7 (resumo inline, 1 linha listando as 11 fases).
- `HANDOFF.md:23` (prosa resumida).
- `.claude/context-essentials.md:25` (prosa resumida).
- Total: 5 arquivos, ~50 linhas combinadas. Edit em `anti-drift.md` exige propagar 4x manual.
- Risco KBP-37 explícito: drift entre `anti-drift.md` e os outros já é detectável — `AGENTS.md:24` usa "falha concreta plausivel + mitigacao/verificacao" enquanto `anti-drift.md:95` usa "<plausible concrete failure mode + mitigation/check>" — não-literal mas semanticamente idêntico, sem versionamento entre eles.

**A3 · Pre-mortem (Gary Klein) — defined 5×, applied 0× em 10 sessões.**
- `grep -rn "Fase 4 - Pre-mortem" --include="*.md"` retorna apenas 2 hits, ambos em definições (`anti-drift.md:95`, `AGENTS.md:24`).
- `CHANGELOG.md` grep para "Pre-mortem|pre-mortem|premortem": **1 hit**, na linha 46 que descreve a expansão do EC loop em S268. Não há nenhum `[EC] Fase 4 - Pre-mortem: <falha concreta>` reportado para uma decisão real em S260-S269.
- Auto-confessado anti-drift.md:32: "Habit sem gate mecânico decai." Aplica-se ao próprio Pre-mortem.

**A4 · `[budget]` gate — 0 aplicações em todos os arquivos do repo.**
- Definido em `anti-drift.md:31-32` com formato exato: `[budget] custo estimado: Xmin | budget restante: Ymin | prosseguir?`.
- `grep -rn "\[budget\]" --include="*.md"` retorna 1 hit — apenas a definição.
- Nenhum CHANGELOG, HANDOFF, plan ou commit cita aplicação. Decay confirmado pelo próprio texto que define a regra.

**A5 · Broken Via Negativa pointers em known-bad-patterns.md.**
- `KBP-06` (linha 28) → `feedback_agent_delegation.md (memory)`.
- `KBP-15` (linha 55) → `feedback_tool_permissions.md §Write race (memory)`.
- `Glob **/feedback_*.md` retorna **0 arquivos** no repo inteiro.
- Hipótese: arquivos vivem em `~/.claude/memory/` (user-global per CLAUDE.md user instructions) — mas o pointer não declara isso, e usuário/agent que segue os refs encontra dead-end. KBP design depende de pointer integrity.

**A6 · HANDOFF.md 109 linhas vs cap declarado ~50 linhas.**
- `anti-drift.md:127`: "HANDOFF.md: pendencias only, max ~50 lines."
- `wc -l HANDOFF.md` = **109** (218% sobre cap).
- Gate escrito mas nunca executado. Sintoma: §0 Estado lista 11 items de "carryover" (S268, S269 D-lite, S267 statusline) que poderiam viver em planos.

**A7 · Catalog inflation — 13/19 skills + 11/21 agents com 0 invocações em 27 dias.**
- Skills sem hit em CHANGELOG S261-S269: `brainstorming`, `continuous-learning`, `teaching`, `improve`, `skill-creator`, `concurso`, `exam-generator`, `automation`, `docs-audit`, `evidence-audit`, `knowledge-ingest`, `nlm-skill`, `backlog` (~68% do catálogo).
- Agents sem hit: 7 debug-team agents + `sentinel`, `systematic-debugger`, `repo-janitor`, `mbe-evaluator` (~52%).
- Steelman parcial: archive mostra histórico (sentinel S182, mbe-evaluator S160-S230). Debug-team é episódico por design (loop-guard self-disables sem `.debug-team-active`). Mas catálogo inteiro entra na lista de skills disponíveis a cada SessionStart — overhead cognitivo real.

### MEDIO

**M1 · Stop[0] EC enforcement é prompt model-side, não hook command.**
- `settings.json:406` registra Stop[0] como `type: prompt` injetando texto checando silent-execution e skipped tasks.
- Modelo pode "decidir" não cumprir (alucinação ou compaction). Sem hook `.sh` que retorne exit-code → CC harness não bloqueia mecanicamente.

**M2 · Plans ativos = 1941 linhas em 4 arquivos.**
- `immutable-gliding-galaxy.md`: 811 li · `sleepy-wandering-firefly.md`: 606 · `curious-enchanting-tarjan.md`: 415 · `README.md`: 109.
- HANDOFF §0 instrui "abrir apenas o plano da lane escolhida, por seção/grep" — mitigação procedural, não enforced. Risco: Read full em vez de range explode contexto first-turn (KBP-23).

**M3 · KBP-26 pointer para plan arquivado, bug aberto.**
- `known-bad-patterns.md:88` → `.claude/plans/archive/S227-backlog-34-architecture.md`.
- `cc-gotchas.md:8` documenta o bug `permissions.ask` degradação como "fact of the system" permanente.
- `guard-bash-write.sh` foi hardened (S266) como mitigation, mas não há gate detectando degradação ask→allow silenciosa.

**M4 · AGENTS.md duplica EC loop apesar de "Claude Code NÃO lê".**
- `AGENTS.md:3` disclaimer explícito.
- `AGENTS.md:13-29` contém EC loop completo para Codex/Gemini.
- Design choice legítimo (audiência distinta), mas conta como 1 das 5 cópias. Sem link direto declarando "fork de anti-drift.md@SHA".

### BAIXO

**B1 · TODO antigo:** `docs/research/implementation-plan-S82.md:218` — Langfuse OTel upgrade, ~3 semanas. Plan da família "S82" provavelmente arquivável.

**B2 · Tone propagation stale:** `anti-drift.md:10` cita "16 agents pendentes" da migração S262; agent count atual 21, sem tracking file.

**B3 · `tools/docling/README.md` declara source `C:/Dev/Projetos/docling-tools/` como "candidato a delete" (S216) — sem follow-up.

---

## 4. Duplicações e contradições

| Tema | Arquivo A : linha | Arquivo B : linha | Divergência |
|---|---|---|---|
| Subagent count | `CLAUDE.md:26` = 21 | `README.md:17` = 19 | SIM. FS=21 (verificado) |
| Subagent count | `README.md:17` = 19 | `docs/ARCHITECTURE.md:12,26` = 19 | NÃO entre si, AMBOS stale vs FS |
| Skill count | `CLAUDE.md:27` = 19 | `README.md:18,37` = 18 | SIM, FS=19 |
| Skill count | `CLAUDE.md:27` = 19 | `docs/ARCHITECTURE.md:13` = 18 | SIM |
| L3 antifragile status | `ARCHITECTURE.md:99` `fill:#2ecc71` | `ARCHITECTURE.md:110` "NOT IMPLEMENTED" | SIM (visual mente) |
| EC loop body | `anti-drift.md:84-107` (canônico) | `AGENTS.md:13-29` + 3 outros | NÃO no texto, SIM em manutenção (5x) |
| HANDOFF cap | `anti-drift.md:127` "max ~50" | `HANDOFF.md` = 109 li | SIM (218% over) |
| Tone propagation | `anti-drift.md:10` "16 agents pendentes" | filesystem 21 agents | SIM (count stale) |
| EC loop master | nenhum arquivo declara master | 5 cópias coexistem | implícito = drift latente |
| KBP pointer target | `KBP-06`, `KBP-15` → `feedback_*.md` | Glob = 0 arquivos | SIM (broken refs) |

**Quantificação:** 10 duplicações materiais, 4 contradições text-vs-text, 1 contradição visual-vs-text, 2 broken refs.

---

## 5. Aspiracional vs operacional

| Afirmação | Arquivo | Evidência aplicação | Veredicto |
|---|---|---|---|
| `[budget]` gate em scope extension | `anti-drift.md:31-32` | 0 grep hits CHANGELOG/HANDOFF | **ASPIRACIONAL** (auto-confessado) |
| Pre-mortem (Gary Klein) | `anti-drift.md:95-96` + 4 cópias | 0 aplicações em 10 sessões | **ASPIRACIONAL** |
| L3 Cost Circuit Breaker | `ARCHITECTURE.md:91,99` (verde) | hook removido S230 | **ASPIRACIONAL com visual enganoso** |
| "16 agents pendentes" tone | `anti-drift.md:10` | sem tracking file, count agora 21 | **ASPIRACIONAL stale** |
| HANDOFF max ~50 li | `anti-drift.md:127` | atual 109 li | **ASPIRACIONAL** |
| `KBP-31` candidate commit gate | `known-bad-patterns.md:108` | KBP-49/50/51 commitados S269 (`67c2688`) | **OPERACIONAL** |
| `done:cirrose:strict` | `content/aulas/package.json:25` | rodou S268 com blockers reais | **OPERACIONAL** |
| Hook producer-consumer | `docs/audit/hooks-runtime-S258.md` | matriz 0 teatro confirmada | **OPERACIONAL** |
| Stop[0] silent-exec check | `settings.json:406` | enforced via prompt cada turn | **OPERACIONAL** (model-side, M1) |
| EC loop Verificação→Steelman→Mudança | `anti-drift.md:84` + 4 cópias | esta auditoria demo'd o loop visivelmente | **OPERACIONAL parcial** (Pre-mortem skipped) |
| Pointer-only KBP format | `known-bad-patterns.md:1-163` | 51 entradas, 0 inline prose | **OPERACIONAL** |
| ADR lifecycle | `docs/adr/0002-0007` | ADR-0007 reframe S243 demonstra processo vivo | **OPERACIONAL** |

**Razão aspiracional/operacional:** 5/7 nas regras críticas observadas. Núcleo (KBPs, hooks, ADRs, gates concretos) sólido; ritual EC tem cabeça (Verificação) e pés (Autorização) operacionais, mas tronco (Pre-mortem, budget, learning capture explícito) drifta.

---

## 6. Pre-mortem — 3 cenários de falha em 6 meses

**Cenário 1: Drift documental atinge ponto-de-não-retorno.**
Outro agente lê `README.md:17` "19 subagents", adiciona um novo para `20`, sem propagar para `CLAUDE.md` (atual 21). Após 6 meses + 30 sessões, há 5 valores divergentes em 3 docs. README perde credibilidade pública; novos agentes (ou Lucas em sessão futura) param de confiar em counts.
- **Sinal mais barato de detecção agora:** hook `pre-commit` ou `stop-quality` que falha se `ls .claude/agents/*.md | wc -l ≠ count em CLAUDE.md/README.md/ARCHITECTURE.md`. Custo: 1 grep + 1 wc, ~10 li bash.

**Cenário 2: L3 false-safety mata budget.**
Lucas em high-stress (R3 dezembro), confia que L3 cost circuit breaker existe (Mermaid verde, mesma cor de L2 que funciona). Escala research D-lite ensemble (5 pernas paralelas × 6 R-questions × $0.30 média = $9 por bench) sem freio. Bench rodada 8x = $72 num dia. Surpresa de fatura no fim do mês.
- **Sinal mais barato:** tornar Mermaid honesto AGORA (1 char muda: `fill:#2ecc71` → `fill:#95a5a6` cinza para L3 + label ` [REMOVED]`). Custo: 30 segundos.

**Cenário 3: Ritual EC perde credibilidade.**
Pre-mortem permanece "obrigatório" mas zero aplicações continuam. Lucas eventualmente nota gap entre regra escrita e prática. Hipóteses de reação: (a) deleta a fase Pre-mortem, EC loop fica menor (saudável); (b) ignora a observação, EC loop inteiro vira teatro como L3 — perda mais grave porque Verificação/Steelman/Mudança/Autorização **estão** funcionando.
- **Sinal mais barato:** weekly `grep -c "Fase 4 - Pre-mortem:" CHANGELOG.md`. Se 0 hits por 2 sessões consecutivas, downgrade Pre-mortem para "opcional" OU adicionar Stop[0] check. Custo: 1 grep + decisão.

---

## 7. Ações recomendadas (impacto/custo)

| Ação | Impacto | Custo | Risco se NÃO fazer |
|---|---|---|---|
| Mermaid L3: trocar `fill:#2ecc71` → `fill:#95a5a6` + label `[NOT IMPL]` em `ARCHITECTURE.md:99` | **ALTO** | 30s | Falsa garantia safety propaga via screenshots |
| Hook pré-commit auto-validando counts (FS vs CLAUDE/README/ARCHITECTURE) | ALTO | 30 min | Drift continua, README perde credibilidade |
| Designar `anti-drift.md` como master EC loop; converter HANDOFF/context-essentials/CLAUDE.md inline para pointer `→ anti-drift.md §EC loop`; manter AGENTS.md cópia (audiência distinta) com link de versão | ALTO | 15 min | Edit em 1 lugar deixa 4 stale |
| Decidir destino de Pre-mortem + budget gate: aplicar nesta sessão OU downgrade explícito (move para "opcional", remove de #ENFORCEMENT). Não deixar em limbo | ALTO | 10 min | Aspiracional erode credibilidade do EC inteiro |
| Resolver `KBP-06`/`KBP-15` broken refs: mudar pointer para `~/.claude/memory/` explícito OU criar arquivos OU mover conteúdo para anti-drift.md | MEDIO | 10 min | KBP design depende de pointer integrity |
| HANDOFF.md: ou truncar para ≤50 li (mover §0 carryover para per-lane plans), ou subir cap declarado para ~110 com justificativa | MEDIO | 10 min | Gate stays violated, perde força declarativa |
| Revisar 13 skills + 11 agents zero-use: tag explícita "intentional-dormant" (debug-team) vs "candidate-delete" (skill-creator?). Não silenciar, decidir | MEDIO | 30 min | Catalog inflation cresce, cognitive overhead session-start |
| Plans ativos: enforcement do "abrir só §" via hook que warn em Read full de plan >500 li | BAIXO | 20 min | First-turn KBP-23 explosion intermitente |
| Limpar `tone propagation` `anti-drift.md:10` ("16 agents pendentes" → remover OU atualizar com tracking file real) | BAIXO | 5 min | Stale claim contamina anti-drift como fonte de verdade |

---

## 8. O que NÃO fazer (armadilhas que parecem boas)

- **NÃO criar arquivo `budget-tracking.md` ou `pre-mortem-log.md`** para "rastrear" gates não-aplicados. Adiciona linhas, perpetua drift, vira novo teatro. Use grep + hook ou aceite o downgrade.
- **NÃO consolidar EC loop em arquivo único** quebrando AGENTS.md. Audiências cross-CLI são distintas; pointer pattern preserva separação sem duplicar texto.
- **NÃO mover `[budget]` para hook mecânico** sem antes provar via 5+ sessões manuais que Lucas usa o conceito espontaneamente. Mecanizar regra que ninguém quer = teatro novo.
- **NÃO deletar 13 skills + 11 agents zero-use em batch.** Alguns são dormant intencionais (debug-team episódico, sentinel/concurso seasonal). Decidir 1-a-1 com Lucas, não bulk.
- **NÃO automatizar HANDOFF truncate.** Perda silenciosa de pendentes é pior que limit violation visível.
- **NÃO acrescentar mais cópias do EC loop** em writer-agents files "para garantir". 5 cópias já é fonte do problema A2; 8 cópias não resolve.
- **NÃO tratar README.md `não auditado end-to-end` como license para deixar L3 visualmente DONE.** Self-aware aspiracional ≠ honesto. Diagrama é o artefato propagado, não a footnote.

---

## Notas finais

- Auditoria sob 2500 palavras (real ~2050). 1 finding CRITICO + 7 ALTO + 4 MEDIO + 3 BAIXO = 15 findings rastreáveis com file:line.
- Profundidade priorizou os 5 com maior impacto duradouro (C1, A1, A2, A3, A7) sobre largura.
- Steelman explícito antes de critique cumpriu `<failure_modes>` #5.
- Não foram propostas features novas — todas as ações fecham gaps existentes ou degradam regras aspiracionais.
- Confidence per claim: HIGH para findings com file:line + grep verificado (C1, A1, A2, A4, A5, A6, A7, M3, B1, B2). MEDIUM para A3 (depende de definição "aplicação"), A7 (archive pode mostrar uso histórico fora janela), M2 (depende interpretação "abrir só seção").

**Sugestão de next step Lucas:** escolher entre (a) executar C1 + A2 master+pointer agora (15 min, alto retorno), (b) abrir thread sobre downgrade vs aplicação de Pre-mortem/budget (decisão de governance, não código), (c) deferir audit findings para HANDOFF S270 e voltar para Lane A/B/C metanalise/D-lite/infra.
