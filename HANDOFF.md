# HANDOFF - Proxima Sessao

> Sessao 115 | 2026-04-08
> Foco: INFRA — P0 triage + ecosystem study + MANDATORY TRIGGERS

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise — s-checkpoint-1 arquivado).
**Agentes: 9.** **Hooks: 34 registrations** (35 scripts; 2 pre-commit). **Rules: 11**. **MCPs: 12**. **KBPs: 7 (next: KBP-08).**
**INFRA COMPLETA.** P0 adversarial TRIAGED.
**Memory: 20/20 (AT CAP). Dream ran S113 (0 gaps). Next review: S116.**

**S115 entregas:**
- P0-1 Bash wildcard: guard-bash-write.sh denylist 11→19 patterns (touch, mkdir, ln, tar, git apply/am, rm, chmod, truncate)
- P0-2 MCP wildcards: Notion/Gmail/Calendar wildcards → 18 read-only entries (write ops = ask)
- /research Perna 1: generationConfig (temperature 1, maxOutputTokens 8192, thinkingBudget HIGH) + text extraction
- MANDATORY TRIGGERS: top 5 skills (research, slide-authoring, organization, review, insights)
- Ecosystem study: gap analysis OLMO vs ecosystem (resources/ecosystem-study-S115.md)
- Worktree isolation evaluated, DEFERRED (worker-mode sufficient)
- Pre-reading heterogeneidade: living HTML criado (16 PMIDs VERIFIED, 5 core path, 4 deep-dive gaps, glossario, NLM section)

## PROXIMOS PASSOS (S116+)

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | **Testar proactive hooks** | Observar nudge-checkpoint/coupling em sessao real (nudge-commit OK) | Facil |
| 2 | **crossref-precommit fix** | Opcao B recomendada. Lucas decide | Facil |
| 3 | **Testar Context7** | resolve-library-id + query-docs (GSAP, deck.js) | Facil |
| 4 | **Skill eval prompts** | Test matrix para top 5 skills (trigger + anti-trigger) | Facil |
| 5 | **Pipeline DAG end-to-end** | Executar cowork→NLM→wiki com dados reais | Normal |
| 6 | **Adversarial recipe em /review** | Integrar 3-leg parallel no skill existente + ToB patterns | Normal |
| 7 | **Aprofundar s-importancia** | h2 = Lucas. Evidence 24/24 VERIFIED. Pre-reading pronto | Normal |
| 8 | **wiki-update skill** | Diff-driven updates com sweep global (Karpathy op #4) | Normal |
| 9 | **Progressive disclosure** | Audit SKILL.md >300 lines, create resources/ dirs | Normal |
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
- **Pre-reading heterogeneidade S115:** Living HTML pronto. Lucas escolhe 1-2 artigos para enviar aos residentes.
- **/research v2.0:** 6 pernas. content-research.mjs arquivado.
- **QA pipeline S103:** Path linear 11 steps. Step 0 pre-read gate adicionado S108.
- **KBP-07:** Anti-workaround gate.
- **Values: Antifragile + Curiosidade** — decision gates.
- **Living HTML per slide = source of truth = SINTESE CURADA (nao template).**
- Memory governance: cap 20 files (20 atual). Next review: S116.
- **Worktree isolation S115:** Evaluated, DEFERRED. Worker-mode (flag+hook) is simpler, safer, sufficient for read-only workers.
- **MANDATORY TRIGGERS S115:** Adopted as standard. Top 5 skills done. Extend to remaining skills incrementally.
- **P0 triage S115:** Bash guard 19 patterns (denylist). MCP read-only (Notion/Gmail/Calendar). Both RESOLVED.
- **/insights:** ran S108. Next: S116.
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
Coautoria: Lucas + Opus 4.6 | S115 2026-04-08
