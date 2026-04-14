# Elite-Conduct Loop

> Gate pre-acao. Antes de QUALQUER implementacao (Write, Edit, Bash que muda estado), parar e refletir.

## O Loop (3 perguntas, ordem fixa)

1. **Verificacao?** — Tenho certeza do que vou escrever? Quoting, formato, paths, edge cases — pensei em cada um?
2. **Mudanca?** — O que exatamente muda? Consigo descrever em 1 frase? Se nao consigo, nao entendi o suficiente.
3. **Elite?** — Um dev senior escreveria isso na primeira tentativa? Se a resposta e "provavelmente nao", PARAR e repensar antes de escrever.

## Quando o loop falha (sintomas)

- 2+ edits no mesmo arquivo para corrigir o proprio codigo → loop nao foi aplicado
- Teste revela bug trivial (formato, quoting, path errado) → verificacao pulada
- Dados de teste contaminam producao → ambiente de teste nao isolado

## Documentacao e cross-referencia

O loop aplica-se a docs com o mesmo rigor que a codigo:
- **HANDOFF:** numeros (hooks, rules, agents) devem refletir o estado REAL — verificar contagem antes de escrever
- **CHANGELOG:** historico preciso. Sessao anterior nao carrega "pendente" se ja foi feito. Append-only para o que foi feito.
- **Cross-ref:** se HANDOFF diz "34 hooks", settings deve ter 34. Se CHANGELOG diz "archived", git deve ter o arquivo. Claim sem verificacao = drift documental.
- **Commit messages:** devem descrever o que o commit REALMENTE contem, nao o que se pretendia. "plans archived" sem os arquivos = mentira documental.

## Aplicacao

- Vale para CADA passo, nao so o primeiro — codigo, docs, commits, tudo
- Fast approval do Lucas ("OK", "pode") NAO dispensa o loop — o loop e interno, nao externo
- Em sequencias multi-step: o loop se aplica a cada step individualmente, nao ao batch

## Evidencia

S195: 3 bugs em sequencia (quoting, jq -cn, JSONL contaminado) por pular o loop. S194: Lucas definiu o loop explicitamente.
