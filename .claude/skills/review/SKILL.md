---
name: review
disable-model-invocation: true
description: "Multi-agent code review with OWASP LLM Top 10 2025, quality checks, and ecosystem conformance."
---

# Skill: Code Review

Revisor de codigo multi-agente com foco em qualidade, seguranca,
performance e conformidade com o ecossistema.

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

### 3. Seguranca (OWASP LLM Top 10 2025)
- Prompt Injection (LLM01)
- Insecure Output Handling (LLM02)
- Supply Chain Vulnerabilities (LLM05)
- Injection classica (SQL, command, XSS)
- Exposicao de credenciais/tokens
- Configuracao insegura de MCP
- Conformidade com `docs/mcp_safety_reference.md`

### 4. Performance
- Complexidade algoritmica
- Queries N+1
- Memory leaks
- Caching oportunidades
- Uso excessivo de API

### 5. Testes
- Cobertura adequada para logica de negocio
- Edge cases
- Testes de integracao (sem mocks desnecessarios)

### 6. Conformidade Ecossistema
- Coautoria explicitada? (`docs/coauthorship_reference.md`)

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
```

## Multi-Agent Review (para mudancas criticas)
1. **Quality Agent** (Sonnet) — reuso, legibilidade, padronizacao
2. **Security Agent** (Sonnet) — OWASP, credenciais, MCP safety
3. **Performance Agent** (Haiku) — complexidade, memory, caching

Consolidar achados em 1 relatorio unificado com dedup.

## Receiving Feedback (anti-sycophancy protocol)

Quando receber output de outro modelo (Codex, sentinel, GPT, adversarial audit) ou feedback externo, seguir este protocolo — NUNCA aceitar automaticamente.

### Protocolo: READ → VERIFY → EVALUATE → RESPOND

| Fase | Acao | Red flag se pular |
|------|------|-------------------|
| **READ** | Ler o feedback completo. Identificar cada claim separadamente. | "Great point!" antes de ler tudo |
| **VERIFY** | Para cada claim factico: verificar no codigo/fonte. Abrir o arquivo, ler a linha, confirmar. | Aceitar claim sobre codigo sem ler o arquivo |
| **EVALUATE** | O achado e real? E relevante? E acionavel? Passa no YAGNI check? | Implementar tudo sem filtrar |
| **RESPOND** | Aceitar com evidencia, rejeitar com justificativa, ou flag para Lucas. | Frases performativas (ver abaixo) |

### Frases PROIBIDAS (performativas)

Nunca usar ao receber feedback — indicam sycophancy, nao avaliacao:
- "You're absolutely right!"
- "Great catch!"
- "Excellent point!"
- "That's a really good observation"
- Qualquer variante de concordancia entusiastica sem evidencia

**Substituir por:** "Verificado em [arquivo:linha] — [confirmado|nao confirmado]. [Acao tomada ou justificativa]."

### YAGNI Check (antes de implementar feedback)

1. O problema existe AGORA ou e hipotetico?
2. Corrigir requer mudar codigo que funciona?
3. O fix adiciona complexidade desproporcional ao risco?
4. Lucas pediu isso ou e sugestao do modelo?

Se >= 2 respostas indicam "nao implementar" → classificar como `[INFO]` e reportar sem agir.

### Push-back criteria

Rejeitar feedback quando:
- Claim factual nao verificavel no codigo atual
- Sugestao contradiz regra/KBP existente
- Fix proposto quebra funcionalidade testada
- Escopo excede o que foi pedido (scope creep via review)
