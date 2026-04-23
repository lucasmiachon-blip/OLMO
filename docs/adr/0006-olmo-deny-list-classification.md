# ADR-0006: OLMO Deny-list Classification

- **Status:** accepted
- **Data:** 2026-04-23
- **Deciders:** Lucas + Claude (Opus 4.7)
- **Sessão:** S241-infra-plataforma

## Contexto

`permissions.deny` em `.claude/settings.json` foi expandida em S235b para cobrir shell-within-shell gaps (KBP-10, KBP-28): 7 patterns adicionais (`bash -c*`, `sh -c*`, `zsh -c*`, `eval *`, `exec *`, `source /*`, `. /*`). Expansão foi correta para mitigar execução arbitrária via indirection.

Efeito colateral acumulado S232-S241: deny-list cresceu organicamente incluindo **patterns benignos-mas-sensíveis** (`Bash(cp *)`, `Bash(mv *)`, `Bash(install *)`, `Bash(rsync *)`, `Bash(tee *)`, `Bash(truncate *)`, `Bash(touch *)`, `Bash(sed -i*)`, `Bash(patch *)`). Justificativa provavelmente foi "prevenir writes inadvertidos", mas prefix-match bloqueia legítimos cp/mv/tee em fluxos **Write→temp→cp** para deploy de scripts (hooks, utilities).

Problema tornou-se crônico ("esse problema eh antigo que nao arrumou uma solucao" — Lucas S241) mas **sem critério formal**, expansão vs redução do deny eram decisões ad-hoc. S241 expôs materialmente em tentativa de deploy de `hooks/stop-failure-log.sh` (ADOPT 5 StopFailure): Write bloqueado pelo `guard-write-unified.sh` Guard 3 (design S194), cp bloqueado pelo deny-list — deploy impossível sem refactor.

## Decisão

Adotar **critério formal de 3 categorias** para classificação de patterns em `permissions.deny`:

### DENY (bloqueio absoluto, impossível aprovar via ask)

1. **Irrecuperável**: operações sem undo
   - `Bash(rm -rf *)`, `Bash(rm -r *)`, `Bash(rm -f *)`, `Bash(rmdir *)`
   - `Bash(shred *)`, `Bash(wipe *)`
   - `Bash(dd *)`, `Bash(sponge *)`
   - `Bash(find * -delete*)`
   - `Bash(git apply *)`, `Bash(git am *)`, `Bash(git checkout --*)`, `Bash(git restore *)`

2. **Código arbitrário inline**: linguagens com `-c`/`-e` executando string como código
   - `Bash(python -c *)`, `Bash(python3 -c *)`, `Bash(py -c *)`
   - `Bash(node -e *)`, `Bash(node --eval *)`
   - `Bash(ruby -e *)`, `Bash(perl -e *)`, `Bash(perl -i*)`, `Bash(perl -pi*)`

3. **Shell-within-shell**: indirection que bypassa deny-list direta (KBP-28)
   - `Bash(bash -c*)`, `Bash(sh -c*)`, `Bash(zsh -c*)`
   - `Bash(eval *)`, `Bash(exec *)`, `Bash(source /*)`, `Bash(. /*)`

4. **Fetch não-verificado**: download/extração de fonte externa não-validada
   - `Bash(tar *x*)`, `Bash(unzip *)`, `Bash(7z x*)`
   - `Bash(curl * -o *)`, `Bash(curl * --output *)`, `Bash(wget * -O *)`
   - `Bash(robocopy *)`, `Bash(xcopy *)`

### ASK via guard (operação legítima mas sensível, Lucas aprova)

Handled por `.claude/hooks/guard-bash-write.sh` com `"permissionDecision":"ask"`:

- **Write operations benignas**: `cp`, `mv`, `install`, `rsync`, `tee`, `truncate`, `touch`, `sed -i`, `patch`
- **Permissões**: `chmod`, `chown` (atualmente em ask via guard, não em deny)

### ALLOW implícito (defaultMode: auto)

Read-only sem side effects:
- `ls`, `cat`, `grep`, `find` (sem `-delete`)
- Git read: `log`, `diff`, `status`, `blame`, `show`
- Package queries: `npm ls`, `pip list`

## Consequências

### Positivas

- **Write→temp→cp deploys legítimos funcionam** sem intervenção manual (deploy de hooks, utilities, scripts)
- **Critério reprodutível**: novo pattern proposto → classificar em 1 das 3 categorias DENY
- **Resolve problema S235b-era** citado como "antigo não arrumado"
- **Semântica clara** diferencia safety (deny) de friction-reduction (ask)
- **Commit `36feffe` S241** aplica o critério pela primeira vez: remove 9 patterns ASK do deny, mantém 23 HIGH-RISK

### Negativas / trade-offs

- **KBP-26 dependency**: `permissions.ask` está broken em CC ≥2.1.113 (bug Anthropic, não OLMO). `guard-bash-write.sh` emite `ask`, mas runtime pode degradar para `allow silent` — operações benignas passam sem prompt Lucas. Malicious cp também poderia passar. **Mitigação**: `guard-bash-write.sh` loga em `hook-log.jsonl` → sentinel detecta anomalias post-hoc. Auditoria substitui prevenção enquanto KBP-26 não resolver.
- **Sem path para resolver KBP-26 estruturalmente** — ADR classifica, não conserta bug upstream. Upgrade/downgrade CC precisa investigação separada.
- **Classificação de patterns borderline requer julgamento** (ex: `scp`, `curl | bash`) — sem rubrica numerical. Resolução: adicionar ao ADR como addendum conforme apareçam.

## Alternativas consideradas

1. **Manter deny-list ampla (status quo)** — rejected: fricção crônica em deploys legítimos; usuário aprovava workarounds repetidamente.
2. **Remover deny-list completamente + confiar em guards** — rejected: KBP-26 torna guards unreliable; alguns padrões (rm -rf) precisam bloqueio absoluto independente de ask.
3. **Reduzir a deny-list literal apenas (sem prefix-match)** — rejected: não cobre shell-within-shell; KBP-28 requer prefix-match em `bash -c*` etc.
4. **`permissions.sandbox:` block** (CC feature recente) — rejected temporariamente: Windows 11 suporte `[VERIFY]`; deferido para EVAL-next session (Agent 1 report).
5. **Allow-list override específico** (`Bash(cp .claude-tmp/* hooks/*)` em allow) — rejected: precedence allow vs deny em CC `[VERIFY]` inconsistente; adiciona tokens por caso sem critério unificador.

## Escopo desta ADR

**Canônico para OLMO.** Aplicar critério a toda modificação futura do deny-list em `.claude/settings.json`. Violação (adicionar pattern benigno-mas-sensível ao deny sem classificação em uma das 4 categorias DENY) deve ser flagada em code review.

### Não cobre

- `.claude/settings.local.json` (overrides locais) — segue mesmo critério mas pode ter exceções documentadas em-linha
- Hook-level guards (`.claude/hooks/*.sh`) — mantém discretion per-hook (ask/block)
- MCP server policy (`mcp__*` patterns) — categoria separada (blocklist total, não granular)

## Governance

- **Revisão**: quando novo pattern é proposto para deny, classificar formalmente em PR description referenciando este ADR.
- **Sentinel flag** (futuro): lint rule detecta deny-list growth sem ADR reference em commit message.
- **Lint candidato**: diff de `settings.json permissions.deny` contra ADR history — pattern novo sem classificação = warn.

## Ligações

- **KBP-10**: Destructive commands without approval (origem da deny-list)
- **KBP-26**: `permissions.ask` broken em CC ≥2.1.113 (bug upstream que motiva mitigação via log)
- **KBP-28**: Adversarial testing frame-bound (shell-within-shell expansão S235b)
- **Commit `9ef3b78`** (S235b): expansão shell-within-shell — mantida sob categoria DENY-3
- **Commit `36feffe`** (S241): aplicação inicial deste critério — remove 9 patterns benignos
- **Commit `7e205a3`** (S241): primeiro deploy bem-sucedido pós-refactor (StopFailure hook)
- **SOTA research S241**: Agent 1 (Anthropic) identificou `permissions.sandbox` como EVAL-next resolução estrutural

Coautoria: Lucas + Opus 4.7 (Claude Code) | S241 infra-plataforma | 2026-04-23
