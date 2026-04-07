# HANDOFF - Proxima Sessao

> Sessao 106 | 2026-04-07
> Foco: s-importancia (research pipeline consolidation)

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (19 slides metanalise).
**Agentes: 8** (todos com maxTurns). **Hooks: 29 registrations** (31 scripts; 2 pre-commit). **Rules: 10**. MCPs: 11. **KBPs: 7.**
**INFRA COMPLETA.** Batches 6+7 CLOSED.
**Memory: 20/20 (AT CAP).**

**/research skill v2.0:** 6 pernas independentes (Gemini deep-search, evidence-researcher MCPs, MBE evaluator, reference-checker, Perplexity Sonar, NLM). content-research.mjs ARQUIVADO (scripts/_archived/). Perplexity = perna independente. New-slide mode (`--after`).

**s-importancia:** Pesquisa feita (evidence-researcher: 8 PMIDs verified + Gemini: status NUANCAVEL). Falta: Perplexity + NLM + construcao living HTML + slide HTML.

## PROXIMOS PASSOS (S107)

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | Arquivar s-checkpoint-1 do deck | Comentar no _manifest.js + rebuild. HTML intacto. | Facil |
| 2 | Pesquisa s-importancia (Perplexity + NLM) | Pernas 5+6 do /research v2.0. NLM falhou S106 (queries longas). Retentar com queries curtas. | Normal |
| 3 | Living HTML s-importancia | Gerar evidence/s-importancia.html a partir dos dados coletados (evidence-researcher + Gemini + Perplexity + NLM) | Normal |
| 4 | Slide HTML s-importancia | Criar slide, posicao apos s-hook (F1). h2 = Lucas decide. | Normal |
| 5 | Re-run editorial s-objetivos R12 | Validar gestalt fix (border-left on obj-body) + accent 100% | Normal |
| 6 | QA proximo slide (s-absoluto ou outro) | Continuar pipeline QA (1/19 editorial) | Normal |

## AGENTES

| Agente | Model | maxTurns | Memory | Status |
|--------|-------|----------|--------|--------|
| evidence-researcher | sonnet | 20 | project | OK — foco MCPs (Perplexity agora perna independente) |
| qa-engineer | sonnet | 12 | project | OK |
| mbe-evaluator | sonnet | 15 | — | OK (FROZEN ate aula completa) |
| reference-checker | haiku | 15 | project | OK |
| quality-gate | haiku | 10 | — | OK |
| researcher | haiku | 15 | — | OK |
| repo-janitor | haiku | 12 | — | OK |
| notion-ops | haiku | 10 | — | P1: adicionar write tools + gates |

## DECISOES ATIVAS

- **s-checkpoint-1:** Sai do deck temporariamente (Lucas decidiu S106). HTML preservado.
- **s-importancia:** Slide novo F1 apos s-hook. Tema: vantagens metodologicas da MA (poder, precisao, resolucao controversias). Pesquisa parcial feita. Status: NUANCAVEL (Gemini) — precisao ≠ acuracia, GIGO caveat.
- **/research v2.0:** 6 pernas. content-research.mjs arquivado. Perplexity = independente. NLM = perna 6.
- **QA pipeline S103:** Path linear 11 steps.
- **css_cascade #deck:** Deferido.
- **KBP-07:** Anti-workaround gate.
- **Values: Antifragile + Curiosidade** — decision gates.
- **Living HTML per slide = source of truth.**
- Memory governance: cap 20 files (20 atual — AT CAP). Next review: S108.
- **/insights:** ran S100. Next: S108.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build apos editar _manifest.js.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.
- **Scripts canonicos + prompts:** protegidos por guard-product-files.sh (ask). NUNCA editar sem aprovacao.
- **npm scripts:** Rodar de `content/aulas/`, NAO da raiz do monorepo.
- **Agent delegation:** NUNCA fire-and-forget. Verificar tipo do agente, output capturavel, aprovacao do Lucas.
- **Anti-workaround (KBP-07):** Quando algo falha: diagnosticar causa raiz, reportar, listar opcoes, PARAR.
- **content-research.mjs ARQUIVADO:** Usar /research skill. Nao referenciar o .mjs.

## DADOS COLETADOS s-importancia

Fontes ja obtidas (para S107):
- `evidence/s-importancia-research.md` — 8 PMIDs verified (Lau 1992, Yusuf 1985, ATC 2002, ATT 2009, ISIS-2 1988, Egger 1997, Clarke 2014, Cumpston 2019)
- `qa-screenshots/s-importancia/content-research.md` — Gemini 3.1 Pro output (NUANCAVEL: GIGO caveat, Magnesio/ISIS-4)
- Falta: Perplexity (perna 5), NLM (perna 6)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S106 2026-04-07
