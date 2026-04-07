# HANDOFF - Proxima Sessao

> Sessao 107 | 2026-04-07
> Foco: s-importancia construcao

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise — s-checkpoint-1 arquivado).
**Agentes: 8** (todos com maxTurns). **Hooks: 29 registrations** (31 scripts; 2 pre-commit). **Rules: 10**. MCPs: 11. **KBPs: 7.**
**INFRA COMPLETA.** Batches 6+7 CLOSED.
**Memory: 20/20 (AT CAP).**

**/research skill v2.0:** 6 pernas independentes. content-research.mjs ARQUIVADO.

**s-importancia:** Pesquisa COMPLETA (5 pernas cruzadas). Living HTML pronto (22 VERIFIED + 2 CANDIDATE). Falta: criar slide HTML (h2 = Lucas decide).

## PROXIMOS PASSOS (S108)

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | Revisar living HTML s-importancia | Faltam secoes: revisao narrativa, glossario, outros padroes dos living HTMLs existentes. Nao commitado. | Normal |
| 2 | Criar slide HTML s-importancia | Posicao apos s-hook (F1). h2 = Lucas decide. Depende de living HTML revisado. | Normal |
| 3 | Re-run editorial s-objetivos R12 | Validar gestalt fix (border-left on obj-body) + accent 100% | Normal |
| 4 | QA proximo slide (s-absoluto ou outro) | Continuar pipeline QA (1/19 editorial) | Normal |
| 5 | Verificar 2 PMIDs CANDIDATE | Kastrati & Ioannidis 2024 (39240561), Murad 2014 (25005654) | Facil |

## AGENTES

| Agente | Model | maxTurns | Memory | Status |
|--------|-------|----------|--------|--------|
| evidence-researcher | sonnet | 20 | project | OK |
| qa-engineer | sonnet | 12 | project | OK |
| mbe-evaluator | sonnet | 15 | — | OK (FROZEN ate aula completa) |
| reference-checker | haiku | 15 | project | OK |
| quality-gate | haiku | 10 | — | OK |
| researcher | haiku | 15 | — | OK |
| repo-janitor | haiku | 12 | — | OK |
| notion-ops | haiku | 10 | — | P1: adicionar write tools + gates |

## DECISOES ATIVAS

- **s-checkpoint-1:** Arquivado S107 (comentado no manifest). HTML preservado. Volta futura.
- **s-importancia:** Slide novo F1 apos s-hook. Pesquisa completa. Living HTML pronto. h2 = Lucas.
- **build-html.ps1 regex fix:** Aplicado nas 3 aulas. Ignora linhas `//` comentadas. Aceita single+double quotes.
- **/research v2.0:** 6 pernas. content-research.mjs arquivado.
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
- PMIDs de LLM: ~56% erro. SEMPRE verificar. (S107: 40% erro Gemini, 6/15 corrigidos NLM.)
- **Scripts canonicos + prompts:** protegidos por guard-product-files.sh (ask). NUNCA editar sem aprovacao.
- **npm scripts:** Rodar de `content/aulas/`, NAO da raiz do monorepo.
- **Agent delegation:** NUNCA fire-and-forget. Verificar tipo do agente, output capturavel, aprovacao do Lucas.
- **Anti-workaround (KBP-07):** Quando algo falha: diagnosticar causa raiz, reportar, listar opcoes, PARAR.
- **content-research.mjs ARQUIVADO:** Usar /research skill. Nao referenciar o .mjs.

## DADOS COLETADOS s-importancia

Fontes completas (5 pernas):
- `evidence/s-importancia.html` — Living HTML (22 VERIFIED + 2 CANDIDATE). SOURCE OF TRUTH.
- `evidence/s-importancia-research.md` — evidence-researcher S106 (8 PMIDs verified)
- `qa-screenshots/s-importancia/content-research.md` — Gemini v1 (NUANCAVEL)
- `qa-screenshots/s-importancia/deep-search-v2.md` — Gemini v2 (contraponto, 15 PMIDs → 6 corrigidos)
- `qa-screenshots/s-importancia/perplexity-leg.md` — Perplexity (Kastrati & Ioannidis 2024)
- `qa-screenshots/s-importancia/nlm-verification.md` — NLM (9 VERIFIED + 6 correcoes)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S107 2026-04-07
