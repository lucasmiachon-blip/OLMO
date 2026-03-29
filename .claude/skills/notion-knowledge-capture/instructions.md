---
name: notion-knowledge-capture
description: "Captura conversa/pesquisa e transforma em pagina estruturada no Masterpiece DB. Ativar apos discussao rica ou pesquisa que mereca registro."
---

# Skill: Notion Knowledge Capture

Transforma conversas, pesquisas e discussoes em documentacao estruturada
no Masterpiece DB do Notion.

## Quando Ativar
- Capturar resultado de pesquisa/discussao no Notion
- Converter output de agente em pagina Masterpiece
- Documentar decisao arquitetural ou clinica
- Criar entry no knowledge base a partir de conversa

## MCP: Seguir `.claude/rules/mcp_safety.md` INTEGRALMENTE

## Masterpiece DB Target

Database: `${NOTION_MASTERPIECE_DB}`
Data Source: `${NOTION_MASTERPIECE_DS}`

### Properties obrigatorias
| Property | Tipo | Valores |
|----------|------|---------|
| Name | title | Titulo descritivo |
| Pilar | select | MEDICINA, CIENCIAS FORMAIS, HUMANIDADES, TECNOLOGIA & IA, EDUCACAO, PROJETOS, OPERACIONAL, META/SISTEMA |
| Maturidade | select | Semente, Broto, Arvore |
| Status | select | Ativo, Em construcao, Arquivo |
| Tipo | select | Mapa, Topico, Pessoa, Galeria, Ferramenta, Curso, Template, Indice |

## Workflow

1. **Extrair** — pontos-chave, decisoes, action items da conversa
2. **Dedup** — verificar se titulo similar ja existe no Masterpiece (`notion-search`)
3. **Classificar** — pilar, maturidade, tipo
4. **Criar** — pagina no Masterpiece com properties corretas
5. **Verificar** — re-ler pagina criada e confirmar

## Formato da Pagina

```
# [Titulo]

> Fonte: [conversa/paper/discussao] | Data: [YYYY-MM-DD]

## Pontos-Chave
- [ponto 1]
- [ponto 2]

## Decisoes
- [decisao + justificativa]

## Action Items
- [ ] [item + responsavel + prazo]

## Referencias
- [fonte com PMID/DOI se aplicavel]

---
Coautoria: Lucas + [modelos]
```

## Anti-patterns
- Criar pagina sem verificar duplicata
- Esquecer properties do Masterpiece
- Conteudo medico sem referencia
