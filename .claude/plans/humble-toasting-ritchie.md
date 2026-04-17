# humble-toasting-ritchie — Context Melt Root Cause Fix

> Sessao 220 | 2026-04-16 | Opus 4.7
> Gates proud-drifting-sunbeam.md B2 (/dream Phase 2.6) ate fix aprovado.

## Context

S219 fechou em ~1h30min com contexto em 74% apos /clear. Lucas listou 4 hipoteses
a validar antes de retomar B2 (que invoca /dream — candidato primario ao leak).
Este plano documenta audit read-only (~10min), ranqueia causas por bytes medidos,
e propoe fixes em micro-batches com STOP + OK (KBP-22/23 ativos).

## Phase 1 — Evidence (read-only audit concluido)

### Bytes medidos por fonte

| # | Fonte | Size | Frequencia | Cost/sessao | Observacao |
|---|-------|------|------------|-------------|------------|
| 1 | `/dream` SKILL.md inline load | **~20KB** (519 li) | por invocacao | **~20KB × N** | Wc -l: `/c/Users/lucas/.claude/skills/dream/SKILL.md 519` |
| 2 | `claudeMd` auto-load (CLAUDE.md + anti-drift + KBP) | ~8KB | cada /clear | ~8KB | 3 arquivos, ~185 li combinados |
| 3 | Available skills listing (~40 skills) | ~5KB | cada /clear | ~5KB | Platform-controlled |
| 4 | `session-start.sh` (boilerplate + HANDOFF.md full) | ~4KB | 1× | ~4KB | HANDOFF 88 li (`hooks/session-start.sh:32`) |
| 5 | Deferred tools listing (~80 tools) | ~3KB | cada /clear | ~3KB | Platform-controlled |
| 6 | `systematic-debugging` SKILL.md | ~10KB (256 li) | por invocacao | ~10KB | Invocado nesta sessao |
| 7 | MCP instructions (SCite etc) | ~2KB | cada /clear | ~2KB | Server-provided |
| 8 | `apl-cache-refresh.sh` STUCK list (14 items) | ~2KB | 1× | ~2KB | `hooks/apl-cache-refresh.sh:236` (unbounded) |
| 9 | Codex agent returns (4 parallel) | ~8KB | one-shot | **0 (mitigado)** | B1.5 externalizou para S220-codex-adversarial-report.md |
| 10 | APL per-turn (ambient-pulse + nudge-commit) | ~0.3KB | por turn | ~15KB @ 50 turns | Rotativo, cooldown 15min em nudge-commit |

### Baseline /clear fresh (um-shot): ~24KB system-reminders + 24KB state + skills-under-demand

### Lucas observation (S220 live): **13% baseline → 40-50% apos PRIMEIRA resposta**

13% de 200k = ~26k tokens (coerente com ~100KB auto-loads).
Jump de 27-37% na 1a resposta = ~54-74KB em **uma** troca.
Decomposicao estimada (meu audit atual como exemplo):

| Causa da primeira troca | Bytes |
|-------------------------|-------|
| Skill invocation `systematic-debugging` body | ~10KB |
| ToolSearch schemas (EnterPlanMode+TaskCreate) | ~4KB |
| 5× Read retornando (settings+README+hooks+HANDOFF) | ~35KB |
| Analise textual + tool-calls metadata | ~5KB |
| **Total primeira troca** | **~54KB (~27% jump)** |

Isso alinha com os 40-50% observados. Primeira troca explode porque skill+reads+schemas carregam simultaneamente.

## Phase 2 — Root Cause Ranking

**Primary (confirmado — hipotese 1 Lucas):** `/dream` skill em 519 linhas (~20KB)
carrega INLINE no contexto quando invocado via Skill tool. Pattern mismatch:
trabalho operacional (scan transcripts + consolidate memoria) esta implementado
como skill (body carrega) ao inves de agent dispatch (retorna report compacto).

**Secondary (confirmado — hipotese ausente):** STUCK list em `apl-cache-refresh.sh:236`
emite TODOS os itens com count >= 3 sem cap. Em S220: 14 itens × ~60 chars = ~2KB
line unica. Unbounded growth a cada sessao que nao resolve pendentes.

**Tertiary (confirmado — hipotese 4):** Session-start `claudeMd` + skills listing +
deferred tools somam ~21KB one-shot por /clear. Platform-controlled — so trim
possivel, nao defer.

**Not confirmed (hipotese 2 Lucas invalidada):** APL per-turn hooks custam ~0.3KB
por turn. Em 50 turns isso e 15KB cumulativo — moderate mas nao dominante.
Nudge-commit tem cooldown 900s. Momentum-brake-clear e silencioso.

**Already mitigated (hipotese 3 Lucas):** Codex agent returns externalizados em
B1.5 para `S220-codex-adversarial-report.md`.

## Phase 3 — Proposed Fixes (ranked por bytes saved)

### F1 — /dream → agent dispatch (BIGGEST WIN, ~20KB → ~1KB)

- Criar `.claude/agents/dream-agent.md` (Sonnet, tools: Read/Grep/Glob/Write)
- Agent recebe: transcript path(s) + memory dir. Executa scan+consolidate.
  Retorna report JSON (mudancas propostas) — NAO carrega skill body.
- Reduzir `~/.claude/skills/dream/SKILL.md` para ~30 li dispatcher:
  "Invoke dream-agent via Agent tool, await report, apply changes."
- Pattern ref: `codex:rescue` (agent-dispatch existente, proven).
- **Savings: ~19KB por invocacao (20× reducao)**
- Impact: B2 de proud-drifting-sunbeam.md torna-se viavel sem context burn.
- Estimated: 40min (implement + verify + test /dream 1×).

### F2 — Cap STUCK list a top 5 (quick win, ~1.5KB)

- Edit `hooks/apl-cache-refresh.sh` linha 62-91 ou linha 236 final.
- Slice STUCK_ALERTS a 5 entries + sufixo `(+N more in stuck-counts.tsv)` se >5.
- **Savings: ~1.5KB por session-start**
- Tradeoff: zero — stuck-counts.tsv persiste full data.
- Estimated: 5min.

### F3 — Trim HANDOFF auto-dump em session-start (~1.5-2KB)

- Edit `hooks/session-start.sh` linha 32.
- Substituir `cat HANDOFF.md` por `head -40` (ESTADO + PENDENTES primarios).
- Adicionar pointer: `(HANDOFF.md completo disponivel via Read quando precisar)`.
- **Savings: ~1.5-2KB por session-start**
- Tradeoff: 1 Read call extra se precisar DECISOES/CUIDADOS (raro na maioria dos turns iniciais).
- Estimated: 10min.

### F4 — systematic-debugging → agent dispatch (~9KB quando invocado)

- Repetir pattern F1 para `superpowers:systematic-debugging` (256 li, ~10KB).
- **Savings: ~9KB por invocacao**
- Aplicar apos F1 validar pattern + aprovacao explicita (plugin skill = cuidado extra).
- Estimated: 20min (ou defer a S221 se F1 ja der ganho suficiente).

### F5 — First-turn discipline (behavioral, nao code) — NEW apos feedback Lucas

Ataca o **jump de 27-37% na primeira resposta** (observado S220 live).
Nao e code change — e regra para adicionar a `.claude/rules/anti-drift.md`:

- **Read com `limit`:** para arquivos >100 li, usar `limit: 50` primeiro. Expand so quando precisa.
  Evita carregar arquivos inteiros como `settings.local.json` (403 li) em audit exploratorio.
- **Skill invocation gate:** skills pesadas (>100 li: systematic-debugging, /dream, brainstorming)
  so invocar quando task EXPLICITAMENTE requer o framework. Audits read-only podem usar logica direta.
- **ToolSearch batch:** carregar schemas so das tools que VAO ser chamadas. Evitar prefetch.
- **Agent dispatch prefer:** se task envolve 3+ Read + 2+ Grep em area ampla, delegar a
  Explore/general-purpose agent. Agent returns compact report (~2KB) vs 30-50KB de raw reads.

Savings: **~20-30KB na primeira resposta** (maior que qualquer fix sozinho).
Estimated: 10min (editar anti-drift.md + 1 KBP).

## Non-goals

- Trimar CLAUDE.md / rules alem do atual — ja KBP-16 pointer-only. Trim extra prejudica signal/noise.
- Disable APL — baixo custo por turn + valor real (commit reminders, deadline).
- Atacar hook issues #1-10 do Codex Batch 1 alem de escopo context-melt → S221.
- Consolidar memoria files (10 candidatos Codex Batch 2) → S221.

## Verification (apos cada fix)

1. Start fresh session → /clear.
2. Capturar ctx% baseline no statusline (ja persistido em `apl/ctx-pct.txt`).
3. Executar trigger do fix (F1: invoke /dream; F2: comparar startup lines; F3: inspect session-start output).
4. Capturar ctx% delta.
5. Reportar bytes saved medidos vs estimados.
6. Persistir resultado em `metrics.tsv` (coluna ctx_pct_max ja existe).

## Implementation order (micro-batches, STOP + OK cada)

| Batch | Fix | Tempo | Risk | STOP apos |
|-------|-----|-------|------|-----------|
| **C1** | F5 (first-turn discipline — rules edit) | 10min | LOW — doc-only | Lucas le + aprova KBP novo |
| **C2** | F2 (cap STUCK) | 5min | LOW — pure output cap | measure line delta |
| **C3** | F3 (trim HANDOFF) | 10min | LOW-MED — truncation pode esconder contexto | inspect session-start output |
| **C4** | F1 (/dream agent) | 40min | MED — novo agent + skill refactor | test /dream 1× + ctx% delta |
| **C5** | F4 (systematic-debug agent) | 20min | MED-HIGH — plugin skill | defer ate Lucas decidir |

**Ordem priorizada por savings/effort:** F5 primeiro (biggest immediate savings sem code),
depois quick wins F2/F3, depois refactor F1 que desbloqueia B2.

Apos C4 aprovado → proud-drifting-sunbeam.md B2 desbloqueado (originalmente `/dream Phase 2.6`).

**Total: ~85min se full sequence. Pode parar em qualquer C sem estado ruim.**

## Critical files

- `hooks/apl-cache-refresh.sh` (F2): linha ~62-91 loop STUCK, linha 236 emit.
- `hooks/session-start.sh` (F3): linha 32 `cat HANDOFF.md`.
- `.claude/agents/dream-agent.md` (F1): novo arquivo.
- `~/.claude/skills/dream/SKILL.md` (F1): reducao 519 → ~30 li.
- `.claude/plans/proud-drifting-sunbeam.md` B2: desbloqueado pos-C3.

## Reuse references

- `codex:codex-rescue` agent pattern — `.claude/agents/` existing precedent (9 agentes).
- `~/.claude/skills/wiki-query/SKILL.md` (148 li) — skill compacta bem-dimensionada como referencia.

---
Coautoria: Lucas + Opus 4.7 | S220 2026-04-16
