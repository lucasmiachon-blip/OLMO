# S245 post-sweep — BACKLOG #13 archive (via dormancy)

## Context

S245 infra sweep resolveu P1 #37 (apl-cache path) e adicionou monitoring note em P1 #34 (CC ask bypass). Restou 1 meta item acionavel pre-/clear:

**Deferred #13 — "g3-result memory findings audit"** (L55 `.claude/BACKLOG.md`):
- 78 sessoes dormente (governance L4 marca "Dormant >10 sessões = audit candidate")
- Zero content impact (nao bloqueia nenhum slide/aula/exame)
- Classificacao atual Deferred ("sem consumer / low urgency")
- Self-violando propria governance rule

**Precedent para closure:** commit `ddcaba1` desta sessao usou strikethrough-in-place pattern para #37; pre-existente em P1 tier. Plus #49 (Managed Agents evaluation) tambem strikethrough-in-place com "RESOLVED S232 post-close (via #51 DELETE path)" — semantica RESOLVED aceita "abandoned via reframe/dormancy", nao so "done via action".

**Outcome intended:** #13 marcado archived via strikethrough in-place (Deferred section); counts BACKLOG header + Contagem Deferred atualizados; git log preserva history total. Apos commit, Deferred section fica 9 items cada um com razao substantiva; BACKLOG um pouco mais limpo pre-/clear.

## Change (escopo minimo)

**File:** `C:\Dev\Projetos\OLMO\.claude\BACKLOG.md`

3 Edits cirurgicos:

### Edit 1: Strikethrough #13 row em Deferred section

**Old (L55):**
```
| 13 | P1 | g3-result memory findings audit | 78 sessões dormente; auto-viola governance L4 ("Dormant >10 sessões"); zero content impact |
```

**New:**
```
| ~~13~~ | RESOLVED S245 (via dormancy) | ~~g3-result memory findings audit~~ | ARCHIVED S245 — 78 sessoes dormente, auto-viola governance L4; zero content impact. Precedent: #49 pattern (RESOLVED via reframe). Historia no git log. |
```

### Edit 2: Update Deferred contagem (L66)

**Old:**
```
**Contagem:** 10 items. Próximo # ainda 52.
```

**New:**
```
**Contagem:** 9 items (10 total, 1 archived S245). Próximo # ainda 52.
```

### Edit 3: Update header Counts (L5)

**Old:**
```
> Counts: P0=3 | P1=4 | Deferred=10 | P2=24 | Frozen=3 | Resolved=12 | Setup=separate. Next #=57.
```

**New:**
```
> Counts: P0=3 | P1=4 | Deferred=9 | P2=24 | Frozen=3 | Resolved=13 | Setup=separate. Next #=57.
```

Rationale: Deferred 10→9 (item archived); Resolved 12→13 (conceptualmente "closed", match semantica #49). Next # unchanged (nao criamos item novo).

## Files modified

- `.claude/BACKLOG.md` — 3 Edits (1 row + 2 counters)

## NOT included (out of scope)

- **#34 demotion P1→Deferred:** monitoring note ja commitada em `ddcaba1`; demotion adiciona cognitive overhead marginal. Lucas decide em commit separado se quiser.
- **Governance rule addition ("Dormant >10 sessoes sem revival = archive automatico"):** interessante mas structural change em governance — separate PR se Lucas quiser formalizar o pattern.
- **Physical move #13 Deferred→Resolved section:** matches 3-col format mas exige 2 Edits adicionais + possivel restructure. Strikethrough in-place (precedent #37/#49) e minimo e consistente.

## Verification

1. **Read BACKLOG.md header (L1-10) + Deferred section (L49-67) pos-Edit** — confirmar:
   - Header Counts: Deferred=9, Resolved=13
   - L55 strikethrough + ARCHIVED tag
   - L66 Contagem 10→9
2. **Grep** `~~13~~` em `.claude/BACKLOG.md` — exact 1 hit
3. **Git diff** — confirma 3 line changes em 1 file, nothing else touched
4. **Commit message:** `chore(backlog): archive #13 g3-result memory findings (78 sessoes dormente)`

## Post-commit state (hidratacao S246)

- 8 commits S245 total em main
- BACKLOG Deferred list = 9 items, cada um com razao viva
- HANDOFF top-block inalterado (S245 tema pendente: estetica/QA/pesquisa)
- Ready for /clear
