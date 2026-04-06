# Plano de Implementacao — Self-Improvement & Anti-Drift

> S82 INFRA | 2026-04-06 | Compilado de: /insights report + 3 pesquisas (anti-drift, anti-fragile, self-improvement)
> Objetivo: resolver retrabalho, cross-ref failures, drift, perda de direcao, ausencia de loops

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

---

## O que falta implementar (ordenado por impacto)

### Dia 0 — Observability (pre-requisito)

#### OTel nativo do Claude Code (5 min)
Claude Code emite telemetria OpenTelemetry nativamente. Env vars:

```bash
# Adicionar ao ~/.bashrc ou perfil PowerShell
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
export OTEL_METRIC_EXPORT_INTERVAL=10000
# Opt-in para conteudo de prompts (desligado por padrao):
# export OTEL_LOG_USER_PROMPTS=1
```

Metricas emitidas: `claude_code.cost.usage` (USD), tokens por tipo (input/output/cache), session ID, model, lines changed.

Backend: **Langfuse** (19k+ stars, MIT, self-host $0, cloud free 50k events/mes).
Alternativa: **Arize Phoenix** (8.6k stars, ELv2, `pip install arize-phoenix`).

Sem isso nao medimos nada. Sem medir, nao melhoramos. Layer 0.

### Dia 2 — Enforcement

#### 5. ifttt-lint (1-2h) — IMPACTO MUITO ALTO
Unica solucao **deterministico** — bloqueia commit se cross-ref nao foi feito.
Directives em comentarios: `LINT.IfChange` / `LINT.ThenChange`.

```
Instalar: pip install pre-commit (ja tem) + ifttt-lint
Adicionar: directives nos slides HTML, _manifest.js, evidence HTML
Configurar: .pre-commit-config.yaml
```

#### 6. Known-Bad Patterns registry (20 min) — IMPACTO ALTO
Via Negativa (Taleb): registro persistente do que falha.
Inspirado em NeoSigma (39% melhoria sem model upgrade) + sec-context (475 stars, 25+ anti-patterns).

```
Criar: .claude/rules/known-bad-patterns.md
/insights alimenta automaticamente. Formato:
  ## [PATTERN-ID] Titulo
  - Quando | Sintoma | Causa | Fix | Sessoes
```

#### 7. Self-healing loop skeleton (30 min) — IMPACTO ALTO
Fecha o loop: falha → classificacao → proposta → revisao → fix → menos falha.

```
hooks/stop-hygiene.sh → grep erros/correcoes → classificar → append .claude/pending-fixes.md
hooks/session-start.sh → surfacear pending-fixes se existir
```

Mapeamento ao H-LLM framework (NeurIPS 2024):
Monitor = OTel | Diagnose = /insights | Adapt = rule/skill edits | Test = pytest

### Semana seguinte — Tier 2 (baixo custo, media complexidade)

#### 8. Local OTel collector + Grafana
Dashboard para trends de custo, error rates, cache efficiency.
Referencia: `claude-code-otel` (MIT, Docker Compose).

#### 9. Circuit breaker hook de custo
PostToolUse hook verifica custo acumulado, mata sessao no threshold.
Previne cenario ZenML ($47k em 4 semanas por loop infinito entre agentes).

```
hooks/cost-circuit-breaker.sh → le metricas OTel → compara com threshold → BLOCK se exceder
```

#### 10. NeoSigma-style failure registry estruturado
JSON tracking: failure_mode, count, resolution_rate, last_seen.
/insights gera, proximo sessao consome. Constrained optimization: so aceitar mudancas que nao regridem.

#### 11. /insights output estruturado
JSON em vez de prose. Rastrear quais propostas foram aceitas/rejeitadas. Alimenta failure registry.

### Mes seguinte — Tier 3 (avaliacao estrategica)

#### 12. Graphiti temporal knowledge graph
Substituir MEMORY.md flat por facts temporais. Requer Neo4j.
Bi-temporal model: facts recebem validity end date, nao sao deletados.
Piloto com subset de memory files.

#### 13. Claude-Mem integration
Captura real-time de sessao vs batch /dream. MCP server + hooks.
AGPL-3.0 — avaliar implicacoes de licenca. 4.1k stars.

#### 14. Aider-style auto-fix on lint failure
guard-lint bloqueia mas nao corrige. Estender: on failure, Haiku fix + re-lint.

#### 15. LangGraph-style checkpointing
SQLite checkpointer em hooks. Crash recovery para agent runs longos.
Padrao: state salvo apos cada tool call, resume do ultimo checkpoint.

### CLAUDE.md otimizacao (pesquisa best practices)

OLMO esta acima da media: root 91 linhas (budget: 200), 6/9 rules path-scoped, enforcement anchors.
Melhorias incrementais identificadas:

#### 16. content/aulas/CLAUDE.md compartilhado (10 min)
Thin file com regras comuns a todas as aulas (build, shared/ design system, naming).
Carrega automaticamente ao trabalhar em qualquer aula. Reduz dependencia das 6 rules path-scoped.

#### 17. Mover Propagation Map para rule path-scoped (5 min)
Propagation Map (linhas 68-80 do CLAUDE.md) e especifico de aulas.
Mover para `content/aulas/CLAUDE.md` ou rule path-scoped. Salva ~15 linhas do CLAUDE.md global.
Trade-off: ja esta no qa-pipeline.md tambem (duplicacao). Decisao: Lucas.

#### 18. /context periodico
Rodar `/context` no inicio de sessao para medir consumo real de tokens.
Dados empiricos > estimativas. Sem custo.

### Nao recomendado agora (rastreado para referencia)

| Tool | Por que nao agora |
|------|-------------------|
| Mem0 | Sem modelo temporal; /dream ja faz consolidacao de memoria |
| xMemory | Research-only; inspiracao de design, nao tooling de producao |
| ChaosEater | Overkill para escala atual; revisitar quando agentes > 20 |
| Letta | Plataforma completa; OLMO se beneficia mais de tools pontuais |
| Schemathesis/Dredd/oasdiff/PactFlow | Agentes nao se comunicam via HTTP APIs ainda |
| OpenHands/SWE-agent | Referencia arquitetural; OLMO usa Claude Code nativo |
| Superpowers | OLMO ja tem patterns equivalentes; estudar TDD enforcement seletivamente |
| NeMo Guardrails | Overkill — dialogue flow control |
| Guardrails AI | Hooks nativos bastam |

---

## Metricas de Sucesso

Medir nas proximas 5 sessoes (S83-S87):

| KPI | Baseline (S75-S81) | Meta |
|-----|-------------------|------|
| Correcoes de scope creep por sessao | 3.0 | < 1.0 |
| Cross-ref failures por sessao | ~1.5 | 0 (com ifttt-lint) |
| Criterios QA inventados | 0.45/sessao | 0 |
| Context overflow com thread perdida | 55% sessoes | < 20% |
| Retrabalho (acao refeita) | ~0.5/sessao | < 0.1 |
| Custo por sessao (USD) | desconhecido | baseline com OTel |

---

## Architecture Vision

```
Atual (S82):
  Claude Code → flat CLAUDE.md + MEMORY.md → manual /insights
  13 hooks (guards, hygiene, crossref, checkpoint) → session-compact reinjecta

Curto prazo (S85-S90):
  Claude Code → OTel → Langfuse/Grafana → automated /insights
  ifttt-lint → pre-commit → cross-ref enforcement
  Hooks chain: checkpoint → compact → essentials + HANDOFF + checkpoint
  Failure registry → constrained optimization loop

Longo prazo (S120+):
  Claude Code → Graphiti temporal graph → bi-temporal memory
  NeoSigma-style autonomous improvement (failure → cluster → fix → verify)
  Circuit breakers + cascading model degradation
  Full validate → classify → recover → learn loop
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
