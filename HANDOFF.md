# HANDOFF - Proxima Sessao

> Sessao 110 | 2026-04-08
> Foco: Memory + Skills Audit

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise — s-checkpoint-1 arquivado).
**Agentes: 8** (todos com maxTurns). **Hooks: 29 registrations** (31 scripts; 2 pre-commit). **Rules: 10**. MCPs: 11. **KBPs: 7 (next: KBP-08).**
**INFRA COMPLETA.** Batches 6+7 CLOSED.
**Memory: 20/20 (AT CAP). Lifecycle field added S110 (11 evergreen, 9 seasonal). Next review: S113.**

**Dream SKILL.md v2.1:** 7 fixes de alinhamento aplicados (lifecycle rename, session path, user type, topic naming, index format, archive dir, file cap). Testado dry-run S110.

**Skills audit S110:** Context7 deferred. **Karpathy Wiki: NAO SKIP — pesquisa aprofundada revelou arquitetura superior (compile-once, query-smart vs nosso load-all). Avaliar adocao parcial.**

## PROXIMOS PASSOS (S111+)

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | **Implementar padroes Wiki no OLMO** | Index-first retrieval, compilation pipeline, backlinks, supersession. Refs: kfchou/wiki-skills, gist karpathy/442a6bf5 | Alta |
| 2 | **Avaliar Context7 MCP** | Docs de libs em tempo real. Free 1k req/mes. Deferred S110 | Normal |
| 3 | **Aprofundar narrativa s-importancia** | Sintese cruzada superficial. Profundidade comparavel a s-pico | Normal |
| 4 | Decidir h2 do slide s-importancia | Lucas decide assertion. Speaker notes dependem do h2 | Lucas |
| 5 | Verificar 2 PMIDs CANDIDATE | Kastrati & Ioannidis 2024 (39240561), Murad 2014 (25005654) | Facil |
| 6 | Diagnostico S109 (pendente) | Hooks produtividade, antifragile, reprodutibilidade, crossref-check | Normal |

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
- **QA pipeline S103:** Path linear 11 steps. Step 0 pre-read gate adicionado S108.
- **css_cascade #deck:** Deferido.
- **KBP-07:** Anti-workaround gate.
- **Values: Antifragile + Curiosidade** — decision gates.
- **Living HTML per slide = source of truth = SINTESE CURADA (nao template).**
- Memory governance: cap 20 files (20 atual). Lifecycle field adicionado S110. Review S113.
- **/insights:** ran S108. Next: S115.
- **Dream v2.1:** 7 fixes de alinhamento (S110). Dry-run validado.
- **Karpathy Wiki:** Pesquisa aprofundada S110. Arquitetura compile-once > load-all. Avaliar adocao parcial S111+.

## KARPATHY WIKI — ACHADOS S110 (referencia para S111+)

Fonte: gist karpathy/442a6bf5. Implementacoes: kfchou/wiki-skills, ussumant/llm-wiki-compiler, lucasastorian/llmwiki.

**Padroes a avaliar para adocao:**
1. **Index-first retrieval** — sumario → carrega so relevantes (vs load-all)
2. **Compilation pipeline** — processa fonte 1x, ripple update em N paginas
3. **Backlinks automaticos** — relacoes tipadas (caused, contradicts, supports)
4. **Supersession** — mark claims obsoletos explicitamente (vs append-only)
5. **Coverage scoring** — quantas fontes suportam cada claim
6. **Audit trail** — log.md append-only com historico de operacoes
7. **4-tier consolidation** — working → episodic → semantic → procedural

**Nossas fraquezas que Wiki resolve:**
- Load-all (20 files → context) nao escala
- Dream faz 1 pass (nao compilation)
- Sem contradicao detection, sem backlinks, sem coverage

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
- **Living HTML = sintese curada da pesquisa, NAO template mecanico.**

## DIAGNOSTICO S109 (pendente — nao executado)

- **Hooks self-improvement/produtividade:** nao estao funcionando. Investigar.
- **Antifragile:** nao esta funcionando. Investigar.
- **Reprodutibilidade:** ainda fraca. Investigar.
- **crossref-check hook:** bloqueia evidence HTML sem slide correspondente (caso legitimo: evidence antes de slide). Ajustar logica.
- **s-importancia.html:** NAO COMMITADO (blocked by crossref). Arquivo local OK.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S110 2026-04-08
