# PENDENCIAS - O Que Falta Para Rodar

> Checklist de tudo que voce precisa configurar/assinar

## 🔴 CRITICO (Precisa para funcionar)

### API Keys
- [ ] **ANTHROPIC_API_KEY** - Orquestrador Opus 4.6 + Subagentes Sonnet/Haiku
  - Onde: https://console.anthropic.com/
  - Custo: Pay-per-use (~$2-5/mes estimado)
  - Config: adicionar no `.env`

- [ ] **OPENAI_API_KEY** - Auditor ChatGPT 5.4
  - Onde: https://platform.openai.com/
  - Custo: Pay-per-use (~$0.50/mes como auditor)
  - Config: adicionar no `.env`

### MCPs Criticos
- [ ] **Notion MCP** - Publicacao de conteudo
  - Setup: `claude mcp add --transport http notion https://mcp.notion.com/mcp`
  - Auth: OAuth via browser (vai pedir login no Notion)
  - Custo: Free tier funciona, Plus ($10/mo) para databases ilimitados

- [ ] **Gmail/Google Workspace MCP** - Emails medicos
  - Setup: `npx @anthropic-ai/google-workspace-mcp`
  - Auth: OAuth Google
  - Custo: Gratuito (usa sua conta Google)

## 🟡 RECOMENDADO (Melhora muito a experiencia)

### Assinaturas de Ferramentas
- [ ] **Perplexity Max** - ✅ JA TEM
  - Uso: Busca web avancada, pesquisa medica rapida
  - Integrar via fetch MCP ou como passo manual no workflow

- [ ] **Scite.ai** - Analise de citacoes medicas
  - Onde: https://scite.ai/pricing
  - Custo: ~$20/mo (Researcher) ou ~$10/mo (Basic)
  - Uso: Verificar se papers foram contraditos
  - API disponivel para integracao futura
  - **Alternativa free**: usar via browser manualmente

- [ ] **Consensus** - Consenso cientifico
  - Onde: https://consensus.app/pricing
  - Custo: Free (10 buscas/dia) ou Premium (~$10/mo)
  - Uso: Verificar o que as evidencias dizem sobre uma pergunta
  - **Free tier pode ser suficiente**

- [ ] **Elicit** - Extracao estruturada
  - Onde: https://elicit.com/pricing
  - Custo: Free (10 papers/dia) ou Plus (~$10/mo)
  - Uso: Tabelas PICO automaticas, scoping reviews
  - **Free tier pode ser suficiente**

- [ ] **Obsidian** - Vault local Zettelkasten
  - Onde: https://obsidian.md/ (gratuito)
  - Plugins: Zotero Integration, Dataview, Templater
  - Vault: `data/obsidian-vault/` (estrutura PARA)
  - Custo: Gratuito

- [ ] **Zotero** - Gerenciador de referencias
  - Onde: https://www.zotero.org/ (gratuito)
  - Plugins: Better BibTeX, Zotero Connector, Obsidian Integration
  - Custo: Gratuito (300MB cloud, ilimitado local)

- [ ] **Perplexity Max** - ✅ JA TEM
  - Uso: Busca web avancada para pesquisa medica

### API Keys Recomendadas
- [ ] **GITHUB_TOKEN** - MCP GitHub
  - Onde: GitHub Settings > Developer Settings > Personal Access Tokens
  - Custo: Gratuito (5000 req/h)

- [ ] **BRAVE_API_KEY** - Busca web alternativa
  - Onde: https://brave.com/search/api/
  - Custo: Gratuito (2000 req/mo)

## 🟢 OPCIONAL (Nice to have)

- [ ] **GOOGLE_AI_KEY** - Gemini (contexto 1M tokens)
  - Onde: https://aistudio.google.com/
  - Custo: Free tier generoso

- [ ] **HF_TOKEN** - HuggingFace (modelos open-source)
  - Onde: https://huggingface.co/settings/tokens
  - Custo: Gratuito

- [ ] **Notion Plus** - Databases ilimitados
  - Custo: $10/mo
  - Necessario se: muitas paginas/databases

## 🔧 SETUP TECNICO

### Software
- [ ] **Python 3.11+** - Runtime principal
- [ ] **Node.js 18+** - Necessario para MCPs (npx)
- [ ] **Ollama** - Modelos locais gratuitos
  - Install: `curl -fsSL https://ollama.ai/install.sh | sh`
  - Modelo: `ollama pull llama3.3`

### Notion Setup
- [ ] Criar database "Knowledge Base Medica" no Notion
- [ ] Criar database "Inbox Medico" no Notion
- [ ] Criar database "Digests Semanais" no Notion
- [ ] Configurar templates de pagina

### Gmail Setup
- [ ] Criar labels no Gmail:
  - `Medical/Newsletters`
  - `Medical/Papers`
  - `Medical/Alerts`
- [ ] Configurar filtros para categorizar emails medicos

### Ambiente
- [ ] Copiar `.env.example` para `.env`
- [ ] Preencher API keys no `.env`
- [ ] Instalar dependencias: `pip install -e ".[dev]"`

## 💰 CUSTO MENSAL ESTIMADO

| Item | Custo/mes | Necessario? |
|------|----------|-------------|
| Anthropic API (Opus+Sonnet) | $2-5 | Sim |
| OpenAI API (ChatGPT auditor) | $0.50 | Sim |
| Notion Free/Plus | $0-10 | Free funciona |
| Perplexity Max | ✅ Ja tem | - |
| Scite Basic | $0-10 | Free via browser |
| Consensus | $0-10 | Free tier ok |
| Elicit | $0-10 | Free tier ok |
| **TOTAL MINIMO** | **~$3-6** | |
| **TOTAL COM TUDO** | **~$15-35** | |

## 📋 ORDEM DE SETUP RECOMENDADA

1. ✅ Repositorio criado e estruturado
2. → API keys Anthropic + OpenAI no `.env`
3. → Instalar MCPs medicos (healthcare, pubmed, biomcp)
4. → Configurar Notion MCP + criar databases
5. → Configurar Gmail MCP + criar labels
6. → Instalar Context7 MCP
7. → Testar workflow `quick_note_to_evidence`
8. → Testar workflow `paper_to_notion`
9. → Configurar Scite/Consensus/Elicit (browser primeiro)
10. → Agendar workflows automaticos
