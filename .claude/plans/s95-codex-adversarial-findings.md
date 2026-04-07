# S95 Codex Adversarial Review — Findings

> 4 batches. Batches 2+3 retornaram findings. Batches 1+4 falharam (re-rodar).
> Apos /clear, usar este arquivo para aplicar fixes.

## Batch 2: Agents + Rules (1 P0, 9 P1, 1 P2)

### P0

1. **`.claude/skills/insights/SKILL.md`** — /insights quebra propria regra de memoria
   - Diz "NEVER modifies memory files" mas escreve `.last-insights` dentro de `memory/`
   - Fix: mover `.last-insights` para fora de `memory/`, ou whitelistar explicitamente

### P1

2. **`.claude/rules/qa-pipeline.md`** — ~~evidence-db.md deprecated ainda no checklist~~
   - ~~Fix: remover references/evidence-db.md do QA checklist~~
   - **DONE S95** — ja removido nesta sessao

3. **`HANDOFF.md`** — Diz S90 deletou evidence-db.md, mas `cirrose/references/evidence-db.md` ainda existe
   - Fix: deletar o arquivo legacy ou corrigir HANDOFF para "migracao parcial"

4. **`.claude/agents/evidence-researcher.md`** — Sem maxTurns (obrigatorio por session-hygiene)
   - Fix: adicionar maxTurns estimado para 1-topic research + report

5. **`.claude/agents/notion-ops.md`** — Nao codifica gates obrigatorios do mcp_safety.md
   - Falta: cross-validation trigger, confidence < 0.70 => block
   - Tools no frontmatter (Read/Grep/Glob) nao incluem Notion tools reais
   - Fix: espelhar safety gates + adicionar tools corretos

6. **`.claude/agents/reference-checker.md`** — Promete cross-ref Notion mas nao tem acesso Notion
   - Fix: remover Notion do contrato, ou adicionar routing/tooling

7. **`.claude/hooks/README.md`** — Contagens de hooks stale (diz 11+10, real eh diferente)
   - Fix: recontar e relabear

8. **`HANDOFF.md`** — Decomposicao de hooks inconsistente (22 CC + 1 PreCompact + 1 pre-commit + 1 APL ≠ 25 runtime hooks)
   - Fix: reescrever como "25 Claude runtime hooks" + pre-commit separado

9. **`CLAUDE.md`** — pending-fixes.md path drift (docs dizem `pending-fixes.md`, hooks usam `.claude/pending-fixes.md`)
   - Fix: padronizar todos docs para `.claude/pending-fixes.md`

10. **`.claude/rules/qa-pipeline.md`** — KBP-05 "hard stop" eh so doc, nao tem hook
    - Fix: adicionar hook pre-agent ou downgrade docs de "hard stop" para "agent convention"

### P2

11. **`HANDOFF.md`** — /insights next marker stale (diz S94, deveria ser S95+)
    - Fix: mudar para S96 ou cadencia por data

---

## Batch 3: Config + Infra (4 P0, 8 P1)

### P0

12. **`docker-compose.yml:27`** — Secrets hardcoded com fallback previsivel
    - `LANGFUSE_DB_PASSWORD:-langfuse_local`, `REDIS_PASSWORD:-redis_local`, etc.
    - Fix: remover defaults inseguros, fail fast sem env vars

13. **`docker-compose.yml:151`** — Langfuse web (:3100) e OTel collector (:4317/:4318) expostos em todas interfaces
    - Fix: bind para `127.0.0.1:` em vez de `0.0.0.0`

14. **`otel-collector-config.yaml:35`** — Debug exporter ativo em producao
    - Telemetria duplicada nos container logs
    - Fix: remover debug exporter ou gater com env flag

15. **`daily-briefing/SKILL.md:102`** — Deadline cache persiste titulos sensiveis de emails
    - Titulos de pacientes podem leakar para `.claude/apl/deadlines.txt`
    - Fix: redact/hash labels antes de escrever cache

### P1

16. **`config/mcp/servers.json`** — 4 MCPs sem version pin (contradiz politica)
    - `@perplexity-ai/mcp-server`, `@rlabs-inc/gemini-mcp`, `@ankimcp/anki-mcp-server`, `@piotr-agier/google-drive-mcp`
    - Fix: pinar versoes

17. **`otel-collector-config.yaml:48`** — Pipeline logs exporta so para debug, nao Langfuse
    - Fix: adicionar `otlphttp/langfuse` ao logs pipeline ou corrigir comentarios

18. **`.claude/insights/failure-registry.json`** — Metadados de sample inconsistentes
    - "20 sessions S75-S81" mas S75-S81 = 7 session IDs
    - Fix: corrigir notes ou sessions_in_sample

19. **`daily-briefing/SKILL.md`** — Usa Google Calendar sem declarar em MCPs necessarios
    - Fix: adicionar Google Calendar a MCPs necessarios

20. **`.env.example`** — Faltam vars obrigatorias (LANGFUSE_AUTH_HEADER, passwords stack)
    - Fix: adicionar todas vars com comentarios

21. **`docker-compose.yml:71`** — Redis healthcheck sem autenticacao
    - Fix: `redis-cli -a "$REDIS_PASSWORD" ping`

22. **`docker-compose.yml:136`** — MinIO endpoint usa `localhost` dentro do container
    - Fix: mudar para `http://minio:9000`

23. **`docker-compose.yml:160`** — OTel collector image sem pin (`latest`)
    - Fix: pinar versao testada

---

## Batches 1 + 4: FALHARAM (re-rodar)

- **Batch 1:** Shell hooks (18 arquivos) — Codex nao retornou findings
- **Batch 4:** JS scripts (5 arquivos) — Codex nao retornou findings

---

## Mudancas ja aplicadas S95 (antes dos fixes)

| Arquivo | Mudanca |
|---------|---------|
| `.claude/agents/qa-engineer.md` | Preflight: 3 dims objetivas (cor, tipografia, hierarquia) |
| `.claude/rules/qa-pipeline.md` | Criteria → dims objetivas + gemini-qa3.mjs unico. Removido evidence-db.md |
| `.claude/context-essentials.md` | Script QA → gemini-qa3.mjs unico |
| `content/aulas/CLAUDE.md` | QA via gemini-qa3.mjs unico. qa-capture.mjs = utilitario |
| `content/aulas/metanalise/CLAUDE.md` | QA section simplificada |
| `content/aulas/README.md` | Rebuild ref + scripts por aula limpos |
| `content/aulas/metanalise/HANDOFF.md` | 35 checks → Preflight novo |
| `scripts/qa-batch-screenshot.mjs` | **Renomeado → qa-capture.mjs** |
| `grade/scripts/qa-batch-screenshot.mjs` | **Deletado** |
| `cirrose/docs/prompts/gate2-opus-visual.md` | **Deletado** |
| `cirrose/docs/prompts/gemini-gate4-editorial.md` | **Deletado** |
| `cirrose/AUDIT-VISUAL.md` + archive | **Deletado** |
| `gemini-qa3.mjs` | Refs internas → qa-capture.mjs |
| `package.json` | npm scripts → qa-capture.mjs |

---

## Proximo (S96)

1. **Verificar qa-capture.mjs:** usa Playwright CLI (direto) e NAO MCP? Se usa MCP, migrar.
2. Aplicar fixes P0 primeiro (security: docker ports, secrets, debug exporter, deadline cache)
3. Aplicar fixes P1 (agents maxTurns, notion-ops gates, hook counts, pending-fixes path)
4. Re-rodar Batches 1+4 (hooks shell + JS scripts)
5. Commit + HANDOFF + CHANGELOG
