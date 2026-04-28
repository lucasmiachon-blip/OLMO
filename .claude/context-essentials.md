# Context Essentials (pos-compaction survival kit)

> Auto-reinject por `hooks/session-compact.sh`. Manter curto: este arquivo + `HANDOFF.md` devem bastar para reidratar.

## Rehydrate minimo
- `git status --short` -> ler `HANDOFF.md` -> escolher UMA lane (metanalise, D-lite, infra).
- Se a lane for D-lite/research: ler `docs/research/S269-dlite-rehydration.md` antes de qualquer Edit. Ele alinha Claude Code + Codex sobre scripts antigos, novos scripts, agents, skill e gaps.
- Nao abrir `CHANGELOG.md` nem planos longos no start; usar `rg -n "termo" arquivo` e ler ranges.
- Auditoria infra S267 persistida em `docs/audit/codex-adversarial-audit-S267.md`; auditoria adversarial S270 em `.claude/plans/archive/S270-audit-adversarial-15-findings.md`; S271 audit-fix execution em `.claude/plans/archive/S271-audit-fix-criticos.md`. Não reconstruir por memória.

## Scripts canonicos
- Build aulas: `npm --prefix content/aulas run build:{aula}`.
- QA unica: `node content/aulas/scripts/gemini-qa3.mjs --aula {aula} --slide {id} --inspect|--editorial`.
- Nunca `taskkill //IM node.exe`; matar por PID especifico.

## Decisions vivas
- Living HTML per slide = source of truth; `evidence-db.md` deprecated.
- `.mjs` Gemini/Perplexity = hot path canonico ate D-lite; `gemini-deep-research`/`perplexity-sonar-research` seguem EXPERIMENTAL.
- S269 D-lite = capture-first, nao final-first: `research-dlite-runner.mjs --output-kind candidates` + `research-candidate-set.json` preservam recall/novelty antes de triagem Opus/MCP. Codex/ChatGPT-5.5 xhigh e perna #7 propria, nao substituto de Gemini/Perplexity/Google AI Studio.
- Gaps D-lite completos vivem em `docs/research/S269-dlite-rehydration.md#open-gaps`; resumo: Gemini API 429, sem candidate-first live re-bench, sem Opus triage runner, sem DOI/URL/ISBN verifier, sem matriz cost/latency/recall.
- Codex CLI `0.125.0` statusline usa strings: `model-name`, `context-used`, `five-hour-limit`, `weekly-limit`, `used-tokens`.

## Loop profissional
- Antes de side effect: EC loop visível — ver master `.claude/rules/anti-drift.md §EC loop`. Sem OK explícito no thread atual = STOP.
- Depois de Edit: rodar verificacao minima, reportar PASS/FAIL em ate 3 bullets.
