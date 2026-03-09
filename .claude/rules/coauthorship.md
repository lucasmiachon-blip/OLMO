# Regra: Coautoria AI Explicita

> Toda producao AI-assistida deve explicitar quem participou.
> Lucas e sempre autor principal e responsavel ultimo.

## Membros da Alianca

| Modelo | Papel | ID |
|--------|-------|----|
| Claude Opus 4.6 | Orquestrador, MBE profunda | `opus` |
| ChatGPT 5.4 | Auditor, cross-validation | `gpt54` |
| Gemini 3.1 | Pesquisa, Google Drive | `gemini31` |
| Cursor | Coding visual | `cursor` |
| Claude Sonnet 4.6 | Subagentes | `sonnet` |
| Claude Haiku 4.5 | Triagem | `haiku` |
| Ollama (local) | Parsing, $0 | `local` |

## Formato

```
Coautoria: Lucas + [modelos]
Orquestrador: [modelo]
Validador: [modelo, se houve]
```

## Quando (obrigatorio)

Notion pages, papers, notas clinicas, questoes de concurso, codigo commitado,
apresentacoes, Anki cards, qualquer conteudo compartilhado com terceiros.

## Nivel de Detalhe

| Contexto | Formato |
|----------|---------|
| Notion (publico) | Header completo |
| Commit | `Co-authored-by: [modelos]` |
| Anki | Tag `ai:opus+gpt54` |
| Slide | Rodape |
| Paper | Agradecimentos |

## Anti-patterns

- Apresentar output AI como 100% proprio
- Usar "AI-assisted" generico sem especificar modelos
- Creditar modelo errado
