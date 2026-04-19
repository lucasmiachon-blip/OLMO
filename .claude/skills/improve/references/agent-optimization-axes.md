# Agent/Subagent Optimization — 6 Axes (S190)

> Backlog #29. Research-backed. Apply when running `/improve audit` on agents.

| Eixo | O que | Status | Ref |
|------|-------|--------|-----|
| Tool restrictions audit | Agents tem ferramentas demais? Reduzir superficie de ataque | PENDING | Anthropic best practices |
| Model routing | Agents leves (repo-janitor, quality-gate) em Haiku em vez de Sonnet | PENDING | Boris: "cheapest model that solves" |
| maxTurns calibration | Calibrar ao uso real com margem +20%, nao chute | PENDING | session-hygiene.md §Hardening |
| Agent composition (HyperAgents) | Self-representation, grafo semantico do codebase | FUTURE | Meta 2026 (Golchian) |
| Subagent parallelism | QA gates em paralelo (preflight+inspect+editorial simultaneo) | PENDING | Anthropic orchestrator-workers |
| Agent-as-skill migration | Agents sem isolamento real → skills context:fork (mais lean) | PENDING | "skills for knowledge, agents for isolation" |

## Current Agents (9)

| Agent | Model | Tools | maxTurns | Candidate for |
|-------|-------|-------|----------|---------------|
| evidence-researcher | (default) | Read,Grep,Glob,WebFetch,Bash,MCPs | - | Tool audit |
| mbe-evaluator | (default) | Read,Grep,Glob | - | Haiku? (read-only) |
| qa-engineer | (default) | Read,Write,Edit,Bash | - | Parallelism |
| quality-gate | (default) | Read,Grep,Glob,Bash | - | Haiku? (lint only) |
| reference-checker | (default) | Read,Grep,Glob,WebSearch,MCPs,Write,Edit | - | Tool audit (Write needed?) |
| repo-janitor | (default) | Read,Bash,Glob,Grep | - | Haiku? |
| researcher | (default) | Read,Grep,Glob,Bash | - | Skill migration? |
| sentinel | sonnet | Read,Bash,Glob,Grep | 25 | OK (calibrated) |
| systematic-debugger | (default) | Read,Grep,Glob,Bash,Write,Edit | - | Tool audit |

## Sources

- HyperAgents: Golchian 2026 (Meta) — self-referential code modification with semantic graph
- DGM: Sakana AI 2025 (arXiv:2505.22954) — evolutionary archive of agent variants
- Anthropic: "Building Effective Agents" Dec 2024 — orchestrator-workers pattern
- Boris Cherny: "simplest possible option", "less steering + better tool use"
