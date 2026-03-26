# CHANGELOG

## Sessao 15 — 2026-03-26

### Skills (split)
- `teaching-improvement` (391 linhas) → 3 skills: `teaching`, `concurso`, `ai-fluency`
- Removido diretorio `.claude/skills/teaching-improvement/`

### Config
- `ecosystem.yaml`: 17 → 20 skills, contagem corrigida
- `servers.json`: adicionado Google Drive MCP (`@piotr-agier/google-drive-mcp`, planned)
- `CLAUDE.md`: skills list atualizada, MCP count corrigido

### MCPs (3 autenticados)
- Gmail, Google Calendar, Canva — connected (13/16 MCPs ativos)
- Google Drive MCP identificado: `@piotr-agier/google-drive-mcp` v1.7.6 (planned)

### Docs
- CLAUDE.md, PENDENCIAS.md, HANDOFF.md, GETTING_STARTED.md, ARCHITECTURE.md — sync com estado real

---
Coautoria: Lucas + opus | 2026-03-26

## Sessao 14 — 2026-03-26

### MCPs (3 instalados)
- Perplexity MCP — `@perplexity-ai/mcp-server` (API key da env)
- NotebookLM MCP — `notebooklm-mcp@latest` (PleasePrompto, auth Chrome)
- Zotero MCP — `zotero-mcp` (modo local, Zotero app aberto)

### Config
- `servers.json` reescrito: 14 MCPs com campo `status` (connected/needs_auth/planned), removidos MCPs fantasma
- `settings.local.json`: permissions para SCite, Perplexity, Gemini, NotebookLM, Zotero
- HANDOFF.md + PENDENCIAS.md atualizados para estado real

### Workflow
- Definido pipeline de pesquisa context-efficient: MCPs como memoria externa, nunca full-text no contexto

---
Coautoria: Lucas + opus | 2026-03-26

## Sessao 12 — 2026-03-14

### Janitor
- Deletar AGENTS.md, tools_ecosystem.yaml, workflows/efficient_workflows.yaml, workflows/medical_workflow.yaml (-940 linhas)
- Limpar referencias em GETTING_STARTED.md, yaml-config.mdc
- Atualizar PENDENCIAS.md (notion-move-pages disponivel)

### Self-Evolving
- ecosystem.yaml: skills sync (6 genericas → 18 reais com paths e descricoes)

### Skill Creator
- Nova skill `daily-briefing` (Gmail→classificar→Notion Emails Digest DB)
- Formato: properties completas + corpo com Resumo + Conceitos-Chave Expandidos

### Notion
- Arquivar 100 paginas do Emails Digest DB (movidas para Archived — Auditoria)
- DB limpo para comecar fresh amanha

### Memory
- Salvar plano futuro Obsidian + Zotero
- Adicionar referencia GTD repos (claude-task-master 25k stars)
- Atualizar user_profile com Zotero e Obsidian

---
Coautoria: Lucas + opus | 2026-03-14

## Sessao 11 — 2026-03-14

### Skills (4 novas)
- Criada `skill-creator` — meta-skill para criar/refinar skills interativamente
- Criada `janitor` — limpeza e manutencao do repositorio (6 operacoes)
- Criada `self-evolving` — auto-evolucao PDCA do ecossistema
- Criada `continuous-learning` — aprendizado progressivo dev/ML/AI ops (etimologia, filosofia)

### Skills (1 upgrade)
- `review` — severity levels P0-P3, OWASP LLM Top 10 2025, conformidade ecossistema

### Evolve (diagnostico)
- Score geral: 7.5/10
- Gap critico: ecosystem.yaml lista 8 skills deletadas
- teaching-improvement candidato a split (392 linhas)
- BudgetTracker configurado mas inativo

### Memory (sistema inicializado)
- user_profile — perfil completo + ecossistema de ferramentas + emails
- feedback_no_infantilizar — sem analogias medicas, usar etimologia/filosofia
- project_recurring_evolve — task recorrente /evolve semanal
- project_skills_update — registro das 4 novas skills
- reference_skill_repos — 15+ repos GitHub com skills

### Config
- CLAUDE.md atualizado com 17 skills

---
Coautoria: Lucas + opus | 2026-03-14

## Sessao 7d — 2026-03-08

### Cross-Validation Workflow
- Criada regra `notion-cross-validation.md` — workflow Claude→ChatGPT→User→Execute
- Prompt padronizado para ChatGPT: auditor independente, naive, sem viés de confirmação
- Inventário read-only do Masterpiece: ~25 páginas mapeadas, 8 pilares confirmados
- Ruff instalado (`pip install ruff`, v0.15.5)

---
Coautoria: Lucas + opus | 2026-03-08

## Sessao 7c — 2026-03-08

### Diagnostico & Limpeza
- Deletados 10 modulos Python redundantes (MCP/Claude nativo substitui): web_search, arxiv_search, summarizer, content_writer, code_analyzer, code_generator, git_manager, response_cache, batch_processor, budget_tracker
- Python: 48 → 38 arquivos (23 skills/agents + 15 __init__/config)

### Conflitos Resolvidos (3/3)
- scientific_agent.py: areas AI/ML → especialidades medicas (reumato, cardio, infecto, epidemio)
- Criado model_router.py: enforce routing trivial→Ollama, simple→Haiku, medium→Sonnet, complex→Opus
- Adicionado Anki MCP em servers.json

---
Coautoria: Lucas + opus | 2026-03-08

## Sessao 7b — 2026-03-08

### Skills
- Criada `notion-knowledge-capture` — conversa/pesquisa → Masterpiece DB
- Criada `notion-spec-to-impl` — specs → tasks no Notion Tasks DB
- Enriquecida `organization` — memory management (2 tiers) + task management + weekly review

### Rules
- Criada `session-hygiene.md` — CHANGELOG + HANDOFF obrigatorios, sempre enxutos
- Atualizada `mcp_safety.md` — notion-move-pages (#64 resolvida), token unico

### Config
- Atualizado CLAUDE.md — novas skills + regra session-hygiene
