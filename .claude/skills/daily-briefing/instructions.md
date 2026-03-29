---
name: daily-briefing
description: "Email diario: Gmail MCP leitura, classificacao e registro no Notion Emails Digest DB. Ativar no inicio do dia ou para processar emails."
---

# Skill: Daily Briefing (Email + Notion)

Leitura diaria de emails via Gmail MCP, classificacao e registro no
Notion Emails Digest DB, e geracao de briefing consolidado.

## Quando Ativar
- `/briefing` ou "resumo do dia", "daily briefing", "emails do dia"
- Agendado via /loop (diario)

## MCPs Necessarios
- **Gmail** (claude_ai_Gmail) — leitura de emails
- **Notion** (claude_ai_Notion) — Emails Digest DB

## Contas de Email
- `${EMAIL_INSTITUTIONAL}` — institucional HC-FMUSP (prioridade)
- `${EMAIL_PERSONAL}` — pessoal (Google Drive Ultra)

## Emails Digest DB (Notion)
- **Database ID**: `${NOTION_EMAILS_DIGEST_DB}`
- **Data Source**: `${NOTION_EMAILS_DIGEST_DS}`

### Properties (preencher para cada email relevante)
| Property | Tipo | Valores |
|----------|------|---------|
| Titulo | title | assunto do email |
| Categoria | select | Educação, Dev, Corporativos, AI, Subscribed, Medicina, Finanças, Networking |
| Prioridade | select | Muito Alta, Alta, Média, Baixa |
| Status | select | Pendente, Em Andamento, Concluído, Não requer ação |
| Tipo de Conteúdo | select | Newsletter, Transacional, Pessoal, Administrativo, Promocional, Automático |
| Leitura Recomendada | select | Ler Completo, Skim, Só Conceito |
| Valor do Insight | select | Raro, Fértil, Útil, Descartável |
| Conceito Central | text | ideia-chave em 1 frase |
| Próxima Ação | text | acao concreta (responder, ler, agendar...) |
| Data do Email | date | data de recebimento |
| Deadline | date | se houver prazo |
| Sender Email | email | remetente |
| Potencial Aula | checkbox | conteudo aproveitavel para ensino |

## Processo (sequencial)

### 1. READ — Gmail
- Buscar emails das ultimas 24h (ambas contas)
- Filtrar: ignorar spam, promocional obvio, notificacoes automaticas triviais
- Para cada email relevante, extrair: assunto, remetente, data, resumo do corpo

### 2. CLASSIFY — Avaliar cada email
Para cada email, determinar:
- **Categoria**: baseado no remetente e conteudo
- **Prioridade**: deadlines, remetentes importantes (HC, USP, orientador) = alta
- **Tipo de Conteudo**: newsletter vs pessoal vs administrativo etc
- **Leitura Recomendada**: conteudo denso = Ler Completo, info breve = Só Conceito
- **Valor do Insight**: conteudo original/raro vs rotineiro
- **Conceito Central**: 1 frase com a ideia-chave
- **Proxima Acao**: acao concreta ou "Não requer ação"
- **Potencial Aula**: conteudo pedagogico aproveitavel?
- **Deadline**: se mencionado no email

### 3. DEDUP — Verificar Notion
- Antes de criar entrada: buscar no Emails Digest se ja existe (por titulo + data)
- Se existir: pular (nao duplicar)

### 4. WRITE — Notion (com protocolo MCP safety)
- Criar 1 pagina por email relevante no Emails Digest DB
- UMA operacao por vez (regra mcp_safety.md)
- Verificar resultado apos cada write
- Se write falhar: PARAR

#### Titulo da pagina
Formato: `[Fonte] — [Titulo descritivo em PT]`
Exemplos:
- `NEJM — Beta-Bloqueadores pós-IAM: Meta-análise IPD de 17.801 Pacientes`
- `Import AI 447 — Economia AGI, Ecologias de Agentes e o Custo da Verificação Humana`
- `Sensible Medicine — OPTION Trial: Viés, Regulação Frouxa e Groupthink`

#### Corpo da pagina (content)
```markdown
## Resumo
[Paragrafo denso com detalhes do email — dados, numeros, conclusoes.
Nao e resumo superficial: e sintese com os dados relevantes.]

## Conceitos-Chave Expandidos
### 1. [Nome do Conceito]
**O que é**: [definicao precisa do conceito]
**Analogia**: [comparacao com outro dominio — medicina, filosofia, etc.]
**Tradeoff**: [limitacoes, tensoes, custos ocultos]
**Uso**: [aplicacao pratica — ensino, clinica, pesquisa, dev]

### 2. [Proximo conceito, se houver]
[mesma estrutura]
```

Regras do corpo:
- Resumo DENSO: incluir numeros, nomes, referencias concretas
- Conceitos-chave: introducao dos conceitos NECESSARIOS para entender o email
  - Conceitos previos: o que o leitor precisa saber antes (prerequisitos)
  - Conhecimento central: o que o email realmente traz de novo
  - Conhecimento posterior: para onde isso leva, o que abre, proximos passos
- Conceitos expandidos: 2-4 por email (so os que trazem insight real)
- Analogias: genuinas, interdisciplinares (medicina↔filosofia↔dev↔epistemologia)
- NAO forcar analogias medicas — preferir conexoes naturais
- Tradeoff obrigatorio: todo conceito tem custo ou limitacao
- Uso: conectar com metas do usuario (ensino, concurso, pesquisa, dev AI)

### 5. BRIEFING — Resumo consolidado
Gerar output no formato:

```
## Daily Briefing — [DATA]

### Prioridade Alta
- [TITULO] | [CATEGORIA] | Acao: [proxima acao]

### Para Ler
- [TITULO] | [LEITURA RECOMENDADA] | Conceito: [conceito central]

### Newsletters/Insights
- [TITULO] | Valor: [valor insight] | Conceito: [conceito central]

### Resumo
- Emails processados: N
- Alta prioridade: N
- Com deadline: N (proxima: [DATA])
- Potencial aula: N
- Registrados no Notion: N

Coautoria: Lucas + opus | [DATA]
```

## Criterios de Prioridade

| Remetente/Contexto | Prioridade Default |
|---------------------|-------------------|
| HC-FMUSP, USP, orientador | Muito Alta |
| Colegas de trabalho, departamento | Alta |
| Newsletters relevantes (AI, medicina) | Média |
| Promocional, automatico, notificacao | Baixa |
| Com deadline < 7 dias | +1 nivel |

## Protecoes
- Seguir protocolo mcp_safety.md para todos os writes
- Nunca marcar email como lido/arquivado sem aprovacao
- Emails com dados de paciente: flag LGPD, nao registrar conteudo
- Rate limit Gmail: respeitar (nao fazer burst)
- Se > 20 emails relevantes: pedir confirmacao antes de batch write

## Eficiencia
- Modelo recomendado: Sonnet (classificacao) + Opus (briefing)
- Gmail read = barato, Notion write = 1 por 1
- Registrar custo no BudgetTracker
