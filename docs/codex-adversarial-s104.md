# Codex Adversarial Review — S104

> Gerado por Codex rescue agent | 2026-04-07
> Coautoria: Lucas + Opus 4.6 + Codex

## Problema 1: Gemini Repetition Loop em JSON Output

### Diagnostico

O script `gemini-qa3.mjs` **ja usa** structured output (`responseMimeType: 'application/json'` + `responseSchema`). O problema nao e falta de JSON mode.

**Causa raiz:** pressao para expandir sem limites:
- Call B exige 5 dimensoes completas (evidencia + problemas + fixes + nota) + dead_css + specificity_conflicts + proposals
- Injeta HTML, CSS, JS, notes, round context e error digest verbatim no prompt
- Prompt diz "olhe de novo se nao achou problemas" — pressao para continuar emitindo
- `proposals` nao tem limite de quantidade nem `required` por item no schema (L404-415)
- `maxOutputTokens: 16384` e alto — amplia janela de degeneracao

**Localizacao:** `gemini-qa3.mjs:916, 963-969, 1058-1061`

### Propostas

| # | Proposta | Impacto | Risco |
|---|---------|---------|-------|
| P1-1 | Reduzir Call B `maxOutputTokens` para 4096-8192 | Alto — limita janela de loop | Pode truncar fixes legitimos |
| P1-2 | Limitar proposals: "max 5, ordenadas por impacto" no prompt | Alto — controla expansao | Pode perder issues low-priority |
| P1-3 | Truncar/resumir `roundCtx` antes de injetar (L947) | Medio — reduz pressao de input | Perde contexto de rounds anteriores |
| P1-4 | Endurecer schema: `required` em cada item de proposals (`severity`, `titulo`, `fix`, `arquivo`, `tipo`) | Medio — forca estrutura | Nenhum significativo |
| P1-5 | Tratar `finishReason !== 'STOP'` como falha estrutural, nao warning | Alto — detecta degeneracao | Pode rejeitar respostas validas truncadas por outro motivo |

### Implementacao sugerida (ordem)

1. P1-4 (schema) + P1-2 (limit 5) — zero risco, maximo controle
2. P1-1 (tokens 8192) — testar se 8192 e suficiente para 5 dims + 5 proposals
3. P1-5 (finishReason gate) — so apos validar que STOP e consistente

---

## Problema 2: Report Parcial Quando 1 de 3 Calls Falha

### Diagnostico

Fix atual (throw → warn + `parsed = {}`) funciona sintaticamente mas tem 2 problemas:

1. **`media_uxcode` cai para `0`** (L1213) — engana o leitor (parece nota ruim, nao "call ausente")
2. **`Promise.all`** (L1074-1080) — se 1 call falhar no HTTP/timeout, TODAS se perdem antes de chegar ao parse

**O que funciona:** `safeNum()` usa optional chaining, `proposals` tem `|| []`. A consolidacao nao crasharia.

**Localizacao:** `gemini-qa3.mjs:1074-1080, 1104-1124, 1208-1214`

### Propostas

| # | Proposta | Impacto | Risco |
|---|---------|---------|-------|
| P2-1 | `Promise.allSettled` em vez de `Promise.all` (L1074) | Critico — salva calls que sucederam | Precisa adaptar destructuring downstream |
| P2-2 | Diferenciar estados: `missing`, `parse_failed`, `truncated`, `ok` | Alto — transparencia | Complexidade no consolidado |
| P2-3 | Usar `null` em vez de `0` para medias indisponiveis (L1212-1214) | Alto — evita engano | Report Markdown precisa tratar null |
| P2-4 | No Markdown: "Call B unavailable: parse_failed" antes do JSON | Medio — contexto humano | — |
| P2-5 | Salvar report parcial mesmo em excecao de rede (L1267-1299 ja tem infra) | Alto — resilience | Report incompleto pode parecer valido |

### Implementacao sugerida (ordem)

1. P2-1 (allSettled) — prerequisito para tudo
2. P2-3 (null em vez de 0) + P2-2 (estados)
3. P2-4 (label no Markdown)

---

## Problema 3: Anti-Workaround Enforcement

### Diagnostico

KBP-07 e normativo (rule/prompt). Apos compaction, o modelo pode esquecer. Hooks existentes:
- `momentum-brake-enforce.sh` — forca ask quando armado
- `guard-product-files.sh` — ask para scripts/prompts (novo S104)

**Limitacao fundamental:** nao existe evento "assistant message submit". Nao da para policiar linguagem ("vou tentar sem X"). O que da para travar e a ACAO subsequente.

**Brecha:** `guard-product-files.sh` da apenas `ask` para scripts canonicos. Apos aprovacao pontual, edit e possivel mesmo no contexto de falha.

### Proposta: Failure Latch (mesmo padrao momentum brake)

```
PostToolUse (Bash|Agent)
  → detecta erro (exit nonzero, MAX_TOKENS, JSON parse FAILED)
  → arma /tmp/olmo-failure-gate/armed

PreToolUse (Write|Edit|Bash|Agent)
  → se /tmp/olmo-failure-gate/armed existe
  → permissionDecision: "ask" com razao "Failure gate: erro detectado, diagnosticar antes de agir"
  → exempt: Read, Grep, Glob, AskUserQuestion (investigacao OK)

UserPromptSubmit
  → limpa /tmp/olmo-failure-gate/armed (usuario tomou decisao)
```

| # | Proposta | Impacto | Risco |
|---|---------|---------|-------|
| P3-1 | PostToolUse `failure-detect.sh` — arma latch em erro | Critico — detecta falha | Falsos positivos em erros benignos (grep no-match) |
| P3-2 | PreToolUse `failure-gate-enforce.sh` — bloqueia acoes durante falha | Critico — impede workaround | Pode atrapalhar investigacao |
| P3-3 | UserPromptSubmit limpa latch | Medio — ciclo completo | — |
| P3-4 | Endurecer guard-product-files para BLOCK durante failure state | Alto — scripts intocaveis em falha | Pode ser excessivo |
| P3-5 | NAO tentar regex em linguagem ("vou tentar") — fragil | — | — |

### Implementacao sugerida

1. P3-1 + P3-2 + P3-3 como trio (failure latch)
2. Calibrar lista de erros que armam (evitar grep no-match, lint warnings)
3. Testar com CHAOS_MODE=1

---

## Decisoes para Lucas

- [ ] P1: Aceitar limite 5 proposals + maxOutputTokens 8192?
- [ ] P2: Implementar `Promise.allSettled` + null medias?
- [ ] P3: Implementar failure latch (3 hooks)?
- [ ] Prioridade: qual problema atacar primeiro na S105?
