# Sessão S151 — HTML + REFERENCES

> Coautoria: Lucas + Opus 4.6
> Baseado em: HANDOFF S150 + `docs/evidence-html-audit-S150.md`
> Decisões editoriais: coletadas via AskUserQuestion nesta sessão

---

## Context

O audit S150 (`docs/evidence-html-audit-S150.md`) mapeou 14 evidence HTMLs contra 3 dimensões: CSS benchmark (7 classes de `pre-reading-heterogeneidade.html`), verificação de PMIDs, e A11y baseline. O resultado: apenas o próprio benchmark atinge 7/7 CSS; 86 de 87 `<th>` estão sem `scope="col"`; 104 de 104 links `target="_blank"` estão sem `rel="noopener noreferrer"`; há inconsistências intra-arquivo em `s-checkpoint-1.html` (linhas 180-182 com badge `.v`, linhas 183-185 sem); `s-pico.html` viola a regra "PMID apenas em `#referencias`" com 6 PMIDs em prosa; `s-importancia.html` não tem PMIDs nem section `#referencias`; e o Nasr PMID 29713212 (s-objetivos.html:285) precisa de re-verificação de identidade após correção S149.

S150 executou apenas 7 fixes mecânicos (bug HTML + DOI labels). As decisões editoriais ficaram represadas. S151 resolve essa fila com decisões já tomadas:

1. s-pico.html → **mover PMIDs prosa → `#referencias`** (respeitar a regra)
2. s-importancia.html → **verificar via PubMed MCP + criar `#referencias`**
3. Nasr 29713212 → **re-verificar identidade via PubMed MCP**, sem deep-read
4. Escopo total → **P0 + P1 + P2 A11y batch**

PubMed MCP é grátis — verificação de PMIDs deixa de ser gargalo de custo.

## Escopo

```
Fase A — PubMed MCP verification (read-only, bloco único de dados)
Fase B — Edits editoriais P0 (s-pico, s-importancia, s-checkpoint-1, s-objetivos)
Fase C — CSS benchmark adoption P1 (blueprint, meta-narrativa, pre-reading-forest-plot-vies)
Fase D — A11y P2 batch (scope="col" + rel="noopener noreferrer" em 14 arquivos)
```

Nada fora disso. Nada de "melhorias adjacentes". Scope discipline: anti-drift.md §Scope.

---

## Fase A — PubMed MCP Verification (dados, sem edit)

**Objetivo**: produzir uma tabela de verdade antes de QUALQUER edit de HTML, para não reescrever baseado em suposição.

**Input** (14 PMIDs pendentes):

| # | PMID | Arquivo:linha | Autor esperado | Status atual |
|---|------|---------------|----------------|--------------|
| 1 | 21366473 | s-checkpoint-1:183 | ACCORD Study Group 2011 (NEJM) | sem badge |
| 2 | 26822326 | s-checkpoint-1:184 | ACCORD Study Group 2016 (Diabetes Care) | sem badge |
| 3 | 31167051 | s-checkpoint-1:185 | Reaven PD 2019 VADT 15yr (NEJM) | sem badge |
| 4 | 37146659 | s-pico:171 | Goldkuhle 2023 | prosa (.v) |
| 5 | 21802903 | s-pico:176 | Guyatt 2011 GRADE indirectness | prosa (.v) |
| 6 | 40393729 | s-pico:181-186 | Guyatt (recente) | prosa (.v) |
| 7 | 41207400 | s-pico:181-186 | Colunga-Lozano | prosa (.v) |
| 8 | 17238363 | s-pico:181-186 | Huang | prosa (.v) |
| 9 | 28234219 | s-pico:181-186 | Adie | prosa (.v) |
| 10 | 29713212 | s-objetivos:285 | Nasr JA et al. 2018 (Adv Med Educ Pract) | flag S149 |
| 11 | ? | s-importancia (novo) | Borenstein 2021 (Introduction to Meta-Analysis 2ed/update) | sem PMID |
| 12 | ? | s-importancia (novo) | Kastrati & Ioannidis 2024 (concordância MA vs mega-trial) | sem PMID |
| 13 | ? | s-importancia (novo) | Yusuf 1985 beta-blockers pós-IAM | sem PMID |
| 14 | ? | s-importancia (novo) | Lau 1992 estreptocinase cumulativo | sem PMID |

**Execução**:
- **Tool default**: PubMed MCP (grátis). Confirmar tool name exato no primeiro call da fase — não assumir nome.
- **Tool fallback**: SCite MCP (`mcp__claude_ai_SCite__search_literature`) — usar SÓ quando PubMed deixa dúvida material não resolvível por metadata. Cada uso de SCite deve ser precedido por uma frase explicando por que PubMed não bastou.
- Para PMIDs conhecidos (1-10): fetch direto por PMID no PubMed, comparar `autor[1] + year + title[:50] + journal` vs esperado. Categorizar: `VERIFIED` | `CANDIDATE` | `INVALID`.
- Para autores sem PMID (11-14): busca estruturada PubMed (autor + ano + termo-chave do título). Retornar top-3 candidatos, escolher o que bate texto do slide, marcar `VERIFIED` ou `CANDIDATE` se ambíguo. SCite só se PubMed retornar vazio ou ambíguo demais.
- Nasr (#10): confirmar apenas **identidade** (autor, título, journal, ano) via PubMed. Se bater → manter V sem deep-read. Se não bater → degradar para C e flag editorial. Não invocar SCite para Nasr (decisão explícita Lucas).

**Output**: `docs/pmid-verification-S151.md` — tabela de 14 linhas com colunas: `PMID | esperado | PubMed retornou | match | categoria | ação`. Este doc é commit separado (commit 1 da sessão) e source-of-truth para Fase B.

**Critério de saída da Fase A**: tabela completa + Lucas valida as 14 linhas antes de tocar em HTML.

---

## Fase B — Edits Editoriais P0

### B1 · s-pico.html — mover 6 PMIDs prosa → `#referencias`

Arquivo: `content/aulas/metanalise/evidence/s-pico.html`

Sub-tarefas:
1. **Linhas 171, 176, 181-186, 232-236**: substituir `PMID 37146659` (e irmãos) por `(Goldkuhle et al. 2023)` — formato autor-ano sem PMID.
2. **`#referencias` (linha 242+)**: adicionar 6 entradas completas usando formato benchmark:
   ```html
   <li>Goldkuhle M et al. 2023. [title]. [journal]. <a class="ref-pmid" href="https://pubmed.ncbi.nlm.nih.gov/37146659" target="_blank" rel="noopener noreferrer">37146659</a> <span class="v">VERIFIED</span></li>
   ```
   Dados (título/journal) vêm da Fase A, não inventar.
3. **CSS drift**: reconciliar `.ref-pmid { font-size: .82rem }` (S144) → `.85rem` (benchmark). Evita fork visual.
4. **PMID 37575761 (VTS med ed, linha 232-236)**: audit marca INVALID. Remover totalmente do arquivo (citação + #referencias se existir).
5. **Self-check**: grep por `PMID \d{7,8}` no arquivo → deve retornar apenas matches dentro de `#referencias`.

**Commit**: `S151: s-pico.html PMIDs prose→refs + CSS reconcile`

### B2 · s-importancia.html — criar section `#referencias` nova

Arquivo: `content/aulas/metanalise/evidence/s-importancia.html`

Sub-tarefas:
1. Adicionar bloco CSS benchmark (`.ref-pmid`, `.v`, `.c`) se ausente.
2. Criar `<section id="referencias">` no rodapé (antes de `</body>`).
3. Popular com 4 entradas: Borenstein 2021, Kastrati & Ioannidis 2024, Yusuf 1985, Lau 1992 — dados da Fase A.
4. Manter citação inline por nome (`Borenstein 2021`) sem modificar prosa — apenas linkar para `#referencias` opcionalmente via `<a href="#referencias">`.
5. Se algum dos 4 não verificar, entrada recebe `.c CANDIDATE` em vez de `.v VERIFIED`.

**Commit**: `S151: s-importancia.html add #referencias (4 PMIDs from PubMed MCP)`

### B3 · s-checkpoint-1.html — badges `.v` nos 3 PMIDs

Arquivo: `content/aulas/metanalise/evidence/s-checkpoint-1.html`

Sub-tarefas:
1. Linhas 183, 184, 185 — se Fase A retornou VERIFIED: adicionar `<span class="v">VERIFIED</span>` após cada `</a>`.
2. Se Fase A retornou CANDIDATE: adicionar `<span class="c">CANDIDATE</span>`.
3. Se INVALID (improvável para ACCORD/VADT, que são trials clássicos): flaggar a Lucas e pausar.

**Commit**: `S151: s-checkpoint-1.html verify + badge ACCORD/VADT`

### B4 · s-objetivos.html — resolver Nasr flag

Arquivo: `content/aulas/metanalise/evidence/s-objetivos.html` (linha 285)

Sub-tarefas:
1. Se Fase A confirmou **identidade** (PMID+autor+título+journal+ano): remover comentário inline `[dados forest plot não no abstract]`, manter badge `.v VERIFIED`. Dados numéricos específicos não são re-checados (decisão Lucas: só identidade).
2. Se Fase A **não** confirmou identidade: degradar para `.c CANDIDATE` + comentário inline atualizado.
3. Nenhum deep-read SCite. Nenhuma remoção de citação.

**Commit**: `S151: s-objetivos.html resolve Nasr 29713212 identity check`

---

## Fase C — CSS Benchmark Adoption P1

Target: 3 arquivos listados no HANDOFF como sem classes completas.

| Arquivo | Classes a adicionar | Nota |
|---------|---------------------|------|
| `blueprint.html` | `.ref-pmid`, `.v`, `.c`, `.key-takeaway`, `.caveat` (cf. audit) | Copy-paste do bloco `<style>` de `pre-reading-heterogeneidade.html:8-80`, integrar sem duplicar classes já presentes |
| `meta-narrativa.html` | Mesmas 5 classes | Mesmo procedimento |
| `pre-reading-forest-plot-vies.html` | `.ref-pmid`, `.v`, `.c` (faltam — já tem 4 das 7) | **Não adicionar PMIDs** ao conteúdo. Só classes (CSS standby, pronto para uso futuro). Adicionar PMIDs é decisão editorial separada — não está no escopo desta sessão |

**Não tocar**: `pre-reading-heterogeneidade.html` (benchmark read-only).
**Não tocar**: `s-pico.html` nesta fase (já fez reconcile em B1).

**Commit(s)**: 1 por arquivo (3 commits pequenos), cada um titulado `S151: {file} adopt benchmark CSS classes`.

---

## Fase D — A11y P2 Batch

Do audit: ~86 `<th>` sem `scope="col"` e ~104 links `target="_blank"` sem `rel="noopener noreferrer"`. Mecânico, alto volume.

**Estratégia**:
1. Listar os 14 arquivos evidence + quantos hits de cada fix cada um tem (fase de leitura rápida).
2. Para cada arquivo: 1 commit contendo ambos os fixes (scope + rel). Commit title: `S151: {file} a11y — th scope + link rel`.
3. **Evitar** `replace_all` cego: cada `<th>` precisa ser confirmado como header de coluna (nem sempre é — pode ser `scope="row"`). Pode-se usar `replace_all` com contexto específico por arquivo.
4. **Evitar** tocar arquivos fora de `content/aulas/metanalise/evidence/`.
5. Commits = 14 (um por arquivo) OU 1 big batch commit se todos trivialmente uniformes. Decisão tomada na hora: se os 2 primeiros arquivos forem idênticos em padrão, batch; caso contrário, 1-por-arquivo.

**Self-check pós-Fase D**: rodar um audit read-only que conte `<th scope` matches vs `<th>` total em cada arquivo, e `rel="noopener` vs `target="_blank"` total. Meta: 100% dos `<th>` com scope ≥ `scope="col"` OU `scope="row"`; 100% dos `target="_blank"` com `rel="noopener noreferrer"`.

---

## Arquivos críticos (paths)

Edits:
- `content/aulas/metanalise/evidence/s-pico.html` (B1)
- `content/aulas/metanalise/evidence/s-importancia.html` (B2)
- `content/aulas/metanalise/evidence/s-checkpoint-1.html` (B3)
- `content/aulas/metanalise/evidence/s-objetivos.html` (B4)
- `content/aulas/metanalise/evidence/blueprint.html` (C)
- `content/aulas/metanalise/evidence/meta-narrativa.html` (C)
- `content/aulas/metanalise/evidence/pre-reading-forest-plot-vies.html` (C)
- `content/aulas/metanalise/evidence/*.html` (D, 14 arquivos)

Read-only (referências):
- `content/aulas/metanalise/evidence/pre-reading-heterogeneidade.html` (benchmark, NÃO tocar)
- `docs/evidence-html-audit-S150.md` (source of truth do estado S150)

Docs novos:
- `docs/pmid-verification-S151.md` (output da Fase A)

---

## Verificação end-to-end

Após cada Fase, antes do próximo commit:

**Fase A**:
- [ ] Tabela `docs/pmid-verification-S151.md` tem 14 linhas preenchidas
- [ ] Lucas confirma os status antes de B1-B4

**Fase B**:
- [ ] `grep -c 'PMID [0-9]' s-pico.html` em prose sections = 0 (só dentro de `#referencias`)
- [ ] `s-importancia.html` tem `<section id="referencias">` (grep)
- [ ] `s-checkpoint-1.html` linhas 183-185 têm `.v` OU `.c` — sem PMIDs órfãos
- [ ] `s-objetivos.html` Nasr linha 285 reflete decisão da Fase A
- [ ] Build metanalise ainda passa: `cd content/aulas && npm run build:metanalise` (ou equivalente existente)

**Fase C**:
- [ ] `grep -c '\.ref-pmid' {blueprint,meta-narrativa,pre-reading-forest-plot-vies}.html` ≥ 1 em cada
- [ ] Visual diff: abrir cada HTML e conferir que layout não quebrou

**Fase D**:
- [ ] `grep -c 'scope="col"' evidence/*.html` soma ≥ número pré-existente
- [ ] `grep -c 'rel="noopener noreferrer"' evidence/*.html` ≥ total de `target="_blank"`

**Pós-sessão**:
- [ ] HANDOFF.md atualizado: P0/P1/P2 dessa sessão movidos para CHANGELOG
- [ ] CHANGELOG.md ganha entrada S151 com categoria `evidence-html`
- [ ] `.claude/.session-name` já contém `HTML+REFERENCES` (feito no início)

---

## Riscos e salvaguardas

| Risco | Mitigação |
|-------|-----------|
| Fase A retorna PMID INVALID em `s-pico` | PAUSE. Reportar a Lucas. Não inventar substituto. Fase B1 depende da Fase A. |
| PubMed MCP tool name diferente do assumido | Confirmar tool disponível no primeiro call da Fase A; se não disponível, reportar antes de prosseguir (KBP-09 — não substituir por outra perna) |
| Edit em `s-pico.html` quebra CSS S144 de outro slide | CSS reconciliation é apenas no `.ref-pmid` font-size. Outras classes S144 preservadas. Visual check obrigatório. |
| Batch A11y toca `<th scope="row">` por engano | Não usar `replace_all` cego. Inspecionar cada `<th>` ou usar regex com contexto. |
| Build metanalise quebra após edits | Rodar build após Fase B, Fase C, Fase D — não acumular edits sem teste. |
| Lucas interrompe mid-Fase | Cada fase termina em commit atômico. Nenhuma fase depende de estado não-commitado da anterior. |

## Decisões Lucas (documentadas aqui para rastreabilidade)

1. **Escopo**: P0 + P1 + P2 A11y batch (o mais amplo dos 4 escopos oferecidos)
2. **s-pico PMIDs prose**: mover todos para `#referencias` (respeitar regra)
3. **s-importancia**: verificar via PubMed MCP + criar `#referencias`
4. **Nasr**: PubMed MCP só para confirmar PMID + título/journal, não deep-read
5. **PubMed MCP budget**: grátis — sem preocupação de custo
6. **SCite MCP policy**: plano Lucas cobre SCite. Usar **apenas quando PubMed deixa dúvida real** — ex.: PMID retorna metadata ambígua, autor homônimo, ou ano/journal conflita. Default absoluto = PubMed MCP. SCite é fallback explícito, não ferramenta de rotina.

## Sequência de commits prevista (ordem)

```
1. Fase A → docs/pmid-verification-S151.md                       (data commit)
2. B1   → s-pico.html PMIDs prose→refs + CSS                    (editorial)
3. B2   → s-importancia.html add #referencias                   (editorial)
4. B3   → s-checkpoint-1.html ACCORD/VADT badges                (verification)
5. B4   → s-objetivos.html Nasr identity check                  (verification)
6. C1   → blueprint.html CSS benchmark                          (CSS)
7. C2   → meta-narrativa.html CSS benchmark                     (CSS)
8. C3   → pre-reading-forest-plot-vies.html CSS benchmark       (CSS)
9. D    → a11y batch (14 files ou 1 big commit)                 (a11y)
10. Wrap → HANDOFF/CHANGELOG update                              (session-hygiene)
```

Total: ~9-22 commits (D pode ser 1 ou 14). Cada commit é atômico e revertível. Momentum brake entre fases: após B, após C, após D — parar e confirmar com Lucas antes da próxima fase.
