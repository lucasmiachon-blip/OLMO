# Plan: Adversarial Review — Research Pipeline I/O Hardening

## Context

S145 forest-plot-hunting expôs falhas sistêmicas no pipeline de pesquisa (`/research` SKILL.md).
3 motores lançados em paralelo: Opus/MCPs, Gemini API, Perplexity API.
Resultado: dados úteis mas enterrados em prosa, 1 call vazia, 0 output estruturado de facto.

Este plano propõe mudanças no SKILL.md para evitar reincidência.

---

## Falhas Diagnosticadas (frame adversarial)

### INPUT — Bugs nos prompts/params

| # | Falha | Impacto | Severidade |
|---|-------|---------|------------|
| I1 | `maxOutputTokens: 8192` com `thinkingBudget: 24576` — Gemini conta thinking DENTRO de maxOutputTokens | 1ª call Gemini = 0 bytes de texto | **CRITICAL** |
| I2 | Prompts dizem "ABERTO" sem schema de output — confunde liberdade de TÓPICO com liberdade de FORMATO | Perplexity retornou 31KB ensaio, Opus retornou narrativa longa | **HIGH** |
| I3 | System prompt Perplexity diz "1 paragraph per finding" — parágrafo não é estruturado | Output verboso sem campos parseáveis | **MEDIUM** |
| I4 | Evidence-researcher (subagent) sem formato de output no prompt | Retorno narrativo em vez de tabela | **MEDIUM** |
| I5 | Nenhum prompt especifica limite de comprimento | Motores expandem indefinidamente | **LOW** |

### OUTPUT — Falhas no pós-processamento

| # | Falha | Impacto | Severidade |
|---|-------|---------|------------|
| O1 | Perplexity: `console.log(JSON.stringify(data))` — dump JSON cru sem extração | Conteúdo + metadata misturados | **MEDIUM** |
| O2 | Gemini: sem check de `finishReason` — truncamento silencioso | 1ª call saiu com STOP mas 0 texto (pensou até acabar tokens) | **HIGH** |
| O3 | Step 2.5 checa "dados estruturados?" mas não define schema esperado | Validação subjetiva, não automatizável | **MEDIUM** |
| O4 | Sem normalização entre pernas — cada uma retorna formato diferente | Consolidação manual obrigatória | **HIGH** |
| O5 | Sem deduplicação — 2 pernas retornaram SGLT2i (redundância não detectada automaticamente) | Desperdício de slot | **LOW** |

### DESIGN — Falhas conceituais

| # | Falha | Impacto |
|---|-------|---------|
| D1 | "Prompt ABERTO" confunde 2 eixos: (a) liberdade de tópico vs (b) formato de output. São independentes | Princípio do skill impede structured output |
| D2 | Sem output budget — nenhuma perna tem instrução de concisão | Motores sempre expandem ao máximo |
| D3 | Pipeline vai direto de raw output → síntese. Falta passo intermediário de normalização | Síntese compara maçãs com laranjas |

---

## Mudanças Propostas

### Arquivo: `.claude/skills/research/SKILL.md`

#### M1: Fix Gemini maxOutputTokens (CRITICAL)

**Linha ~87**: `maxOutputTokens: 8192` → `maxOutputTokens: 32768`

Adicionar comentário explicativo:
```
// NOTA: Gemini conta thinking tokens DENTRO de maxOutputTokens.
// Com thinkingBudget: 16384, sobram ~16384 para texto.
// Bug S145: 8192 total - thinking = 0 texto output.
```

Também reduzir thinkingBudget de 24576 → 16384 (pesquisa não precisa de tanto thinking).

#### M2: Adicionar Output Schema Suffix (HIGH)

Novo bloco no SKILL.md após Step 2 — template de sufixo obrigatório para todos os prompts:

```markdown
### Output Schema Suffix (obrigatório em toda perna)

Toda perna DEVE ter um sufixo de formato no prompt. O tópico pode ser aberto,
mas o FORMAT é sempre fechado.

**Principio:** OPEN topic + CLOSED format. Nunca ambos abertos.

Sufixo padrão (adaptar colunas ao tipo de pesquisa):

\`\`\`
=== OUTPUT FORMAT (MANDATORY) ===
Return ONLY a markdown table with these columns. NO prose before or after.

| Field | Item 1 | Item 2 |
|-------|--------|--------|
| First author, year | | |
| Title | | |
| Journal | | |
| PMID | | |
| DOI | | |
| Population | | |
| Intervention | | |
| Comparator | | |
| Primary outcome | | |
| Effect size (specify OR/RR/HR) | | |
| 95% CI | | |
| I² (%) | | |
| N studies | | |
| N patients | | |
| Clinical significance (1-2 sentences max) | | |
| PMID status | CANDIDATE | CANDIDATE |

RULES: No introductions. No conclusions. No methodology discussion.
Only the table. If <2 items found, fill what you have.
\`\`\`
```

#### M3: Fix Perplexity system prompt + response parsing (MEDIUM)

System prompt atual:
```
'Structured output. For each finding: 1 paragraph (3-5 sentences)...'
```

Proposto:
```
'Return findings as markdown tables ONLY. No prose paragraphs.
Every finding = 1 row with columns: Author|Year|Journal|PMID|DOI|
Population|Intervention|Comparator|Outcome|Effect|CI95|I²|N_studies|
N_patients|Significance. Mark all PMIDs as CANDIDATE.'
```

Response parsing — de:
```js
console.log(JSON.stringify(await res.json(), null, 2));
```
Para:
```js
const data = await res.json();
const content = data.choices?.[0]?.message?.content || 'NO CONTENT';
const citations = data.citations || [];
console.log(content);
if (citations.length) {
  console.log('\\n=== CITATIONS ===');
  citations.forEach((c, i) => console.log((i+1) + '. ' + c));
}
```

#### M4: Adicionar finishReason check no Gemini (HIGH)

Após response parse:
```js
const finishReason = data.candidates?.[0]?.finishReason;
if (finishReason === 'MAX_TOKENS') {
  console.error('WARNING: Response truncated (MAX_TOKENS). Increase maxOutputTokens.');
}
if (!parts.some(p => p.text)) {
  console.error('ERROR: No text output. Thinking consumed all tokens.');
}
```

#### M5: Atualizar princípio "Prompt ABERTO" (DESIGN)

De:
```
Prompt ABERTO. Todos PMIDs = [CANDIDATE].
```
Para:
```
Tópico ABERTO, formato FECHADO. Pesquisa exploratória mas output sempre em schema.
Todos PMIDs = [CANDIDATE].
```

Adicionar ao Step 2 regras:
```
**Princípio I/O:** Open topic + Closed format.
- OPEN: "What are the most practice-changing..." (tópico livre)
- CLOSED: "Return ONLY a markdown table..." (formato fixo)
- NEVER: both open (gera ensaio) or both closed (mata criatividade)
```

#### M6: Step 2.5 — Schema Validation Gate (MEDIUM)

Adicionar checklist mecânica ao Step 2.5:

```markdown
### Validação de Schema (Step 2.5)

Para cada perna retornada, verificar mecanicamente:
1. Output contém `|` (pipe) em >=3 linhas? (indica tabela markdown)
2. Output contém PMID ou DOI? (indica dados rastreáveis)
3. Output < 5000 chars? (indica concisão — se > 5000, provavelmente prosa)
4. finishReason != MAX_TOKENS? (indica completude)

Score: 4/4 = prosseguir | 2-3/4 = flag + prosseguir | 0-1/4 = re-prompt ou skip
```

---

## Arquivos Afetados

| Arquivo | Tipo de mudança |
|---------|----------------|
| `.claude/skills/research/SKILL.md` | M1-M6 (todas as mudanças) |

---

## Verificação

1. Lançar busca de **colchicina em DAC** (pedido do Lucas) com os prompts corrigidos
2. Verificar que Gemini retorna texto (não 0 bytes)
3. Verificar que Perplexity retorna tabela (não ensaio)
4. Verificar que output de cada perna é parseável mecanicamente

---

## Teste: Colchicina em DAC

Após implementar M1-M6, lançar pesquisa específica:
- Tópico: "Meta-analyses of colchicine in coronary artery disease"
- Filtros: 2023-2026, Tier 1, RCTs
- Motores: Gemini + Perplexity (2 pernas, rápido)
- Esperar: tabela estruturada, PMIDs, sem ensaio
