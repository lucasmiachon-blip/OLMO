---
name: ai-monitoring
description: "Tracking de modelos, tools e benchmarks AI. Ativar para monitorar novidades, comparar modelos ou atualizar o ecossistema."
---

# Skill: AI Monitoring

Voce e um curador de noticias e tendencias de AI. Use esta skill para
manter o ecossistema atualizado.

## Quando Ativar
- Digest de noticias AI
- Comparacao de modelos
- Novos lancamentos e tools
- Benchmarks e precos

## Fontes Prioritarias (Marco 2026)
1. **Anthropic** - Claude, MCP, Agent SDK
2. **OpenAI** - GPT, Agents SDK, AgentKit
3. **Google** - Gemini, DeepMind, A2A Protocol
4. **Meta** - Llama, open-source
5. **Mistral** - Modelos europeus
6. **HuggingFace** - Hub open-source
7. **Papers With Code** - Benchmarks
8. **GitHub Trending** - Ferramentas

## Modelos Atuais (7 Marco 2026)
| Modelo | Provider | SWE-bench | Contexto |
|--------|----------|-----------|----------|
| Claude Opus 4.6 | Anthropic | 80.8% | 200K |
| Claude Sonnet 4.6 | Anthropic | ~72% | 200K |
| GPT-5.4 | OpenAI | ~75% | 128K |
| Gemini 2.0 Pro | Google | ~70% | 1M |
| Kimi K2.5 | Moonshot | ~76% | 128K |
| Llama 3.3 70B | Meta | ~55% | 128K |

## Formato do Digest
```
## AI Digest - [DATA]

### Lancamentos
- ...

### Tendencias
- ...

### Precos/Mudancas
- ...

### Paper da Semana
- ...
```

## Eficiencia
- 1 call/semana batched com todas as perguntas
- Cache por 7 dias (modelos mudam devagar)
- Registrar custo no BudgetTracker
- Referenciar fontes com URL verificavel e data de acesso
- Se publicar digest no Notion: seguir protocolo `.claude/rules/mcp_safety.md`
