# HANDOFF - Proxima Sessao

> Sessao 152 | 2026-04-11
> Foco: Infra — /insights S151 queue (P001/P002/P003/P004) + hook bug audit
> **Proxima sessao = INFRA continuada (hooks + outros itens infra). Slides DEPOIS.**

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (**15 slides** metanalise).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 13.** **Skills: 20.** **Memory: 20/20.**

## S152 DONE (resumo — detalhes no CHANGELOG)

- **Fase A — diagnose success-capture hook:** root cause encontrada via debug instrumentation em commit trivial (2f35e7e). Bug: `console.log(ti.command)` preservava `\n` reais; `sed -n '2p'` pegava linha 2 do comando em vez do exit_code. Fix aplicado (4cbbd49): strip `[\r\n]+` do command + substituir `tool_response.exit_code` (nao existe no schema Bash) por `tr.interrupted===true`. Validado end-to-end.
- **Fase B1 — KBP-13 + anti-drift §Verification (e2f1cc2):** append KBP-13 "Factual Claim Without Verification" (3/3 corrections S151 eram subtipos — state drift, intent assumption, historical attribution). Anti-drift ganhou 3 bullets novos: claim-about-state, claim-about-history, claim-about-intent.
- **Fase B2 — scope-shrink symmetry (e2f1cc2):** novo bullet em anti-drift §Scope discipline. Silent skips de parte do plano = drift na direcao oposta de creep.
- **Fase C1 — plans lifecycle (e2f1cc2):** session-hygiene §Artifact cleanup ganhou protocolo `.claude/plans/` com archive SXXX- prefix, default=keep, decisoes por arquivo.
- **Preventive fix build-monitor.sh (e2f1cc2):** mesmo bug pattern que success-capture. Patch equivalente aplicado.
- **Fase C2 — listagem de 18 orphan plans:** ver P0 abaixo.

4 commits: 2f35e7e (heartbeat+debug) → 4cbbd49 (success-capture fix) → e2f1cc2 (rules + build-monitor) → (wrap a seguir)

## P0 — Triage 18 orphan plans (Lucas decide individualmente, default=keep)

Todos parecem ser plans consumidos de sessoes passadas. Proposta: archive em `.claude/plans/archive/` com prefixo SXXX-. **NUNCA batch-delete** (KBP-10). Lucas decide arquivo-por-arquivo.

| Plan file | Title | Sessao provavel | Proposta |
|-----------|-------|-----------------|----------|
| cached-snuggling-donut.md | Refactor s-objetivos | ? | archive |
| compiled-sleeping-raven-agent-a97482049cefea20a.md | Dream S142 Consolidation | S142 | archive |
| compiled-sleeping-raven.md | R14 Call D — s-importancia | ? | archive |
| dazzling-skipping-koala.md | Adversarial Review — Research Pipeline I/O | ~S141 | archive |
| deep-mixing-badger.md | Build s-importancia (Dual Creation) | S135 | archive |
| floating-gathering-starfish.md | Melhorar s-importancia | ? | archive |
| greedy-toasting-quasar.md | S138 QA s-importancia H2 + Preflight | S138 | archive |
| idempotent-orbiting-hinton.md | Verificacao CANDIDATE PMIDs | ~S149 | archive |
| magical-growing-harbor.md | **S151 HTML + REFERENCES** | S151 | archive |
| nested-wibbling-pearl.md | S150 HTML improvements + PMID clickable | S150 | archive |
| precious-inventing-petal.md | QA s-importancia S137 | S137 | archive |
| purrfect-spinning-barto.md | QA Gemini R13 s-importancia | ? | archive |
| resilient-napping-willow.md | Refactor Evidence HTMLs DOIs | ~S147-148 | archive |
| steady-snuggling-hammock.md | s-pico Evidence Benchmark + RS title | ? | archive |
| ticklish-booping-lemon.md | s-pico QA Final | ? | archive |
| tingly-crafting-codd.md | S136 build slides + poda | S136 | archive |
| transient-coalescing-balloon.md | Evidence HTML s-contrato | ? | archive |
| vast-shimmying-toast.md | QA s-pico S145 | S145 | archive |

Comando ref (Lucas executa com aprovacao): `mkdir -p .claude/plans/archive && mv .claude/plans/<plan>.md .claude/plans/archive/S<NNN>-<plan>.md`.

## P0 — Forest plot slides (do HANDOFF anterior, ainda pendente)

### Slides novos (2 — Lucas decide combo)
- **Slide A:** Vaduganathan 2022 (SGLT2i/IC, PMID 36041474 VERIFIED) — anatomia basica
- **Slide B:** Colchicina — 3 MAs candidatas (Ebrahimi 2025 Cochrane CANDIDATE + Samuel 2025 EHJ 40314333 VERIFIED + Li 2026 AJCD 40889093 VERIFIED)
- Evidence: `forest-plot-candidates.html` (9 candidatos, 6 combos)

### B3 deferido (slide frozen)
- **s-checkpoint-1.html:183-185** — 3 PMIDs ACCORD/VADT VERIFIED mas badges `.v` nao adicionados. Retomar se slide sair do freeze.

## P1 — A11y gaps residuais (low priority, do HANDOFF anterior)

- **Benchmark `pre-reading-heterogeneidade.html`:** 14 links `target="_blank"` sem `rel="noopener"` + 3 `<th>` sem scope — skipped para preservar invariante read-only. Requer decisao explicita.
- **forest-plot-candidates.html:** 9 `<th colspan="2">` sao label rows. Fix semantico caso-a-caso pendente.

## P2 — /insights S151 queue residual

**Status:** P001 (KBP-13) ✅, P002 (success-capture) ✅, P003 (plans lifecycle) ✅, P004 (scope-shrink) ✅. **Deferidos:** P005 (plan reference-type column em research/SKILL.md) + P006 (plan pre-flight tool availability hook).

**Verdict:** IMPROVING — corrections_5avg 1.128→0.912 (↓19%), kbp_5avg 0.32→0.154 (↓52%). Report completo: `.claude/skills/insights/references/latest-report.md`.

## P3 — Proxima sessao infra (continuacao)

Lucas decidiu S152: **proxima sessao e mais infra (hooks + outros)**, depois volta para slides (forest plot Vaduganathan + colchicine).

Escopo infra proximo:
1. **Hook/config system review** (flagged no BACKLOG #3 + Lucas "JSON → formato menos verboso + safer" S152): YAGNI audit + explorar alternativas para configs (`settings.local.json`, `failure-registry.json`) e logs (`.jsonl`). Candidatos: TOML (configs), text append (logs), YAML. Design + prototipo. Pode gerar migrations.
2. **Hook audit re-sweep:** search S152 validou success-capture + build-monitor; outros 13 hooks auditados clean. Re-sweep se adicionarmos novos hooks ou se o review acima mudar o schema esperado.
3. **P005 + P006 (do /insights S151 backlog — ambos exigem design):**
   - P005 add coluna `type` em research/SKILL.md Step 2 (paper|book|guideline|preprint|web + fallback ID). Rapido (2 min) mas espera sessao infra.
   - P006 pre-flight tool availability — **proposta original (hook parseia plan + ToolSearch) e invalida**: hooks nao podem chamar ToolSearch (rodam fora do contexto do agente). Re-escopar como Step 1.5 em research/SKILL.md (agente checa tools antes de cada Perna), OU static allowlist mantida manualmente, OU SessionStart context injection. Requer design session.
4. **Triage 18 orphan plans** (listados em P0 acima). Archive per-file apos decisao Lucas.

**Quando infra estiver fechado → voltar para slides** (forest plot Vaduganathan + colchicine combo, ver P0 abaixo).

## BACKLOG (pos-deadline)

| # | Item | Detalhe |
|---|------|---------|
| 1 | Pernas pendentes (research) | Perna 2 (evidence-researcher), Perna 6 (NLM: requer login) |
| 2 | Adversarial deferred: M-01, M-10 | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 3 | Hook/config system review | JSON adequado? YAGNI audit. ✱ Lucas flagged S152 ✱ |
| 4 | Pipeline DAG end-to-end | cowork→NLM→wiki |
| 5 | medicina-clinica stubs | 4 concepts stub/low aguardam Cowork harvest |
| 6 | Skill de slides consolidada | Usar skill-creator para criar skill nova |
| 7 | P005: plan template reference-type | Add coluna `type` em research/SKILL.md (paper/book/guideline/preprint/web + ISBN/DOI/PMID/URL). Quick (2 min) na proxima sessao infra. |
| 8 | P006: plan pre-flight tool availability | **Proposta original invalida** (hooks nao chamam ToolSearch). Re-design: Step 1.5 em research/SKILL.md ou static allowlist. Requer design session. |

## DECISOES ATIVAS

- **Living HTML = source of truth = SINTESE CURADA.**
- **Evidence CSS benchmark S148:** `pre-reading-heterogeneidade.html` = padrao-ouro visual.
- **Regra PMID em #referencias S151:** PMID em prosa = violacao. Mover para `<section id="referencias">` clicaveis. Excecao: books → `<span class="book">BOOK</span>` + ISBN.
- **KBP-13 (S152):** antes de afirmar fato sobre state/history/intent, verificar via grep / git log -S / leitura do header. Memoria decay-biased.
- **Scope-shrink symmetry (S152):** skip silencioso de parte de plano = drift. Report obrigatorio em HANDOFF/CHANGELOG.
- **Plans lifecycle (S152):** `.claude/plans/` consumidos → `archive/SXXX-<name>.md`. Per-file decision, default=keep.
- **Estilo narrativo S119:** foco em metodologia.
- **Dual creation S135:** Gemini + Claude mockups independentes.
- **Pedagogia adultos S135:** sem formulas, numeros concretos.
- **Speaker notes S135:** em evidence HTML.
- **Archetype removal S136.**
- **Projecao S142:** auditorio 10m.
- **Motion S139:** com proposito pedagogico.
- **QA visual S138:** screenshot como imagem.
- **QA output S139:** WHAT/WHY/PROPOSAL/GUARANTEE.
- **Navy card SigmaN = hero S139.**
- **Fresh eyes S140:** sem scores anteriores.
- **Call D S140:** 4th call anti-sycophancy.
- **Temp editorial 1.0 S141.**

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro (LLM).
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- KBP-07 anti-workaround, KBP-08 anti-substituicao, KBP-09 anti-routing, KBP-10 anti-destructive, KBP-11 Gemini thinking pool, KBP-12 structured output, **KBP-13 claim-without-verification**.
- **Verificar atribuicao via `git log -S '<literal>'` antes de afirmar origem** (KBP-13).
- MCP gate + Research gate: hooks force "ask" antes de MCP/research calls.
- MCP freeze ate 2026-04-14 (9 frozen; PubMed/SCite/Consensus ativos). PubMed MCP schemas nao indexados no tool pool; fallback NCBI eutils funcionou.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever sem instrucao EXPLICITA.
- Gemini FPs conhecidos: css_cascade e failsafes/@media print.
- Benchmark `pre-reading-heterogeneidade.html` = READ-ONLY.
- Secrets audit manual pendente (trufflehog/gitleaks nao instalados).
- **Hook bug pattern (S152):** se criar PostToolUse hook que parseia `tool_input.command` ou `tool_response`, NAO usar `sed -n 'Np'` para pegar campos; NAO confiar em `tool_response.exit_code` (nao existe para Bash — usar `tr.interrupted`). Ver `hooks/success-capture.sh` pos-fix como referencia.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S152 2026-04-11
