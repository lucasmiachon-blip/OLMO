# Skill: Self-Evolving (Auto-Evolucao)

Auto-evolucao iterativa do ecossistema. Analisa, identifica melhorias,
implementa e valida — ciclo PDCA para skills, rules e configs.
Inspirada em miles990/self-evolving-agent + adaptacoes do ecossistema.

## Quando Ativar
- `/evolve` ou "evoluir", "melhorar skills", "auto-evolucao"
- `/insights` semanal (previsto no CLAUDE.md)
- Apos detectar padroes repetitivos que poderiam virar skill/rule

## Processo PDCA (Plan-Do-Check-Act)

### 1. PLAN — Diagnostico
Analisar estado atual do ecossistema:
- Ler todas as skills em `.claude/skills/`
- Ler todas as rules em `.claude/rules/`
- Ler `CLAUDE.md`, `HANDOFF.md`, `CHANGELOG.md`
- Ler memory em `~/.claude/projects/.../memory/`
- Identificar:
  - Skills desatualizadas ou incompletas
  - Rules conflitantes ou redundantes
  - Gaps (necessidades recorrentes sem skill)
  - Padroes de feedback do usuario (memory tipo feedback)
  - Oportunidades de automacao

### 2. DO — Propor Melhorias
Para cada melhoria identificada, gerar proposta:
```
[MELHORIA] titulo
- Tipo: skill | rule | config | memory
- Impacto: alto | medio | baixo
- Esforco: trivial | simples | complexo
- Descricao: [1-2 linhas]
- Acao: [o que mudar concretamente]
```

Priorizar por: impacto alto + esforco baixo primeiro.

### 3. CHECK — Validar com Usuario
- Apresentar lista priorizada de melhorias
- Usuario aprova, rejeita ou modifica cada uma
- Somente implementar as aprovadas

### 4. ACT — Implementar
- Executar mudancas aprovadas
- Para cada mudanca: verificar resultado
- Atualizar CLAUDE.md se skills/rules mudaram
- Commit com coautoria

## Checkpoints Obrigatorios

- **CP0**: Anchor — qual e o objetivo da evolucao?
- **CP1**: Memory check — ja tentamos isso antes? Deu certo?
- **CP2**: Verificacao pos-mudanca — nada quebrou?
- **CP3**: Confirmacao de milestone — usuario valida direcao

## Ciclos Recomendados

| Frequencia | Escopo | Profundidade |
|------------|--------|-------------|
| Semanal | Skills + rules | Rapido (gaps obvios) |
| Mensal | Ecossistema completo | Profundo (PDCA completo) |
| Por demanda | Especifico | Focado (1 area) |

## Metricas de Saude

Avaliar e reportar:
- Skills: total, usadas vs orfas, linhas medias
- Rules: total, conflitos detectados, cobertura
- Memory: total, tipos, desatualizadas
- Config: modelos em uso, custo estimado, rate limits
- HANDOFF: items pendentes, idade media

## Formato de Output

```
## Evolucao Report — [DATA]

### Diagnostico
- Skills: N (N ativas, N orfas)
- Rules: N (N conflitos)
- Gaps identificados: [lista]

### Melhorias Propostas
1. [ALTA] [titulo] — [descricao]
2. [MEDIA] [titulo] — [descricao]
...

### Implementadas
- [x] [melhoria 1]
- [x] [melhoria 2]

### Metricas Pos-Evolucao
[comparativo antes/depois]

Coautoria: Lucas + opus | [DATA]
```

## Anti-patterns
- Evoluir sem diagnostico (mudar por mudar)
- Criar skill para uso unico
- Ignorar feedback do usuario em memory
- Over-engineering (adicionar complexidade sem valor)

## Eficiencia
- Modelo recomendado: Sonnet (analise) + Opus (decisoes complexas)
- Registrar custo no BudgetTracker
