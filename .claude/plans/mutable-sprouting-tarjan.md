# Plan: mutable-sprouting-tarjan — S230 Phase G HIPERGRANULAR (PAUSED-RESUMABLE)

> **Session:** 230 (`bubbly-forging-cat`) — Phase G in progress, PAUSED 2026-04-19 ~13:15
> **Resume entrypoint:** Read este file inteiro + HANDOFF.md "PAUSED" section + git log -10
> **Próxima fase a executar:** G.9 (banner lib) — see Phase G.9 section

---

## RESUME CHECKLIST (primeira coisa a fazer ao retomar)

```bash
# 1. Verify state intact
git log --oneline -10                                    # último: "S230 Phase G.1: /insights restoration"
git status --short                                       # esperado: limpo
ls -la .claude/plans/mutable-sprouting-tarjan.md         # este arquivo

# 2. Verify decisions context
cat .claude/.session-name                                # "bubbly-forging-cat"
cat .claude/.last-insights                               # epoch ~1776615003 (Apr 19 ~13:00)

# 3. Read findings (already saved)
head -50 .claude/skills/insights/references/latest-report.md  # report S230 - 6 propostas

# 4. Confirm tasks state via TaskList — but TaskList resets per session
# Use this plan as canonical task source (Phase G.x sections)
```

---

## CONTEXT (compressed)

Pós-Phase F (doc sweep), Lucas perguntou "como sabemos que estamos melhorando?". Auditoria revelou múltiplas instâncias de **metrics teatro** análogas ao ModelRouter teatro deletado em Phase D:

- `metrics.tsv` stale 7 sessões (S224-S230) por bug regex SESSION_NUM
- Momentum brake nunca dispara (Bash blanket exempt = ~99% tool calls passam)
- KPI Reflection Loop fires raramente (200-call interval; sessões curtas nunca atingem)
- Cost circuit breaker BLOCK threshold (400 calls) nunca disparado em sessões reais
- `/insights` skill last run Apr 8 → restored Phase G.1 (Apr 19, commit 2634c0c)

**Critério decisório (Lucas):** "definir se são métricas úteis ou vanity". Critério aplicado: **métrica é ÚTIL se já moveu pelo menos 1 decisão nas últimas 5 sessões**, VANITY se nunca foi consultada.

**Diretivas Lucas adicionais (post-G.1):**
- Banner system 6 níveis semânticos (verde/cyan/amarelo/laranja/vermelho/magenta)
- Tamanho uniforme 4-5 linhas (verde = 1 li exceção)
- /insights periodicidade **bi-diária** (a cada 2 dias, não semanal — semanal "fica muita coisa")
- Visuals chamativos NÃO só para anti-meta-loop, mas para "outros momentos importantes"
- Brake (G.4) NÃO decidir delete sem investigar se é útil-subutilizado

---

## ESTADO ATUAL EXATO (snapshot 2026-04-19 ~13:15)

### Commits desta sessão S230 (12 total — atualizado 2026-04-19 ~15:15)
```
a8a87be S230 Phase G.9b: doc fix — canonical deploy pattern obsoleto por KBP-26
44f8751 S230 Phase G.9: banner.sh lib — 6 niveis semanticos
4446ee8 S230 Phase G PAUSE: hipergranular plan + HANDOFF resume entrypoint
479a5ef S230 Phase F: full doc sweep — refresh Estado markers + tests count
8ba190b S230 close: bubbly-forging-cat — 4 batches complete (5+6 deferred)
378499f S230 Batch 3c: delete ModelRouter teatro (BACKLOG #42 RESOLVED)
100b85f S230 Batch 3b: delete SmartScheduler + skills/ orphan cascade
0d432c6 S230 Batch 3a: ecosystem.yaml scope clarified
fcd4bdc S230 Batch 4: plans audit (S225 archive + S227 header refresh)
104cdbd S230 Batch 2: memory de-duplication + canonical owners (pre-session)
46ae0ce S230 Batch 1: reconcile docs with filesystem reality (pre-session)
2634c0c S230 Phase G.1: /insights restoration — first run after 11d gap
```

### Files modificados/criados Phase G.1 (already committed in 2634c0c)
- `.claude/skills/insights/references/latest-report.md` (264 ins, 79 dels) — full S230 report
- `.claude/insights/failure-registry.json` (NEW)
- `.claude/.last-insights` (timestamp updated, gitignored?)

### Decisões tomadas (canonical record)

| Decisão | Status | Rationale |
|---|---|---|
| Phase G.4 momentum brake | PENDING — investigar útil vs subutilizado | Lucas: zero firings ≠ delete sem investigation |
| Phase G.7 KBP-23 hook enforcement | APPROVED | 27 violations em 11d evidência clara |
| Phase G.8 anti-meta-loop banner | APPROVED | 5 sessões sem aulas/ = R3 risk |
| Phase G.9 banner system 6 níveis | APPROVED | Sistema unificado para todos eventos importantes |
| Banner sizes | 3-4 li (Lucas S230 revised de 4-5), verde=1 li | Lucas explicit |
| /insights periodicity | bi-diária (a cada 2d) | Lucas: semanal "fica muita coisa" |
| Edit hooks/ pattern | Write→temp→`cat source > dest` (cp em deny S227 KBP-26) | guard-write-unified.sh:120-124 BLOCK + settings.json deny Bash(cp *) |

### Tasks tracking (manual — TaskList resets per session)

| ID | Phase | Status | Files modified |
|----|-------|--------|----|
| 7 | G.1 /insights run | ✅ DONE 2634c0c | latest-report.md, failure-registry.json |
| 15 | G.9 banner lib | ✅ DONE 44f8751 + a8a87be (doc fix) | hooks/lib/banner.sh (NEW, 74 li) |
| 13 | G.7 KBP-23 enforce | ✅ DONE (pending SHA) | hooks/post-tool-use-failure.sh (36→42 li, +6) |
| 14 | G.8 anti-meta banner | ✅ DONE (combined G.5) | hooks/session-start.sh (75→~100 li, +25) |
| 11 | G.5 /insights ritual | ✅ DONE (combined G.8) | hooks/session-start.sh |
| 8 | G.2 metrics regex fix | ✅ DONE (regex + 7 rows backfill S224-S230) | hooks/stop-metrics.sh + .claude/apl/metrics.tsv |
| 9 | G.3 slim VANITY | ⏳ NEXT | .claude/hooks/post-global-handler.sh |
| 10 | G.4 brake decision | ⏳ blocked (precisa investigation) | depends on G.4 outcome |
| 12 | G.6 session close | ⏳ last | HANDOFF.md, CHANGELOG.md, plan archive |

---

## PADRÃO Write→temp→deploy (aplicar a TODOS edits em hooks/)

> ⚠️ **S230 G.9 DESCOBERTA (2026-04-19):** pattern original `cp` obsoleto. `Bash(cp *)`, `Bash(mv *)`, `Bash(install *)`, `Bash(rsync *)`, `Bash(tee *)`, `Bash(sed -i*)` estão em `.claude/settings.json` deny list desde S227 (KBP-26 / BACKLOG #34 — 34 destructive deny patterns aplicadas quando `permissions.ask` quebrou em CC 2.1.113). Denial é automática, sem popup. Shell redirect (`>`) NÃO está em deny — só pede ask via `guard-bash-write.sh` Pattern 1 (line 36).

`guard-write-unified.sh:120-124` BLOCKS Edit/Write em `(\.claude/hooks|hooks)/.*\.sh$`.
**Solução atual (S230+):** escrever em path não-hook, depois shell redirect (`cat source > dest`).

### Steps padrão (para CADA hook editado)

```bash
# Step 1: Write conteúdo a path permitido
#   Use .claude/workers/{hookname}.sh.new — workers/ aceita .sh sem timestamp
#   (workers/ Guard 2a só exige timestamp para .md files)
Write(.claude/workers/{hookname}.sh.new, content)

# Step 2: Deploy via shell redirect (cp em deny, redirect só pede ask)
Bash("cat .claude/workers/{hookname}.sh.new > {path-real}/{hookname}.sh")

# Step 3: chmod +x (repo convention, mesmo pra sourced libs — sibling hook-log.sh tem +x)
Bash("chmod +x {path-real}/{hookname}.sh")

# Step 4: Cleanup fantasma workers (mandatory — Lucas explicit)
Bash("rm .claude/workers/{hookname}.sh.new")

# Step 5: Verify syntax no destino
Bash("bash -n {path-real}/{hookname}.sh && echo 'syntax ok'")
```

### Lista de 6 hooks a editar Phase G (= redirect + chmod + rm = 3 popups/hook)

| Hook destination | New file | Phase |
|---|---|---|
| `hooks/lib/banner.sh` | `.claude/workers/banner.sh.new` | G.9 |
| `hooks/post-tool-use-failure.sh` | `.claude/workers/post-tool-use-failure.sh.new` | G.7 |
| `hooks/session-start.sh` | `.claude/workers/session-start.sh.new` | G.5+G.8 (combinados) |
| `hooks/stop-metrics.sh` | `.claude/workers/stop-metrics.sh.new` | G.2 |
| `.claude/hooks/post-global-handler.sh` | `.claude/workers/post-global-handler.sh.new` | G.3 |
| `.claude/hooks/momentum-brake-{enforce,clear}.sh` | (G.4 outcome dependent — DELETE OR fix) | G.4 |

**Total popups esperados:** 6 hooks × 3 popups (redirect + chmod + rm) + verifications ≈ 18-21 popups Lucas (cada ~3-5 sec)

---

## BANNER SYSTEM 6 NÍVEIS — FULL SPEC (Phase G.9)

### Filosofia
- Cores semânticas por severidade (verde→magenta)
- Tamanho uniforme 4-5 li (impacto visual constante) — exceção verde 1 li
- Aplicável a TODOS eventos importantes via `hooks/lib/banner.sh` source

### ANSI escape codes reference

```bash
# Foreground
RESET="\033[0m"
BOLD="\033[1m"

# Background colors
BG_GREEN="\033[42m"       # 🟢 SUCCESS
BG_CYAN="\033[46m"        # 🔵 INFO
BG_YELLOW="\033[43m"      # 🟡 WARN
BG_ORANGE="\033[48;5;208m"  # 🟠 ATTN (256-color)
BG_RED="\033[41m"         # 🔴 CRITICAL
BG_MAGENTA="\033[45m"     # 🟣 DECISION

# Text colors
FG_BLACK="\033[30m"
FG_WHITE="\033[97m"
```

### Semântica + quando aplicar

| Nível | Cor | Quando | Tamanho |
|---|---|---|---|
| 🟢 SUCCESS | Verde | Commit clean, milestone, pytest 100% | 1 li |
| 🔵 INFO | Cyan | /insights bi-diário reminder, status routine | 4-5 li box |
| 🟡 WARN | Amarelo | nudge-commit 30min sem commit, ctx >70%, KBP single | 4-5 li box |
| 🟠 ATTN | Laranja | 3 sessões sem aulas/, KBP recurrent (3+ em sessão), brake fired | 4-5 li box |
| 🔴 CRITICAL | Vermelho | 5+ sessões avoidance, R3<100d, integrity violation, scope drift confirmado | 4-5 li box |
| 🟣 DECISION | Magenta | Lucas precisa escolher (estado ambíguo, decisão arquitetural) | 4-5 li box |

### Banner templates (exatos para implementação)

#### 🟢 SUCCESS (1 li)
```
echo -e "${BG_GREEN}${FG_BLACK}${BOLD} ✓ ${RESET}${BG_GREEN}${FG_BLACK} ${MSG}${RESET}"
```
Exemplo render: `[fundo verde] ✓ pytest 40/40 PASS · ruff clean · build_ecosystem ok`

#### 🔵 INFO (4-5 li)
```
echo -e "${BG_CYAN}${FG_BLACK}${BOLD}                                                          ${RESET}"
echo -e "${BG_CYAN}${FG_BLACK}${BOLD}  ℹ  ${TITLE}                                            ${RESET}"
echo -e "${BG_CYAN}${FG_BLACK}    ${LINE2}                                                    ${RESET}"
echo -e "${BG_CYAN}${FG_BLACK}    ${LINE3}                                                    ${RESET}"
echo -e "${BG_CYAN}${FG_BLACK}                                                                ${RESET}"
```

#### 🟡 WARN (4-5 li) — substitui nudge-commit atual
```
echo -e "${BG_YELLOW}${FG_BLACK}${BOLD}                                                          ${RESET}"
echo -e "${BG_YELLOW}${FG_BLACK}${BOLD}  ⚠  ${TITLE}                                            ${RESET}"
echo -e "${BG_YELLOW}${FG_BLACK}    ${LINE2}                                                    ${RESET}"
echo -e "${BG_YELLOW}${FG_BLACK}    ${LINE3}                                                    ${RESET}"
echo -e "${BG_YELLOW}${FG_BLACK}                                                                ${RESET}"
```

#### 🟠 ATTN (4-5 li) — anti-meta 3+ sessões
```
echo -e "${BG_ORANGE}${FG_WHITE}${BOLD}                                                          ${RESET}"
echo -e "${BG_ORANGE}${FG_WHITE}${BOLD}  ⚡ ATENCAO: ${TITLE}                                    ${RESET}"
echo -e "${BG_ORANGE}${FG_WHITE}    ${LINE2}                                                    ${RESET}"
echo -e "${BG_ORANGE}${FG_WHITE}    ${LINE3}                                                    ${RESET}"
echo -e "${BG_ORANGE}${FG_WHITE}                                                                ${RESET}"
```

#### 🔴 CRITICAL (4-5 li) — 5+ sessões OR R3<100d
```
echo -e "${BG_RED}${FG_WHITE}${BOLD}                                                            ${RESET}"
echo -e "${BG_RED}${FG_WHITE}${BOLD}  🚨 CRITICO: ${TITLE}                                      ${RESET}"
echo -e "${BG_RED}${FG_WHITE}${BOLD}     ${LINE2}                                               ${RESET}"
echo -e "${BG_RED}${FG_WHITE}${BOLD}     ${LINE3}                                               ${RESET}"
echo -e "${BG_RED}${FG_WHITE}${BOLD}                                                            ${RESET}"
```

#### 🟣 DECISION (4-5 li) — Lucas precisa decidir
```
echo -e "${BG_MAGENTA}${FG_WHITE}${BOLD}                                                          ${RESET}"
echo -e "${BG_MAGENTA}${FG_WHITE}${BOLD}  ❓ DECISAO: ${TITLE}                                   ${RESET}"
echo -e "${BG_MAGENTA}${FG_WHITE}    ${LINE2}                                                    ${RESET}"
echo -e "${BG_MAGENTA}${FG_WHITE}    ${LINE3}                                                    ${RESET}"
echo -e "${BG_MAGENTA}${FG_WHITE}                                                                ${RESET}"
```

### `hooks/lib/banner.sh` FULL SOURCE (copy-paste para `.claude/workers/banner.sh.new`)

```bash
#!/usr/bin/env bash
# banner.sh — Semantic banner library for OLMO hooks
# Source: . "$PROJECT_ROOT/hooks/lib/banner.sh"
# Usage: banner_warn "Title" "Line 2" "Line 3"
# Created: S230 Phase G.9 (bubbly-forging-cat)

# ANSI codes
readonly _RESET="\033[0m"
readonly _BOLD="\033[1m"
readonly _BG_GREEN="\033[42m"
readonly _BG_CYAN="\033[46m"
readonly _BG_YELLOW="\033[43m"
readonly _BG_ORANGE="\033[48;5;208m"
readonly _BG_RED="\033[41m"
readonly _BG_MAGENTA="\033[45m"
readonly _FG_BLACK="\033[30m"
readonly _FG_WHITE="\033[97m"

# Pad string to 60 chars (banner internal width)
_pad60() {
  local s="$1"
  printf "%-60s" "$s"
}

# 🟢 SUCCESS (1 line)
banner_success() {
  local msg="$1"
  printf '%b ✓ %s%b\n' "${_BG_GREEN}${_FG_BLACK}${_BOLD}" "$msg" "${_RESET}"
}

# 🔵 INFO (4-5 li)
banner_info() {
  local title="$1" line2="${2:-}" line3="${3:-}"
  printf '%b%b%b\n' "${_BG_CYAN}${_FG_BLACK}${_BOLD}" "$(_pad60 "")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_CYAN}${_FG_BLACK}${_BOLD}" "$(_pad60 "  ℹ  $title")" "${_RESET}"
  [ -n "$line2" ] && printf '%b%b%b\n' "${_BG_CYAN}${_FG_BLACK}" "$(_pad60 "    $line2")" "${_RESET}"
  [ -n "$line3" ] && printf '%b%b%b\n' "${_BG_CYAN}${_FG_BLACK}" "$(_pad60 "    $line3")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_CYAN}${_FG_BLACK}" "$(_pad60 "")" "${_RESET}"
}

# 🟡 WARN (4-5 li)
banner_warn() {
  local title="$1" line2="${2:-}" line3="${3:-}"
  printf '%b%b%b\n' "${_BG_YELLOW}${_FG_BLACK}${_BOLD}" "$(_pad60 "")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_YELLOW}${_FG_BLACK}${_BOLD}" "$(_pad60 "  ⚠  $title")" "${_RESET}"
  [ -n "$line2" ] && printf '%b%b%b\n' "${_BG_YELLOW}${_FG_BLACK}" "$(_pad60 "    $line2")" "${_RESET}"
  [ -n "$line3" ] && printf '%b%b%b\n' "${_BG_YELLOW}${_FG_BLACK}" "$(_pad60 "    $line3")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_YELLOW}${_FG_BLACK}" "$(_pad60 "")" "${_RESET}"
}

# 🟠 ATTN (4-5 li)
banner_attn() {
  local title="$1" line2="${2:-}" line3="${3:-}"
  printf '%b%b%b\n' "${_BG_ORANGE}${_FG_WHITE}${_BOLD}" "$(_pad60 "")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_ORANGE}${_FG_WHITE}${_BOLD}" "$(_pad60 "  ⚡ ATENCAO: $title")" "${_RESET}"
  [ -n "$line2" ] && printf '%b%b%b\n' "${_BG_ORANGE}${_FG_WHITE}" "$(_pad60 "    $line2")" "${_RESET}"
  [ -n "$line3" ] && printf '%b%b%b\n' "${_BG_ORANGE}${_FG_WHITE}" "$(_pad60 "    $line3")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_ORANGE}${_FG_WHITE}" "$(_pad60 "")" "${_RESET}"
}

# 🔴 CRITICAL (4-5 li)
banner_critical() {
  local title="$1" line2="${2:-}" line3="${3:-}"
  printf '%b%b%b\n' "${_BG_RED}${_FG_WHITE}${_BOLD}" "$(_pad60 "")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_RED}${_FG_WHITE}${_BOLD}" "$(_pad60 "  🚨 CRITICO: $title")" "${_RESET}"
  [ -n "$line2" ] && printf '%b%b%b\n' "${_BG_RED}${_FG_WHITE}${_BOLD}" "$(_pad60 "     $line2")" "${_RESET}"
  [ -n "$line3" ] && printf '%b%b%b\n' "${_BG_RED}${_FG_WHITE}${_BOLD}" "$(_pad60 "     $line3")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_RED}${_FG_WHITE}${_BOLD}" "$(_pad60 "")" "${_RESET}"
}

# 🟣 DECISION (4-5 li)
banner_decision() {
  local title="$1" line2="${2:-}" line3="${3:-}"
  printf '%b%b%b\n' "${_BG_MAGENTA}${_FG_WHITE}${_BOLD}" "$(_pad60 "")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_MAGENTA}${_FG_WHITE}${_BOLD}" "$(_pad60 "  ❓ DECISAO: $title")" "${_RESET}"
  [ -n "$line2" ] && printf '%b%b%b\n' "${_BG_MAGENTA}${_FG_WHITE}" "$(_pad60 "    $line2")" "${_RESET}"
  [ -n "$line3" ] && printf '%b%b%b\n' "${_BG_MAGENTA}${_FG_WHITE}" "$(_pad60 "    $line3")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_MAGENTA}${_FG_WHITE}" "$(_pad60 "")" "${_RESET}"
}
```

---

## PHASE G.9 — Banner library deploy (FIRST after resume)

### Pre-action EC
- Verificacao: `hooks/lib/` directory exists? Verify: `ls -la hooks/lib/` (should have `hook-log.sh`)
- Mudanca: Write banner.sh source to `.claude/workers/banner.sh.new` → cp → chmod
- Elite: lib infrastructure shared by 4+ hooks (G.7/G.8/G.5 + retrofits) — DRY > inline

### Steps
```bash
# 1. Verify lib dir
Bash("ls hooks/lib/")  # esperado: hook-log.sh

# 2. Write banner.sh source (use FULL SOURCE block above, copy-paste)
Write(.claude/workers/banner.sh.new, <FULL SOURCE>)

# 3. Deploy via cp (Lucas approves popup)
Bash("cp .claude/workers/banner.sh.new hooks/lib/banner.sh && chmod +x hooks/lib/banner.sh")

# 4. Cleanup temp
Bash("rm .claude/workers/banner.sh.new")

# 5. Verify syntax + smoke test
Bash("bash -n hooks/lib/banner.sh && echo 'syntax ok'")
Bash("bash -c '. hooks/lib/banner.sh && banner_warn \"TESTE\" \"linha 2\" \"linha 3\"'")
```

### Verification
- `bash -n hooks/lib/banner.sh` exits 0
- Smoke test renders amarelo box 4 li com "⚠ TESTE"
- Lucas vê banner visualmente em terminal

### Commit
```
S230 Phase G.9: banner.sh lib — 6 niveis semanticos

- hooks/lib/banner.sh NEW (~85 li)
- 6 funcoes: banner_success/info/warn/attn/critical/decision
- ANSI 256-color (verde/cyan/amarelo/laranja/vermelho/magenta)
- Tamanho 4-5 li uniforme, verde excecao 1 li
- Source via: . "$PROJECT_ROOT/hooks/lib/banner.sh"

Plan: mutable-sprouting-tarjan.md Phase G.9.
Coautoria: Lucas + Opus 4.7

Co-authored-by: Opus 4.7 <noreply@anthropic.com>
```

---

## PHASE G.7 — KBP-23 hook enforcement

### Pre-action EC
- Verificacao: hook-log.jsonl tem 27 entries `pattern:Read` + `exceeds maximum allowed tokens` em 11d
- Mudanca: Modify `hooks/post-tool-use-failure.sh` para detectar pattern + inject banner WARN
- Elite: rule sem enforcement decai (KBP-22 silent execution analog) — automated guard

### Read existing first
```bash
Read("hooks/post-tool-use-failure.sh")  # ~50 li típico, full read OK
```

### Modification spec
Após linha que loga failure, ANTES do exit, adicionar:
```bash
# S230 Phase G.7: KBP-23 enforcement (Read sem limit)
if [[ "$PATTERN" == "Read" ]] && [[ "$DETAIL" == *"exceeds maximum allowed tokens"* ]]; then
  . "$PROJECT_ROOT/hooks/lib/banner.sh"
  banner_warn "KBP-23 Read sem limit" "Use 'limit: 50' primeiro" "Depois Grep targeted"
fi
```

### Steps
```bash
Read("hooks/post-tool-use-failure.sh")  # full content
# Compose new content with G.7 block
Write(".claude/workers/post-tool-use-failure.sh.new", <new content>)
Bash("cp .claude/workers/post-tool-use-failure.sh.new hooks/post-tool-use-failure.sh && chmod +x hooks/post-tool-use-failure.sh")
Bash("rm .claude/workers/post-tool-use-failure.sh.new")
Bash("bash -n hooks/post-tool-use-failure.sh && echo 'syntax ok'")
```

### Commit
```
S230 Phase G.7: KBP-23 enforcement (Read sem limit auto-warn)

- hooks/post-tool-use-failure.sh: detecta Read + 'exceeds maximum allowed tokens' → banner WARN amarelo
- 27 violacoes em 11d (evidence /insights P002) — rule qualitativa sem enforcement decaiu
- Uses banner_warn from hooks/lib/banner.sh (G.9)

Plan: mutable-sprouting-tarjan.md Phase G.7.
Coautoria: Lucas + Opus 4.7
```

---

## PHASE G.8 + G.5 — session-start.sh combined edits

### Pre-action EC
- Verificacao: `hooks/session-start.sh` already exists; APL output já presente
- Mudanca: Add 2 blocks — anti-meta-loop detection + /insights bi-diário reminder
- Elite: combinar 2 edits do mesmo file em 1 deploy = -2 popups Lucas

### Read existing first
```bash
Read("hooks/session-start.sh")  # full content
```

### G.8 anti-meta-loop block (add antes de exit)
```bash
# S230 Phase G.8: anti-meta-loop banner
PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
. "$PROJECT_ROOT/hooks/lib/banner.sh" 2>/dev/null

# Conta sessões consecutivas sem commit em content/aulas/
AULAS_COMMITS_LAST_5=$(git -C "$PROJECT_ROOT" log -5 --pretty=format:"%H" -- content/aulas/ 2>/dev/null | wc -l | tr -d ' ')
TOTAL_LAST_5=$(git -C "$PROJECT_ROOT" log -5 --pretty=format:"%H" 2>/dev/null | wc -l | tr -d ' ')
META_STREAK=$((TOTAL_LAST_5 - AULAS_COMMITS_LAST_5))

R3_DAYS="?"
[ -f "$PROJECT_ROOT/.claude/apl/deadline-days.txt" ] && R3_DAYS=$(cat "$PROJECT_ROOT/.claude/apl/deadline-days.txt")

if [ "$META_STREAK" -ge 5 ] || { [ "$R3_DAYS" != "?" ] && [ "$R3_DAYS" -lt 100 ] 2>/dev/null; }; then
  banner_critical "$META_STREAK SESSOES SEM PRODUTO" "R3 Clinica Medica: ${R3_DAYS} dias" "ACAO: voltar para content/aulas/"
elif [ "$META_STREAK" -ge 3 ]; then
  banner_attn "$META_STREAK sessoes sem aulas/" "R3 Clinica Medica: ${R3_DAYS} dias" "Considere voltar a slides hoje"
fi
```

### G.5 /insights bi-diário reminder block (add antes de exit)
```bash
# S230 Phase G.5: /insights bi-diário reminder
LAST_INS_FILE="$PROJECT_ROOT/.claude/.last-insights"
if [ -f "$LAST_INS_FILE" ]; then
  LAST_INS=$(cat "$LAST_INS_FILE" 2>/dev/null || echo 0)
  NOW=$(date +%s)
  GAP_DAYS=$(( (NOW - LAST_INS) / 86400 ))
  if [ "$GAP_DAYS" -ge 2 ]; then
    banner_info "/insights pendente" "Ultimo run: ${GAP_DAYS}d atras" "Periodicidade alvo: bi-diaria"
  fi
fi
```

### Steps (single deploy combina G.8 + G.5)
```bash
Read("hooks/session-start.sh")
# Compose new content adding both blocks before final exit
Write(".claude/workers/session-start.sh.new", <new content>)
Bash("cp .claude/workers/session-start.sh.new hooks/session-start.sh && chmod +x hooks/session-start.sh")
Bash("rm .claude/workers/session-start.sh.new")
Bash("bash -n hooks/session-start.sh && echo 'syntax ok'")
```

### Commit
```
S230 Phase G.8+G.5: anti-meta-loop banner + /insights bi-diario reminder

G.8 anti-meta-loop (P005):
- Conta META_STREAK = sessoes consecutivas sem commit content/aulas/
- 3-4 sessoes → banner ATTN laranja
- 5+ sessoes OR R3<100d → banner CRITICAL vermelho
- Uses banner_attn/banner_critical from hooks/lib/banner.sh

G.5 /insights ritual (P006 revised):
- Periodicidade bi-diaria (Lucas decision: semanal "fica muita coisa")
- gap_days >= 2 → banner INFO cyan
- Manual trigger always (NUNCA auto-execute /insights)

Plan: mutable-sprouting-tarjan.md Phase G.8+G.5.
Coautoria: Lucas + Opus 4.7
```

---

## PHASE G.2 — metrics.tsv SESSION_NUM regex fix

### Pre-action EC
- Verificacao: hooks/stop-metrics.sh:96 regex `^S([0-9]+):` não casa "S230 Batch X:"
- Mudanca: Add `([[:space:]]|:)` no regex
- Elite: fix isolado, testável via shell antes de deploy

### Modification spec
Linha 96 atual:
```bash
if [[ "$LATEST_COMMIT_MSG" =~ ^S([0-9]+): ]]; then
```

Substituir por:
```bash
# S230 G.2: regex aceita "S230 Batch X:" / "S229 close:" / "S228:" — espaco OU colon apos numero
if [[ "$LATEST_COMMIT_MSG" =~ ^S([0-9]+)([[:space:]]|:) ]]; then
```

### Pre-test (before deploy)
```bash
Bash("echo 'S230 Batch 4:' | grep -E '^S([0-9]+)([[:space:]]|:)'")  # match
Bash("echo 'S229 close:' | grep -E '^S([0-9]+)([[:space:]]|:)'")    # match
Bash("echo 'S228 audit findings' | grep -E '^S([0-9]+)([[:space:]]|:)'")  # match
```

### Steps
```bash
Read("hooks/stop-metrics.sh", limit=110)  # cobrir ao redor da linha 96
# Compose new content with regex fix
Write(".claude/workers/stop-metrics.sh.new", <new content>)
Bash("cp .claude/workers/stop-metrics.sh.new hooks/stop-metrics.sh && chmod +x hooks/stop-metrics.sh")
Bash("rm .claude/workers/stop-metrics.sh.new")
Bash("bash -n hooks/stop-metrics.sh && echo 'syntax ok'")
```

### Backfill S224-S230 (manual append a metrics.tsv)
```bash
Read(".claude/apl/metrics.tsv")  # ver header + last entries

# Compor 7 linhas backfill (data_quality=backfill) baseado em success-log + git log
# Cada linha: SESSION  DATE  REWORK  BACKLOG_OPEN  BACKLOG_RESOLVED  HANDOFF_PEND  CL_LINES  COMMITS  CALLS  ELAPSED_MIN  data_quality  ctx_pct
# Exemplo S230: S230  2026-04-19  0  46  1  6  18  9  ?  ?  backfill  ?

# Lucas roda manualmente OU usar Edit (metrics.tsv não está em hooks/, OK Edit)
Edit(".claude/apl/metrics.tsv", append 7 backfill lines)
```

### Verification
```bash
Bash("tail -10 .claude/apl/metrics.tsv")  # last entries S224-S230 visible
Bash("grep -c '^S22[4-9]\\|^S230' .claude/apl/metrics.tsv")  # >= 7
```

### Commit
```
S230 Phase G.2: stop-metrics.sh regex fix + backfill S224-S230

- hooks/stop-metrics.sh:96 regex `^S([0-9]+):` -> `^S([0-9]+)([[:space:]]|:)`
- Antes: nao casava "S230 Batch X:" (espaco antes do colon) -> 7 sessoes stale
- Backfill manual S224-S230 em .claude/apl/metrics.tsv (data_quality=backfill)
- Verificado: regex casa S230 Batch X / S229 close / S228 audit

Plan: mutable-sprouting-tarjan.md Phase G.2.
Coautoria: Lucas + Opus 4.7
```

---

## PHASE G.3 — Slim VANITY (KPI loop + Cost BLOCK)

### Pre-action EC
- Verificacao: post-global-handler.sh:45-146 (KPI loop) + linhas 26-32 (Cost BLOCK arm)
- Mudanca: Delete ambos blocks. Keep Cost WARN (informativo) + momentum-arm (G.4 dependency)
- Elite: code teatro nunca consumed = honest delete

### Read existing first
```bash
Read(".claude/hooks/post-global-handler.sh")  # full ~149 li
```

### Delete spec
- Lines 26-32: Cost BLOCK arm logic (mkdir COST_BRAKE_DIR + echo armed)
- Lines 45-146: KPI Reflection Loop entire block (DORA-inspired comparison)

Result: post-global-handler.sh fica ~50 li (was 149).

### Steps
```bash
Read(".claude/hooks/post-global-handler.sh")
# Compose new content removing 2 blocks
Write(".claude/workers/post-global-handler.sh.new", <new content>)
Bash("cp .claude/workers/post-global-handler.sh.new .claude/hooks/post-global-handler.sh && chmod +x .claude/hooks/post-global-handler.sh")
Bash("rm .claude/workers/post-global-handler.sh.new")
Bash("bash -n .claude/hooks/post-global-handler.sh && echo 'syntax ok'")
```

### Cleanup de ruído
- `.claude/hooks/momentum-brake-enforce.sh` — referencia COST_LOCK em linha ~33 — remover (G.3 ou G.4)
- `docs/ARCHITECTURE.md` Mermaid não menciona KPI loop especificamente — verify via grep

### Verification
```bash
Bash("wc -l .claude/hooks/post-global-handler.sh")  # ~50 (was 149)
Bash("grep -c 'KPI_INTERVAL\\|KPI Reflection\\|BLOCK_THRESHOLD' .claude/hooks/post-global-handler.sh")  # 0
```

### Commit
```
S230 Phase G.3: slim VANITY infrastructure (-107 li)

- .claude/hooks/post-global-handler.sh: delete KPI Reflection Loop (linhas 45-146, ~100 li) + Cost BLOCK arm (linhas 26-32, ~7 li)
- Manter: Cost WARN (informativo, pertinente) + momentum-arm (G.4 dependency)
- Evidence /insights P003: zero firings em 11d (200-call interval too high; sessoes curtas nao atingem)
- KPI loop = Padrao Phase D (ModelRouter teatro) aplicavel

Plan: mutable-sprouting-tarjan.md Phase G.3.
Coautoria: Lucas + Opus 4.7
```

---

## PHASE G.4 — Momentum brake decision (BLOCKED — needs investigation)

### Pre-action EC
- Verificacao: zero brake firings em hook-log.jsonl 11d. /tmp/olmo-momentum-brake/armed exists (always armed). Bash blanket exempt no enforce.
- Mudanca: PENDING — investigar útil-vs-subutilizado. Lucas explicit: "Preciso saber se eh util e so esta sendo subutilizado"
- Elite: evidence-based decision; brake é teatro real OR conceito certo mal-implementado?

### Investigation needed (resume here)

**Question:** Brake é TEATRO (delete) ou SUBUTILIZADO (fix)?

**Test 1:** Verify armed file timing vs commits
```bash
# brake should fire BETWEEN tool calls within Lucas silence
# verify: how many cycles "Lucas fala → brake clear → tool calls → brake re-armed"?
ls -la /tmp/olmo-momentum-brake/  # last armed timestamp
ls -la .claude/hook-log.jsonl     # last brake fired entry?
```

**Test 2:** Sample sessões with REAL Edit/Write (não exempt)
```bash
# Count Edit/Write tool uses em S230 specifically
grep -c '"tool_name":"Edit"\|"tool_name":"Write"' /c/Users/lucas/.claude/projects/C--Dev-Projetos-OLMO/871bd5a2-9777-4ddb-88af-5a193d8cdd58.jsonl
# Se >0, brake DEVERIA ter disparado mas não logou — bug de logging OR exempt outra
```

**Test 3:** Check brake event log
```bash
# brake-enforce loga em algum lugar? Read source again to confirm
Read(".claude/hooks/momentum-brake-enforce.sh")
# Linha 52 exit JSON com "ask" — mas onde isso aparece? Lucas vê popup "[momentum-brake]"?
```

### Decision matrix (após investigation)

| Test result | Decision |
|---|---|
| Brake disparou mas Lucas auto-aprovou sem refletir | **TEATRO behavioral** → delete OR add force-pause |
| Brake nunca disparou em sessões com Edit/Write | **TEATRO técnico** (bug enforce) → fix logging primeiro |
| Brake disparou normalmente, sessões só Read/Grep dominantes | **SUBUTILIZADO** → fix Bash blanket→granular (HANDOFF item 2) |
| Brake disparou + Lucas pausou + scope drift evitado | **ÚTIL real** → keep as is |

### Outcomes possíveis

- **Delete (P001 default):** rm 2 hooks + 2 settings.json registrations + post-global-handler:42-43 (LOCK_DIR block)
- **Fix granular (HANDOFF item 2):** Bash blanket → granular (only Read-style bash exempt; git/rm/mv/echo arma)
- **Add logging (intermediate):** brake-enforce logs every fire to hook-log.jsonl, decide em S232

### Commit (placeholder — content depends on decision)
```
S230 Phase G.4: momentum-brake decision — [DELETE | FIX GRANULAR | ADD LOGGING]

[Justificativa baseada em investigation outcome]

Plan: mutable-sprouting-tarjan.md Phase G.4.
Coautoria: Lucas + Opus 4.7
```

---

## PHASE G.6 — Session close (last)

### Pre-action EC
- Verificacao: All G.X phases committed, working tree clean
- Mudanca: Update HANDOFF + CHANGELOG + archive plan
- Elite: state files via Edit (anti-drift §State files), preserve sections

### Steps

#### G.6.a — HANDOFF.md final update
- Remove "PAUSED" header (Phase G complete)
- Update P1 list: P001 brake decision + outcome
- Update ESTADO POS-S230 with full Phase G summary
- Reference latest-report.md + failure-registry.json

#### G.6.b — CHANGELOG.md append (S230 entry)
Add to existing S230 block:
```
- Phase G.1 (2634c0c): /insights restored after 11d gap — 6 propostas geradas
- Phase G.2 (commit X): metrics.tsv regex fix + backfill S224-S230
- Phase G.3 (commit Y): VANITY slim — KPI loop + Cost BLOCK deleted (-107 li)
- Phase G.4 (commit Z): momentum-brake [DELETE | FIX | LOG] — [evidence-based]
- Phase G.5 (commit W): /insights bi-diario reminder via session-start
- Phase G.7 (commit V): KBP-23 hook enforcement (Read sem limit auto-warn)
- Phase G.8 (commit U): anti-meta-loop banner (3-4 ATTN, 5+/R3<100d CRITICAL)
- Phase G.9 (commit T): hooks/lib/banner.sh — 6 niveis semanticos
```

#### G.6.c — Plan archive
```bash
Bash("git mv .claude/plans/mutable-sprouting-tarjan.md .claude/plans/archive/S230-mutable-sprouting-tarjan-G-metrics.md")
```

#### G.6.d — Final commit
```
S230 Phase G close: metrics infrastructure rationalized

Phase G summary:
- /insights restored (G.1) + bi-diario ritual (G.5)
- Banner system 6 niveis semanticos (G.9) — base infra para nudges visuais
- KBP-23 enforcement automated (G.7) — 27 violations/11d evidence
- Anti-meta-loop banner (G.8) — R3 prep avoidance signal
- metrics.tsv resurrected (G.2) — regex fix + 7 sessoes backfilled
- VANITY slim (G.3) — -107 li teatro
- Momentum-brake [DELETE | FIX | LOG] (G.4) — evidence-based decision

Net Phase G: ~9 commits, ~150 li deletadas + ~150 li adicionadas (banner lib + enforcements)

HANDOFF + CHANGELOG synced. Plan archived.

Coautoria: Lucas + Opus 4.7
```

---

## /insights FINDINGS (P001-P006 reproduced)

### P001 — DELETE momentum-brake teatro [HIGH, freq=0]
- Target: `.claude/hooks/momentum-brake-{clear,enforce}.sh` + `.claude/hooks/post-global-handler.sh:42-43` + `.claude/settings.json` registrations
- Status: **PENDING G.4 decision** (Lucas: investigate util-vs-subutilizado)

### P002 — KBP-23 hook enforcement [HIGH, freq=27]
- Target: `hooks/post-tool-use-failure.sh`
- Status: **APPROVED G.7**
- Draft inline: `if [[ "$PATTERN" == "Read" ]] && [[ "$DETAIL" == *"exceeds maximum"* ]]; then banner_warn "KBP-23 Read sem limit" "Use 'limit: 50' primeiro" "Depois Grep targeted"; fi`

### P003 — DELETE KPI loop + Cost BLOCK [HIGH, freq=0]
- Target: `.claude/hooks/post-global-handler.sh:26-32, 45-146`
- Status: **APPROVED G.3**

### P004 — Fix metrics.tsv regex [MEDIUM, freq=7]
- Target: `hooks/stop-metrics.sh:96`
- Status: **APPROVED G.2**

### P005 — Anti-meta-loop banner [HIGH, freq=5]
- Target: `hooks/session-start.sh`
- Status: **APPROVED G.8** (with banner system G.9)

### P006 — /insights bi-diario reminder [MEDIUM, freq=1]
- Target: `hooks/session-start.sh`
- Status: **APPROVED G.5** (revised periodicity weekly→bi-diaria per Lucas)

### Pending fix flagged by /insights
- BACKLOG #34 manual follow-up: /clear + observe popup stability + close

---

## RISK MAP UPDATED

| Phase | Risk | Mitigation |
|---|---|---|
| G.9 banner lib | LOW | Pure new file, no existing behavior changed; smoke test before commit |
| G.7 KBP-23 enforce | LOW | Single conditional addition; default exit 0 preserved |
| G.8 anti-meta banner | LOW | Detection logic isolated; banner only output (no behavior change) |
| G.5 /insights ritual | LOW | Reminder only (NEVER auto-execute) |
| G.2 metrics regex | LOW | Tested via shell echo+grep before deploy |
| G.3 slim VANITY | LOW | Delete code com zero firings — comprovadamente teatro |
| G.4 brake decision | DEPENDS | Investigation needed; outcome dictates risk profile |
| G.6 session close | LOW | Edit (não Write) state files; preserve sections |

**Total popups Lucas esperados (Phase G full):** ~12-15 (cp 6 hooks + rm temps + verifications)

---

## GOTCHAS DESCOBERTOS S230 (preserve para S231+)

1. **Bash blanket exempt em momentum-brake-enforce.sh:46** = brake nunca arma para Bash writes. Pre-existente HANDOFF item 2.
2. **stop-metrics.sh regex `^S([0-9]+):` rigid** — não casa formato real "S230 Batch X:" (espaço antes colon). Bug latente desde S224.
3. **guard-write-unified.sh:120-124 BLOCKS Edit em hooks/** — pattern `Write→temp→cp` obrigatório. `.claude/workers/` é path permitido para temp.
4. **`.claude/insights/` não existia** — /insights skill assume mas nunca foi inicializado. Phase G.1 created.
5. **`.claude/.last-insights` apontava Apr 8** — 11 dias gap. Resetado Phase G.1.
6. **`__pycache__` órfão pós git rm pasta** — `git rm -r skills/` removeu .py mas deixou `__pycache__/*.pyc`. Solução: Lucas roda `rm -rf` manualmente OR `git clean -fd`.
7. **`settings.local.json` é gitignored** — edits locais não committed. Phase B descobriu mid-commit.
8. **/insights skill tem `disable-model-invocation: true`** — agente não pode invocar via Skill tool. Lucas roda `/insights` manualmente.
9. **Plan file em archive não pode ser editado** — quando arquivado em archive/, file moved. Novo plan exige novo path.
10. **TaskList resets per session** — não persiste entre /clear ou pause/resume. Plan file é canonical task source.

---

## RESUME ENTRYPOINT (instructions for next session — including for me future-self)

When resuming this work in a new CC session:

```bash
# 1. Hydration via SessionStart hook reads HANDOFF.md
#    HANDOFF.md topo dirá "PAUSED — see plan"

# 2. Read this plan file COMPLETO
#    File: .claude/plans/mutable-sprouting-tarjan.md (this file)

# 3. Verify state intact
git log --oneline -5  # last commit: "S230 Phase G.1: /insights restoration" (2634c0c)
git status --short    # esperado: limpo (apenas se PAUSE foi committed)
ls .claude/plans/ACTIVE-*.md  # apenas ACTIVE-S227

# 4. Re-create TaskList (manual, from "Tasks tracking" table above):
TaskCreate("Phase G.9 banner lib")
TaskCreate("Phase G.7 KBP-23 enforce")
TaskCreate("Phase G.8 + G.5 session-start combined")
TaskCreate("Phase G.2 metrics regex fix")
TaskCreate("Phase G.3 slim VANITY")
TaskCreate("Phase G.4 brake decision (BLOCKED — investigate first)")
TaskCreate("Phase G.6 session close")

# 5. Start with Phase G.9 (FIRST — banner lib infrastructure)
#    See "Phase G.9" section above for steps

# 6. Order: G.9 → G.7 → G.8+G.5 → G.2 → G.3 → G.4 (decision) → G.6
```

---

## Coautoria

Cada commit Phase G: `Coautoria: Lucas + Opus 4.7` + `Co-authored-by: Opus 4.7 <noreply@anthropic.com>`.
