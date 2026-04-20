# HANDOFF - Proxima Sessao

> ✅ **S232 COMPLETE** (generic-snuggling-cloud — v6 adversarial consolidation) 2026-04-19 — audit-first cleanup; research skill unblocked; naming conflations fixed; 37/37 tests pass. 8 commits, net ~570 li removed.

**S234 HYDRATION (ordem obrigatória):**
1. Read este HANDOFF completo
2. Check `.claude/plans/README.md` (plans index + naming convention)
3. Se dúvida sobre S232 execution: `.claude/plans/archive/S232-v6-adversarial-consolidation.md`
4. Se dúvida sobre decisões históricas: `CHANGELOG.md §Sessao 232`

---

## S234 PRIORITIES — ordem definida

### P0 — Produção slides (IMMEDIATE, este é o foco da sessão)

**Por quê P0:** 2 dias de housekeeping S232-S233 foram preparação; S234 é entrega. APL já aponta próximo slide (`s-absoluto`). Retomar velocity de produção médica.

**Execução ordenada:**

1. **Environment check (~5min)**
   - `cd content/aulas && npm install` (se necessário)
   - Confirmar aula alvo (cirrose / grade / metanalise) via Lucas
   - Dev server: cirrose:4100 | grade:4101 | metanalise:4102

2. **Pick slide (Lucas decide, APL suggests s-absoluto)**
   - QA status atual: 3/19 editorial (per APL hooks)

3. **Pipeline per `content/aulas/CLAUDE.md`** (ordem rígida):
   - `npm run build:{aula}` (hook lint-before-build garante lint)
   - `qa-engineer --slide s-{id}` Preflight (único slide, único gate — KBP-05)
   - **Lucas OK** entre gates
   - `gemini-qa3.mjs --inspect` (se pedido)
   - **Lucas OK**
   - `gemini-qa3.mjs --editorial` (se pedido)

### P1 — Pre-slides verification (5min se qualquer concern)

**Por quê P1:** S232 fez upgrades (scripts/, workflows.yaml delete, naming fixes). Se primeiro slide falhar, P1 investiga infra antes de feature.

- `/research s-absoluto` smoke (Pernas 1+5 agora funcionais via `.claude/scripts/`)
- `python -m orchestrator status` (deve mostrar automacao + data_pipeline)
- `pytest tests/` (37/37 pass expected)

### P2 — BACKLOG residuals post-slides (S235+)

**Por quê P2:** nada aqui bloqueia slides. Ordem por P0/P1/P2 tiers em `.claude/BACKLOG.md`. Destaques:

| # | Item | Rationale |
|---|------|-----------|
| #46 | Knowledge integration ADR (OLMO ↔ COWORK) | Debt desde S229; ADR pending |
| #36 | Living-HTML migration | DEFERRED explicit S234+; S227 plan archived mas intent vivo |
| #37 | apl-cache-refresh wrong BACKLOG path | Small fix, L23 in hook |
| #34 | CC permissions.ask follow-up | Manual test needed |
| #29 | Agent optimization Phases 3-6 | Phases 1-2 done; 3 (maxTurns), 4 (HyperAgents), 5 (parallelism), 6 (agent-as-skill) pending |

### P3 — Roadmap S235+ (conceptual, não urgente)

- Claude Managed Agents evaluation (April 8 launch hosted alternative)
- Native Structured Outputs agent-level (Gemini v3 rec)
- MCP server Gemini/Perplexity (replace script file if research scales)
- HyperAgents / Voyager / DGM — architectural revolution post-slides

---

## ESTADO POS-S232 (snapshot)

- **Infra limpa pré-slides:** workflows.yaml deleted, chatgpt-5.4 → gpt-4.1-mini, mbe-evidence phantoms eliminated, shared_memory dead field deleted, producer scripts purged (ADR-0002).
- **Research skill desbloqueada:** `.claude/scripts/{gemini,perplexity}-research.mjs` substitui node -e inline bloqueado desde S227 KBP-26.
- **Control plane canonical:** settings.json = hooks + permissions; settings.local.json = user overrides ONLY.
- **Memory governance:** per-agent only (`.claude/agent-memory/evidence-researcher/` = 6 topics + MEMORY.md); §Memory em ARCHITECTURE.md.
- **Multimodel ADR-0003:** ChatGPT ≠ Codex ≠ OpenAI API ≠ GPT-N.M distinction; Antigravity historical/deferred.
- **Plans:** 0 active (ACTIVE-S227 + S232-readiness + S232-v6 todos archived). Convention: ver `.claude/plans/README.md`.
- **BACKLOG:** 46 items (P0=0/P1=12/P2=22/Resolved=9/Frozen=3).
- **Hooks:** 30/30 valid. Tests: 37/37 pass.
- **External reviewers triangulation** (pattern reusable): Codex GPT-5.4 + Gemini 3.1 Pro + research agent + 3 Explore agents.

## Naming convention (by-the-way)

**Arquivos-chave e porquê:**

- `HANDOFF.md` (root): pendências para próxima sessão, future-only, max 80 li. Sobrescrito each session.
- `CHANGELOG.md` (root): append-only history por sessão. Nunca reescreve.
- `.claude/BACKLOG.md`: backlog tiered P0/P1/P2/Frozen/Resolved. Cross-sessão persistent.
- `.claude/plans/README.md`: índice + naming convention para plans (deste commit).
- `.claude/plans/{current}.md`: plan active (auto-generated name em plan mode OK; rename at archival).
- `.claude/plans/archive/S{N}-{slug}.md`: plans históricos (patter: session number + descriptive slug).
- `docs/ARCHITECTURE.md`: arquitetura canonical (SSoT).
- `docs/adr/{N}-{name}.md`: architectural decisions numbered.

---
Coautoria: Lucas + Opus 4.7 + Codex + Gemini + research agent + 3 Explore agents | S232 generic-snuggling-cloud v6 adversarial consolidation | 2026-04-19

(R3 Clínica Médica: 225 dias — study cadence continues em paralelo)
