# Evidence HTML Audit — S150

> Sessao 150 | 2026-04-10 | Fase 1 (read-only)
> Scope: 14 evidence HTMLs em `content/aulas/metanalise/evidence/`
> Benchmark: `pre-reading-heterogeneidade.html` (S148)
> Coautoria: Lucas + Opus 4.6

## Sumario executivo

| Metrica | Valor |
|---|---|
| Arquivos auditados | 14 |
| Arquivos com PubMed URLs | 8 / 14 |
| Arquivos com DOI URLs | 6 / 14 |
| Total PubMed URLs no projeto | 117 |
| Total DOI URLs no projeto | 18 |
| URLs PubMed com trailing slash `/` | **13** (todas em `s-objetivos.html`) |
| URLs PubMed sem `target="_blank"` | **13** (mesmas de acima — drift concentrado) |
| `<th>` tags total | 87 |
| `<th>` com `scope=` (a11y) | **1** (so `s-forest-plot.html`) |
| Links `target="_blank"` com `rel="noopener"` | **0 / 104** |
| Bugs HTML encontrados | **1 confirmado** (s-checkpoint-1:183) |
| Arquivos sem qualquer citacao (potencial violacao) | **3** (s-importancia, s-pico, pre-reading-forest-plot-vies) |

**Headline:** o drift de formato de **links** esta concentrado em 1 arquivo (`s-objetivos.html`) — fix cirurgico. O problema mais grave e **estrutural**: 3 arquivos sem citacoes quando deveriam ter, 1 arquivo com PMIDs em PROSA (violacao direta da regra), e 1 bug HTML. **Acessibilidade** e baseline ~zero — trabalho transversal em todos os 14 arquivos.

---

## Matriz de estado (14 arquivos)

Legend:
- PMID/DOI counts: numero de URLs do tipo no arquivo
- `TS`: trailing slash em PubMed URL (deve ser 0)
- `NoTG`: PubMed URL sem `target="_blank"` (deve ser 0)
- `#ref`: tem `<section id="referencias">` (✓/✗)
- CSS: quantas das 7 classes benchmark (`ref-pmid`, `.v`, `.c`, `.key-takeaway`, `.caveat`, `.gap-card`, `.core-step`) estao declaradas
- `<th>`: total / com scope
- `rel`: total `rel="noopener"` (deve ser = total `target="_blank"`)

| # | Arquivo | PMID | DOI | TS | NoTG | #ref | CSS 7/7 | th/scope | rel | Priority | Notas |
|---|---------|-----:|----:|---:|-----:|:----:|:-------:|---------:|----:|:--------:|-------|
| 1 | `pre-reading-heterogeneidade.html` | 16 | 5 | 0 | 0 | ✗ | **7/7** | 3/0 | 0 | — | **BENCHMARK.** Read-only. Nao modificar. |
| 2 | `pre-reading-forest-plot-vies.html` | 0 | 0 | 0 | 0 | ? | 4/7 | 3/0 | 0 | **P1** | **Zero citacoes** — pre-reading sem refs suspeito. Investigar scope |
| 3 | `blueprint.html` | 0 | 0 | 0 | 0 | ? | 2/7 | 6/0 | 0 | P2 | Prose narrative. 2 CSS classes apenas. |
| 4 | `meta-narrativa.html` | 0 | 0 | 0 | 0 | ? | 3/7 | 2/0 | 0 | P3 | Prose narrative. Layout arco narrativo. |
| 5 | `s-ancora.html` | 6 | 1 | 0 | 0 | ✓ | 3/7 | 4/0 | 0 | P1 | **DOI format drift** (label = DOI text, nao "DOI") |
| 6 | `s-checkpoint-1.html` | 13 | 2 | 0 | 0 | ✓ | 3/7 | 7/0 | 0 | **P0** | **Bug HTML linha 183** `</a></td></li>` (td orfao) + **badges V faltando linhas 183-185** + DOI format drift linhas 93, 115 |
| 7 | `s-contrato.html` | 0 | 0 | 0 | 0 | ? | 3/7 | 3/0 | 0 | P3 | Contrato pedagogico, possivel prose-only. Investigar scope |
| 8 | `s-forest-plot.html` | 12 | 2 | 0 | 0 | ✗ | 5/7 | 10/**1** | 0 | P2 | Slide deprecated (removido S146). DOI format drift linhas 91, 140. Unico com 1 `<th scope>` |
| 9 | `s-hook.html` | 33 | 0 | 0 | 0 | ✓ | 3/7 | 5/0 | 0 | P3 | **Formato benchmark 100% compliant.** Apenas a11y pending |
| 10 | `s-importancia.html` | **0** | 0 | 0 | 0 | ? | 4/7 | 7/0 | 0 | **P1** | **Zero PMIDs** — cita autores (Borenstein 2021, Lau 1992, Yusuf 1985, Kastrati 2024) mas SEM PMID. **Violacao de project_living_html.md** |
| 11 | `s-objetivos.html` | 14 | 1 | **13** | **13** | ✓ | 3/7 | 4/0 | 0 | **P1** | **Format drift concentrado:** linhas 278-290 #referencias todos com trailing slash E sem target |
| 12 | `s-pico.html` | **0** | 0 | 0 | 0 | ✓ | 6/7 | 5/0 | 0 | **P1** | **PMIDs plain text em PROSA** (linhas 171, 176) — **violacao da regra**. `.ref-pmid` CSS existe mas nao usado no HTML. `.82rem` vs benchmark `.85rem` (drift CSS) |
| 13 | `s-rs-vs-ma.html` | 12 | 0 | 0 | 0 | ✓ | 3/7 | 4/0 | 0 | P2 | S149 updated. Baseline clean |
| 14 | `forest-plot-candidates.html` | 11 | 7 | 0 | 0 | ✗ | 4/7 | 24/0 | 0 | P2 | Deep catalog. Mix V/C badges corretos. Sem #referencias (estrutura de catalog) |

---

## Achados prioritarios

### P0 — Bug HTML (bloqueador de markup validity)

**s-checkpoint-1.html:183**
```html
<li>ACCORD Study Group (2011). ... PMID: <a class="ref-pmid" href="..." target="_blank">21366473</a></td></li>
                                                                                          ^^^^^^^ orfao
```
O `</td>` fecha uma tag que nunca foi aberta (o contexto e `<ol class="ref-list"><li>`, nao uma tabela). Markup broken.

**Tambem nas linhas 183-185:** badge `<span class="v">VERIFIED</span>` ausente, enquanto 180-182 tem. Inconsistencia intra-arquivo.

### P1 — Violacoes de `project_living_html.md`

1. **s-pico.html — PMIDs em prosa** (linhas 171, 176, 181-186, 232-236)
   ```
   Linha 171: '...Goldkuhle et al. 2023, PMID 37146659)' (dentro de <p>)
   Linha 176: '...Guyatt et al. 2011, PMID 21802903)' (dentro de <p>)
   ```
   Regra violada: "PMIDs clicaveis APENAS em `#referencias` tables/lists + Nunca na prosa narrativa nem no corpo do slide". Todos os PMIDs sao plain text — nenhum clicavel, apesar de `.ref-pmid` CSS estar declarado.

2. **s-importancia.html — zero PMIDs**
   Cita Borenstein 2021 (linha 58), Kastrati & Ioannidis 2024 (linha 78), Yusuf 1985 (linha 92), Lau 1992 (linhas 102, 112) — sem PMID. Nao ha `#referencias` section. Regra: "Dados numericos verificados (PMID ou [TBD])" + "Living HTML por slide e canonico". Todos os autores citados deveriam ter referencia rastreavel.

3. **pre-reading-forest-plot-vies.html — zero citacoes**
   Pre-reading que deveria seguir o padrao benchmark (`pre-reading-heterogeneidade.html` tem 16 PMIDs + 5 DOIs). Se for intencional (overview pre-aula sem refs), precisa ser confirmado. Caso contrario, falta conteudo referencial.

### P1 — Format drift concentrado

**s-objetivos.html linhas 278-290** (13 refs no `<ol class="ref-list">`)
```html
<!-- ATUAL (drift): -->
<a class="ref-pmid" href="https://pubmed.ncbi.nlm.nih.gov/25005654/">PMID 25005654</a>
<!--                                                            ^ trailing slash       ^ sem target="_blank" -->

<!-- ALVO (benchmark): -->
<a class="ref-pmid" href="https://pubmed.ncbi.nlm.nih.gov/25005654" target="_blank">PMID 25005654</a>
```
PMIDs afetados (13): 25005654, 17785646, 28935701, 32870085, 25284006, 37640836, 22225439, 29713212, 38938910, 15634359, 24528395, 33782057, 15189255.

### P1 — DOI format drift (label inconsistente)

**s-checkpoint-1.html:93, 115 / s-ancora.html:88 / s-forest-plot.html:91, 140**
```html
<!-- ATUAL (drift): -->
<a class="ref-pmid" href="https://doi.org/10.1016/S0140-6736(09)60697-8" target="_blank">10.1016/S0140-6736(09)60697-8</a>

<!-- ALVO (benchmark): -->
<a class="ref-pmid" href="https://doi.org/10.1016/S0140-6736(09)60697-8" target="_blank">DOI</a>
```
Label deveria ser o texto literal `DOI`, nao o DOI number. Afeta 5 ocorrencias em 4 arquivos.

### P2 — CSS benchmark adoption incomplete

Classes do benchmark (`pre-reading-heterogeneidade.html` tem 7/7):
- `.ref-pmid` (link style)
- `.v` (badge VERIFIED azul)
- `.c` (badge CANDIDATE vermelho)
- `.key-takeaway` (green callout)
- `.caveat` (amber callout)
- `.gap-card` (gap indicator)
- `.core-step` (numbered step)

| Arquivo | Count | Faltam |
|---|:---:|---|
| blueprint.html | 2/7 | 5 classes |
| s-ancora, s-rs-vs-ma, s-objetivos, meta-narrativa, s-checkpoint-1, s-hook, s-contrato | 3/7 | 4 classes |
| pre-reading-forest-plot-vies, s-importancia, forest-plot-candidates | 4/7 | 3 classes |
| s-forest-plot | 5/7 | 2 classes |
| s-pico | 6/7 | 1 classe |
| **pre-reading-heterogeneidade (BENCHMARK)** | 7/7 | — |

Nota importante: a "falta" de classes pode ser legitima — se o arquivo nao precisa de `.gap-card`, nao precisa declarar. A Fase 4 nao deve forcar 7/7. Apenas adicionar as que FALTAM mas sao usadas no HTML ou sao obviamente necessarias.

### P3 — Acessibilidade (baseline ~zero)

- **`<th scope=>`: 1 de 87** (so `s-forest-plot.html` tem 1). Fix transversal: adicionar `scope="col"` ou `scope="row"` em todos os table headers.
- **`rel="noopener noreferrer"`: 0 de 104** links `target="_blank"`. Security + a11y. Fix transversal em todos os 8 arquivos com links externos.
- **Badges color-only**: `.v` (azul) vs `.c` (vermelho) ja tem font-weight 700, mas color-only communication falha WCAG 2.1. Text fallback: ja presente em alguns casos (`<span class="v">VERIFIED</span>` vs so `V`). **Padronizar**: usar texto completo `VERIFIED`/`CANDIDATE` em vez de `V`/`C` quando possivel.

---

## Suspicious PMIDs (para Fase 3 PubMed MCP verification)

Lucas ja sinalizou que S149 encontrou erros. A auditoria nao re-verifica PMIDs ja marcados VERIFIED. Candidatos para re-verificacao ou verificacao inicial nesta rodada (Lucas decide prioridade):

### Ja flagados previamente
1. **Nasr 29713212** (`s-objetivos.html:285`, `s-rs-vs-ma.html`?) — PMID ok mas dados forest plot nao confirmados no abstract (flagged S149). **Decisao pendente do Lucas:** manter como `<span class="v">V</span> [dados nao no abstract]` ou remover o dado 44→76%?

### CANDIDATE ainda nao verificados (de HANDOFF Batch B/C)
2. **Ebrahimi (Cochrane colchicina)** — DOI ok, PMID nao encontrado. Em `forest-plot-candidates.html:158` marcado `<span class="c">C</span>`
3. **GLP-1 RAs PMC12991648** — conversao PMC→PMID pendente
4. **SGLT2i PMC12843294** — conversao PMC→PMID pendente
5. **CLEAR SYNERGY** — nao identificado
6. **Renfro/Sargent**, **Park/JCO**, **Berlin Questionnaire**, **Fresno Test** — Batch C pendente

### A confirmar pela primeira vez (descobertos nesta auditoria)
7. **s-hook.html linhas 89-132** — 33 PMIDs total, todos com `<span class="v">VERIFIED</span>` badge. Amostra visual: Hoffmann 34091022, Bojcic 37931822, Siedler 40969451, Qureshi 41428154, Windish 17785646, Ioannidis 27620683, Niforatos 31355871, Siemens 33741503, Fanaroff 30874755, Lakhlifi 37081292, Saposnik 27809908, Wilkinson 40349737, Brignardello-Petersen 39218429, Paul 40414366, Uttley 39542225, Xu 40268307, Possamai 40163084, Herrera-Perez 31182188, Ioannidis 16014596. **Todos marcados VERIFIED** — status de verificacao real nao rastreado pela auditoria (usa a marcacao existente). Sample random check recomendado.

### Geradores de risco (plain text PMIDs em prose — high fabricacao risk)
8. **s-pico.html** 6 PMIDs em prose: 37146659 (Goldkuhle 2023), 21802903 (Guyatt 2011), 40393729 (Guyatt 2025), 41207400 (Colunga-Lozano 2025), 17238363 (Huang 2006), 28234219 (Adie 2017), 37575761 (VTS med ed — ja marcado INVALID no comentario linha 236). 5 PMIDs nao verificados via MCP.

**Recomendacao:** na Fase 3, priorizar s-pico.html (6 PMIDs em risco) + Nasr pendencia + Batch B/C pendentes.

---

## Priorizacao sugerida para Fases 2-5

### Fase 2 (P0 + P1 format fixes) — blast radius minimo
- **s-checkpoint-1.html:183-185** — bug HTML (`</td>` orfao) + adicionar `<span class="v">VERIFIED</span>` em 3 linhas (1 commit)
- **s-objetivos.html:278-290** — remover 13 trailing slashes + adicionar 13 `target="_blank"` (1 commit, sed-friendly)
- **s-checkpoint-1.html:93, 115 + s-ancora.html:88 + s-forest-plot.html:91, 140** — normalizar DOI label (4 arquivos, 1 commit cada)

### Fase 3 (PubMed MCP verification) — 1 PMID por vez, Lucas aprova cada
- s-pico.html 6 PMIDs plain text
- Nasr 29713212 decisao (manter flag ou remover dado)
- Batch B/C pendentes (11 CANDIDATEs em 5 HTMLs per HANDOFF)

### Fase 4 (CSS benchmark adoption) — apenas classes realmente usadas
- s-contrato, s-rs-vs-ma, s-hook, meta-narrativa: adicionar classes que forem HTML-used
- blueprint.html: mais pesado, 5 classes possivelmente necessarias
- s-pico.html CSS drift: `.ref-pmid` font-size `.82rem` → `.85rem`

### Fase 5 (a11y + polish) — transversal, mecanico
- `<th scope="col">` em 86 table headers (14 arquivos)
- `rel="noopener noreferrer"` em 104 links `target="_blank"` (8 arquivos)
- Padronizar texto de badges (`V`/`C` → `VERIFIED`/`CANDIDATE` onde apropriado)

### Fases fora de scope desta sessao (backlog)
- **s-importancia.html** — conteudo faltante (autores sem PMID). Requer decisao editorial do Lucas: adicionar `#referencias` section? tratar como prose-only? Backlog separado.
- **pre-reading-forest-plot-vies.html** — idem. Requer decisao de escopo (pre-reading deve ter refs ou nao?)
- **s-contrato.html, blueprint.html, meta-narrativa.html** — prose narrativo, podem ficar como estao

---

## Metodologia

Auditoria read-only via `Grep` e `Read` tools. Nenhum script novo criado (KBP-03). Contagens obtidas via `rg --count`. Inspecao de linhas via `Read` com offset/limit para arquivos grandes. Total de chamadas de ferramentas: ~20 (14 arquivos × 1-2 dimensoes paralelas).

**Nao incluido na auditoria (delegado ao Lucas ou Fase 3):**
- Re-verificacao semantica de PMIDs ja marcados VERIFIED (assume-se correto)
- Analise de qualidade narrativa/pedagogica
- Validacao visual em browser (screenshots)

**Limitacoes:**
- Ripgrep nao suporta negative lookahead; "sem `target`" foi derivado por subtracao (117 total - 104 com target = 13 sem)
- `<th scope>` grep pode nao capturar atributos com aspas simples ou multilinha — validado como baseline zero, assume-se representativo

---

Coautoria: Lucas + Opus 4.6 | S150 2026-04-10
