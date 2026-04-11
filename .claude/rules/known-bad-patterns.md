---
description: Via Negativa — patterns the agent must NEVER repeat. Fed by /insights.
globs: "**/*"
---

# Known-Bad Patterns (Via Negativa)

> Knowing what NOT to do is more robust than knowing what to do. — Taleb
> Governance: /insights appends. NEVER remove — only mark RESOLVED. Next: KBP-16.

## KBP-01 Scope Creep
Trigger: chains to next step without asking. Lucas: "calma/pare/espere". Cause: helpfulness bias. **→ anti-drift.md §Momentum brake**

## KBP-02 Context Overflow
Trigger: 3+ subagent runs → forgets decisions, repeats questions. Cause: compaction loses conventions. **→ session-hygiene.md §Proactive Checkpoints**

## KBP-03 Agent-Script Redundancy
Trigger: reimplements logic from `content/aulas/scripts/`. Lucas: "tem redundancia com scripts". Cause: agent definition duplicates script. **→ anti-drift.md §Script Primacy**

## KBP-04 QA Criteria From Training Data
Trigger: evaluates slides from general knowledge, not script checks. Lucas: "com os criterios nao da sua cabeca". **→ qa-pipeline.md §0 Pre-Read Gate**

## KBP-05 Batch QA Multi-Slide
Trigger: processes 2+ slides in one invocation. Lucas: "um slide por vez". Cause: throughput over protocol. **→ qa-pipeline.md §1**

## KBP-06 Agent Delegation Without Verification
Trigger: subagent returns empty/"submitted to external tool". Lucas: "verificar antes de lancar". Cause: fire-and-forget. Fix: (1) verify agent type matches task, (2) confirm output capturable, (3) Lucas approval. Never `codex:rescue` for internal review — use `general-purpose` or `sentinel`.

## KBP-07 Workaround Without Diagnosis
Trigger: failure → agent invents alternative instead of diagnosing. Lucas: "nao invente/nao mexe sem autorizacao". Cause: aversion to reporting failure, disguises workaround as pragmatism. **→ anti-drift.md §Failure response**

## KBP-08 API/MCP Substitution
Trigger: /research substitui WebSearch por API/MCP especifica. Output parece OK mas fontes genericas. Lucas: "fez ou nao fez o gemini e perplexity?". Cause: missing API keys don't error. Fix: (1) WebSearch removido de evidence-researcher S126. (2) Pre-flight API key validation. (3) Perna falhou = reportar e pular, NUNCA substituir.

## KBP-09 API Key Tool via MCP — Wrong Execution Path
Trigger: /research Perna 1 (Gemini) ou 5 (Perplexity) lancada via MCP/subagent em vez de Bash/API key. Agente reporta "sem MCP direto" como limitacao. Lucas: "eh para ser via api key". Cause: agente generaliza "pesquisa = MCP" e ignora scripts Bash no SKILL.md. Complementa KBP-08 (substitution vs wrong path). Fix: (1) Tabela Step 2 com coluna "Ferramenta/Executor" (S129). (2) Pre-flight API key check (Step 1.5). (3) Pernas 1/5/6 = orquestrador via Bash, NUNCA subagent. **→ SKILL.md Step 2 tabela**

## KBP-10 Destructive Commands Without Approval
Trigger: agente executa `rm`/`rmdir`/delete em dados do projeto sem aprovacao explicita do Lucas. Lucas: "nao pode dar comando destrutivo sem ask". Cause: (1) regra "artifact cleanup consumidos" interpretada permissivamente, (2) Pattern 17 usava "ask" que podia ser auto-aprovado, (3) `.claude/workers/` gitignored = sem rede de seguranca. Fix S130: (1) guard-bash-write.sh Pattern 17a hard-blocks rm em `.claude/workers/`. (2) Regra geral: NENHUM comando destrutivo sem aprovacao explicita — nem orquestrador, nem worker. **→ guard-bash-write.sh Pattern 17a/17b**

## KBP-11 Gemini Thinking Token Pool Shared with Output
Trigger: Gemini API call retorna 0 bytes de texto. `finishReason: MAX_TOKENS` ou `STOP` sem texto. Lucas: "gemini retornou vazio". Cause: `maxOutputTokens` inclui thinking tokens no Gemini (diferente de Claude). Com `maxOutputTokens: 8192` e `thinkingBudget: 24576`, o modelo gasta tudo em thinking e sobram 0 tokens para texto. Fix S145: (1) `maxOutputTokens: 32768` com `thinkingBudget: 16384`. (2) Check `finishReason === 'MAX_TOKENS'` + check `!parts.some(p => p.text)`. (3) Comentario explicativo no SKILL.md. **→ SKILL.md Perna 1 generationConfig**

## KBP-12 Research Prompts Without Output Schema
Trigger: pesquisa retorna ensaio/prosa em vez de dados estruturados. Lucas: "vc tem que forca-los a dar output estruturado". Cause: prompts diziam "ABERTO" sem distinguir liberdade de TOPICO de liberdade de FORMATO. Perplexity retornou 31KB ensaio, Opus retornou narrativa longa. Fix S145: (1) Principio "OPEN topic + CLOSED format" no SKILL.md. (2) Output Schema Suffix obrigatorio em toda perna. (3) System prompt Perplexity reescrito com formato tabular. (4) Schema Validation Gate mecanico no Step 2.5. **→ SKILL.md §Output Schema Suffix + §Principio I/O**

## KBP-13 Factual Claim Without Verification
Trigger: agente afirma um fato sobre estado (ex: "MCP X esta frozen"), historia (ex: "padrao introduzido no arquivo Y") ou design intent (ex: "doc Z e sincronizado") e Lucas corrige. Cause: working-memory coherence bias — a primeira resposta plausivel e oferecida sem checar source-of-truth. Diferente de KBP-07 (que dispara em falhas); KBP-13 dispara em claims durante trabalho *rotineiro*. Evidencia S151 (3 eventos em 16 sessoes, todos subtipos desta categoria): (1) lista de MCPs frozen recalled de memoria, (2) `meta-narrativa.html` assumido como synced, (3) atribuicao do padrao `.v/.c` a `s-checkpoint-1.html` quando origem era `forest-plot-candidates.html` S146 ea434e7. Fix S152: antes de qualquer assertion sobre state/history/intent, rodar verificacao mais barata (grep, `git log -S '<literal>'`, ler header do doc) e citar inline. Se custo > ~5s, parar e perguntar. **→ anti-drift.md §Verification gate extended to historical/state claims**

## KBP-14 Velocity Over Comprehension
Trigger: Lucas aprovando rapidamente ("OK", "ok", "pode", "continue") em sequencia mas a densidade tecnica do trabalho e alta. Agente trata fast approval como informed consent e acelera. Lucas mais tarde verbaliza falta de protecao do plano ("nao filtro bem", "tem que me explicar"). Cause: explicacoes atrofiam mid-session apesar de anti-drift §Calibrate depth cobrir o caso. KBP-13 protege contra claims sem verificacao; KBP-14 protege contra **execucao sem verbalizacao do porque**. Fix: quando ocorrerem 3+ aprovacoes monossilabicas consecutivas durante execucao, slow down e re-explicar WHY da proxima fase antes de prosseguir. Melhor adicionar 30s de contexto que executar contra plano half-understood. Evidencia S154: L456 ("lembre que eu ainda sou iniciante entao algumas coisas tem que me explicar pois nao filtro bem msm o plano") + L478 ("vc ser meu mentor em varios aspectos esta relativamente sendo pouco usado, mas nao eh P0"). Padrao recorrente — memory `user_mentorship.md` ja registrava expectativa antes. **→ anti-drift.md §Execution-phase explanation budget + §Active mentor mode**

## KBP-15 Write Race via External Script
Trigger: script externo (Python/Bash) modifica arquivo no write-path do Claude Code (`settings.local.json`, `.claude/*.md`); modificacoes externas sao silenciosamente clobbered por flush in-memory subsequente. Lucas: (S155) "depois de rodar strip-a3.py o arquivo tem 89 entries em vez de 70 esperadas, e tem entries `Bash(cp ...)` / `Bash(python ...)` que o script nao adicionou". Cause: Claude Code mantem copia in-memory de `settings.local.json` para checks de permissao + auto-append de tools auto-aprovados. Script externo modifica disco, mas proximo write Claude Code flush in-memory state, sobrescrevendo as mudancas externas. Diferente de race condition classica — race e entre processo externo e in-memory state de Claude Code, nao entre dois processos no fs. Diferente de KBP-10 (destrutivo intencional); KBP-15 protege contra modificacoes EXTERNAS BENIGNAS sendo silenciosamente perdidas. Fix S155: para arquivos no write-path do Claude Code, SEMPRE usar Edit/Write tool atraves do path canonico. Scripts externos podem LER mas nao MODIFICAR. Evidencia: 17 entries removidas via strip-a3.py + 4 cp/python auto-add → arquivo final tinha 89 entries; refeito atomicamente via Write tool → 68 entries verificadas. **→ memory feedback_tool_permissions.md §Write race**
