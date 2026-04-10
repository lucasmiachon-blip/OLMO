# HANDOFF - Proxima Sessao

> Sessao 143 | 2026-04-10
> Foco: QA s-contrato

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (16 slides metanalise).
**Agentes: 10.** **Hooks: 38 registrations.** **Rules: 11**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 10.**
**Skills: 20.** **Memory: 20/20.** **.claudeignore: criado S128.**

## P0 — QA slides (11 LINT-PASS restantes)

**s-importancia: DONE (R14, adjusted 7.0/10).** Primeiro slide QA completo com Call D.
**s-contrato: DONE (R11, adjusted 5.9/10 — 6 FPs, real ~7.0/10).** Evidence HTML criado. Click-reveal 2 cards. Skill font 18→20px.

Lucas decide proximo slide. Pipeline: 1 slide/vez, 4 calls (A+B+C+D).
Prompts atualizados S142: design target = **auditorio 10m projetor** (nao TV 55" 6m).

## P1 — /insights trend watch

S141 insights: rolling averages subiram (corrections 0.862->1.128, kbp 0.254->0.32).
Observar S142-S144. Se KBP/session > 0.5 por 3 sessoes: investigar regressao.

## P2 — css_cascade FP exclusion

R14 confirmou css_cascade como FP persistente (2/10 — failsafe rules corretamente scoped mas Gemini nao distingue condicional de global). Candidato para exclusao explicita no prompt de Call B.

## BACKLOG (pos-deadline)

| # | Item | Detalhe |
|---|------|---------|
| 1 | Refatorar 6 evidence HTMLs | s-hook, s-pico, s-rs-vs-ma, s-objetivos, s-checkpoint-1, s-ancora |
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
- KBP-07 anti-workaround, KBP-08 anti-substituicao, KBP-09 anti-routing, KBP-10 anti-destructive.
- MCP gate + Research gate: hooks force "ask" antes de MCP/research calls.
- MCP freeze ate 2026-04-14. PubMed session expirou S129.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever h2 sem instrucao EXPLICITA e inequivoca.
- Gemini FPs conhecidos: css_cascade (2/10 R14) — failsafe rules corretamente scoped mas Gemini confunde condicional com global leak. failsafes corrigido (3→8/10 com FP injection).
- Auto-dream: loop funcionando (S142 dream ran, no new signal).
- Secrets audit manual: nenhum secret verificado no git history. trufflehog/gitleaks nao instalados — scan definitivo pendente.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S142 2026-04-10
