---
description: "Claude Code runtime gotchas: timeout unit mismatch, permissions bug, deny-list prefix-match. Loads for settings + hooks edits."
paths:
  - ".claude/settings.json"
  - ".claude/settings.local.json"
  - "hooks/**"
  - ".claude/hooks/**"
---

# CC schema gotchas

> Armadilhas operacionais do Claude Code runtime documentadas após descoberta empírica. Não são bugs a reportar — são facts do sistema que precisam influenciar config reviews futuros.

- **timeout em hook type "command"/"http":** milissegundos.
- **timeout em hook type "prompt"/"agent":** segundos.
  Evidência: stop_hook_summary real com `timeout: 30` + `durationMs: 3025` sem `hookErrors` — se fosse ms teria estourado em 30ms. Não mude timeouts desses tipos sem testar.
- **permissions.ask tem bug em CC >=2.1.113** (KBP-26) — pode degradar silenciosamente para allow. Arquitetura de permissions precisa assumir esse failure mode.
- **deny-list é prefix-match.** Deny inclui 7 patterns shell-within-shell (`bash -c`, `sh -c`, `zsh -c`, `eval`, `exec`, `source /*`, `. /*`). `$()`, backticks e pipelines (`Bash(X && bash -c Y)`) requerem hook-level guard — fora do pattern match.

## Upstream plugin bugs (tracking, no local patch)

Bugs em plugins de terceiros que afetam OLMO. Não patcham localmente (workaround → entulho); registramos para rastrear, comentar upstream e re-validar após plugin update.

- **codex@openai-codex Stop hook stdin block on Windows** — issue #191 OPEN desde 2026-04-09.
  - Sintoma: `Stop hook error: Failed with non-blocking status code: No stderr output` esporádico ao fim de turnos.
  - Causa: `stop-review-gate-hook.mjs` chama `fs.readFileSync(0)` antes do check `config.stopReviewGate`; no Windows Git Bash o CC harness não pipea/fecha stdin → blocking infinito até timeout do manifest matar silent.
  - Versões afetadas: 1.0.3 e 1.0.4 (manifest hooks.json byte-identical entre versões).
  - Bug correlato no mesmo manifest: `SessionStart`/`SessionEnd` com `timeout: 5` (ms — unreachable para Node cold start). Stop com `timeout: 900` ms está apenas ~250ms acima do tempo medido sem stdin block (644ms).
  - Estado OLMO: aceito como noise não-bloqueante. `config.stopReviewGate=false` (default) → função real do hook = nenhuma. Re-validar quando plugin atualizar.
  - Tracking: https://github.com/openai/codex-plugin-cc/issues/191
