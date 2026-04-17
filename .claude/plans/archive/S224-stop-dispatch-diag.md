# S224 INFRA100.1 — Stop[5] Dispatch Diagnostic

> Session: S224 | 2026-04-17 | Scope: diagnose only. No fix. Restore clean.
> Verdict: **H2 CONFIRMED** — Stop hook `type: command` dispatch FUNCIONA. Problema original é composicional do entry `integrity.sh`.

---

## Baseline (Step 1, pre-patch)

```
$ stat -c '%y %s' .claude/integrity-report.md
2026-04-17 09:27:35.307663900 -0300 2003

$ ls -la /tmp/stop-trace.txt
ls: cannot access '/tmp/stop-trace.txt': No such file or directory

$ jq '.hooks.Stop[5]' .claude/settings.json
{
  "hooks": [
    {
      "type": "command",
      "command": "bash $CLAUDE_PROJECT_DIR/tools/integrity.sh > /dev/null 2>&1 || echo '[INTEGRITY] violations -- see .claude/integrity-report.md'",
      "timeout": 10000,
      "async": true
    }
  ]
}
```

---

## Patch applied (Step 2)

Edit `.claude/settings.json:373-376`:

```diff
-            "command": "bash $CLAUDE_PROJECT_DIR/tools/integrity.sh > /dev/null 2>&1 || echo '[INTEGRITY] violations -- see .claude/integrity-report.md'",
-            "timeout": 10000,
-            "async": true
+            "command": "bash -c 'echo stop-fired-$(date -u +%FT%TZ) >> /tmp/stop-trace.txt'",
+            "timeout": 5000,
+            "async": false
```

Design choices:
- `bash -c '...'`: elimina dependência de `$CLAUDE_PROJECT_DIR` expansion
- Sem redirect `> /dev/null 2>&1`: stderr visível para harness caso shell falhe
- `async: false`: bloqueia até completion; falhas não são fire-and-forget

---

## Exercise (Step 3)

1 Stop event real: fim do turn do assistant após aplicar o patch.

(Planejamento original previa 3 turns para distinguir flaky vs solid dispatch. 1 turn foi suficiente para verdict binário H1 vs H2 — single entry elimina H1 completamente.)

---

## Observation (Step 4)

```
$ ls -la /tmp/stop-trace.txt
-rw-r--r-- 1 lucas 197609 32 Apr 17 10:26 /tmp/stop-trace.txt

$ cat /tmp/stop-trace.txt
stop-fired-2026-04-17T13:26:40Z

$ wc -l /tmp/stop-trace.txt
1 /tmp/stop-trace.txt
```

**Timestamp analysis:**
- File created: 10:26 local (Apr 17)
- Content UTC: `2026-04-17T13:26:40Z` = 10:26:40 BRT (-03:00)
- Consistency: file mtime local == content UTC converted = coerente
- Entry is single-line, complete, with correctly expanded `$(date)` subshell.

---

## Verdict — H2 CONFIRMED

**Evidence:**
1. `/tmp/stop-trace.txt` went from absent to 1 coherent entry after 1 Stop event.
2. `bash -c` was invoked with subshell expansion working (`$(date -u +%FT%TZ)` → ISO 8601).
3. Write to `/tmp/` path resolved (Git Bash mount on Windows).
4. `async: false` sync completion did not trigger harness error.

**What this proves:**
- Stop hook `type: command` dispatch FUNCIONA no Windows Claude Code harness.
- bash.exe é invocável via PATH do harness.
- `/tmp/` é Git-Bash-mapped para `C:\Users\lucas\AppData\Local\Temp`.

**What was refuted (H1):**
- Hipótese "Stop command-type dispatch silently fails harness-side" — FALSO.
- Hipótese "Stop [2-5] são todos fantasma por mesma razão" — parcialmente falso: dispatch funciona; se [2-4] não deixam rastro, é porque não escrevem rastro (stop-quality.sh silent-on-pass, etc.) ou porque têm bug específico como [5].

**What remains (H2 composicional) — candidates for Path B iteration:**
- (a) `$CLAUDE_PROJECT_DIR` não expande em Stop dispatch context → bash recebe `bash  /tools/integrity.sh` (path quebrado), falha, redirect `2>&1 > /dev/null` engole stderr, `|| echo` anexa texto ao output mas harness com `async: true` descarta.
- (b) `async: true` combinado com redirect mascara qualquer exit code; harness talvez despache mas não aguarde nem leia resultado — `integrity.sh` pode estar executando mas escrevendo em path errado (se `$PROJECT_ROOT` default para `pwd` sob Stop context diferente do repo root).
- (c) Interação específica de single-quote no `|| echo '[INTEGRITY]...'` — shell parsing edge case.
- (d) `timeout: 10000` vs harness own stop-event deadline race.

---

## Next steps (pending Lucas decision)

**Path A — Migrate integrity.sh para SessionEnd:**
- SessionEnd (linha 397, settings.json) provadamente fira (`hook-log.jsonl` 9 entries).
- Trade-off: perde defense-in-depth per-turn; gain: guaranteed fire-on-session-end.
- Implies revisando `buzzing-wondering-hickey.md` Commit 2 como insuficiente.

**Path B — Iterate variations on Stop[5] integrity.sh entry:**
- Start: restaurar redirect `2>/tmp/stop5-stderr.log` (não `> /dev/null 2>&1`) para capturar stderr.
- Next: trocar `$CLAUDE_PROJECT_DIR` por `$(pwd)` ou path hardcoded para testar variable expansion.
- Next: trocar `async: true` → `async: false` para forçar sync reporting.
- Isolate one variable at a time, each needing 1 fresh Stop event.

**Path C — Hybrid:**
- Keep Stop[5] as per-turn with fixed command (resultado de Path B).
- Add SessionEnd mirror as safety net in case Stop[5] race still eats violations.

Recommended order: Path B first (cheap, isolates culprit, preserves intent). Path A as fallback if Path B doesn't converge in 1 session.

---

## Restore verification (Step 5)

```
$ git diff HEAD -- .claude/settings.json
+    "defaultMode": "auto",
```

**Only diff vs HEAD:** `"defaultMode": "auto"` em `permissions` block — persistida pelo harness quando Auto mode foi ativado esta sessão. **NÃO é alteração do diagnóstico.** Stop[5] restaurado byte-por-byte vs baseline.

Confirmed via `jq '.hooks.Stop[5]' .claude/settings.json`:
```json
{
  "hooks": [
    {
      "type": "command",
      "command": "bash $CLAUDE_PROJECT_DIR/tools/integrity.sh > /dev/null 2>&1 || echo '[INTEGRITY] violations -- see .claude/integrity-report.md'",
      "timeout": 10000,
      "async": true
    }
  ]
}
```

---

## Open question for S225

**Is the defense-in-depth intent served by per-turn OR per-session?**
- S222 intent: catch invariant violations antes que próximo turn construa em cima.
- If Path A (SessionEnd-only), violation detected só no fim — next session starts from HANDOFF that claims "all clean" without proof.
- If Path B (fix Stop[5]), retain per-turn granularity — aligns with original S222 reasoning.

Lucas decide.
