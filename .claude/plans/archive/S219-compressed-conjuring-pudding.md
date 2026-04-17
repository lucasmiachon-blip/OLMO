# S219 Plan (Phase 2): Proactive Communication Enforcement

## Context

O agente executa sem comunicar ha 20+ sessoes. Rules textuais (CLAUDE.md §1, anti-drift.md §EC loop, §Momentum brake) nao resolveram porque sao advisory — nenhum hook verifica se o agente explicou antes de agir.

**Gap estrutural identificado:**
- Momentum brake: exempta Bash/Read/Grep (correto para pesquisa, mas permite cadeias longas de execucao sem comunicacao)
- Stop[0] prompt: checa se tasks foram skipped, NAO se o agente comunicou antes de executar
- EC loop: texto puro — o agente pode ignorar e nenhum hook detecta
- P001 (pre-execution reflection gate): diagnosticado S193, nunca implementado

**Principio: sem adicionar complexidade nova.** Reusar o que existe.

## Abordagem: expandir Stop[0] prompt

Stop[0] ja existe, ja funciona, ja tem infraestrutura. A mudanca e adicionar UM criterio ao prompt existente: "o agente executou 3+ tool calls em sequencia sem comunicar ao usuario o que estava fazendo e por que?"

### Por que Stop[0] e nao um novo hook

1. **Ja existe** — zero infra nova
2. **Tem acesso ao contexto conversacional** — pode ver se houve texto entre tool calls
3. **Fires a cada resposta** — feedback imediato
4. **E semantico** — pode distinguir "Bash(git log)" (pesquisa, ok silencioso) de "Edit+Write+Bash(deploy)" (acao, requer comunicacao)

### O que NAO fazer

- Nao criar um novo hook script
- Nao adicionar PreToolUse gate em Bash (causaria friction em 100% dos bash calls)
- Nao adicionar variáveis de flag (complexidade sem ganho)
- Nao expandir o EC loop com mais campos (o problema nao e o template, e a ausencia de enforcement)

## Mudanca unica

**Arquivo**: `.claude/settings.local.json` linha 328 (Stop[0] prompt)

**Adicionar ao prompt existente** (antes do `$ARGUMENTS`):

```
SECOND CHECK — Silent execution: Count the tool calls in the assistant's response. If there are 3+ tool calls (Edit, Write, Bash with side effects, Agent) without user-facing text explaining WHAT is being done and WHY before those calls, that is silent execution. Research tools (Read, Grep, Glob) don't count. If silent execution detected, respond with JSON: {"ok":false,"reason":"Silent execution: N tool calls sem explicar ao usuario o que e por que"}. This check is INDEPENDENT of the skip check — both must pass.
```

**Tambem adicionar a anti-drift.md §EC loop** (reforco textual do que o hook enforca):

```
"Elite: sim" PROIBIDO — must contain: (1) por que esta abordagem e melhor que alternativas, (2) o que seria mais profissional. Reflexao de segurança nao basta — reflexao de excelencia.
```

**Tambem adicionar KBP-22 a known-bad-patterns.md:**
```
## KBP-22 Silent Execution Chains
→ anti-drift.md §EC loop + Stop[0] prompt (S219: enforcement mecanico)
```

## Arquivos a modificar

1. `.claude/settings.local.json` (linha 328) — expandir Stop[0] prompt
2. `.claude/rules/anti-drift.md` — hardening do EC Elite
3. `.claude/rules/known-bad-patterns.md` — KBP-22

## Verificacao

1. Testar Stop[0] com cenario que viola: resposta com 4 Edits sem texto → deve retornar `{ok:false}`
2. Testar Stop[0] com cenario correto: texto explicativo + Edits → deve retornar `{ok:true}`
3. Confirmar que pesquisa pura (Read+Grep+Glob) nao trigga falso positivo
