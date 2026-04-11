# Plan: Refactor s-objetivos

## Context

Lucas quer refatorar o slide s-objetivos da metanalise:
- Remover objetivo 5 ("Certeza na evidencia / Pincelada em GRADE")
- Mudar grid de 3x2 para 2-2-1 (2 top, 2 middle, 1 centralizado embaixo)
- 3 clicks progressivos: row 1 → row 2 → accent (punchline)

---

## 0. Matar skills de slide + limpar refs

### 0.1 Salvar patterns.md (unico ativo genuinamente util)

Mover `.claude/skills/slide-authoring/references/patterns.md` → `.claude/rules/slide-patterns.md`
Adicionar frontmatter `paths: content/aulas/**` para auto-load.

### 0.2 Deletar skill e comando

- Deletar `.claude/skills/slide-authoring/` (diretorio inteiro — SKILL.md + references/)
- Deletar `.claude/commands/new-slide.md`

### 0.3 Limpar todas as referencias

| Arquivo | Linha | Acao |
|---------|-------|------|
| `HANDOFF.md` | 15 | Remover "Usar /new-slide skill + /slide-authoring" |
| `.claude/hooks/guard-qa-coverage.sh` | inteiro | Deletar hook (guard-product-files.sh ja cobre edits em slides) |
| `.claude/hooks/README.md` | 72 | Remover linha do guard-qa-coverage |
| `wiki/concepts/skill.md` | 23 | Remover /new-slide e /slide-authoring da lista Ensino, ajustar contagem |
| `.claude/settings.local.json` | se registra hook | Remover registro do guard-qa-coverage |

Pos-deadline: criar skill nova com skill-creator, migrar de rules para skill.

---

## 1. HTML: remover item 5 + renumerar

**Arquivo:** `content/aulas/metanalise/slides/00b-objetivos.html`

**Remover bloco inteiro do item 5:**
```html
<div class="obj-item" data-reveal="2">
  <span class="obj-num">5</span>
  <div class="obj-body">
    <p class="obj-skill">Certeza na evidência</p>
    <p class="obj-detail">Pincelada em GRADE</p>
  </div>
</div>
```

**Renumerar:** item 6 (accent) → item 5. `<span class="obj-num">6</span>` → `5`.

**Ajustar data-reveal (3 grupos):**
- Items 1, 2: `data-reveal="1"` (row topo)
- Items 3, 4: `data-reveal="2"` (row meio)
- Item 5 accent: `data-reveal="3"` (centralizado embaixo)

Nota: items 1-2 hoje tem `data-reveal="1"`, item 3 tem `data-reveal="1"` tambem — precisa mudar para `"2"`. Item 4 (ex-heterogeneidade, hoje reveal="2") fica `"2"`. Item accent (hoje reveal="3") fica `"3"`.

## 2. CSS: grid 2-2-1

**Arquivo:** `content/aulas/metanalise/metanalise.css`

Atualizar comentario e adicionar centralizacao do accent:
```css
/* --- Objetivos: 2-2-1 grid (5 items) --- */
```

Grid ja tem `grid-template-columns: 1fr 1fr` — isso funciona pra 2-2. Para o item accent na row 3 centralizado, adicionar:
```css
section#s-objetivos .obj-item--accent {
  grid-column: 1 / -1;
  justify-self: center;
  max-width: 480px;
  /* manter background, padding, margin, border-radius existentes */
}
```

## 3. slide-registry.js: ajustar comentario

**Arquivo:** `content/aulas/metanalise/slide-registry.js`

Atualizar comentario:
```js
// Click-reveal: 3 groups (1-2 conceitos, 3-4 metodologia, 5 punchline)
```
Logica (`groups = [1, 2, 3]`) ja esta correta — nao muda.

## 4. _manifest.js: sem mudanca

clickReveals ja e 3. headline nao muda. Nada a fazer.

## 5. Build + lint

```bash
cd content/aulas && npm run lint:slides && npm run build:metanalise
```

---

## Verificacao

1. `npm run lint:slides` → PASS
2. `npm run build:metanalise` → PASS
3. Abrir dev server, navegar ate s-objetivos, confirmar:
   - Click 1: items 1,2 aparecem (row topo)
   - Click 2: items 3,4 aparecem (row meio)
   - Click 3: item 5 accent aparece (centralizado embaixo)
   - Grid visual: 2 top, 2 middle, 1 centered bottom

## Arquivos modificados

| Arquivo | Acao |
|---------|------|
| `.claude/rules/slide-patterns.md` | CRIAR (conteudo de patterns.md com frontmatter) |
| `.claude/skills/slide-authoring/` | DELETAR diretorio |
| `.claude/commands/new-slide.md` | DELETAR |
| `.claude/hooks/guard-qa-coverage.sh` | DELETAR |
| `.claude/hooks/README.md` | EDITAR (remover linha do hook deletado) |
| `.claude/settings.local.json` | EDITAR (remover registro do hook, se existir) |
| `HANDOFF.md` | EDITAR (remover refs a skills deletadas) |
| `wiki/concepts/skill.md` | EDITAR (remover skills, ajustar contagem) |
| `content/aulas/metanalise/slides/00b-objetivos.html` | EDITAR (remover item 5, renumerar, ajustar reveals) |
| `content/aulas/metanalise/metanalise.css` | EDITAR (comentario + accent centralizado) |
| `content/aulas/metanalise/slide-registry.js` | EDITAR (comentario) |
