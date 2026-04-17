# S220 — Micro-batches (stop + OK per batch)

> **Status: PARTIAL-DONE — S224 audit** — B10 (plans hygiene) e B13 parcial (DEAD-REFs verify) executados em S224. B4-B9 (docling pipeline) aguardam Lucas reflection sobre docling scope. B11-B12 (stop-metrics) unknown status. B1-B3/B14-B15 nao verificados.

## Ordem profissional, cada batch = STOP + ask OK.

**B1. /dream dry-run** — inspect 4 phases, write nothing. Report proposed changes. STOP.
**B2. /dream Phase 2.6 only** — isolated run, 1 line em `project_self_improvement.md`. STOP.
**B3. git commit parcial** — progress so far (plans + session-name). STOP.
**B4. `uv python list`** — confirmar 3.13. Decide venv path. STOP.
**B5. `cd tools/docling && uv venv + uv sync`** — 2GB download. Fail-stop se erro. STOP.
**B6. `pdf_to_obsidian.py --help`** — dry imports check. STOP.
**B7. `pdf_to_obsidian.py metanalise.pdf --type Meta`** — real run. STOP.
**B8. Inspect frontmatter diff** — vs template Obsidian. Report, nao patch. STOP.
**B9. git commit** — docling state. STOP.
**B10. Plans hygiene (C)** — 1 move + 3 status notes. STOP.
**B11. Read stop-metrics.sh + propose patch (D)** — nao editar. STOP.
**B12. Apply + deploy stop-metrics.sh patch** — com verify 2-stops. STOP.
**B13. F1-F4 quick wins** — KBP-23 add, KBP-22 trim, DEAD-REFs verify, SCHEMA.md decide. STOP apos cada sub-item.
**B14. git commit** — hooks + hygiene. STOP.
**B15. HANDOFF + CHANGELOG + final commit (E)** — close.

## Regra de stop

Cada batch: eu anuncio, executo, reporto, pergunto **"OK proximo?"**. Lucas aprova. Proximo batch.

## Commits

B3, B9, B14, B15 = git commit parcial. Atacam 69min-no-commit nudge.

## Non-goals (mesmos)
14 STUCK integral, 9 hook issues restantes, S221 backlog.

## Budget
~70-85min. Pode pausar em qualquer B sem estado ruim.

---
S220 2026-04-16 | Opus 4.7
