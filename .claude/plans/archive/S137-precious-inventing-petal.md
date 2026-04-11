# Plano: QA s-importancia (Sessao 137)

## Context

Slide `s-importancia` foi criado na S135 e built na S136. Estado atual: LINT-PASS. Proximo passo no HANDOFF P0: rodar o pipeline QA (3 gates sequenciais). Este plano cobre **apenas o Gate -1 (Preflight)** — os gates seguintes dependem de Lucas aprovar cada etapa.

## Arquivos criticos

| Arquivo | Papel |
|---------|-------|
| `content/aulas/metanalise/slides/02-importancia.html` | Slide HTML fonte |
| `content/aulas/metanalise/metanalise.css` (L730-861) | CSS scopado `section#s-importancia` |
| `content/aulas/metanalise/slide-registry.js` (L89-107) | Animacao GSAP |
| `content/aulas/metanalise/slides/_manifest.js` | Manifest entry |
| `content/aulas/metanalise/evidence/s-importancia.html` | Evidence HTML |

## Pipeline (qa-pipeline.md Step 1-5)

### Step 1 — Build
```bash
cd content/aulas && npm run build:metanalise
```
Confirma lint + build OK. Se falhar, diagnosticar antes de prosseguir.

### Step 2 — Capture screenshots
```bash
cd content/aulas && node scripts/qa-capture.mjs --aula metanalise --slide s-importancia
```
Gera PNGs (S0 initial + S2 final) em `metanalise/qa-screenshots/s-importancia/`.

### Step 3 — Pre-read criterios (KBP-04)
Ler antes de avaliar:
- `design-reference.md` §1 (cor semantica) e §2 (tipografia)
- `slide-rules.md` §1-§2 (estrutura, CSS)
Ja lidos neste plan mode — re-ler no momento da avaliacao.

### Step 4 — Ler screenshot + codigo
- Ler PNGs capturados (multimodal)
- Ler `02-importancia.html` (HTML)
- Ler CSS (metanalise.css L730-861)

### Step 5 — Avaliar 4 dims

| Dim | Criterio |
|-----|----------|
| Cor | Tokens sem literais fora :root. Semantica clinica correta. Contraste projecao 6m |
| Tipografia | Font >= 18px corpo. Sem vw/vh. Peso legivel. tabular-nums em dados |
| Hierarquia | h2 presente. Punchline > suporte. Fluxo visual |
| Design | Composicao, espacamento, proporcao, viewport 1280x720 |

Output: tabela `| Dim | PASS/FAIL | Evidencia |`
Qualquer FAIL = iterar antes de Gemini.

### STOP — Reportar e aguardar Lucas

## O que NAO fazer
- NAO avancar para Gate 0 (Inspect) sem OK do Lucas
- NAO avaliar mais de 1 slide
- NAO criar scripts
- NAO editar o slide sem instrucao explicita

## Verificacao
- Build exit code 0
- Screenshots existem em qa-screenshots/s-importancia/
- Tabela de 4 dims com evidencia concreta (nao opiniao)
