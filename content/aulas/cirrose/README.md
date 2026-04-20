# Cirrose — Slides Interativos

> 44 slides assertion-evidence. Producao (lint clean).
> Migracao para living HTML per slide planejada (mesmo esquema de metanalise).

## Quick Start

```bash
cd content/aulas
npm run dev:cirrose  # porta 4100
npm run build:cirrose
npm run done:cirrose  # Definition of Done (3 gates)
```

## Estrutura

```
slides/*.html          <- fonte dos slides (1 arquivo por slide)
slides/_manifest.js    <- metadata, ordem, headlines
slide-registry.js      <- animacoes custom por slide
cirrose.css            <- CSS scopado (section#s-{id})
references/            <- 6 documentos interconectados
scripts/build-html.ps1 <- gera index.html
assets/                <- imagens, SVGs
```

## Reference Docs

Os 6 documentos em `references/` formam um grafo interconectado:

```
CASE.md <<──────── Source of truth (dados do paciente)
  |                  | valida
narrative.md <<── Arco narrativo (3 atos, pacing, Chekhov's guns)
  |
must-read-trials.md << Lista de leitura + status PDF (sync Notion)
  |
archetypes.md <<── Skeletons HTML para coding agents
  |
decision-protocol.md << Protocolo para decisoes nao-triviais
  |
coautoria.md <<─── Disclosure AI (ICMJE 2024)
```

Cada arquivo tem secao "See also" linkando para os siblings relevantes.

> **Nota:** `evidence-db.md` foi deprecado. Living HTML per slide sera source of truth
> apos migracao (ver metanalise como referencia).

## Integracao Notion

| DB Notion | Arquivo repo | Direcao | O que sincroniza |
|-----------|-------------|---------|------------------|
| References DB (`collection://2b24bb6c...`) | `must-read-trials.md` | Bidirecional | PMIDs, tier, PDF status |
| Biblia Narrativa (page) | `narrative.md` | Notion -> Repo (draft) | Arco narrativo (repo e canonico) |
| Teaching Log (planejado) | — | — | Feedback de aulas |

Protocolo completo: `docs/SYNC-NOTION-REPO.md`
Seguranca Notion: `docs/mcp_safety_reference.md`

## Migracao Planejada

Cirrose adotara o mesmo esquema de metanalise:
- `evidence/*.html` (living HTML per slide) como source of truth
- `narrative.md` -> HTML on-demand (como `meta-narrativa.html`)
- Sem sync automatico, sem guards de narrativa
- Timeline: pos-deadline metanalise
