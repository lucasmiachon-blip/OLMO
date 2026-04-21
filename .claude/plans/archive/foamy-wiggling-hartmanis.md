# S237 C4 Close + Docs Update + Baton Pass

> Overwrites previous C1 plan content. Scope now: close C4 clean + update state docs
> for tomorrow's baton pass (Lucas + Codex adversarial + new Opus.ai reidratação).
> NO C5 execution tonight. Lucas exhausted; plan is for tomorrow execution.

## Context

S237 mid-execution: C1-C3 committed (HEAD `8e8eb28`). C4 shared-v2 Day 1 work prepared but uncommitted:
- 7 new files + 2 Edits tokens + 2 Edits external (package.json, ADR-0005)
- 7 adversarial greps pós-Write clean (60 literais all justified, 0 element selectors, 3 @container/@media justified, 3 clamps math-verified, 0 TODO/FIXME, 0 tiny files, 3 WOFF2 <10KB identical to shared/ production copies)
- slide.css Fix 3.1 comment aplicado (`/* Consumers @container slide (...) chegam em C5+ ... */`)
- Vite dev server rodando em background (ID `b48vbnd5q`) porta 4103 para Lucas validar visualmente

Blocker antes de commit: **Lucas visual validation pendente** (browser check hero + evidence mocks). Se OK → proceed 3 commits. Se fail → hotfix pré-commit.

## State Snapshot (pre-commit)

**Git HEAD:** `8e8eb28` (S237 C3 ADRs).

**Working tree:**
- Modified: `content/aulas/package.json`, `docs/adr/0005-shared-v2-greenfield.md`
- Modified (tokens Edits): `content/aulas/shared-v2/tokens/system.css`, `content/aulas/shared-v2/tokens/components.css`
- Untracked: `.claude/plans/foamy-wiggling-hartmanis.md` (this plan file), `content/aulas/shared-v2/` (14 files: 7 novos + 3 tokens pre-calibrados + 4 fonts WOFF2)

**Key files in `content/aulas/shared-v2/`:**
| Path | Li | Status |
|---|---|---|
| README.md | 61 | NEW |
| type/scale.css | 70 | NEW (Utopia-adaptada clamp+cqi) |
| layout/slide.css | 36 | NEW (container-type + aspect-ratio 16:9 + fix comment) |
| layout/primitives.css | 52 | NEW (every-layout) |
| css/index.css | 113 | NEW (@layer cascade + @font-face + utilities) |
| _mocks/hero.html | 19 | NEW |
| _mocks/evidence.html | 26 | NEW |
| tokens/reference.css | ~200 | PRE-EXISTING (calibrado + 3 fixes S237 C4) |
| tokens/system.css | ~155 | PRE-EXISTING + Edit +6 li (--font-*) |
| tokens/components.css | ~200 | PRE-EXISTING + Edit +10 li (--slide-caption-*) |
| assets/fonts/*.woff2 | — | COPIED from shared/ (4 WOFF2, 36KB) |

## Protocolo de execução — 3 commits + report

**Pré-requisito:** visual OK from Lucas (via Vite em porta 4103). Se não OK, hotfix primeiro.

### Commit 1 — S237 C4 shared-v2 Day 1

```bash
git add content/aulas/shared-v2/ content/aulas/package.json docs/adr/0005-shared-v2-greenfield.md
git commit -F- <<'EOF'
S237 C4: shared-v2 Day 1 — tokens (pre-existing) + type + layout + entry + mocks

Creates: content/aulas/shared-v2/ greenfield. Tokens calibrados por Lucas em
sessão Claude.ai separada (reference/system/components 3 layers, OKLCH híbrido
Stripe+Radix-inspired, APCA-safe, prefers-reduced-motion obrigatório).

Type scale fluid via clamp+cqi com fórmula Utopia-adaptada para container queries
(tabela de derivação no header de scale.css: N_cqi + floor_px para cada clamp).
Layout primitives every-layout.dev (stack/cols/cluster/grid-auto-fit) zero media
queries, zero @container em primitives. Mocks hero + evidence validam tokens +
type + layout via npm run dev:shared-v2 porta 4103.

Motion CSS (motion/tokens.css + motion/transitions.css) e dialog mock adiados
para C5 junto com JS layer (deck.js + presenter-safe.js + motion.js + reveal.js)
— motion requer JS coupling para validação real via element.animate().

Edits: tokens/system.css +3 --font-* tokens; tokens/components.css +4
--slide-caption-* tokens; docs/adr/0005 §Browser Targets + §A11y; package.json
dev:shared-v2 port 4103.

Co-authored-by: Claude Opus 4.7 (Claude Code) <noreply@anthropic.com>
Adversarial-reviewed-by: Claude Opus 4.7 (Claude.ai session separate)
EOF
```

### Commit 2 — chore archive plan file

```bash
mkdir -p .claude/plans/archive
git mv .claude/plans/foamy-wiggling-hartmanis.md .claude/plans/archive/
git commit -F- <<'EOF'
chore(S237): archive plan file foamy-wiggling-hartmanis

C4 plan file move para archive/. Valor histórico preservado (decisões registradas
em ADR-0005 + CHANGELOG §S237 C4 já cobrem); arquivo fica disponível em
archive/ para consulta futura sem poluir plans/ ativo.

Co-authored-by: Claude Opus 4.7 (Claude Code) <noreply@anthropic.com>
EOF
```

### Docs Updates (3 files antes do Commit 3)

#### Update 1 — `HANDOFF.md` overwrite completo

**Approach:** Write tool overwrites (anti-drift §State files prefers Edit, but full refresh post-C4 warranted — old C1 state is stale). Content:

```markdown
# HANDOFF - Proxima Sessao

> S237 mid-execution: C1-C4 committed. shared-v2 Day 1 (tokens + type + layout + mocks)
> operacional em porta 4103. Próximo: C5 Day 2 (motion CSS + JS layer + dialog mock
> + ensaio HDMI residencial). Deadline 30/abr/2026 (T-9d).

## HYDRATION (obrigatória, 3 passos)

1. Ler este HANDOFF completo.
2. `git log --oneline -10` — confirma últimos commits S237 (C1 state refresh, C2
   grade-v1 archive, C3 ADRs 0004+0005, C4 shared-v2 Day 1, chore archive plan, docs refresh).
3. Escolher: **(a)** C5 Day 2 (motion + JS + ensaio HDMI), **(b)** C6 grade-v2
   scaffold, **(c)** C7 qa-pipeline v2. Ordem canônica: a→b→c.

---

## P0 — shared-v2 + grade-v2 + qa-pipeline v2 (deadline 30/abr/2026)

### P0a C5 — shared-v2 Day 2 (PRÓXIMO)
- `content/aulas/shared-v2/motion/tokens.css` + `motion/transitions.css`
- `content/aulas/shared-v2/js/motion.js` (WAAPI helpers + VT wrapper + reduced-motion guard)
- `content/aulas/shared-v2/js/deck.js` (navegação, keybindings, hashchange)
- `content/aulas/shared-v2/js/presenter-safe.js` (?lock=1 letterbox + ResizeObserver clamp)
- `content/aulas/shared-v2/js/reveal.js` (data-reveal declarativo)
- `content/aulas/shared-v2/css/presenter-safe.css`
- `content/aulas/shared-v2/_mocks/dialog.html`
- **ENSAIO HDMI RESIDENCIAL OBRIGATÓRIO** antes de commit C5 — testa presenter-safe em monitor externo com mudança de resolução.

### P0b C6 — grade-v2 scaffold
`content/aulas/grade-v2/` com slides/ + evidence/ + exports/ + qa-rounds/ + variants/ + CLAUDE.md + HANDOFF.md + CHANGELOG.md + _manifest.js 18 slots placeholder + grade-v2.css mínimo.

### P0c C7 — qa-pipeline v2 Gate 0+1
`content/aulas/scripts/qa-pipeline/` com index.mjs + gate0-local.mjs + gate1-flash.mjs + shared/utilities + prompts/. Gate 2 Pro + Gate 3 Designer adiados (skippable via flag).

### P0.5 — QA editorial metanalise (paralelo)
16 slides pendentes (3/19 done). Usa qa-pipeline v2 quando Gate 0+1 operacional.

### P1 — R3 infra + Anki
Deferred pós-30/abr.

---

## Fallback multi-camada (handoff §D6)

- L0 Vite dev server (porta 4103 shared-v2 / 4100 cirrose / 4102 metanalise)
- L3 PDF em `{aula}/exports/` (DeckTape, fresh <24h, done-gate.js enforça)
- L4 PPTX em `{aula}/exports/` (manual primeiro, automatizado pós-30/abr)
- L2 GitHub Pages pós-30/abr

---

## Âncoras de leitura (sob demanda)

- `CLAUDE.md §ENFORCEMENT` — primacy anchor
- `.claude/rules/anti-drift.md` — propose-before-pour + EC loop + failure response
- `.claude/rules/slide-rules.md` — E07 + E20-E52
- `docs/adr/0004-grade-v1-archived.md` — rationale grade-v1 archive + 3-2-1 backup
- `docs/adr/0005-shared-v2-greenfield.md` — arquitetura shared-v2 + §Browser Targets + §A11y
- `content/aulas/shared-v2/README.md` — doutrina de consumo da biblioteca
- `content/aulas/shared-v2/tokens/` — 3 arquivos calibrados pelo Lucas (NÃO regenerar)

---

## Estado factual

- **Git HEAD:** `<hash pós-commit 3 docs>` (preencher depois do commit docs)
- **Aulas:** cirrose 11 slides produção + shared/; metanalise 19 slides QA 3/19; grade-v2 scaffold pendente (C6); grade-v1 archived (branch `legacy/grade-v1` + tag `grade-v1-final` em `ccbaefe` + tar externo `C:\Dev\Projetos\OLMO_primo\grade-v1-qa-snapshot-2026-04-21.tar.gz`).
- **shared-v2:** tokens + type + layout + entry + mocks hero/evidence DONE. Motion + JS + dialog mock pendentes C5.
- **R3 Clínica Médica:** 223 dias (Dez/2026). Setup infra em 0.
- **Deadline GRADE v2:** 30/abr/2026 quinta-feira. T-9d.

Coautoria: Lucas + Opus 4.7 (Claude Code) + Opus 4.7 (Claude.ai adversarial review) | S237 mid-execution | 2026-04-21
```

#### Update 2 — `CHANGELOG.md`

**Approach:** Edit existing §Sessao 237 block (added in C1) to replace with comprehensive entry covering C1-C4 + chore + docs. NOT prepend (duplicates).

Target: replace the existing §Sessao 237 block (currently has only C1 entry) with:

```markdown
## Sessao 237 — 2026-04-21 (grade-v2 kickoff: shared-v2 greenfield + ADRs)

### Commits

- **C1 state docs refresh** — HANDOFF §P0 + BACKLOG §P0 + CHANGELOG §S237 atualizados para refletir shared-v2 + qa-pipeline v2 + grade-v2 como P0. Reconciliação com decisões D2-D8 consolidadas em sessão Claude.ai madrugada 21/abr.
- **C2 grade-v1 archive** — branch `legacy/grade-v1` + tag `grade-v1-final` em `ccbaefe` (S178 last touch) + 70 tracked files removed + tar externo 22 orphans gitignored em `C:\Dev\Projetos\OLMO_primo\grade-v1-qa-snapshot-2026-04-21.tar.gz`. `.claudeignore` entry + `content/aulas/CLAUDE.md §Legacy Archives`.
- **C3 ADRs 0004 + 0005** — ADR-0004 grade-v1 archived (3-2-1 backup strategy como "applied here", não pattern canônico — promoção pós-N=2+). ADR-0005 shared-v2 greenfield (rationale: scaleDeck bug + stack aging + presenter-safe gap; phases C4 Day 1 + C5 Day 2).
- **C4 shared-v2 Day 1** — `content/aulas/shared-v2/` greenfield com 7 arquivos novos (README + type/scale.css + layout/slide.css + layout/primitives.css + css/index.css + _mocks/hero + _mocks/evidence) + 4 fonts copy + 4 Edits (system.css +3 --font-* tokens; components.css +4 --slide-caption-* tokens; ADR-0005 §Browser Targets + §A11y; package.json dev:shared-v2 porta 4103). Tokens (reference + system + components) pre-calibrados por Lucas em sessão Claude.ai separada (governança Stripe-style + valores Radix-inspired: warning L=82% com on-solid dark explícito, info hue 210° para separação do accent blue-violet 265°, danger hue 22° editorial). Type scale fluid via clamp+cqi com fórmula Utopia-adaptada (tabela de derivação no header de scale.css: N_cqi = (size_max-size_min)/13.2, floor_px = size_min - N×6). Layout primitives every-layout.dev (stack/cols/cluster/grid-auto-fit) zero media queries. 7 greps adversariais pós-Write clean.
- **C4 chore** — plan file `foamy-wiggling-hartmanis.md` movido para `.claude/plans/archive/`.
- **C4 docs** — HANDOFF.md overwrite (estado S237 mid-execution) + CHANGELOG §S237 expansion + BACKLOG §P0 refresh.

### Deferred para C5+

- motion/tokens.css + motion/transitions.css — requer JS coupling para validação.
- js/motion.js + js/deck.js + js/presenter-safe.js + js/reveal.js — Day 2.
- _mocks/dialog.html — C6 com conteúdo grade-v2 real.
- Ensaio HDMI residencial — C5 obrigatório antes de commit.

### Aprendizados (max 5 li)

- Revisão Opus-sobre-Opus tem correlação de blind spots: Claude.ai Opus revisor e Claude Code Opus autor pensam parecido, alguns tipos de erro passam (literais hardcoded em reemit, fórmula dimensionalmente inconsistente, clamp invertido onde min > floor). Mitigação: greps adversariais explícitos + camada externa de revisão (Codex CLI sessão separada pós-commit). Iteração em examples tem ponto de retorno decrescente — após 2 rodadas com erros novos introduzidos a cada reemit, encerra e fornece prompt prescritivo com fórmula + tabela + escopo reduzido. Governança Stripe-style (1 token por função) supera Radix (múltiplas opções por categoria) em projetos com ≤5 aulas por risco de drift entre aulas; reverta se ≥10 aulas emergirem. Tokens pré-calibrados em sessão separada (Claude.ai com output files) entregues como filesystem pre-existing ao Claude Code economizam 2-3 rodadas de calibração in-band. Stop hook + Windows path escape (KBP candidate) emergiu como pattern — backslash interpretation em bash-within-bash produz paths truncados (`C:\Dev\Projetos\OLMO` → `C:DevProjetosOLMO`); non-blocking mas silent failure esconde regressão; próximo /insights audit candidate.

Coautoria: Lucas + Opus 4.7 (Claude Code + Claude.ai) | S237 grade-v2 kickoff | 2026-04-21
```

#### Update 3 — `.claude/BACKLOG.md` §P0 refresh

**Approach:** Edit §P0 block (current L13-24 covers C1's tabela com #52/53/54 + §Dependencies + P0.5 bullet + R3 ex-P1 sub). Replace with updated P0 reflecting C4 done + C5 next.

Target replacement:

```markdown
## P0 — blocking próxima sessão <a id="p0"></a>

**Foco (ordem explícita):**

1. **P0a — shared-v2 Day 2 (C5)** — `motion/tokens.css` + `motion/transitions.css` + `js/motion.js` + `js/deck.js` + `js/presenter-safe.js` + `js/reveal.js` + `css/presenter-safe.css` + `_mocks/dialog.html`. **Ensaio HDMI residencial obrigatório** antes de commit.
2. **P0b — grade-v2 scaffold (C6)** — `content/aulas/grade-v2/` com slides/ + evidence/ + exports/ + qa-rounds/ + variants/ + CLAUDE.md + _manifest.js 18 slots.
3. **P0c — qa-pipeline v2 Gate 0+1 (C7)** — `content/aulas/scripts/qa-pipeline/` com gate0-local + gate1-flash + shared utilities + prompts.
4. **P0.5 — QA editorial metanalise** — 16 slides pendentes (3/19 done), paralelo quando bandwidth permitir + qa-pipeline v2 operacional.
5. **P1 sub** — R3 infra + Anki cards (deferred pós-30/abr).

**Deadline grade-v2:** 30/abr/2026 quinta-feira. Hoje T-9d.

**Bloqueadores cruzados:**
- P0a bloqueia validação completa de shared-v2 (scaleDeck bug elimination via presenter-safe.js).
- P0b consome shared-v2 (precisa Day 2 done).
- P0c pode rodar paralelo a P0b após Gate 0+1 validados.
```

Plus update L5 counts: still `Next #=55` (no new items added), `P0=3` (matches items).

### Commit 3 — docs refresh

```bash
git add HANDOFF.md CHANGELOG.md .claude/BACKLOG.md
git commit -F- <<'EOF'
docs(S237): HANDOFF + CHANGELOG + BACKLOG refresh pós-C4

HANDOFF.md: estado mid-execution S237 (C1-C4 done, C5 próximo, T-9d deadline).
§P0 reflete shared-v2 Day 2 + grade-v2 scaffold + qa-pipeline v2 como trabalho
em ordem canônica.

CHANGELOG.md §Sessao 237 expansion: C1 state refresh + C2 grade-v1 archive + C3
ADRs + C4 shared-v2 Day 1 + chore archive plan file + docs refresh.
Aprendizados consolidados 5 li.

BACKLOG.md §P0 refresh: P0a C5 + P0b C6 + P0c C7 numerados com bloqueadores
cruzados declarados.

Co-authored-by: Claude Opus 4.7 (Claude Code) <noreply@anthropic.com>
EOF
```

### Final verification

```bash
git log --oneline -7
# Expected sequence:
# [hash3] docs(S237): HANDOFF + CHANGELOG + BACKLOG refresh pós-C4
# [hash2] chore(S237): archive plan file foamy-wiggling-hartmanis
# [hash1] S237 C4: shared-v2 Day 1 — tokens (pre-existing) + type + layout + entry + mocks
# 8e8eb28 S237 Commit 3: ADR-0004 (grade-v1 archived) + ADR-0005 (shared-v2 greenfield)
# 939c847 S237 Commit 2: grade-v1 archive — ...
# e361520 S237 Commit 1: state docs refresh — ...
# 2e04cae docs: S236 close — ...
```

Kill Vite server (if Lucas hasn't already):
```bash
powershell.exe -NoProfile -Command "Get-NetTCPConnection -LocalPort 4103 -State Listen -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id \$_.OwningProcess -Force }"
```

TaskUpdate C4 → completed. Create C4.5 placeholder (se Codex achar issues). C5 permanece pending.

### Baton pass report

```
C4 closed. 3 commits no HEAD:
- [hash1] S237 C4: shared-v2 Day 1
- [hash2] chore(S237): archive plan file
- [hash3] docs(S237): HANDOFF + CHANGELOG + BACKLOG refresh

Ready for:
1. Codex CLI adversarial review (Lucas inicia sessão paralela com prompt Opus.ai entregou).
2. Pausa. Amanhã Lucas + nova janela Opus.ai reidratam via HANDOFF.md para C5 Day 2 com ensaio HDMI residencial.

Task tracking: C4 marcado done. C5 próximo item in-queue.
```

## Regras duras para execução (quando Lucas aprovar)

- **Não inicie C5** após os 3 commits. Pausa obrigatória.
- **Não responda achados Codex hoje.** Codex produz relatório em sessão paralela; Lucas filtra; Claude Code amanhã aplica achados válidos como hotfix C4.5 ou entra em C5.
- **Se visual Lucas falhar**, STOP antes de Commit 1, reporta, decide hotfix pré-commit vs adiar para amanhã.
- **Se algum step de git falhar**, STOP, anti-drift §Failure response.

## Context budget

Context atual ~50%. Execução dos 3 commits + docs + report deve consumir ~10-15% adicional. Deixar janela para amanhã recuperar via HANDOFF.md reidratação.

## Ordem de execução final

1. [Lucas] Visual validation via browser (5 min, hero + evidence mocks)
2. [Lucas] OK commit ou reporta hotfix needed
3. [Claude Code] Se hotfix: aplica minimal fix + retorna ao passo 2
4. [Claude Code] Commit 1 C4
5. [Claude Code] Commit 2 chore archive plan
6. [Claude Code] Write HANDOFF.md overwrite + Edit CHANGELOG §S237 expansion + Edit BACKLOG §P0 refresh
7. [Claude Code] Commit 3 docs
8. [Claude Code] git log --oneline -7 verify + kill Vite background + TaskUpdate C4 completed
9. [Claude Code] Baton pass report final
10. [Lucas] Inicia Codex CLI adversarial review em sessão paralela (fora Claude Code)
11. [Lucas] Sleep 😴
12. [Amanhã] Reidratação nova janela Opus.ai + Claude Code via HANDOFF.md
