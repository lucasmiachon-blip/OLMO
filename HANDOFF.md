# HANDOFF - Proxima Sessao

> Sessao 210 | System-maturity: pesquisa concluida, execucao pendente.

## ESTADO ATUAL

Monorepo funcional. Build PASS (**17 slides** metanalise).
**Rules: 5 files, 198 li.** **Hooks: 30 shell scripts (8/27 eventos, so `command` type).** **Permissions: 38 (era 145).**
**Memory: 21/20 (over cap).** Agentes: 10. MCPs: 3+9. KBPs: 21. Skills: 22+3. Backlog: 33 (7 resolved).

## P0 — System Maturity (plano master: `.claude/plans/generic-wondering-manatee.md`)

**Rules reduction ✅:** 1,102 → 198 li, 13 → 5 files (-82%). Fase 1a (S208) + Fase 1b (S209).

**Pesquisa S209 concluida (3 agentes, fontes verificadas):**
- Hooks: 27 eventos (usamos 8), 4 handler types (usamos 1), Hookify oficial, `prompt` type hooks, `$CLAUDE_PROJECT_DIR`
- Memoria: ByteRover (zero-infra, SOTA), Mem0 free tier (10k adds/mo), Graphiti (Neo4j required)
- Audit: 4 bugs runtime, 3 vulns, 5 scripts orfaos, 26/30 sem `set -u`

**Ja feito S209:**
- Permissions cleanup: 145→38 entradas (redundancias WebFetch/Bash/MCP removidas)
- Momentum brake: WebFetch/WebSearch/Task* isentos (era ask em tudo)
- Feedback salvo: nunca sobrescrever planos/pesquisa sem reler

**Pendente execucao (order TBD por Lucas):**
- Hookify: instalar e avaliar (plugin oficial, YAML declarativo)
- Bugs: pre-push.sh missing, package.json dead refs, model-fallback Windows date, chaos session ID
- Vulns: printf injection, eval injection, JSON hand-assembly
- Mem0 free tier: avaliar vs flat files (pesquisa de comparacao pendente — agente rodando S209)
- CSS verification loop, export-png.mjs, baseline metrics

## P0 — Pendentes Anteriores

- s-quality: evidence HTML integration + narrativa pendente
- s-tipos-ma: slide PENDENTE (Lucas decide quantos, posicao, h2)
- drive-package: PDF stale, PNG export pendente
- Apresentacao S208: PDF cortou slides, HDMI comprimiu janela

## P1

- Wallace CSS-wide: 29 font-sizes raw, #162032 sem token, 20 !important
- TREE.md desatualizado (S93 → S208)
- Sentinel agent improvement (backlog #31)

## DECISOES ATIVAS

- Gemini QA temp: 1.0, topP 0.95. OKLCH obrigatorio.
- Living HTML = source of truth. Agent effort: max.
- CMMI maturity model. Hooks = freio (L2). Verification loops = melhoria (L3+).

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`. h2 = trabalho do Lucas.

---
Coautoria: Lucas + Opus 4.6 | S209 2026-04-15
