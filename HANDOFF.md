# HANDOFF - Proxima Sessao

> Sessao 109 | 2026-04-08
> Foco: Dream v2 + Skills Audit

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise — s-checkpoint-1 arquivado).
**Agentes: 8** (todos com maxTurns). **Hooks: 29 registrations** (31 scripts; 2 pre-commit). **Rules: 10**. MCPs: 11. **KBPs: 7 (next: KBP-08).**
**INFRA COMPLETA.** Batches 6+7 CLOSED.
**Memory: 20/20 (AT CAP).**

**Dream skill v2:** 5 melhorias aplicadas (evergreen types, audit trail, repetition detector, confidence-weighted merge, TTL auto-downgrade). Commitado em `~/.claude/skills/dream/`.

**Skills audit S109:** Pesquisa completa de skills externas. Plano em `.claude/plans/fizzy-snuggling-feather.md`. Candidatas priorizadas: Context7, Karpathy Wiki, Superpowers (parcial), Agent Teams nativo.

## PROXIMOS PASSOS (S110+)

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | **Avaliar Context7** | Docs de libs em tempo real. Instalar como MCP ou skill. Free tier 1k req/mes | Normal |
| 2 | **Avaliar Karpathy Wiki** | Knowledge base persistente. Complementa ou substitui memory? | Normal |
| 3 | **Testar /dream dry-run** | Validar as 5 melhorias v2 com dados reais | Facil |
| 4 | **Aprofundar narrativa s-importancia** | Sintese cruzada superficial. Profundidade comparavel a s-pico | Normal |
| 5 | Decidir h2 do slide s-importancia | Lucas decide assertion. Speaker notes dependem do h2 | Lucas |
| 6 | Verificar 2 PMIDs CANDIDATE | Kastrati & Ioannidis 2024 (39240561), Murad 2014 (25005654) | Facil |
| 7 | Memory review | Cap 20/20. Due desde S105. Dream v2 pode ajudar com auto-downgrade | Facil |
| 8 | Diagnostico S109 (pendente) | Hooks produtividade, antifragile, reprodutibilidade, crossref-check | Normal |

## AGENTES

| Agente | Model | maxTurns | Memory | Status |
|--------|-------|----------|--------|--------|
| evidence-researcher | sonnet | 20 | project | OK |
| qa-engineer | sonnet | 12 | project | OK |
| mbe-evaluator | sonnet | 15 | — | OK (FROZEN ate aula completa) |
| reference-checker | haiku | 15 | project | OK |
| quality-gate | haiku | 10 | — | OK |
| researcher | haiku | 15 | — | OK |
| repo-janitor | haiku | 12 | — | OK |
| notion-ops | haiku | 10 | — | P1: adicionar write tools + gates |

## DECISOES ATIVAS

- **s-checkpoint-1:** Arquivado S107. HTML preservado. Volta futura.
- **s-importancia:** Slide novo F1 apos s-hook. Living HTML com secoes completas mas narrativa rasa. h2 = Lucas.
- **build-html.ps1 regex fix:** Aplicado nas 3 aulas.
- **/research v2.0:** 6 pernas. content-research.mjs arquivado.
- **QA pipeline S103:** Path linear 11 steps. **Step 0 pre-read gate adicionado S108.**
- **css_cascade #deck:** Deferido.
- **KBP-07:** Anti-workaround gate.
- **Values: Antifragile + Curiosidade** — decision gates.
- **Living HTML per slide = source of truth = SINTESE CURADA (nao template).**
- Memory governance: cap 20 files (20 atual — AT CAP). Review due S110.
- **/insights:** ran S108. Next: S115.
- **Dream v2:** 5 melhorias. Testar dry-run S110. Nao pushado upstream (fork local).

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build apos editar _manifest.js.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar. (S107: 40% erro Gemini, 6/15 corrigidos NLM.)
- **Scripts canonicos + prompts:** protegidos por guard-product-files.sh (ask). NUNCA editar sem aprovacao.
- **npm scripts:** Rodar de `content/aulas/`, NAO da raiz do monorepo.
- **Agent delegation:** NUNCA fire-and-forget. Verificar tipo do agente, output capturavel, aprovacao do Lucas.
- **Anti-workaround (KBP-07):** Quando algo falha: diagnosticar causa raiz, reportar, listar opcoes, PARAR.
- **content-research.mjs ARQUIVADO:** Usar /research skill. Nao referenciar o .mjs.
- **Living HTML = sintese curada da pesquisa, NAO template mecanico.** Cada secao deve refletir achados reais.

## DIAGNOSTICO S109 (pendente — nao executado)

- **Hooks self-improvement/produtividade:** nao estao funcionando. Investigar.
- **Antifragile:** nao esta funcionando. Investigar.
- **Reprodutibilidade:** ainda fraca. Investigar.
- **crossref-check hook:** bloqueia evidence HTML sem slide correspondente (caso legitimo: evidence antes de slide). Ajustar logica.
- **s-importancia.html:** NAO COMMITADO (blocked by crossref). Arquivo local OK.
- **Metodo:** diagnostico proprio + adversarial Codex em batches.
- **Status:** Sessao S109 usada para skills audit + dream v2. Diagnostico deferido para S110.

## CONFLITOS

(nenhum ativo)

## SKILLS AUDIT (referencia para S110+)

Plano completo: `.claude/plans/fizzy-snuggling-feather.md`
Repos confirmados: obra/superpowers, upstash/context7, Shmayro/singularity-claude, nextlevelbuilder/ui-ux-pro-max-skill, hesreallyhim/awesome-claude-code, rohitg00/awesome-claude-code-toolkit, piercelamb/deep-plan, affaan-m/everything-claude-code, AgriciDaniel/skill-forge
Prioridade: Context7 > Karpathy Wiki > Agent Teams nativo > Superpowers (parcial)
NAO instalar: everything-claude-code (bloat), singularity-claude (conflita com governance)

---
Coautoria: Lucas + Opus 4.6 | S109 2026-04-08
