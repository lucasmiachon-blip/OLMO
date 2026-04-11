---
name: brainstorming
description: "Structured pre-action Socratic dialogue to define WHAT, WHY, WHO, HOW before implementation (produces no code/files)."
argument-hint: "[topic or goal in any domain]"
---

# Brainstorming — Socratic Pre-Action Dialogue

Topic: `$ARGUMENTS`

Dialogo estruturado ANTES de qualquer implementacao.
Complementa o momentum brake (reativo) com validacao proativa de escopo.

## HARD GATE — Anti-Codigo

Enquanto este skill estiver ativo:

- **PROIBIDO**: Write, Edit, Bash, Agent, gerar codigo, SQL, HTML, CSS, assinaturas de funcao
- **PROIBIDO**: criar arquivos, executar comandos, lancar subagents
- **UNICO output permitido**: perguntas, reformulacoes, scope card
- Se o usuario pedir "so codifica" ou "pula isso": responder "Scope card primeiro. Mais uma pergunta."
- **Encerra SOMENTE** quando usuario aprova scope card OU diz "exit brainstorming" / "sair"

Este gate existe porque pensar antes de agir e mais barato que desfazer depois.

---

## Fase 1: SEED (1 mensagem)

Ler `$ARGUMENTS`. Detectar dominio. Fazer UMA pergunta de abertura.

### Deteccao de dominio

| Sinais no argumento | Dominio | Pergunta de abertura |
|---------------------|---------|----------------------|
| slide, aula, apresentacao, lecture, deck | **Teaching** | "Qual a UNICA afirmacao clinica que o aluno deve levar desta aula?" |
| feature, bug, refactor, API, component, hook, script | **Dev** | "Que problema do usuario isso resolve? (nao o problema tecnico — o problema humano)" |
| pesquisa, paper, evidence, PMID, PICO, hipotese, revisao | **Research** | "Qual a pergunta PICO que voce quer responder?" |
| concurso, estudo, prova, simulado, topico, banca | **Concurso** | "Qual tema especifico e qual sua taxa de acerto atual nele?" |
| (ambiguo ou misto) | **General** | "Em uma frase: o que muda no mundo quando isso estiver pronto?" |

Se o dominio for incerto, perguntar: "Isso e mais perto de [A] ou [B]?" antes de prosseguir.

Formato da resposta SEED:

```
**Dominio detectado:** [dominio]
**Topic:** [resumo do argumento]

[Pergunta de abertura]
```

---

## Fase 2: DIVERGE (2-4 mensagens)

Explorar o espaco do problema. **Uma pergunta por mensagem. Esperar resposta antes da proxima.**

### Banco de perguntas por dominio

**Teaching / Slides:**
1. Quem e o publico? (residentes, internos, graduacao, colegas)
2. O que eles ja sabem sobre isso? Qual misconception mais comum?
3. Que tipo de evidencia visual sustenta a afirmacao? (grafico, tabela, fluxograma, caso)
4. Em que momento da aula isso aparece? (abertura, desenvolvimento, fechamento)

**Dev:**
1. Quem usa isso? Com que frequencia?
2. O que existe hoje que tenta resolver isso? Por que nao basta?
3. Qual a menor versao disso que ja e util? (MVP)
4. Que efeitos colaterais essa mudanca pode ter? (outros arquivos, hooks, CI)

**Research:**
1. O que ja se sabe sobre isso? Qual o estado da arte?
2. Se confirmado, que pratica clinica muda?
3. Que tipo de estudo responde melhor? (RCT, coorte, MA, revisao)
4. Qual a consequencia de NAO investigar isso?

**Concurso:**
1. Qual banca? (ENARE, USP, Unicamp, etc.) Qual o perfil de questoes?
2. Quais subtopicos adjacentes costumam confundir?
3. Voce erra mais por nao saber ou por cair em pegadinha?
4. Que recurso ja usou pra estudar isso? (Medcel, Medway, livro, etc.)

**General:**
1. Quem se beneficia quando isso estiver pronto?
2. Que restricoes existem? (tempo, ferramentas, dependencias)
3. O que acontece se nao fizermos nada?
4. Qual seria o primeiro sinal de que funcionou?

### Regras do DIVERGE

- Fazer NO MAXIMO 1 pergunta por mensagem
- Se a resposta do usuario ja cobrir a proxima pergunta, pular para a seguinte
- Se o usuario divagar, reformular gentilmente: "Interessante. Voltando ao escopo: [pergunta]"
- Apos 2-4 rodadas, transitar para CONVERGE

---

## Fase 3: CONVERGE (1-2 mensagens)

Sintetizar tudo em um **Scope Card** e apresentar para aprovacao.

### Template do Scope Card

```
## Scope Card: [titulo curto]

- **WHAT**: [objetivo em uma frase]
- **WHY**: [motivacao — o que muda se fizermos isso]
- **WHO**: [publico / usuario / beneficiario]
- **HOW**: [restricoes, ferramentas, abordagem]
- **NOT**: [o que esta FORA do escopo — exclusoes explicitas]
- **EXIT**: [criterio objetivo de "pronto"]
```

O campo **NOT** e o mecanismo de prevencao de scope creep.
Perguntar explicitamente: "Tem algo que voce quer garantir que NAO entre no escopo?"

Se o usuario quiser ajustar, editar o scope card e reapresentar.

---

## Fase 4: EXIT (1 mensagem)

Quando o scope card estiver aprovado, apresentar as 3 saidas:

> Scope card aprovado. Proximo passo:
> 1. **Plan Mode** — entrar em modo planejamento para desenhar a implementacao
> 2. **Executar** — tarefa pequena e clara, posso comecar direto
> 3. **Refinar** — quero explorar mais antes de decidir
>
> Qual prefere?

- **Opcao 1**: sugerir `EnterPlanMode` como proximo passo natural
- **Opcao 2**: iniciar a tarefa respeitando o scope card (NOT como guardrail)
- **Opcao 3**: voltar para Fase 2 ou 3

---

## Anti-Patterns (o que NAO fazer)

- Fazer 3 perguntas de uma vez (viola 1-pergunta-por-mensagem)
- Sugerir solucoes durante o brainstorming (viola hard gate)
- Pular o scope card e ir direto para acao
- Inventar exclusoes no NOT sem perguntar ao usuario
- Assumir dominio sem sinais claros no argumento
- Continuar divergindo apos 4 rodadas sem convergir

---

## Integracao com o Ecossistema

- **Momentum brake** (hooks): opera DOWNSTREAM. Brainstorming opera UPSTREAM. Complementares.
- **Plan mode** (.claude/plans/): saida natural do brainstorming. Scope card alimenta o plano.
- **Skills de dominio** (/slide-authoring, /research, /concurso): invocar DEPOIS do brainstorming, nao durante.
- **Anti-drift** (rules): brainstorming reforoca "declare intent before acting" de forma estruturada.
- **KBP-01**: o campo NOT no scope card e a versao proativa da prevencao de scope creep.
