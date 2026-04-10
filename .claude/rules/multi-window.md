---
description: Coordenacao multi-janela — orquestrador edita, workers read-only
---

# Multi-Window Coordination

> Orquestrador (1 janela) edita repo + commits. Workers (1-2 janelas) read-only + MCPs.

## Roles

### Orquestrador (1 janela)
Edit/Write, commits, integra workers, lanca subagents, decide o que entra no repo.

### Worker (1-2 janelas)
**Read-only** no repo. Pode MCPs + WebSearch/WebFetch. Escreve APENAS em `.claude/workers/{task-name}/`. **NUNCA** commit, **NUNCA** edita slides/evidence/scripts/config/agents/rules/hooks. Ao terminar: cria `DONE.md`.

**Workers NEVER:** create HTML/CSS/JS files, edit _manifest.js, modify slides/, create templates, or perform any action that changes the build output. Workers CREATE only: .md files inside `.claude/workers/{task-name}/`.

## Workers

Pasta: `.claude/workers/{task-name}/` (gitignored). Orquestrador consome e apaga apos integrar.

**Nomeacao:** todo MD inclui data/hora no titulo: `# {Titulo} — {YYYY-MM-DD HH:MM}` (Brasilia, 24h).

**DONE.md:** campos obrigatorios: Status (COMPLETE|PARTIAL|FAILED), Session, Resumo (2-3 linhas), Arquivos criados, Sugestoes, Pendencias (se PARTIAL/FAILED).

## Ativacao

Trigger: "worker mode" / "voce e um worker" / "modo worker" → `echo "worker" > .claude/.worker-mode` + `mkdir -p .claude/workers/{task-name}/`. Sem trigger = orquestrador (padrao).

## Enforcement

Hook `guard-worker-write.sh` bloqueia Write/Edit fora de `.claude/workers/` quando `.worker-mode` existe. Ao encerrar: `rm .claude/.worker-mode`.

Cross-repo: OLMO = principal, OLMO_COWORK = cowork. NAO editar repo alheio.
