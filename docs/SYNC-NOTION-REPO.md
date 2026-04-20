# SYNC-NOTION-REPO — Protocolo de Sincronizacao

> Quais DBs Notion se conectam a quais arquivos do repo, quem e source of truth, e como sincronizar.
> Referenciado por: `content/aulas/cirrose/references/narrative.md`

---

## Source of Truth

| Dado | Source of Truth | Espelho |
|------|----------------|---------|
| Dados do paciente (labs, MELD, checkpoints) | `content/aulas/cirrose/references/CASE.md` | Notion (read-only copy) |
| Arco narrativo (atos, pacing, Chekhov's guns) | `content/aulas/cirrose/references/narrative.md` | Notion "Biblia Narrativa" |
| Dados clinicos com PMID | Living HTML: `content/aulas/*/evidence/s-*.html` | Notion References DB |
| Lista de trials / PDF status | Notion References DB | `content/aulas/cirrose/references/must-read-trials.md` |
| Slide HTML/CSS/JS | Repo (`content/aulas/cirrose/slides/`) | — |
| Coautoria e disclosure | `content/aulas/cirrose/references/coautoria.md` | — |

**Regra:** quando repo e Notion divergem, **repo prevalece** para dados clinicos e narrativa.
Notion prevalece apenas para **status de PDF** (coluna `Verified` na References DB).

---

## Notion DBs Relevantes

| DB | Collection ID | Uso |
|----|---------------|-----|
| **References DB** (trials, PDFs) | `collection://2b24bb6c-91be-42c0-ae28-908a794e5cf5` | Trials com PMID, status de PDF, tier de evidencia |
| **Biblia Narrativa** | *(page, nao collection — buscar via `notion-search`)* | Draft narrativo original (ChatGPT 5.4). Repo e canonico. |
| **Teaching Log** | *(planejado, nao criado — ver `.claude/BACKLOG.md` §Infra Pendente)* | Feedback de aulas, acoes corretivas |

---

## Workflows de Sync

### Repo → Notion (push)

Quando: novo PMID verificado em living HTML (`evidence/s-*.html`)

1. Verificar PMID via PubMed MCP
2. Atualizar living HTML (status: VERIFICADO)
3. Atualizar `must-read-trials.md` se trial e must-read
4. No Notion References DB: criar/atualizar entrada, setar `Verified = true`
5. Seguir protocolo `docs/mcp_safety_reference.md` (1 write por vez, verificar resultado)

### Notion → Repo (pull)

Quando: Lucas marca PDF como encontrado no Notion

1. No Notion: setar `Verified = true` + upload PDF
2. No repo: atualizar coluna `PDF?` em `must-read-trials.md` (✓)
3. Nao copiar conteudo do Notion para o repo — so flags de status

### Auditoria (periodica)

1. Filtrar Notion References DB: `Verified = false`
2. Comparar com `must-read-trials.md` seção "Pendentes"
3. Buscar PDFs faltantes
4. Atualizar ambos (Notion + repo)

---

## Seguranca

- Notion MCP: protocolo em `docs/mcp_safety_reference.md`
- Operacoes seguras: `notion-search`, `notion-fetch`
- Operacoes arriscadas: `notion-update-page`, `notion-create-pages`
- Regra de ouro: 1 write por vez, verificar resultado, erro = PARAR

---

Coautoria: Lucas + Opus 4.6 | 2026-03-29
