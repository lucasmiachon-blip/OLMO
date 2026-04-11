# INFRA_3 — Reduzir auto-load (adversarial + macro)

> Lucas + Opus 4.6 | S156 2026-04-11
> Frame: ADVERSARIAL. Pressupor que S155 fixes nao corrigiram o que reclamavam corrigir.
> Opus profissional decide. Lucas iniciante valida se quiser mas default = execute.

## Context (por que)

S155 fez INFRA-PESADO (3 Gemini + 2 Codex adversarial dedup). Lucas relata que o objetivo era **reduzir auto-load** mas a percepcao e que **inflou**. Tres artefatos chegam a esta sessao:

1. **Os 45 findings brutos** (G1/G3/C1) em `.claude/tmp/` — parcialmente acionados em S155, parcialmente deferidos
2. **Conversa Claude.ai** sobre meta-KBP, 7 padroes LLMOps degradation (verbosity bias, context padding, sycophantic elaboration, unbounded generation, prompt dilution, context bloat, auto-regressive drift), e 2 prompts operacionais
3. **Sensacao subjetiva do Lucas** de que o sistema inflou

O job desta sessao e **verificar mecanicamente** + executar compactacao honesta + **ancorar estruturalmente** contra re-inflacao. Adversarial = pushback com evidencia, nao concordar com tudo.

## Baseline verificado (wc + git show)

**Auto-load files (globs: "**/*", sempre no prompt inicial):**

| Arquivo | Bytes | Tokens (~) |
|---|---|---|
| anti-drift.md | 8,341 | 2,085 |
| known-bad-patterns.md | 8,095 | 2,024 |
| HANDOFF.md | 6,970 | 1,743 |
| CLAUDE.md (project) | 3,075 | 769 |
| session-hygiene.md | 2,958 | 740 |
| multi-window.md | 1,712 | 428 |
| coauthorship.md | 777 | 194 |
| **TOTAL rules+CLAUDE+HANDOFF** | **31,928** | **~7,982** |

**Os 3 maiores (anti-drift + KBPs + HANDOFF) = 73% do auto-load rules.** Compactacao fora desses 3 tem ROI marginal.

## Verificacao adversarial da reclamacao ("inflou")

Git show de cada commit S155:

| Commit | Target | Delta auto-load real |
|---|---|---|
| e3e88f2 | plan file (+155 LOC) | **0** (plans dir nao e auto-loaded) |
| f3ba682 | 15 skill+agent descriptions | **-1,800 tokens** |
| 310b547 | multi-window.md | **-25 tokens** |
| 4ba7697 (wrap) | KBP-15 +275 + HANDOFF +625 | **+900 tokens** |
| **NET S155** | | **~-900 tokens** (reducao) |

**Veredicto:** percepcao de "inflou" parcialmente errada. S155 reduziu ~900 tokens no liquido. MAS duas coisas inflaram visivelmente (HANDOFF +625, KBP-15 +275 — o KBP sobre verbosity e o mais longo do arquivo, meta-ironia). Lucas viu o inflar, nao a economia em 15 arquivos distantes.

## Raiz do problema real

**known-bad-patterns.md contem drift interno de formato.** KBP-01 a 05 + 07 sao compact (~170 chars, pointer-style). KBP-06 + 08-15 sao inflated (avg ~710 chars, Fix/Evidencia inline). A disciplina de "pointer-only" degradou silenciosamente ao longo de 20 sessoes.

**Mecanismo subjacente (LLMOps):** verbosity bias + context padding — cada /insights adicionou prose "para clareza" sem checar se o pointer target ja cobria.

**Decisao: Formato C+ (minimo absoluto).**

```
## KBP-NN Name
→ pointer.md §section
```

Prose vive no pointer target. Lucas quotes + Trigger + Cause forense persistem em `git history` + `CHANGELOG.md` (append-only). `git log -S "calma/pare/espere"` resolve forense.

**Ponteiros decididos para KBPs sem pointer:**
- KBP-06 (Agent Delegation): → `feedback_agent_delegation.md` (memory file existente)
- KBP-08 (API/MCP Substitution): → `evidence-researcher SKILL.md §Step 2`

## Correcao adversarial dos 2 prompts Claude.ai

**Prompt 1 (KBP compaction) — bugs corrigidos:**
- ✗ "KBP-06 a KBP-15" incluia KBP-07 que ja e compact → plan pula KBP-07
- ✗ "KBP-06 → §Failure response" wrong target (KBP-06 e sobre agent delegation, nao failure) → plan usa feedback_agent_delegation.md
- ✓ Logica central certa

**Prompt 2 (settings.local.json collapse) — goal misalignment nomeada:**
- settings.local.json **nao e auto-loaded como prompt context** (e JSON config runtime). Reduz runtime permission surface, nao auto-load tokens. **Metrica diferente do Prompt 1, ambas validas.**
- C1 #1 aconselhou remover Bash(*). S155 deferiu A1 (policy: keep Bash(*) para friction). Prompt 2 consistente com policy. OK.

## Plano de execucao

### Commit 1 — known-bad-patterns.md compaction + NEW KBP-16 (anti-re-inflation anchor)

**Target:** TODOS os 15 KBPs → Formato C+ (name + pointer only) + ADD KBP-16 (meta-KBP).

**Processo:**
1. Para cada KBP (01-15): manter `## KBP-NN Name` + `→ pointer.md §section`; remover Trigger/Lucas/Cause/Fix/Evidencia inline
2. KBP-06 caso especial: ler memory file durante execucao e confirmar cobertura de "verify agent type/output before launch"; se gap → extensao minima out-of-repo
3. KBP-15 (meta-ironia): pointer → `feedback_tool_permissions.md §Write race`
4. **ADD KBP-16 Verbosity Drift in Auto-Loaded Docs** → `anti-drift.md §Pointer-only discipline` (criado em Commit 3). Este KBP e o trigger point contra futuras KBP-17+ infladas.
5. Preserve: frontmatter, header, citacao Taleb. Update "Next: KBP-17".
6. Write tool (full rewrite do arquivo — mais limpo que Edit block-a-block)
7. Verificacao: `wc -c` + `grep -c '^## KBP-'` = 16 + `grep -c '^→' ` = 16

**ROI:**
- Before: 8,095 B
- After: ~1,750 B (16 × ~80 + header ~450)
- **Savings: ~6,345 B = ~1,586 tokens de auto-load (78% reducao)**

**Risk:** baixo. Reversivel via `git revert`. Forense preservado em git history + CHANGELOG.

### Commit 2 — settings.local.json wildcard collapse + MCP wildcards (decisao incluida)

**Target:** 35 redundant entries removidas + 10 MCP specifics consolidados em 3 wildcards. Final: 26 entries (vs 68 atual).

**Decisao Opus (Lucas delegou "vc decide" + "allow generico nao especifico"):** INCLUIR MCP wildcards como extension. Consistente com intent. Risk minimo — MCPs ja usados ativamente.

**Processo (KBP-15 compliance):**
1. Backup: `cp .claude/settings.local.json .claude/tmp/backup-pre-infra3-settings.json`
2. **Write tool path canonico** (NUNCA script externo)
3. Preservar: env, deny, hooks, statusLine, plansDirectory
4. Rewrite permissions.allow → 26 entries:
   - 3 wildcards base: Bash(*), WebSearch(*), WebFetch(*)
   - 10 tool names: Read, Glob, Grep, ExitPlanMode, EnterPlanMode, Agent, ToolSearch, TaskCreate, TaskUpdate, TaskList
   - 3 MCP wildcards claude.ai: mcp__claude_ai_PubMed__*, mcp__claude_ai_Consensus__*, mcp__claude_ai_SCite__*
   - 3 MCP wildcards direct (NEW): mcp__pubmed__*, mcp__biomcp__*, mcp__crossref__*
   - 7 Skills: Skill(research), Skill(codex:rescue), Skill(dream), Skill(wiki-lint), Skill(insights), Skill(brainstorming), Skill(wiki-query)
5. Verificacao: `jq .` shape valid + `jq '.permissions.allow | length'` = 26

**ROI:** runtime permission surface -62% (68→26). Cognitive load ao ler manualmente. **Nao reduz tokens auto-load** (settings.local.json nao e auto-loaded).

**Risk:** medio. gitignored → backup em `.claude/tmp/` e rede de seguranca.

### Commit 3 — anti-drift.md ADD §Pointer-only discipline (STRUCTURAL ANCHOR)

**Target:** ADICIONAR nova secao a anti-drift.md que ancora enforcement contra re-inflacao.

**Por que este commit e essencial:** sem anchor estrutural, Commits 1+4 sao one-shot wins e re-drift acontece em S157+. Com o anchor, cada nova KBP/rule e gated pela regra via KBP-16 trigger.

**Conteudo novo (~400 B, siga sua propria regra — curto):**

```markdown
## Pointer-only discipline (auto-loaded docs)

Auto-loaded docs (rules/, CLAUDE.md, HANDOFF) usam Formato C+:
`## Item Name` + `→ pointer.md §section`. Prose vive no pointer target.

Underlying LLMOps degradation patterns: verbosity bias, context padding,
sycophantic elaboration, unbounded generation, prompt dilution, context
bloat, auto-regressive drift. Cada um empurra docs para prose inline.

Trigger: adicionar KBP/rule com Fix/Evidencia/Trigger inline = violacao.
Forense (quotes, evidence) vive em git history + CHANGELOG.md (append-only).
Enforcement: KBP-16 em known-bad-patterns.md aponta para esta secao.
```

**Processo:**
1. Read anti-drift.md (ja feito)
2. Edit tool: inserir nova secao apos §Script Primacy (topic alinhado)
3. Verificacao: `grep -c 'Pointer-only' anti-drift.md` = 1

**ROI:**
- Before: 8,341 B
- After: ~8,741 B (+400 B)
- **Cost: +100 tokens AGORA para impedir re-drift de ~1,800 tokens ao longo de 20 sessoes futuras.**
- **Break-even:** imediato apos 1 sessao que tentar adicionar KBP-17 inflado.

**Risk:** baixo.

### Commit 4 — HANDOFF.md compaction + BACKLOG.md extraction

**Target:** HANDOFF 94 linhas / 6,970 B → ~50 linhas / ~3,500 B (conforme session-hygiene.md, agora com teeth via KBP-16).

**Processo:**
1. Extract BACKLOG table → novo `.claude/BACKLOG.md` (nao auto-loaded, consultado on-demand)
2. Comprimir P0: so titulo + 1 linha acao + pointer CHANGELOG/evidence
3. Comprimir DECISOES ATIVAS: so decisoes com impacto ativo (historico → CHANGELOG)
4. Preservar: ESTADO ATUAL (counts), CUIDADOS (hard constraints), CONFLITOS
5. Update header: S156 2026-04-11
6. Edit/Write tool
7. Verificacao: `wc -l HANDOFF.md` ≤ 50 + `wc -c HANDOFF.md` ≤ 3,600 + `test -f .claude/BACKLOG.md`

**ROI:**
- Before: 6,970 B
- After: ~3,500 B
- **Savings: ~3,470 B = ~867 tokens auto-load**

**Side effect:** `.claude/BACKLOG.md` criado — 11 items persistentes. Convencao: gitignored primeiro (Lucas decide se git add depois).

**Risk:** medio. HANDOFF e o file mais consultado. Mas KBP-16 + Commit 3 previnem re-inflacao.

## ROI Total (auto-load tokens)

| Commit | Before | After | Delta |
|---|---|---|---|
| Commit 1 (known-bad-patterns.md + KBP-16) | 8,095 B | ~1,750 B | **-1,586 tokens** |
| Commit 2 (settings.local.json) | — | — | runtime, nao tokens |
| Commit 3 (anti-drift.md +secao) | 8,341 B | ~8,741 B | **+100 tokens** |
| Commit 4 (HANDOFF.md + BACKLOG.md) | 6,970 B | ~3,500 B | **-867 tokens** |
| **NET auto-load** | | | **-2,353 tokens (~20% do baseline ~12K tokens session-start)** |

## Files a modificar

- `C:\Dev\Projetos\OLMO\.claude\rules\known-bad-patterns.md` (Commit 1, Write tool)
- `C:\Dev\Projetos\OLMO\.claude\settings.local.json` (Commit 2, Write tool per KBP-15)
- `C:\Dev\Projetos\OLMO\.claude\rules\anti-drift.md` (Commit 3, Edit tool — ADD secao)
- `C:\Dev\Projetos\OLMO\HANDOFF.md` (Commit 4, Write tool)
- `C:\Dev\Projetos\OLMO\.claude\BACKLOG.md` (Commit 4, Write tool — NEW file)

## Files NAO modificados (firewall explicito)

- `content/aulas/**` — Lucas working area
- `.claude/rules/slide-*.md` — Lucas working area
- `CHANGELOG.md` — append-only, nao auto-loaded (append ao final do wrap)
- `.claude/plans/archive/*` — historico
- Memory files (out-of-repo) exceto extensao minima de feedback_agent_delegation.md se KBP-06 target gap

## Verification plan

**Pre-execution baseline:**
```
wc -c .claude/rules/known-bad-patterns.md .claude/rules/anti-drift.md HANDOFF.md
jq '.permissions.allow | length' .claude/settings.local.json
```

**Post-Commit 1:** `wc -c` ~1,750 B + `grep -c '^## KBP-'` = 16

**Post-Commit 2:** `jq .` valid + `jq '.permissions.allow | length'` = 26

**Post-Commit 3:** `grep -c 'Pointer-only' anti-drift.md` = 1

**Post-Commit 4:** `wc -l HANDOFF.md` ≤ 50 + `test -f .claude/BACKLOG.md`

**Adversarial self-check (fresh session):** reducao >= 2,300 tokens vs pre-S156 baseline = sucesso.

## Adversarial catches

1. **S155 nao inflou no liquido.** Reduziu ~900 tokens. Percepcao dispensada por HANDOFF +625 e KBP-15 +275 visiveis.
2. **KBP-15 e self-consuming** — KBP sobre verbosity e o mais verboso do arquivo.
3. **Prompt 1 Claude.ai tem 2 bugs** corrigidos no plan (KBP-07 ja compact, KBP-06 wrong target).
4. **Prompt 2 nao reduz auto-load** — reduz runtime permission surface (metrica diferente).
5. **C1 #1 vs Prompt 2** — resolvido via policy S155 (keep Bash(*)).
6. **Commits 1+4 sozinhos sao cosmeticos** — re-inflam em S157+. **Commit 3 e o anchor estrutural** que paga pelo proprio custo (+100 tokens) apos 1 sessao impedida de drift. Por isso esta no plan.
7. **Macro plan coberto:** meta-KBP = KBP-16, 7 LLMOps patterns = anti-drift §Pointer-only discipline, 2 prompts = Commits 1+2. Nada do Claude.ai paste ficou de fora.

## Out of scope

- anti-drift.md rewrite (so ADICAO, nao compactacao)
- Adicionar wildcards alem dos 3 MCP (Skill(*), etc) — nao pedido
- Criar kbp-archive.md — YAGNI
- Slide rules/patterns drift (backlog #9)
- Memory files out-of-repo (exceto KBP-06 target gap)

## Estimated total

**~45-75 min.** Commit 1 ~20-30 / Commit 2 ~10-15 / Commit 3 ~5-10 / Commit 4 ~15-20 / Wrap ~5.

## Wrap protocol (apos 4 commits)

1. CHANGELOG append: 1 linha por commit + link ao plan arquivado
2. HANDOFF ja compactado no Commit 4 — update session header + P0 items remanescentes
3. Plan file → `.claude/plans/archive/S156-rippling-coalescing-codd.md`
4. Session wrap message: commits + ROI verified + break-even logic
