# Elite-Conduct Loop

> Gate pre-acao. Antes de QUALQUER implementacao (Write, Edit, Bash que muda estado), parar e refletir.

## O Loop (3 perguntas, ordem fixa)

1. **Verificacao?** — Tenho certeza do que vou escrever? Quoting, formato, paths, edge cases — pensei em cada um?
2. **Mudanca?** — O que exatamente muda? Consigo descrever em 1 frase? Se nao consigo, nao entendi o suficiente.
3. **Elite?** — Um dev senior escreveria isso na primeira tentativa? Se a resposta e "provavelmente nao", PARAR e repensar antes de escrever.

## Checkpoint visivel (OBRIGATORIO)

Antes de cada Edit/Write, escrever no output as 3 respostas em formato compacto:

```
[EC] Verificacao: <o que verifiquei — escaping, formato, paths, edge cases>
[EC] Mudanca: <1 frase descrevendo o que muda>
[EC] Elite: <sim/nao — se nao, PARAR e repensar>
```

**Por que visivel:** Lucas e dev iniciante — nao pode ser rede de seguranca. O checkpoint auditable forca reflexao (escrever = pensar) e permite Lucas ver se foi pulado. Sem `[EC]` antes de Edit/Write = loop nao foi aplicado.

Tier: Unaudited (S200). Testar 3 sessoes. Se falhar → escalar para hook.

## Quando o loop falha (sintomas)

- 2+ edits no mesmo arquivo para corrigir o proprio codigo → loop nao foi aplicado
- Teste revela bug trivial (formato, quoting, path errado) → verificacao pulada
- Dados de teste contaminam producao → ambiente de teste nao isolado

## Documentacao e cross-referencia

O loop aplica-se a docs com o mesmo rigor que a codigo. Gate adicional para cada linha/secao:

> **"Isso vai poluir meu contexto?"** Cada linha auto-loaded compete por context window. Necessario → reescreva com precisao. Desnecessario → mova para pointer ou remova. Docs existem para ORIENTAR decisoes, nao para acumular historico.

- **HANDOFF:** numeros (hooks, rules, agents) devem refletir o estado REAL — verificar contagem antes de escrever. So pendencias e futuro, nunca historico.
- **CHANGELOG:** historico preciso. Append-only para o que foi feito. Sem redundancia com HANDOFF.
- **Cross-ref:** se HANDOFF diz "32 hooks", settings deve ter 32. Claim sem verificacao = drift documental.
- **Commit messages:** descrevem o que o commit CONTEM, nao o que se pretendia.

## Aplicacao

- Vale para CADA passo, nao so o primeiro — codigo, docs, commits, tudo
- Fast approval do Lucas ("OK", "pode") NAO dispensa o loop — o loop e interno, nao externo
- Em sequencias multi-step: o loop se aplica a cada step individualmente, nao ao batch

## Evidencia

S195: 3 bugs em sequencia (quoting, jq -cn, JSONL contaminado) por pular o loop. S194: Lucas definiu o loop explicitamente. S200: Caddyfile auto-HTTPS + findstr backslash — loop nao aplicado, capturado por review holistico.
