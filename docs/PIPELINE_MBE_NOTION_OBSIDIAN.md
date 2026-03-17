# Pipeline MBE: Pesquisa → Qualidade → Notion + Obsidian

> Detalhes técnicos do pipeline. **Workflow principal**: `docs/WORKFLOW_MBE.md`
> Coautoria: Lucas + opus

## Visão Geral

```
PubMed (tier1) ──► Consensus (consenso %) ──► Scite (citation check)
       │                    │                         │
       └────────────────────┴─────────────────────────┘
                                    │
                                    ▼
                    atualizar_tema.py / paper_to_notion
                                    │
                    ┌───────────────┴───────────────┐
                    ▼                               ▼
              Obsidian (03-Resources/)        Notion (Masterpiece DB)
              - evidence_level               - Nivel Evidencia
              - last_review                   - Ultima Revisao
              - references [tipo]            - Referencias com PMID
```

## 1. Fontes e Classificação

| Ferramenta | Papel | Automatizável |
|------------|-------|---------------|
| **PubMed** | Busca + filtro tier 1 (meta-análise, revisão sistemática) | Sim (`--tier1`) |
| **Consensus** | % consenso, filtro por tipo de estudo | MCP (Cursor/Claude) |
| **Scite** | Supporting vs contrasting citations | MCP (Cursor/Claude) |
| **Zotero** | Biblioteca pessoal, PDFs | Sim (API) |

## 2. Uso do Script `atualizar_tema.py`

```powershell
# Busca tier 1 + mais recentes → Obsidian + Notion
uv run python scripts/atualizar_tema.py -t "Restrição salina ascite cirrose" --fetch --tier1 --recent

# Só PubMed tier 1, 10 refs
uv run python scripts/atualizar_tema.py -t "Sodium restriction cirrhotic ascites" --fetch --sources pubmed --tier1 --max-refs 10

# Atualizar metadata (tags, last_review) sem refetch
uv run python scripts/atualizar_tema.py -t "Ascite" --so-metadata --tags ascite,cirrose,hepatologia
```

### Flags

| Flag | Descrição |
|------|-----------|
| `--fetch` | Busca em PubMed/Zotero |
| `--tier1` | Filtra apenas meta-análise + revisão sistemática (PubMed) |
| `--recent` | Ordena por data (mais recentes primeiro) |
| `--sources` | pubmed,zotero (default) |
| `--max-refs` | Máx refs por fonte (default: 5) |
| `--so-metadata` | Atualiza só frontmatter, preserva conteúdo |

## 3. Workflow Manual: Consensus + Scite

Quando precisar de classificação intermediária (consenso %, citation intent):

1. **Consensus** (consensus.app)
   - Query: `sodium restriction cirrhotic ascites`
   - Filtro: Meta-Analysis + Systematic Review
   - Anotar: % consenso, papers principais

2. **Scite** (scite.ai)
   - Para papers com evidência conflitante
   - Ver: supporting vs contrasting citations
   - Identificar quem apoia/contradiz cada conclusão

3. **Alimentar o pipeline**
   - Copiar PMIDs/DOIs para `atualizar_tema.py` via `--content-file`
   - Ou: usar resultado no Notion manualmente
   - Ou: agente com MCP Consensus/Scite faz a busca e popula

## 4. Output: Obsidian

Arquivo: `03-Resources/<tema>.md`

```yaml
---
title: Restrição Salina
type: note
tags: [ascite, cirrose, hepatologia]
created: 2026-03-14
updated: 2026-03-14
last_review: 2026-03-14
evidence_level: I
references:
  - Paper X (pubmed)
  - Paper Y (pubmed)
---
```

## 5. Output: Notion

Arquivo: `scripts/output/notion-<tema>-masterpiece.md`

- Propriedades sugeridas: **Nivel Evidencia** (I-V), **Ultima Revisao**
- Template: Masterpiece DB
- Copiar para Notion ou usar MCP Notion para criar página

## 6. Workflow `paper_to_notion` (config/workflows.yaml)

Fluxo: PubMed → Consensus + Scite → **Opus** → Notion

- **consensus_scite_triage**: Consensus (% consenso) + Scite (supporting vs contrasting)
- **opus_classify_and_critique**: Opus recebe Scite/Consensus, filtra evidência, classifica (Oxford CEBM, GRADE), coloca as críticas mais importantes (vieses, contradições Scite, incerteza Consensus)
- **cross_validation**: segunda opinião quando evidência ambígua
- **publish_to_notion**: template MBE com PICO, tabela estudos, críticas em destaque

## 7. Atualizações Periódicas

- **Semanal**: `weekly_medical_digest` (cron Segunda 8h) — busca tier 1, publica digest
- **On-demand**: `atualizar_tema.py -t "Tema" --fetch --tier1 --recent`
- **Revisão de tópico**: `--so-metadata` para atualizar `last_review` sem refetch

## Referências

- `config/mcp/servers.json` — Scite, Consensus
- `scripts/fetch_medical.py` — PubMed tier1, Zotero
- `config/workflows.yaml` — paper_to_notion, weekly_medical_digest
