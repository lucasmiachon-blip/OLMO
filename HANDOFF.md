# HANDOFF - Proxima Sessao

> Sessao 61 | 2026-04-04

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 11 rules (5 path-scoped).
8 hooks (.claude/hooks/) + 5 hooks (hooks/). Todos com node JSON parsing.
Codex S60 audit 100% resolvido: 24/24 (20 fixed, 4 accepted). Report em `.archive/`.
Codex Memory Audit S61 em andamento: 4 frames lancados (obj+adv x round1+round2).
Round 1 objetivo completo. Demais pendentes (agents podem ter expirado).

## PROXIMO (P0 — aulas)

1. **Metanalise QA** — 18 slides, QA visual incompleto. Deadline 2026-04-15 (~11 dias)
2. **Construir slide s-pico** — evidence HTML pronto. Decidir h2, source-tag, speaker notes
3. **Rodar /research em s-aplicacao** — segundo HTML, validar com dados clinicos

## PROXIMO (P1 — memory cleanup)

4. **Cross-reference real dos 38 memory files** — Codex round 1 propoe 9 DELETE, 17 CONSOLIDATE, 3 UPDATE, 10 KEEP. Verdicts NAO validados (Lucas flaggou aceitacao passiva). Cada file precisa de leitura + grep nos canonicos antes de decidir.
5. **Governance rules para memories** — cap 20 files, criterios de criacao, review cycle. Proposta em `docs/CODEX-MEMORY-AUDIT-S61.md`
6. **MEMORY.md index** — stale, mixes status/policy/index. Reescrever como pure index apos cleanup.
7. **`.claude/hooks/README.md`** — documenta hooks deletados, faltam os 8 atuais

## PROXIMO (P2 — infra herdado)

8. **h2 assertion rewrite** — 11+ slides. Lucas guia.
9. **Merge new-slide into slide-authoring** — ultimo cleanup de skills

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- guard-lint-before-build.sh: roda 3 linters (lint-slides + case-sync + narrative-sync). BLOQUEIA se qualquer falhar.
- guard-product-files.sh: BLOQUEIA edits a settings.local.json e hooks/ (exit 2).
- guard-bash-write.sh: 11 patterns, ASK (nao block). Usado para escrever hooks protegidos.
- QA visual = Opus (multimodal) + Gemini script. Build ANTES de QA.
- Memory audit: NAO aceitar verdicts do Codex sem cross-reference real (file × canonical).

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.
- Security gates fail-closed. NaN/negative input -> BLOCK.
- settings.local.json e hooks/ BLOQUEADOS contra Edit/Write (bypass via Bash ask).
- **Memory governance pendente** — nao criar novos memories ate cleanup completo.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] ARCHITECTURE.md sync — alinhar com implementacao real

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 + Codex GPT-5.4 | 2026-04-04
