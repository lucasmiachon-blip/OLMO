# S227+ — Migrar Medical Evidence Memory → Living-HTML (SSoT)

> Status: DESIGN (proposto S225 iter 3, reprogramado S227; não executado S227-S229; ainda ACTIVE per HANDOFF / BACKLOG #36)
> Origin: Lucas durante S225 Phase 4 — "que tal usar o benchmark da aula de metanalise para fazermos em cirrose, paginas em html, source of truth tirarmos isso da memoria do sistema para ocupar com outras coisas?"

---

## Context

S225 Phase 4 consolidou memoria agent-researcher (8→6 files) + global (20→19, estrutura_output absorbido em research). Merge foi "salvar tempo" mas não resolve arquitetural: **medical evidence em agent-memory é anti-pattern**.

**Insight Lucas:** metanalise aula já tem padrão living-HTML em `content/aulas/metanalise/evidence/` com 17 files — convention madura (project_living_html.md: citation rules, PMIDs clickable VERIFIED, 3-layer pre-reading, design consistency). Esse é o SSoT correto.

**Thesis:** memoria do sistema deve conter **comportamento + padrões + user feedback**, não **conhecimento médico dense**. Medical evidence pertence em HTML versionado na própria aula, consumido pelo slide (project_living_html pattern), não injetado em cada prompt de agent.

---

## Benchmark: metanalise/evidence estrutura

```
content/aulas/metanalise/evidence/
├── blueprint.html
├── meta-narrativa.html
├── pre-reading-forest-plot-vies.html
├── pre-reading-heterogeneidade.html
├── s-ancora.html
├── s-contrato.html
├── s-forest-plot-final.html
├── s-heterogeneity.html
├── s-hook.html
├── s-importancia.html
├── s-objetivos.html
├── s-pico.html
├── s-pubbias.html
├── s-quality-grade-rob.html
├── s-rob2.html
├── s-rs-vs-ma.html
├── s-tipos-ma.html
└── _archive/ (old versions)
```

Padrão: `s-{slide-name}.html` (per-slide) + `pre-reading-{topic}.html` (per-topic cross-slide) + `blueprint.html` (meta).

CSS baseline: `pre-reading-heterogeneidade.html` (S148 benchmark).

---

## Mapping — 8 memory files → HTML

| Memory file (deletable post-migration) | Target HTML | Aula |
|---|---|---|
| cacld-screening-primary-care.md | content/aulas/cirrose/evidence/pre-reading-cacld-screening.html | cirrose |
| csph-nsbb-baveno-predesci.md | content/aulas/cirrose/evidence/pre-reading-csph-nsbb-baveno.html | cirrose |
| elastography-modality-comparison-and-limitations.md (merged S225) | content/aulas/cirrose/evidence/pre-reading-elastography-modality.html | cirrose |
| meld-na-score-evidence.md | content/aulas/cirrose/evidence/pre-reading-meld-na.html | cirrose |
| rule-of-five (absorbed in te-csph-accuracy-and-gray-zone.md S225) | content/aulas/cirrose/evidence/pre-reading-te-rule-of-5.html | cirrose |
| te-csph-accuracy-and-gray-zone.md (merged S225) | content/aulas/cirrose/evidence/pre-reading-te-csph-accuracy.html | cirrose |
| sr-ma-umbrella-definitions.md | (já pertence ao metanalise) content/aulas/metanalise/evidence/pre-reading-sr-ma-umbrella.html | metanalise |

**Note:** S225 merges já consolidaram 4→2 files — mapping aqui reflete estado pós-S225 (6 medical files restantes em evidence-researcher).

---

## Architecture post-migration

### SSoT = HTML living-evidence
- `content/aulas/cirrose/evidence/` — ~7 pre-reading HTML (por tópico, não por slide)
- `content/aulas/metanalise/evidence/` — +1 novo (sr-ma-umbrella)
- Cada HTML com: citation rules (PMID clickable quando VERIFIED), 3-layer pre-reading structure, design consistency (CSS base)

### Agent memory redirecionada
- `.claude/agent-memory/evidence-researcher/MEMORY.md` → redirect/index p/ HTML paths (não copia conteúdo)
- Dir evidence-researcher pode até ser REMOVIDO inteiramente se index global sufficient
- evidence-researcher agent via SKILL.md aprende a buscar living-HTML primeiro, pesquisa externa se gap

### Memoria global liberada
- Global continua 19/20 — estrutura memory inalterada (behavior/patterns/feedback)
- Migration NÃO muda global cap (diferente objetivo)

---

## Migration steps (S226)

### Step 1 — Pre-flight (30min)
- Verify `content/aulas/cirrose/evidence/` dir (glob: não existe — criar)
- Ler template: `content/aulas/metanalise/evidence/pre-reading-heterogeneidade.html` (S148 benchmark)
- Extract CSS + HTML skeleton
- Document PMID verification status: quais PMIDs já VERIFIED vs pendentes (V1 esummary batch)

### Step 2 — Template + first convert (45min)
- Write `content/aulas/cirrose/evidence/_template.html` (reusable skeleton)
- Convert 1 file end-to-end (recomendado: `te-csph-accuracy-and-gray-zone.md` — mais denso, valida template)
- Verify: browser render, CSS consistency, PMID clickables, tables formatted
- Get Lucas OK no benchmark

### Step 3 — Batch convert remaining 6 (3-4h)
- Per file: Read MD → compose HTML using template → preserve tables/sections/PMIDs
- PMID verification: V1 esummary (ncbi.nlm.nih.gov) se gap
- DOI links adicionados quando disponível
- Verify each in browser before next

### Step 4 — Agent integration (30min)
- Update evidence-researcher agent SKILL.md: "consult living-HTML first for cirrose/metanalise topics"
- Update `.claude/agent-memory/evidence-researcher/MEMORY.md`: convert from content index → HTML path index
- Optional: remove evidence-researcher memory dir entirely

### Step 5 — Delete old memory (10min)
- `git rm` 6 evidence-researcher .md files (content now in HTML)
- Commit

### Step 6 — Documentation + slide linkage (30min)
- Update CHANGELOG.md
- HANDOFF S227 START HERE
- Wire to slide HTML via project_living_html pattern (if applicable — each pre-reading references related slide IDs)

---

## Effort estimate S226

- Pre-flight: 30min
- Template + 1 file: 45min
- Batch 6: 3-4h (maior item)
- Integration + cleanup: 40min
- Docs + commit: 30min
- **Total: 5-6h sessão dedicada**

Alternativa: **migração parcial**. S226 faz template + 2-3 files. S227 completa restante. Reduz risco de slip.

---

## Risks + mitigations

1. **PMID verification incomplete**: HTML exige VERIFIED para clickable. Mitigar: V1 esummary batch antes; PMIDs não-VERIFIED ficam plain-text.
2. **Table formatting**: MD tables → HTML mal convertidas. Mitigar: validator diff script OR manual inspection post-convert.
3. **Slide linkage ambiguity**: project_living_html diz "per slide"; migration é "per topic". Decidir S226: manter topic-based (independent of slides) OR refatorar para slide-based.
4. **Scope creep**: tentativa de converter ALL memory (non-medical) = scope creep. Strict scope: 6-7 medical files apenas.
5. **Cirrose aula immature**: cirrose não tem evidence/ dir ainda. Criar OK mas adiciona scope.

---

## Decision points (Lucas aprova S226 start)

- **D1**: Cirrose evidence dir — criar novo OR usar docs/evidence/ existente?
- **D2**: Living-HTML topic-based OR slide-based mapping?
- **D3**: Migrar ALL 6 em S226 OR partial (template + 2-3)?
- **D4**: evidence-researcher dir — esvaziar mas preservar MEMORY.md como index, OU remover inteiro?

---

## References

- `project_living_html.md` (memory) — citation rules, 3-layer structure, clickable PMIDs
- `content/aulas/metanalise/evidence/pre-reading-heterogeneidade.html` — benchmark file (S148)
- S225 Phase 4 plan (parent context): `ACTIVE-S225-consolidacao-plan.md`
- Lucas trigger S225 iter 3: "tirarmos isso da memoria do sistema para ocupar com outras coisas"

---

Coautoria: Lucas + Opus 4.7 | S226 design plan drafted S225 | 2026-04-17
