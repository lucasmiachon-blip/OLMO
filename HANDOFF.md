# HANDOFF - Proxima Sessao

> ✅ **S232 COMPLETE** (generic-snuggling-cloud — v6 adversarial consolidation) 2026-04-19 — audit-first cleanup; 9 commits; net ~570 li removed. Infra limpa, capability inalterada (honestidade brutal: evolução = 0).
>
> **S233 SKIPPED** — verification done inline durante S232 close.

**S234 HYDRATION (ordem obrigatória):**
1. Read este HANDOFF completo
2. Check `.claude/plans/README.md` (convenção + taxonomia)
3. Se dúvida S232 execution: `.claude/plans/archive/S232-v6-adversarial-consolidation.md`
4. CHANGELOG §Sessao 232 para decisões históricas

---

## PRIORIDADES S234-S239 — ordem definida + racional

**Tese:** S232 foi débito pago. S234-S238 é **evolução real com consumer + benefit + anti-YAGNI**. Lucas S232 close: "produção é o menor problema, honestidade brutal sempre e plano de evolução".

### P0 — S234: **Research skill E2E verification + fix (B)**

**Consumer:** toda research session (Perna 1 Gemini + Perna 5 Perplexity).

**Pain concreto:** S232 criou `.claude/scripts/{gemini,perplexity}-research.mjs` unblock de `node -e` deny (KBP-26). Scripts rodam syntax-wise mas **nunca foram invocados contra API real**. HANDOFF S232 claim "unblocked" é teórico.

**Por quê P0:** baseline honesto antes de qualquer evolução; verifica claim S232; sem isso, A/C/D ficam construindo sobre base não validada.

**Execução:**
1. Escolher 1 topic real (ex: "MELD-Na 2024-2026 updates" ou similar)
2. Invocar `node .claude/scripts/gemini-research.mjs "<prompt>"` — verificar: (a) script path loads; (b) API call returns; (c) output format respeitado
3. Mesmo para Perplexity
4. Se break: diagnose + fix
5. Document: tempo/custo/qualidade por perna em `.claude/scripts/README.md` (novo doc de baseline)

**Deliverable:** evidência empírica. ~1-2h. Close S234.

**Rejeito explícito:** rodar `/research` 6-perna completa ainda não — apenas as 2 repaired. Evita scope creep.

---

### P1 — S235: **PMID batch verification automation (A)**

**Consumer:** todo slide com evidência (cirrose + metanalise + grade ≈ 100 slides/ano).

**Pain concreto:** research skill marca PMIDs como CANDIDATE; verificação manual ad-hoc via PubMed MCP individual. 5-10min/slide.

**Solução:** script `.claude/scripts/pmid-batch-verify.mjs` — input: lista CANDIDATE PMIDs; output: VERIFIED/INVALID inline. Uses PubMed MCP esummary batch.

**Deliverable:** 1 script + evidence-researcher SKILL.md update ("após output, rodar pmid-batch-verify").

**Ganho mensurável:** 8-16h/ano salvos + zero PMID errado publicado.

**Não-YAGNI:** você faz isso manualmente toda sessão. Ver `.claude/skills/research/SKILL.md` P005 + qa-engineer.md criteria PMID VERIFIED.

---

### P1 — S236: **Living-HTML migration partial (BACKLOG #36)**

**Status update (S232 close):** BACKLOG #36 **continua ativo per Lucas decision**. Dormant 6 sessões (S227-S232) NÃO significa archive; intent preservado. Scheduled for S236 execution.

**Consumer:** evidence-researcher agent + aulas (cirrose + metanalise).

**Pain concreto:** medical evidence em `.claude/agent-memory/evidence-researcher/*.md` (6 files). Per S227 plan + Codex S232 finding: agent-memory = anti-pattern; evidence belongs as Living-HTML em `content/aulas/cirrose/evidence/`.

**Por quê S236 (não S234 ou antes):** depende de A (PMID batch verify) para qualidade da migração — sem isso, migration copia PMIDs CANDIDATE não-verificados.

**Execução (partial, não full):**
1. Read `.claude/plans/archive/S227-memory-to-living-html.md` (plan canonical preservado)
2. Template: `content/aulas/cirrose/evidence/_template.html` (derivado de metanalise/evidence S148 benchmark)
3. Convert 2-3 files (Lucas pick high-value: csph-nsbb, meld-na, te-accuracy)
4. Use A (pmid-batch-verify) para VERIFIED PMIDs inline
5. Update MEMORY.md redirect para HTML paths
6. `git rm` converted .md files

**Deliverable:** 2-3 HTML files + ARCHITECTURE.md §Memory update. ~3h.

**Full migration (remaining 4 files):** S239+.

---

### P2 — S237: **Claude Managed Agents evaluation (C)** — spec-only audit

**Consumer (potencial):** OLMO `orchestrator.py` + permissions system + tracing infra.

**Pain concreto:** (1) KBP-26 deny list bloqueia canonical tools (`node -e`, `cp`, `rmdir`, etc.); S232 gastou tempo contornando. (2) Custom tracing via 30 hooks ~500 li — Anthropic agora hospeda alternative.

**Por quê S237 (pós-wins concretos):** informed decision depende de ver B/A/Living-HTML funcionando primeiro — entende onde pain está antes de decidir migrate.

**Deliverable:** `docs/adr/0004-claude-managed-agents-evaluation.md` — spec dos pains resolvidos + custos migração + veredicto (migrate S239+, NOT migrate, ou partial adopt).

**Escopo:** 2-3h audit. Read Anthropic docs + map to OLMO pain points. NÃO migrate ainda.

**Rejeito explícito:** adotar sem avaliação — mudança arquitetural grande merece ADR.

---

### P2 — S238: **QA gate parallelism (D)** — ADR + pilot

**Consumer:** toda QA session (3/19 editorial atual; 10+ aulas enfileiradas).

**Pain concreto:** 30-40min/slide sequential (Preflight → Lucas OK → Inspect → Lucas OK → Editorial). × 19 slides/aula × 10 aulas = ~95h QA/ano.

**Solução proposta:** 3 gates PARALELO para MESMO slide (KBP-05 "1 slide" preserved). Lucas vê 3 resultados juntos, decide 1× em vez de 3×. ~50% time cut.

**Por quê S238 (último):** requer ADR-0005 primeiro (KBP-05 semantics); breaking change pipeline; piloto reversível antes de default.

**Deliverable:** ADR-0005 + opt-in flag `--parallel` em qa-engineer + pilot em 1 slide.

**Ganho:** ~47h/ano salvos.

**Rejeito:** rodar parallel sem ADR (v5 harness pilot foi esse anti-padrão).

---

### P3 — S239+: **Slides production em escala**

Com wins acumulados (research verified + PMID auto + Living-HTML partial + possivelmente QA parallel + possibly Managed Agents direction):
- Slides production retoma com helpers melhores que pré-S232
- Velocity real, não apenas "cleanup feel-good"
- Concurso R3 225 days pressure continues

---

## BACKLOG triage (mudanças S232 close)

| # | Change | Razão |
|---|--------|-------|
| #36 Living-HTML | ACTIVE continues (was archived as DEFERRED) | Lucas explicit S232 close: "vai continuar" |
| NEW A | PMID batch verify | S235 scheduled |
| NEW B | Research skill E2E verify | S234 scheduled |
| NEW C | Managed Agents eval | S237 scheduled |
| NEW D | QA parallelism ADR | S238 scheduled |

---

## ESTADO POS-S232 (snapshot factual)

- **Infra limpa pré-evolução:** workflows.yaml deleted, chatgpt-5.4 → gpt-4.1-mini, mbe-evidence phantoms eliminated, shared_memory dead field, producer scripts purged.
- **Research skill:** scripts criados em `.claude/scripts/`, NÃO testados empiricamente (S234 P0 resolve).
- **Control plane:** settings.json canonical; .local.json user overrides ONLY.
- **Memory governance:** per-agent only; §Memory em ARCHITECTURE.md.
- **Plans:** 0 active. Historical archive intact.
- **BACKLOG:** 46+4 items post-S232 (new entries A/B/C/D).
- **Hooks:** 30/30 valid. Tests: 37/37 pass.
- **Triangulation pattern confirmado:** Codex + Gemini + research agent + Explore agents = reusable audit layer (Gemini fabrica citations, fact-check required).

## Deferreds S240+ (explicit non-action)

- MemSearch / ByteRover semantic retrieval — YAGNI para 6 files; revisit em 30+
- Reflexion retry-with-reward — requer test infra; defer
- HyperAgents hierarchical / Voyager skill extraction / DGM — architectural revolution; roadmap longe
- Native Structured Outputs agent-level — Gemini v3 rec; defer até C (Managed Agents) decide

## Naming convention

- `HANDOFF.md` (root): future-only, priority-ordered, max 100 li
- `CHANGELOG.md` (root): append-only history por sessão
- `.claude/BACKLOG.md`: tiered P0/P1/P2 persistent backlog
- `.claude/plans/README.md`: índex + taxonomia
- `.claude/plans/S{N}-{slug}.md`: active plans (auto-generated OK em plan mode; rename at archival)
- `.claude/plans/archive/S{N}-{slug}.md`: historical
- `docs/adr/{N}-{name}.md`: architectural decisions numbered

---
Coautoria: Lucas + Opus 4.7 + Codex + Gemini + research agent + 3 Explore agents | S232 generic-snuggling-cloud v6 + post-close evolution plan | 2026-04-19

(R3 Clínica Médica: 225 dias)
