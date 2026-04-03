# Rule Compliance Matrix — 2026-04-03

> Scope: 27 sessions (last 7 days), 11 rule files, 20 recent commits

## Matrix

| Rule File | Status | Confidence | Evidence Source |
|-----------|--------|------------|-----------------|
| `anti-drift.md` | PARTIALLY FOLLOWED | Medium | 23/27 sessions have intent declarations; 5-step gate not verifiable from transcripts |
| `coauthorship.md` | FOLLOWED | High | 20/20 recent commits have Co-Authored-By header |
| `design-reference.md` | FOLLOWED | High | CSS tokens verified: --danger hue=8 (<=10), chroma=0.22 (>=0.20). E059 fix applied. PMID workflow active in 10+ sessions |
| `efficiency.md` | STALE | High | BudgetTracker referenced but DB never created. Rule too vague (5 lines) |
| `mcp_safety.md` | FOLLOWED | High | 10 sessions with Notion MCP; read-first patterns observed; no bulk writes |
| `notion-cross-validation.md` | FOLLOWED (dormant) | Medium | No reorganization operations in scope; rule valid but untested recently |
| `process-hygiene.md` | FOLLOWED | High | 0 actual `taskkill //IM node.exe` executions; PID-based kills used; port checks in dev sessions |
| `qa-pipeline.md` | FOLLOWED | Medium | QA terminology in 10+ sessions; gate sequencing referenced; limited deep-dive into actual execution |
| `quality.md` | PARTIALLY FOLLOWED | Low | Rule too vague to audit rigorously (5 generic lines) |
| `session-hygiene.md` | FOLLOWED | High | HANDOFF.md at S54, CHANGELOG.md append-only, both updated with each commit session |
| `slide-rules.md` | PARTIALLY FOLLOWED | High | Metanalise: 0 inline styles. Cirrose: 6. Grade: 1876 (pre-dates rule, imported legacy) |

## Findings Summary

| Finding | Category | Priority | Fix Target |
|---------|----------|----------|------------|
| BudgetTracker never materialized | RULE_STALE | Low | efficiency.md |
| check-evidence-db.sh hook deprecated | RULE_STALE + HOOK_GAP | Medium | settings.local.json + hook file |
| CLAUDE.md hook count wrong (4 vs 5) | RULE_GAP | Low | CLAUDE.md |
| Grade aula 1876 inline styles | RULE_STALE | Medium | slide-rules.md (legacy exemption) |
| Anti-drift 5-step gate no enforcement | RULE_GAP | Medium | anti-drift.md |
| quality.md too vague | RULE_STALE | Low | Merge into CLAUDE.md or expand |
| No encoding rule (cp1252) | RULE_GAP | Low | quality.md or CLAUDE.md |
| Stale skills not cleaned up | RULE_GAP | Low | evidence/, mbe-evidence/ |

## Overall Assessment

- **5/11 rules** fully followed (45%)
- **3/11 rules** partially followed (27%) — gaps in enforcement or legacy exceptions
- **3/11 rules** have staleness issues (27%) — aspirational references, deprecated workflows
- **0/11 rules** actively violated
- **4 gaps** identified — patterns in memory/practice not yet codified as rules
