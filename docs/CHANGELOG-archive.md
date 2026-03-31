# CHANGELOG — Arquivo (Sessoes 7b–24)

> Movido do CHANGELOG.md principal em 2026-03-31.
> Sessoes recentes: ver `CHANGELOG.md` (raiz).

## Sessao 24 — 2026-03-29

### Aulas Infra
- `npm install`: 229 packages, 0 vulnerabilidades. Node v20.20.0.
- Vite dev server validado: cirrose + grade HTTP 200 em localhost:3000
- Build: `build:cirrose` (44 slides) + `build:grade` (58 slides) OK
- Lint slides: clean

### Arquitetura Aulas
- `shared/` promovido de `cirrose/shared/` → `content/aulas/shared/` (design system compartilhado)
- Imports atualizados: `./shared/` → `../shared/` em cirrose (template + slide-registry)
- Grade resgatada de `aulas-magnas`: 58 slides, template reescrito Reveal.js → deck.js
- `package.json`: +`dev:grade`, +`build:grade`, +`qa:screenshots:grade`

### Grade QA (legibilidade)
- `grade/scripts/qa-batch-screenshot.mjs`: Playwright screenshots + metricas automatizadas
- Check C8 novo: auditoria font-size minimo 18px (legibilidade a 5m, projecao padrao)
- **Diagnostico**: 9/10 slides falham C8 (fontes 14px), 8/10 overflow, 6/10 >40 palavras
- 2 slides com 404 JS errors (recursos faltando)

### Concurso R3 Clinica Medica
- Anki MCP: v0.15.0 (18 tools), config `--stdio` em servers.json (status: planned)
- Pipeline documentado: provas+SAPs → analise padroes → questoes calibradas → Anki
- `assets/provas/` + `assets/sap/` criados, PDFs gitignored
- Memory: `project_concurso_timeline` (foco total a partir de abril)

### Housekeeping
- PENDENCIAS.md: Haiku 3 stale removido, secao concurso reescrita, ensino atualizado
- CLAUDE.md: Key Files reorganizado por subsistema (Python, Aulas, Concurso, Docs)
- Documentacao final: HANDOFF, CHANGELOG, CLAUDE.md, PENDENCIAS limpos para hidratacao

## Sessao 23 — 2026-03-29

### Aulas Integration
- Cirrose aula (44 slides, deck.js+GSAP, assertion-evidence) incorporada em `content/aulas/cirrose/`
- package.json + vite.config.js adaptados para nova localizacao no monorepo
- 8 scripts de tooling copiados (linters, QA gate, export)
- Scaffolds: grade/, metanalise/, osteoporose/ com READMEs descritivos

### Pesquisa & Estrategia
- `content/aulas/STRATEGY.md`: pesquisa completa de ferramentas profissionais (GSAP, CSS, Lottie, D3)
- Canva MCP capabilities mapeadas (30 tools, limitacoes de speaker notes)
- Decisao documentada: hibrido HTML/PPTX/Canva por contexto
- Roadmap de 9 fases de evolucao tecnica

### Config & Rules
- `.claude/rules/slide-rules.md` com `paths: ["content/aulas/**"]` (so carrega em contexto de aula)
- `pyproject.toml`: `exclude = ["content/"]` protege ruff de JS/HTML
- `.pre-commit-config.yaml`: exclude nos hooks ruff para content/aulas/
- `Makefile`: targets aulas-install, aulas-dev, aulas-build-cirrose
- `CLAUDE.md`: referencia atualizada a content/aulas/

### Memories
- feedback_aulas_improve_not_inherit: melhorar, nao copiar cegamente
- feedback_no_frankenstein: Lucas deve entender e debugar tudo
- feedback_mantra_simplicity: beleza com simplicidade, mentor-aprendiz
- feedback_legacy_vs_professional: separar legacy/professional ao incorporar

## Sessao 22 — 2026-03-29

### Build System (Fase 1)
- `pyproject.toml` overhaul: v0.2.0, optional-dependencies, hatch build, expanded ruff rules
- `Makefile` com targets lint/format/type-check/test/check/run/status/clean
- `.pre-commit-config.yaml`: pre-commit-hooks v5.0.0 + ruff v0.15.6
- `README.md` criado (requisito hatchling)

### Token Diet (Fase 2-3)
- `CLAUDE.md`: 87→57 linhas (-500 tokens/prompt). Removidas secoes auto-discovered
- Rules trimadas: coauthorship (45→27), session-hygiene (57→25), mcp_safety (92→50), notion-cross-validation (79→34)
- Docs extraidos: `docs/coauthorship_reference.md`, `docs/mcp_safety_reference.md`, `templates/chatgpt_audit_prompt.md`
- Skills consolidadas 19→17: medical-research→mbe-evidence, ai-fluency+ai-monitoring→ai-learning
- Heavy skills split: mbe-evidence/REFERENCE.md, exam-generator/REFERENCE.md

### Code Quality (Fase 4)
- `agents/core/exceptions.py`: hierarquia customizada (EcosystemError→AgentError, ConfigError, etc.)
- `agents/core/log.py`: setup_logging() centralizado
- `config/loader.py`: ConfigError wrapping, Path.open(), ternary
- `orchestrator.py`: setup_logging() + AgentError catch

### Testing (Fase 5)
- 47 testes: mcp_safety (25), model_router (13), config/loader (9)
- `tests/conftest.py`: MockAgent + tmp_config_dir fixtures

### CI/CD (Fase 6)
- `.github/workflows/ci.yml`: lint+format+mypy+pytest, Python 3.11/3.12 matrix
- `.github/pull_request_template.md`, `.github/dependabot.yml`
- `agents/py.typed` (PEP 561)

### Anti-Drift (novo)
- `.claude/rules/anti-drift.md`: guardrails research-backed (Trail of Bits, VIBERAIL, Anthropic practices)
- Positive framing, consequence pattern, primacy/recency anchoring
- Memory: feedback sobre aceitacao passiva de Lucas

### Decomposicao (Fase 7)
- `notion_cleaner.py` (1079 linhas) → subpackage `notion/` (5 modulos)
- models, snapshot, analysis, executor, cleaner
- Backward-compat re-export preservado
- 3 RUF012 pre-existentes corrigidos (→ ClassVar)

### Scaffold (Fase 8)
- `apps/api/`, `apps/web/`, `content/aulas/`, `content/blog/` com READMEs

---
Coautoria: Lucas + opus | 2026-03-29

## Sessao 21 — 2026-03-28

### Arvore de Diretorios
- `03-Resources/` → `resources/` (PARA numbering removido)
- `config/keys/keys_setup.md` → `docs/` (doc no lugar certo)
- `workflows/` removido (pacote vazio, workflows vivem em config/workflows.yaml)
- `data/obsidian-vault/` removido (7 dirs vazios sem uso)

### Hooks
- `hooks/notify.sh` — toast notification Windows 11 (evento Notification)
- `hooks/stop-hygiene.sh` — verifica HANDOFF+CHANGELOG + context recovery (evento Stop)
- `settings.local.json` atualizado com bloco hooks + 4 permissoes redundantes removidas

### Rules & Configs
- `mcp_safety.md`: 137→92 linhas (FATOS, FONTES, CROSS-VAL duplicata removidos)
- Path-scoping: `mcp_safety.md` e `notion-cross-validation.md` com `paths:` frontmatter
- `pyproject.toml`: +3 ruff lint rules (UP=pyupgrade, B=bugbear, SIM=simplify)
- `.gitignore`: +hooks/*.log, coverage, .uv/
- `CLAUDE.md`: Key Files e Conventions atualizados (hooks, path-scoping)

---
Coautoria: Lucas + opus | 2026-03-28

## Sessao 20 — 2026-03-28

### Self-Improvement (pesquisa + implementacao)
- Pesquisa com 4 agentes paralelos: agents, skills, memory, project structure
- Memory prune: 3 stale removidas (feedback_modelo_opus, project_skills_update, project_future_obsidian_zotero)
- Custom agents: .claude/agents/ criado com 4 agents (researcher, notion-ops, literature, quality-gate)
- Skills frontmatter: YAML padronizado em todas as 20 skills (name + description)
- Skills consolidation: research absorve scientific, concurso linka exam-generator, automation expandida
- CLAUDE.md: secao Agents adicionada, skills 20→19, scientific removida

---
Coautoria: Lucas + opus | 2026-03-28

## Sessao 18 — 2026-03-27

### Notion Writes (3 verificados)
- TECNOLOGIA & IA → Status: Arquivo (portal fino, AI Hub e a entrada ativa)
- Estatinas (efeito loteria) merged como subsecao V em Lipides e prevencao primaria
- Conceitos Garimpados: MOC adicionado no topo (7 clusters, ~60 conceitos indexados)

### Docs
- HANDOFF.md, CHANGELOG.md: sessao 18 completa

---
Coautoria: Lucas + opus | 2026-03-27

## Sessao 17 — 2026-03-27

### Auditoria Masterpiece — 2o Ciclo (completo)
- Inventario expandido: 70+ paginas + subpaginas, 8 pilares verificados
- Cross-validation ciclo 2 executado (Claude + ChatGPT v2 prompt)
- Comparacao pareceres: 5 convergencias, 1 divergencia (Estatinas), 2 falsos positivos ChatGPT (snapshot stale)

### Notion Writes (8 verificados)
- Terry Underwood: 3 paginas Archived → 1 entry consolidada (Pessoa, EDUCACAO, Broto, 6 insights)
- Conceitos Garimpados → META/SISTEMA, Galeria, Arvore, Ativo (curadoria transitoria)
- Zettelkasten: 2 paginas Archived → 1 entry consolidada (Topico, EDUCACAO, Broto, conteudo merged)
- Organizacao (wrapper vazio) → Archived
- Models (subpage quase vazia) → Archived
- HUB Multidisciplinar → Status: Arquivo
- Antibioticos: verificado, estrutura ja correta (nenhuma acao)

### Verificacao Properties Sessao 16
- AI tools, Comportamento, Decision theory: Broto confirmado (ChatGPT flagou erroneamente)

### Docs
- ARCHITECTURE.md: skills list atualizada (12→20), MCPs atualizados (13 reais)
- ECOSYSTEM.md: data atualizada
- HANDOFF.md, CHANGELOG.md: sessao 17 completa

---
Coautoria: Lucas + opus + gpt54 | 2026-03-27

## Sessao 16 — 2026-03-26

### Cross-Validation Masterpiece (Claude + ChatGPT)
- Inventario read-only completo do Masterpiece DB (40+ paginas)
- Analise independente do ChatGPT via MCP Notion
- Comparacao dos 2 pareceres: convergencias, divergencias, erros factuais do ChatGPT corrigidos

### Notion Writes (7 updates verificados)
- Musicos, Pintores, Pensadores do cuidado → Tipo: Galeria
- AI tools, Comportamento, Decision theory → Maturidade: Broto
- Flammula of uncertainty → Tipo: Mapa

### Triagem Archived
- ~80 paginas auditadas (email digests, eventos passados, governance)
- 3 paginas com valor unico identificadas para recuperacao futura

---
Coautoria: Lucas + opus + gpt54 | 2026-03-26

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
- Prompt padronizado para ChatGPT: auditor independente, naive, sem vies de confirmacao
- Inventario read-only do Masterpiece: ~25 paginas mapeadas, 8 pilares confirmados
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
