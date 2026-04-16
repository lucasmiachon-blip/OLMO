# S214: Self-Improvement Step 2 ✅ + Organizacao de Diretorios

## Parte 1: Self-Improvement (DONE)
- /dream Sub-step 5: hook-log analysis — DONE
- Agent hook Stop[1]: artifact hygiene — DONE
- Auto Dream nativo: NAO disponivel (verificado S214)

---

## Parte 2: Organizacao de Diretorios

### Context

214 sessoes de acumulo organico. Diretorios duplicados, arquivos orfaos, lixo de ferramentas.
O problema: cada arquivo extra e contexto que polui, confunde, ou engana.

**Criterio para cada batch:** E profissional? O que melhora? Baseado em que?

---

### Batch 1: Duplicacao de backlogs (3 arquivos → 1)

**Arquivos:**
- `BACKLOG.md` (root, 17 linhas, S93) — 5 items genericos (Drive MCP, Anki, Cowork, pipelines)
- `.claude/BACKLOG.md` (40 linhas, S156+) — 33 items detalhados com RESOLVED tracking
- `PENDENCIAS.md` (root, 70 linhas) — setup checklist (MCPs, ferramentas, concurso, custo)

**Profissional?** Nao. 3 listas de pendencias e antipattern classico — split-brain. Quem chega nao sabe qual consultar.

**O que melhora?** Single source of truth para pendencias. Hoje `.claude/BACKLOG.md` e o completo mas ninguem olha `BACKLOG.md` root desde S93.

**Baseado em que?** BACKLOG root nao foi editado desde S93 (120+ sessoes atras). Todos os 5 items dele ja estao em `.claude/BACKLOG.md` ou `PENDENCIAS.md`. PENDENCIAS tem conteudo unico (setup checklist, MCPs, custo) que pode ir para `.claude/BACKLOG.md` como secao.

**Acao:**
1. Merge conteudo unico de PENDENCIAS.md → `.claude/BACKLOG.md` (nova secao "Setup & Infra")
2. `git rm BACKLOG.md` (root) — items ja cobertos
3. `git rm PENDENCIAS.md` — conteudo migrado
4. Verificar: nenhuma referencia quebrada (grep "PENDENCIAS" e "BACKLOG.md" no repo)

---

### Batch 2: Lixo de ferramentas externas

**Arquivos:**
- `.playwright-mcp/` — 30 logs/ymls de abril 1-4, nao tracked, 0 utilidade
- `.obsidian/` — 4 configs, nao tracked, vault nao usado ativamente neste repo
- `error.log` — raiz, nao tracked, log orfao

**Profissional?** Nao. Logs de ferramentas que rodaram uma vez e deixaram rastro.

**O que melhora?** Menos lixo no `ls`, menos confusao, gitignore mais limpo.

**Baseado em que?** Nenhum desses arquivos e referenciado em CLAUDE.md, scripts, ou hooks. `.playwright-mcp` sao logs de 2 semanas atras (abril 1-4). `.obsidian` nao tem vault associado aqui. `error.log` e vazio ou orfao.

**Acao:**
1. `rm -rf .playwright-mcp/` (nao tracked)
2. `rm -rf .obsidian/` (nao tracked — se Lucas usa Obsidian neste repo, perguntar antes)
3. `rm error.log` (nao tracked)
4. Adicionar `.playwright-mcp/` e `error.log` ao `.gitignore` (prevenir reacumulo)

---

### Batch 3: Arquivos superseded/orfaos tracked

**Arquivos:**
- `hooks/stop-should-dream.sh` — tracked, superseded S213 (logica em session-end.sh)
- `.archive/ADVERSARIAL-AUDIT-S81.md` — unico tracked em `.archive/`, 5 irmãos nao-tracked
- `.archive/` inteiro — 5 codex/adversarial audits de S57-S81 (60-130 sessoes atras)

**Profissional?** Manter codigo morto tracked e divida. `.archive/` com 1 tracked e 5 nao-tracked e inconsistente.

**O que melhora?** Repo mais limpo. `stop-should-dream.sh` tracked confunde — alguem pode achar que e ativo.

**Baseado em que?** `stop-should-dream.sh` nao esta registrado em settings.local.json (confirmado pela exploracao). `.archive/` nao e referenciado em nenhum CLAUDE.md, hook, ou script. Os audits tem valor historico no git log, nao no working tree.

**Acao:**
1. `git rm hooks/stop-should-dream.sh`
2. `git rm .archive/ADVERSARIAL-AUDIT-S81.md`
3. `rm` os 5 nao-tracked em `.archive/`
4. `rmdir .archive/` (ou gitignore se quiser manter o dir)

---

### Batch 4: .claude/ — lixo de workers e adversarial

**Arquivos:**
- `.claude/workers/` — 23 arquivos gitignored. Vestigios de pesquisa valgimigli, forest planning, hardening, distributed systems. Mix de .mjs, .md, .json, .txt.
- `.claude/gemini-adversarial-*.json/.txt` — 3 arquivos de adversarial testing antigo
- `.claude/skills/.archive/deep-search-workspace/` — workspace de evals antigo, gitignored

**Profissional?** Workers sao output intermediario de pesquisa — uteis na semana, lixo depois. Gitignored = invisivel mas ocupa espaco e confunde quem olha o disco.

**O que melhora?** Menos ruido no filesystem. Workers e adversarial sao context que nunca mais sera consultado.

**Baseado em que?** Workers mais recentes sao de abril 9-15. Gemini adversarial de abril 5-15. Deep-search workspace e de epoca de evals. Nenhum referenciado em codigo ativo.

**Acao:**
1. `rm -rf .claude/workers/*` (manter o dir, gitignored)
2. `rm .claude/gemini-adversarial-*`
3. `rm -rf .claude/skills/.archive/`

---

### Batch 5: daily-digest e docs/.archive

**Arquivos:**
- `daily-digest/` — 2 digests (abril 9-10), nao tracked
- `docs/.archive/` — 3 docs (CODEX-AUDIT-S70, OBSIDIAN_CLI_PLAN, S63-AUDIT-REPORT), tracked

**Profissional?** daily-digest com 2 arquivos de 1 semana atras e feature abandonada. docs/.archive sao audits antigos no lugar certo (archive) mas de S63-S70.

**O que melhora?** daily-digest confunde — parece feature ativa. docs/.archive pesa no git tree sem valor ativo.

**Baseado em que?** daily-digest nao e referenciado em nenhum script ou hook. docs/.archive sao de S63-S70 (150+ sessoes atras), historico no git log.

**Acao:**
1. `rm -rf daily-digest/` (nao tracked)
2. `git rm docs/.archive/*` — historico preservado no git
3. Considerar: `rmdir docs/.archive/`

---

### Batch 6: Avaliacao — manter ou nao?

**Arquivos que NÃO vou propor deletar (justificativa):**

| Arquivo | Por que manter |
|---------|---------------|
| `.cursor/` (8 tracked) | Config de IDE ativa. Lucas pode usar Cursor. |
| `wiki/` (25 tracked) | Conteudo medico estruturado (conceitos medicina-clinica + sistema-olmo). Valor pedagogico. |
| `.claude/context-essentials.md` | Injetado por session-compact.sh. Ativo. |
| `.claude/.heartbeat` | Usado por hooks. Ultimo: S152. |
| `.claude/success-log.jsonl` (138 linhas) | Dados de performance. Pode ser util para metricas. |
| `.claude/hook-stats.jsonl` (195 linhas) | Dados de hooks. Complementa hook-log.jsonl. |
| `tools/zone-calibrator.html` | Ferramenta unica mas funcional. |
| `skills/` (root, Python) | Modulo Python (efficiency/local_first.py). Diferente de .claude/skills. |

---

## Verificacao

Apos cada batch:
1. `git status` — confirmar que so deletou o que previa
2. `grep -r "ARQUIVO_DELETADO"` — confirmar 0 refs quebradas
3. Commit atomico por batch

## Sequencia

Batch 1 (backlogs) → 2 (ferramentas) → 3 (superseded) → 4 (.claude lixo) → 5 (daily-digest/docs) → 6 (decisao final)
Cada batch: parar, reportar, Lucas confirma proximo.
