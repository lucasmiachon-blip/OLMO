# HANDOFF - Proxima Sessao

> Sessao 71 | 2026-04-05

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean (v6). Build OK (18 slides metanalise).

## P0 — s-pico REDESIGN (em andamento)

### Decisoes Lucas (S71)
- **h2**: "PICO mismatch e indirectness no GRADE — motivo formal para rebaixar certeza"
- **Boxes**: Ponte PICO→GRADE (cada letra → tipo de indirectness)
- **Conteudo boxes**: INDEFINIDO — depende da sintese da triangulacao abaixo

### Triangulacao S71 — 5 pernas concluidas

| Perna | Status | Achados-chave |
|-------|--------|---------------|
| Consensus MCP | ✅ | Core GRADE 5 (Guyatt 2025, 6 cit), GRADE 8 (Guyatt 2011, 1098 cit), Concept 4 (Goldkuhle 2023, 7 cit) |
| SCite MCP | ✅ | Core GRADE 5 metadata confirmada. Secoes do paper: "differences in population", "differences in interventions", "differences in comparators", "differences in outcomes". Content denied (paywall) mas PDF aberto |
| PubMed MCP | ❌ | Session terminated (3a vez). Fallback: WEB-VERIFIED |
| Gemini API (`content-research.mjs`) | ✅ $0.049 | 4 tipos + exemplos clinicos. Broad vs focused PICO. ~12.2% downgrade por indirectness. Salvo em `qa-screenshots/s-pico/content-research.md` |
| NLM (notebook Metanalise, 30 fontes) | ✅ | 4 tipos com exemplos dos livros. Target PICO vs Study PICO. Broad vs Focused PICO (lumping vs splitting). 10 citacoes de 5 fontes diferentes |

### Convergencia (5/5 pernas)

**4 tipos de indirectness (GRADE 8, Guyatt 2011 PMID 21802903):**
1. **Populacao**: trial em pop A aplicado a pop B diferente (ex: cancer avancado → inicial)
2. **Intervencao**: dose/via/regime testado difere do pretendido (ex: simvastatina 20mg → atorva 80mg)
3. **Desfecho**: surrogate no lugar de patient-important outcome (ex: HbA1c → eventos CV)
4. **Comparacao indireta**: sem head-to-head, comparacao via ponte (ex: A vs placebo + B vs placebo)

**Expansao Goldkuhle 2023 (PMID 37146659 VERIFIED):**
- Treatment switching no braco comparador = indirectness de comparador (nao bias)

**Core GRADE 5 (Guyatt 2025, PMID 40393729 VERIFIED):**
- Target PICO (ideal do clinico) vs Study PICO (o que o trial testou)
- Discrepancia substancial → avaliar probabilidade de magnitude diferir → rate down

**Broad vs Focused PICO (Cochrane v6.5 cap 3):**
- Broad (lumping) → poder estatistico mas heterogeneidade
- Focused (splitting) → directness mas imprecisao

**Dado quantitativo**: ~12.2% downgrade por indirectness em Cochrane cirurgicas (imprecisao e RoB dominam)

**PMID falso flaggado**: Gemini retornou PMID 37263516 para Goldkuhle — SCite confirma DOI correto = PMID 37146659

### Glossario novos termos (para "Se Perguntarem")
- Target PICO vs Study PICO
- Broad PICO vs Focused PICO (lumping vs splitting)
- Review PICO → Synthesis PICO → Study PICO (3 camadas Cochrane v6.5)
- Estimand framework (Remiro-Azocar 2025)

### Proximo passo
- [ ] Lucas define texto exato dos 4 boxes (com base na triangulacao acima)
- [ ] Atualizar living HTML `evidence/s-pico.html` com achados S71 + glossario expandido
- [ ] Build slide: h2 + boxes + source-tag + speaker notes
- [ ] Propagacao: `_manifest.js` headline sync
- [ ] Lint + build + verify

## P1 — DOCS (Codex adversarial S70)

Audit completo: `docs/CODEX-AUDIT-S70.md`. Total: **6 HIGH, 39 MEDIUM, 6 LOW**.
(Sem mudancas S71 — foco em s-pico)

## P2 — AULAS (metanalise)

| Estado | Count | Slides |
|--------|-------|--------|
| DONE | 1 | s-rs-vs-ma |
| REDESIGN | 1 | s-pico (h2 decidido, boxes pendente) |
| LINT-PASS | 14 | todos F2 restantes + I2 + F3 |
| QA pending | 1 | s-checkpoint-1 |
| Title/hook/contrato | 3 | production-ready (sem living HTML) |

- 2 evidence HTMLs existem: `evidence/s-pico.html` (parcial) + `evidence/s-rs-vs-ma.html` (DONE)
- 16 slides sem living HTML. Deadline 2026-04-15 (~10 dias)

## STACK GEMINI

| Componente | Status S71 |
|------------|-----------|
| `content-research.mjs` (API key) | ✅ funcional, usado S71 ($0.049) |
| `gemini-qa3.mjs` (API key) | ✅ funcional |
| Gemini CLI (OAuth) | ✅ disponivel (deep-search pontual) |
| NLM CLI | ✅ auth OK S71, notebook Metanalise 30 fontes |

**Decisao S71**: Gemini MCP descartado. Usar Gemini via API (Google AI Studio) com scripts existentes.

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- aside.notes removido do lint — notes no living HTML.
- Gemini: API key via scripts (`content-research.mjs`, `gemini-qa3.mjs`). MCP descartado.
- Memory governance: cap 20 files (15 atual), next review S72.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Gemini: API key (scripts) para research/QA, CLI para deep-search pontual. MCP descartado.
- NLM CLI no Windows: sempre `PYTHONIOENCODING=utf-8`.
- PubMed MCP: dropa sessao frequentemente (S70 2x, S71 1x).
- Context rot: commit + update docs antes de degradar.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] ARCHITECTURE.md sync (stale: skills, agents, rules, MCP counts)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-05
