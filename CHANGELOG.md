# CHANGELOG

## Sessao 32 — 2026-03-31 (skill-debugging)

### Skills
- `systematic-debugging`: nova skill, 4 fases (root cause → padroes → hipotese → fix), adaptada de obra/superpowers (128K stars)
- Skills: 14 → 15

### Rules
- `anti-drift.md`: verification gate 5-step (cherry-pick superpowers verification-before-completion)

### Tooling
- `dream-skill` instalada (~/.claude/skills/dream/) — memory consolidation 4 fases, Stop hook global, auto-trigger 24h
- `@openai/codex` CLI v0.118.0 instalado globalmente (npm -g)
- `codex-plugin-cc`: pendente auth (`codex login`) + plugin install

### Research
- Superpowers (128K stars): avaliado, cherry-picked debugging + verification
- GSD (32K stars): avaliado, descartado (dev workflow, nao organizacao)
- Notion Calendario + Tasks DB: mapeados (schema, views, data source IDs)
- Auto Dream (oficial Anthropic): rolling out mar/2026, behind feature flag

### Notion
- 3 compromissos criados no Calendario DB para 01/abr (Dr Fernanda ICESP, Psicologo 11h, OLMO skills+metanalise)

### Memory
- 3 novas memorias: notion-databases (reference), tooling-pipeline (project), metanalise-deadline (project)

## Sessao 31 — 2026-03-31

### Skills Audit (18 → 14)
- **3 merges**: ai-learning → continuous-learning, research → mbe-evidence, notion-knowledge-capture → notion-publisher
- **1 prune**: self-evolving removida (PDCA ja coberto por concurso e review)
- **12 migracoes**: instructions.md → SKILL.md (formato oficial Anthropic)
- Todas 14 skills com descriptions "pushy" (anti-undertrigger, trigger phrases PT-BR)
- Descoberta: skills com `instructions.md` nao carregavam no auto-trigger — so `SKILL.md` funciona

### Docs
- `ARCHITECTURE.md`: contagem atualizada (17 → 14 skills)

### Memory
- Atualizada `user_mentorship.md`: Opus mentor full-stack (dev, ML, AI, eng sistemas, gestao, orquestracao)

## Sessao 30 — 2026-03-31

### Skills
- `skill-creator`: substituido por versao oficial Anthropic (18 arquivos, repo anthropics/skills)
- `slide-authoring`: nova skill (65 linhas SKILL.md + references/patterns.md com 5 padroes HTML)
- Avaliadas e descartadas: 7 skills ui-ux-pro-max (irrelevantes para nosso stack deck.js)
- Avaliado claude-mem (44K stars): decisao de instalar em sessao dedicada futura

### Config
- `statusline.sh`: nome da sessao em magenta bold (destaque visual)
- `pyproject.toml`: ruff exclude para `.claude/skills/skill-creator/` (codigo externo)

### Memory
- Criado sistema de memoria persistente (MEMORY.md + 2 memorias: anti-sycophancy, mentorship)

## Sessao 29 — 2026-03-31

### Hooks
- Novo `hooks/stop-notify.sh`: beep 1200Hz + toast "Pronto" no evento Stop
- Todos os 3 hooks corrigidos para paths absolutos (CWD-independent)

### Docs Promovidos
- `decision-protocol.md` e `coautoria.md` promovidos de cirrose → `shared/`
- Cirrose originais viram redirects (tabela de artefatos preservada)

### Lessons Absorbed
- `slide-rules.md`: +E32, +§7 GSAP armadilhas, +§8 scaling arquitetura
- `ERROR-LOG.md` metanalise: 5 licoes herdadas do aulas-magnas

### Infra
- Repo renomeado: `organizacao1` → `LM` → `OLMO` (via `gh repo rename`)

### Cirrose — Feedback pós-aula (2026-03-31)
- Novo `cirrose/NOTES.md`: feedback da aula real
- Erro: indicação de albumina em HDA (albumina é SBP, não HDA)
- Tópico novo: coagulopatia no cirrótico (hemostasia rebalanceada, TEG/ROTEM, PVT)
- Pronúncia cACLD: letra por letra internacionalmente, DHCAc não é usado verbalmente no BR

### Legacy Cleanup
- `aulas-magnas` movido para `legacy/` (fora do repo)
- `wt-metanalise` movido para `legacy/` (worktree pruned)

### PENDENCIAS
- `Osteoporose` atualizado: agora em `legacy/aulas-magnas`

## Sessao 28 — 2026-03-31

### Metanalise Migration
- 18 slides + references + scripts migrados de wt-metanalise para `content/aulas/metanalise/`
- Paths corrigidos: `../../shared/` → `../shared/`
- Docs reescritos (CLAUDE.md, HANDOFF.md, NOTES.md, CHANGELOG.md, ERROR-LOG.md)
- Deleted: WT-OPERATING.md, AUDIT-VISUAL.md, HANDOFF-ARCHIVE.md (absorvidos)
- `package.json`: +`dev:metanalise` (port 4102), +`build:metanalise`

### CSS Architecture
- slide-rules.md: nova secao §1b (tokens + composicao livre, sem archetypes)
- Stack profissional: GSAP 3.14 (ja existia) + Lottie-web 5.13 + D3 7.9
- `base.css`: `@media (prefers-reduced-motion: reduce)` adicionado
- `presenter.js`: criado mas NAO integrado (precisa rewrite — HTML separado, timer fix)

### Doc Restructuring
- ECOSYSTEM.md deletado — conteudo unico absorvido no CLAUDE.md (Objectives + Tool Assignment)
- CHANGELOG.md: 382→50 linhas — sessoes 7b-24 movidas para `docs/CHANGELOG-archive.md`
- PENDENCIAS.md: separado setup/infra de backlog, items completados removidos
- ARCHITECTURE.md: skills list derivavel removida, agent system marcado como scaffold
- HANDOFF.md: items DONE removidos, sessao 28 atualizada
- 4 refs a ECOSYSTEM.md atualizadas (GETTING_STARTED, TREE, OBSIDIAN_CLI_PLAN, CLAUDE.md)

### Memories
- feedback_self_question: reflexao critica antes de implementar
- feedback_no_sycophancy: zero adulacao, analise critica antes de concordar

## Sessao 27 — 2026-03-29

### Tree Cleanup
- Deletada branch stale `refactor/monorepo-professional` (12 commits atras, 0 proprios)
- Removidos 5 stubs orfaos: `content/blog/`, `apps/api/`, `apps/web/`, `aulas/metanalise/`, `aulas/osteoporose/`
- Info migracao preservada em PENDENCIAS.md secao "Aulas Congeladas"

### Path Fix
- `03-Resources/` → `resources/` em 4 arquivos: `atualizar_tema.py`, `workflow_cirrose_ascite.py`, `workflows.yaml`, `workflow-mbe-opus-classificacao.md`
- `knowledge_organizer.py` mantido (PARA convention do Obsidian vault)

### Documentation
- Novo `docs/TREE.md`: mapa completo anotado da arvore do projeto
- `skills/__init__.py`: docstring clarifica `skills/` (runtime) vs `.claude/skills/` (slash commands)
- `CLAUDE.md`: secao Misc com cross-refs para skills/ e TREE.md

## Sessao 26 — 2026-03-29

### Hardening Documental
- Novo `docs/SYNC-NOTION-REPO.md`: protocolo Notion↔Repo (source of truth, collection IDs, workflows)
- `content/aulas/README.md` reescrito: 14 scripts mapeados, status por aula, grafo cross-refs, Notion
- See-also em 7 reference docs (CASE, narrative, evidence-db, must-read, archetypes, decision-protocol, coautoria)
- `CLAUDE.md` + `ECOSYSTEM.md` atualizados com referencia ao SYNC-NOTION-REPO

### Vite Safety
- `vite.config.js`: `strictPort: true`, porta removida (controlada por npm scripts)
- `package.json`: cirrose=4100, grade=4101, strictPort em todos os dev scripts
- Corrige problema de servidores fantasma ao rodar multiplos projetos Vite

## Sessao 25 — 2026-03-29

### Timeline Fix
- Concurso: nov/2026 → dez/2026 (7 ocorrencias: CLAUDE.md, ECOSYSTEM, ecosystem.yaml, ARCHITECTURE, skill concurso)
- Estudo: "foco total abril" → "foco total maio" (HANDOFF, PENDENCIAS)
- PENDENCIAS backlog: "Abr-Nov" → "Mai-Dez"
- Memory: project_concurso_timeline atualizada

### Docs Cleanup
- `docs/WORKFLOW_MBE.md` + `docs/PIPELINE_MBE_NOTION_OBSIDIAN.md`: `03-Resources/` → `resources/` (path stale desde sessao 21)
- Auditoria completa: 9 docs, 8 rules, 17 skills, 4 agents — tudo sincronizado
- Nenhum doc stale ou redundante encontrado

### Housekeeping
- HANDOFF.md: sessao 25 com estado atualizado + novo item (scripts Python path stale)
- Flagged: `atualizar_tema.py`, `knowledge_organizer.py`, `workflows.yaml` ainda referenciam `03-Resources/`

---
Sessoes anteriores (7b–24): `docs/CHANGELOG-archive.md`
