# HANDOFF - Proxima Sessao

> Sessao 139 | 2026-04-10
> Foco: melhorar s-importancia — click-reveal + QA adversarial

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (16 slides metanalise).
**Agentes: 10.** **Hooks: 39 registrations.** **Rules: 10**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 10.**
**Skills: 18.** **Memory: 20/20.** **.claudeignore: criado S128.**

## P0 — QA s-importancia (continuar)

Click-reveal implementado (5 beats). SplitText removido. Font 18px. Dead CSS limpo.
Gemini R12: overall 6.5 (motion 7.4, "didatica"). FPs em css_cascade e failsafes ([data-qa] design).
Pendencias:
1. Verificar no browser ao vivo (click-reveals + transicao cross-slide)
2. Re-capturar video com transicao (qa-capture.mjs atualizado S139)
3. Gemini R13 adversarial com payload adaptado (WHAT/WHY/PROPOSAL/GUARANTEE)
4. Ajustar gemini-qa3.mjs para output estruturado seguir memorias (call adicional se preciso)
5. Avaliar proporcao navy card (300px) — Gemini flagou, Lucas quer manter ΣN como hero
6. Considerar direcao motion: items originando do card (sugestao Gemini narrativa_motion)

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
- **Motion S139:** animacoes com PROPOSITO pedagogico (retencao, carga cognitiva, varredura). Sem proposito = nao animar.
- **QA visual S138:** analise multimodal obrigatoria (screenshot como imagem), nao apenas codigo.
- **QA output S139:** Gemini deve reportar WHAT/WHY/PROPOSAL/GUARANTEE. Sem notas subjetivas.
- **Navy card ΣN = hero S139:** Lucas: "a melhor parte eh o box com o sigma e o N". Tudo deriva dele.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- KBP-07 anti-workaround, KBP-08 anti-substituicao, KBP-09 anti-routing, KBP-10 anti-destructive.
- MCP gate + Research gate: hooks force "ask" antes de MCP/research calls.
- MCP freeze ate 2026-04-14. PubMed session expirou S129.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever h2 sem instrucao EXPLICITA e inequivoca.
- Gemini FPs conhecidos: css_cascade e failsafes flagam `[data-qa]` como bug (e design).

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S139 2026-04-10
