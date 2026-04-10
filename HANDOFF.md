# HANDOFF - Proxima Sessao

> Sessao 138 | 2026-04-10
> Foco: QA s-importancia — h2 + visual hierarchy

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (16 slides metanalise).
**Agentes: 10.** **Hooks: 39 registrations.** **Rules: 10**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 10.**
**Skills: 18.** **Memory: 19/20.** **.claudeignore: criado S128.**

## P0 — QA s-importancia (continuar)

h2 restaurado. Contraste navy corrigido. Visual hierarchy melhorada. SplitText motion implementado.
Pendencias:
1. Testar animacao no browser (SplitText word reveal + 3 tempos)
2. Avaliar se motion e realmente invisivel/subsidiario a 10m
3. Refletir: repertorio alem de GSAP (CSS animations, SVG, scroll-driven?)
4. Preflight formal apos motion finalizado
5. Gate 0: `gemini-qa3.mjs --aula metanalise --slide s-importancia --inspect`
6. Gate 4: `gemini-qa3.mjs --aula metanalise --slide s-importancia --editorial`

## P1 — QA restantes (12 slides LINT-PASS)

Lucas decide qual slide. Pipeline: 1 slide/vez, 3 gates.

## BACKLOG (pos-deadline)

| # | Item | Detalhe |
|---|------|---------|
| 1 | Refatorar 6 evidence HTMLs | s-hook, s-pico, s-rs-vs-ma, s-objetivos, s-checkpoint-1, s-ancora → benchmark |
| 2 | Pernas pendentes (research) | Perna 2 (evidence-researcher), Perna 6 (NLM: requer login) |
| 3 | Adversarial deferred: M-01, M-10 | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 4 | Hook/config system review | JSON adequado? YAGNI audit |
| 5 | Pipeline DAG end-to-end | cowork→NLM→wiki |
| 6 | medicina-clinica stubs | 4 concepts stub/low aguardam Cowork harvest |
| 7 | Skill de slides consolidada | Usar skill-creator para criar skill nova |

## DECISOES ATIVAS

- **Living HTML = source of truth = SINTESE CURADA.**
- **Evidence benchmark S131:** TODOS evidence HTMLs = estrutura pre-reading-heterogeneidade.
- **Estilo narrativo S119:** foco em metodologia, exemplos pontuais.
- **Dual creation S135:** Gemini + Claude geram mockups HTML independentes. NUNCA Claude reescreve Gemini.
- **Pedagogia adultos S135:** sem formulas em slides (1/√N proibido), numeros concretos SIM.
- **Speaker notes S135:** vao para evidence HTML, NAO aside no slide.
- **Archetype removal S136:** campo archetype removido do manifest. Liberdade artistica.
- **Projecao S138:** 2 cenarios (sala 6m TV + auditorio 10m projetor). Design target: 10m.
- **Motion S138:** animacoes subsidiarias ao conteudo, NUNCA protagonistas. Com proposito pedagogico.
- **QA visual S138:** analise multimodal obrigatoria (screenshot como imagem), nao apenas codigo.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- KBP-07 anti-workaround, KBP-08 anti-substituicao, KBP-09 anti-routing, KBP-10 anti-destructive.
- MCP gate + Research gate: hooks force "ask" antes de MCP/research calls.
- MCP freeze ate 2026-04-14. PubMed session expirou S129.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever h2 sem instrucao EXPLICITA e inequivoca.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S138 2026-04-10
