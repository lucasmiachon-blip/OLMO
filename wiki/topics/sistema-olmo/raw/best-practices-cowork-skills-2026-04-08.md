# Best Practices — Cowork, CLAUDE.md & Skills (Abril 2026)

**Pesquisa**: Anthropic docs oficiais + GitHub repos de maior visibilidade
**Data**: 2026-04-08
**Objetivo**: Alimentar OLMO_COWORK com padrões profissionais validados
**Coautoria**: Lucas + Opus 4.6 (Cowork)

---

## 1. Anthropic Official — Skill Authoring Best Practices

Fonte: `platform.claude.com/docs/claude-code/skills`

### 1.1 Anatomia de uma Skill

```
my-skill/
├── SKILL.md          ← Ponto de entrada (obrigatório)
├── resources/        ← Arquivos de referência (opcional)
│   ├── template.html
│   └── style-guide.md
└── examples/         ← Exemplos (opcional)
```

- **SKILL.md** é o único arquivo lido automaticamente ao triggerar
- Recursos adicionais são carregados sob demanda (progressive disclosure)

### 1.2 Progressive Disclosure (3 níveis)

| Nível | O que | Quando |
|-------|-------|--------|
| **L1 — Metadata** | `name`, `description` no frontmatter | Sempre visível (matching/trigger) |
| **L2 — SKILL.md** | Instruções completas | Ao triggerar a skill |
| **L3 — Resources** | Templates, exemplos, guias | Sob demanda via `Read` dentro da skill |

**Regra**: SKILL.md deve ser **< 500 linhas**. Se maior, mover conteúdo para `resources/`.

### 1.3 Otimização da Description (campo mais importante para trigger)

- **Terceira pessoa**: "Creates professional Word documents" (não "I create...")
- **Termos específicos**: incluir extensões (.docx, .pdf), nomes de ferramentas, sinônimos
- **Máximo 1024 caracteres**
- **MANDATORY TRIGGERS**: listar palavras-chave que DEVEM ativar a skill
- **Formato recomendado**:
  ```
  **[Título]**: [Descrição funcional com keywords]
    - MANDATORY TRIGGERS: keyword1, keyword2, .ext, tool-name
  ```

### 1.4 Naming Conventions

- **Nome da skill**: `kebab-case` (ex: `cowork-research`, `slide-authoring`)
- **Forma gerúndio** para ações: "Creating presentations", "Extracting data"
- **Prefixo de domínio** quando útil: `cowork-*`, `medical-*`

### 1.5 Referências e Dependências

- **Um nível de profundidade** — SKILL.md pode referenciar arquivos em `resources/`, mas esses arquivos NÃO devem referenciar outros
- **Nunca nested references** — evita loops e context overflow
- **MCP tools**: referenciar como `ServerName:tool_name` (ex: `PubMed:search_articles`)

### 1.6 Padrões de Workflow dentro de Skills

**Checklist pattern** (para processos sequenciais):
```markdown
## Steps
1. [ ] Verificar pré-requisitos
2. [ ] Executar busca
3. [ ] Processar resultados
4. [ ] Validar output
5. [ ] Entregar
```

**Decision tree pattern** (para lógica condicional):
```markdown
## Quando usar
- Se [condição A] → [ação A]
- Se [condição B] → [ação B]
- Default → [ação padrão]
```

**Feedback loop pattern** (para iteração):
```markdown
## Refinamento
1. Gerar primeira versão
2. Avaliar contra critérios
3. Se não atende → ajustar e voltar a 1
4. Se atende → entregar
```

### 1.7 Anti-patterns de Skills (evitar)

| Anti-pattern | Problema | Solução |
|---|---|---|
| SKILL.md monolítico (>500 linhas) | Context overflow, lentidão | Progressive disclosure com resources/ |
| Description vaga ("handles documents") | Trigger falha | Keywords específicas + MANDATORY TRIGGERS |
| Nested references (A→B→C) | Loops, overhead | Máximo 1 nível de profundidade |
| Hardcoded paths | Portabilidade zero | Variáveis ou paths relativos |
| Sem exemplos de output | Claude improvisa | Incluir template do output esperado |
| Skill faz tudo | Difícil manter | Uma skill = uma responsabilidade |

### 1.8 Evaluation-Driven Development

Anthropic recomenda testar skills com **evals** antes de considerar prontas:

1. Criar 3-5 prompts de teste que devem triggerar a skill
2. Criar 2-3 prompts que NÃO devem triggerar (falsos positivos)
3. Verificar: a skill produz output esperado em cada caso?
4. Iterar description e instruções até convergir

---

## 2. Claude Code — CLAUDE.md Best Practices

Fonte: `code.claude.com/docs/claude-code/best-practices`

### 2.1 Design do CLAUDE.md

- **Conciso**: incluir apenas o que se aplica broadly ao projeto
- **Tabela include/exclude**: documentar o que pertence ao CLAUDE.md vs skills
- **Podar regularmente**: remover instruções obsoletas
- **Enforcement anchors**: regras críticas no início E no final (primacy + recency bias)

```markdown
# Exemplo de separação
## No CLAUDE.md (broadly applicable)
- Idioma: português brasileiro
- Convenção de commits
- Paths canônicos

## Em skills (domain-specific)
- Pipeline de pesquisa clínica (→ cowork-research)
- Extração de plataformas médicas (→ cowork-extract)
```

### 2.2 Verification Patterns

- **Sempre verificar** antes de declarar tarefa completa
- Padrões: rodar testes, checar build, ler diff, screenshot
- Para tarefas high-stakes: usar subagent para verificação independente

### 2.3 Context Management

- `/clear` entre tarefas não-relacionadas para evitar context pollution
- Checkpoints antes de ações destrutivas
- Se contexto está ficando grande → summarize estado, salvar, limpar

### 2.4 Skills vs CLAUDE.md

| Aspecto | CLAUDE.md | Skills |
|---------|-----------|--------|
| Escopo | Projeto inteiro | Domínio específico |
| Tamanho | Curto, < 200 linhas ideal | Até 500 linhas |
| Trigger | Sempre carregado | Sob demanda |
| Conteúdo | Regras, paths, convenções | Workflows, templates, exemplos |
| Atualização | Raro | Frequente (iteração) |

### 2.5 Hooks para Ações Determinísticas

- Hooks = ações automáticas que rodam em triggers específicos (pre-commit, post-save, etc.)
- Usar para: linting, formatting, validação de schema, notificações
- NÃO usar para: decisões que requerem julgamento humano

### 2.6 Parallel Sessions

- Múltiplas instâncias podem rodar em paralelo
- Cada uma com contexto isolado
- Útil para: pesquisa + implementação simultâneas

---

## 3. GitHub Repos de Referência

### 3.1 Repos Oficiais e de Alta Visibilidade

| Repo | Autor | Conteúdo | Relevância para OLMO |
|------|-------|----------|----------------------|
| **anthropics/skills** | Anthropic (oficial) | Skills de referência oficiais | Padrão-ouro de estrutura |
| **everything-claude-code** | (community) | Guia completo Claude Code | Referência de workflows |
| **awesome-claude-skills** | travisvn | Curadoria de skills da comunidade | Inspiração de descriptions |
| **awesome-claude-code** | hesreallyhim | Curadoria de recursos Claude Code | Tips & tricks |
| **awesome-claude-code-toolkit** | (community) | 135 agents, 35 skills catalogados | Benchmark de escala |
| **claude-cowork-guide** | (community) | 43 workflows, 70 prompts para Cowork | Workflows prontos |
| **academic-research-skills** | (community) | Skills para pesquisa acadêmica | Comparar com cowork-research |

### 3.2 Padrões Observados nos Melhores Repos

1. **README.md com badges e TOC** — fácil navegação
2. **Cada skill em pasta própria** — isolamento claro
3. **Description otimizada** — keywords, extensões, MANDATORY TRIGGERS
4. **Exemplos de uso** — "diga X para triggerar"
5. **Changelog** — versionamento de skills
6. **Tests/evals** — validação automatizada

---

## 4. Aplicação ao OLMO_COWORK — Melhorias Concretas

### 4.1 Melhorias Imediatas (aplicar agora)

| Item | Estado Atual | Melhoria | Prioridade |
|------|-------------|----------|------------|
| Description do cowork-research | Longa, narrativa | Adicionar MANDATORY TRIGGERS, formato padrão | Alta |
| Description do cowork-extract | Longa, narrativa | Adicionar MANDATORY TRIGGERS, formato padrão | Alta |
| SKILL.md tamanhos | ~200 e ~150 linhas | OK (< 500), mas poderiam ter resources/ | Média |
| Progressive disclosure | Não usa resources/ | Criar resources/ com templates de output | Média |
| Evals | Nenhum | Criar 5 prompts de teste por skill | Média |

### 4.2 Melhorias Futuras (próximas sessões)

- **Versionamento de skills**: adicionar frontmatter `version: 1.0.0`
- **Changelog por skill**: o que mudou e por quê
- **Template de output** em `resources/`: exemplo concreto do Markdown gerado
- **Evaluation suite**: prompts que devem/não devem triggerar cada skill
- **Métricas**: tempo médio de execução, taxa de sucesso, feedback do Lucas

### 4.3 Checklist de Qualidade para Novas Skills

```markdown
## Checklist — Nova Skill OLMO_COWORK
- [ ] Nome em kebab-case
- [ ] Description < 1024 chars com MANDATORY TRIGGERS
- [ ] SKILL.md < 500 linhas
- [ ] Frontmatter: name, description
- [ ] Steps numerados com checkboxes
- [ ] Error handling documentado
- [ ] Template de output em resources/ (se > trivial)
- [ ] 3-5 prompts de teste (triggering)
- [ ] 2-3 prompts de falso positivo (não deve triggerar)
- [ ] Anti-patterns do KBP documentados
- [ ] Integração com ecossistema OLMO documentada
```

---

## 5. Referências

- Anthropic. "Skill Authoring Best Practices." platform.claude.com/docs/claude-code/skills. Acesso: 2026-04-08.
- Anthropic. "Claude Code Best Practices." code.claude.com/docs/claude-code/best-practices. Acesso: 2026-04-08.
- Anthropic. "Agent Skills Architecture." claude.com/blog/agent-skills. Acesso: 2026-04-08.
- GitHub: anthropics/skills, everything-claude-code, awesome-claude-skills (travisvn), awesome-claude-code (hesreallyhim), awesome-claude-code-toolkit, claude-cowork-guide, academic-research-skills.
