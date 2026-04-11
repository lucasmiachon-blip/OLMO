# HANDOFF - Proxima Sessao

> Sessao 154 | 2026-04-11
> Foco: INFRA_LEVE2 — execucao plano S153 (Scope A+B+C) + dead JSON pipeline (Scope D emergente)
> **Proxima sessao (S155) = SLIDES** (Lucas: "slides amanha somente")

## ESTADO ATUAL

Monorepo funcional. CI verde. Build PASS (**15 slides** metanalise — s-checkpoint-1 totalmente removido S154).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 13.** **Skills: 20.** **Memory: 20/20.**

S154 entregou 4 commits:
- `f368fdb` Scope C — research SKILL Step 2 ganhou coluna `type` + Fallback ID (P005)
- `e5cf768` Scope D — kill dead JSON-driven /research pipeline (s-pico.json + s-rs-vs-ma.json + generate-evidence-html.py; SKILL.md doc-rot ressolvido)
- `2ac4869` Scope A — remove s-checkpoint-1 from active deck (14 files, +16/-248)
- (este wrap)

Scope B: 18 orphan plans archived em `.claude/plans/archive/SXXX-*.md` (Lucas batch-approved). Apenas `sunny-plotting-fountain.md` ativo, arquivado neste wrap como `S154-sunny-plotting-fountain.md`.

## P0 — Slides (Lucas: "slides amanha somente")

### Forest plot novos (2 — Lucas decide combo)
- **Slide A:** Vaduganathan 2022 (SGLT2i/IC, PMID 36041474 VERIFIED) — anatomia basica
- **Slide B:** Colchicina — 3 MAs candidatas (Ebrahimi 2025 Cochrane CANDIDATE + Samuel 2025 EHJ 40314333 VERIFIED + Li 2026 AJCD 40889093 VERIFIED)
- Evidence: `forest-plot-candidates.html` (9 candidatos, 6 combos)

## P1 — A11y gaps residuais (low priority)

- **Benchmark `pre-reading-heterogeneidade.html`:** 14 links `target="_blank"` sem `rel="noopener"` + 3 `<th>` sem scope — skipped para preservar invariante read-only.
- **forest-plot-candidates.html:** 9 `<th colspan="2">` sao label rows. Fix semantico caso-a-caso pendente.

## BACKLOG (canal persistente self-improvement)

| # | Item | Detalhe |
|---|------|---------|
| 1 | Pernas pendentes (research) | Perna 2 (evidence-researcher), Perna 6 (NLM: requer login) |
| 2 | Adversarial deferred: M-01, M-10 | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 3 | Hook/config system review | JSON adequado? YAGNI audit. Lucas flagged S152 |
| 4 | Pipeline DAG end-to-end | cowork→NLM→wiki |
| 5 | medicina-clinica stubs | 4 concepts stub/low aguardam Cowork harvest |
| 6 | Skill de slides consolidada | Usar skill-creator para criar skill nova |
| 7 | P006: plan pre-flight tool availability | Re-design: Step 1.5 em research/SKILL.md ou static allowlist |
| 8 | **Postmortem dead JSON+py pipeline** | Investigar WHY: YAGNI? abstraction mismatch? Lucas iniciante? Origem S46-S48, abandono S75, remocao S154. Lucas pediu "para registrar" |

## DECISOES ATIVAS

- **Living HTML = source of truth = SINTESE CURADA.** Escrito direto, sem JSON intermediario (S154 confirmed via dead pipeline removal).
- **Evidence CSS benchmark S148:** `pre-reading-heterogeneidade.html` = padrao-ouro visual.
- **Regra PMID em #referencias S151:** PMID em prosa = violacao. Excecao: books → `.book` + ISBN.
- **KBP-13 (S152):** verificar state/history/intent antes de afirmar.
- **Scope-shrink symmetry (S152):** skip silencioso = drift, report obrigatorio.
- **Plans lifecycle (S152):** archive/SXXX-name.md, per-file decision, default=keep. **18 plans arquivados S154.**
- **s-checkpoint-1 removido S154:** I1 nao retorna. Code/CSS/JS/cross-refs limpos. Apenas historicos preservados (CHANGELOG, _archive/, audits, research reports).
- **Estilo narrativo S119:** foco em metodologia. Dual creation S135. Pedagogia adultos S135. Speaker notes em evidence S135. Archetype removal S136. Projecao auditorio 10m S142. Motion com proposito S139. QA visual screenshot S138. QA output WHAT/WHY/PROPOSAL/GUARANTEE S139. Navy card ΣN hero S139. Fresh eyes S140. Call D S140. Temp editorial 1.0 S141.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro (LLM).
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- KBP-07 anti-workaround, KBP-08 anti-substituicao, KBP-09 anti-routing, KBP-10 anti-destructive, KBP-11 Gemini thinking pool, KBP-12 structured output, **KBP-13 claim-without-verification**.
- **Verificar atribuicao via `git log -S '<literal>'` antes de afirmar origem** (KBP-13).
- MCP gate + Research gate: hooks force "ask" antes de MCP/research calls.
- MCP freeze ate 2026-04-14 (9 frozen; PubMed/SCite/Consensus ativos).
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever sem instrucao EXPLICITA.
- Gemini FPs conhecidos: css_cascade e failsafes/@media print.
- Benchmark `pre-reading-heterogeneidade.html` = READ-ONLY.
- **Hook bug pattern (S152):** PostToolUse hook que parseia `tool_input.command`/`tool_response`: NAO usar `sed -n 'Np'`; usar `tr.interrupted` (nao existe `exit_code` para Bash). Ver `hooks/success-capture.sh` pos-fix.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S154 2026-04-11
