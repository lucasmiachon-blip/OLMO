# HANDOFF - Proxima Sessao

> Sessao 62 | 2026-04-04

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 11 rules (5 path-scoped).
8 hooks (.claude/hooks/) + 5 hooks (hooks/). Docs atualizados (hooks README reescrito).
Memory system: 20 topic files + MEMORY.md (consolidado de 39). Governance: cap 20.
Skill merge: new-slide absorbed into slide-authoring v2.0.

## PROXIMO (P0 — S63 planejado)

1. **Pesquisa best practices CLAUDE.md + rules** — pesquisar como projetos de referencia estruturam CLAUDE.md e rules. Avaliar se os nossos seguem melhores praticas. Melhorar onde necessario.
2. **Codex audit batches** — mandar 2 rounds focados ao Codex (objetivo + adversarial), com prompts reestruturados: conteudo inline, pares de comparacao, criterio binario, batches de 8-10 files. Alvo: CLAUDE.md (project + global), rules/, hooks/, skills/. Validar o que acabou de ser consolidado.

## PROXIMO (P1 — aulas)

3. **Metanalise QA** — 18 slides, QA visual incompleto. Deadline 2026-04-15 (~11 dias)
4. **Construir slide s-pico** — evidence HTML pronto. Decidir h2, source-tag, speaker notes
5. **Rodar /research em s-aplicacao** — segundo HTML, validar com dados clinicos

## PROXIMO (P2 — infra herdado)

6. **h2 assertion rewrite** — 11+ slides. Lucas guia.

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- guard-lint-before-build.sh: roda 3 linters. BLOQUEIA se qualquer falhar.
- guard-product-files.sh: BLOQUEIA edits a settings.local.json e hooks/.
- QA visual = Opus (multimodal) + Gemini script. Build ANTES de QA.
- Memory governance: cap 20 files, review a cada 3 sessoes, merge antes de criar.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.
- Security gates fail-closed. NaN/negative input -> BLOCK.
- settings.local.json e hooks/ BLOQUEADOS contra Edit/Write.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] ARCHITECTURE.md sync — alinhar com implementacao real

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-04
