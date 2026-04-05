# S68 Codex Adversarial — Triagem Pendente

> Gerado: S68 | 2026-04-04 | Coautoria: Lucas + Opus 4.6 + GPT-5.4 (Codex)
> Status: Triagem parcial. Fixes pendentes para proxima sessao.

---

## FIXES JA APLICADOS (S68)

- [x] metanalise/CLAUDE.md: removido `WT-OPERATING.md` (dead ref)
- [x] design-reference.md: token source corrigido (base.css shared → aula.css cascade)
- [x] design-reference.md: E52 clarificado (vw proibido em font-size, clamp() so para layout)

---

## ROUND 2A — Cross-File Contradictions

### PAIR 1: CLAUDE.md vs anti-drift.md
**VERDICT: MINOR**
- Contradiction: NO
- Terminology drift: YES — "espere OK" vs "approved plan", "Efficiency" vs "Budget awareness"
- **Acao sugerida**: ACCEPT (naming diferente mas sem conflito real)

### PAIR 2: session-hygiene.md vs HANDOFF.md
**VERDICT: ACTION NEEDED**
- HANDOFF excede template (~50 linhas vs max ~30)
- Estrutura real: P0/P1 + DECISOES ATIVAS + CUIDADOS (nao documentados na regra)
- **Fix pendente**: Atualizar session-hygiene.md para refletir estrutura real:
  ```
  ## HANDOFF.md (max ~50 linhas)
  Estrutura: ESTADO ATUAL → P0/P1 (priority bands) → DECISOES ATIVAS → CUIDADOS → PENDENTE → CONFLITOS.
  ```

### PAIR 3: slide-rules.md vs design-reference.md
**VERDICT: ACTION NEEDED**
- E52 conflict: slide-rules bane todo vw; design-reference permitia com clamp() → **JA CORRIGIDO S68**
- Token source: slide-rules diz base.css, design-reference dizia cirrose.css → **JA CORRIGIDO S68**
- E21 duplicado entre ambos: ACCEPT (complementares, nao identicos)
- Precedence gap: nenhum file diz qual vence → considerar adicionar nota

### PAIR 4: mcp_safety.md vs notion-cross-validation.md
**VERDICT: ACTION NEEDED**
- mcp_safety diz "cross-validation para writes" (amplo)
- notion-cross-validation scopa so reorganizar/arquivar/batch>5
- Post-write re-read duplicado em ambos
- **Fix pendente**: mcp_safety ANTI-PERDA L38 consolidar:
  ```
  - Batch > 5 items OR reorganizar/arquivar/mesclar → cross-validation obrigatoria (ver notion-cross-validation.md)
  ```

### TOP 3 RISCOS (Codex ranking)
1. slide-rules vs design-reference — **PARCIALMENTE CORRIGIDO** (E52+tokens OK, precedence gap pendente)
2. mcp_safety vs notion-cross-validation — **PENDENTE**
3. session-hygiene vs HANDOFF — **PENDENTE**

---

## ROUND 2B — Dead References

### LIKELY_DEAD (confirmados)

| Ref | Arquivo | Status | Fix |
|-----|---------|--------|-----|
| `WT-OPERATING.md` | metanalise/CLAUDE.md | **REMOVIDO S68** | Done |
| `guard-lint-before-build.sh` | CLAUDE.md root L63 | Path parcial | **Fix pendente**: qualificar para `.claude/hooks/guard-lint-before-build.sh` |
| `session-hygiene.md` | CLAUDE.md root L69 | Path parcial | Aceitavel (agente resolve via Glob), fix opcional |
| `BudgetTracker` | anti-drift.md | Ja removido | N/A |

### UNKNOWN (verificar)

| Ref | Arquivo | Analise |
|-----|---------|---------|
| `/concurso` | CLAUDE.md root | Sao skills (slash commands), nao paths — naming correto |
| `/exam-generator` | CLAUDE.md root | Idem |
| `docs/coauthorship_reference.md` | coauthorship.md | Verificar existencia |
| `templates/chatgpt_audit_prompt.md` | notion-cross-validation.md | Verificar existencia |
| `docs/mcp_safety_reference.md` | mcp_safety.md | Verificar existencia |

### EXISTS (confirmados, sem acao)
- docs/ARCHITECTURE.md, docs/TREE.md, orchestrator.py, config/ecosystem.yaml
- .claude/rules/coauthorship.md, mcp_safety.md, notion-cross-validation.md
- shared/, cirrose/, metanalise/, grade/, assets/provas/, assets/sap/
- base.css, {aula}.css, shared/js/deck.js, shared/assets/fonts/

---

## CROSS-REFERENCE FINDINGS (Explore agent)

### ALTO — session-hygiene template (PENDENTE)
- Regra diz max 30 linhas + estrutura simples
- Realidade: 50 linhas + P0/P1 + DECISOES ATIVAS + CUIDADOS
- Fix: atualizar regra para max ~50 + estrutura real

### MEDIO — mcp_safety redundancia (PENDENTE)
- Post-write re-read em mcp_safety (Fase 3 L24-26) E notion-cross-validation (step 8 L20)
- Cross-validation trigger vago vs scoping preciso
- Fix: mcp_safety referenciar notion-cross-validation

### MEDIO — CLAUDE.md path parciais (PENDENTE)
- guard-lint-before-build.sh → qualificar para .claude/hooks/
- session-hygiene.md → opcional (Glob resolve)

### BAIXO — ENFORCEMENT duplicado (DECISAO LUCAS)
- CLAUDE.md L3-7 e L74-78 sao identicos (primacy + recency anchor)
- Intencional anti-compaction, mas Codex flaggou como waste
- Manter ou cortar? Lucas decide

### NOTA — design-reference "HEX e verdade" (PENDENTE AVALIACAO)
- design-reference.md L119: "HEX e verdade de renderizacao"
- Codigo real usa OKLCH via color-mix() como primary
- Avaliar se "HEX e verdade" e regra de verificacao visual ou erro factual

---

## CHECKLIST — TRIAGEM S69

- [x] session-hygiene.md: atualizar template HANDOFF (max 50, priority bands) — **FIXED S69**
- [x] CLAUDE.md: qualificar path guard-lint-before-build.sh — **FIXED S69**
- [x] Verificar existencia: docs/coauthorship_reference.md, templates/chatgpt_audit_prompt.md, docs/mcp_safety_reference.md — **TODOS EXISTEM**
- [~] mcp_safety.md: consolidar ANTI-PERDA — **DESCARTADO** (defense in depth, nao e redundancia)
- [~] Decisao: ENFORCEMENT duplicado — **MANTER** (anti-compaction intencional)
- [~] Avaliar: "HEX e verdade" — **MANTER** (regra QA correta, Codex nao entendeu dominio)
- [~] Slide-rules vs design-reference precedencia — **DESCARTADO** (conflito ja corrigido S68)

---

Coautoria: Lucas + Opus 4.6 (orquestrador) + GPT-5.4 via Codex (auditor)
