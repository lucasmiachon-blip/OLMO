# Configuracao de API Keys

> Referencia: `config/mcp/servers.json` (16 MCPs: 13 connected, 3 planned)

## MCPs Nativos claude.ai ($0 via Max — OAuth, sem API key)

Notion, PubMed, SCite, Consensus, Scholar Gateway, Gmail, Google Calendar, Canva, Excalidraw.
Autenticacao via OAuth no browser, sem variaveis de ambiente.

## Keys para MCPs Locais

### 1. Gemini MCP
```bash
export GOOGLE_AI_KEY="AIza..."
```
- **Uso**: MCP Gemini (pesquisa, analise, imagens, video)
- **Onde obter**: https://aistudio.google.com/

### 2. Perplexity MCP
```bash
export PERPLEXITY_API_KEY="pplx-..."
```
- **Uso**: MCP Perplexity (busca web, pesquisa, raciocinio)
- **Onde obter**: https://www.perplexity.ai/settings/api

### 3. Zotero MCP
```bash
export ZOTERO_LOCAL="true"
```
- **Uso**: MCP Zotero local (referencias, PDFs, busca)
- **Requisito**: Zotero Desktop rodando com Better BibTeX

### 4. NotebookLM MCP
- **Auth**: via browser (Google account)
- **Requisito**: NotebookLM server rodando localmente

## Keys Adicionais (codigo Python, nao MCPs)

### 5. Anthropic (scripts Python)
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```
- **Nota**: CLI Claude Code usa Max subscription, nao esta key
- **Uso**: Scripts Python que chamam API diretamente
- **Onde obter**: https://console.anthropic.com/

### 6. OpenAI (cross-validation)
```bash
export OPENAI_API_KEY="sk-..."
```
- **Uso**: Cross-validation Notion (ChatGPT 5.4 como auditor)
- **Onde obter**: https://platform.openai.com/

### 7. GitHub (MCP Server)
```bash
export GITHUB_TOKEN="ghp_..."
```
- **Uso**: Code search, issues, PRs
- **Free tier**: 5000 requests/hora
- **Onde obter**: GitHub Settings > Developer Settings > Personal Access Tokens

## Setup Rapido

```bash
cp .env.example .env
# Edite com suas chaves
```

## Seguranca

- NUNCA commite o arquivo `.env`
- Use `.env.example` como template (sem valores reais)
- Rotacione keys a cada 90 dias
- Use keys com permissoes minimas necessarias
