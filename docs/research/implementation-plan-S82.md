# Plano de Implementacao — Self-Improvement & Anti-Fragile

> S82-S83 INFRA | Atualizado: 2026-04-06 (S83)
> Fontes: /insights S82 (58 sessoes) + 5 pesquisas (anti-drift, anti-fragile, self-improvement, memory, Claude Code best practices)
> Objetivo: sistema que melhora com cada falha (antifragile), nao apenas sobrevive (resiliente)

---

## Diagnostico (de onde vem o problema)

### Cadeia causal identificada (/insights, 58 sessoes)

```
Context overflow (50% das sessoes)
  → Thread perdida (30%)
  → Agente reinventa em vez de ler scripts (10x)
  → Criterios errados (9x)
  → Retrabalho
  → Mais context
  → Overflow (loop)
```

### Numeros reais

| Problema | Incidencia | Correcoes do Lucas |
|----------|-----------|-------------------|
| Scope creep (agir sem permissao) | 24 eventos | "calma", "pare", "espere" |
| Context overflow → thread perdida | 11 eventos | "organize num md antes de perder" |
| Agent-script redundancia | 10 eventos | "siga os scripts nao invente" |
| Criterios QA inventados | 9 eventos | "com os criterios nao da sua cabeca" |
| Batch QA (multi-slide) | 7 eventos | "um slide por vez" |

### Root causes (pesquisa anti-drift)

1. **Compaction destroi regras** — preserva codigo mas perde convencoes e decisoes
2. **Nenhum mecanismo deterministico** de cross-ref — tudo e advisory (modelo pode ignorar)
3. **Agente otimiza para helpfulness** — "melhorar" codigo vizinho parece util mas e drift

### Analise anti-fragilidade (7 camadas Taleb)

| Camada | Descricao | Nosso estado |
|--------|-----------|-------------|
| L1 Retry + backoff | Retry transiente (429/5xx) | **PARCIAL** — scripts tem retry, sem jitter |
| L2 Model fallback | Primary → secondary → tertiary | **ZERO** — so Opus, sem fallback chain |
| L3 Circuit breaker | Fast-fail quando endpoint morre | **PARCIAL** — maxTurns nos agentes |
| L4 Graceful degradation | Cache/simpler response | **ZERO** |
| L5 Self-healing loop | Validate → classify → recover → learn | **ZERO** — /insights e manual |
| L6 Chaos engineering | Injecao deliberada de falhas | **ZERO** |
| L7 Continuous learning | Falha → dado que melhora futuro | **ZERO** — sem loop persistente |

**Conclusao:** L1-L3 (resiliencia parcial). L5-L7 (anti-fragilidade) zero.

### Gaps criticos

| Gap | Impacto | Solucao proposta | Custo |
|-----|---------|-----------------|-------|
| Zero observability | Nao sabemos tokens/custo/erros por sessao | OTel nativo (3 env vars) | $0 |
| Sem cross-ref deterministico | Edita slide, esquece manifest → QA falha | ifttt-lint + stop hook | $0 |
| Sem self-healing loop | Falha → conserto manual proximo sessao | Validate→classify→recover | $0 |
| Memory sem temporal invalidation | Fact stale vive para sempre | TTL/timestamps em memory | $0 |
| Contract mismatch silencioso | Doc diz X, codigo faz Y | Doc follows code + CI check | $0 |

---

## O que ja fizemos (S82) ✅

### Rules aplicadas (6 propostas /insights)

| Proposta | Alvo | Commit |
|----------|------|--------|
| Criteria-source mandate | qa-pipeline.md | `9f159b3` |
| Momentum brake | anti-drift.md | `9f159b3` |
| Script primacy | anti-drift.md | `9f159b3` |
| Single-slide guard | qa-engineer.md | `9f159b3` |
| Proactive checkpoints | session-hygiene.md | `9f159b3` |
| P0 security gate | session-hygiene.md | `9f159b3` |

### Quick wins implementados (Dia 0-1)

| # | Item | Commit | Impacto |
|---|------|--------|---------|
| 0 | plansDirectory config | config local (nao versionado) | Planos sobrevivem sessoes |
| 1 | Context-Essentials | `484012f` | Regras sobrevivem compaction |
| 2 | Propagation Map no CLAUDE.md | `2dcdae3` | Cross-ref visivel toda sessao |
| 3 | PreCompact checkpoint hook | `13699c7` | Estado salvo antes de compaction |
| 4 | Stop hook cross-ref check | `a4f4603` | Warning deterministico se esquecer propagacao |

## O que fizemos (S83) ✅

### Enforcement + Via Negativa + Self-Healing

| # | Item | Commit | Impacto |
|---|------|--------|---------|
| 5 | Cross-ref pre-commit hook (bash, nao ifttt-lint) | `19ba5fe` | BLOCK commit se cross-ref quebrado |
| 6 | Known-bad-patterns registry (5 KBPs) | `19ba5fe` | Via Negativa: agente sabe o que NAO fazer |
| 7 | Self-healing loop skeleton | `bfe65f2` | stop-detect → pending-fixes → session-start surfacea |

**Decisao #5:** Custom bash hook em vez de ifttt-lint. Pesquisa encontrou ebrevdo/ifttt-lint (npm, 9.3k downloads/mes) e @slnc/ifchange (npm, 3.2k). Ambos exigem anotar 19+ arquivos com directives. O bash hook faz file-level co-modification check com 40 linhas e 0 dependencias. 80% do valor, 10% do custo. Phase B (ifttt-lint directives) fica como upgrade futuro se FP for alto.

### Cleanup + CLAUDE.md

| # | Item | Commit | Impacto |
|---|------|--------|---------|
| 16 | content/aulas/CLAUDE.md compartilhado | `06d243e` | Regras comuns a todas as aulas, carrega automaticamente |
| 17 | Slim CLAUDE.md root (92→85 linhas) | `88f2837` | Propagation map movido para aulas/CLAUDE.md |
| — | Remover qa-video.js deprecated | `d7bb0cc` | Dead code cleanup |
| — | Project values como decision gates | `058a746`+ | Antifragile + Curiosidade em CLAUDE.md, context-essentials, memoria |

### Pesquisas completas (S83)

| Pesquisa | Arquivo | Linhas |
|----------|---------|--------|
| Memory best practices | `docs/research/memory-best-practices-2026.md` | 736 |
| Claude Code best practices | `docs/research/claude-code-best-practices-2026.md` | 1076 |

---

## O que fizemos (S84) ✅

### Tier 0 + Tier 1 — Agent hardening

| # | Item | Commit | Impacto |
|---|------|--------|---------|
| 0 | OTel env vars documentados em .env.example | `8ed6905` | Pronto para ativar quando Langfuse estiver up |
| 1A | Model routing: evidence-researcher→sonnet | `8ed6905` | ~60% economia em sessoes de pesquisa |
| 1A | Model routing: reference-checker→haiku | `8ed6905` | ~85% economia |
| 1A | Model routing: notion-ops→haiku | `8ed6905` | ~60% economia |
| 1B | PreCompact hook migration | `8ed6905` | Timing garantido antes da compaction |
| 1C | memory:project em qa-engineer | `8ed6905` | Antifragile L7 — aprende entre sessoes |
| 1C | memory:project em reference-checker | `8ed6905` | Antifragile L7 — citation patterns |
| 1D | context:fork em skills pesadas | verificado existia | Antifragile L4 ja ativo |

## O que fizemos (S85) ✅

### Tier 2 — Automation & Loops

| # | Item | Commit | Impacto |
|---|------|--------|---------|
| 8partial | lint-on-edit PostToolUse hook | `5e3058a` | L5 self-healing: lint automatico em edicoes de slide |
| 9 | cost-circuit-breaker PostToolUse hook | `5e3058a` | L3 circuit breaker: avisa 100 calls, bloqueia 400 |
| 11 | quality-gate JS/CSS lint scripts | `5e3058a` | Agente descongelado, cobre todos os lints da aula |
| 12 | /insights output JSON estruturado | `5e3058a` | L7: proposals/kbps/pending-fixes gerados automaticamente |

## O que fizemos (S86) ✅

### L7 + L2 — Memory TTL, Failure Registry, Fallback Advisory

| # | Item | Commit | Impacto |
|---|------|--------|---------|
| 16 | Memory TTL backfill (17 files) | S86 | L7: memorias com review_by, last_challenged, confidence |
| 16b | /dream Phase 4 TTL check | S86 | L7: /dream flaggeia memorias expiradas |
| 10 | NeoSigma failure registry JSON | S86 | L7: constrained optimization sobre dados de falha |
| 10b | /insights Phase 5 (registry append) | S86 | L7: /insights auto-atualiza registry + trend check |
| 2C | Model fallback advisory hook | S86 | L2: detecta overloaded/429/unavailable, sugere downgrade |

## O que falta implementar (ordenado por valor antifragile)

### Tier 0 — Observability (OTel + Langfuse backend)

**Docker Desktop instalado (S85).** Proximo: subir Langfuse via Docker Compose.

Env vars ja documentadas em `.env.example`:
```bash
CLAUDE_CODE_ENABLE_TELEMETRY=1
OTEL_METRICS_EXPORTER=otlp
OTEL_EXPORTER_OTLP_PROTOCOL=grpc
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
OTEL_METRIC_EXPORT_INTERVAL=10000
```

Backend: **Langfuse** (19k+ stars, MIT, $0 self-host).
Comando para subir (apos instalar Docker):
```bash
git clone https://github.com/langfuse/langfuse && cd langfuse && docker compose up -d
```

### Tier 2 restante

Fonte: `docs/research/claude-code-best-practices-2026.md` §9.3

#### A. Agent model routing (15 min) — ECONOMIA REAL
5/8 agentes provavelmente herdam Opus. Desperdicio direto.

| Agente | Atual | Recomendado | Economia |
|--------|-------|-------------|----------|
| evidence-researcher | herda Opus | sonnet | ~60% |
| reference-checker | herda Opus | haiku | ~85% |
| mbe-evaluator | sonnet ✓ | sonnet ✓ | — |
| qa-engineer | sonnet ✓ | sonnet ✓ | — |
| researcher | haiku ✓ | haiku ✓ | — |
| repo-janitor | haiku ✓ | haiku ✓ | — |
| quality-gate | haiku ✓ | haiku ✓ | — |
| notion-ops | sonnet | haiku | ~60% |

3 agentes ja tem model correto. 3 precisam adicionar. Economia: significativa em sessoes com pesquisa.

#### B. PreCompact hook migration (5 min) — CORRECAO
`pre-compact-checkpoint.sh` esta no evento Stop, nao PreCompact. Timing nao garantido — compaction pode ocorrer antes do Stop hook rodar. Mover para evento PreCompact (existe desde 2026).

#### C. Agent memory: project (10 min) — ANTIFRAGILE L7
Agentes com `memory: project` acumulam conhecimento entre sessoes em `.claude/agent-memory/<name>/`.
Candidatos: qa-engineer (aprende issues recorrentes), reference-checker (lembra citation patterns).
Antifragile: agente que aprende = L7 continuous learning.

#### D. context: fork em skills pesadas (10 min) — CONTEXT PROTECTION
Skills como /research, /medical-researcher, /deep-search inundam o contexto principal.
`context: fork` no frontmatter roda em subagent isolado — resultado volta como resumo.
Antifragile: protege o contexto = L4 graceful degradation.

### Tier 2 restante

#### 8. Local OTel collector + Langfuse ✅ PARCIAL (S84-S85)
- Env vars documentadas. Docker instalado (S85). Falta: `docker compose up` Langfuse.
- Referencia: `claude-code-otel` (MIT, Docker Compose).

#### 9. Circuit breaker de custo ✅ IMPLEMENTADO (S85)
- `.claude/hooks/cost-circuit-breaker.sh` — proxy via call count (haiku: ~100 calls/sessao ok).
- TODO: upgrade para custo USD real via OTel quando Langfuse estiver ativo.

#### 10. NeoSigma-style failure registry estruturado
JSON tracking com constrained optimization: so aceitar mudancas que nao regridem.
Dependencia: `/insights` JSON output (feito em S85). Proximo passo natural.

#### 11. PostToolUse lint-on-edit ✅ IMPLEMENTADO (S85)
- `.claude/hooks/lint-on-edit.sh` — detecta slides/*.html, roda lint-slides.js, injeta erros.

#### 12. /insights output estruturado ✅ IMPLEMENTADO (S85)
- Template JSON em SKILL.md: proposals[], kbps_to_add[], pending_fixes_to_add[], metrics{}.

#### 2C. Model fallback chain (Opus → Sonnet → Haiku)
Antifragile L2. Agentes tem model routing mas sem fallback automatico se modelo falha.
Config + PostToolUse hook para detectar erros de modelo e fazer downgrade.

### Tier 3 — Strategic (avaliar quando Tier 1-2 estabilizar)

#### 13. Graphiti temporal knowledge graph
Substituir MEMORY.md flat por facts temporais com Neo4j. Bi-temporal model.

#### 14. ifttt-lint directives (Phase B do #5)
Se o bash hook tiver muitos falsos positivos, instalar ebrevdo/ifttt-lint (npm) e anotar arquivos com LINT.IfChange/ThenChange para enforcement region-level.

#### 15. Agent Teams para workflow paralelo
Slide authoring + QA + evidence research em paralelo. Feature experimental.

#### 16. Memory temporal invalidation
review_by, confidence, last_challenged em frontmatter de memory files.
Fonte: `docs/research/memory-best-practices-2026.md` §4.

### Nao recomendado agora

| Tool | Razao |
|------|-------|
| Mem0 | /dream ja consolida; sem modelo temporal |
| xMemory, ChaosEater | Research-only ou overkill para escala atual |
| Letta/MemGPT | Plataforma completa; OLMO se beneficia de tools pontuais |
| NeMo Guardrails, Guardrails AI | Hooks nativos bastam |
| Schemathesis/Dredd/PactFlow | Agentes nao se comunicam via HTTP APIs |

---

## Metricas de Sucesso

Medir nas proximas 5 sessoes (S85-S90):

| KPI | Baseline (S75-S81) | S83 estado | S85 estado | Meta S90 |
|-----|-------------------|-----------|------------|----------|
| Cross-ref failures por sessao | ~1.5 | 0 (pre-commit bloqueia) | 0 | 0 |
| Correcoes de scope creep por sessao | 3.0 | TBD | TBD | < 1.0 |
| Criterios QA inventados | 0.45/sessao | 0 (criteria-source rule) | 0 | 0 |
| Context overflow com thread perdida | 55% sessoes | TBD | TBD | < 20% |
| Issues carregados entre sessoes | 0% | 100% (pending-fixes) | 100% | 100% |
| Custo por sessao (USD) | desconhecido | desconhecido | desconhecido | baseline com OTel |
| Lint errors detectados automaticamente | 0% | 0% | 100% (lint-on-edit) | 100% |

## Camadas Antifragile (Taleb) — Estado Atual (S86)

| Camada | Descricao | S82 | S83 | S84 | S85 | S86 |
|--------|-----------|-----|-----|-----|-----|-----|
| L1 Retry + backoff | Retry transiente | PARCIAL | PARCIAL | PARCIAL | PARCIAL | PARCIAL |
| L2 Model fallback | Primary → secondary | ZERO | ZERO | ZERO | ZERO | **PARCIAL** (advisory hook) |
| L3 Circuit breaker | Fast-fail | PARCIAL | PARCIAL | PARCIAL | **MELHORADO** | MELHORADO |
| L4 Graceful degradation | context:fork | ZERO | PARCIAL | **IMPLEMENTADO** | IMPLEMENTADO | IMPLEMENTADO |
| L5 Self-healing | Detect → recover | ZERO | IMPLEMENTADO | IMPLEMENTADO | **MELHORADO** | MELHORADO |
| L6 Chaos engineering | Falhas deliberadas | ZERO | ZERO | ZERO | ZERO | ZERO |
| L7 Continuous learning | Falha → melhoria | ZERO | PARCIAL | **MELHORADO** | MELHORADO | **SIGNIFICATIVO** (TTL + registry) |

## Architecture Vision

```
S82 (baseline):
  Claude Code → flat CLAUDE.md + MEMORY.md → manual /insights
  13 hooks (guards, hygiene, crossref, checkpoint)

S83 (agora):
  Claude Code → CLAUDE.md cascata (root → aulas → metanalise)
  15 hooks (+crossref pre-commit BLOCKING, +stop-detect-issues)
  10 rules (+known-bad-patterns Via Negativa)
  Self-healing loop: detect → persist → surface → fix
  Values como decision gates (antifragile, curiosidade)
  2 pre-commit hooks (secrets + crossref) = dual gate

Curto prazo (S85-S90):
  Agent model routing (Opus → Sonnet/Haiku por agente)
  PreCompact hook migration (timing correto)
  Agent memory: project (qa-engineer, reference-checker aprendem)
  context: fork em skills pesadas (protecao de contexto)
  OTel → Langfuse → metricas reais de custo/tokens/erros

Medio prazo (S90-S100):
  PostToolUse lint-on-edit feedback loop
  NeoSigma failure registry + constrained optimization
  Cost circuit breaker
  /insights output JSON → alimenta failure registry automaticamente

Longo prazo (S120+):
  Graphiti temporal knowledge graph
  Full autonomous improvement loop (detect → classify → fix → verify → learn)
  Agent Teams para workflow paralelo
```

---

## Ferramentas — Tabela Completa

| Ferramenta | Stars | Licenca | Custo | Categoria | Decisao |
|------------|-------|---------|-------|-----------|---------|
| OTel nativo | N/A | N/A | $0 | Observability | IMPLEMENTAR |
| Langfuse | 19k+ | MIT | $0 self-host | Observability | IMPLEMENTAR |
| Arize Phoenix | 8.6k | ELv2 | $0 self-host | Observability | ALTERNATIVA |
| claude-code-otel | ~200 | MIT | $0 | Observability | REFERENCIA |
| ifttt-lint | ~100 | MIT | $0 | Cross-ref | IMPLEMENTAR |
| sec-context | 475 | CC-BY-4.0 | $0 | Anti-patterns | INSPIRACAO |
| Graphiti/Zep | 24.4k | Apache 2.0 | $0 | Memory | AVALIAR (Tier 3) |
| Claude-Mem | 4.1k | AGPL-3.0 | $0 | Memory | AVALIAR (Tier 3) |
| Mem0 | 48k | Apache 2.0 | $0-$249/m | Memory | NAO AGORA |
| Letta/MemGPT | 21.6k | MIT | $0 | Memory | NAO AGORA |
| xMemory | Research | Research | N/A | Memory | INSPIRACAO |
| NeoSigma | N/A | Proprietary | TBD | Self-healing | INSPIRACAO |
| ChaosEater | Research | Research | $0.20-0.80 | Self-healing | BACKLOG |
| Superpowers | 107k | TBD | $0 | Claude Code | ESTUDAR |
| anthropics/skills | Official | Apache 2.0 | $0 | Claude Code | REFERENCIA |
| OpenHands | 65-70k | MIT | $0 | Agent framework | REFERENCIA |
| Aider | 39k | Apache 2.0 | $0 | Agent framework | REFERENCIA |
| SWE-agent | 19k | MIT | $0 | Agent framework | REFERENCIA |
| LangGraph | 28k | MIT | $0 | Agent framework | REFERENCIA |
| Schemathesis | 2.5k | MIT | $0 | Contract testing | BACKLOG |
| Dredd | 4.2k | MIT | $0 | Contract testing | BACKLOG |
| oasdiff | 1.5k | Apache 2.0 | $0 | Contract testing | BACKLOG |
| PactFlow Drift | 12k | MIT/commercial | $0-paid | Contract testing | BACKLOG |

---

## Fontes

- `/insights` report: `.claude/skills/insights/references/latest-report.md`
- Pesquisa anti-drift: `docs/research/anti-drift-tools-2026.md` (449 linhas, 30+ fontes)
- Pesquisa anti-fragile: input direto do Lucas (7 camadas Taleb, observability, memory, contracts)
- Pesquisa self-improvement: `docs/research/agent-self-improvement-2026.md` (811 linhas, 60+ fontes)
- Pesquisa CLAUDE.md best practices: `docs/research/claude-md-best-practices-2026.md` (414 linhas)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-06
