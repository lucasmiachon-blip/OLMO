# HANDOFF - Proxima Sessao

> Sessao 72 | 2026-04-05

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean (v6). Build OK (18 slides metanalise).
content-research.mjs com NLM integration testado e funcional.

## P0 — s-pico REDESIGN (em andamento)

### Triangulacao S71 — COMPLETA (5/5 pernas)
Convergencia nos 4 tipos de indirectness (GRADE 8, Guyatt 2011 PMID 21802903):
1. Populacao, 2. Intervencao, 3. Desfecho (surrogate), 4. Comparacao indireta

### Proximo passo
- [ ] Lucas define texto exato dos 4 boxes (com base na triangulacao)
- [ ] Atualizar living HTML `evidence/s-pico.html` com achados S71 + glossario expandido
- [ ] Build slide: h2 + boxes + source-tag + speaker notes
- [ ] Propagacao: `_manifest.js` headline sync
- [ ] Lint + build + verify

## P1 — DOCS (Codex audit S70 — RESOLVIDO)

Audit completo triado e fixado S71. Restam apenas:
- [ ] gemini-qa3.mjs: grade aula crash (missing docs/prompts/, slide-registry.js) — baixa prioridade, grade ILEGIVEL
- [ ] Obsidian CLI: backlog (plano arquivado em docs/.archive/)

## P2 — AULAS (metanalise)

| Estado | Count | Slides |
|--------|-------|--------|
| DONE | 1 | s-rs-vs-ma |
| REDESIGN | 1 | s-pico (h2 decidido, boxes pendente) |
| LINT-PASS | 14 | todos F2 restantes + I2 + F3 |
| QA pending | 1 | s-checkpoint-1 |
| Title/hook/contrato | 3 | production-ready (sem living HTML) |

- 16 slides sem living HTML. Deadline 2026-04-15 (~10 dias)

## STACK GEMINI

| Componente | Status S71 |
|------------|-----------|
| `content-research.mjs` (API + NLM) | ✅ testado S71 ($0.041 + 139.6s NLM) |
| `gemini-qa3.mjs` (API key) | ✅ funcional |
| Gemini CLI (OAuth) | ✅ disponivel (deep-search pontual) |
| NLM CLI | ✅ auth OK S71, notebook Metanalise 30 fontes |

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- Gemini: API key via scripts. MCP descartado S71.
- NLM: `--nlm` flag no content-research.mjs. 3 queries progressivas.
- Memory governance: cap 20 files (14 atual), next review S72.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- NLM CLI no Windows: sempre `PYTHONIOENCODING=utf-8`. Auth expira ~20min.
- PubMed MCP: dropa sessao frequentemente.

## PENDENTE (herdado)

- [ ] Obsidian CLI (backlog, plano em docs/.archive/)
- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] ARCHITECTURE.md: pode precisar sync adicional (MCP details, workflow engine)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-05
