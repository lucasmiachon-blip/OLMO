---
name: daily-briefing
description: >
  Daily email processing: Gmail MCP reading, classification, and Notion Emails
  Digest DB registration with expanded concept analysis. Use this skill at the
  start of each day, when processing emails, generating daily summaries, or
  when the user says 'briefing', 'resumo do dia', 'emails do dia', 'o que
  chegou', or wants to catch up on recent communications.
---

# Skill: Daily Briefing (Email + Notion)

Leitura diaria de emails via Gmail MCP, classificacao e registro no
Notion Emails Digest DB, e geracao de briefing consolidado.

## MCPs Necessarios
- **Gmail** (claude_ai_Gmail) — leitura de emails
- **Notion** (claude_ai_Notion) — Emails Digest DB

## Contas de Email
- `${EMAIL_INSTITUTIONAL}` — institucional HC-FMUSP (prioridade)
- `${EMAIL_PERSONAL}` — pessoal (Google Drive Ultra)

## Emails Digest DB (Notion)
- **Database ID**: `${NOTION_EMAILS_DIGEST_DB}`
- **Data Source**: `${NOTION_EMAILS_DIGEST_DS}`

### Properties
| Property | Tipo | Valores |
|----------|------|---------|
| Titulo | title | assunto do email |
| Categoria | select | Educacao, Dev, Corporativos, AI, Subscribed, Medicina, Financas, Networking |
| Prioridade | select | Muito Alta, Alta, Media, Baixa |
| Status | select | Pendente, Em Andamento, Concluido, Nao requer acao |
| Tipo de Conteudo | select | Newsletter, Transacional, Pessoal, Administrativo, Promocional, Automatico |
| Leitura Recomendada | select | Ler Completo, Skim, So Conceito |
| Valor do Insight | select | Raro, Fertil, Util, Descartavel |
| Conceito Central | text | ideia-chave em 1 frase |
| Proxima Acao | text | acao concreta |
| Data do Email | date | data de recebimento |
| Deadline | date | se houver prazo |
| Potencial Aula | checkbox | conteudo aproveitavel para ensino |

## Processo

### 1. READ — Gmail
- Buscar emails das ultimas 24h (ambas contas)
- Filtrar: ignorar spam, promocional obvio, notificacoes triviais

### 2. CLASSIFY — Avaliar cada email
- Categoria, Prioridade, Tipo de Conteudo
- Leitura Recomendada, Valor do Insight
- Conceito Central (1 frase com a ideia-chave)
- Proxima Acao, Deadline, Potencial Aula

### 3. DEDUP — Verificar Notion
- Buscar no Emails Digest se ja existe (por titulo + data)

### 4. WRITE — Notion (com protocolo MCP safety)
- UMA operacao por vez (regra mcp_safety.md)
- Verificar resultado apos cada write

#### Titulo da pagina
Formato: `[Fonte] — [Titulo descritivo em PT]`

#### Corpo da pagina
```markdown
## Resumo
[Paragrafo denso com dados, numeros, conclusoes]

## Conceitos-Chave Expandidos
### 1. [Nome do Conceito]
**O que e**: [definicao precisa]
**Analogia**: [comparacao interdisciplinar genuina]
**Tradeoff**: [limitacoes, custos ocultos]
**Uso**: [aplicacao pratica — ensino, clinica, pesquisa, dev]
```

### 5. BRIEFING — Resumo consolidado
```
## Daily Briefing — [DATA]
### Prioridade Alta
### Para Ler
### Newsletters/Insights
### Resumo
- Emails processados: N
- Alta prioridade: N
- Com deadline: N
```

## Criterios de Prioridade

| Remetente/Contexto | Prioridade Default |
|---------------------|-------------------|
| HC-FMUSP, USP, orientador | Muito Alta |
| Colegas de trabalho | Alta |
| Newsletters relevantes | Media |
| Promocional, automatico | Baixa |
| Com deadline < 7 dias | +1 nivel |

### 6. APL CACHE — Deadline cache for ambient hooks
After processing, write upcoming deadlines to `.claude/apl/deadlines.txt`:
- Source: emails with Deadline property (< 7 days) + Google Calendar next 7 days
- Format per line: `"Title" | Xd Xh` (time remaining)
- Max 3 lines, sorted by urgency (soonest first)
- If no deadlines found, leave file empty (do not delete)
- Example:
  ```
  "Aula Cirrose" | 2d 5h
  "Revisao paper" | 5d 12h
  ```

## Protecoes
- Seguir protocolo mcp_safety.md para todos os writes
- Nunca marcar email como lido/arquivado sem aprovacao
- Emails com dados de paciente: flag LGPD, nao registrar conteudo
- Se > 20 emails relevantes: pedir confirmacao antes de batch write
