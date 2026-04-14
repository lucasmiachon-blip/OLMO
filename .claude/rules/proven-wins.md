# Proven Wins — Audit First, Then Protect

> "Funciona" nao e evidencia de qualidade. Muito foi construido sem loops de auditoria.
> Somente padroes VALIDADOS ganham protecao. O resto precisa de escrutinio.

## Maturity tiers

| Tier | Criterio | Acao correta |
|------|----------|--------------|
| **Unaudited** | Existe, parece funcionar, nunca foi revisado | Auditar antes de confiar ou replicar |
| **Audited** | Revisado criticamente (redundancia, formato, edge cases) | Corrigir achados, promover a Tested |
| **Tested** | Passou teste real (execucao, build, cenarios) | Monitorar 3+ sessoes |
| **Proven** | Sobreviveu 5+ sessoes sem issues, validado por Lucas | APLICAR e PROTEGER — nao melhorar |

## Gate (antes de tocar infra existente)

1. **Qual o tier?** Unaudited → auditar primeiro, nao assumir que funciona bem.
2. **Foi pedido?** Melhoria nao-solicitada em Proven = drift. Em Unaudited = valido.
3. **Ha padrao Proven para isso?** Sim → replicar. Nao → propor e esperar OK.

## O que isso previne

- Confiar cegamente em codigo que "nao deu erro" (survivorship bias)
- Replicar padroes nao-auditados (espalhar divida tecnica)
- Melhorar Proven sem necessidade (risco > ganho)
- Ignorar que "funciona mal" e invisivel sem auditoria

## Audit loop obrigatorio

Antes de declarar qualquer componente como Proven:
1. Review critico: redundancia, formato, profissionalismo, edge cases
2. Teste real: execucao com inputs reais, nao so syntax check
3. Cross-ref: referencias existem, paths corretos, sem orfaos
4. Lucas valida: tier Proven requer OK explicito

## Quando melhoria E valida

- Componente Unaudited ou Audited (precisa de melhoria por definicao)
- Lucas pede explicitamente
- Algo quebra (teste falha, hook erro, build break)
- Plano de consolidacao aprovado (ex: Hooks Fase 2)

Mesmo assim: propor primeiro, executar depois de OK.
