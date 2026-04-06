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
- Para batch/reorganize/archive: seguir workflow completo em `notion-cross-validation.md`

## OPERACOES PROIBIDAS

- DELETE de databases → bloqueado pela API
- BULK writes automaticos → falham (#74), fazer 1 por 1
- "Always Approve" em writes → NUNCA habilitar

## ANTI-PERDA (Zero Data Loss)

- NUNCA deletar: apenas ARQUIVAR (trash = reversivel 30 dias)
- Antes de WRITE: dedup titulo/PMID
- Batch > 5 items ou operacao destrutiva: ver `notion-cross-validation.md`

## MODELO HARSH (na duvida, nao age)

- Writes SEMPRE requerem aprovacao humana (sem auto-execute)
- Confidence scoring serve como INPUT para decisao do Lucas, nao como gate automatico
- Confidence < 0.70 → BLOQUEAR (nem apresentar ao Lucas)
- Dados de paciente → BLOQUEAR (LGPD)
- Erro em write → PARAR (nao retry)

Cross-validation para writes: `.claude/rules/notion-cross-validation.md`
Referencia completa (setup, anti-theft, cache): `docs/mcp_safety_reference.md`
