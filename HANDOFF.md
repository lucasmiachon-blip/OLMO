# HANDOFF - Proxima Sessao

> Sessao 153 | 2026-04-11
> Foco: INFRA_LEVE — planning-only (contexto cheio antes da execucao)
> **Proxima sessao (S154) = LER O PLANO E EXECUTAR.** Plano pronto em `.claude/plans/sunny-plotting-fountain.md`.

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (**15 slides** metanalise, s-checkpoint-1 ainda no repo mas ja fora do deck ativo via comment S107).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 13.** **Skills: 20.** **Memory: 20/20.**

## P0 — Executar o plano S153 (proxima sessao)

**Abrir primeiro**: `.claude/plans/sunny-plotting-fountain.md`. Aprovado por Lucas. Contem mapa exaustivo + decisoes pre-resolvidas + ordem de execucao.

### Sumario executivo do plano (3 scopes)

- **Scope A — Remover s-checkpoint-1** (principal work):
  - 7 arquivos canonicos: mv slides/03-checkpoint-1.html + evidence/s-checkpoint-1.html + references/research-accord-valgimigli.md para `_archive/` respectivos; delete bloco `#s-checkpoint-1`/`.ck1-*` em metanalise.css (~142 linhas); delete factory em slide-registry.js (58 linhas); delete entry comentada em _manifest.js (2 linhas); `rm -r` qa-screenshots/s-checkpoint-1/ (gitignored, aprovado).
  - 11 cross-refs ativas a atualizar: CLAUDE.md, HANDOFF.md (metanalise), meta-narrativa.html, blueprint.html, s-pico.html, s-rs-vs-ma.html, 04-rs-vs-ma.html speaker note.
  - Verificacao: lint PASS + build PASS + grep-zero em `content/aulas/metanalise/**` fora de `_archive/` e historicos.
- **Scope B — Triage 18 orphan plans** (per-file, KBP-10, Lucas aprova cada um): archive em `.claude/plans/archive/` com prefixo SXXX-.
- **Scope C — P005 quick win**: `research/SKILL.md` Step 2 ganha coluna `type` + fallback ID. Fecha BACKLOG #7.

### Ordem de execucao (do plano §Sequencia)

1. Scope C (2 min, commit isolado)
2. Scope A (maior chunk, commit dedicado, validar build)
3. Scope B (per-file approval, commit bundled)
4. Wrap: HANDOFF atualizado → proximo foco slides (forest plot Vaduganathan + colchicine), CHANGELOG S153 entry final, este plano → `.claude/plans/archive/S153-sunny-plotting-fountain.md`

### Descobertas criticas ja incorporadas no plano

- `.checkpoint-*` classes compartilhadas com checkpoint-2 (PRESERVAR). Apenas `.ck1-*` exclusivas (REMOVER).
- ACCORD em `forest-plot-candidates.html:351` = contexto Stead 2023, NAO TOCAR.
- s-ancora nao referencia `research-accord-valgimigli.md` → archive inteiro seguro.
- Historico (CHANGELOG, KBP-13, audits S150/S151, plans antigos) = via negativa, NAO EDITAR.

## P1 — Forest plot slides (aguardando fim da infra)

### Slides novos (2 — Lucas decide combo)
- **Slide A:** Vaduganathan 2022 (SGLT2i/IC, PMID 36041474 VERIFIED) — anatomia basica
- **Slide B:** Colchicina — 3 MAs candidatas (Ebrahimi 2025 Cochrane CANDIDATE + Samuel 2025 EHJ 40314333 VERIFIED + Li 2026 AJCD 40889093 VERIFIED)
- Evidence: `forest-plot-candidates.html` (9 candidatos, 6 combos)

## P2 — A11y gaps residuais (low priority)

- **Benchmark `pre-reading-heterogeneidade.html`:** 14 links `target="_blank"` sem `rel="noopener"` + 3 `<th>` sem scope — skipped para preservar invariante read-only. Requer decisao explicita.
- **forest-plot-candidates.html:** 9 `<th colspan="2">` sao label rows. Fix semantico caso-a-caso pendente.

## BACKLOG (pos-deadline — canal persistente self-improvement)

| # | Item | Detalhe |
|---|------|---------|
| 1 | Pernas pendentes (research) | Perna 2 (evidence-researcher), Perna 6 (NLM: requer login) |
| 2 | Adversarial deferred: M-01, M-10 | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 3 | Hook/config system review | JSON adequado? YAGNI audit. ✱ Lucas flagged S152 ✱ → deferred em S153 plano §D1 |
| 4 | Pipeline DAG end-to-end | cowork→NLM→wiki |
| 5 | medicina-clinica stubs | 4 concepts stub/low aguardam Cowork harvest |
| 6 | Skill de slides consolidada | Usar skill-creator para criar skill nova |
| 7 | ~~P005: plan template reference-type~~ | **→ Scope C do plano S153** (nao remover daqui ate execucao) |
| 8 | P006: plan pre-flight tool availability | Proposta original invalida (hooks nao chamam ToolSearch). Re-design: Step 1.5 em research/SKILL.md ou static allowlist. Requer design session. → deferred em S153 plano §D3 |

**Wrap checklist S154**: ao terminar execucao do plano, remover BACKLOG #7 (P005 completado), verificar #3 e #8 continuam la, renumerar sequencia.

## DECISOES ATIVAS

- **Living HTML = source of truth = SINTESE CURADA.**
- **Evidence CSS benchmark S148:** `pre-reading-heterogeneidade.html` = padrao-ouro visual.
- **Regra PMID em #referencias S151:** PMID em prosa = violacao. Mover para `<section id="referencias">` clicaveis. Excecao: books → `<span class="book">BOOK</span>` + ISBN.
- **KBP-13 (S152):** antes de afirmar fato sobre state/history/intent, verificar via grep / git log -S / leitura do header. Memoria decay-biased.
- **Scope-shrink symmetry (S152):** skip silencioso de parte de plano = drift. Report obrigatorio em HANDOFF/CHANGELOG.
- **Plans lifecycle (S152):** `.claude/plans/` consumidos → `archive/SXXX-<name>.md`. Per-file decision, default=keep.
- **s-checkpoint-1 fora do escopo (S153):** slide nao retorna mais. Plano S153 executa a remocao completa.
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
- MCP freeze ate 2026-04-14 (9 frozen; PubMed/SCite/Consensus ativos).
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever sem instrucao EXPLICITA.
- Gemini FPs conhecidos: css_cascade e failsafes/@media print.
- Benchmark `pre-reading-heterogeneidade.html` = READ-ONLY.
- **Hook bug pattern (S152):** se criar PostToolUse hook que parseia `tool_input.command` ou `tool_response`, NAO usar `sed -n 'Np'` para pegar campos; NAO confiar em `tool_response.exit_code` (nao existe para Bash — usar `tr.interrupted`). Ver `hooks/success-capture.sh` pos-fix como referencia.
- **Plan S153 approved**: Scope A tem KBP-10 hard-block bypass autorizado para `rm -r qa-screenshots/s-checkpoint-1/` (gitignored, fora de `.claude/workers/`). Escopo unico, nao generalizar.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S153 2026-04-11
