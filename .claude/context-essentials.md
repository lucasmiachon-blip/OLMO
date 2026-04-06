# Context Essentials (pos-compaction survival kit)

> Reinjectado automaticamente por hooks/session-compact.sh apos compaction.
> Editar aqui, NAO no hook. Max 30 linhas de regras.

## ENFORCEMENT (5 regras mais violadas — /insights S82, 58 sessoes)

1. NAO avance sem autorizacao do Lucas. Proponha, espere OK, execute.
2. Use scripts existentes (qa-batch-screenshot.mjs, npm run build:{aula}). NAO reinvente.
3. Build ANTES de QA: npm run build:{aula} → qa-batch-screenshot.mjs.
4. QA visual = EU (Opus, multimodal). NAO delegar ao Gemini.
5. Plan mode quando pedido. NAO pule direto para execucao.

## SCOPE DISCIPLINE (24 eventos de scope creep)

- 1 slide por vez. 1 gate por invocacao. Max 2 agentes simultaneos.
- Momentum brake: apos cada acao, PARAR e reportar. Proximo passo = Lucas decide.
- Criterios QA: ler do script, NUNCA inventar.

## KEY DECISIONS

- Living HTML per slide = source of truth. evidence-db.md deprecated.
- index.html e gerado — rodar build-html.ps1 apos editar _manifest.js.
- NUNCA `taskkill //IM node.exe` — matar por PID especifico.
