# HANDOFF - Proxima Sessao

> Sessao 142 | 2026-04-10
> Foco: Rodar R14 com Call D e verificar pipeline completo

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (16 slides metanalise).
**Agentes: 10.** **Hooks: 39 registrations.** **Rules: 11**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 10.**
**Skills: 20.** **Memory: 20/20.** **.claudeignore: criado S128.**

## P0 — Rodar R14 com Call D e verificar

**Pronto para rodar.** Comando:
```bash
cd content/aulas
node scripts/qa-capture.mjs --aula metanalise --slide s-importancia
node scripts/gemini-qa3.mjs --aula metanalise --slide s-importancia --editorial --round 14
```

O que verificar no output:
1. **Fresh eyes**: round context mostra "fresh eyes — FPs injected" (nao scores anteriores)
2. **Call D executa**: "6b. Running Call D — Anti-Sycophancy Validation..."
3. **Ceiling violations**: motion scores devem ser recalibrados (R13 tinha 5 WARNs: 10s com problemas)
4. **GUARANTEE fields**: dimensoes devem ter campo guarantee preenchido (especialmente Call C)
5. **failsafes**: se continuar 3/10, confirma FP persistente (CSS ja esta correto)
6. **Adjusted overall**: Call D produz score recalibrado vs raw score das 3 calls

Pendencias pos-R14:
- Se overall ajustado >= 7: slide aprovavel (issues restantes sao design decisions)
- Se failsafes continua FP: adicionar ao prompt de Call B como exclusao explicita
- Se Call D nao agrega valor: pode ser removida (custo ~$0.02)

## P1 — QA restantes (12 slides LINT-PASS)

Lucas decide qual slide. Pipeline: 1 slide/vez, 4 gates (agora com Call D).

## P2 — /insights trend watch

S141 insights: rolling averages subiram (corrections 0.862->1.128, kbp 0.254->0.32).
Observar S142-S144. Se KBP/session > 0.5 por 3 sessoes: investigar regressao.

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
- **Projecao S138:** 2 cenarios (sala 6m TV + auditorio 10m projetor). Design target: 10m.
- **Motion S139:** animacoes com PROPOSITO pedagogico (retencao, carga cognitiva, varredura). Sem proposito = nao animar.
- **QA visual S138:** analise multimodal obrigatoria (screenshot como imagem), nao apenas codigo.
- **QA output S139:** Gemini deve reportar WHAT/WHY/PROPOSAL/GUARANTEE. Sem notas subjetivas.
- **Navy card SigmaN = hero S139:** Lucas: "a melhor parte eh o box com o sigma e o N". Tudo deriva dele.
- **Fresh eyes S140:** Gemini NAO recebe scores anteriores. Avaliacao independente. Known FPs injetados separadamente.
- **Call D S140:** 4th call anti-sycophancy. Audita 3 calls, recalibra scores, produz priority actions.
- **Temp editorial 1.0 S141:** Aplica-se a TODAS calls (incluindo Call D). Testado S71.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- KBP-07 anti-workaround, KBP-08 anti-substituicao, KBP-09 anti-routing, KBP-10 anti-destructive.
- MCP gate + Research gate: hooks force "ask" antes de MCP/research calls.
- MCP freeze ate 2026-04-14. PubMed session expirou S129.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever h2 sem instrucao EXPLICITA e inequivoca.
- Gemini FPs conhecidos: css_cascade e failsafes flagam `[data-qa]` como bug (e design). failsafes 3/10 persistente por 3 rounds — CSS esta correto.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S141 2026-04-10
