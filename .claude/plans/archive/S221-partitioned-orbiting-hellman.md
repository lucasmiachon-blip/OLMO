# S221 — integrity.sh (invariant checker, seed)

> Session: S221 CONTEXT_ROT2 | Scope: 1 trabalho | Risco: baixo (read-only, relata)

## Context (what's actually happening)

Projeto entrou em **truth-decay** em 4 dominios simultaneamente:

1. **HOOKS** — `momentum-brake` exempta todo Bash; `PostToolUseFailure` registrado em evento inexistente (silenciosamente disabled); `/tmp/cc-session-id.txt` global corrompe entre sessoes. Policia nao policia.
2. **PLANS** — 4 de 6 ativos FALSE-DONE ou STALE (Codex batch 3). HANDOFF repete mentiras.
3. **MEMORY** — 20/20 at cap, 9 merges pendentes. SCHEMA.md declara "10 rules" (sao 5); MEMORY.md L52 "5 rules (199 li)". Contagens nao batem, nada dispara.
4. **REFERENCING** — CLAUDE.md:63 + :73 apontam scripts mortos. KBP-06 + KBP-15 apontam memory files mortos. `.claude/.claude/apl/` orfaos timestamped 21:01 de hoje (cwd bug ativo).

**Padrao comum:** claims declarativos (contagens, pointers, paths, status) decaem livres porque **nada testa que ainda compilam**. Agentes ingerem mentiras como ground truth. Orfaos sao fim da cadeia.

**Pressao de Lucas S221:** "md usado tem destino" — politica sem mecanismo = teatro. Precisamos de mecanismo.

## Proposed change

Criar **`tools/integrity.sh`** — verificador de invariantes do repo, read-only, relata falhas sem corrigir. Arquitetura modular (cada INV-X e uma funcao bash), grow incrementalmente.

### Escopo deste commit (INV-2 + INV-5)

**INV-2: Hook registration integrity**
- Parse `.claude/settings.local.json` e extrai todos os `command` de hooks
- Para cada path extraido: verifica `[[ -f "$path" && -x "$path" ]]`
- Expande `$CLAUDE_PROJECT_DIR` apropriadamente
- Falha se qualquer hook registrado nao existe ou nao e executavel

**INV-5: Untracked pollution absence**
- Executa `git status --porcelain` e filtra `^\?\? \.claude/\.claude/` + `^\?\? \.claude/tmp/`
- Falha se qualquer dir untracked desses existe
- (Nao deleta — apenas relata)

### Output

`.claude/integrity-report.md` append-only (ou sobrescrever por sessao — decide durante impl):

```
# Integrity Report — S221 2026-04-16 HH:MM

## INV-2 Hook registration
- [PASS] hooks/apl-cache-refresh.sh
- [PASS] .claude/hooks/guard-write-unified.sh
- ...
- Total: 30 registered, 30 exist, 0 missing

## INV-5 Untracked pollution
- [FAIL] .claude/.claude/ present (4 files)
- [FAIL] .claude/tmp/ present (5 files)
- Total: 2 violations

## Summary: 2 invariants checked, 2 violations
```

### Out of scope (explicit)

- INV-1 (md destino) — precisa whitelist design + frontmatter injection, proximo commit
- INV-3 (pointer resolution) — regex parsing de rules/, proximo commit
- INV-4 (count integrity) — requires spec de quais numeros checar, proximo commit
- Stop hook wiring — commit separado apos invariants estabilizarem
- Auto-fix — NUNCA (so relata; fix e decisao humana)
- cwd bug fix (criador de `.claude/.claude/apl/`) — commit separado (diagnostico em pending-fixes)

## Why this change is good

1. **Ataca gerador, nao sintoma.** Deletar orfaos resolve 9 arquivos hoje. Invariante evita a CLASSE de orfaos para sempre.
2. **"Md tem destino" vira compilavel** quando INV-1 entra (proximo commit). Politica sem mecanismo era teatro.
3. **Adversarial by construction** — default: "claim e mentira ate prova por filesystem."
4. **Incremental.** Um invariante por commit = "um trabalho por vez" honesto. Cada um e um ganho isolado.
5. **Unifica 4 dominios** (hooks=INV-2, plans=invariante futura de verification boxes, memory=INV-4, refs=INV-3).
6. **Metrica de rot objetiva.** Numero de violacoes por sessao = trend plotavel. Ataca "funciona sem metrica = achismo" direto.
7. **Via Negativa.** Relata o errado, nao prescreve o certo. Taleb-aligned.
8. **Barato.** 1 script bash + 1 arquivo de relatorio. Zero agente, zero hook novo neste commit.

## Trade-offs honestos

- **Primeira rodada ruidosa:** INV-5 vai relatar 2 FAILs imediatamente (os dirs existem). Isso e **feature**, nao bug — forca o cleanup explicito (proximo commit).
- **INV-2 pode ter FP** em hooks cross-platform (Windows bash resolution). Mitigation: usar `command -v` em vez de `-x` se `-x` falhar em .sh Windows.
- **Report format sobrescreve vs append:** sobrescrever = so ultimo estado (git tracks); append = historico in-file. Default: sobrescrever (decide final durante impl, registrar no commit).

## Arquivos

### Novos
- `tools/integrity.sh` (~80-120 linhas bash, strict mode, funcoes modulares)
- `.claude/integrity-report.md` (output, gitignored? decide — se versionado, diff = rot delta)

### Modificados
- `.claude/pending-fixes.md` — append 1 linha: "S221: cwd bug criando `.claude/.claude/apl/` — grep hooks/ por path relativo sem $CLAUDE_PROJECT_DIR"

### Inalterados (explicitamente)
- `.claude/settings.local.json` (nao wire ainda)
- hooks/stop-*.sh (nao wire ainda)
- CLAUDE.md, rules/*, memory/* (nao mudar declaracoes — invariantes vao expor quais mentem)

## Verification

```bash
# 1. Dry-run manual
bash tools/integrity.sh

# Expected INV-2 output: algo como "30 registered, N exist, M missing"
#   M deve ser 0 ou baixo (se nao-zero = achado real)
# Expected INV-5 output: "2 violations" (os dois dirs existem hoje)

# 2. Exit code
bash tools/integrity.sh; echo "exit=$?"
# Expected: exit=1 (porque INV-5 falha). 0 so quando zero violacoes.

# 3. Idempotent
bash tools/integrity.sh && bash tools/integrity.sh
# Expected: mesmo report nos 2 runs (com timestamp diferente)

# 4. Output legivel
cat .claude/integrity-report.md
# Expected: markdown limpo com secoes por INV

# 5. No side effects
git status --short
# Expected: apenas novo arquivo .claude/integrity-report.md (se versionado) ou nada (se gitignored)
```

## Commit message

```
S221: tools/integrity.sh seed (INV-2 hook registration + INV-5 orphan dirs)

- tools/integrity.sh: invariant checker, read-only, reports-only
- INV-2: hooks registrados em settings.local.json existem + executaveis
- INV-5: sem .claude/.claude/ ou .claude/tmp/ untracked
- .claude/integrity-report.md: baseline
- .claude/pending-fixes.md: flag cwd bug creating .claude/.claude/apl/
- Proximos commits: INV-1 md destino, INV-3 pointers, INV-4 counts,
  wire to Stop hook

Ataca gerador do truth-decay em 4 dominios (hooks, plans, memory, refs).
Politica "md tem destino" vira mecanica em INV-1 (proximo).

Coautoria: Lucas + Opus 4.7
```

## Next (nao agora)

Ordem sugerida apos este commit (Lucas decide):
1. **INV-1 md destino** — aplica politica nova, whitelist para grandfather
2. **INV-3 pointer resolution** — ataca DEAD-REFs diretos
3. **INV-4 count integrity** — reconcilia SCHEMA vs MEMORY
4. **Wire no Stop hook** — surface em session-start quando falhas >0
5. **Fix cwd bug upstream** — para o gerador de `.claude/.claude/apl/`
6. **Cleanup orfaos** — so depois que INV-5 esta checando (senao volta)
