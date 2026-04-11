# HANDOFF - Proxima Sessao

> Sessao 155 | 2026-04-11
> Foco: INFRA-PESADO — adversarial dedup (Opus + 3 Gemini + 2 Codex), KBP-15 write race, backlog gate
> **Proxima sessao (S156) = SLIDES** (Lucas: "slides amanha somente" carry-over de S154→S155, agora S155→S156)

## ESTADO ATUAL

Monorepo funcional. CI verde. Build PASS (**15 slides** metanalise).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 15** (KBP-15 NEW S155). **Skills: 20.** **Memory: 20/20.**

S155 entregou 4 commits + 10 memory edits (out-of-repo) + 1 settings.local.json rewrite (gitignored):
- `e3e88f2` Plan adopted — INFRA-PESADO 3G+2C
- `310b547` D1 — multi-window/session-hygiene contradiction fix
- `f3ba682` B — 15 skill+agent descriptions compressed (-72 LOC)
- (este wrap) — known-bad-patterns.md KBP-15 + CHANGELOG + HANDOFF

Out-of-band: settings.local.json 503→481 LOC (gitignored). Memory dedup 10 edits (out-of-repo, full list em CHANGELOG).

## P0 — Pendentes deste S155 (precisam ack Lucas)

### A1+A2 — Group A permissions garbage (friction warning per KBP-14)
- **A1:** Bash(*) wildcard collapse — propos remover entries Bash() especificas dado que `Bash(*)` ja allowed. **Friction:** removendo Bash(*) wildcard significa que toda shell command nova precisa ack ate allowlist rebuild. Lucas decide.
- **A2:** MCP wildcard pattern — proposta consolidacao MCP allow patterns. Mesma natureza. Lucas decide.

**Por que parei:** KBP-14 (active mentor mode) — fast approval ≠ informed consent. Lucas merece ver o trade-off antes de aprovar.

### .claude/tmp/ cleanup (KBP-10 ack required)
21 arquivos tmp do dispatch S155: g1/g2/g3 prompts+results+sys+input, c1/c2 results, schema, settings.local.json.bak.a3+a4, strip-a3.py + strip-a4.py. **NUNCA deletar sem ack explicito do Lucas (KBP-10).** Surface listing, Lucas decide individualmente ou batch-approve.

## P0 — Slides (carry-over de S154)

### Forest plot novos (2 — Lucas decide combo)
- **Slide A:** Vaduganathan 2022 (SGLT2i/IC, PMID 36041474 VERIFIED) — anatomia basica
- **Slide B:** Colchicina — 3 MAs candidatas (Ebrahimi 2025 Cochrane CANDIDATE + Samuel 2025 EHJ 40314333 VERIFIED + Li 2026 AJCD 40889093 VERIFIED)
- Evidence: `forest-plot-candidates.html` (9 candidatos, 6 combos)

## P1 — A11y gaps residuais (low priority, carry-over)

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
| 8 | Postmortem dead JSON+py pipeline | Lucas pediu "para registrar". S156+ |
| 9 | **NEW S155 Group E** | slide-patterns.md vs slide-rules.md drift — 5 findings em `.claude/tmp/c1-result.md` (C1 #6-#10): data-background-color, inline style, slide-navy, slide-figure layout class, PMID:pending. Defer para sessao slide-focused (touches CSS/runtime + Lucas working) |
| 10 | **NEW S155 A1+A2** | settings.local.json wildcard collapse — DEFERRED S155 apos analise. Friction warning: removendo `Bash(*)` reverte fix S102 (deny recorrente em comandos safe). Trade-off real: -22 LOC vs friction 2-3 semanas. Re-examinar se houver trigger real (comando perigoso slip through) |
| 11 | **NEW S155 Group G** | Hooks lazy load por escopo — complexity-as-ceremony per backlog gate |

## DECISOES ATIVAS

- **Backlog gate (S155):** `if (commits>1 AND loc_saved<50 AND touches_runtime): → backlog`. Aplicado pelo orquestrador antes de surfacing a Lucas. patterns_antifragile.md ganhou L8 layer.
- **KBP-15 (S155 NEW):** scripts externos podem LER mas NAO MODIFICAR arquivos no write-path do Claude Code (`settings.local.json`, `.claude/*.md`). Write race = in-memory state vs disk modification.
- **Solo-audit penalty (S155):** finding sets de UM modelo so ~47% FP. Triangulados (Gemini+Codex agree) 0% FP. KBP-13 mandatorio para non-triangulated.
- **Living HTML = source of truth = SINTESE CURADA.** Escrito direto, sem JSON intermediario.
- **Evidence CSS benchmark S148:** `pre-reading-heterogeneidade.html` = padrao-ouro visual.
- **Regra PMID em #referencias S151:** PMID em prosa = violacao. Excecao: books → `.book` + ISBN.
- **KBP-13 (S152):** verificar state/history/intent antes de afirmar.
- **Scope-shrink symmetry (S152):** skip silencioso = drift, report obrigatorio.
- **Plans lifecycle (S152):** archive/SXXX-name.md, per-file decision, default=keep.
- **s-checkpoint-1 removido S154:** I1 nao retorna. Code/CSS/JS/cross-refs limpos.
- **Estilo narrativo S119:** foco em metodologia. Dual creation S135. Pedagogia adultos S135. Speaker notes em evidence S135. Archetype removal S136. Projecao auditorio 10m S142. Motion com proposito S139. QA visual screenshot S138. QA output WHAT/WHY/PROPOSAL/GUARANTEE S139. Navy card ΣN hero S139. Fresh eyes S140. Call D S140. Temp editorial 1.0 S141.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro (LLM).
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- KBP-07 anti-workaround, KBP-08 anti-substituicao, KBP-09 anti-routing, KBP-10 anti-destructive, KBP-11 Gemini thinking pool, KBP-12 structured output, **KBP-13 claim-without-verification**, **KBP-14 velocity-over-comprehension**, **KBP-15 write-race-via-external-script**.
- **Verificar atribuicao via `git log -S '<literal>'` antes de afirmar origem** (KBP-13).
- **Solo-audit findings = ~50% provisional.** Verificar source-of-truth antes de agir (KBP-13 mandatorio).
- **Scripts externos NAO modificam settings.local.json** (KBP-15). Edit/Write tool ou nada.
- MCP gate + Research gate: hooks force "ask" antes de MCP/research calls.
- MCP freeze ate 2026-04-14 (9 frozen; PubMed/SCite/Consensus ativos).
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever sem instrucao EXPLICITA.
- Gemini FPs conhecidos: css_cascade e failsafes/@media print.
- Benchmark `pre-reading-heterogeneidade.html` = READ-ONLY.
- **Hook bug pattern (S152):** PostToolUse hook que parseia `tool_input.command`/`tool_response`: NAO usar `sed -n 'Np'`; usar `tr.interrupted`.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 + Gemini 3.1 Pro (×3) + Codex (×2) | S155 2026-04-11
