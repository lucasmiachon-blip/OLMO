# Regra: Seguranca MCP - Modelo Harsh

## Anti-Theft (Protecao de Credenciais)
- NUNCA logar keys/tokens em output
- Todas as credenciais via ${ENV_VAR}, nunca hardcoded
- OAuth com escopo MINIMO (read-only quando possivel)
- Notion: escopo limitado a databases especificos
- Gmail: --sanitize sempre habilitado

## Anti-Perda (Zero Data Loss)
- NUNCA deletar: apenas ARQUIVAR (Notion) ou LABEL+ARCHIVE (Gmail)
- Antes de WRITE: verificar se ja existe (dedup por titulo/PMID/message_id)
- Antes de UPDATE: snapshot do estado anterior no SQLite
- Operacao destrutiva = confirmacao humana OBRIGATORIA
- Batch > 5 items = confirmacao humana OBRIGATORIA
- Pagina com > 30 dias = confirmacao antes de editar

## Anti-Retrabalho (Cache + Checkpoints)
- SEMPRE verificar cache local antes de chamar MCP
- Workflows longos: checkpoint a cada step (resumable)
- Dedup de resultados ANTES de processar com modelo caro
- Se workflow falhar no step N: retomar de N, nao do zero

## Modelo Harsh (Na duvida, nao age)
- Confidence < 0.7 → flag para review humano
- Confidence < 0.5 → BLOQUEAR operacao
- Dados de paciente detectados → BLOQUEAR + alertar (LGPD)
- Erro em write → nao retry automatico
- Rate limit → parar, nao tentar fallback em writes
