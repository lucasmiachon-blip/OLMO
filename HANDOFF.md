# HANDOFF - Proxima Sessao

> Sessao 135 | 2026-04-09
> Foco: build s-importancia

## ESTADO ATUAL

Monorepo funcional. CI verde. Build pendente (19 slides metanalise — s-importancia adicionado).
**Agentes: 10.** **Hooks: 39 registrations.** **Rules: 10**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 10.**
**Skills: 18.** **Memory: 20/20.** **.claudeignore: criado S128.**

## P0 — s-importancia: build + QA

Arquivos criados S135, falta build + QA:
1. `npm run build:metanalise` + `npm run lint:slides` + visual check
2. Atualizar `evidence/s-importancia.html` — mover speaker notes para la
3. QA pipeline: Preflight → Inspect → Editorial
4. Deletar mockups `.claude/mockup-importancia-*.html`

## P1 — Remover GRADE slides

Lucas: "todos os slides de GRADE vao sumir, talvez 1 novo". Limpar:
- manifest entries de GRADE
- CSS de GRADE em metanalise.css
- JS de GRADE em slide-registry.js
- Arquivos HTML de GRADE em slides/

## P2 — Enxugar memoria

Manter: agnosticos (feedback, patterns, user) + metanalise-specific.
Freeze/arquivar: seasonal que nao se aplica a metanalise. So fica o que e agnostico ou metanalise.

## BACKLOG (pos-deadline)

| # | Item | Detalhe |
|---|------|---------|
| 1 | Refatorar 6 evidence HTMLs | s-hook, s-pico, s-rs-vs-ma, s-objetivos, s-checkpoint-1, s-ancora → benchmark |
| 2 | Pernas pendentes (research) | Perna 2 (evidence-researcher: Scite/CrossRef/SemScholar/BioMCP), Perna 6 (NLM: requer login). Queries co-designed |
| 3 | Adversarial deferred: M-01, M-10 | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 4 | Hook/config system review | JSON adequado? YAGNI audit. Esquema de config (ref: WhatsApp JPEG subagents post). Brainstorming + micropassos |
| 5 | Pipeline DAG end-to-end | cowork→NLM→wiki |
| 6 | medicina-clinica stubs | 4 concepts stub/low aguardam Cowork harvest |
| 7 | Skill de slides consolidada | Usar skill-creator para criar skill nova, migrar de rules para skill |

## DECISOES ATIVAS

- **Living HTML = source of truth = SINTESE CURADA.**
- **Evidence benchmark S131:** TODOS evidence HTMLs = estrutura pre-reading-heterogeneidade.
- **Estilo narrativo S119:** foco em metodologia, exemplos pontuais.
- **Dual creation S135:** Gemini + Claude geram mockups HTML independentes. NUNCA Claude reescreve Gemini.
- **Pedagogia adultos S135:** sem formulas em slides (1/√N proibido), numeros concretos SIM.
- **Speaker notes S135:** vao para evidence HTML, NAO aside no slide.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- KBP-07 anti-workaround, KBP-08 anti-substituicao, KBP-09 anti-routing, KBP-10 anti-destructive.
- MCP gate + Research gate: hooks force "ask" antes de MCP/research calls.
- MCP freeze ate 2026-04-14. PubMed session expirou S129.
- Projetor metanalise: ~10m distancia. Legibilidade = constraint #1.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S135 2026-04-09
