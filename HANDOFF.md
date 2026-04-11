# HANDOFF - Proxima Sessao

> Sessao 151 | 2026-04-10
> Foco: HTML + REFERENCES (Fase A PubMed verification → B edits → C CSS → D A11y batch)

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (**15 slides** metanalise).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 12.** **Skills: 20.** **Memory: 20/20.**

## S151 DONE (resumo — detalhes no CHANGELOG)

- Fase A: 15 PMIDs verificados via NCBI eutils (13 V, 1 BOOK, 1 INVALID) → `docs/pmid-verification-S151.md`
- Fase B: s-pico (PMIDs prose→refs), s-importancia (cria #referencias + 4 refs), s-objetivos (Nasr flag resolved). B3 s-checkpoint-1 deferido (frozen slide).
- Fase C: blueprint/meta-narrativa/pre-reading-forest-plot-vies recebem CSS `.ref-pmid/.v/.c`
- Fase D: 124 links com `rel="noopener noreferrer"` (D.1) + 75/87 `<th scope="col">` (D.2)
- 7 commits atomicos (2fc965e → 5984337)

## P0 — Pendencias com coordenadas exatas

### Forest plot slides (2 novos — Lucas decide combo)
- **Slide A:** Vaduganathan 2022 (SGLT2i/IC, PMID 36041474 VERIFIED) — anatomia basica
- **Slide B:** Colchicina — 3 MAs candidatas (Ebrahimi 2025 Cochrane CANDIDATE + Samuel 2025 EHJ 40314333 VERIFIED + Li 2026 AJCD 40889093 VERIFIED)
- Evidence: `forest-plot-candidates.html` (9 candidatos, 6 combos)

### B3 deferido (slide frozen)
- **s-checkpoint-1.html:183-185** — 3 PMIDs ACCORD/VADT VERIFIED via Fase A mas badges `.v` nao adicionados. Retomar se slide sair do freeze.

## P1 — A11y gaps residuais (low priority)

- **Benchmark `pre-reading-heterogeneidade.html`:** 14 links `target="_blank"` sem `rel="noopener"` + 3 `<th>` sem scope — skipped intencionalmente em S151 D para preservar invariante read-only. Requer decisao explicita do Lucas para tocar.
- **forest-plot-candidates.html:** 9 `<th colspan="2">` sao label rows (nao column headers). Fix semantico caso-a-caso pendente — nao batch.

## P2 — Benchmark evolution (backlog)

- Promover `.v` e `.c` classes ao benchmark `pre-reading-heterogeneidade.html`. Atualmente o benchmark so tem `.ref-pmid`; o pattern completo (`.v/.c/.book`) originou em `forest-plot-candidates.html` S146 (commit ea434e7). Tornar o benchmark um superset real exigiria adicionar essas 3 classes — decisao do Lucas: "pode ser adicionado ao benchmark posteriormente".

## P3 — /insights trend watch

S141: rolling averages corrections 0.862→1.128, kbp 0.254→0.32. Se KBP/session > 0.5 por 3 sessoes: investigar regressao. S151 teve 1 KBP-07 event (attribution-without-verification) — Lucas corrigiu.

## BACKLOG (pos-deadline)

| # | Item | Detalhe |
|---|------|---------|
| 1 | Pernas pendentes (research) | Perna 2 (evidence-researcher), Perna 6 (NLM: requer login) |
| 2 | Adversarial deferred: M-01, M-10 | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 3 | Hook/config system review | JSON adequado? YAGNI audit |
| 4 | Pipeline DAG end-to-end | cowork→NLM→wiki |
| 5 | medicina-clinica stubs | 4 concepts stub/low aguardam Cowork harvest |
| 6 | Skill de slides consolidada | Usar skill-creator para criar skill nova |

## DECISOES ATIVAS

- **Living HTML = source of truth = SINTESE CURADA.**
- **Evidence CSS benchmark S148:** `pre-reading-heterogeneidade.html` = padrao-ouro visual. S151 Fase C aplicou mais 3 arquivos (blueprint, meta-narrativa, pre-reading-forest-plot-vies).
- **Regra PMID em #referencias S151:** PMID em prosa narrativa = violacao. Mover para `<section id="referencias">` clicaveis. Excecao: books sem PMID tagged `<span class="book">BOOK</span>` + ISBN.
- **Estilo narrativo S119:** foco em metodologia, exemplos pontuais.
- **Dual creation S135:** Gemini + Claude geram mockups HTML independentes. NUNCA Claude reescreve Gemini.
- **Pedagogia adultos S135:** sem formulas em slides (1/√N proibido), numeros concretos SIM.
- **Speaker notes S135:** vao para evidence HTML, NAO aside no slide.
- **Archetype removal S136:** campo archetype removido do manifest. Liberdade artistica.
- **Projecao S142:** Design target = auditorio 10m projetor.
- **Motion S139:** animacoes com PROPOSITO pedagogico.
- **QA visual S138:** analise multimodal obrigatoria (screenshot como imagem), nao apenas codigo.
- **QA output S139:** Gemini deve reportar WHAT/WHY/PROPOSAL/GUARANTEE.
- **Navy card SigmaN = hero S139.**
- **Fresh eyes S140:** Gemini NAO recebe scores anteriores.
- **Call D S140:** 4th call anti-sycophancy.
- **Temp editorial 1.0 S141:** Aplica-se a TODAS calls.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro (LLM).
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- KBP-07 anti-workaround, KBP-08 anti-substituicao, KBP-09 anti-routing, KBP-10 anti-destructive, KBP-11 Gemini thinking pool, KBP-12 structured output.
- **Verificar atribuicao via `git log -S '<literal>'` antes de afirmar origem** (S151 KBP-07 event: attribuí `.v/.c` a s-checkpoint-1 sem verificar; era `forest-plot-candidates.html` S146 ea434e7).
- MCP gate + Research gate: hooks force "ask" antes de MCP/research calls.
- MCP freeze ate 2026-04-14 (9 frozen; PubMed/SCite/Consensus ativos). PubMed MCP schemas nao indexados no tool pool em S151 — fallback NCBI eutils via WebFetch funcionou.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever h2 sem instrucao EXPLICITA.
- Gemini FPs conhecidos: css_cascade e failsafes/@media print.
- Benchmark `pre-reading-heterogeneidade.html` = READ-ONLY (preservado tambem em S151 D — gap de 14 links + 3 th intencional).
- Secrets audit manual pendente (trufflehog/gitleaks nao instalados).

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S151 2026-04-10
