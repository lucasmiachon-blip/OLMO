---
name: systematic-debugging
description: "Structured 4-phase debugging methodology (root cause, pattern analysis, hypothesis, implementation)."
---

# Skill: Systematic Debugging

> NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST.
>
> Propor solucao antes de entender o problema e como prescrever sem diagnostico.

## Quando usar

- Erro em runtime, build, CI, linter, testes
- Comportamento inesperado (funciona diferente do esperado)
- Regressao (funcionava antes, parou)
- Qualquer fix que falhou na primeira tentativa

## As 4 Fases

### Fase 1: Investigacao (Root Cause)

**Objetivo:** entender o que aconteceu, nao o que voce *acha* que aconteceu.

1. **Leia o erro inteiro** — nao so a primeira linha. Stack traces se leem de baixo para cima.
2. **Reproduza o problema** — se nao consegue reproduzir, nao consegue confirmar o fix.
3. **Isole o escopo** — quais arquivos mudaram? `git diff` e `git log --oneline -10`.
4. **Trace o fluxo** — siga os dados do input ate o ponto de falha. Em sistemas multi-camada, adicione logs temporarios nas fronteiras (ex: entre Python e API, entre JS e CSS).

**Red flags desta fase:**
- Propor solucao antes de ler o erro completo
- Dizer "provavelmente e X" sem evidencia
- Pular para o fix porque "ja vi isso antes"

### Fase 2: Analise de Padroes

**Objetivo:** comparar o que funciona com o que quebrou.

1. **Encontre um caso que funciona** — outro teste, outro slide, outro endpoint.
2. **Compare lado a lado** — diff entre o caso funcional e o quebrado.
3. **Identifique diferencas** — a causa esta nas diferencas, nao nas similaridades.
4. **Mapeie dependencias** — o que esse codigo precisa para funcionar? (imports, config, arquivos externos, estado)

**Analogia clinica:** e o diagnostico diferencial — voce compara o paciente doente com o saudavel e busca o que difere.

### Fase 3: Hipotese e Teste

**Objetivo:** metodo cientifico aplicado a codigo.

1. **Formule hipotese especifica** — "O erro ocorre porque X esta Y quando deveria estar Z."
2. **Teste UMA variavel por vez** — mudar 2 coisas simultaneamente invalida o teste.
3. **Prediga o resultado** — antes de rodar, diga o que espera. Se o resultado surpreende, a hipotese esta errada.
4. **Documente** — registre o que testou e o resultado. Evita repetir testes.

**Red flags desta fase:**
- Mudar 3 coisas de uma vez "pra ver se resolve"
- Nao predizer o resultado antes de testar
- Ignorar resultado inesperado em vez de investigar

### Fase 4: Implementacao

**Objetivo:** fix minimo, verificado, permanente.

1. **Escreva o teste que falha** — reproduza o bug como teste automatizado (quando aplicavel).
2. **Fix minimo** — corrija apenas a causa raiz. Nao aproveite para "melhorar" codigo adjacente.
3. **Verifique** — rode o teste, rode o CI, confirme que funciona.
4. **Cheque regressao** — o fix nao quebrou outra coisa? `pytest tests/` ou `npm run qa`.

**Regra dos 3 fixes:** se 3+ tentativas de fix falharam, PARE. A arquitetura pode estar errada. Reporte ao usuario com as evidencias coletadas e peca direcao.

## Gate de Verificacao

Antes de declarar "corrigido":

```
[ ] Li o erro completo (nao so a primeira linha)
[ ] Reproduzi o problema
[ ] Identifiquei a causa raiz com evidencia
[ ] Fix alterou apenas o necessario
[ ] Teste/CI passou apos o fix
[ ] Nenhuma regressao introduzida
```

Se nao pode marcar todos: o debug nao terminou.

## Formato de Output

Ao debugar, estruture a comunicacao assim:

```
## Debug: [descricao curta do problema]

**Erro:** [mensagem exata]
**Fase 1 — Investigacao:** [o que encontrei]
**Fase 2 — Padroes:** [comparacao funcional vs quebrado]
**Fase 3 — Hipotese:** [minha hipotese e como testei]
**Fase 4 — Fix:** [o que mudei e por que]
**Verificacao:** [comandos rodados e resultados]
```

## Anti-Patterns (STOP imediato)

| Sinal | Problema | Correcao |
|-------|----------|----------|
| "Provavelmente e X" | Adivinhacao sem evidencia | Volte para Fase 1 |
| Mudou 3+ arquivos de uma vez | Invalidou o teste | Reverta, mude 1 por vez |
| "Ja vi esse erro antes" | Viés de confirmacao | Verifique — mesmo erro, contexto diferente |
| Fix nao testado | Afirmacao sem prova | Rode o comando, leia o output |
| 3+ tentativas de fix | Causa raiz errada | PARE, reporte com evidencias |
| "Funcionou no meu teste manual" | Nao reproduzivel | Escreva teste automatizado |

## Integracao com o Projeto

- **Python:** `pytest tests/ -x` (para no primeiro erro para investigar)
- **Aulas (CSS/JS):** `npm run qa:screenshots:*` + inspecionar no browser
- **Linter:** `ruff check . --show-fixes` (mostra o que mudaria)
- **CI:** ler output completo do CI antes de propor fix
- **Anti-drift:** esta skill respeita `anti-drift.md` — nao fabrica explicacoes, nao muda codigo adjacente
