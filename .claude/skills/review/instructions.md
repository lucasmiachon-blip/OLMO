---
name: review
description: "Code review multi-agente com OWASP LLM Top 10 2025. Ativar para revisar PRs, auditar seguranca ou checar qualidade de codigo."
---

# Skill: Code Review

Revisor de codigo multi-agente com foco em qualidade, seguranca,
performance e conformidade com o ecossistema.

## Quando Ativar
- `/review` ou "revisar codigo", "review PR"
- Antes de merge/deploy
- Auditoria de seguranca
- Analise de qualidade de codigo

## Processo de Review

### 1. Contexto
- `git diff` para ver mudancas (staged + unstaged)
- Entender proposito das mudancas
- Verificar impacto no sistema
- Checar se toca em arquivos protegidos (.claude/rules/, config/)

### 2. Qualidade
- Legibilidade e clareza
- Nomes significativos
- Complexidade desnecessaria (over-engineering)
- Duplicacao de codigo
- Type hints (obrigatorio por convencao)
- Conformidade com `.claude/rules/quality.md`

### 3. Seguranca (OWASP LLM Top 10 2025)
- Prompt Injection (LLM01)
- Insecure Output Handling (LLM02)
- Supply Chain Vulnerabilities (LLM05)
- Injection classica (SQL, command, XSS)
- Exposicao de credenciais/tokens
- Configuracao insegura de MCP
- Conformidade com `.claude/rules/mcp_safety.md`

### 4. Performance
- Complexidade algoritmica
- Queries N+1
- Memory leaks
- Caching oportunidades
- Uso excessivo de API (conformidade com rules/efficiency.md)

### 5. Testes
- Cobertura adequada para logica de negocio
- Edge cases
- Testes de integracao (sem mocks desnecessarios)

### 6. Conformidade Ecossistema
- Coautoria explicitada? (rules/coauthorship.md)
- Notion writes seguem protocolo? (rules/mcp_safety.md)
- Budget respeitado? (config/rate_limits.yaml)

## Severity Levels

| Level | Tag | Acao |
|-------|-----|------|
| P0 Critical | `[BLOCK]` | Bloqueia merge, fix imediato |
| P1 Important | `[WARN]` | Deveria corrigir antes de merge |
| P2 Suggestion | `[INFO]` | Nice to have, nao bloqueia |
| P3 Nitpick | `[NIT]` | Estilo, preferencia pessoal |

## Formato de Output

```
## Code Review: [ARQUIVO/PR]

### Resumo
[1-2 frases sobre as mudancas]

### Veredito: APROVADO | MUDANCAS NECESSARIAS | BLOQUEADO

### Issues

#### [BLOCK] Criticas
- file:line — descricao — sugestao de fix

#### [WARN] Importantes
- file:line — descricao — sugestao de fix

#### [INFO] Sugestoes
- file:line — descricao

### Pontos Positivos
- ...
```

## Multi-Agent Review (para mudancas criticas)
Rodar 3 agentes em paralelo via Agent tool:
1. **Quality Agent** (Sonnet) — reuso, legibilidade, padronizacao
2. **Security Agent** (Sonnet) — OWASP, credenciais, MCP safety
3. **Performance Agent** (Haiku) — complexidade, memory, caching

Consolidar achados em 1 relatorio unificado com dedup.

## Cross-Validation com ChatGPT
Para decisoes criticas (arquitetura, seguranca), envie o mesmo
codigo para ChatGPT 5.4 como segunda opiniao independente.

## Eficiencia
- Review simples: Sonnet (single agent)
- Review critico: multi-agent (Sonnet + Haiku)
- Registrar custo no BudgetTracker
