# Context Essentials (pos-compaction survival kit)

> Reinjectado automaticamente por `hooks/session-compact.sh` apos compaction.
> Contem APENAS o que NAO esta em `CLAUDE.md` ou `.claude/rules/anti-drift.md`. Max ~15 linhas.
> Regras gerais (proponha OK, antifragile, curiosidade) vivem em CLAUDE.md + anti-drift — NAO duplicar aqui.

## Scripts canonicos (aulas)
- Build: `npm run build:{aula}` (SEMPRE antes de QA — gera index.html)
- QA: `node content/aulas/scripts/gemini-qa3.mjs` (UNICO — 3 gates: Preflight → Inspect → Editorial)

## Decisions vivas
- Living HTML per slide = source of truth (`evidence-db.md` deprecated)
- `plansDirectory: .claude/plans` — planos sobrevivem sessoes
- NUNCA `taskkill //IM node.exe` — matar por PID especifico (Lucas roda dev server)

## Roadmap pointers
- Next P1: `.claude/plans/ACTIVE-S227-memory-to-living-html.md` (agent-memory → living HTML)
- Audit frame: `.claude/plans/bubbly-forging-cat.md` (S230 adversarial campaign)
