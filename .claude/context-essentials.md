# Context Essentials (pos-compaction survival kit)

> Auto-reinject por `hooks/session-compact.sh`. Manter curto: este arquivo + `HANDOFF.md` devem bastar para reidratar.

## Rehydrate minimo
- `git status --short` -> ler `HANDOFF.md` -> escolher UMA lane (metanalise, D-lite, infra).
- Nao abrir `CHANGELOG.md` nem planos longos no start; usar `rg -n "termo" arquivo` e ler ranges.
- Drift local conhecido: `.claude/statusline.sh` modificado; `.claude/.research-tmp/` ignorado como temp; Codex global statusline ja configurado fora do repo.
- Auditoria infra S267 persistida em `docs/audit/codex-adversarial-audit-S267.md`; nao reconstruir por memoria.

## Scripts canonicos
- Build aulas: `npm --prefix content/aulas run build:{aula}`.
- QA unica: `node content/aulas/scripts/gemini-qa3.mjs --aula {aula} --slide {id} --inspect|--editorial`.
- Nunca `taskkill //IM node.exe`; matar por PID especifico.

## Decisions vivas
- Living HTML per slide = source of truth; `evidence-db.md` deprecated.
- `.mjs` Gemini/Perplexity = hot path canonico ate D-lite; `gemini-deep-research`/`perplexity-sonar-research` seguem EXPERIMENTAL.
- Codex CLI `0.125.0` statusline usa strings: `model-name`, `context-used`, `five-hour-limit`, `weekly-limit`, `used-tokens`.

## Loop profissional
- Antes de Edit: verificar evidencia (`file:line`/comando/SHA), declarar risco e verificacao, aguardar OK Lucas quando escopo nao estiver explicito.
- Depois de Edit: rodar verificacao minima, reportar PASS/FAIL em ate 3 bullets.
