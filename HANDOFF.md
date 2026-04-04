# HANDOFF - Proxima Sessao

> Sessao 64 | 2026-04-04

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 9 rules (5 path-scoped).
Gemini CLI atualizado (0.36.0), OAuth Ultra ativo (lucasmiachon87@gmail.com).
Codex CLI v0.118.0, plugin `codex@openai-codex` ativo.
GEMINI.md + AGENTS.md criados (rascunho v1 — refinar com pesquisa abaixo).

## P0 — CONTINUAR (Instalacao CLI)

### Fase 1: Remover Gemini MCP ($$ → $0)
1. `claude mcp remove gemini` — remove o MCP server local (@rlabs-inc/gemini-mcp)
2. Editar `settings.local.json`: remover linha `"mcp__gemini__*"` das permissions
3. Atualizar `config/mcp/servers.json`: marcar gemini como `"status": "removed"`
4. Testar que eu (Claude Code) uso `gemini -p "..."` via Bash (OAuth, $0)

### Fase 2: Migrar scripts de API key → CLI OAuth
- `gemini-qa3.mjs` — QA visual multimodal (envia PNGs via API key). Reescrever para usar `gemini -p @./screenshot.png` (OAuth, $0). Multimodal INCLUSO na quota Ultra.
- `content-research.mjs` — ja tem `--prompt-only` mode. Pode chamar `gemini -p` como backend.
- **Economia estimada**: $200/20 slides → $0 (toda analise visual via OAuth)

### Fase 3: Refinar GEMINI.md e AGENTS.md com pesquisa
Pesquisa completa feita (3 agentes). Principais achados para aplicar:

**AGENTS.md (Codex):**
- Focar em COMANDOS copy-pasteable, nao prosa (pesquisa ICLR 2026)
- Max 150 linhas. Front-load critico. Remover secao "Architecture" (token waste)
- AGENTS.md virando padrao universal (OpenAI + Google + Cursor convergindo)
- Codex le AGENTS.md nativamente. Gemini CLI TAMBEM le AGENTS.md
- Pode add `project_doc_fallback_filenames = ["CLAUDE.md"]` em `~/.codex/config.toml`
- Skills system: `.agents/skills/` com SKILL.md (similar ao Claude Code)
- Anti-patterns: prosa vaga, >150 linhas, mixing concerns, acumular regras sem podar

**GEMINI.md:**
- Suporta `@file.md` imports (ate 5 niveis, recursivo, circular-safe)
- 3 tiers concatenam (NAO override): global + projeto + JIT (subdirs)
- `/init` gera GEMINI.md automaticamente (analisa projeto)
- `/memory add <text>` append ao global GEMINI.md
- `context.fileName` em settings.json pode incluir `["AGENTS.md", "CLAUDE.md", "GEMINI.md"]`
- `.geminiignore` para excluir assets/provas/, assets/sap/
- Exemplo real: Firebase UI usa @imports por package

**Orquestracao multi-CLI:**
- Claude Code como orquestrador chamando `gemini -p` e `codex exec` via Bash
- Task routing: pesquisa→Gemini($0), review→Codex($0), build→Claude($0 Max)
- Deep Research so via API (nao disponivel no CLI -p) — manter MCP OU usar Gemini web
- CLI OAuth: multimodal($0) + agentic search($0) + Deep Think($0). Deep Research Agent formal = API only
- Riscos: context desync, feedback loops, false consensus, MCP bloat

## P1 — AUDIT (herdado S63)

1. Revisar S63 audit report — 8 FIX pendentes (4 alto, 4 medio)
2. Aplicar fixes aprovados
3. Rodar Codex Round 2 — prompts em `.claude/tmp/codex-round2a.md`

## P2 — AULAS (herdado)

4. Metanalise QA — 18 slides, 4 DONE, 14 pendentes. Deadline 2026-04-15 (~11 dias)
5. Construir slide s-pico — evidence HTML pronto
6. Rodar /research em s-aplicacao

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- Audit findings: report first, execute next session.
- QA visual: migrar de Gemini API ($$$) → Gemini CLI OAuth ($0). Opus multimodal como fallback.
- Memory governance: cap 20 files, review a cada 3 sessoes.
- **NOVA**: Gemini CLI (OAuth Ultra) = canal primario de pesquisa. 2,000 req/dia, $0.
- **NOVA**: Multimodal (PNG, video) incluso na quota Ultra. Sem custo extra.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.
- settings.local.json e hooks/ BLOQUEADOS contra Edit/Write (pedir autorizacao).
- Gemini CLI (OAuth): multimodal + agentic research + Deep Think = $0. Deep Research Agent formal = API only ($$$).

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] ARCHITECTURE.md sync

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-04
