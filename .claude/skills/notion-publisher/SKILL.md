---
name: notion-publisher
disable-model-invocation: true
description: >
  Create professional Notion pages with templates for medical evidence, digests,
  quick references, and knowledge capture into Masterpiece DB. Use this skill
  whenever the user wants to publish content to Notion, capture conversation
  insights, create structured pages, format research outputs, register knowledge,
  or organize the knowledge base. Trigger for any Notion write operation,
  'registrar no Notion', 'capturar no Notion', 'publicar', or after rich
  discussions that deserve documentation in the Masterpiece DB.
---

# Skill: Notion Publisher + Knowledge Capture

Designer de conteudo para Notion. Cria paginas bonitas, bem organizadas,
com informacao de qualidade referenciada. Tambem captura conversas e
pesquisas em paginas estruturadas no Masterpiece DB.

## MCP: Notion — SEGURANCA OBRIGATORIA

**OBRIGATORIO**: Seguir protocolo completo de `.claude/rules/mcp_safety.md`.

### Protocolo para TODA operacao Notion neste skill:

1. **READ-ONLY por padrao** — usar token read-only para snapshot/busca
2. **Antes de qualquer WRITE**:
   - Snapshot completo da pagina (state_before no SQLite)
   - Aprovacao humana obrigatoria
   - Cross-validation (Claude + ChatGPT 5.4) para conteudo medico
3. **UMA operacao por vez** — nunca batch automatico (bug #74)
4. **Apos cada WRITE**: re-ler pagina para confirmar resultado
5. **Se resultado != esperado**: PARAR + alertar humano
6. **NUNCA deletar** — apenas ARQUIVAR (reversivel 30 dias)
7. **Confidence < 0.7** → flag para review humano
8. **Registrar custo** no BudgetTracker para cada API call

## Knowledge Capture → Masterpiece DB

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

### Workflow Knowledge Capture
1. **Extrair** — pontos-chave, decisoes, action items da conversa
2. **Dedup** — verificar se titulo similar ja existe no Masterpiece (`notion-search`)
3. **Classificar** — pilar, maturidade, tipo
4. **Criar** — pagina no Masterpiece com properties corretas
5. **Verificar** — re-ler pagina criada e confirmar

### Formato da Pagina Knowledge Capture
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

## Templates de Pagina

### Template: Resumo de Evidencias Medicas
```
# [Topico Medico]

> Atualizado: [DATA]
> Nivel de Evidencia: [I-V]
> Grau de Recomendacao: [A-D]

## Pergunta Clinica (PICO)
| Componente | Descricao |
|-----------|-----------|
| **P**aciente | [populacao/problema] |
| **I**ntervencao | [tratamento/exposicao] |
| **C**omparador | [controle/alternativa] |
| **O**utcome | [desfecho primario] |

## Conclusao Principal
> [Conclusao em 1-2 frases com numeros concretos]
> NNT: [X] | RR: [Y] (IC95%: [Z])

## Evidencias

### Estudo 1: [Titulo Curto]
| Campo | Valor |
|-------|-------|
| Autores | [nomes] |
| Revista | [nome] ([ano]) |
| Design | [RCT/Coorte/etc] |
| n | [tamanho] |
| Nivel | [I-V] |
| PMID | [numero] |

**Resultados**: [achados principais com IC]
**Limitacoes**: [1-2 frases]

## Tabela Comparativa
| Estudo | Design | n | Resultado | IC 95% | Nivel |
|--------|--------|---|-----------|--------|-------|

## Analise Critica
### Pontos Fortes
### Limitacoes
### Scite Citation Check

## Referencias
1. [Autor et al. Titulo. Revista. Ano;Vol:pag. PMID: XXXXX]

## Estrategia de Busca
- **Bases**: PubMed, Cochrane, medRxiv
- **Termos**: [MeSH terms usados]
- **Filtros**: [tipo de estudo, data, idioma]

*Gerado por AI Agent Ecosystem | Revisado por: [nome do medico]*
```

### Template: Digest Semanal Medico
```
# Digest Medico - Semana [N], [Ano]

## Top 3 Evidencias da Semana
### 1. [Titulo]
> [Resumo em 2 frases] | Nivel [X] | [Revista]

## Guidelines Atualizadas
## Trials em Andamento
## Leitura Recomendada
```

### Template: Nota Clinica Rapida
```
# [Topico] - Quick Reference

> Evidencia: [Nivel] | Recomendacao: [Grau]

## TL;DR
## Indicacao
## Contraindicacao
## Dose / Protocolo
## Fonte
```

## Estetica Notion
- Cover images relacionadas ao topico
- Callout blocks para conclusoes-chave
- Toggle lists para detalhes expandiveis
- Dividers entre secoes
- Tabelas limpas e alinhadas

## Anti-patterns
- Criar pagina sem verificar duplicata
- Esquecer properties do Masterpiece
- Conteudo medico sem referencia
