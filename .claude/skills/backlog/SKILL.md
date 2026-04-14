---
name: backlog
disable-model-invocation: true
description: "Structured backlog management — add, triage, close, score, report. Interactive CRUD for BACKLOG.md with auto-scoring by staleness, dependency, and alignment. Use when user says /backlog, 'triage backlog', 'add to backlog', 'backlog report', 'what's stale in backlog', or manages project debt."
version: 1.0.0
---

# Backlog — Structured Project Debt Management

> BACKLOG.md is the single source of truth. This skill reads and writes it.
> Every modification requires Lucas's approval before writing.

Operate on: `$ARGUMENTS` (mode). Default: `report`.

## Modes

### `/backlog add <description>`

1. Read BACKLOG.md, find the highest `#` number
2. Propose a new row with:
   - `#`: next sequential number
   - `Item`: concise name (< 40 chars)
   - `Detalhe`: description with session origin (e.g., "S190")
3. Show the row to Lucas. Write only after approval.

### `/backlog triage`

1. Read BACKLOG.md completely
2. For each non-RESOLVED item, score it (see Scoring below)
3. Present items sorted by score (highest first) in a table:
   `| # | Item | Score | Age | Proposal |`
4. Proposals: KEEP (with new priority if changed), CLOSE (cite evidence), ARCHIVE (stale, no longer relevant), ESCALATE (blocking other work)
5. Walk through items interactively. Lucas decides each one.

### `/backlog close #N <reference>`

1. Read BACKLOG.md
2. Find item `#N`
3. Prepend `[RESOLVED S{current}]` to the Item column
4. Append resolution reference to Detalhe

### `/backlog report`

1. Read BACKLOG.md
2. Summary: total items, open vs resolved, items by age bucket (< 5 sessions, 5-15, > 15)
3. Flag: items with > 10 sessions without progress
4. Flag: items that block P0 work in HANDOFF.md

### `/backlog score`

1. Read BACKLOG.md + HANDOFF.md
2. Auto-score each open item (see Scoring)
3. Present ranked table. No modifications — report only.

## Scoring

Four factors, each 0-3:

| Factor | 0 | 1 | 2 | 3 |
|--------|---|---|---|---|
| **Staleness** | < 5 sessions | 5-10 | 10-20 | > 20 sessions |
| **Dependency** | Nothing blocked | Nice-to-have | Enables P1 | Blocks P0 |
| **Alignment** | Tangential | Supports P2 | Supports P1 | Supports P0 |
| **Complexity** (inverse) | > 2 sessions work | 1-2 sessions | < 1 session | Quick fix (< 30 min) |

Score = sum (0-12). Higher = act sooner.

Items scoring 0-3: safe to defer. 4-7: review. 8-12: act this session or next.

## Gotchas

- NEVER batch-modify items. One at a time, Lucas approves each.
- RESOLVED items stay in the table for historical reference — do not delete rows.
- Session numbers in items are absolute (S155, not "5 sessions ago"). Calculate age from current session number.
- If BACKLOG.md format changes, adapt — the table structure is the contract, not the exact markdown.
- Backlog gate (S155): `if (commits>1 AND loc_saved<50 AND touches_runtime) → backlog`. Apply when evaluating whether new work should be a backlog item.

## Safety

- Read-only by default. Write only with explicit Lucas approval per item.
- Never remove non-RESOLVED items without approval.
- Never reorder the `#` column — numbers are permanent identifiers.
