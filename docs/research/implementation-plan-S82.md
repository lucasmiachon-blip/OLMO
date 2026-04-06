# Plano de Implementacao — Self-Improvement & Anti-Drift

> S82 INFRA | 2026-04-05 | Compilado de: /insights report + pesquisa anti-drift
> Objetivo: resolver retrabalho, cross-ref failures, drift, perda de direcao

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

| Ferramenta | O que faz | Custo | Decisao |
|------------|-----------|-------|---------|
| **ifttt-lint** | Cross-ref deterministico via pre-commit | $0 | IMPLEMENTAR (Dia 2) |
| **claude-mem** | Auto-capture + reinject de memoria (21.5k stars) | $0 | AVALIAR (se rework persistir) |
| **claude-code-context-handoff** | Auto-handoff pre/pos compaction | $0 | AVALIAR (pode substituir hooks manuais) |
| **post_compact_reminder** | Reinjecta lembrete pos-compaction | $0 | JA IMPLEMENTADO (session-compact.sh) |
| **plansDirectory** | Planos versionados | $0 | IMPLEMENTAR (2 min) |
| **Mem0 MCP** | Memory-as-a-service | Free tier | BACKLOG |
| **Letta** (ex-MemGPT) | Tiered memory OS-inspired | Self-hosted $0 | BACKLOG |
| NeMo Guardrails | Dialogue flow control | $0 | DESCARTADO (overkill) |
| Guardrails AI | LLM output validation | $0 | DESCARTADO (hooks nativos bastam) |

---

## Fontes

- `/insights` report: `.claude/skills/insights/references/latest-report.md`
- Pesquisa anti-drift: `docs/research/anti-drift-tools-2026.md` (449 linhas, 30+ fontes)
- Pesquisa self-improvement: `docs/research/agent-self-improvement-2026.md` (aguardando)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-06
