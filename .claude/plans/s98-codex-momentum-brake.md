# Codex Proposal: Momentum Brake (Anti KBP-01)

> Source: Codex adversarial agent S98 (2026-04-07)
> Status: PENDENTE implementacao

## Problema

Regras em prosa (anti-drift.md, KBP-01) falham porque o bias de "ser util" as sobrescreve durante geracao. O agente conhece as regras mas as ignora quando acha que esta sendo pragmatico.

## Proposta: 3 hooks estruturais

### 1. momentum-brake-arm.sh (PostToolUse: Write|Edit|Bash|Agent)
- Apos qualquer acao discreta, escreve state file em `/tmp/olmo-momentum-brake/`
- Printa reminder de STOP no output

### 2. momentum-brake-enforce.sh (PreToolUse: .*)
- Antes de CADA tool call, verifica se state file existe
- Se armado: output `permissionDecision: "ask"` — forca aprovacao estrutural
- Agente NAO consegue bypassar (gate do SDK, nao prosa)

### 3. momentum-brake-clear.sh (UserPromptSubmit)
- Quando Lucas envia mensagem, limpa o lock
- Agente pode agir de novo ate a proxima acao discreta

## Insight chave

`permissionDecision: "ask"` e um gate estrutural do Claude Code SDK. Diferente de regras em prosa, o agente nao pode ignorar — o harness bloqueia a tool call ate o usuario aprovar. Isso transforma o momentum brake de "por favor pare" em "voce DEVE parar".

## TODO (proxima sessao)
- [ ] Escrever os 3 scripts shell
- [ ] Registrar em settings.local.json
- [ ] Testar: fazer uma edicao, verificar que proxima tool pede permissao
- [ ] Ajustar excepcoes (Read/Grep/Glob nao devem armar o brake)
