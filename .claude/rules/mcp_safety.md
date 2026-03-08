# Regra: Seguranca MCP - Protocolo Baseado em Evidencia

> Baseado em: GitHub Issues oficiais (makenotion/notion-mcp-server),
> ToolEmu/ICLR 2024, Bruce Schneier (Sep 2025), PromptArmor,
> Notion Security Best Practices, OWASP LLM Top 10 2025.

## FATOS (por que este protocolo existe)

1. Serialization bugs (#79, #82, #181): writes vao pro objeto errado
2. Permissoes nao respeitadas (#80): conteudo criado em workspace errado
3. NAO existe API para mover paginas entre parents (#64)
4. Melhor LLM agent falha 23.9% em tasks de seguranca (ToolEmu)
5. Update operations quebram consistentemente (#131)
6. Bulk operations falham repetidamente (#74)
7. Prompt injection sem solucao conhecida (Schneier)
8. Rate limit: 180 req/min (throttle em batch)

## PROTOCOLO NOTION MCP

### Fase 1: READ-ONLY (padrao)
- Usar token READ-ONLY por padrao (desmarcar "Update content" e "Insert content")
- Escopo: paginas especificas, NUNCA workspace inteiro
- Operacoes permitidas: notion-search, notion-fetch, notion-get-comments
- Objetivo: snapshot completo antes de qualquer acao

### Fase 2: WRITE (so apos snapshot + aprovacao humana)
- Trocar para token com write SOMENTE quando necessario
- UMA operacao por vez (nunca batch automatico — bug #74)
- Verificar resultado de cada write ANTES do proximo
- Se write falhar: PARAR, nao retry (bug de serialization pode enviar pra lugar errado)

### Fase 3: VERIFICACAO
- Apos cada write: re-ler a pagina pra confirmar que o resultado e o esperado
- Se resultado != esperado: PARAR + alertar humano
- Log de toda operacao no SQLite (state_before + state_after)

## OPERACOES PROIBIDAS (nao existem ou sao inseguras)

- MOVER paginas entre databases/parents → NAO EXISTE NA API (#64)
  - Workaround: CRIAR nova pagina no destino + COPIAR conteudo + ARQUIVAR original
- DELETE de databases → bloqueado pela API (safety feature)
- BULK writes automaticos → falham (#74), fazer 1 por 1
- "Always Approve" em writes → NUNCA habilitar
- Confiar em placement automatico → bug #80 coloca em workspace errado

## WORKAROUND PARA "MOVER" PAGINAS (seguro)

Como nao existe API de move, o fluxo seguro para reorganizar:
1. READ pagina original (snapshot completo: properties + content)
2. CREATE nova pagina no database correto com mesmo conteudo
3. VERIFICAR nova pagina (re-ler e comparar)
4. So se verificacao OK: ARCHIVE original (soft-delete, reversivel)
5. NUNCA deletar original antes de verificar a copia

## ANTI-PERDA (Zero Data Loss)

- NUNCA deletar: apenas ARQUIVAR (Notion trash = reversivel 30 dias)
- Antes de WRITE: verificar se pagina ja existe (dedup titulo/PMID)
- Antes de UPDATE: snapshot do estado anterior no SQLite
- Operacao destrutiva = confirmacao humana OBRIGATORIA
- Batch > 5 items = confirmacao humana OBRIGATORIA
- Pagina com > 30 dias = confirmacao antes de editar
- Notion tem version history nativo = safety net adicional

## ANTI-THEFT (Protecao de Credenciais)

- NUNCA logar keys/tokens em output
- Credenciais via ${ENV_VAR}, nunca hardcoded
- OAuth escopo MINIMO: paginas especificas, nao workspace
- Gmail: --sanitize sempre habilitado
- Verificar endpoint: SOMENTE mcp.notion.com/mcp (oficial)
- Cuidado com prompt injection via paginas compartilhadas

## ANTI-RETRABALHO (Cache + Checkpoints)

- SEMPRE verificar cache local antes de chamar MCP
- Workflows longos: checkpoint a cada step (resumable)
- Dedup de resultados ANTES de processar
- Se workflow falhar no step N: retomar de N, nao do zero
- Rate limit 180 req/min: respeitar, nao forcar

## CROSS-VALIDATION (Claude + ChatGPT 5.4)

Cruzar dois modelos independentes reduz erros significativamente.
Evidencia: ensemble/cross-check entre LLMs reduz hallucination e
erro de classificacao (benchmark literature 2024-2025).

Protocolo para writes no Notion:
1. Claude (Opus) propoe acao (ex: relocate pagina X para database Y)
2. ChatGPT 5.4 recebe MESMA pagina + proposta e avalia independentemente
3. Se AMBOS concordam (>= 0.8 confidence cada): auto-execute
4. Se DIVERGEM: flag para review humano com ambas justificativas
5. Se UM deles tem confidence < 0.5: BLOQUEAR

Quando usar cross-validation (OBRIGATORIO):
- Classificar tipo de pagina (original vs coautoria AI)
- Decidir relocacao entre databases
- Merge de duplicatas
- Archive de conteudo (pode ser referencia importante)
- Qualquer acao em > 10 paginas

Quando NAO precisa (single model OK):
- Read-only operations (snapshot, busca)
- Adicionar tags em pagina ja classificada
- Criar pagina nova (nao afeta existente)

Custo extra: $0 (ambos inclusos nos planos Pro/Max)

## MODELO HARSH (na duvida, nao age)

- Confidence < 0.7 → flag para review humano
- Confidence < 0.5 → BLOQUEAR operacao
- Dados de paciente detectados → BLOQUEAR + alertar (LGPD)
- Erro em write → PARAR (nao retry — pode ir pro lugar errado)
- Rate limit → parar imediatamente
- Resultado inesperado → PARAR + alertar humano
- Cross-validation divergente → PARAR + mostrar ambas justificativas

## SETUP RECOMENDADO (2 tokens)

```
Token 1 (read-only): uso diario, snapshot, busca, auditoria
  - Escopo: read_content apenas
  - Paginas: todas que precisar ler

Token 2 (read-write): so quando vai executar plano aprovado
  - Escopo: read_content + update_content + insert_content
  - Paginas: APENAS as que vai modificar
  - Ativar SOMENTE durante execucao
```

## FONTES

- makenotion/notion-mcp-server: Issues #64, #74, #77, #79, #80, #82, #107, #109, #131, #142, #181
- developers.notion.com/docs/mcp-security-best-practices
- ToolEmu (ICLR 2024): 23.9% failure rate on safety tasks
- Schneier (Sep 2025): "Zero agentic AI systems are secure against these attacks"
- PromptArmor: Notion data exfiltration via prompt injection
- OWASP LLM Top 10 2025: LLM01 = Prompt Injection
