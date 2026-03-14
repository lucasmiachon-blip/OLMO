# Skill: Skill Creator

Meta-skill para criar, testar e refinar novas skills do Claude Code.
Baseada na skill oficial Anthropic + adaptacoes do ecossistema.

## Quando Ativar
- Usuario quer criar nova skill
- Usuario quer melhorar skill existente
- `/skill-creator` ou "criar skill", "nova skill"

## Processo Interativo (5 Passos)

### 1. Capturar Intencao
Perguntar ao usuario:
- **O que** a skill deve fazer? (1-2 frases)
- **Quando** deve ativar? (triggers, contextos)
- **Qual modelo** deve rodar? (Opus/Sonnet/Haiku/local)
- **Depende** de algum MCP ou ferramenta externa?
- **Exemplo** de input → output esperado?

### 2. Gerar Draft
Criar `instructions.md` seguindo o padrao do ecossistema:

```markdown
# Skill: [Nome]

[Descricao em 1-2 linhas]

## Quando Ativar
- [triggers concretos]

## Processo
### 1. [Passo]
- [instrucoes claras]

## Formato de Output
[template do output esperado]

## Eficiencia
- Modelo recomendado: [modelo]
- Registrar custo no BudgetTracker
```

### 3. Testar com Prompts Reais
- Gerar 3-5 test cases representativos
- Rodar cada um e avaliar output
- Documentar resultado: PASS / PARTIAL / FAIL

### 4. Iterar
- Refinar instrucoes baseado nos testes
- Ajustar triggers, formato, restricoes
- Re-testar ate atingir >= 80% PASS

### 5. Instalar e Registrar
- Salvar em `.claude/skills/[nome-da-skill]/instructions.md`
- Atualizar `CLAUDE.md` (secao Skills)
- Commit com coautoria

## Regras

- Skills devem ser **enxutas** (< 200 linhas idealmente)
- Sem duplicacao — verificar se ja existe skill similar
- Progressive disclosure: metadata leve, corpo sob demanda
- Seguir convencoes do ecossistema (type hints, YAML config, coautoria)
- Nunca incluir credenciais ou tokens na skill

## Template Rapido

Para skills simples, usuario pode dizer:
```
Cria skill [nome] que [faz X] quando [trigger Y] usando [modelo Z]
```
E o skill-creator gera automaticamente o draft.

## Anti-patterns
- Skill generica demais (faz tudo = faz nada)
- Skill que duplica funcionalidade de outra
- Instrucoes vagas ("faca algo bom")
- Dependencia de MCP sem documentar
