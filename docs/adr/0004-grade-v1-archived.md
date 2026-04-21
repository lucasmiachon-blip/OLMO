# ADR-0004: grade-v1 Archived

- **Status:** accepted
- **Data:** 2026-04-21
- **Deciders:** Lucas + Claude (Opus 4.7)
- **Sessão:** S237-Beggining_GRADE_V2

## Contexto

`content/aulas/grade/` era legacy (58 slides, 60 HTML, 91 files, 2.8MB) produzida S107-S178, pre-slideologia + pré-shared-v2 tokens. S237 P0 pivot define **grade-v2 greenfield** em `content/aulas/grade-v2/` (ver ADR-0005). Presença do legacy contamina Grep/Read durante dev grade-v2 e gera ambiguidade de nomenclatura para future readers.

## Decisão

Archive `content/aulas/grade/` via estratégia 3-2-1 aplicada **neste caso específico**:

| Copy | Media | Path | Contains |
|---|---|---|---|
| 1 | git branch | `legacy/grade-v1` (HEAD pré-deleção) | 70 tracked files (HTML slides, CSS, JS, manifest) |
| 2 | git tag | `grade-v1-final` (commit `ccbaefe` S178) | snapshot semântico do último touch |
| 3 | tar.gz external | `C:\Dev\Projetos\OLMO_primo\grade-v1-qa-snapshot-2026-04-21.tar.gz` | 22 orphans gitignored (index.html build + qa-screenshots 2026-03-30) |

**Recovery order (fallback chain):** branch → tag → tar. Branch é estado mais fresco (inclui infra updates pós-S178, 70 files completos); tag é snapshot rigoroso pontual (ccbaefe, mais antigo mas semanticamente significativo); tar cobre orphans regeneráveis que não entram em git history.

Remove `content/aulas/grade/` do working tree via `git rm -r`; append `content/aulas/grade/` em `.claudeignore` bloqueia futuro Grep/Read indexing.

## Consequências

- **Positivas:** clean dev env para grade-v2 (zero Grep/Read contamination); recovery triplo redundante cobre branch corruption, tag loss, e orphan-specific restore.
- **Negativas:** orphans fora de git history (tar como única cópia); perda de tar = perda definitiva de QA screenshots histórico.

## Alternativas consideradas

1. **Manter in-repo read-only** — rejected: Grep/Read contamination persistente + ambiguidade nome grade/grade-v2.
2. **Archive método único (só branch OU só tar)** — rejected: single-point-of-failure inaceitável para 2.8MB histórico.
3. **Migrar para separate git repo** — rejected: over-engineering para N=1 archive.

## Escopo desta ADR

**Pontual para grade-v1.** Estratégia 3-2-1 foi aplicada aqui como **N=1 data point**. **Promoção a pattern canônico** para futuros aulas archives **fica deferida** até evidência N=2+ (próxima aula arquivada). Se próxima archive seguir mesmo padrão em condições comparáveis, documentar pattern em ADR separado (ex: "Aula Archive Policy"). Rule-of-N=2+ prevents premature abstraction.

## Ref cruzada

- Commit `939c847` S237 C2 (execution)
- `HANDOFF.md §Estado factual` (grade-v1 archived note)
- `content/aulas/CLAUDE.md §Legacy Archives` (public-facing doc)
- `C:\Dev\Projetos\OLMO_primo\README.md` (archive location + contents table)
- ADR-0005 (shared-v2 greenfield — contexto de por que grade-v2 existe, motivando archive de grade-v1)
