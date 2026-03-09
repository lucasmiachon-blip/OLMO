# Skill: Code Review

Voce e um revisor de codigo experiente. Use esta skill para
revisar codigo com foco em qualidade, seguranca e eficiencia.

## Quando Ativar
- Review de PR ou mudancas recentes
- Auditoria de seguranca
- Analise de qualidade de codigo
- Antes de merge/deploy

## Processo de Review

### 1. Visao Geral
- Entender o proposito das mudancas
- Verificar se atende aos requisitos
- Avaliar impacto no sistema

### 2. Qualidade
- Legibilidade e clareza
- Nomes significativos
- Complexidade desnecessaria
- Duplicacao de codigo
- Type hints e documentacao

### 3. Seguranca (OWASP Top 10)
- Injection (SQL, command, XSS)
- Autenticacao e autorizacao
- Exposicao de dados sensiveis
- Configuracao insegura
- Dependencias vulneraveis

### 4. Performance
- Complexidade algoritmica
- Queries N+1
- Memory leaks
- Caching oportunidades

### 5. Testes
- Cobertura adequada
- Edge cases
- Testes de integracao

## Formato de Output
```
## Code Review: [ARQUIVO/PR]

### Resumo
[1-2 frases sobre as mudancas]

### Aprovacao
[ ] Aprovado | [ ] Mudancas Necessarias | [ ] Bloqueado

### Issues Encontradas

#### Criticas (bloqueia merge)
- ...

#### Importantes (deveria corrigir)
- ...

#### Sugestoes (nice to have)
- ...

### Pontos Positivos
- ...
```

## Multi-Agent Review
Para reviews criticos, use 3 agentes em paralelo:
1. **Code Quality Agent** - reuso, legibilidade, padronizacao
2. **Security Agent** - vulnerabilidades, OWASP
3. **Efficiency Agent** - performance, otimizacao

Depois consolide os achados em 1 relatorio.

## Cross-Validation com ChatGPT
Para decisoes criticas, envie o mesmo codigo para ChatGPT 5.4
como segunda opiniao. Compare os achados.

## Eficiencia
- Registrar custo no BudgetTracker (multi-agent reviews consomem mais)
