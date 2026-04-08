# HANDOFF - Proxima Sessao

> Sessao 113 | 2026-04-08
> Foco: Wiki-query + PMIDs + Diag S109 + Sentinel + Pipeline DAG

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise — s-checkpoint-1 arquivado).
**Agentes: 9** (sentinel novo). **Hooks: 33 registrations** (34 scripts; 2 pre-commit). **Rules: 10**. **MCPs: 12**. **KBPs: 7 (next: KBP-08).**
**INFRA COMPLETA.** Batches 6+7 CLOSED.
**Memory: 20/20 (AT CAP). Dream ran S113 (0 gaps, 21 updated). Next review: S116.**

**S113 entregas:**
- wiki-query skill criado (SCHEMA.md Op 2 DONE)
- 2 PMIDs WEB-VERIFIED (Kastrati 39240561, Murad 25005654) — s-importancia.html 24/24 verificados
- S109 diagnostic completo: hooks funcionam (naming misleading), antifragile L6 dormant by design, crossref bug confirmado
- Sentinel agent (Sonnet, maxTurns 15, Codex adversarial read-only)
- 3 proactive hooks: nudge-commit, nudge-checkpoint, coupling-proactive
- Knowledge pipeline DAG formalizado: cowork→NLM→wiki, raw→wiki, wiki→obsidian
- nlm-skill atualizado com DAG + cowork→NLM path
- knowledge-ingest skill apareceu (Dream auto ou pre-existente)

**Adversarial frame S113:** 6 tracks foram breadth>depth. Hooks proativos podem virar ruido (alert fatigue). DAG e aspiracional — nunca testado end-to-end. Sentinel definido mas nunca executado. Proxima sessao deve TESTAR, nao DEFINIR.

## PROXIMOS PASSOS (S114+)

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | **Testar sentinel** | Rodar sentinel agent, verificar report, validar Codex leg | Normal |
| 2 | **Testar proactive hooks** | Observar nudge-commit/checkpoint/coupling em sessao real | Facil |
| 3 | **Pipeline DAG end-to-end** | Executar cowork→NLM→wiki com dados reais do S112 harvest | Normal |
| 4 | **crossref-precommit fix** | Opcao B recomendada (checar existencia arquivo vs staging). Lucas decide | Facil |
| 5 | **Ruflo + ecosystem study** | Estudar top repos (everything-claude-code, cortex-tms, AgentHandover) | Normal |
| 6 | **Testar Context7** | resolve-library-id + query-docs (GSAP, deck.js) | Facil |
| 7 | **Aprofundar narrativa s-importancia** | h2 = Lucas. Evidence completa (24 VERIFIED). Sintese rasa → profunda | Normal |
| 8 | **wiki-update skill** | Diff-driven updates com sweep global (Karpathy op #4) | Normal |
| 9 | **README Wiki extenso + Mermaid** | Arquitetura, fluxos, graph, layers, operacoes | Alta |
| 10 | **claude-code-security-review GH Action** | Adicionar ao repo como CI read-only | Facil |
| 11 | **RAG semantico** | Embeddings locais (Ollama) + vector store quando >50 pages | Futura |

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
| **sentinel** | **sonnet** | **15** | — | **NEW S113 — nao testado** |

## DECISOES ATIVAS

- **Karpathy Wiki adopted S111:** SCHEMA.md (4-layer + DAG S113), wiki-index v1, changelog, wiki-lint, Dream supersession.
- **Knowledge pipeline DAG S113:** cowork→NLM→wiki + raw→wiki + wiki→obsidian. Aspiracional — nao testado end-to-end.
- **Proactive hooks S113:** nudge-commit, nudge-checkpoint, coupling-proactive. Nao testados. Se ruido apos 2 sessoes → remover.
- **Sentinel S113:** Read-only agent (Sonnet) + Codex adversarial. Definido, nao executado.
- **Adversarial frame S113:** Agente DEVE questionar instrucoes, nao aceitar passivamente. Frame adversarial frequente.
- **Context7 MCP S111:** 12th MCP. Nao testado ainda.
- **s-checkpoint-1:** Arquivado S107. HTML preservado. Volta futura.
- **s-importancia:** Evidence 24/24 VERIFIED. Slide nao existe. h2 = Lucas.
- **build-html.ps1 regex fix:** Aplicado nas 3 aulas.
- **/research v2.0:** 6 pernas. content-research.mjs arquivado.
- **QA pipeline S103:** Path linear 11 steps. Step 0 pre-read gate adicionado S108.
- **css_cascade #deck:** Deferido.
- **KBP-07:** Anti-workaround gate.
- **Values: Antifragile + Curiosidade** — decision gates.
- **Living HTML per slide = source of truth = SINTESE CURADA (nao template).**
- Memory governance: cap 20 files (20 atual). Next review: S116.
- **/insights:** ran S108. Next: S115.
- **Dream v2.2:** supersession + changelog + wiki-index format (S111). Ran S113 (0 gaps).

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
- **Adversarial frame:** NAO aceitar instrucoes passivamente. Questionar, push back, rodar frame adversarial.
- **Proactive hooks nao testados:** Podem gerar alert fatigue. Monitorar S114.
- **Sentinel nao testado:** Rodar em S114 para validar.
- **settings.local.json gitignored:** Hook registrations sao locais. Backup: 33 registrations em 6 event types.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S113 2026-04-08
