# HANDOFF - Proxima Sessao

> Sessao 49 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). 11 rules.
Pipeline /research v2 validado end-to-end com primeiro HTML real (s-rs-vs-ma).
Living HTML per slide: template com badges, referencia rapida, referencias academicas.
Slide s-rs-vs-ma reescrito: 4 colunas (Rev, RS, Umbrella, MA).

## PROXIMO

1. **Verificar PMIDs CANDIDATE** — 35725647 (Shen 2022), 27620683 (Ioannidis 2016) via PubMed MCP
2. **Preencher [EXEMPLO TBD]** — revisao narrativa recente NEJM para speaker notes
3. **Rodar /research em s-aplicacao** — segundo HTML, validar com dados clinicos reais
4. **Cleanup old skills** — remover evidence/, mbe-evidence/, agent literature.md
5. **Metanalise QA** — 14 slides pendentes. Deadline 2026-04-15 (~12 dias)
6. **aside.notes deprecation** — atualizar slide-rules.md + linters
7. **Merge new-slide → slide-authoring** — overlap critico

## DECISOES ATIVAS

- Living HTML per slide substitui: evidence-db.md, aside.notes, Notion slide DB, blueprint.md
- Fontes por slide: de 5 para 2 (evidence HTML + narrative.md)
- Evidence-first workflow: HTML gerado ANTES do slide de apresentacao
- Referencias academicas: Autor (ano) in-text + lista no final com PMID/revista/status
- /research e /teaching NAO fundem (lifecycle diferente). mbe-evaluator e a ponte.
- Projetor ~10m: HTML primary + Canva Pro fallback

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] daily-briefing: adicionar Notion Calendario + Tasks "Due Today"
- [ ] Codex deferred: linter parsers — #13, #28-29. Low ROI.
- [ ] h2 assertion rewrite — 11+ slides. Lucas guia.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-02
