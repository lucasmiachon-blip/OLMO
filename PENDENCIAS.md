# PENDENCIAS - O Que Falta Para Rodar

> Checklist de tudo que voce precisa configurar/assinar
> Atualizado: 8 de Marco de 2026

## CRITICO (Precisa para funcionar)

### API Keys
- [ ] **ANTHROPIC_API_KEY** - Orquestrador Opus 4.6 + Subagentes Sonnet/Haiku
  - Onde: https://console.anthropic.com/
  - Custo: Pay-per-use (~$3-4/mes estimado)
  - Config: adicionar no `.env`

- [ ] **OPENAI_API_KEY** - Auditor ChatGPT 5.4 (via API, opcional se usar web)
  - Onde: https://platform.openai.com/
  - Custo: Pay-per-use (~$0.50/mes como auditor)
  - Config: adicionar no `.env`

### MCPs Criticos
- [ ] **Healthcare MCP** - PubMed, FDA, ClinicalTrials, CID-10
  - Setup: `claude mcp add healthcare-mcp npx -- -y healthcare-mcp`
  - Custo: Gratuito

- [ ] **PubMed MCP** - Busca avancada 39M+ citacoes
  - Setup: `claude mcp add pubmed-mcp npx -- -y pubmed-mcp`
  - Custo: Gratuito

- [ ] **BioMCP** - Queries biomedicas em linguagem natural
  - Setup: `claude mcp add biomcp npx -- -y biomcp`
  - Custo: Gratuito

- [ ] **Notion MCP** - Publicacao de conteudo (PROTOCOLO SEGURO)
  - Setup: `claude mcp add --transport http notion https://mcp.notion.com/mcp`
  - Auth: OAuth via browser (2 tokens: read-only padrao + read-write sob demanda)
  - Custo: $0 via Claude Pro/Max
  - **SEGURANCA**: Ver `.claude/rules/mcp_safety.md` (bugs conhecidos, protocolo)
  - **IMPORTANTE**: Nao existe API de move — usar criar+copiar+verificar+arquivar

- [ ] **Gmail/Google Workspace MCP** - Emails medicos
  - Setup: `npx @anthropic-ai/google-workspace-mcp`
  - Auth: OAuth Google
  - Custo: Gratuito

## RECOMENDADO (Melhora muito a experiencia)

### Ferramentas JA TEM
- [x] **Perplexity Max** - Busca web avancada
- [x] **Excalidraw** - Diagramas e whiteboard
- [x] **Canva Pro** - Design e apresentacoes
- [x] **Google One Ultra 30TB** - Google Drive + Gemini
- [x] **Claude Pro/Max** - Claude.ai + Cowork

### Ferramentas para Instalar/Configurar
- [ ] **Obsidian** - Vault local Zettelkasten (gratuito)
  - Onde: https://obsidian.md/
  - Plugins: Zotero Integration, Dataview, Templater

- [ ] **Zotero** - Gerenciador de referencias (gratuito)
  - Onde: https://www.zotero.org/
  - Plugins: Better BibTeX, Zotero Connector

### Ferramentas MBE (Free via Browser)
- [ ] **Scite.ai** - Citacoes suporte vs contraste (free via browser)
  - Premium opcional: ~$10-20/mo
- [ ] **Consensus** - Consenso cientifico (free 10/dia)
  - Premium opcional: ~$10/mo
- [ ] **Elicit** - Extracao PICO (free 10 papers/dia)
  - Premium opcional: ~$10/mo

### Cowork Setup
- [ ] **Claude Desktop** com Cowork habilitado
  - Criar Skill "Extrair UpToDate" no Cowork
  - Criar Skill "Extrair DynaMed" no Cowork
  - Criar Skill "Extrair BMJ Best Practice" no Cowork
  - Frequencia: 2-3x/semana, disparar manualmente

### API Keys Recomendadas
- [ ] **GITHUB_TOKEN** - MCP GitHub (gratuito, 5000 req/h)
- [ ] **BRAVE_API_KEY** - Busca web alternativa (gratuito, 2000 req/mo)

## ENSINO + CONCURSO NOV/2026

### Concurso (120 questoes multipla escolha — PRIORIDADE DO ANO)
- [ ] Definir especialidades/topicos do concurso
- [ ] Criar database Notion "Concurso Error Log" (ver skill teaching-improvement)
- [ ] **Anki + AnkiConnect** — instalar Anki Desktop + add-on AnkiConnect (2055492159)
- [ ] **Anki MCP** — `claude mcp add anki-mcp npx -- -y @ankimcp/anki-mcp-server`
  - Opus + ChatGPT 5.4 geram cards baseados no Error Log e desempenho
  - AI prioriza: erros recorrentes > unicos > conteudo novo
  - Max 20 cards novos/dia, cross-validados
- [ ] Criar decks por especialidade no Anki
- [ ] **MedAdapt MCP** — conteudo educacional medico (PubMed/NCBI Bookshelf)
  - Setup: verificar `ryoureddy/medadapt-content-server`
- [ ] Assinar/configurar banco de questoes
  - Plataformas BR (Estrategia MED, Sanar, etc): SEM API publica
  - Alternativa: provas anteriores publicas (USP, UNICAMP, UNIFESP)
  - Alternativa: MedMCQA dataset (194k questoes, open source)
- [ ] Criar plano macro Mar-Nov no Notion (calendario de estudo)
- [ ] Configurar Claude como quiz generator (prompt template)
- [ ] Primeiro simulado baseline (120 questoes cronometrado)

### Ensino (Professor)
- [ ] Criar database Notion "Teaching Log" (error log de aulas)
- [ ] Configurar workflow de preparacao de aulas (skill teaching-improvement)
- [ ] Desenvolver curriculo "AI para Alunos de Medicina" (8 aulas)

## OPCIONAL (Nice to have)

- [ ] **GOOGLE_AI_KEY** - Gemini API (free tier generoso)
- [ ] **HF_TOKEN** - HuggingFace (gratuito)
- [ ] **Notion Plus** - Databases ilimitados ($10/mo)
- [ ] **Make** - Automacao low-code (PLANO FUTURO)
- [ ] **n8n** - Automacao self-hosted (PLANO FUTURO)

## SETUP TECNICO

### Software
- [ ] **Python 3.11+** - Runtime principal
- [ ] **Node.js 18+** - Necessario para MCPs (npx)
- [ ] **Ollama** - Modelos locais gratuitos
  - `curl -fsSL https://ollama.ai/install.sh | sh`
  - `ollama pull llama3.3`

### Notion Setup (Ultimate Brain + Medico)
- [x] **Ultimate Brain** (Thomas Frank) - Template base ja instalado
  - Fonte: https://thomasjfrank.com/brain/
  - Funcionalidades: GTD tasks, PARA organization, My Day dashboard, Quick Capture
  - Companion: Flylighter (browser extension para quick capture)
- [ ] **P0: Snapshot do estado atual** - Ler TUDO via MCP antes de qualquer mudanca
  - Usar NotionCleaner.snapshot() → gera notion_snapshot.md local
  - Identificar: databases existentes, paginas, properties, duplicatas
  - Entender estrutura atual do Ultimate Brain antes de customizar
- [ ] Adaptar Ultimate Brain para workflow medico:
  - Mapear databases UB → nossos databases (Knowledge Base, Inbox, Digests, Projetos)
  - Adicionar properties medicas (Tipo, Especialidade, PMID, Nivel Evidencia)
  - Manter dashboard e views do UB (ja sao bons)
- [ ] Criar database "Knowledge Base Medica" (ou adaptar do UB)
- [ ] Criar database "Inbox Medico" (ou adaptar do UB)
- [ ] Criar database "Digests Semanais"
- [ ] Configurar templates de pagina

### Gmail Setup
- [ ] Criar labels: `Medical/Newsletters`, `Medical/Papers`, `Medical/Alerts`
- [ ] Configurar filtros para categorizar emails medicos

### Ambiente
- [ ] Copiar `.env.example` para `.env`
- [ ] Preencher API keys no `.env`
- [ ] Instalar dependencias: `pip install -e ".[dev]"`

## CUSTO MENSAL ESTIMADO

Budget definido: **$100/mes** (testar por 30 dias e ajustar)

| Item | Custo/mes | Necessario? |
|------|----------|-------------|
| Anthropic API (Opus+Sonnet+Haiku) | $10-40 (depende do routing) | Sim |
| OpenAI API (auditor, opcional) | $0-0.50 | Opcional (web $0) |
| Cowork + ChatGPT Agent | $0 | Ja tem planos |
| Perplexity Max | $0 | Ja tem |
| Google One Ultra (Gemini+Drive) | $0 | Ja tem |
| Canva Pro | $0 | Ja tem |
| Notion Free | $0 | Free funciona |
| Scite/Consensus/Elicit (browser) | $0 | Free via browser |
| **TOTAL ESTIMADO** | **~$10-40** | |
| **BUDGET MAX** | **$100** | Margem para teste |

> Nota: Uma pesquisa PubMed completa (query→triagem→leitura→sintese)
> gasta ~10-12 requests API. Monitoramento AI 2x/dia = ~240 req/mes.
> Total estimado: ~400-700 req/mes. Testar e ajustar.

## ORDEM DE SETUP RECOMENDADA

1. [x] Repositorio criado e estruturado
2. [ ] API keys Anthropic + OpenAI no `.env`
3. [ ] Instalar MCPs medicos (healthcare, pubmed, biomcp)
4. [ ] Configurar Notion MCP + criar databases
5. [ ] Configurar Gmail MCP + criar labels
6. [ ] Instalar Context7 MCP
7. [ ] Configurar Cowork Skills para fontes pagas
8. [ ] Testar workflow `quick_note_to_evidence`
9. [ ] Testar workflow `paper_to_notion`
10. [ ] Configurar Scite/Consensus/Elicit (browser primeiro)
