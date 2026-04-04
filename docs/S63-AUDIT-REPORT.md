# S63 Audit Report — CLAUDE.md + Rules

> Sessao 63 | 2026-04-04 | Coautoria: Lucas + Opus 4.6 + GPT-5.4 (Codex)
> Status: REPORT ONLY. Nenhum fix aplicado alem do P0.1 (consolidacao).
> Proxima acao: Lucas revisa, aprova fixes, executa na S64.

---

## P0.1 — Consolidacao (JA APLICADO)

Mudancas estruturais ja commitadas nesta sessao:

| Acao | Resultado |
|------|-----------|
| Merge efficiency.md + quality.md INTO anti-drift.md | 11 → 9 rules |
| Trim root CLAUDE.md (Objectives, Self-Improvement) | 86 → 77 linhas |
| Trim process-hygiene.md (remover bash snippets) | 49 → 26 linhas |
| Compactar status table metanalise/CLAUDE.md | 107 → 96 linhas |
| Adicionar frontmatter description a coauthorship.md | Metadata para discovery |
| Adicionar frontmatter description a session-hygiene.md | Metadata para discovery |
| Deletar efficiency.md e quality.md | -2 arquivos |

---

## P0.2 — Codex Audit Round 1A (CLAUDE.md + unscoped rules)

### Raw Findings (GPT-5.4)

#### CLAUDE.md (root)
| Criterio | Resultado | Evidencia |
|----------|-----------|-----------|
| C1 Conciseness | FAIL | Enforcement repetido 2x + mix de concerns |
| C2 Actionability | FAIL | "Maximo valor, minimo custo" e "glob primeiro" vagos |
| C3 Consistency | FAIL | "espere OK" vs "Claude Code=FAZER" ambiguo |
| C4 Completeness | FAIL | Sem boundary clara always-obeyed vs delegated |
| C5 Scoping | FAIL | Slide/Notion/QA rules em root loads every session |

#### CLAUDE.md (global)
| Criterio | Resultado | Evidencia |
|----------|-----------|-----------|
| C1 Conciseness | FAIL | Identity + memory + dream + screenshots bundled |
| C2 Actionability | FAIL | "etimologia, filosofia, conexoes" subjetivo |
| C3 Consistency | FAIL | "5 workarounds" vs auto /dream |
| C4 Completeness | FAIL | /dream depende de comando que pode nao existir |
| C5 Scoping | FAIL | Memory system + statusline nao universal |

#### anti-drift.md
| Criterio | Resultado | Evidencia |
|----------|-----------|-----------|
| C1 Conciseness | FAIL | >20% compressivel (intent/verify restatements) |
| C2 Actionability | FAIL | "Connect to concepts Lucas knows" vago |
| C3 Consistency | FAIL | "one commit" pode conflitar com non-commit tasks |
| C4 Completeness | FAIL | Verification gate sem fallback para "sem comando" |
| C5 Scoping | FAIL | globs: ** overbroad para trivial tasks |

#### coauthorship.md
| Criterio | Resultado | Evidencia |
|----------|-----------|-----------|
| C1 Conciseness | PASS | — |
| C2 Actionability | FAIL | "[modelos]" placeholder sem triggers |
| C3 Consistency | FAIL | Co-authored-by "invalido" para AI |
| C4 Completeness | FAIL | Sem fallback se reference unavailable |
| C5 Scoping | FAIL | Loads every session sem path scope |

#### session-hygiene.md
| Criterio | Resultado | Evidencia |
|----------|-----------|-----------|
| C1 Conciseness | PASS | — |
| C2 Actionability | PASS | — |
| C3 Consistency | FAIL | Triggers nao alinhados com root |
| C4 Completeness | FAIL | No-commit case sem cobertura |
| C5 Scoping | FAIL | Loads em read-only sessions |

#### notion-cross-validation.md
| Criterio | Resultado | Evidencia |
|----------|-----------|-----------|
| C1 Conciseness | PASS | — |
| C2 Actionability | PASS | — |
| C3 Consistency | FAIL | Opening mais estrito que exceptions |
| C4 Completeness | FAIL | Sem fallback ChatGPT unavailable |
| C5 Scoping | FAIL | `**/*notion*` captura files que mencionam "notion" |

#### metanalise/CLAUDE.md
| Criterio | Resultado | Evidencia |
|----------|-----------|-----------|
| C1 Conciseness | FAIL | Narrative + status + hardware + QA num arquivo |
| C2 Actionability | PASS | — |
| C3 Consistency | FAIL | IPD out of scope mas ancora e IPD-MA |
| C4 Completeness | FAIL | Sem fallback se artifacts missing/stale |
| C5 Scoping | PASS | — |

### Triagem Round 1A

| # | Finding | Veredicto | Acao proposta |
|---|---------|-----------|---------------|
| 1 | Over-scoping (5 files always-on) | **ACCEPT design** | Custo baixo (~150 lines), risco de nao carregar > custo. Documentar. |
| 2 | Precedence "espere OK" vs "FAZER" | **FIX** | Add 1-liner: "Tabela = funcao, NAO autonomia. Espere OK prevalece." |
| 3 | "etimologia/filosofia" nao-executavel | **ACCEPT** | Preferencia comunicacional, funciona na pratica. Nao e gate. |
| 4 | /dream fallback se skill inexistente | **FIX** | Add check: "AND /dream skill available. Se nao, skip silently." |
| 5 | Root CLAUDE.md surface area | **ACCEPT** | 77 linhas, dentro do range 60-80. Enforcement duplicado intencional. |
| 6 | IPD scope vs ancora IPD-MA | **FIX** | Clarificar: "IPD metodologia = fora. Ancora usa IPD mas e ensinada como pairwise." |
| 7 | Verification gate sem fallback | **FIX** | Add: "Sem comando: verificar manualmente (ler o arquivo)." |
| 8 | Co-authored-by "invalido" | **REJECT** | Factualmente errado — padrao GitHub/Copilot/Claude. |
| 9 | notion-cross-validation opening vs exceptions | **FIX minor** | Rephrase opening para alinhar com scope real. |
| 10 | session-hygiene no-commit case | **FIX minor** | Add 1-liner sobre sessoes sem commit mas com state change. |

**Score: 5 FIX, 3 ACCEPT, 1 REJECT, 1 nao-classificado (opening rephrasing)**

---

## P0.2 — Codex Audit Round 1B (path-scoped rules)

### Raw Findings (GPT-5.4)

#### slide-rules.md
| Criterio | Resultado | Evidencia |
|----------|-----------|-----------|
| C1 Conciseness | FAIL | Mix de HTML/CSS/GSAP/deck.js/temas/erros/bootstrap |
| C2 Actionability | PASS | Imperativas: NUNCA, DEVE, limites numericos |
| C3 Consistency | PASS | Vocabulario estavel (E-codes, data-animate, theme-dark) |
| C4 Completeness | FAIL | E-codes sem fonte canonica, validate-css.sh sem path |
| C5 Scoping | PASS | Especifico para aulas |
| C6 Path-scope | FAIL | Usa `globs:` em vez de `paths:` (inconsistente) |

#### design-reference.md
| Criterio | Resultado | Evidencia |
|----------|-----------|-----------|
| C1 Conciseness | PASS | — |
| C2 Actionability | FAIL | "tratamento visual superior" subjetivo |
| C3 Consistency | PASS | — |
| C4 Completeness | PASS | — |
| C5 Scoping | PASS | — |
| C6 Path-scope | PASS | — |

#### qa-pipeline.md
| Criterio | Resultado | Evidencia |
|----------|-----------|-----------|
| C1 Conciseness | PASS | — |
| C2 Actionability | PASS | — |
| C3 Consistency | PASS | — |
| C4 Completeness | FAIL | Gates sem criterios entry/exit formais |
| C5 Scoping | FAIL | `**/qa*` e `**/gate*` captura fora de aulas |
| C6 Path-scope | FAIL | Amplo demais |

#### process-hygiene.md
| Criterio | Resultado | Evidencia |
|----------|-----------|-----------|
| C1 Conciseness | PASS | — |
| C2 Actionability | FAIL | Comandos "invalidos em PowerShell" |
| C3 Consistency | PASS | — |
| C4 Completeness | FAIL | Faltam instrucoes robustas para iniciante |
| C5 Scoping | PASS | — |
| C6 Path-scope | PASS | — |

#### mcp_safety.md
| Criterio | Resultado | Evidencia |
|----------|-----------|-----------|
| C1 Conciseness | PASS | — |
| C2 Actionability | FAIL | "confidence < 0.70" sem definicao de calculo |
| C3 Consistency | FAIL | Vocabulario diferente das rules de slides |
| C4 Completeness | FAIL | Sem mapeamento para tools reais |
| C5 Scoping | FAIL | Conteudo MCP/Notion, nao aulas |
| C6 Path-scope | FAIL | Paths nao correspondem a aulas |

### Cross-File Overlaps (Codex)

1. E21 (dados medicos) aparece em slide-rules.md E design-reference.md
2. Batch limits em slide-rules (max 5), qa-pipeline (nunca batch), mcp_safety (batch > 5 = humano)
3. Aprovacao humana em slide-rules (layout) e mcp_safety (writes)
4. Motion/QA em slide-rules (timing/easing) e qa-pipeline (Call C)
5. Higiene operacional em qa-pipeline (gates) e process-hygiene (dev server)

### Triagem Round 1B

| # | Finding | Veredicto | Acao proposta |
|---|---------|-----------|---------------|
| 1 | slide-rules globs vs paths inconsistente | **FIX** | Normalizar para `paths:` como os demais |
| 2 | E-codes sem fonte canonica | **ACCEPT** | E-codes sao inline — criar registry seria over-engineering agora |
| 3 | qa-pipeline paths `**/qa*` amplo demais | **FIX** | Narrow para `content/aulas/**/qa*` ou remover wildcard |
| 4 | process-hygiene "invalido em PowerShell" | **REJECT** | Projeto usa bash (Git Bash). Comandos sao validos. |
| 5 | mcp_safety "fora de aulas" | **REJECT** | ERRO DO MEU PROMPT — agrupei com "aulas rules" mas mcp_safety tem scope proprio (Notion/MCP). |
| 6 | design-reference "tratamento visual superior" | **ACCEPT** | Principio de design, nao gate. Funciona como orientacao. |
| 7 | qa-pipeline gates sem entry/exit criteria | **ACCEPT** | Criterios estao em metanalise/CLAUDE.md. Cross-ref, nao gap. |
| 8 | E21 overlap entre slide-rules e design-reference | **ACCEPT** | design-reference tem checklist completo, slide-rules tem menction. Complementares. |
| 9 | mcp_safety confidence score sem definicao | **ACCEPT** | Valido — "confidence < 0.70" precisa de criterio operacional. TODO futuro. |

**Score: 2 FIX, 5 ACCEPT, 2 REJECT**

---

## Resumo: Fixes Pendentes (para S64)

### FIX — Alto impacto (aplicar)
1. **root CLAUDE.md L36**: Add "Tabela = funcao, NAO autonomia. Espere OK prevalece."
2. **anti-drift.md Verification**: Add fallback "Sem comando: verificar manualmente"
3. **metanalise/CLAUDE.md L11**: Clarificar IPD scope vs ancora
4. **global CLAUDE.md Auto Dream**: Add skill availability check

### FIX — Medio impacto (aplicar)
5. **slide-rules.md frontmatter**: `globs:` → `paths:` (normalizar)
6. **qa-pipeline.md frontmatter**: Narrow `**/qa*` → `content/aulas/**/qa*`
7. **notion-cross-validation.md opening**: Rephrase para alinhar com exceptions
8. **session-hygiene.md**: Add no-commit case

### ACCEPT — Nao requer acao imediata
- Over-scoping de 5 files always-on (design tradeoff, custo baixo)
- "etimologia/filosofia" como preferencia comunicacional
- E-codes inline sem registry central
- Cross-file overlaps sao complementares, nao duplicacao
- confidence score sem definicao operacional (TODO futuro)

### REJECT — Falsos positivos
- Co-authored-by "invalido" (padrao real do GitHub)
- Comandos bash "invalidos em PowerShell" (projeto usa bash)
- mcp_safety "fora de aulas" (meu erro de prompt — agrupei errado)

---

## Round 2 (Adversarial) — PROMPTS PRONTOS

Prompts preparados em `.claude/tmp/`. Rodar em S64 APOS aplicar os 8 fixes acima.

### 2A: Cross-file contradictions (`.claude/tmp/codex-round2a.md`)
4 pares comparados:
1. CLAUDE.md root vs anti-drift.md — precedence, redundancy
2. session-hygiene.md vs HANDOFF.md real — regra seguida?
3. slide-rules.md vs design-reference.md — overlap E21, E52, tokens
4. mcp_safety.md vs notion-cross-validation.md — workflow conflitante?

Criterios: Contradiction, Precedence gap, Redundancy, Terminology drift.

### 2B: Dead references scan (`.claude/tmp/codex-round2b.md`)
11 files escaneados. Cada referencia classificada como EXISTS/UNKNOWN/LIKELY_DEAD.
Alvos: file paths, URLs, commands, E-codes, named concepts.

### Comando para rodar (S64)
```bash
cat .claude/tmp/codex-round2a.md | codex exec --sandbox read-only -o .claude/tmp/codex-r2a-output.md -
cat .claude/tmp/codex-round2b.md | codex exec --sandbox read-only -o .claude/tmp/codex-r2b-output.md -
```

### Workflow S64
1. Revisar este report
2. Aplicar 8 fixes (FIX alto + medio)
3. Commit intermediario
4. Rodar Round 2A + 2B (comandos acima)
5. Triagem Round 2
6. Fixes finais + commit
7. Build slides metanalise + preparar pre-reading

---

## Metricas

| Metrica | Antes (S62) | Depois (S63 P0.1) |
|---------|------------|-------------------|
| Rules | 11 | 9 (-2 merged) |
| Root CLAUDE.md | 86 linhas | 77 linhas |
| process-hygiene.md | 49 linhas | 26 linhas |
| metanalise/CLAUDE.md | 107 linhas | 96 linhas |
| Codex findings total | — | 50 criteria checked |
| FIX pendentes | — | 8 |
| ACCEPT | — | 8 |
| REJECT (FP) | — | 3 |

---

Coautoria: Lucas + Opus 4.6 (orquestrador) + GPT-5.4 via Codex (auditor)
