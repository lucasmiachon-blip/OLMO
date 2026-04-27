# Codex CLI Peer-Review — S264.b verification

> **Path:** `.claude/.parallel-runs/2026-04-27-ma-types/codex-peer-review.md`
> **Date:** 2026-04-27 | **Reviewer:** Codex CLI (GPT-5.5) — segundo modelo, manual paste por Lucas em outra janela
> **Subject:** plan §S264.b recommendation (Option C — accept partial + document bench finding)
> **Confidence:** review é ele próprio bench substrate (segundo modelo verifica primeiro modelo).

---

## Review (verbatim)

### Findings materiais

| File | Problem | Severity | Confiança |
|---|---|---|---|
| `.claude/plans/sleepy-wandering-firefly.md:395` | "14 outputs" não bate com disco nem com a soma: 3 Gemini + 3 Perplexity + 3 NLM + 3 Codex + 1 evidence = 13. | P1 | 0.98 |
| `.claude/plans/splendid-munching-swing.md:170` + `sleepy-wandering-firefly.md:409` | O plano mandava rodar sequencial para evitar rate-limit, mas Path B teve 3 Gemini simultâneos e Q2 429. | P1 | 0.9 |
| `.claude/plans/sleepy-wandering-firefly.md:426` | "chattiness é root cause" está plausível, mas formulado forte demais. Docs do Claude Code dizem maxTurns limita turnos agentic/tool-use, e stop natural pode ser end_turn, budget/self-regulation ou prompt design. | P2 | 0.75 |

**Fixes recomendados:**
- F1: Trocar para "13 substantive outputs" ou explicar o 14º artefato.
- F2: Não contar Gemini Q2 como falha arquitetural de agent; marcar como confound de orquestração.
- F3: Rebaixar para "principal hipótese suportada pelo transcript; requer transcript/stop subtype para prova".

### Strongest Counter-Argument

> O melhor argumento contra C é que o bench não comparou ".mjs vs agents"; comparou .mjs determinístico contra agents que tentam fazer parse/validate/spot-check/emit via conversa em 6 fases. Isso enviesou contra Path B.
>
> O próprio codex-xhigh-researcher prova que agent pode ser robusto quando o design é "thin wrapper + subprocess schema-enforced": o Codex CLI produz JSON nativo, e o agent só valida. Logo, a conclusão correta não é "scripts vencem agents"; é **"scripts vencem estes wrappers chatty; thin-agent + deterministic runner parece o melhor padrão"**.
>
> Eu não escolheria B, porque parser do orchestrator mascararia a falha. Mas eu consideraria uma D-lite antes de travar política: refatorar só Gemini/Perplexity para uma única execução Bash determinística que chama API, salva raw, extrai JSON e imprime final. Isso não parece 2-3h inevitável; o corpo já tem os comandos. **O custo real é validação, não rewrite.**

### Blind Spots

1. **maxTurns não é métrica simples de "mensagens totais".** A doc do Agent SDK diz que o loop termina quando Claude produz resposta sem tool calls, e maxTurns limita turnos agentic/tool-use. Então "15 turns natural" precisa do `ResultMessage.subtype`, `stop_reason` e transcript do subagent antes de virar KBP.
2. **Claude Code tem SubagentStop hooks** que podem impedir o subagent de parar se o artefato esperado não existir. Isso é uma alternativa arquitetural importante: em vez de aumentar maxTurns, usar hook de qualidade "output JSON exists and validates".
3. **A regra KBP-48 "wrap = sempre agente" está forte demais.** Os dados favorecem algo mais específico: "APIs externas devem ter contrato determinístico e auditável; se wrapped por agent, o agent precisa ser fino e verificável".
4. **Perplexity ignorar system_prompt afeta `.mjs` E agent**, porque ambos usam o mesmo modelo/API. Isso é bug de prompt/API contract, não evidência limpa contra scripts.

### Alternative Recommendation

> Minha recomendação: **aprovar C para documentar o bench parcial, mas registrar decisão como KEEP-SEPARATE provisório**, não como MERGE nem MERGE-BACK.

**Estado recomendado agora:**
- `.mjs` fica canonical para Gemini/Perplexity hot path, porque completou 9/9 scripts.
- `codex-xhigh-researcher` fica canonical como agent robusto, porque o padrão `codex exec --output-schema` funcionou.
- `gemini-deep-research` e `perplexity-sonar-research` ficam **experimental até D-lite**.
- Não escolheria a opção "allow Claude to edit its own settings"; não há necessidade para esse peer review.

**Fontes externas consultadas:**
- Claude Code Agent Loop sobre maxTurns/result subtype
- Subagents docs sobre frontmatter maxTurns
- Anthropic stop reasons
- Hooks docs sobre SubagentStop

---

## Claude orchestrator response (S264.c)

Findings F1/F2/F3 **conceded** — corrections applied no plan §S264.c. Counter-argument **conceded** — recommendation amended para Option C provisional + KEEP-SEPARATE provisional + D-lite track. Blind spots 1-4 **acknowledged** — KBP-Candidate-D NOT formalized esta sessão (precisa transcript proof); KBP-48 reformulation defer S265; SubagentStop hooks como S265+ exploration.

**Net effect:** Codex review elevou bench finding accuracy. Não invalidou bench — refinou framing crítico antes de policy lock. Pattern: peer-review entre modelos é cheap quality gate ($0 + ~5min Lucas paste) com signal alto.
