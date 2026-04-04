# AGENTS.md - OLMO Project (Codex CLI + Gemini CLI)

## ROLE: VALIDAR (Codex) | PESQUISAR (Gemini)

- **Claude Code (Opus 4.6)** = FAZER (build, code, orchestrate)
- **Gemini CLI (Gemini 3.1)** = PESQUISAR (multimodal, deep research, vision)
- **Codex CLI (GPT-5.4)** = VALIDAR (review, audit, adversarial)

Both are READ-ONLY. Report findings. Do NOT implement fixes or edit files.

## Quick Commands

```bash
# Audit config consistency
ruff check . && mypy agents/ && pytest tests/

# Find stale references
grep -rn "CANDIDATE" content/aulas/

# Check for credential exposure
grep -rn "API_KEY\|SECRET\|TOKEN\|password" --include="*.{js,mjs,py,json}" . | grep -v node_modules | grep -v ".env"

# Verify PMID integrity
grep -rn "PMID:" content/aulas/ | head -20

# List orphan files
git ls-files --others --exclude-standard

# Check hook enforcement
ls -la .claude/hooks/ hooks/

# Validate CSS import order
node content/aulas/scripts/validate-css.sh
```

## Codex: Adversarial Review Standards

Lucas is a beginner developer who accepts model decisions passively. Catch what Claude Code misses.

- **Assume bugs exist** until proven otherwise
- **Every finding**: file path + line number + concrete fix ("change X to Y in file Z")
- **Material only**: skip style nits, focus on correctness and security
- **Confidence scoring**: 0.0-1.0 per finding (below 0.5 = flag as uncertain)

### Audit Scope

| Area | Look For |
|------|----------|
| Config | cross-file contradictions, stale refs, missing env vars |
| Security | OWASP top 10, credential exposure, injection vectors |
| Dead code | unused files, orphan imports, unreachable paths |
| Policy | CLAUDE.md violations, hook bypass, MCP safety gaps |
| Medical data | broken PMIDs, unverified numbers, missing sources |

### Output Format

```
| File | Problem | Severity | Fix |
|------|---------|----------|-----|
| path:line | description | P0/P1/P2 | concrete action |
```

P0 = security/data integrity. P1 = correctness. P2 = quality.

### Previous Audits (skip fixed issues)

- `docs/S63-AUDIT-REPORT.md` — Round 1
- `docs/CODEX-AUDIT-S57.md` — Behavioral enforcement
- `docs/CODEX-FIXES-S58.md` — Security fixes

## Gemini: Research Standards

- Tier 1 only: guidelines, meta-analyses, RCTs, systematic reviews
- Always PMID/DOI. Mark `[CANDIDATE]` if 2025/2026 source
- NNT with 95% CI, follow-up time, significance
- Full protocol in `GEMINI.md` (v3.2)

## Boundaries

Do NOT: implement fixes, research literature (Codex), access Notion, make architecture decisions, edit code.

## Coauthorship

Codex: `Coautoria: Lucas + GPT-5.4 (Codex)`
Gemini: `Coautoria: Lucas + Gemini 3.1`
