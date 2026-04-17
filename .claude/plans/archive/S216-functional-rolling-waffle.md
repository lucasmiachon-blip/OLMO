# Plan: S216 Clean_up + Obsidian + PDF Pipeline

## Context

S215 limpou 67 files, auditou estado da arte, configurou Obsidian vault com junction wiki/.
S216: cleanup pendente + incorporar `docling-tools` no OLMO + pipeline PDF→Obsidian.
Lucas quer: digerir PDFs academicos → abastecer Obsidian → sintese cruzada de evidencias anti-alucinacao.

## Estado atual do docling-tools

Repo separado em `C:\Dev\Projetos\docling-tools\` (irmao do OLMO).
- Python 3.13, uv, Docling 2.86+, PyMuPDF
- `extract_figures.py` — extrai figuras de PDFs via Docling (ja rodou nos PDFs de colchicina)
- `precision_crop.py` — crop de alta resolucao de forest plots via PyMuPDF/fitz
- `main.py` — placeholder
- Output: 33 figuras cochrane + 4 tier2 ja extraidas
- Referencias hardcoded a `C:\Dev\Projetos\OLMO\content\aulas\dist\assets\`

---

## Step 1: Fix dream auto-trigger bug

**Problema:** Auto-dream dispara toda sessao sem permissao.
**Causa raiz:** `~/.claude/CLAUDE.md` secao "Auto Dream" = instrucao mandatoria + `session-start.sh:46-54` mensagem imperativa.

**Fix:**
- `~/.claude/CLAUDE.md` secao "Auto Dream" → mudar para: "informar usuario, NAO executar sem pedido explicito"
- `hooks/session-start.sh:46-54` → mensagem discreta: "(Dream disponivel — rode /dream quando quiser)"
- `rm ~/.claude/.dream-pending` (limpar flag atual)

## Step 2: Incorporar docling-tools no OLMO

**Decisao:** mover para `tools/docling/` dentro do monorepo OLMO (nao manter separado).
**Razoes:**
- Scripts ja referenciam assets do OLMO (paths hardcoded)
- Compartilha contexto cientifico (PDFs das aulas)
- Um unico repo = um unico workspace para Claude Code

**Acao:**
1. Criar `tools/docling/` no OLMO
2. Copiar: `extract_figures.py`, `precision_crop.py`, `pyproject.toml`
3. NAO copiar: `.venv/`, `.git/`, `output/`, `preview/` (regeneraveis)
4. Adaptar paths: usar paths relativos ao `$CLAUDE_PROJECT_DIR` (portabilidade)
5. Adicionar `tools/docling/` ao `.gitignore` do venv e ao `pyproject.toml` do OLMO como workspace (ou manter venv separado via uv)

**Questao para Lucas:** manter venv separado (`tools/docling/.venv`) ou unificar com o venv raiz do OLMO? Docling e pesado (~2GB PyTorch).

## Step 3: Pipeline PDF → Obsidian

**Script novo:** `tools/docling/pdf_to_obsidian.py`

Fluxo:
```
PDF academico
  → Docling DocumentConverter (markdown + metadados + figuras)
  → Enriquecimento: PubMed/CrossRef API → DOI, PMID, autores, journal
  → Template literature-note (frontmatter YAML)
  → Salva em Obsidian _inbox/
  → Figuras em Obsidian _attachments/
```

Frontmatter compativel com template existente:
```yaml
---
title: ""
authors: []
year:
doi: ""
pmid: ""
type: RCT|SR|Meta|Guideline|Review
grade: ""
tags: [literature-note, auto-digested]
source_pdf: ""
digested_at: ""
coautoria: Lucas + Docling
---
```

Output: `_inbox/{slug-do-titulo}.md` + figuras em `_attachments/{slug}/`

## Step 4: Sintese cruzada de evidencias (anti-alucinacao)

**Conceito:** multiplos PDFs sobre o mesmo topico → cruzar achados → detectar concordancias/discordancias → note permanente com evidencia triangulada.

**Script:** `tools/docling/cross_evidence.py`

Fluxo:
```
N literature-notes no vault (mesmo tag/topico)
  → Extrair claims de cada note (Key Findings)
  → Cruzar: claim X aparece em quantas fontes?
  → Concordancia (3+ fontes) → claim forte
  → Discordancia → flag para revisao manual
  → Output: permanent-note com:
    - Claim + fontes que suportam
    - Nivel de concordancia (unanime/maioria/dividido/isolado)
    - Gaps: o que nenhum estudo abordou
```

Frontmatter da permanent-note:
```yaml
---
title: "Sintese: {topico}"
confidence: high|medium|low
tags: [permanent-note, cross-evidence]
sources: [nota1.md, nota2.md, ...]
concordancia: unanime|maioria|dividido
coautoria: Lucas + Claude + Docling
---
```

**Anti-alucinacao:** toda claim trackeada ate o PDF fonte original. Nenhuma inferencia sem ancoragem.

## Step 5: Cleanup pendente

**5a. docs/ stale** (decisao Lucas):
- `docs/PIPELINE_MBE_NOTION_OBSIDIAN.md` — migrar conteudo relevante para Obsidian ou deletar
- `docs/WORKFLOW_MBE.md` (mar/29) — mesmo
- `docs/codex-adversarial-s104.md` — historico, candidato a delete

**5b. TREE.md:** regenerar apos mudancas

**5c. Python infra:** esperar decisao Lucas (manter/arquivar/limpar)

---

## Ordem de execucao

1. **Fix dream bug** (Step 1) — elimina irritacao diaria
2. **Incorporar docling-tools** (Step 2) — base para tudo que segue
3. **pdf_to_obsidian.py** (Step 3) — pipeline nucleo
4. **cross_evidence.py** (Step 4) — diferencial anti-alucinacao
5. **Cleanup** (Step 5) — docs stale + TREE.md

## Verificacao

- [ ] Dream NAO dispara automaticamente na proxima sessao
- [ ] `tools/docling/` existe no OLMO com scripts funcionais
- [ ] `uv run python tools/docling/pdf_to_obsidian.py <test.pdf>` gera .md na _inbox
- [ ] Frontmatter compativel com template literature-note do vault
- [ ] Cross-evidence gera permanent-note com rastreabilidade
- [ ] docs/ stale resolvidos
- [ ] TREE.md atualizado
