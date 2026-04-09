---
title: Rules
description: Regras comportamentais — 11 rules, KBPs, enforcement via hooks, anti-drift
domain: sistema-olmo
confidence: high
tags: [rule, kbp, anti-drift, enforcement, via-negativa]
created: 2026-04-08
sources:
  - .claude/rules/*.md
  - .claude/rules/known-bad-patterns.md
---

# Rules

Rules sao contratos comportamentais em markdown, auto-loaded em toda sessao do repo. Definem o que o agente DEVE e NAO DEVE fazer.

## Inventario (11 rules)

| Rule | Escopo |
|------|--------|
| anti-drift.md | Transparencia, scope discipline, failure gate, momentum brake |
| known-bad-patterns.md | Via Negativa — 7 KBPs acumulados (S82-S116) |
| multi-window.md | Orquestrador unico, workers read-only, guard hook |
| session-hygiene.md | HANDOFF + CHANGELOG obrigatorios, checkpoints |
| coauthorship.md | Coautoria AI explicita em toda producao |
| qa-pipeline.md | 11 steps lineares, 1 slide/vez, scripts canonicos |
| slide-rules.md | Edicao, CSS, motion, GSAP, deck.js |
| design-reference.md | Semantica de cor, tipografia, dados medicos |
| process-hygiene.md | Portas, processos, PID management |
| mcp_safety.md | Protocolo Notion MCP, read-only default |

## Known-Bad Patterns (Via Negativa)

| KBP | Padrao | Status |
|-----|--------|--------|
| KBP-01 | Scope creep — agir sem permissao | Hooks enforcem (S102+) |
| KBP-02 | Context overflow → thread loss | Checkpoints proativos |
| KBP-03 | Reinventar scripts existentes | Script primacy rule |
| KBP-04 | QA com criterios inventados | Criteria-source mandate |
| KBP-05 | Batch QA multi-slide | 1 slide/invocacao enforced |
| KBP-06 | Agent delegation sem verificacao | Pre-launch checklist |
| KBP-07 | Workaround sem diagnostico | Failure gate (5 steps) |

**Governance:** /insights appende novos KBPs. NUNCA remover — so marcar RESOLVED. IDs estaveis e sequenciais.

## Enforcement

Rules sao enforced em 3 camadas:
1. **Texto** — agente le e segue (fragil, falha sob pressao)
2. **Hooks** — harness bloqueia violacoes (estrutural, model-proof)
3. **Memory** — feedback persiste entre sessoes (aprendizado)

Piramide: texto < hooks < KBPs. Quando texto falha, criar hook. Quando hook falha, criar KBP.

## Relacionados

- [[hook]] — hooks enforcem rules estruturalmente
- [[agent]] — agents seguem rules via prompt + hooks
- [[memory]] — KBPs alimentam feedback memories
