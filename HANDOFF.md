# HANDOFF - Proxima Sessao

> Sessao 147 | 2026-04-10
> Foco: TBD

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (**15 slides** metanalise — s-forest-plot removido S146).
**Agentes: 10.** **Hooks: 38 registrations.** **Rules: 11**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 12.**
**Skills: 20.** **Memory: 20/20 (0 slots livre).** **.claudeignore: criado S128.**

## P0 — Forest plot slides (2 novos) + QA restantes

**s-forest-plot removido S146.** Sera substituido por 2 slides com forest plot REAL (crop + zoom + animacao).
- **Slide A:** Vaduganathan 2022 (SGLT2i/IC, Lancet, PMID 36041474 VERIFIED). 5 estudos, anatomia basica.
- **Slide B:** Ebrahimi 2025 (Colchicina, Cochrane, PMID CANDIDATE). 12 estudos, I² 51%, leitura critica.
- Evidence HTML criado: `evidence/s-forest-plot.html` + `evidence/forest-plot-candidates.html` (6+1 candidatos).
- **Pendente:** Lucas le os trials e confirma combo. Verificar PMID Ebrahimi + CLEAR SYNERGY. Crop forest plots.

**s-pico: DONE (R12, --term teal token, punchline containment).**
**s-importancia: DONE.** **s-contrato: DONE.**
**Proximo QA:** s-absoluto (ou proximo LINT-PASS apos forest plot slides criados).

## P1 — /insights trend watch

S141 insights: rolling averages subiram (corrections 0.862->1.128, kbp 0.254->0.32).
Observar S142-S146. Se KBP/session > 0.5 por 3 sessoes: investigar regressao.

## P2 — css_cascade FP exclusion DONE

Exclusao explicita adicionada ao prompt Call B (gate4-call-b-uxcode.md) S146. Secao "FALSOS POSITIVOS CONFIRMADOS".

## BACKLOG (pos-deadline)

| # | Item | Detalhe |
|---|------|---------|
| 1 | Refatorar 5 evidence HTMLs | s-hook, s-rs-vs-ma, s-objetivos, s-checkpoint-1, s-ancora (s-pico DONE S144) |
| 2 | Pernas pendentes (research) | Perna 2 (evidence-researcher), Perna 6 (NLM: requer login) |
| 3 | Adversarial deferred: M-01, M-10 | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 4 | Hook/config system review | JSON adequado? YAGNI audit |
| 5 | Pipeline DAG end-to-end | cowork→NLM→wiki |
| 6 | medicina-clinica stubs | 4 concepts stub/low aguardam Cowork harvest |
| 7 | Skill de slides consolidada | Usar skill-creator para criar skill nova |

## DECISOES ATIVAS

- **Living HTML = source of truth = SINTESE CURADA.**
- **Evidence benchmark S131:** TODOS evidence HTMLs = estrutura pre-reading-heterogeneidade.
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
- MCP freeze ate 2026-04-14. PubMed session expirou S129.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever h2 sem instrucao EXPLICITA e inequivoca.
- Gemini FPs conhecidos: css_cascade (2-6/10 across slides) e failsafes/@media print — FPs persistentes, Call D confirma.
- **QA Preflight S145:** analise visual SEPARADA do codigo (2 fases). Notas numericas sao aleatorias — foco em WHAT/WHY/PROPOSAL.
- Auto-dream: loop funcionando (S142 dream ran, no new signal).
- Secrets audit manual: nenhum secret verificado no git history. trufflehog/gitleaks nao instalados — scan definitivo pendente.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S146 2026-04-10
