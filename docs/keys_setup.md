# Configuracao de API Keys

> Referencia: `config/mcp/servers.json`

## MCPs Nativos claude.ai ($0 via Max — OAuth, sem API key)

Notion, PubMed, SCite, Consensus, Scholar Gateway, Gmail, Google Calendar, Canva, Excalidraw.
Autenticacao via OAuth no browser, sem variaveis de ambiente.

## Keys para MCPs Locais

### 1. Gemini API (scripts)
```bash
export GEMINI_API_KEY="AIza..."
```
- **Uso**: Script `gemini-qa3.mjs` (API key, nao MCP). `content-research.mjs` removido S106 — substituido por `/research` skill.
- **Onde obter**: https://aistudio.google.com/
- **Nota**: Gemini MCP descartado S71 (nunca conectou). Usar API via scripts.

### 2. Perplexity API direta
```bash
export PERPLEXITY_API_KEY="pplx-..."
```
- **Uso**: integracoes diretas e experimentos locais; MCP Perplexity foi removido do inventory atual
- **Onde obter**: https://www.perplexity.ai/settings/api

### 3. Zotero local + script Python
```bash
export ZOTERO_LOCAL="true"
export ZOTERO_API_KEY="..."
export ZOTERO_LIBRARY_ID="..."
```
- **Uso**: `ZOTERO_LOCAL=true` para inventory local; `ZOTERO_API_KEY` + `ZOTERO_LIBRARY_ID` para `scripts/fetch_medical.py`
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

### 8. Langfuse local (docker compose + OTel)
```bash
export LANGFUSE_DB_PASSWORD="..."
export CLICKHOUSE_PASSWORD="..."
export REDIS_PASSWORD="..."
export MINIO_PASSWORD="..."
export ENCRYPTION_KEY="..."
export LANGFUSE_SALT="..."
export NEXTAUTH_SECRET="..."
export LANGFUSE_PUBLIC_KEY="pk-lf-..."
export LANGFUSE_SECRET_KEY="sk-lf-..."
export LANGFUSE_AUTH_HEADER="<base64 public:secret>"
```
- **Uso**: `docker compose up -d` + collector em `config/otel/otel-collector-config.yaml`
- **Nota**: `LANGFUSE_AUTH_HEADER` e o Base64 de `LANGFUSE_PUBLIC_KEY:LANGFUSE_SECRET_KEY`

## Setup Rapido

```bash
cp .env.example .env
# Edite com as variaveis que realmente usar
```

PowerShell:

```powershell
Copy-Item .env.example .env
```

## Seguranca

- NUNCA commite o arquivo `.env`
- Use `.env.example` como template (sem valores reais)
- Rotacione keys a cada 90 dias
- Use keys com permissoes minimas necessarias
