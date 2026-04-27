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
- S266 research state: `.mjs` Gemini/Perplexity hot path canônico; wrappers `gemini-deep-research`/`perplexity-sonar-research` EXPERIMENTAL até D-lite re-bench.

## Loop profissional (S266)
- Rehydrate: `git status --short` + HANDOFF P0 + este arquivo; só abrir docs grandes por grep/range.
- Antes de Edit: STOP → verificar evidência (`file:line`/comando/SHA) → propor mudança + porquê + risco + verificação → esperar OK Lucas.
- Depois de Edit: rodar verificação combinada, reportar PASS/FAIL em até 3 bullets, pedir só o próximo ASK.

## Roadmap pointers
- P0 atual: `HANDOFF.md` define escolha entre QA metanálise e D-lite signoff.
- Plans vivos: `.claude/plans/sleepy-wandering-firefly.md` + `.claude/plans/curious-enchanting-tarjan.md`.
