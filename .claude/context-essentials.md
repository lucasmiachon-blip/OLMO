# Context Essentials (pos-compaction survival kit)

> Reinjectado automaticamente por hooks/session-compact.sh apos compaction.
> Editar aqui, NAO no hook. Max 30 linhas de regras.

## ENFORCEMENT (5 regras mais violadas — /insights S82, 58 sessoes)

1. NAO avance sem autorizacao do Lucas. Proponha, espere OK, execute.
2. Use scripts existentes (gemini-qa3.mjs, npm run build:{aula}). NAO reinvente.
3. Build ANTES de QA: npm run build:{aula} → gemini-qa3.mjs (unico script QA).
4. QA: Preflight (dims objetivas $0) → Inspect (Gemini Flash) → Editorial (Gemini Pro). Tudo via gemini-qa3.mjs.
5. Plan mode quando pedido. NAO pule direto para execucao.
6. POS-COMPACTION: summary = contexto, NAO todo-list. Reportar estado, perguntar foco.

## SCOPE DISCIPLINE (24 eventos de scope creep)

- 1 slide por vez. 1 gate por invocacao. Max 2 agentes simultaneos.
- Momentum brake: apos cada acao, PARAR e reportar. Proximo passo = Lucas decide.
- Criterios QA: ler do script, NUNCA inventar.

## VALUES (decision gates — aplicar, nao citar)

**Antifragile:** esta decisao torna o sistema mais forte com falhas futuras?
- Se encontrou erro recorrente → criar rule/hook, nao so corrigir
- Se escolhendo entre warn e block → preferir block (se FP baixo)
- Se algo quebrou → append ao known-bad-patterns, nao so consertar

**Curiosidade:** esta interacao ensina algo?
- Explicar o PORQUE antes de executar. Insights durante, nao depois
- Conexoes reais (medicina ↔ engenharia ↔ filosofia). Nunca infantilizar
- Lucas aprende dev on the job — cada sessao deve deixa-lo mais capaz

## KEY DECISIONS

- Living HTML per slide = source of truth. evidence-db.md deprecated.
- index.html e gerado — rodar `npm run build:{aula}` apos editar _manifest.js.
- NUNCA `taskkill //IM node.exe` — matar por PID especifico.
- plansDirectory: `.claude/plans` — planos sobrevivem sessoes.
- Batches pequenos + ensinamento + commit granular. Lucas quer aprender.
- Roadmap proximo: `docs/research/implementation-plan-S82.md`
