# HANDOFF - Proxima Sessao

> Sessao 108 | 2026-04-07
> Foco: living HTML + insights

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise — s-checkpoint-1 arquivado).
**Agentes: 8** (todos com maxTurns). **Hooks: 29 registrations** (31 scripts; 2 pre-commit). **Rules: 10**. MCPs: 11. **KBPs: 7 (next: KBP-08).**
**INFRA COMPLETA.** Batches 6+7 CLOSED.
**Memory: 20/20 (AT CAP).**

**/research skill v2.0:** 6 pernas independentes. content-research.mjs ARQUIVADO.

**s-importancia:** Living HTML com TODAS secoes (speaker-notes, pedagogia, retorica, numeros, sugestoes, rubric, glossario). **Narrativa superficial — aprofundar S109.** h2 = Lucas decide. 2 CANDIDATE PMIDs pendentes.

**/insights S108:** Rodou. Trend IMPROVING (correcoes 0.27, KBP 0.18). 3 proposals aplicadas.

## PROXIMOS PASSOS (S109)

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | **Aprofundar narrativa s-importancia** | Sintese cruzada superficial. Rodar novos queries (trials mais recentes). Profundidade comparavel a s-pico. | Normal |
| 2 | Decidir h2 do slide s-importancia | Lucas decide assertion. Speaker notes dependem do h2. | Lucas |
| 3 | Verificar 2 PMIDs CANDIDATE | Kastrati & Ioannidis 2024 (39240561), Murad 2014 (25005654) | Facil |
| 4 | Criar slide HTML s-importancia | Posicao apos s-hook (F1). Depende de living HTML revisado + h2. | Normal |
| 5 | Re-run editorial s-objetivos R12 | Validar gestalt fix (border-left on obj-body) + accent 100% | Normal |
| 6 | QA proximo slide (s-absoluto ou outro) | Continuar pipeline QA (1/19 editorial) | Normal |
| 7 | Memory review | Cap 20/20. Due desde S105. Revisar merge candidates. | Facil |

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

- **s-checkpoint-1:** Arquivado S107. HTML preservado. Volta futura.
- **s-importancia:** Slide novo F1 apos s-hook. Living HTML com secoes completas mas narrativa rasa. h2 = Lucas.
- **build-html.ps1 regex fix:** Aplicado nas 3 aulas.
- **/research v2.0:** 6 pernas. content-research.mjs arquivado.
- **QA pipeline S103:** Path linear 11 steps. **Step 0 pre-read gate adicionado S108.**
- **css_cascade #deck:** Deferido.
- **KBP-07:** Anti-workaround gate.
- **Values: Antifragile + Curiosidade** — decision gates.
- **Living HTML per slide = source of truth = SINTESE CURADA (nao template).**
- Memory governance: cap 20 files (20 atual — AT CAP). Review due S109.
- **/insights:** ran S108. Next: S115.

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
- **Living HTML = sintese curada da pesquisa, NAO template mecanico.** Cada secao deve refletir achados reais.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S108 2026-04-07
