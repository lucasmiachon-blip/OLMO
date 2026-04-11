# S150 — HTML improvements + PMID clickable (14 evidence HTMLs)

> Sessao 150 | 2026-04-10 | Foco: auditoria e normalizacao dos evidence HTMLs
> Coautoria: Lucas + Opus 4.6

## Context

**Por que este trabalho agora.** S148 aplicou o CSS benchmark (`pre-reading-heterogeneidade.html`) em 5 evidence HTMLs e tornou DOIs clicaveis. S149 verificou 14 PMIDs via PubMed MCP e corrigiu 2 erros (Aromataris 26360830, Garritty 33068715) + flagou Nasr 29713212 com dados forest plot nao confirmados. **Consequencia natural:** os outros ~9 arquivos nao passaram pelo mesmo tratamento, e os ja tocados acumularam drift de formato (ex: s-objetivos.html linha 270 usa formato benchmark enquanto linha 278 usa formato legado com trailing slash e texto "PMID {num}").

**Lucas observou:** "verificou e achou alguns valores errados" — reforcando a expectativa de que uma auditoria abrangente vai descobrir mais PMIDs suspeitos (consistent com KBP-04 e a taxa observada de ~56% erro em PMIDs gerados por LLM).

**Desfecho pretendido:** (1) todos os 14 evidence HTMLs com formato de link uniforme ao benchmark S148, (2) CSS benchmark adotado onde ainda falta, (3) PMIDs suspeitos catalogados para verificacao posterior via PubMed MCP — NAO auto-corrigidos, (4) visual polish + acessibilidade basica aplicados de forma conservadora. Saida: evidence HTMLs internamente consistentes + relatorio de suspeitos para o Lucas decidir o proximo batch de verificacao.

## Decisoes de Scope (confirmadas via AskUserQuestion)

- **Scope PMID:** auditar TODOS os 14 evidence HTMLs (nao so os 3 de S149)
- **Scope HTML improvements:** as 4 dimensoes — normalizacao de links, adocao do CSS benchmark, polish visual, acessibilidade (WCAG)
- **Safety rail:** auditoria read-only PRIMEIRO, batches de fix depois, cada um com aprovacao explicita

## Formato Benchmark (source: `pre-reading-heterogeneidade.html` linha 192, `.ref-pmid` class)

```html
<!-- PMID VERIFIED (clickable) -->
<a class="ref-pmid" href="https://pubmed.ncbi.nlm.nih.gov/{PMID}" target="_blank">PMID {PMID}</a> <span class="v">VERIFIED</span>

<!-- PMID CANDIDATE (NAO clickable) -->
<span class="c">C</span> CANDIDATE

<!-- DOI (sempre clickable) -->
<a class="ref-pmid" href="https://doi.org/{DOI}" target="_blank">DOI</a>
```

**CSS requerido:**
```css
.ref-pmid { color: #2563eb; text-decoration: none; font-size: .85rem; }
.ref-pmid:hover { text-decoration: underline; }
.v { background: #2563eb; color: #fff; font-size: .65rem; border-radius: 3px; padding: 0 .3rem; font-weight: 700; }
.c { background: #dc2626; color: #fff; font-size: .65rem; border-radius: 3px; padding: 0 .3rem; font-weight: 700; }
```

**Regras invariantes (de `project_living_html.md`):**
- PMIDs clicaveis APENAS em `#referencias` tables/lists + apenas se VERIFIED (3/3 match PubMed MCP)
- CANDIDATE = badge vermelho, SEM link (link errado e pior que sem link)
- NUNCA PMID inline na prosa narrativa nem no corpo do slide
- DOI sempre clicavel (scheme estavel)
- URL PubMed SEM trailing slash, `target="_blank"` obrigatorio

## Arquivos-alvo (14)

| # | Arquivo | Linhas | Status conhecido |
|---|---------|-------:|------------------|
|  1 | `pre-reading-heterogeneidade.html` | 317 | **Benchmark (gold standard).** Audit so — nao modificar |
|  2 | `pre-reading-forest-plot-vies.html` | 233 | Pode faltar layering 3-layer |
|  3 | `blueprint.html` | 223 | Zero PMIDs (prosa) — confirmar |
|  4 | `meta-narrativa.html` | 134 | A verificar |
|  5 | `s-ancora.html` | 169 | A verificar |
|  6 | `s-checkpoint-1.html` | 193 | Benchmark OK, **bug HTML linha 183** (`</td></li>` trocado) |
|  7 | `s-contrato.html` | 153 | A verificar |
|  8 | `s-forest-plot.html` | 255 | Slide removido S146; arquivo fica como historico |
|  9 | `s-hook.html` | 176 | **Formato benchmark 100% ✓** — audit so |
| 10 | `s-importancia.html` | 354 | **Zero PMIDs no grep** — suspeito, investigar |
| 11 | `s-objetivos.html` | ~305 | Drift: linha 270 benchmark vs linha 278 legado |
| 12 | `s-pico.html` | 269 | CSS proprio S144 — validar |
| 13 | `s-rs-vs-ma.html` | ~255 | S149 tocou, ~6 PMIDs em tables |
| 14 | `forest-plot-candidates.html` | 425 | S149 tocou, 19 PMIDs mix V/C |

## Abordagem: Fases sequenciais, cada fase com gate de aprovacao

### Fase 1 — Audit read-only (THIS session, primeiro)

**Entregavel:** `docs/evidence-html-audit-S150.md` (novo arquivo, unico criado nesta fase)

**Colunas da tabela de audit (uma linha por arquivo):**
1. `file` — caminho relativo
2. `pmid_total` — total de PMIDs encontrados
3. `pmid_linked` — quantos usam `.ref-pmid` corretamente
4. `pmid_plain` — quantos estao plain text fora de `#referencias` (OK) ou dentro (NAO OK)
5. `format_issues` — lista de linhas com formato drift (trailing slash, sem target, texto inconsistente)
6. `doi_total` / `doi_linked` — equivalente para DOIs
7. `css_benchmark` — ja tem `.ref-pmid`/`.v`/`.c`/`.key-takeaway`/`.caveat`? boolean por item
8. `html_bugs` — tags mal fechadas, atributos quebrados, encoding errors
9. `a11y_issues` — `<th scope>` ausente, badges color-only sem text, hrefs sem rel/target
10. `suspicious_pmids` — PMIDs que parecem errados (autor/journal/ano mismatch aparente no contexto, duplicados, numeros sequenciais suspeitos)
11. `fix_priority` — P0 (bug HTML) / P1 (format drift) / P2 (CSS benchmark) / P3 (a11y polish)

**Metodologia (read-only):**
- Grep por `PMID|pubmed\.ncbi|ref-pmid|doi\.org` em cada arquivo
- Read arquivo completo quando contagem >10 ocorrencias
- Comparar format string com benchmark (`href="https://pubmed.ncbi.nlm.nih.gov/{num}" target="_blank">PMID {num}`)
- Flagar qualquer desvio: trailing `/`, missing `target`, texto != `PMID {num}`, classe != `ref-pmid`
- Nao corrigir NADA nesta fase — so catalogar
- NAO modificar `pre-reading-heterogeneidade.html` (benchmark intocavel)

**Saida ao Lucas:** tabela markdown + resumo ("N PMIDs suspeitos encontrados, K precisam de verificacao PubMed MCP, M arquivos com CSS benchmark faltante") — Lucas decide quais fases executar e em que ordem.

**Gate:** Lucas aprova Fase 2 + escolhe quais batches/prioridades avancar.

---

### Fase 2 — Normalizacao de formato de links (P1)

**Quando:** apos audit aprovado e Lucas selecionar arquivos/batches.

**Trabalho por arquivo (mecanico, sem decisao semantica):**
- Para cada `<a>` com href PubMed ou DOI que divirja do benchmark:
  - Remover trailing slash de URL PubMed
  - Adicionar `target="_blank"` se ausente
  - Ajustar texto do link ao padrao: PMID → `PMID {num}`, DOI → `DOI`
  - Garantir classe `.ref-pmid`
- **NUNCA tocar no numero do PMID ou DOI em si** — se numero suspeito, ele vai para Fase 3
- **NUNCA converter plain-text PMID para link sem Lucas confirmar** que a VERIFICACAO foi feita

**Commit granularity:** 1 commit por arquivo (permite revert cirurgico). Mensagem: `S150: normalize PMID/DOI link format in {file}`.

**Gate:** apos cada commit, parar e reportar diff ao Lucas. Proximo arquivo so com OK explicito.

---

### Fase 3 — PMIDs suspeitos → PubMed MCP verification (P0 semantico)

**Quando:** apos Lucas revisar a lista de suspicious_pmids do audit.

**Protocolo por PMID suspeito (KBP-04 + project_living_html.md):**
1. Lucas seleciona N PMIDs suspeitos para verificacao
2. Orquestrador chama PubMed MCP com 3-field cross-check (autor + titulo + journal/ano)
3. Reporta resultado: VERIFIED | CORRECTED → {novo_pmid} | NOT_FOUND | DATA_SUSPECT
4. Lucas aprova correcao ou flag como CANDIDATE
5. Aplica fix apenas com aprovacao

**Nao ha bypass.** Se PubMed MCP indisponivel, adia ao proximo batch — NUNCA substitui por WebSearch sem aprovacao (KBP-08).

**Gate:** 1 PMID por vez. Lucas confirma cada correcao.

---

### Fase 4 — CSS benchmark adoption (P2)

**Quando:** apos Fases 2 e 3 estaveis.

**Arquivos-alvo:** aqueles que o audit marcar como `css_benchmark: incomplete`.

**Trabalho:** copiar do benchmark (`pre-reading-heterogeneidade.html` linhas 10-80 CSS block):
- `.ref-pmid`, `.v`, `.c`, `.key-takeaway`, `.caveat`, `.gap-card`, `.core-step`, accordion
- **NAO tocar HTML estrutural** — so adicionar CSS faltante ao `<style>` do arquivo
- Validar visualmente carregando o arquivo no browser apos cada edit

**Gate:** por arquivo, mostrar diff + screenshot antes/depois (se Lucas pedir).

---

### Fase 5 — Polish visual + acessibilidade (P3)

**Quando:** ultima fase, opcional dependendo do tempo.

**Polish visual (minimalista, nao invasivo):**
- Consistencia de bordas 8-10px, sombras leves em cards
- Hover states em tabelas
- Espacamento vertical entre secoes

**Acessibilidade (WCAG 2.1 AA basico):**
- `<th scope="col">` em table headers
- Text-fallback em badges V/C (ja tem font-weight 700, verificar se visivel sem cor)
- `rel="noopener noreferrer"` em links `target="_blank"`
- Alt em imagens se houver

**Gate:** diff por arquivo. Nenhum redesign visual — so camada defensiva.

## Arquivos Criticos

### Read-only (auditar mas NAO modificar nesta sessao)
- `content/aulas/metanalise/evidence/pre-reading-heterogeneidade.html` — benchmark
- `C:\Users\lucas\.claude\projects\C--Dev-Projetos-OLMO\memory\project_living_html.md` — regras

### Target (modificar com aprovacao por fase/arquivo)
- `content/aulas/metanalise/evidence/pre-reading-forest-plot-vies.html`
- `content/aulas/metanalise/evidence/blueprint.html`
- `content/aulas/metanalise/evidence/meta-narrativa.html`
- `content/aulas/metanalise/evidence/s-ancora.html`
- `content/aulas/metanalise/evidence/s-checkpoint-1.html` (bug linha 183 = P0)
- `content/aulas/metanalise/evidence/s-contrato.html`
- `content/aulas/metanalise/evidence/s-forest-plot.html`
- `content/aulas/metanalise/evidence/s-hook.html` (baseline OK)
- `content/aulas/metanalise/evidence/s-importancia.html` (investigar ausencia de PMIDs)
- `content/aulas/metanalise/evidence/s-objetivos.html`
- `content/aulas/metanalise/evidence/s-pico.html`
- `content/aulas/metanalise/evidence/s-rs-vs-ma.html`
- `content/aulas/metanalise/evidence/forest-plot-candidates.html`

### Novos arquivos (criados pelo plano)
- `docs/evidence-html-audit-S150.md` — relatorio de audit (Fase 1)
- (possivelmente) `docs/pmid-suspicious-S150.md` — lista de PMIDs para verificacao (Fase 3)

## Utilitarios a reusar (nao reinventar)

- **Grep tool** — busca `PMID`, `ref-pmid`, `pubmed.ncbi`, `doi.org` (ja validado nesta sessao)
- **Read tool** — inspeccao completa quando necessario
- **PubMed MCP** — unica fonte de truth para verificacao de PMID (Perna 3 do /research, ativa desde S149)
- **Nenhum script novo.** Nao criar scripts de "auto-audit" ou "auto-fix" (KBP-03 Agent-Script Redundancy). Auditoria manual via Grep/Read e apropriada para 14 arquivos.

## Verificacao end-to-end

### Por fase
- **Fase 1:** audit file existe + tabela completa 14 linhas + suspicious_pmids lista populada
- **Fase 2:** `git diff` mostra so mudancas de formato (href attrs, text content), nenhum numero de PMID/DOI alterado
- **Fase 3:** cada correcao de PMID linkada a resposta do PubMed MCP + aprovacao do Lucas no commit message
- **Fase 4:** `<style>` blocks incluem classes do benchmark; abrir HTML no browser e ver consistencia visual
- **Fase 5:** `<th>` com scope; links externos com rel=noopener; validar com axe DevTools manual (Lucas)

### Smoke test final
- `cd content/aulas && npm run build` — build do slide deck nao deve quebrar (evidence HTMLs sao standalone, mas hooks podem lintar)
- Abrir cada evidence HTML modificado no browser + verificar links clicaveis abrem PubMed na aba nova
- Git log: cada fase/arquivo em commit discreto, mensagem clara, co-autoria Lucas + Opus 4.6

## Riscos e mitigacoes

| Risco | Mitigacao |
|-------|-----------|
| Auto-corrigir PMID errado (LLM 56% erro) | **Fase 3 protocolo:** verificacao PubMed MCP obrigatoria, Lucas aprova cada correcao individual |
| Scope creep durante fix | **Momentum brake:** 1 arquivo por commit, parar e reportar apos cada |
| Quebrar o benchmark (pre-reading-heterogeneidade) | Listado como **read-only** explicitamente, audit apenas |
| Quebrar h2 (trabalho do Lucas) | CUIDADO documentado em HANDOFF; nunca tocar `<h2>` sem instrucao inequivoca |
| Fase 2 normalizacao acidentalmente remove info | Commit por arquivo, diff revisado antes do commit |
| Inconsistencia entre CSS e estrutura HTML | Fase 4 so adiciona CSS, nao muda estrutura |
| Gate mental fadigado apos varias fases | Plano parametriza gates — cada fase tem STOP explicito, Lucas decide continuar |

## Nao-objetivos (NAO fazer nesta sessao/plano)

- NAO criar novos scripts de lint/audit
- NAO corrigir PMIDs sem PubMed MCP verification
- NAO modificar o benchmark (pre-reading-heterogeneidade.html)
- NAO tocar em `<h2>` de qualquer slide
- NAO reescrever narrativas/prosa
- NAO adicionar speaker notes aos evidence HTMLs (standby per project_living_html.md)
- NAO adicionar sections faltantes (#pedagogia, #retorica, etc.) — backlog separado
- NAO fazer commit batch multi-arquivo
- NAO usar workaround quando PubMed MCP falhar (KBP-08)
- NAO inferir estrutura/conteudo — ler o arquivo
