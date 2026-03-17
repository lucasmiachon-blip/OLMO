# Workflow MBE: Tópico → Notion + Obsidian

> Workflow único para atualizar tópicos médicos com pesquisa, qualidade de evidência e publicação.
> Fonte única de verdade. Coautoria: Lucas + opus

---

## 1. Quando Disparar

| Gatilho | Ação |
|---------|------|
| **Novo tópico** | Quero criar nota sobre X (ex: restrição salina, ascite) |
| **Atualização periódica** | Revisar tópico existente (semanal/mensal) |
| **Pergunta clínica** | Preciso de evidência tier 1 sobre Y |
| **Paper novo** | Encontrei paper relevante, quero integrar |

---

## 2. Fluxo Principal (Passo a Passo)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  ENTRADA: Tema (ex: "Restrição salina ascite cirrose")                   │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  PASSO 1: BUSCA (automatizado)                                           │
│  Comando: atualizar_tema.py -t "Tema" --fetch --tier1 --recent             │
│  Fontes: PubMed (tier 1) + Zotero (opcional)                              │
│  Output: lista de refs com [meta_analysis] / [systematic_review]          │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  PASSO 2: CLASSIFICAÇÃO (Consensus + Scite → Opus)                       │
│  Consensus: filtrar tier 1, % consenso                                    │
│  Scite: supporting vs contrasting por paper                              │
│  Opus: filtra evidência, classifica (Oxford/GRADE), coloca críticas      │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  PASSO 3: SÍNTESE (manual ou agente)                                    │
│  Preencher: Definição, Pontos-Chave (dos abstracts/PDFs)                │
│  Editar: 03-Resources/<tema>.md ou scripts/output/notion-*.md            │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  PASSO 4: PUBLICAÇÃO                                                     │
│  Obsidian: 03-Resources/<tema>.md (já gerado pelo script)                │
│  Notion: copiar scripts/output/notion-<tema>-masterpiece.md → Masterpiece │
│          OU usar MCP Notion para criar página                            │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Comandos por Cenário

### Cenário A: Novo tópico (busca completa)

```powershell
uv run python scripts/atualizar_tema.py -t "Restrição salina ascite cirrose" --fetch --tier1 --recent --tags ascite,cirrose,hepatologia
```

- Cria `03-Resources/restricao-salina-ascite-cirrose.md`
- Cria `scripts/output/notion-restricao-salina-ascite-cirrose-masterpiece.md`
- `evidence_level` e `last_review` preenchidos automaticamente

### Cenário B: Atualizar tópico existente (só metadata)

```powershell
uv run python scripts/atualizar_tema.py -t "Ascite" --so-metadata --tags ascite,cirrose,hepatologia
```

- Atualiza frontmatter (tags, updated, last_review)
- **Não** refaz busca, **não** sobrescreve conteúdo

### Cenário C: Refetch (nova busca, preservar links)

```powershell
uv run python scripts/atualizar_tema.py -t "Ascite" --fetch --tier1 --recent --links Cirrose,Hepatite
```

- Nova busca PubMed tier 1
- Sobrescreve seção Referências
- Links para outras notas preservados

### Cenário D: Conteúdo manual (já tenho o texto)

```powershell
uv run python scripts/atualizar_tema.py -t "Ascite" --content-file path/to/conteudo.md --tags ascite,cirrose
```

- Usa conteúdo do arquivo
- Gera Obsidian + Notion com esse conteúdo

---

## 4. Onde Fica Cada Coisa

| Artefato | Local | Propósito |
|----------|-------|-----------|
| Notas médicas | `03-Resources/*.md` | Obsidian vault, Zettelkasten |
| Conteúdo Notion | `scripts/output/notion-*-masterpiece.md` | Copiar para Masterpiece DB |
| Workflow config | `config/workflows.yaml` | paper_to_notion, weekly_medical_digest |
| Pipeline doc | `docs/PIPELINE_MBE_NOTION_OBSIDIAN.md` | Detalhes técnicos |

---

## 5. Checklist por Tópico

- [ ] Busca executada (`--fetch --tier1 --recent`)
- [ ] Consensus/Scite consultados (se evidência conflitante)
- [ ] Definição e Pontos-Chave preenchidos
- [ ] Nota Obsidian em `03-Resources/`
- [ ] Página Notion criada no Masterpiece DB
- [ ] `last_review` atualizado
- [ ] Links para notas relacionadas (`[[Cirrose]]`, etc.)

---

## 6. Frequência Sugerida

| Ação | Frequência |
|------|------------|
| Digest médico semanal (tier 1) | Segunda 8h (cron) |
| Atualizar tópico específico | On-demand quando revisar |
| Revisar `last_review` antigos | Mensal (listar notas >30 dias) |

---

## 7. Referência Rápida: Flags do Script

| Flag | Uso |
|------|-----|
| `-t "Tema"` | Nome do tópico (obrigatório) |
| `--fetch` | Busca PubMed/Zotero |
| `--tier1` | Só meta-análise + revisão sistemática |
| `--recent` | Ordenar por data |
| `--tags a,b,c` | Tags Obsidian |
| `--links X,Y` | Links para outras notas |
| `--so-metadata` | Só frontmatter, preserva conteúdo |
| `--content-file path` | Usar conteúdo de arquivo |
| `--sources pubmed,zotero` | Fontes (default: ambas) |
| `--max-refs N` | Máx refs por fonte (default: 5) |
