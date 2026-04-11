# Plan: Verificacao de CANDIDATE PMIDs nos Living HTMLs

## Context

S148 aplicou PMIDs clicaveis e badges V/C nos evidence HTMLs. Restam ~30 marcadores `<span class="c">CANDIDATE</span>` em 5 arquivos, mapeando a ~14 PMIDs numericos + ~8 itens sem PMID. Regra: PMID so vira link apos 3-field cross-ref (autor + titulo + journal) via PubMed MCP. Taxa de erro ~56% em PMIDs de LLM — verificacao eh obrigatoria.

## Inventario (5 arquivos, ~22 itens unicos)

### Tier 1: PMIDs com numero — verificar via `get_article_metadata` (14 calls)

| # | PMID | Citacao esperada | Arquivo(s) |
|---|------|-----------------|------------|
| 1 | 15634359 | Dawes 2005, Sicily Statement, BMC Med Educ | s-objetivos |
| 2 | 29713212 | Nasr 2018, forest plot literacy, J Community Hosp Intern Med Perspect | s-objetivos (5 locais) |
| 3 | 38938910 | Borenstein 2023, I-squared, Integr Med Res | s-objetivos (4 locais) |
| 4 | 24528395 | Ilic 2014, teaching methods SR, Med Educ | s-objetivos |
| 5 | 15189255 | Rees 2004, outcomes-based curricula, Med Educ | s-objetivos |
| 6 | 24909434 | ACE Tool (autor TBD) | s-objetivos |
| 7 | 26657463 | Aromataris 2015, umbrella review, JBI | s-rs-vs-ma |
| 8 | 34384532 | Garritty 2021, rapid review, Syst Rev | s-rs-vs-ma |
| 9 | 28912002 | Elliott 2017, living SR, J Clin Epidemiol | s-rs-vs-ma |
| 10 | 16268861 | Whittemore 2005, integrative review, J Adv Nurs | s-rs-vs-ma |
| 11 | 16053581 | Pawson 2005, realist review, J Health Serv Res Policy | s-rs-vs-ma |
| 12 | 26287849 | Hyman 2015, basket trial, NEJM | s-rs-vs-ma |
| 13 | 41325621 | Soumare 2026, corticosteroids, Ann Intern Med | forest-plot-candidates |
| 14 | 37847274 | Juraschek 2023, PA+HO, JAMA | forest-plot-candidates |

### Tier 2: PMC→PMID via `convert_article_ids` (2 conversions + 2 metadata)

| # | ID | Citacao | Arquivo |
|---|-----|---------|---------|
| 15 | PMC12991648 | GLP-1 NMA (autor/journal TBD) | forest-plot-candidates |
| 16 | PMC12843294 | SGLT2i HF+DM2 (autor/journal TBD) | forest-plot-candidates |

### Tier 3: Lookup por citacao — `lookup_article_by_citation` / `search_articles` (6-8 calls)

| # | Citacao | Arquivo |
|---|---------|---------|
| 17 | Renfro & Sargent 2017, master protocols, Ann Oncol | s-rs-vs-ma |
| 18 | Park et al. JCO 2022, master protocols | s-rs-vs-ma |
| 19 | CLEAR SYNERGY 2024 (colchicine post-PCI) | forest-plot-candidates, s-forest-plot |
| 20 | Ebrahimi 2025, Cochrane colchicine (DOI ok, PMID?) | forest-plot-candidates, s-forest-plot |
| 21 | Berlin Questionnaire (EBM tool, PMID?) | s-objetivos |
| 22 | Fresno Test (EBM tool, PMID?) | s-objetivos |

### Tier 4: Referencia generica (0 calls)

| # | Item | Arquivo | Acao |
|---|------|---------|------|
| 23 | "Cochrane fracture reviews" (stat 12%) | s-pico | Nao eh paper unico. Manter nota descritiva. |

## Execucao em 3 batches

### Batch A — Tier 1 completo (14 calls paralelos)
1. Disparar 14x `get_article_metadata` em paralelo
2. Para cada resultado, checar 3 campos (autor, titulo, journal)
3. **3/3 match** → upgrade C→V + link clicavel
4. **Mismatch** → tentar `lookup_article_by_citation` como fallback
5. Editar s-objetivos.html e s-rs-vs-ma.html

### Batch B — Tier 2 + Tier 3 parcial (8-10 calls)
1. `convert_article_ids` para PMC12991648, PMC12843294, DOI Ebrahimi
2. `search_articles("CLEAR SYNERGY colchicine 2024")`
3. Follow-up `get_article_metadata` nos PMIDs retornados
4. Editar forest-plot-candidates.html e s-forest-plot.html

### Batch C — Tier 3 restante (4-6 calls)
1. Lookup Renfro/Sargent, Park/JCO, Berlin Questionnaire, Fresno Test
2. Editar s-rs-vs-ma.html e s-objetivos.html

## Resultados possiveis por item

| Resultado | Badge | HTML |
|-----------|-------|------|
| 3/3 match | `<span class="v">V</span>` | `<a class="ref-pmid" href="https://pubmed.ncbi.nlm.nih.gov/{PMID}" target="_blank">{PMID}</a>` |
| DOI ok, PMID nao indexado | `<span class="v">V</span>` | Manter link DOI existente, nota "PMID pending" |
| Sem PMID, literatura cinza | `<span class="w">GREY-LIT</span>` | URL estavel se disponivel |
| Mismatch nao resolvido | `<span class="w">?</span>` | Reportar a Lucas para decisao |

## Pos-edicao

1. Grep por cada PMID corrigido em TODOS os arquivos (mesmo PMID aparece em multiplos locais)
2. Atualizar contagens no footer de cada arquivo (ex: "7 VERIFIED, 6 CANDIDATE" → novo total)
3. Commit com mensagem descritiva

## Budget estimado

~28-33 MCP calls (best case) / ~35-40 (worst case com fallbacks de mismatch)

## Arquivos criticos

- `content/aulas/metanalise/evidence/s-objetivos.html` (~11 markers)
- `content/aulas/metanalise/evidence/s-rs-vs-ma.html` (~8 markers)
- `content/aulas/metanalise/evidence/forest-plot-candidates.html` (~7 markers)
- `content/aulas/metanalise/evidence/s-forest-plot.html` (~3 markers)
- `content/aulas/metanalise/evidence/s-pico.html` (~1 marker)

## Verificacao

- Apos cada batch: grep `CANDIDATE` no diretorio evidence/ → contagem deve diminuir
- Apos todos: zero CANDIDATE restante (ou apenas itens que Lucas decidiu manter)
- Build: `npm run build` de `content/aulas/` para confirmar HTML valido
