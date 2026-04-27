# Plan: QA editorial metanalise — forest-plot + dead-code cleanup s-absoluto (S264)

## Sessão

- **Nome:** `qa-editorial-metanalise`
- **Foco (Lucas, mensagens 1+2):**
  1. Vite dev server rodando (Lucas request)
  2. Dead-code cleanup completo de `s-absoluto` (slide deletado S186, refs stale ainda presentes)
  3. Arrumar ordem em `metanalise/HANDOFF.md` (stale desde S162, auto-admitido linha 20)
  4. QA editorial forest-plot: s-forest1 → s-forest2 (ordem manifest, confirmada)
- **Janela:** QA editorial. Janela paralela = S264 P0 bench (`splendid-munching-swing.md`) — out of scope aqui.
- **Cross-window safety:** sempre `git fetch && git status` antes de touch state files. Diff-first em **todo** Edit.

## Diff antes de cada Edit (regra cardinal Lucas)

Cada Edit, sem exceção:
1. Read full file (ou range ± 20 li ao redor do old_string) — KBP-25
2. Apresento `old_string` + `new_string` como proposta
3. Lucas OK por edit
4. Execute Edit
5. Status

Múltiplos Edits no mesmo file: old_strings em linhas distintas non-overlapping.

## Cross-window protocol (KBP-40 + S259+ reinforced)

- `HANDOFF.md` root + `CHANGELOG.md` root + `GEMINI.md` estão **M** no git status — outra janela pode editar
- `git fetch && git status` antes de touch desses arquivos
- Edit minimal sections — **NÃO rewrite** (anti-drift §State files)
- `git branch --show-current` antes de commit
- `metanalise/HANDOFF.md` clean — OK editar (mas ainda diff-first)

## Phases (6 phases — TaskCreate batch no approval)

### Phase 0 — Setup (~10 min)

1. **Vite dev server** (Lucas request): `npm run dev:metanalise` (port 4102, content/aulas/package.json) — background com PID tracked. NUNCA `taskkill //IM node.exe` (KBP rule aulas/CLAUDE.md).
2. **`.claude/.session-name`**: `echo -n "qa-editorial-metanalise" > .claude/.session-name` (status line update).
3. **TaskCreate batch** (6 tasks, 1 per phase) — anti-drift §Plan execution.
4. **Pre-flight reads** (KBP-25 + KBP-34):
   - `content/aulas/metanalise/slides/08a-forest1.html` (s-forest1)
   - `content/aulas/metanalise/slides/08b-forest2.html` (s-forest2)
   - `content/aulas/metanalise/evidence/s-forest-plot-final.html` (read-only context)
   - `content/aulas/metanalise/metanalise.css` — Grep `s-forest|forest-plot|fp-` + `s-absoluto`
   - `content/aulas/metanalise/slide-registry.js` — Grep `s-forest1|s-forest2|s-absoluto`
   - `content/aulas/metanalise/HANDOFF.md` (full)
5. **Dead-code grep s-absoluto** repo-wide: `Grep "s-absoluto"` em todos os contextos — gera lista exaustiva ANTES de Phase 1.
6. **Cross-window check**: `git fetch && git status`. Reportar diffs detectados.

### Phase 1 — Dead-code cleanup s-absoluto (~15-20 min)

Lucas autorizou: "se quiser apague tudo referente". Targets potenciais (a confirmar via Phase 0 grep):

- **HANDOFF root** linha 19: ref "Próximo APL: s-absoluto (3/19 editorial)" → trocar por estado real (forest-plot QA pendente)
- **`metanalise/HANDOFF.md`** linhas 14, 79, 84: ocorrências em "Estado atual", tabela slides F3, "Resumo"
- **`metanalise/qa-screenshots/s-absoluto/`** (diretório completo) — Gate 0 only, slide deletado, artifact stale
- **`metanalise.css`** — verificar `section#s-absoluto` orphan rules
- **`slide-registry.js`** — verificar function `s-absoluto` órfã
- **outros encontrados via grep** (CHANGELOG aula, scripts, evidence/)

Ordem:
1. Lucas OK na lista exaustiva grep (Phase 0 output)
2. Para cada arquivo: Read → diff → Lucas OK → Edit (ou delete)
3. Build PASS após cleanup: `npm run build:metanalise`

### Phase 2 — Order reconcile `metanalise/HANDOFF.md` (~10-15 min)

Stale desde S162 (auto-admitido linha 20). Manifest source of truth = 17 slides:

```
F1: s-title, s-objetivos, s-hook, s-importancia
F2: s-rs-vs-ma, s-quality, s-contrato, s-pico, s-forest1, s-forest2,
    s-rob2, s-pubbias1, s-pubbias2, s-heterogeneity, s-fixed-random
F3: s-etd, s-contrato-final
```

Edits granulares (Edit minimal, NÃO rewrite):
1. Linha 12: "16/16 no deck" → "17/17 no deck"
2. Linhas 30-37: "Ordem do deck (atualizada S157)" — substituir pela ordem manifest
3. Linhas 41-86: tabelas "Estado dos Slides" — sync com manifest (remove s-checkpoint-2/s-aplicabilidade, add s-rob2/s-pubbias1/s-pubbias2/s-etd/s-contrato-final)
4. Linhas 84-86: "Resumo" — contar DONE/QA/LINT-PASS reais
5. Linha 20: deletar nota "manifest real = 17 slides — HANDOFF abaixo desatualizado desde S162" (resolvida)

Cada subitem com diff-first.

### Phase 3 — s-forest1 QA cycle (~30-40 min)

KBP-05 anti-batch. Pipeline `gemini-qa3.mjs`:

1. **Preflight** ($0): `node scripts/gemini-qa3.mjs --aula metanalise --slide s-forest1 --preflight`
2. Reportar warnings/errors. **[Lucas OK]**
3. **Inspect** (Gemini Flash): `--inspect`
4. Reportar findings. Edits propostas (diff-first). **[Lucas OK por fix]**
5. Edits (se houver): Read full antes, diff, Lucas OK
6. `npm run lint:slides metanalise` PASS → `npm run build:metanalise`
7. `qa-capture.mjs` screenshot atualizado
8. **Editorial** (Gemini Pro): `--editorial`
9. Reportar scorecard. Score < 7 → checkpoint Lucas. **[Lucas approve]**
10. Edit `metanalise/HANDOFF.md`: s-forest1 LINT-PASS → DONE (Edit minimal)

Threshold rubric: medical GSAP = 6-8 (anti-sycophancy ceiling, qa-pipeline.md §E069). Uniform stagger = max 7. CountUp without pause = max 6.

### Phase 4 — s-forest2 QA cycle (~30-40 min)

Mesma sequência Phase 3 com `--slide s-forest2`. Atenção: clickReveals=8 (mais complexo que forest1=5) — review motion grouping (priority_actions s-contrato R11 #3 sugere mesma vigilância).

### Phase 5 — Session close (~10-15 min)

1. **Diff cross-window**: `git fetch && git status` — confirmar HANDOFF root / CHANGELOG root estado
2. **HANDOFF root**: append/edit S264 close (Edit minimal, append novo bloco se necessário)
3. **CHANGELOG root**: append S264 entry (1 linha por mudança, max 5 li aprendizados)
4. **`metanalise/CHANGELOG.md`**: append bloco S264 (estava silent S260-S263 conforme Explore agent)
5. **Stop dev server**: kill PID specific (NUNCA `taskkill //IM node.exe`)
6. **Commit**: após Lucas OK explícito. `git branch --show-current` antes. Sem `--no-verify`. Co-authored-by Opus 4.7.

## Out of scope esta janela

- **s-contrato R11=5.9 REOPEN** (2 MUST: CSS failsafe unscoped + subgrid) — segue pendente, surface em HANDOFF P0 close
- S264 P0 bench script×agent (outra janela)
- s-objetivos R11 artifact action
- Specialty cleanup carryover, tone propagation, R3 prep

## Verification per slide

Antes de cada gate seguinte:
1. `npm run lint:slides metanalise` → PASS
2. `npm run build:metanalise` → PASS (`metanalise/index.html` regenerado)
3. `node scripts/qa-capture.mjs --aula metanalise --slide {id}` → screenshot atual
4. Gate run completo (preflight/inspect/editorial)
5. Vite live preview no browser quando Lucas pedir

## Critical files

| Arquivo | Phase | Tipo |
|---------|-------|------|
| `content/aulas/metanalise/slides/08a-forest1.html` | 3 | Edit possível |
| `content/aulas/metanalise/slides/08b-forest2.html` | 4 | Edit possível |
| `content/aulas/metanalise/evidence/s-forest-plot-final.html` | 0 | Read context |
| `content/aulas/metanalise/metanalise.css` | 1, 3, 4 | Edit possível |
| `content/aulas/metanalise/slide-registry.js` | 1, 3, 4 | Edit possível |
| `content/aulas/metanalise/HANDOFF.md` | 1, 2, 3, 4 | Edit minimal |
| `content/aulas/metanalise/CHANGELOG.md` | 5 | Append |
| `content/aulas/metanalise/qa-screenshots/s-absoluto/` | 1 | Delete (dir) |
| `HANDOFF.md` (root) | 1, 5 | Edit minimal cross-window-safe |
| `CHANGELOG.md` (root) | 5 | Append cross-window-safe |
| `.claude/.session-name` | 0 | Write |

## Reference docs (already loaded via SessionStart)

- `.claude/rules/qa-pipeline.md`, `slide-rules.md`, `design-reference.md`, `anti-drift.md`, `known-bad-patterns.md`
- `content/aulas/CLAUDE.md`, `content/aulas/metanalise/CLAUDE.md`
- `content/aulas/metanalise/HANDOFF.md`, `content/aulas/metanalise/slides/_manifest.js`

## Primeira ação após approval

1. `npm run dev:metanalise` (background, port 4102) — vite up
2. `echo -n "qa-editorial-metanalise" > .claude/.session-name`
3. TaskCreate batch (6 tasks)
4. Phase 0: pre-flight reads + dead-code grep s-absoluto repo-wide
5. Lucas review da grep list → Phase 1 cleanup
