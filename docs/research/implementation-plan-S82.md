# Plano de Implementacao — Self-Improvement & Anti-Drift

> S82 INFRA | 2026-04-06 | Compilado de: /insights report + pesquisa anti-drift + pesquisa anti-fragile
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

### Analise anti-fragilidade (pesquisa independente, 7 camadas Taleb)

Nosso sistema mapeado nas 7 camadas anti-fragile:

| Camada | Descricao | Nosso estado |
|--------|-----------|-------------|
| L1 Retry + backoff | Retry transiente (429/5xx) | **PARCIAL** — scripts tem retry, sem jitter |
| L2 Model fallback | Primary → secondary → tertiary | **ZERO** — so Opus, sem fallback chain |
| L3 Circuit breaker | Fast-fail quando endpoint morre | **PARCIAL** — maxTurns nos agentes |
| L4 Graceful degradation | Cache/simpler response | **ZERO** |
| L5 Self-healing loop | Validate → classify → recover → learn | **ZERO** — /insights e manual |
| L6 Chaos engineering | Injecao deliberada de falhas | **ZERO** |
| L7 Continuous learning | Falha → dado que melhora futuro | **ZERO** — sem loop persistente |

**Conclusao:** Estamos entre L1-L3 (resiliencia parcial). Layers 5-7 (anti-fragilidade real) nao existem.

### Gaps criticos

| Gap | Impacto | Solucao proposta | Custo |
|-----|---------|-----------------|-------|
| Zero observability | Nao sabemos tokens/custo/erros por sessao | OTel nativo (3 env vars) | $0 |
| Sem cross-ref deterministico | Edita slide, esquece manifest → QA falha | ifttt-lint | $0 |
| Sem self-healing loop | Falha → conserto manual proximo sessao | Validate→classify→recover | $0 |
| Memory sem temporal invalidation | Fact stale vive para sempre | TTL/timestamps em memory | $0 |
| Contract mismatch silencioso | Doc diz X, codigo faz Y (75% APIs driftam) | Doc follows code + CI check | $0 |

---

## O que ja fizemos (S82)

### Rules aplicadas (6 propostas /insights) ✅

| Proposta | Alvo | Commit |
|----------|------|--------|
| Criteria-source mandate | qa-pipeline.md | `9f159b3` |
| Momentum brake | anti-drift.md | `9f159b3` |
| Script primacy | anti-drift.md | `9f159b3` |
| Single-slide guard | qa-engineer.md | `9f159b3` |
| Proactive checkpoints | session-hygiene.md | `9f159b3` |
| P0 security gate | session-hygiene.md | `9f159b3` |

Impacto esperado: reduzir ~60% dos problemas comportamentais (rules agora cobrem os 5 padroes).
Limitacao: rules sao advisory — modelo pode ignorar pos-compaction.

---

## O que falta implementar (ordenado por impacto)

### Dia 0 — Observability (2 min, pre-requisito)

#### 0. OTel nativo do Claude Code (2 min) — IMPACTO FUNDAMENTAL
Claude Code ja emite telemetria OpenTelemetry. 3 env vars ativam tudo:
metricas (tokens, custo USD, tool calls), eventos (prompts, erros), traces (beta).

```bash
# Adicionar ao ~/.bashrc ou perfil PowerShell
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318  # Langfuse ou collector local
```

Backend recomendado: **Langfuse** (21.9k stars, MIT, adquirido pelo ClickHouse jan/2026).
Self-host ou cloud free tier. Decorator `@observe()` para scripts Python.

Sem isso nao medimos nada. Sem medir, nao melhoramos. Layer 0.

### Dia 1 — Quick Wins (< 1 hora total)

#### 1. Context-Essentials (10 min) — IMPACTO ALTO
Arquivo cirurgico `.claude/context-essentials.md` com 20-30 linhas criticas.
Reinjectado via `session-compact.sh`. Resolve: amnesia pos-compaction.

```
Criar: .claude/context-essentials.md
Editar: hooks/session-compact.sh (cat context-essentials.md)
```

#### 2. Propagation Map no CLAUDE.md (10 min) — IMPACTO ALTO
Tabela "se mudou X, deve mudar Y" no CLAUDE.md. Zero custo, melhora imediata.

```markdown
## Propagation Map (OBRIGATORIO)
| Se mudar...              | Deve atualizar...                      |
|--------------------------|----------------------------------------|
| slides/{id}.html         | _manifest.js + index.html (run build)  |
| evidence/{id}.html       | slide correspondente (citation block)  |
| _manifest.js             | index.html (run build-html.ps1)        |
| .claude/agents/*.md      | HANDOFF.md tabela de agentes           |
| ecosystem.yaml           | docs/ARCHITECTURE.md                   |
```

#### 3. plansDirectory config (2 min) — IMPACTO MEDIO
Planos sobrevivem sessoes via git.

```json
// settings.local.json
{ "plansDirectory": ".claude/plans" }
```

#### 4. PreCompact checkpoint hook (20 min) — IMPACTO ALTO
Hook que grava estado antes de compaction: git status, arquivos modificados, tarefa corrente.

```
Criar: hooks/pre-compact-checkpoint.sh
Configurar: settings.local.json PreCompact hook
Criar: hooks/post-compact-recovery.sh (cat checkpoint + essentials)
```

#### 5. Stop hook cross-ref check (15 min) — IMPACTO MEDIO-ALTO
Haiku verifica cross-refs no fim de cada turn (~$0.001/call).

```json
// settings.local.json Stop hook tipo prompt
"Check git diff. If slide HTML modified, verify _manifest.js + evidence also updated."
```

### Dia 2 — Enforcement (1-2 horas)

#### 6. ifttt-lint (1-2h) — IMPACTO MUITO ALTO
Unica solucao **deterministico** — bloqueia commit se cross-ref nao foi feito.
Directives em comentarios: `LINT.IfChange` / `LINT.ThenChange`.

```
Instalar: pip install pre-commit (ja tem) + ifttt-lint
Adicionar: directives nos slides HTML, _manifest.js, evidence HTML
Configurar: .pre-commit-config.yaml
```

Suporta 40+ linguagens (HTML, JS, YAML, Python).

#### 7. Known-Bad Patterns registry (20 min) — IMPACTO ALTO
Via Negativa (Taleb): em vez de adicionar guardrails, manter registro do que falha.
`/insights` ja identifica padroes; falta persistencia estruturada entre sessoes.

```
Criar: .claude/known-bad-patterns.md
Formato por entrada:
  ## [PATTERN-ID] Titulo
  - **Quando:** contexto em que ocorre
  - **Sintoma:** como se manifesta
  - **Causa:** root cause
  - **Fix:** o que previne
  - **Sessoes:** S75, S78 (evidencia)
```

/insights alimenta automaticamente. Agente consulta antes de agir em areas de risco.
Inspirado em NeoSigma: 39% melhoria sem upgrade de modelo, so com failure registry.

#### 8. Self-healing loop skeleton (30 min) — IMPACTO ALTO
Hook Stop que classifica falhas da sessao e propoe fixes para rules/hooks.
Nao aplica automaticamente — gera `pending-fixes.md` para Lucas revisar.

```
Editar: hooks/stop-hygiene.sh
  → Ao final: grep erros/correcoes da sessao
  → Classificar: RULE_VIOLATION | RULE_GAP | HOOK_GAP | PATTERN_REPEAT
  → Se encontrar: append a .claude/pending-fixes.md
Proximo sessao: surfacear pending-fixes no start hook
```

Fecha o loop: falha → classificacao → proposta → revisao → fix → menos falha.

### Semana seguinte (se necessario)

#### 7. Agent Stop hook com tools (2-3h)
Substituir prompt hook por agent hook que pode ler arquivos e verificar consistencia real.

#### 8. State machine com session.md (1h)
Estado persistente atualizado pelo agente a cada acao.

#### 9. claude-mem MCP (2-3h)
Avaliar SO SE rework persistir apos items 1-6.

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

---

## Ferramentas Descobertas (referencia)

### Implementar / Avaliar

| Ferramenta | O que faz | Stars | Custo | Decisao |
|------------|-----------|-------|-------|---------|
| **OTel nativo** | Telemetria Claude Code (tokens, custo, erros) | N/A | $0 | IMPLEMENTAR (Dia 0, 2 min) |
| **Langfuse** | Observability backend (traces, metrics, cost) | 21.9k | $0 (self-host/free) | IMPLEMENTAR (backend OTel) |
| **ifttt-lint** | Cross-ref deterministico via pre-commit | ~200 | $0 | IMPLEMENTAR (Dia 2) |
| **plansDirectory** | Planos versionados via git | N/A | $0 | IMPLEMENTAR (2 min) |
| **claude-mem** | Auto-capture + reinject de memoria | 35.9k | $0 | AVALIAR (se rework persistir) |
| **claude-code-context-handoff** | Auto-handoff pre/pos compaction | — | $0 | AVALIAR (pode substituir hooks) |

### Avaliar se gaps persistirem

| Ferramenta | O que faz | Stars | Custo | Decisao |
|------------|-----------|-------|-------|---------|
| **Mem0** | Memory universal (vector+graph+KV) | 51.4k | Free tier | AVALIAR (temporal invalidation) |
| **Graphiti/Zep** | Knowledge graph temporal (bi-temporal model) | 24.4k | $0 | AVALIAR (stale fact prevention) |
| **Letta** (ex-MemGPT) | Tiered memory, agent self-edit | 20.9k | Self-host $0 | BACKLOG |
| **Arize Phoenix** | OTel-native tracing (alternativa Langfuse) | 8.5k | $0 | ALTERNATIVA |
| **ChaosEater** | Chaos engineering automatizado para LLM | — | $0.20-0.80/cycle | BACKLOG (Layer 6) |

### Referencia (contexto, nao implementar)

| Ferramenta | O que faz | Relevancia |
|------------|-----------|-----------|
| **Superpowers** (Jesse Vincent) | Skills library TDD/debug/collab | 42k stars, marketplace oficial |
| **OpenHands** (ex-OpenDevin) | AI coding agent (CMU) | 70.4k stars, referencia arquitetural |
| **Aider** | Git-first AI coding | 39k stars, cada edit = commit |
| **NeoSigma** | Self-improvement loop autonomo | 39% melhoria sem model upgrade |
| post_compact_reminder | Reinjecta lembrete pos-compaction | JA IMPLEMENTADO (session-compact.sh) |
| NeMo Guardrails | Dialogue flow control | DESCARTADO (overkill) |
| Guardrails AI | LLM output validation | DESCARTADO (hooks nativos bastam) |

---

## Fontes

- `/insights` report: `.claude/skills/insights/references/latest-report.md`
- Pesquisa anti-drift: `docs/research/anti-drift-tools-2026.md` (449 linhas, 30+ fontes)
- Pesquisa anti-fragile: input direto do Lucas (7 camadas Taleb, observability, memory, contracts)
- Pesquisa self-improvement: `docs/research/agent-self-improvement-2026.md` (aguardando)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-06
