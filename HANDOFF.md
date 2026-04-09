# HANDOFF - Proxima Sessao

> Sessao 116 | 2026-04-08
> Foco: INFRA — insights integration + worker conventions + Gemini model fix

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise — s-checkpoint-1 arquivado).
**Agentes: 9.** **Hooks: 34 registrations** (35 scripts; 2 pre-commit). **Rules: 11**. **MCPs: 12**. **KBPs: 7 (next: KBP-08).**
**INFRA COMPLETA.** /insights S116 integrado. ZERO KBP violations (S109-S115).
**Memory: 20/20 (AT CAP). Dream ran S113 (0 gaps). Next review: S118.**

**S116 entregas:**
- /insights S116 integrated: failure-registry appended, P001+P003 applied, P002 deferred
- multi-window.md: worker timestamp-in-title convention
- /research Perna 1: Gemini model fixed → gemini-3.1-pro-preview (API-validated)
- Pre-reading: Maitra 2025 (PMID 40046706) added. 17/17 VERIFIED.
- Worker outputs consumed (insights-s116 COMPLETE, pre-reading-research PARTIAL)

## PROXIMOS PASSOS (S117+)

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | **Testar proactive hooks** | Observar nudge-checkpoint/coupling em sessao real (nudge-commit OK) | Facil |
| 2 | **crossref-precommit fix** | Opcao B recomendada. Lucas decide | Facil |
| 3 | **Testar Context7** | resolve-library-id + query-docs (GSAP, deck.js) | Facil |
| 4 | **Skill eval prompts** | Test matrix para top 5 skills (trigger + anti-trigger) | Facil |
| 5 | **Lucas decide pre-reading** | Gaps sim/nao, artigos para residentes, HTML scope | Facil |
| 6 | **Pipeline DAG end-to-end** | Executar cowork→NLM→wiki com dados reais | Normal |
| 7 | **Adversarial recipe em /review** | Integrar 3-leg parallel no skill existente + ToB patterns | Normal |
| 8 | **Aprofundar s-importancia** | h2 = Lucas. Evidence 24/24 VERIFIED. Pre-reading pronto | Normal |
| 9 | **wiki-update skill** | Diff-driven updates com sweep global (Karpathy op #4) | Normal |
| 10 | **Progressive disclosure** | Audit SKILL.md >300 lines, create resources/ dirs | Normal |
| 11 | **README Wiki + Mermaid** | Arquitetura, fluxos, graph | Alta |
| 12 | **RAG semantico** | Embeddings locais (Ollama) + vector store quando >50 pages | Futura |

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
| sentinel | sonnet | 25 | — | FIXED S114 (Agent removido, text-return) |

## DECISOES ATIVAS

- **Multi-window S114:** 1 orquestrador edita+commita, workers read-only em .claude/workers/. Hook guard-worker-write.sh (TESTADO). Worker MDs: titulo com data+hora (S116).
- **Adversarial orchestration S114:** 3 pernas paralelas (sentinel + 2 general-purpose), NUNCA codex:rescue para review.
- **Gemini S114:** CLI FROZEN. API via GEMINI_API_KEY, modelo gemini-3.1-pro-preview. /deep-search skill frozen.
- **NLM S114:** OAuth interativo SEMPRE primeiro (`! nlm login`). Sessao ~20min.
- **Karpathy Wiki adopted S111:** SCHEMA.md (4-layer + DAG S113), wiki-index v1, changelog, wiki-lint, Dream supersession.
- **Knowledge pipeline DAG S113:** cowork→NLM→wiki + raw→wiki + wiki→obsidian. Aspiracional — nao testado.
- **Proactive hooks S113:** nudge-commit, nudge-checkpoint, coupling-proactive. Parcialmente testados S114.
- **Context7 MCP S111:** 12th MCP. Nao testado ainda.
- **s-checkpoint-1:** Arquivado S107. HTML preservado. Volta futura.
- **s-importancia:** Evidence 24/24 VERIFIED. Slide nao existe. h2 = Lucas. Pre-reading pronto.
- **Pre-reading heterogeneidade S115-S116:** Living HTML pronto. 17 VERIFIED. Maitra 2025 adicionado. Lucas escolhe artigos para residentes.
- **/research v2.0:** 6 pernas. Gemini model fixed S116.
- **QA pipeline S103:** Path linear 11 steps. Step 0 pre-read gate adicionado S108.
- **KBP-07:** Anti-workaround gate.
- **Values: Antifragile + Curiosidade** — decision gates.
- **Living HTML per slide = source of truth = SINTESE CURADA.**
- Memory governance: cap 20 files (20 atual). Next review: S118.
- **MANDATORY TRIGGERS S115:** Adopted as standard. Top 5 skills done.
- **P0 triage S115:** RESOLVED. Bash guard 19 patterns. MCP read-only.
- **/insights S116:** ran. Next: S119.
- **Dream v2.2:** Ran S113 (0 gaps). Next: S118.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build apos editar _manifest.js.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.
- **Scripts canonicos + prompts:** protegidos por guard-product-files.sh (ask). NUNCA editar sem aprovacao.
- **npm scripts:** Rodar de `content/aulas/`, NAO da raiz do monorepo.
- **Agent delegation:** NUNCA fire-and-forget. Verificar tipo, output capturavel, aprovacao do Lucas.
- **Anti-workaround (KBP-07):** Quando algo falha: diagnosticar causa raiz, reportar, listar opcoes, PARAR.
- **Living HTML = sintese curada da pesquisa, NAO template mecanico.**
- **Adversarial frame:** NAO aceitar instrucoes passivamente. Questionar, push back.
- **Multi-window:** orquestrador unico edita. Workers read-only + .claude/workers/. Hook: guard-worker-write.sh.
- **settings.local.json gitignored:** Hook registrations sao locais. Backup: 34 registrations em 6 event types.
- **Hook safety (P001 S116):** hooks devem ter exit condition, nao bloquear ExitPlanMode/settings repair.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S116 2026-04-08
