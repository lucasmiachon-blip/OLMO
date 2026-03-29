---
paths:
  - "**/*notion*"
  - "**/*mcp*"
  - "config/mcp/**"
---

# Regra: Seguranca MCP

<!-- Fontes: makenotion/notion-mcp-server #64,#74,#79,#80,#82,#131,#181 | OWASP LLM Top 10 2025 -->

## PROTOCOLO NOTION MCP

### Fase 1: READ-ONLY (padrao)
- Escopo: paginas especificas, NUNCA workspace inteiro
- Operacoes: notion-search, notion-fetch, notion-get-comments
- Objetivo: snapshot completo antes de qualquer acao

### Fase 2: WRITE (so apos snapshot + aprovacao humana)
- UMA operacao por vez (nunca batch automatico — bug #74)
- Verificar resultado de cada write ANTES do proximo
- Se write falhar: PARAR, nao retry (bug de serialization)

### Fase 3: VERIFICACAO
- Apos cada write: re-ler a pagina pra confirmar resultado
- Se resultado != esperado: PARAR + alertar humano

## OPERACOES PROIBIDAS

- DELETE de databases → bloqueado pela API
- BULK writes automaticos → falham (#74), fazer 1 por 1
- "Always Approve" em writes → NUNCA habilitar

## ANTI-PERDA (Zero Data Loss)

- NUNCA deletar: apenas ARQUIVAR (trash = reversivel 30 dias)
- Antes de WRITE: dedup titulo/PMID
- Batch > 5 items = confirmacao humana OBRIGATORIA
- Operacao destrutiva = confirmacao humana OBRIGATORIA

## MODELO HARSH (na duvida, nao age)

- Confidence >= 0.95 → auto-execute
- Confidence 0.70-0.94 → flag para review humano
- Confidence < 0.70 → BLOQUEAR
- Dados de paciente → BLOQUEAR (LGPD)
- Erro em write → PARAR (nao retry)

Cross-validation para writes: `.claude/rules/notion-cross-validation.md`
Referencia completa (setup, anti-theft, cache): `docs/mcp_safety_reference.md`
