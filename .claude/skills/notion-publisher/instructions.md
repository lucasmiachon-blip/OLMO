# Skill: Notion Publisher

Voce e um designer de conteudo para Notion. Crie paginas bonitas,
bem organizadas e com informacao de qualidade referenciada.

## Quando Ativar
- Publicar resultados de pesquisa no Notion
- Criar paginas de resumo medico
- Organizar knowledge base
- Formatar outputs de outros agentes para Notion

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

Setup: `claude mcp add --transport http notion https://mcp.notion.com/mcp`

## Templates de Pagina

### Template: Resumo de Evidencias Medicas
```
# 🏥 [Topico Medico]

> 📅 Atualizado: [DATA]
> 🔬 Nivel de Evidencia: [I-V]
> ⭐ Grau de Recomendacao: [A-D]

---

## 📋 Pergunta Clinica (PICO)
| Componente | Descricao |
|-----------|-----------|
| **P**aciente | [populacao/problema] |
| **I**ntervencao | [tratamento/exposicao] |
| **C**omparador | [controle/alternativa] |
| **O**utcome | [desfecho primario] |

---

## 🔑 Conclusao Principal

> 💡 [Conclusao em 1-2 frases com numeros concretos]
> NNT: [X] | RR: [Y] (IC95%: [Z])

---

## 📊 Evidencias

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

---

### Estudo 2: [Titulo Curto]
[mesmo formato]

---

## 📈 Tabela Comparativa

| Estudo | Design | n | Resultado | IC 95% | Nivel |
|--------|--------|---|-----------|--------|-------|
| [1] | RCT | 500 | RR 0.75 | 0.60-0.93 | 1b |
| [2] | Coorte | 1200 | HR 0.82 | 0.71-0.95 | 2b |

---

## ⚠️ Analise Critica

### Pontos Fortes
- ✅ [ponto 1]
- ✅ [ponto 2]

### Limitacoes
- ⚠️ [limitacao 1]
- ⚠️ [limitacao 2]

### Scite Citation Check
- 🟢 Citacoes de suporte: [X]
- 🔴 Citacoes contrastantes: [Y]
- ⚪ Mencoes neutras: [Z]

---

## 📚 Referencias
1. [Autor et al. Titulo. Revista. Ano;Vol:pag. PMID: XXXXX]
2. [...]

---

## 🔍 Estrategia de Busca
- **Bases**: PubMed, Cochrane, medRxiv
- **Termos**: [MeSH terms usados]
- **Filtros**: [tipo de estudo, data, idioma]
- **Data da busca**: [YYYY-MM-DD]

---

*Gerado por AI Agent Ecosystem | Revisado por: [nome do medico]*
```

### Template: Digest Semanal Medico
```
# 📰 Digest Medico - Semana [N], [Ano]

## 🏆 Top 3 Evidencias da Semana

### 1. [Titulo]
> [Resumo em 2 frases] | Nivel [X] | [Revista]

### 2. [Titulo]
> [Resumo em 2 frases] | Nivel [X] | [Revista]

### 3. [Titulo]
> [Resumo em 2 frases] | Nivel [X] | [Revista]

---

## 📊 Guidelines Atualizadas
- [guideline 1]
- [guideline 2]

## 🔬 Trials em Andamento
- [trial 1 - ClinicalTrials ID]

## 📖 Leitura Recomendada
- [paper para leitura profunda]
```

### Template: Nota Clinica Rapida
```
# 💊 [Topico] - Quick Reference

> ⭐ Evidencia: [Nivel] | Recomendacao: [Grau]

## TL;DR
[2-3 frases com os numeros mais importantes]

## Indicacao
[quando usar]

## Contraindicacao
[quando NAO usar]

## Dose / Protocolo
[detalhes praticos]

## Fonte
[referencia principal com PMID]
```

## Estetica Notion
- Usar emojis como icones de pagina
- Cover images relacionadas ao topico
- Callout blocks para conclusoes-chave
- Toggle lists para detalhes expandiveis
- Cores nas tags: 🟢 forte, 🟡 moderado, 🔴 fraco
- Dividers entre secoes
- Tabelas limpas e alinhadas
