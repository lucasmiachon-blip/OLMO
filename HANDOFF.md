# HANDOFF - Proxima Sessao

> Sessao 56 (cont.) | pos-clear

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 11 rules (5 path-scoped).
s-pico evidence HTML completo (7 refs verified, NLM leg validado).
/research pipeline agora inclui NotebookLM como perna adicional.

## PROXIMO

1. **Construir slide s-pico** — evidence HTML pronto em `evidence/s-pico.html`. Decidir: source-tag (Guyatt 2025?), speaker notes (indirectness, treatment switching), h2 (manter?)
2. **Rodar /research em s-aplicacao** — segundo HTML, validar com dados clinicos reais
3. **Metanalise QA** — 13 slides pendentes. Deadline 2026-04-15 (~11 dias)
4. **Integrar NLM leg no /research skill** — formalizar no SKILL.md
5. **Cleanup old skills** — remover evidence/, mbe-evidence/, agent literature.md

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- NLM como perna do /research (query aberta a fontes curadas por Lucas).
- Queries de pesquisa: exploratorias, NAO deterministas.
- Narrativa evidence: citacao cientifica (Autor, ano) sem PMID inline.
- `.theme-dark` class para dark slides. /research e /teaching NAO fundem.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.
- Security gates fail-closed. NaN/negative input → BLOCK.
- Jia et al. 2026 (Gemini) = INVALID. DOI nao resolve. Dado removido.
- Greenhalgh 7a (Wiley DOI:10.1002/9781394206933) — sem acesso CAPES/USP. Lucas vai procurar.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] daily-briefing: adicionar Notion Calendario + Tasks "Due Today"
- [ ] h2 assertion rewrite — 11+ slides. Lucas guia.
- [ ] reduced-motion visual test — Chrome --force-prefers-reduced-motion
- [ ] Cirrose: migrar dark slides para .theme-dark (mesmo pattern)
- [ ] ARCHITECTURE.md sync — alinhar com implementacao real

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-03
