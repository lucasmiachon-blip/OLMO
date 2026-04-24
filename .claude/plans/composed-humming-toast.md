# S245 — CLAUDE.md ENFORCEMENT #5: "Ler os documentos antes de mudar"

## Context

Lucas pediu: "coloque em claude md ler os documentos antes de mudanca". Sessao S245 foca em **estetica + QA slides + pesquisa** — dominios que tocam areas pouco frequentes (CSS/GSAP, gemini-qa3.mjs, research/SKILL.md), onde reler governing docs antes de mudar evita retrabalho e violacao de convencoes estabelecidas.

**Gap confirmado (Phase 1 Explore):**
- Zero regras em `.claude/rules/*.md` cobrem "ler governing docs antes de Edit em novo dominio" em primacy level
- KBP-25 (§Edit discipline) cobre apenas Read do arquivo-alvo (±20 li) para precisao de whitespace — **nao cobre governing layer**
- §Verification (anti-drift) e reativa ("Claim about X → read source"), nao proativa
- Governing-docs pattern (ler CLAUDE.md-subarea / ADR / SKILL.md antes de domain work) e **AUSENTE em todos os rules files**
- `Propagation Map` em CLAUDE.md diz **o que atualizar depois**, nao **o que ler antes**

S244 detox deixou ENFORCEMENT com 4 itens. Proxima vaga #5 alinhada com primacy anchor — high visibility por session load.

## Change (primary — escopo Lucas)

**File:** `C:\Dev\Projetos\OLMO\CLAUDE.md` (linhas 3-9, §ENFORCEMENT)

Add item 5 apos item 4, antes da linha em branco L9:

```
5. **Ler os documentos antes de mudar.** Dominio novo ou pouco tocado → ler CLAUDE.md da subarea + `rules/*` + ADR/SKILL.md citados antes do primeiro Edit. "Pareceu obvio" nao dispensa.
```

### Formatting precision (KBP-25 — Edit discipline)

- **CRLF line endings** preservados (repo pattern)
- **Bullet at column 0** (pure `5.`, igual items 1-4 — sem indentacao)
- **Unicode chars usados:** arrow `→` (U+2192, ja presente no repo p.ex. item 3 pattern)
- **NAO usar em-dash** `—` (U+2014) neste item — evita risco Edit futuro
- **Keep blank line L9** separator para prose paragraph seguinte
- **Sem trailing whitespace**

### Exact Edit specs

```
old_string:
4. **Curiosidade obrigatoria.** Explicar o porque antes de executar. Ensinar durante, nao depois.

new_string:
4. **Curiosidade obrigatoria.** Explicar o porque antes de executar. Ensinar durante, nao depois.
5. **Ler os documentos antes de mudar.** Dominio novo ou pouco tocado → ler CLAUDE.md da subarea + `rules/*` + ADR/SKILL.md citados antes do primeiro Edit. "Pareceu obvio" nao dispensa.
```

## Optional secondary (Lucas decide — NAO incluir neste commit)

Explore agent recomendou three-layer approach. Duas adicoes opcionais:

1. **anti-drift.md §Edit discipline — novo bullet 0** antes de "Read full file OU range":
   ```
   0. Se dominio novo ou pouco tocado: ler governing docs (CLAUDE.md da subarea, ADR relevante, SKILL.md referenciado) antes do primeiro Edit. Precede qualquer Read de precisao.
   ```

2. **KBP-34 novo** em `known-bad-patterns.md`:
   ```
   ## KBP-34 Edit em dominio novo sem ler governing docs
   → anti-drift.md §Edit discipline bullet 0
   ```

**Recomendacao defensiva:** fazer **apenas primary** neste commit. Lucas pediu "claude md" explicito. Three-layer = scope creep (KBP-01). Se Lucas quiser, faz-se commit separado depois.

## Files modified

- `C:\Dev\Projetos\OLMO\CLAUDE.md` — 1 linha adicionada (item 5 ENFORCEMENT)

## Verification

1. **Read CLAUDE.md pos-Edit** — confirmar 5 itens ENFORCEMENT, formatacao CRLF preservada, blank line L9 intacta
2. **Grep** `5\. \*\*Ler os documentos antes de mudar` em CLAUDE.md — retorna exatly 1 hit
3. **Visual check** — bullet `5.` aparece no mesmo indent-level dos items 1-4
4. **No trailing whitespace, no duplicate blank lines**
5. **Git diff** — confirma +1 linha em CLAUDE.md, nada mais tocado
6. **Commit:** `docs(CLAUDE.md): ENFORCEMENT #5 — ler documentos antes de mudar`

## Session metadata

- `.claude/.session-name` ja gravado: `estetica + QA slides + pesquisa`
- CHANGELOG S245 + HANDOFF update apos commit (per anti-drift §Session docs)

## Session follow-up (escopo S245 pos-Edit)

Apos primary commit, Lucas escolhe:
- (a) Three-layer expansion (anti-drift bullet 0 + KBP-34)
- (b) Iniciar estetica (CSS/GSAP audit)
- (c) Iniciar QA slides (gemini-qa3 run)
- (d) Iniciar pesquisa (tema a definir)
