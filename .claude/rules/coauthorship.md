# Regra: Coautoria AI Explicita - Pacto de Alianca Multi-AI

> Atualizado: 8 de Marco de 2026
> Principio: Toda producao AI-assistida deve explicitar quem participou.

## PACTO DE ALIANCA

Este ecossistema opera com **multiplos modelos AI em colaboracao**.
Cada modelo tem papel definido, e TODO output deve creditar quem contribuiu.

### Membros da Alianca

| Modelo | Papel Principal | Identificador |
|--------|----------------|---------------|
| **Claude Opus 4.6** | Orquestrador, decisoes complexas, MBE profunda | `opus` |
| **ChatGPT 5.4** | Auditor, cross-validation, Deep Research | `gpt54` |
| **Gemini 3.1** | Pesquisa, Google Drive, contexto longo | `gemini31` |
| **Cursor** | Coding visual, multi-file editing | `cursor` |
| **Claude Sonnet 4.6** | Subagentes, execucao | `sonnet` |
| **Claude Haiku 4.5** | Tarefas simples, triagem | `haiku` |
| **Ollama (local)** | Parsing, formatacao, $0 | `local` |

### Humano
- **Lucas** — autor principal, decisor final, responsavel ultimo

## PROTOCOLO DE ATRIBUICAO

### Em todo output significativo, incluir:

```
---
Coautoria: Lucas + [modelos que participaram]
Orquestrador: [modelo que coordenou]
Validador: [modelo que revisou, se houve]
Data: YYYY-MM-DD
---
```

### Exemplos

**Nota clinica analisada:**
```
Coautoria: Lucas + opus + gpt54
Orquestrador: opus (analise MBE)
Validador: gpt54 (cross-validation)
```

**Codigo desenvolvido:**
```
Coautoria: Lucas + opus + cursor
Orquestrador: opus (arquitetura)
Validador: cursor (implementacao visual)
```

**Pesquisa com multiplas fontes:**
```
Coautoria: Lucas + opus + gemini31 + gpt54
Orquestrador: opus (sintese)
Pesquisa: gemini31 (Google Scholar, Drive)
Validador: gpt54 (fact-check)
```

**Questao de concurso gerada:**
```
Coautoria: Lucas + opus + gpt54
Gerador: opus (exam-generator skill)
Validador: gpt54 (calibracao, pegadinhas)
```

## QUANDO EXPLICITAR (OBRIGATORIO)

- Notion pages publicadas
- Papers, notas clinicas, analises MBE
- Questoes de concurso geradas/calibradas
- Codigo commitado (ja no commit message ou header)
- Apresentacoes e slides
- Qualquer conteudo compartilhado com terceiros
- Anki cards (campo "source" ou tag)

## QUANDO OPCIONAL (mas recomendado)

- Notas pessoais no Obsidian
- Brainstorms internos
- Logs de debug/desenvolvimento
- Conversas exploratorias

## NIVEL DE DETALHE

| Contexto | Formato |
|----------|---------|
| Notion page (publico) | Header completo com todos participantes |
| Commit message | `Co-authored-by: [modelos]` no footer |
| Anki card | Tag `ai:opus+gpt54` ou campo source |
| Slide/apresentacao | Rodape: "Produzido com assistencia de [modelos]" |
| Paper/artigo | Agradecimentos ou nota metodologica |
| Codigo (header) | Comentario `# Coautoria: Lucas + opus + cursor` |

## PRINCIPIOS

1. **Transparencia total** — nunca omitir participacao de AI
2. **Credito proporcional** — quem fez mais, aparece primeiro
3. **Responsabilidade humana** — Lucas e sempre o autor principal e responsavel
4. **Rastreabilidade** — se algo der errado, saber quem fez o que
5. **Honestidade intelectual** — especialmente em contexto academico/medico
6. **Evolucao** — novos modelos entram na alianca conforme adotados

## ANTI-PATTERNS (evitar)

- Apresentar output AI como 100% proprio sem credito
- Omitir qual modelo validou uma decisao critica
- Usar "AI-assisted" generico sem especificar quais modelos
- Creditar modelo errado (ex: dizer que Gemini fez algo que foi o Opus)
