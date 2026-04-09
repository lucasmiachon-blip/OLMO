# OLMO Wiki — Knowledge Base

> Content wiki: conhecimento medico + documentacao de sistema.
> Separado do Memory Wiki (~/.claude/projects/*/memory/) que e self-knowledge do agente.

## Estrutura

```
wiki/
├── _index.md                ← Indice global
└── topics/
    ├── medicina-clinica/    ← R3, aulas, MBE, hepatologia
    │   ├── raw/             ← Fontes EN imutaveis (Cowork alimenta via orquestrador)
    │   ├── wiki/concepts/   ← Notas compiladas PT (principal)
    │   └── wiki/topics/     ← Compilados futuros
    └── sistema-olmo/        ← Self-improvement do OLMO
        ├── raw/             ← Docs existentes, best practices
        ├── wiki/concepts/   ← Conceitos do sistema (mcp, skill, hook...)
        └── wiki/topics/     ← Temas transversais (orquestracao, safety...)
```

## Convencoes

- **raw/** e imutavel — LLM le, nunca escreve. Cowork produz em OLMO_COWORK, orquestrador copia.
- **wiki/** e compilado — LLM mantem, humano revisa.
- PT e lingua principal. EN fica em raw/ como material-fonte.
- Frontmatter YAML obrigatorio (confidence, tags, wikilinks).
- `[[wikilinks]]` entre paginas para Obsidian graph view.

## Ownership

| Quem | Pode |
|------|------|
| Lucas | Tudo |
| Orquestrador | Compilar raw/ → wiki/, manter indices, lint |
| Cowork | Produzir em OLMO_COWORK (orquestrador copia para raw/) |
| Workers | Nada (read-only no repo) |

Coautoria: Lucas + Opus 4.6 | S117 2026-04-08
