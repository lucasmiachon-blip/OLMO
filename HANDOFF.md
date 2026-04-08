# HANDOFF - Proxima Sessao

> Sessao 111 | 2026-04-08
> Foco: Wiki + Context7

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise — s-checkpoint-1 arquivado).
**Agentes: 8** (todos com maxTurns). **Hooks: 29 registrations** (31 scripts; 2 pre-commit). **Rules: 10**. **MCPs: 12** (Context7 added S111). **KBPs: 7 (next: KBP-08).**
**INFRA COMPLETA.** Batches 6+7 CLOSED.
**Memory: 20/20 (AT CAP). Wiki-index v1 + tags + wikilinks added S111. Next review: S113.**

**Wiki system S111:** SCHEMA.md (3-layer Karpathy architecture), wiki-index v1 (semantic "Load when" triggers), changelog.md (audit trail), wiki-lint skill (health check), Dream v2.2 (supersession + changelog). All 20 files: tags + 11 with [[wikilinks]]. Obsidian-ready.

**Context7 MCP:** Installed, configured, permission added. Real-time lib docs (1000+ libs, free 1k/mo).

## PROXIMOS PASSOS (S112+)

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | **Rodar wiki-lint pela primeira vez** | Testar o skill, corrigir findings | Facil |
| 2 | **Testar Context7** | resolve-library-id + query-docs (GSAP, deck.js) | Facil |
| 3 | **wiki-query skill** | Smart retrieval from index (TODO em SCHEMA.md) | Normal |
| 4 | **Obsidian vault setup** | .obsidian/ config, sync memory/ como vault | Normal |
| 5 | **Aprofundar narrativa s-importancia** | Sintese cruzada superficial. Profundidade comparavel a s-pico | Normal |
| 6 | Decidir h2 do slide s-importancia | Lucas decide assertion. Speaker notes dependem do h2 | Lucas |
| 7 | Verificar 2 PMIDs CANDIDATE | Kastrati & Ioannidis 2024 (39240561), Murad 2014 (25005654) | Facil |
| 8 | Diagnostico S109 (pendente) | Hooks produtividade, antifragile, reprodutibilidade, crossref-check | Normal |
| 9 | **README Wiki extenso + Mermaid** | Apos instalacao completa: arquitetura, fluxos, graph, layers, operacoes | Alta |
| 10 | **wiki-update skill** | Diff-driven updates com sweep global (Karpathy op #4) | Normal |
| 11 | **RAG semantico** | Embeddings locais (Ollama) + vector store quando >50 pages | Futura |
| 12 | **Dominos futuros** | learning/, medical/, meta/ — wiki pages por dominio | Futura |

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

- **Karpathy Wiki adopted S111:** SCHEMA.md (3-layer), wiki-index v1, changelog, wiki-lint, Dream supersession. Compilation > retrieval.
- **Context7 MCP S111:** 12th MCP. Permission in settings.local.json.
- **s-checkpoint-1:** Arquivado S107. HTML preservado. Volta futura.
- **s-importancia:** Slide novo F1 apos s-hook. Living HTML com secoes completas mas narrativa rasa. h2 = Lucas.
- **build-html.ps1 regex fix:** Aplicado nas 3 aulas.
- **/research v2.0:** 6 pernas. content-research.mjs arquivado.
- **QA pipeline S103:** Path linear 11 steps. Step 0 pre-read gate adicionado S108.
- **css_cascade #deck:** Deferido.
- **KBP-07:** Anti-workaround gate.
- **Values: Antifragile + Curiosidade** — decision gates.
- **Living HTML per slide = source of truth = SINTESE CURADA (nao template).**
- Memory governance: cap 20 files (20 atual). Wiki-index v1 added S111. Review S113.
- **/insights:** ran S108. Next: S115.
- **Dream v2.2:** supersession + changelog + wiki-index format (S111).

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
Coautoria: Lucas + Opus 4.6 | S111 2026-04-08
