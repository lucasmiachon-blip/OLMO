# Catalog Status — Agents + Skills

> Single source of truth para status operacional dos `.claude/agents/*.md` (21) e `.claude/skills/*/SKILL.md` (19).
> Created S271 (audit S270 §A7 closure). Review cadence: /dream cycle ou audit S275+.

## Status legend

- `active` — usado regularmente (≥1x last 9 sessions OR core path)
- `active-but-rare` — valid use case mas <1x/9 sessions; manter para uso futuro
- `intentional-dormant` — episodic by design (debug-team loop-guard, R3 seasonal)
- `candidate-delete` — sem use case claro 9+ sessions; revisar S275-280 com Lucas 1-a-1; **bulk delete proibido** (audit S270 §8)

## Agents (21)

| Name | Status | Reason |
|---|---|---|
| codex-xhigh-researcher | active | research perna #7 (S259+); cross-family validation /evidence pipeline |
| evidence-researcher | active | research perna principal /evidence; PubMed+Crossref+Scite |
| qa-engineer | active | QA pipeline metanálise editorial; per-slide invocation |
| reference-checker | active | cross-ref slides vs evidence HTML; /research pipeline |
| researcher | active | codebase exploration; high-traffic |
| quality-gate | active | pre-commit lint+test gate |
| gemini-deep-research | active-but-rare | research perna #1 broad orchestrator |
| perplexity-sonar-research | active | research perna #5 deep search Tier 1 |
| gemini-dlite-research | active | S269 D-lite research perna #1 wrapper experimental |
| perplexity-dlite-research | active | S269 D-lite research perna #5 wrapper experimental |
| debug-symptom-collector | intentional-dormant | episodic Phase 1 /debug-team |
| debug-strategist | intentional-dormant | episodic Phase 2 /debug-team |
| debug-archaeologist | intentional-dormant | episodic Phase 2 /debug-team (Gemini 1M context) |
| debug-adversarial | intentional-dormant | episodic Phase 2 /debug-team (Codex max plan) |
| debug-architect | intentional-dormant | episodic Phase 3 /debug-team (Aider Architect) |
| debug-patch-editor | intentional-dormant | episodic Phase 4 /debug-team (Aider Editor; only writer) |
| debug-validator | intentional-dormant | episodic Phase 5 /debug-team |
| sentinel | active-but-rare | self-improvement scan; CLAUDE.md recomenda usage frequente — gap entre recomendação e uso real |
| systematic-debugger | active-but-rare | structured 4-phase debugging; redundância potencial com `systematic-debugging` skill |
| repo-janitor | active-but-rare | repo cleanup; útil pos-audit |
| mbe-evaluator | active-but-rare | MBE framework eval slides; revisar uso real proxima audit |

## Skills (19)

| Name | Status | Reason |
|---|---|---|
| research | active | hot path D-lite + canonical research |
| systematic-debugging | active | 4-phase methodology; preferido vs systematic-debugger agent |
| document-conversion | active | S269 Lane D; EPUB→PDF/MD pipeline |
| insights | active | weekly /insights cycle |
| evidence-audit | active-but-rare | audit slides vs evidence; medical work |
| review | active-but-rare | code review skill |
| brainstorming | active-but-rare | Socratic pre-action; usar em decisões grandes |
| teaching | active-but-rare | ensino slideologia; Lucas é professor |
| backlog | active-but-rare | `.claude/BACKLOG.md` management |
| continuous-learning | active-but-rare | learning framework Lucas-adjacent |
| concurso | intentional-dormant | R3 prep; ativará intensivo pre-dec/2026 |
| exam-generator | intentional-dormant | gerar questões R3; ativará pre-dec/2026 |
| debug-team | intentional-dormant | episodic /debug-team orchestrator (loop-guard self-disable) |
| skill-creator | candidate-delete | meta skill; document-conversion criada manual S269 |
| improve | candidate-delete | nome genérico, função unclear |
| automation | candidate-delete | sem use case claro 9+ sessions |
| docs-audit | candidate-delete | audit docs; S270 audit foi via direct agent + Read/Grep |
| knowledge-ingest | candidate-delete | ingest knowledge; document-conversion replaces? |
| nlm-skill | candidate-delete | NotebookLM = slot per CLAUDE.md ("Slots like ... NotebookLM ... do NOT imply callable runtime") |

## Action pending

- **6 candidate-delete skills:** `skill-creator`, `improve`, `automation`, `docs-audit`, `knowledge-ingest`, `nlm-skill`. Revisar S275-280 com Lucas 1-a-1; bulk delete proibido.
- **Hot vs rare calibration:** track use via `post-bash-handler` hook stats per-agent/skill (FUTURE — não nesta sessão).
- **Sentinel gap:** CLAUDE.md recomenda usage frequente; observed 0 hits 9 sessions. Calibrar recommendation OR investigar barreira de uso.

## Review triggers

- `/dream` cycle (~24h)
- audit S275+
- pre-commit if `.claude/agents/` or `.claude/skills/` touched
- `/insights` weekly

## Source-of-truth invariants

- Status here ≠ enforcement; é registro decisional. FS truth dos counts vive em `tools/integrity.sh §INV-4`.
- KBP-16 pointer-only spirit: este file lista status mas não duplica skill descriptions (vivem em SKILL.md frontmatter).
- Audit S270 §8: "NÃO deletar 13 skills + 11 agents zero-use em batch" — `candidate-delete` = candidate, não decision-final.
