# ECOSYSTEM.md - Mapa do Ecossistema AI

> Atualizado: 29 de Marco de 2026
> Perfil: Medico + Professor + Pesquisador + Dev AI

## Objetivos

1. **Digest medico semanal** — melhores evidencias via PubMed MCPs → Notion
2. **Pipeline nota/paper → MBE → Notion** — GRADE, CONSORT, STROBE, PRISMA
3. **Fontes pagas** — Cowork extrai UpToDate/DynaMed/BMJ → MBE → Notion
4. **Gmail → Notion** — emails medicos classificados e publicados
5. **Knowledge base unificada** — Notion (publico) + Obsidian (local) + Zotero (refs)
6. **Ensino** — slideologia, andragogia, AI fluency, error log
7. **Dev AI** — curadoria 2x/semana (MCP, Agent SDK, agentic patterns)
8. **Concurso dez/2026** — 120 questoes, spaced repetition, Anki AI-driven

## Regra de Ouro

```
Claude Code  = FAZER     Cowork      = EXTRAIR    Cursor    = EDITAR
Claude.ai    = PENSAR    ChatGPT Web = VALIDAR    Gemini    = PESQUISAR
Perplexity   = BUSCAR    NotebookLM  = ESTUDAR    Notion    = PUBLICAR
Obsidian     = CONECTAR  Zotero      = REFERENCIAR Canva    = DESIGN
```

## KPIs

- Cache hit rate
- Custo mensal real vs estimado
- Notion pages organizadas vs orfas
- Workflows executados com sucesso / total
- Cross-validation agreement rate (Claude vs 5.4)
- Concurso: % acerto por especialidade, questoes/semana, Anki retention

## Onde Vive Cada Informacao

| O que | Onde | Nao duplicar em |
|-------|------|-----------------|
| Arquitetura (diagrama) | `CLAUDE.md` | aqui |
| Config de agentes | `config/ecosystem.yaml` | aqui |
| Config de workflows | `config/workflows.yaml` | aqui |
| Budget e rate limits | `config/rate_limits.yaml` | aqui |
| MCP servers | `config/mcp/servers.json` | aqui |
| Coautoria | `.claude/rules/coauthorship.md` | aqui |
| Seguranca Notion | `.claude/rules/mcp_safety.md` | aqui |
| Checklist setup | `PENDENCIAS.md` | aqui |
| Handoff entre sessoes | `HANDOFF.md` | aqui |
| Decisoes tecnicas | `docs/ARCHITECTURE.md` | aqui |
| Sync Notion ↔ Repo | `docs/SYNC-NOTION-REPO.md` | aqui |
| Aulas design system | `content/aulas/shared/` | aqui |
| Aulas roadmap tecnico | `content/aulas/STRATEGY.md` | aqui |
| Aulas QA scripts | `content/aulas/*/scripts/` | aqui |
| Concurso provas/SAPs | `assets/provas/`, `assets/sap/` | aqui |

---
Coautoria: Lucas + opus
Data: 2026-03-29
