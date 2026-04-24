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
