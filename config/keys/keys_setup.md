# Configuracao de API Keys

## Keys Obrigatorias

### 1. Anthropic (Orquestrador + Subagentes)
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```
- **Modelos**: Opus 4.6, Sonnet 4.6, Haiku 4.5
- **Uso**: Orquestrador principal, todos os agentes
- **Pricing**: Pay-per-use (ver config/rate_limits.yaml)
- **Onde obter**: https://console.anthropic.com/

### 2. OpenAI (Auditor ChatGPT)
```bash
export OPENAI_API_KEY="sk-..."
```
- **Modelos**: GPT-5.4 (auditor), GPT-4o-mini (fallback)
- **Uso**: Auditoria semanal, segunda opiniao, cross-validation
- **Onde obter**: https://platform.openai.com/

## Keys Recomendadas

### 3. GitHub (MCP Server)
```bash
export GITHUB_TOKEN="ghp_..."
```
- **Uso**: MCP github server, code search, issues, PRs
- **Free tier**: 5000 requests/hora
- **Onde obter**: GitHub Settings > Developer Settings > Personal Access Tokens

### 4. Brave Search (MCP Server)
```bash
export BRAVE_API_KEY="BSA..."
```
- **Uso**: MCP brave-search server, busca web
- **Free tier**: 2000 queries/mes (suficiente!)
- **Onde obter**: https://brave.com/search/api/

### 5. HuggingFace (Modelos Open Source)
```bash
export HF_TOKEN="hf_..."
```
- **Uso**: Download de modelos, inference API
- **Free tier**: Sim
- **Onde obter**: https://huggingface.co/settings/tokens

## Keys Opcionais (Futuro)

### 6. Google AI (Gemini)
```bash
export GOOGLE_AI_KEY="AIza..."
```
- **Modelos**: Gemini 2.0 Pro/Flash
- **Uso**: Terceira opiniao, contexto 1M tokens
- **Onde obter**: https://aistudio.google.com/

### 7. Serper (Google Search API)
```bash
export SERPER_API_KEY="..."
```
- **Uso**: Alternativa ao Brave para busca web
- **Free tier**: 2500 queries gratis
- **Onde obter**: https://serper.dev/

## Setup Rapido

```bash
# Copie o template
cp .env.example .env

# Edite com suas chaves
nano .env

# Verifique
python -c "from dotenv import load_dotenv; load_dotenv(); import os; print('Anthropic:', 'OK' if os.getenv('ANTHROPIC_API_KEY') else 'MISSING')"
```

## Seguranca

- NUNCA commite o arquivo `.env`
- Use `.env.example` como template (sem valores reais)
- Rotacione keys a cada 90 dias
- Use keys com permissoes minimas necessarias
