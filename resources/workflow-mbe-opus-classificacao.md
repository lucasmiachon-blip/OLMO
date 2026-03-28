---
title: Workflow MBE - Opus Classificação
type: note
tags:
  - workflow
  - mbe
  - opus
  - scite
  - consensus
  - notion
  - obsidian
created: 2026-03-17
updated: 2026-03-17
last_review: 2026-03-17
evidence_level: I
references:
  - config/workflows.yaml
  - docs/WORKFLOW_MBE.md
  - docs/PIPELINE_MBE_NOTION_OBSIDIAN.md
---

# Workflow MBE - Opus Classificação

## Fluxo

```
PubMed → Consensus (% consenso) + Scite (supporting/contrasting)
                    ↓
              Opus (filtra, classifica, críticas)
                    ↓
         ┌──────────┴──────────┐
         ▼                    ▼
    Notion              Obsidian
  (Masterpiece)      (03-Resources/)
```

## Papel do Opus

1. **FILTRAR** evidência a partir de Scite/Consensus (priorizar consenso alto, menos contrasting)
2. **CLASSIFICAR** nível Oxford CEBM, grau recomendação (A-D)
3. **CRÍTICAS** mais importantes: vieses, contradições (Scite contrasting), incerteza (Consensus baixo)
4. **SINTETIZAR** para Notion + Obsidian

## Outputs

| Destino | Conteúdo |
|---------|----------|
| **Notion** | PICO, tabela estudos, conclusão, críticas em destaque |
| **Obsidian** | Nota com tags, links [[topicos]], referências PMID |

## Links

- [[Cirrose]]
- [[Ascite]]
- [[Restrição Salina]]

## Referências

- `config/workflows.yaml` — paper_to_notion
- `scripts/atualizar_tema.py` — fetch tier1, Obsidian + Notion
