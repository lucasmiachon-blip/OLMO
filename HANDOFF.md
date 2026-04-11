# HANDOFF - Proxima Sessao

> Sessao 150 | 2026-04-10
> Foco: HTML improvements + PMID clickable (mechanical fixes)

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (**15 slides** metanalise).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 12.** **Skills: 20.** **Memory: 20/20.**

## S150 DONE

- Audit read-only completo dos 14 evidence HTMLs → `docs/evidence-html-audit-S150.md` (matrix, prioridades, suspicious PMIDs)
- **Mechanical fixes (7 edits, 0 risco semantico):**
  - `s-checkpoint-1.html:183` — bug HTML `</td></li>` orfao em `<ol><li>` removido
  - `s-checkpoint-1.html:93,115` — DOI labels (texto visivel) → `DOI` (Ray 2009 + ACCORD)
  - `s-objetivos.html` — 13 URLs PubMed: trailing slash removido + `target="_blank"` adicionado (replace_all)
  - `s-ancora.html:88` — DOI label → `DOI` (Valgimigli)
  - `s-forest-plot.html:91,140` — DOI labels → `DOI` (Vaduganathan + Ebrahimi)
- Forest plot slides (2 novos) pendentes de Lucas — Ebrahimi/Samuel/Li + Vaduganathan (inalterado)

## P0 — Pendencias com coordenadas exatas (proximo agent executa direto)

### Editorial decisions (Lucas tem que decidir primeiro)
- **`s-pico.html`**: 6 PMIDs em prosa narrativa (linhas 171, 176, 181-186, 232-236) — violacao regra "PMID apenas em `#referencias`". Decisao: mover para `#referencias`, remover, ou manter como excecao? CSS `.ref-pmid font-size: .82rem` vs benchmark `.85rem`.
- **`s-importancia.html`**: Zero PMIDs no arquivo. Cita Borenstein 2021, Kastrati & Ioannidis 2024, Yusuf 1985, Lau 1992 so por nome. Adicionar PMIDs? (proibido sem PubMed MCP)
- **`pre-reading-forest-plot-vies.html`**: Zero PMIDs (pre-reading pedagogico). Ok manter sem refs?

### Fase 3 — PubMed MCP verification (PMIDs suspeitos do audit)
- **s-checkpoint-1.html:183-185** — 3 PMIDs sem badge VERIFIED (21366473, 26822326, 31167051). PubMed MCP check antes de adicionar `<span class="v">VERIFIED</span>`.
- **Nasr 29713212** (s-objetivos:285) — PMID ok mas dados forest plot 44%→76% nao no abstract (flag S149). Decisao: remover citacao, manter flag, ou deep-read full paper?
- **s-pico.html** 6 PMIDs prosa: Goldkuhle 37146659, Guyatt 21802903, Guyatt 40393729, Colunga-Lozano 41207400, Huang 17238363, Adie 28234219 — nenhum verificado PubMed MCP.

## P1 — CSS benchmark adoption (13 arquivos)

Meta: adicionar classes do benchmark (`pre-reading-heterogeneidade.html` linhas 10-80) onde faltam.
- Arquivos sem `.ref-pmid`/`.v`/`.c` completos: `blueprint.html`, `meta-narrativa.html`, `pre-reading-forest-plot-vies.html` (checar com audit)
- `s-pico.html` tem CSS proprio S144 (.ref-pmid .82rem) — reconciliar com benchmark .85rem ou manter diferenca intencional
- **NAO tocar** `pre-reading-heterogeneidade.html` (benchmark read-only)

## P2 — A11y baseline (transversal)

Do audit: ~86 `<th>` sem `scope="col"`, ~104 links `target="_blank"` sem `rel="noopener noreferrer"`. Low risk, high volume — batch add em 1 commit por arquivo.

## P3 — Forest plot slides (2 novos)

- Slide A: Vaduganathan 2022 (SGLT2i/IC, PMID 36041474 VERIFIED) — anatomia basica
- Slide B: Colchicina — 3 MAs candidatas (Ebrahimi 2025 Cochrane CANDIDATE + Samuel 2025 EHJ 40314333 VERIFIED + Li 2026 AJCD 40889093 VERIFIED)
- Pendente: Lucas escolhe combo. Evidence: `forest-plot-candidates.html` (9 candidatos, 6 combos).

## P4 — /insights trend watch

S141: rolling averages corrections 0.862→1.128, kbp 0.254→0.32. Se KBP/session > 0.5 por 3 sessoes: investigar regressao.

## BACKLOG (pos-deadline)

| # | Item | Detalhe |
|---|------|---------|
| 1 | ~~Refatorar 5 evidence HTMLs~~ DONE S148 | CSS benchmark + DOIs clicaveis aplicados. s-pico separado (CSS proprio S144). |
| 2 | Pernas pendentes (research) | Perna 2 (evidence-researcher), Perna 6 (NLM: requer login) |
| 3 | Adversarial deferred: M-01, M-10 | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 4 | Hook/config system review | JSON adequado? YAGNI audit |
| 5 | Pipeline DAG end-to-end | cowork→NLM→wiki |
| 6 | medicina-clinica stubs | 4 concepts stub/low aguardam Cowork harvest |
| 7 | Skill de slides consolidada | Usar skill-creator para criar skill nova |

## DECISOES ATIVAS

- **Living HTML = source of truth = SINTESE CURADA.**
- **Evidence CSS benchmark S148:** `pre-reading-heterogeneidade.html` = padrao-ouro visual. Aplicado a 5 evidence HTMLs.
- **Estilo narrativo S119:** foco em metodologia, exemplos pontuais.
- **Dual creation S135:** Gemini + Claude geram mockups HTML independentes. NUNCA Claude reescreve Gemini.
- **Pedagogia adultos S135:** sem formulas em slides (1/√N proibido), numeros concretos SIM.
- **Speaker notes S135:** vao para evidence HTML, NAO aside no slide.
- **Archetype removal S136:** campo archetype removido do manifest. Liberdade artistica.
- **Projecao S142:** Design target = auditorio 10m projetor. Prompts atualizados (TV 55" 6m removido).
- **Motion S139:** animacoes com PROPOSITO pedagogico (retencao, carga cognitiva, varredura). Sem proposito = nao animar.
- **QA visual S138:** analise multimodal obrigatoria (screenshot como imagem), nao apenas codigo.
- **QA output S139:** Gemini deve reportar WHAT/WHY/PROPOSAL/GUARANTEE. Sem notas subjetivas.
- **Navy card SigmaN = hero S139:** Lucas: "a melhor parte eh o box com o sigma e o N". Tudo deriva dele.
- **Fresh eyes S140:** Gemini NAO recebe scores anteriores. Avaliacao independente. Known FPs injetados separadamente.
- **Call D S140:** 4th call anti-sycophancy. Audita 3 calls, recalibra scores, produz priority actions. Validado S142 (6 ceiling violations, 1 FP detectado, custo $0.026).
- **Temp editorial 1.0 S141:** Aplica-se a TODAS calls (incluindo Call D). Testado S71.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- KBP-07 anti-workaround, KBP-08 anti-substituicao, KBP-09 anti-routing, KBP-10 anti-destructive, KBP-11 Gemini thinking pool, KBP-12 structured output.
- MCP gate + Research gate: hooks force "ask" antes de MCP/research calls.
- MCP freeze ate 2026-04-14 (9 frozen; PubMed/SCite/Consensus ativos). PubMed MCP reconectou S149.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever h2 sem instrucao EXPLICITA e inequivoca.
- Gemini FPs conhecidos: css_cascade (2-6/10 across slides) e failsafes/@media print — FPs persistentes, Call D confirma.
- **QA Preflight S145:** analise visual SEPARADA do codigo (2 fases). Notas numericas sao aleatorias — foco em WHAT/WHY/PROPOSAL.
- Auto-dream: loop funcionando (S142 dream ran, no new signal).
- Secrets audit manual: nenhum secret verificado no git history. trufflehog/gitleaks nao instalados — scan definitivo pendente.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S150 2026-04-10
