# HANDOFF - Proxima Sessao

> Sessao 114 | 2026-04-08
> Foco: Adversarial audit + pre-reading heterogeneidade + multi-window

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise — s-checkpoint-1 arquivado).
**Agentes: 9** (sentinel fixado). **Hooks: 34 registrations** (35 scripts; 2 pre-commit). **Rules: 11**. **MCPs: 12**. **KBPs: 7 (next: KBP-08).**
**INFRA COMPLETA.** Batches 6+7 CLOSED.
**Memory: 20/20 (AT CAP). Dream ran S113 (0 gaps). Next review: S116.**

**S114 entregas (5 batches):**
- Sentinel testado (falhou 4x), diagnosticado, fixado: Agent tool removido, text-return canonical, maxTurns 25
- Adversarial audit 3-leg: sentinel-report (14 findings), adversarial-audit (3 passes), codex-report (9 findings)
- KBP-06 3a recorrencia documentada + fix estrutural (Codex = perna separada, NUNCA delegada)
- Multi-window system: regra + pasta .claude/workers/ + hook guard-worker-write (testado — bloqueou edit real)
- Worker UX: basta dizer "worker mode" na outra janela — auto-cria flag + restringe
- Pre-reading heterogeneidade: 10 artigos VERIFIED + 4 candidatos WEB-VERIFIED
- Best practices cowork/skills pesquisa
- Gemini CLI FROZEN. /research Perna 1 = Gemini API `gemini-3.1-pro` deep think (GEMINI_API_KEY)
- NLM OAuth prominente em /research Perna 6 + nlm-skill regra #1
- /deep-search skill FROZEN (referencia de prompt design apenas)

**Adversarial frame S114:** Sentinel falhou 4x (structural: sem Write tool + Agent tool contradiz spec). Codex fire-and-forget 3a vez. Explorer hallucinou bug inexistente. Subagent outputs DEVEM ser verificados. Gemini CLI frozen (429 quota). Deep-search skill frozen.

## PROXIMOS PASSOS (S115+)

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | **Triar adversarial findings** | 2 P0 (Bash wildcard, MCP wildcards) — Lucas decide | Facil |
| 2 | **Testar proactive hooks** | Observar nudge-commit/checkpoint/coupling em sessao real | Facil |
| 3 | **crossref-precommit fix** | Opcao B recomendada. Lucas decide | Facil |
| 4 | **Testar Context7** | resolve-library-id + query-docs (GSAP, deck.js) | Facil |
| 5 | **Pipeline DAG end-to-end** | Executar cowork→NLM→wiki com dados reais | Normal |
| 6 | **Adversarial recipe em /review** | Integrar 3-leg parallel no skill existente | Normal |
| 7 | **Aprofundar s-importancia** | h2 = Lucas. Evidence 24/24 VERIFIED. Pre-reading pronto | Normal |
| 8 | **Ruflo + ecosystem study** | best-practices doc criado, estudar repos top | Normal |
| 9 | **wiki-update skill** | Diff-driven updates com sweep global (Karpathy op #4) | Normal |
| 10 | **README Wiki + Mermaid** | Arquitetura, fluxos, graph | Alta |
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
| sentinel | sonnet | 25 | — | FIXED S114 (Agent removido, text-return) |

## DECISOES ATIVAS

- **Multi-window S114:** 1 orquestrador edita+commita, workers read-only em .claude/workers/. Hook guard-worker-write.sh (TESTADO — bloqueou edit real). Ativar worker: dizer "worker mode". OLMO_COWORK em C:\Dev\Projetos\OLMO_COWORK.
- **Adversarial orchestration S114:** 3 pernas paralelas (sentinel + 2 general-purpose), NUNCA codex:rescue para review. Codex = manual por Lucas se quiser.
- **Gemini S114:** CLI FROZEN. API via GEMINI_API_KEY, modelo gemini-3.1-pro (deep think). /deep-search skill frozen (referencia apenas).
- **NLM S114:** OAuth interativo SEMPRE primeiro (`! nlm login`). Sessao ~20min. Falha silenciosa sem auth.
- **Karpathy Wiki adopted S111:** SCHEMA.md (4-layer + DAG S113), wiki-index v1, changelog, wiki-lint, Dream supersession.
- **Knowledge pipeline DAG S113:** cowork→NLM→wiki + raw→wiki + wiki→obsidian. Aspiracional — nao testado.
- **Proactive hooks S113:** nudge-commit, nudge-checkpoint, coupling-proactive. Parcialmente testados S114 (nudge-commit funcional).
- **Context7 MCP S111:** 12th MCP. Nao testado ainda.
- **s-checkpoint-1:** Arquivado S107. HTML preservado. Volta futura.
- **s-importancia:** Evidence 24/24 VERIFIED. Slide nao existe. h2 = Lucas. Pre-reading pronto.
- **/research v2.0:** 6 pernas. content-research.mjs arquivado.
- **QA pipeline S103:** Path linear 11 steps. Step 0 pre-read gate adicionado S108.
- **KBP-07:** Anti-workaround gate.
- **Values: Antifragile + Curiosidade** — decision gates.
- **Living HTML per slide = source of truth = SINTESE CURADA (nao template).**
- Memory governance: cap 20 files (20 atual). Next review: S116.
- **/insights:** ran S108. Next: S115.
- **Dream v2.2:** Ran S113 (0 gaps).

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build apos editar _manifest.js.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.
- **Scripts canonicos + prompts:** protegidos por guard-product-files.sh (ask). NUNCA editar sem aprovacao.
- **npm scripts:** Rodar de `content/aulas/`, NAO da raiz do monorepo.
- **Agent delegation:** NUNCA fire-and-forget. Verificar tipo, output capturavel, aprovacao do Lucas. Subagent outputs VERIFICADOS (explorer hallucinou S114).
- **Anti-workaround (KBP-07):** Quando algo falha: diagnosticar causa raiz, reportar, listar opcoes, PARAR.
- **Living HTML = sintese curada da pesquisa, NAO template mecanico.**
- **Adversarial frame:** NAO aceitar instrucoes passivamente. Questionar, push back.
- **Multi-window:** orquestrador unico edita. Workers read-only + .claude/workers/. Hook: guard-worker-write.sh.
- **settings.local.json gitignored:** Hook registrations sao locais. Backup: 34 registrations em 6 event types.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S114 2026-04-08
