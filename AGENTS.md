# AGENTS.md - OLMO Project (Codex CLI + Gemini CLI)

> ⚠️ **Claude Code NÃO lê este arquivo.** Consumer: Codex CLI + Gemini CLI (convenção própria dos CLIs externos). Claude Code governa-se por `CLAUDE.md` + `.claude/rules/` apenas. Este arquivo orienta cross-CLI strategy.

## ROLE: VALIDAR (Codex) | PESQUISAR (Gemini) | Codex S259+ also RESEARCH perna #6

- **Claude Code (Opus 4.7)** = FAZER (build, code, orchestrate)
- **Gemini CLI (Gemini 3.1)** = PESQUISAR (multimodal, deep research, vision)
- **Codex CLI (GPT-5.5 + `reasoning.effort=xhigh`)** = VALIDAR (review, audit, adversarial) + **RESEARCH S259 POC** (research perna #6 em /evidence pipeline; agent: `.claude/agents/codex-xhigh-researcher.md`)

Codex + Gemini são READ-ONLY por default (Claude Code não é vinculado por esta restrição). Report findings. Só editar quando Lucas aprovar explicitamente o escopo no thread atual.

## Codex/Gemini EC loop obrigatorio

Contexto e memoria de agente sao efemeros. Antes de qualquer edicao, comando com side effect, commit/push, ou mudanca operacional, Codex/Gemini devem tornar a decisao reproduzivel no thread atual:

```text
[EC] Fase 1 - Verificacao: o que foi checado antes de agir.
[EC] Fase 1 - Evidencia: file:line, comando/output, SHA, PMID/DOI/URL, ou outro artefato verificavel.
[EC] Fase 1 - Gap A3: estado atual -> estado esperado -> gap mensuravel -> fonte de verdade.
[EC] Fase 2 - Steelman obrigatorio: melhor argumento contrario ou melhor razao para nao fazer.
[EC] Fase 3 - Mudanca proposta: arquivos exatos, alteracao minima, fora-de-escopo explicito.
[EC] Fase 3 - Por que e mais profissional: por que esta abordagem reduz risco melhor que alternativas; o que um engenheiro rigoroso faria agora vs deferiria com razao.
[EC] Fase 4 - Pre-mortem (Gary Klein): falha concreta plausivel + mitigacao/verificacao.
[EC] Fase 4 - Rollback/stop-loss: gatilho objetivo para abortar, reverter ou pedir ajuda.
[EC] Fase 5 - Verificacao pos-mudanca: comando(s) e criterio objetivo PASS/FAIL.
[EC] Fase 6 - Learning capture: adotar, ajustar, reverter ou codificar como regra/hook/teste.
[AUTORIZACAO] Aguardar OK explicito do Lucas antes de executar.
```

Sem `[AUTORIZACAO]` explicita no thread atual = STOP e reportar. "Parece logico", "ja estava no plano" ou memoria de sessoes anteriores nao contam como permissao.

## S259 architectural POC: Codex as research perna

Lucas signaled (S259) intent to migrate research orchestration de `.mjs` scripts (`content/aulas/scripts/*.mjs` — fragility reportada) → **agents/skill pattern** (SOTA Anthropic Claude Code 2026: subagents declarativos com tool isolation + skill markdown > imperative scripts).

POC vehicle: **`codex-xhigh-researcher`** subagent — invocation pattern:
```bash
codex exec -c reasoning.effort=xhigh --ephemeral -s read-only "<prompt>"
```

S266 runtime note: do **not** pass `--model` from the Claude subagent path; `~/.codex/config.toml` default applies.

Cross-family validation (OpenAI vs Anthropic vs Google ecosystems) é defesa contra hallucination compartilhada entre modelos da mesma família.

Full `.mjs` migration deferred S260+ gated by POC outcome (≥3 of 5 R-questions convergem com outras 5 pernas + cost ≤ $0.30 per question + PMID fabrication ≤ 10%).

**Migration architecture reference (S260+):** `.claude/plans/immutable-gliding-galaxy.md` (Conductor 2026 — Arquitetura OLMO em 12 braços) §11b Mermaid DAG Architecture + §11c Phasing P0→P4 + §11d Council pattern multi-model. Braços relevantes: 4.3 RESEARCH + 4.10 TOOLING/ECOSYSTEM + 4.11 ORQUESTRACAO_MULTI_MODEL. S260+ migration plan deve consultar este DAG antes de touch additional `.mjs`.

## Quick Commands

```bash
# Base audit (post-S232 Python runtime purge)
uv run ruff check .
uv run mypy scripts/ config/

# Slide lint (enforced by guard-lint-before-build.sh)
node content/aulas/scripts/lint-slides.js {aula}
node content/aulas/scripts/lint-case-sync.js {aula}

# Orphan/stale check
git ls-files --others --exclude-standard
grep -rn "CANDIDATE" content/aulas/

# Secrets audit (pre-commit)
grep -rn "API_KEY\|SECRET\|TOKEN\|password" --include="*.{js,mjs,py,json}" . | grep -v node_modules | grep -v ".env"
```

Detalhe por domínio via skills Claude Code: `janitor` (orphans), `docs-audit` (markdown), `review` (code security), `evidence-audit` (PMIDs), `done-gate` (per-aula DONE).

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

### Behavioral Heuristics (complement to scope above)

- **Confirmation inertia**: Is the model just agreeing with Lucas? Check for 3+ consecutive agreements without a single objection or risk raised.
- **Context drift**: Do new rules/changes contradict `CLAUDE.md`, `GEMINI.md`, or existing `.claude/rules/`? Cross-file diff required. (See: `anti-drift.md`)
- **Evidence integrity**: Cross-validate PMIDs against living HTML (canonical) and PubMed. LLM-generated PMIDs have ~56% error rate. (See: `reference-checker.md`)

### Validated Workflow (S50-S51)

Model A (GPT-5.4) generates findings → Model B (Opus) validates against code → Human triages → Fix confirmed TRUE only. FP rate: ~8% (3/38). Without validation: ~30% FP.

### Output Format

```
| File | Problem | Severity | Fix |
|------|---------|----------|-----|
| path:line | description | P0/P1/P2 | concrete action |
```

P0 = security/data integrity. P1 = correctness. P2 = quality.

### Previous Audits (archived S215 — history in git log)

- S57: Behavioral enforcement (15 objective + 10 adversarial)
- S58: 10 fixes applied, 6 rejected with justification
- S60: Security hardening (16 objective + 8 adversarial)
- S61: Memory consolidation audit

## Gemini: Research Standards

- Tier 1 only: guidelines, meta-analyses, RCTs, systematic reviews
- Always PMID/DOI. Mark `[CANDIDATE]` if 2025/2026 source
- NNT with 95% CI, follow-up time, significance
- Full protocol in `GEMINI.md` (v3.7)

## Boundaries

Do NOT by default: implement fixes, access Notion, make architecture decisions, edit code. Exception: Lucas can explicitly approve a bounded edit scope in the current thread. Codex research is allowed only via the S259+ `codex-xhigh-researcher` POC / evidence pipeline.

## Coauthorship

Codex: `Coautoria: Lucas + GPT-5.5 (Codex xhigh)`
Gemini: `Coautoria: Lucas + Gemini 3.1`
