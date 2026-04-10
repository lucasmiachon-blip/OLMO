---
title: Skills
description: Skills do Claude Code — 25+ skills, trigger patterns, progressive disclosure
domain: sistema-olmo
confidence: high
tags: [skill, automation, pipeline, teaching]
created: 2026-04-08
sources:
  - .claude/skills/*.md (projeto)
  - ~/.claude/skills/*.md (global)
  - config/ecosystem.yaml
---

# Skills

Skills sao prompts especializados carregados sob demanda pelo harness. O OLMO tem 25+ skills organizados por dominio.

## Categorias

| Dominio | Skills | Exemplos |
|---------|--------|----------|
| Pesquisa | 2 | /research (6 pernas), /evidence |
| Ensino | 1 | /teaching |
| Concurso | 2 | /concurso, /exam-generator |
| Organizacao | 3 | /organization, /daily-briefing, /notion-publisher |
| Infra | 5 | /insights, /review, /janitor, /dream, /wiki-lint |
| Dev | 3 | /automation, /skill-creator, /systematic-debugging |
| Estudo | 2 | /knowledge-ingest, /nlm-skill, /continuous-learning |
| Meta | 3 | /wiki-query, /docs-audit, /simplify |

## Anatomia de um Skill

```
.claude/skills/{name}/
  SKILL.md          ← Prompt principal (YAML frontmatter + instrucoes)
```

Frontmatter: `name`, `description`, `model`, `maxTurns`, `tools[]`, `triggers[]`.

## Patterns

- **Progressive disclosure:** SKILL.md >300 linhas → extrair para `resources/`
- **Trigger patterns:** keywords no prompt do usuario ativam o skill
- **MANDATORY TRIGGERS (S115):** top 5 skills com triggers explicitos
- **context:fork:** skills pesados fazem fork de contexto para nao poluir janela principal

## Relacionados

- [[agent]] — agents executam, skills orquestram
- [[hook]] — hooks podem triggerar skills (/dream via stop hook)
- [[memory]] — /dream e /wiki-query operam no memory wiki
