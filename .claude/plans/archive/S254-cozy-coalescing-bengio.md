# Plan: Codify KBP-40 — SessionStart gitStatus snapshot stale

> Sessão: **Infra-rapido** (S254, 2026-04-26) | Quick win do backlog | Estimativa: ~2-3 min

## Context

**Origem:** HANDOFF S253 §Cautions S254 listou candidate /insights P253-NEW:
> "Branch awareness: SessionStart `gitStatus` snapshot fica stale. Always `git branch --show-current` antes de commit (KBP candidate /insights P253-NEW)."

**Por quê:** O bloco `gitStatus` injetado em SessionStart é um snapshot estático — captura branch + dirty state apenas no boot da sessão. Durante a sessão, switches de branch, commits, e mudanças de tree não atualizam esse contexto. Agentes que confiam em `gitStatus` para "qual branch estou?" tomam decisão sobre dado decaído. Risco real: commit em branch errado, ou claim de "estou em main" quando já fui pra feature branch.

**KBP-31 enforcement:** "Aprendizados KBP-Candidate Without Commit" — candidate sem commit = lost. HANDOFF marcou explicitamente, então codificação bloqueia perda.

**Numbering correction:** Source of truth `known-bad-patterns.md` linha 9 diz `Next: KBP-40` (não KBP-41 como propus inicialmente no AskUserQuestion). Branch-awareness ocupa **KBP-40**. WebFetch URL lifecycle (também HANDOFF-pending, defer'd até P2 sota-intake skill) vai ocupar KBP-41 quando codificado.

## Files to modify (2)

### 1. `.claude/rules/anti-drift.md` — adicionar branch claim ao §Verification

**Location:** linha 61 (último statement de claim-checks na §Verification)

**Pattern existente (lines 60-61):**
```
File not found → Glob. Error → read actual message. Claim about code → read the file.
Claim about state → read source-of-truth file. Claim about history → `git log -S` / `git blame`.
```

**Mudança (append a linha 61):**
```
File not found → Glob. Error → read actual message. Claim about code → read the file.
Claim about state → read source-of-truth file. Claim about history → `git log -S` / `git blame`. Claim about branch → `git branch --show-current` (SessionStart `gitStatus` snapshot decai durante sessão).
```

**Por que inline e não nova subsection:** matches existing pattern (linhas 60-61 já são uma série de inline claim→verify rules). Mantém densidade alta, evita ruído estrutural.

### 2. `.claude/rules/known-bad-patterns.md` — append KBP-40 entry + bump header pointer

**Edit A — header bump (line 9):**
```
Antes: > Governance: /insights appends. NEVER remove — only mark RESOLVED. Next: KBP-40.
Depois: > Governance: /insights appends. NEVER remove — only mark RESOLVED. Next: KBP-41.
```

**Edit B — append entry (após line 127, fim do arquivo):**
```

## KBP-40 SessionStart gitStatus snapshot stale
→ anti-drift.md §Verification (branch claim)
```

(Format conforme header §Format: `## KBP-NN Name` + `→ pointer`. Prose vive no pointer target — toda a explicação fica no anti-drift.md inline rule.)

## Verification (post-edit)

1. **Read anti-drift.md §Verification** (lines 55-65): confirmar linha 61 agora termina com "Claim about branch → ..." e §Adversarial review (line 63) intacta.
2. **Read known-bad-patterns.md header** (lines 5-12): confirmar `Next: KBP-41.`
3. **Read known-bad-patterns.md tail** (lines 125-132): confirmar KBP-40 appended logo após KBP-39, blank line separator presente.
4. **Visual count:** KBPs total = 40 (era 39). Pode confirmar com `Grep "^## KBP-" .claude/rules/known-bad-patterns.md | wc -l` mas é overkill pra mudança trivial.

## Out of scope (não fazer agora)

- ❌ NÃO codificar KBP-41 WebFetch URL lifecycle (defer'd HANDOFF até P2 sota-intake skill exists).
- ❌ NÃO update Conductor §16 ou HANDOFF S254→ativa nesta tarefa (Lucas pediu 1 candidate; pode ser próximo quick win se quiser).
- ❌ NÃO criar hook/lint que enforça `git branch --show-current` antes de commit (escopo maior; rule textual primeiro, tooling depois se sinal de violação aparecer).
- ❌ NÃO commit nesta sessão a menos que Lucas peça explicitamente (CLAUDE.md ENFORCEMENT #1).

## Next quick wins disponíveis (oferecer após este)

Se Lucas quiser continuar "tirando coisas do backlog":
- **B.** Update Conductor §16 com S254 init entry (~1-2 min)
- **C.** Update HANDOFF.md S254 PROXIMA → SESSAO ATIVA (~2 min)
- **D.** /insights P253-001 backlog triage (P0 BACKLOG.md 41 items STAGNANT 18 sessões) — maior, talvez 5-10 min

## Risk

- Baixíssimo. Append-only edits em arquivos governance bem-formados.
- Single-file race: nenhum (2 arquivos distintos, edits non-overlapping).
- Edit discipline (KBP-25): old_string será copiado direto do Read output já feito.
