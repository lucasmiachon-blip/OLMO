# ADR-0007: shared-v2 Migration Posture (bridge-incremental)

- **Status:** accepted
- **Data:** 2026-04-23
- **Deciders:** Lucas + Claude (Opus 4.7)
- **Sessão:** S243 adversarial-patches

## Contexto

`ADR-0005-shared-v2-greenfield` (2026-04-21) decidiu criar `content/aulas/shared-v2/` paralelo ao `shared/` atual, com "Migration `shared/ → shared-v2/` de cirrose + metanalise **pós-30/abr**" (L27). A ADR-0005 não especificou a **estratégia concreta** de migration: bulk vs incremental, bridge temporário vs definitivo, criteria de exit do bridge.

S242 adversarial round (Gemini 3.1 finding F16) identificou ambiguidade como risk: sem posture clara, migration degrada em 2 sistemas sustentados (ADR-0005 §Consequências negativas: "Risco de drift/abandonment").

Fato empírico: `content/aulas/metanalise/shared-bridge.css` já existe (criado em C5 Grupo B). **A decisão (b) bridge-incremental já foi feita de facto por Lucas** durante C5 Grupo B/C work — esta ADR formaliza o padrão observado e define exit criteria.

## Decisão

Adotar **alternativa (b) bridge-incremental com exit criteria formal**:

1. Cada aula migra `shared/ → shared-v2/` individualmente, criando `{aula}/shared-bridge.css` local que re-exporta tokens/classes ausentes em shared-v2 (pattern metanalise).
2. Bridge vive enquanto aula consome features não-cobertas por shared-v2.
3. Bridge é **removido** quando shared-v2 cobrir 100% das features consumidas pela aula (exit criteria concreto per-aula).
4. Pós migration de TODAS as aulas ativas (cirrose, metanalise, grade-v2 + futuras), `shared/` legacy é **arquivada** (não removida; pattern ADR-0004 grade-v1 archive policy).

### Exit criteria por-aula

Bridge `{aula}/shared-bridge.css` pode ser removido quando **todas** as condições:

- `grep "from .*shared-bridge" {aula}/**/*.{css,js}` retorna zero matches
- `{aula}/CLAUDE.md` §Migration declara explícito "shared-v2 full coverage, bridge removed"
- QA gate (`done-gate.js` ou equivalente) passa sem referência a shared-bridge
- Commit de remoção assinado por Lucas (autorização explícita rollback-safe)

### Timeline indicativo (não-binding)

- **T-0 até 30/abr/2026:** shared-v2 Day 2+3 completion (ADR-0005 §Phases); grade-v2 como first consumer
- **Pós-30/abr → dez/2026 (R3):** migration gradual de metanalise slide-por-slide conforme Lucas edita slides existentes
- **Pós-R3 (2027):** migration cirrose (produção estável, migration = R3+ work)
- **Archive shared/ legacy:** apenas quando zero aulas consumirem (long-term, não priorizado)

## Consequências

### Positivas

- **Reconhece padrão existente** — metanalise shared-bridge.css é evidência de que (b) já funciona na prática
- **Exit criteria mensuráveis** — grep + CLAUDE.md §Migration + QA gate = 3 checkpoints objetivos
- **Incremental migration isolada** — alinhado com ADR-0005 §Consequências positivas
- **Rollback barato** — shared/ legacy permanece acessível até archive formal
- **R3 prioridade preservada** — migration não bloqueia concurso R3 dez/2026 (prep paralela)

### Negativas

- **Dupla manutenção sustentada** (ADR-0005 já listou) — bug em shared/ ainda precisa fix durante window migration (2026-04-23 até R3 ou além)
- **Bridge per-aula gera duplicação** — cada aula pode ter shared-bridge.css ligeiramente diferente; drift entre bridges possível
- **Exit criteria requer disciplina** — sem CI enforcement, migration "esquecida" numa aula vira debt invisível
- **Timeline indicativo não-binding** — risk de slippage R3-sized

## Alternativas consideradas

1. **Migração agressiva (remove shared/ pós-grade-v2)** — rejected. Bulk migration 30 slides prod (cirrose 11 + metanalise 19) sem budget R3 = regression risk alto. ADR-0005 já escolheu isolation-first posture.

2. **Freeze (shared-v2 namespace separado, sem migração de aulas antigas)** — rejected. ADR-0005 L27 explicitamente promete migration; reverter seria ADR-0005 addendum conflituoso. Dois sistemas sustentados violam princípio "um canônico" (ADR-0005 §Negativas).

3. **Bridge definitivo (manter shared-bridge.css forever)** — rejected. Sem exit criteria vira debt invisível; ADR-0005 §Negativas "drift/abandonment" se materializa. Bridge é ponte, não destino.

## Enforcement

- Novo aula pós-grade-v2: **shared-v2 exclusivamente**, sem bridge (grade-v2 deve cobrir 100% antes de considerar production-ready per ADR-0005 §Phases).
- Aula ativa (cirrose, metanalise): `shared-bridge.css` permitido, obrigatório declarar em `{aula}/CLAUDE.md §Migration` as dependências bridge explícitas.
- Lint candidato (BACKLOG): detecta `from .*shared-bridge` em aula que declarou "bridge removed" em CLAUDE.md → mismatch flag.
- Edit em `shared/` legacy: continua exigindo OK Lucas (ADR-0005 §Enforcement mantido).

## Ref cruzada

- **ADR-0005** — shared-v2 greenfield decision (predecessor, define o "porquê da v2")
- **ADR-0004** — grade-v1 archive policy (pattern de archive para shared/ pós-migration completa)
- `content/aulas/metanalise/shared-bridge.css` — evidência empírica de facto
- `.claude/plans/S239-C5-continuation.md` — C5 Grupo B/C continuation (shared-v2 Day 2/3)
- `.claude/plans/glimmering-coalescing-ullman.md §F16` — F16 finding que motivou esta ADR

Coautoria: Lucas + Opus 4.7 (Claude Code) | S243 adversarial-patches | 2026-04-23
