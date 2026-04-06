# Anti-Drift, Anti-Rework & Cross-Reference Tools — April 2026

> Pesquisa: Lucas + Opus 4.6 | S83 | 2026-04-05
> Objetivo: eliminar retrabalho, drift, cross-ref failures no ecossistema OLMO

---

## 1. Problem Analysis

Mapeando os 4 pain points do Lucas para failure modes documentados na literatura:

### 1.1 Rework (agente refaz trabalho ja feito)

**Failure mode**: Session amnesia. Cada sessao comeca do zero. O agente nao sabe o que ja foi decidido, construido ou descartado. Pos-compaction, ate regras comportamentais sao esquecidas.

**Root cause**: Claude Code depende de conversation history para estado. Compaction (automatica a ~95% do contexto) faz summarization lossy — preserva codigo mas perde regras, convencoes e decisoes. Estudo documentado: "project-context.md rules followed perfectly before compaction, violated 100% after" ([Golev, 2026](https://golev.com/post/claude-saves-tokens-forgets-everything/)).

**O que Lucas ja tem**: `session-compact.sh` reinjecta 5 regras + HANDOFF.md. `session-start.sh` carrega HANDOFF no inicio. Isso e bom, mas insuficiente — as regras reinjectadas sao genericas, nao incluem estado especifico da tarefa em andamento.

### 1.2 Cross-reference failures (edita um arquivo, esquece os relacionados)

**Failure mode**: Partial propagation. Mudanca em slide HTML sem atualizar manifest, narrative, evidence, ou vice-versa. O agente nao tem um grafo de dependencias — cada arquivo e tratado isoladamente.

**Root cause**: LLMs operam arquivo-por-arquivo. Nao existe mecanismo nativo de "se mudou X, deve mudar Y". O CUIDADOS no HANDOFF.md diz "Editar slide = AMBOS arquivos" mas isso e advisory (o modelo pode ignorar).

**Falta**: enforcing deterministico de co-changes. O ecossistema nao tem nenhuma ferramenta que BLOQUEIE commit quando co-changes obrigatorios estao faltando.

### 1.3 Drift (desvio gradual do plano)

**Failure mode**: Scope creep silencioso. O agente resolve o problema pedido, depois "melhora" codigo adjacente, ou muda abordagem sem avisar, ou age sem permissao.

**Root cause**: LLMs otimizam para helpfulness. "Melhorar" codigo vizinho parece helpfulness. Sem constraints deterministicos, regras advisory sao seguidas ~80-90% do tempo.

**O que Lucas ja tem**: anti-drift.md com momentum brake, scope discipline, verification gate. guard-pause.sh bloqueia edits em modo pausa. Boa base, mas tudo advisory exceto guard-pause.

### 1.4 Lost direction (pos-compaction ou pos-context overflow)

**Failure mode**: Amnesia completa. Apos compaction, o agente perde track do working directory, dos arquivos em uso, das decisoes tomadas, e ate do objetivo da sessao.

**Root cause**: Compaction preserva um summary da conversa, mas descarta detalhes de baixa frequencia — e regras/convencoes sao exatamente low-frequency, early-session content que e descartado primeiro.

**O que Lucas ja tem**: SessionStart(compact) reinjecta HANDOFF. Mas nao reinjecta: estado da tarefa corrente, quais arquivos estao em edicao, qual plano esta sendo seguido.

---

## 2. Tools & Frameworks

### 2.1 Cross-File Enforcement

| Tool | O que faz | Claude Code compat | Custo | Esforco |
|------|-----------|-------------------|-------|---------|
| **[ifttt-lint](https://github.com/simonepri/ifttt-lint)** | Directives `LINT.IfChange`/`LINT.ThenChange` em comentarios. Se mudou regiao X, pre-commit bloqueia se Y nao mudou. | Sim (pre-commit hook) | $0 (Rust, open source) | Baixo: adicionar comentarios nos arquivos, configurar pre-commit |
| **Custom PreToolUse hook** | Script bash que verifica co-changes antes de commit | Nativo | $0 | Medio: escrever script de validacao |
| **Agent Stop hook** | Subagente verifica cross-refs antes de finalizar | Nativo (type: agent) | Custo de tokens do subagente | Medio: escrever prompt de verificacao |

**ifttt-lint e a recomendacao #1 para cross-ref**. E uma reimplementacao do linter interno do Google. Suporta 40+ linguagens. Syntax para HTML:

```html
<!-- LINT.IfChange(slide-forest-plot) -->
<section id="s-forest-plot" class="slide">...</section>
<!-- LINT.ThenChange(//content/aulas/metanalise/_manifest.js:forest-plot, //content/aulas/metanalise/evidence/forest-plot.html) -->
```

Em YAML:
```yaml
# LINT.IfChange(slide-list)
slides:
  - forest-plot
  - funnel-plot
# LINT.ThenChange(//content/aulas/metanalise/slides/index.html)
```

Em Python:
```python
# LINT.IfChange(slide-config)
SLIDE_ORDER = ["forest-plot", "funnel-plot"]
# LINT.ThenChange(//content/aulas/metanalise/_manifest.js:slide-list)
```

Instalacao: `pip install pre-commit` + `.pre-commit-config.yaml` com `ifttt-lint` e `ifttt-lint-diff`.

### 2.2 Memory & Context Persistence

| Tool | O que faz | Claude Code compat | Custo | Esforco |
|------|-----------|-------------------|-------|---------|
| **Claude Code Auto Memory** | Salva notas automaticas em `~/.claude/projects/` | Nativo (v2.1.59+) | $0 | Zero (ja ativo) |
| **Claude Code Session Memory** | Background system salva summaries estruturados | Nativo (v2.1.30+) | $0 | Zero (ja ativo) |
| **CLAUDE.md + rules/** | Instrucoes persistentes carregadas toda sessao | Nativo | $0 | Ja implementado no OLMO |
| **[claude-mem](https://github.com/thedotmack/claude-mem)** | Plugin MCP que captura tudo, comprime com AI, reinjecta em sessoes futuras. 21.5k stars. | MCP server | $0 (open source) | Medio: instalar MCP server |
| **[claude-code-context-handoff](https://github.com/who96/claude-code-context-handoff)** | Auto-gera handoff pre-compaction, restaura pos-compaction via hooks | Hooks nativos | $0 | Baixo: instalar hooks |
| **[post_compact_reminder](https://github.com/Dicklesworthstone/post_compact_reminder)** | Reinjecta lembrete de re-ler AGENTS.md apos compaction | Hook nativo | $0 | Minimo |
| **[Mem0](https://mem0.ai)** MCP | Memory-as-a-service. User/session/agent scopes. AWS Agent SDK partner. | MCP server | Free tier: 10k memories, 1k retrievals/mes | Medio |
| **[Letta](https://letta.com)** (ex-MemGPT) | OS-inspired tiered memory: working (RAM) + recall (disk). Agente gerencia propria memoria. | API/MCP | Self-hosted: $0. Cloud: pago. | Alto |
| **[Zep](https://getzep.com)** / Graphiti | Knowledge graph temporal. Entidades mudam ao longo do tempo. | API | Cloud: pago | Alto |

**Para Lucas**: Claude Code nativo (Auto Memory + Session Memory + CLAUDE.md) ja cobre 80% das necessidades. O gap principal e o **context-essentials.md** — um arquivo cirurgico de 10-50 linhas reinjectado pos-compaction, distinto do CLAUDE.md completo.

### 2.3 Anti-Drift & Guardrails

| Tool | O que faz | Claude Code compat | Custo | Esforco |
|------|-----------|-------------------|-------|---------|
| **Claude Code Hooks (command)** | Shell scripts deterministicos em lifecycle events | Nativo | $0 | Ja implementado |
| **Claude Code Hooks (prompt)** | Single-turn LLM evaluation (Haiku) | Nativo | ~$0.001/call | Baixo |
| **Claude Code Hooks (agent)** | Multi-turn subagente com tools (Read, Grep, Glob) | Nativo | ~$0.01-0.05/call | Medio |
| **Claude Code Plan Mode** | Shift+Tab x2 para planejar antes de executar | Nativo | $0 | Zero (ja disponivel) |
| **[rulebricks/claude-code-guardrails](https://github.com/rulebricks/claude-code-guardrails)** | Real-time guardrails para tool calls | MCP + hooks | $0 | Medio |
| **[dwarvesf/claude-guardrails](https://github.com/dwarvesf/claude-guardrails)** | Permission deny rules + shell hooks + prompt injection defense | Config files | $0 | Baixo |
| **NeMo Guardrails** | Colang-based dialogue flow control | Nao integra diretamente com Claude Code | $0 (open source) | Alto (overkill) |
| **Guardrails AI** | Pydantic-style LLM output validation | Python API | $0 (open source) | Alto (overkill) |

**Para Lucas**: hooks nativos (command + prompt + agent) cobrem tudo que NeMo/Guardrails AI fariam, com zero dependencia externa. O gap e usar os 3 tipos estrategicamente.

### 2.4 State-of-the-Art (Abril 2026)

| Feature | Status | Relevancia |
|---------|--------|------------|
| **1M context window** | GA para Opus 4.6 e Sonnet 4.6. Sem multiplicador de custo. | Alta: 5x menos compactions. 15% reducao medida em compaction events. |
| **PreCompact / PostCompact hooks** | Disponivel. matcher: manual/auto | Alta: ultimo momento para salvar estado antes de compaction |
| **Agent Teams** | Experimental (Feb 2026). Coordenacao multi-agente via shared task list. | Media: util para paralelismo, mas Lucas prefere controle (max 2 agentes). |
| **plansDirectory** | Disponivel. Planos podem ser salvos no projeto e versionados. | Alta: planos sobrevivem sessoes via git. |
| **`if` field em hooks** | v2.1.85+. Filtra hooks por tool name + arguments (permission rule syntax). | Alta: hooks mais cirurgicos. |
| **Session Memory** | v2.1.30+. Background system automatico. | Ja ativo. |
| **Worktree isolation** | `--worktree` flag ou `isolation: worktree` em agentes. | Media: util para agentes paralelos. |
| **A2A Protocol** (Google) | Linux Foundation AAIF. Interoperabilidade inter-agente. | Baixa (futuro, nao necessario agora). |

---

## 3. Patterns & Techniques (sem ferramentas novas)

### 3.1 Context-Essentials Pattern

**Problema**: CLAUDE.md e grande (~200 linhas no OLMO). Pos-compaction, precisa de reinjecao cirurgica, nao do manual inteiro.

**Solucao**: Criar `.claude/context-essentials.md` (max 50 linhas) com APENAS:
- Regras que previnem bugs (cross-ref obrigatorios, scripts canonicos)
- Anti-patterns proibidos (taskkill node, fabricar PMIDs)
- Estado da tarefa corrente (atualizado pelo agente)

Reinjectar via `SessionStart(compact)` hook. O OLMO ja faz isso parcialmente em `session-compact.sh`, mas pode ser melhorado com conteudo dinamico.

### 3.2 State Machine Workflow

**Problema**: agente perde track de onde esta no fluxo.

**Solucao** ([Nick Tune, 2026](https://medium.com/nick-tune-tech-strategy-blog/minimalist-claude-code-task-management-workflow-7b7bdcbc4cc1)): 3 arquivos persistentes:
1. `tasks.md` — lista de tarefas com status
2. `requirements.md` — descricao detalhada + criterios de verificacao
3. `session.md` — updates curtos do agente sobre tarefa corrente

Claude inicia cada mensagem declarando seu estado corrente (`CHECK_STATUS`, `WORKING`, `AWAITING_COMMIT`). O state machine previne drift porque cada transicao e explicita.

**Adaptacao OLMO**: HANDOFF.md ja faz parte disso. Adicionar `session.md` (estado micro, atualizado pelo agente) e formalizar transicoes.

### 3.3 Per-Step Constraint Design

**Problema**: regras uniformes causam over-constraint em tarefas exploratoras e under-constraint em tarefas criticas.

**Solucao** ([Akari Iku, 2026](https://dev.to/akari_iku/how-to-stop-claude-code-skills-from-drifting-with-per-step-constraint-design-2ogd)): 4 tipos de constraint por step:
- **Procedural** (HOW): sequencia fixa. Ex: build → lint → test → commit.
- **Criteria** (WHAT): metricas. Ex: "ROI em base TCO 3 anos, eixos tempo/custo/erro".
- **Template**: formato fixo, conteudo livre. Ex: PR template, HANDOFF format.
- **Guardrail**: proibicoes. Ex: "NUNCA apresentar numeros nao-verificados sem marcar como estimativa".

**Adaptacao OLMO**: os skills e agentes podem declarar tipo de constraint por step no frontmatter.

### 3.4 80/20 Context Budget Rule

**Principio**: nunca usar os ultimos 20% do context window para tarefas complexas multi-arquivo. Reservar para edits leves.

**Implementacao**: monitorar tokens via statusline (OLMO ja tem). Quando atingir 80%, manual `/compact` ANTES que o auto-compact degrade a qualidade.

### 3.5 PreCompact Checkpoint Pattern

**Problema**: auto-compact dispara quando ja e tarde — modelo opera degradado.

**Solucao**: `PreCompact` hook grava snapshot do estado corrente em arquivo. Inclui: arquivos modificados, tarefa em andamento, decisoes tomadas, proximos passos. `PostCompact` ou `SessionStart(compact)` reinjecta esse snapshot.

### 3.6 Saved Plans in Version Control

**Problema**: planos feitos em Plan Mode morrem com a sessao.

**Solucao**: configurar `plansDirectory` para `.claude/plans/` dentro do projeto. Planos ficam versionados no git. Sessao nova pode `--resume` com plano salvo.

```json
// em .claude/settings.json ou settings.local.json
{
  "plansDirectory": ".claude/plans"
}
```

### 3.7 Propagation Checklist em CLAUDE.md

**Problema**: cross-refs sao advisory. Agente esquece.

**Solucao parcial** (sem tooling): adicionar secao explicita no CLAUDE.md com mapa de propagacao:

```markdown
## Propagation Map (OBRIGATORIO)
Quando editar qualquer item da coluna A, DEVE editar B tambem:
| Se mudar...                 | Deve atualizar...                            |
|-----------------------------|----------------------------------------------|
| slides/{id}.html            | _manifest.js + index.html (run build)        |
| evidence/{id}.html          | slide correspondente (citation block)         |
| _manifest.js                | index.html (run build-html.ps1)              |
| .claude/agents/*.md         | HANDOFF.md tabela de agentes                 |
| ecosystem.yaml              | docs/ARCHITECTURE.md agent table             |
```

Isso ja e mais do que o CUIDADOS atual oferece — e um mapa explicitamente estruturado.

---

## 4. Quick Wins (implementavel HOJE com features existentes)

### QW-1: Criar `.claude/context-essentials.md` (10 min)

Extrair do HANDOFF.md e anti-drift.md as 20-30 linhas mais criticas. Atualizar `session-compact.sh` para `cat` este arquivo em vez de hardcoded rules.

```bash
# session-compact.sh (proposta)
cat "$PROJECT_ROOT/.claude/context-essentials.md" 2>/dev/null
echo ""
echo "=== HANDOFF.md ==="
cat "$PROJECT_ROOT/HANDOFF.md" 2>/dev/null
```

### QW-2: Propagation Map no CLAUDE.md (10 min)

Adicionar a tabela de propagacao obrigatoria da secao 3.7 ao CLAUDE.md principal. Custo zero, melhora imediata na consciencia de cross-refs.

### QW-3: PreCompact hook para checkpoint (20 min)

Adicionar hook que grava estado antes de compaction:

```json
{
  "hooks": {
    "PreCompact": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash /c/Dev/Projetos/OLMO/hooks/pre-compact-checkpoint.sh",
            "timeout": 5000
          }
        ]
      }
    ]
  }
}
```

O script grava `date`, `git status --short`, `git diff --name-only`, e os ultimos 5 commits em `.claude/last-checkpoint.md`. O `session-compact.sh` existente pode entao `cat` este checkpoint junto com as regras.

### QW-4: `plansDirectory` no settings (2 min)

```json
{
  "plansDirectory": ".claude/plans"
}
```

Planos passam a ser versionados e reutilizaveis entre sessoes.

### QW-5: Stop hook tipo `prompt` para cross-ref check (15 min)

Adicionar um Stop hook que usa Haiku para verificar se mudancas pendentes tem cross-refs faltando:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check git diff for this session. If any file in content/aulas/*/slides/ was modified, verify that the corresponding _manifest.js and evidence/ files were also considered. If cross-references are missing, respond with {\"ok\": false, \"reason\": \"...\"}. If everything is consistent, respond with {\"ok\": true}."
          }
        ]
      }
    ]
  }
}
```

Custo: ~$0.001 por invocacao (Haiku). Beneficio: catch deterministico de cross-ref failures.

### QW-6: PostCompact hook para re-injectar checkpoint (5 min)

```json
{
  "hooks": {
    "PostCompact": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "cat /c/Dev/Projetos/OLMO/.claude/last-checkpoint.md 2>/dev/null || echo '(no checkpoint)'"
          }
        ]
      }
    ]
  }
}
```

---

## 5. Strategic Recommendations (medio prazo)

### SR-1: ifttt-lint para cross-ref enforcement (1-2 horas)

Instalar `ifttt-lint` via pre-commit. Adicionar `LINT.IfChange`/`LINT.ThenChange` nos arquivos criticos do sistema de aulas. Isso transforma cross-ref de advisory para deterministico — commit e bloqueado se propagacao nao foi feita.

**Prioridade**: ALTA. Resolve o pain point #2 (cross-reference failures) de forma definitiva.

**Risco**: baixo. Os directives sao comentarios — nao mudam comportamento do codigo. Podem ser adicionados incrementalmente.

### SR-2: Agent-type Stop hook para QA abrangente (2-3 horas)

Substituir o Stop hook tipo `prompt` (QW-5) por tipo `agent` que pode realmente ler arquivos e verificar consistencia:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "agent",
            "prompt": "Verify cross-file consistency: 1) Check git diff for modified files, 2) For each modified slide, verify _manifest.js lists it, 3) For each modified evidence file, verify the slide references it, 4) Check HANDOFF.md reflects current state. Return {ok: true} or {ok: false, reason: '...'}.",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

**Custo**: ~$0.01-0.05 por invocacao (subagente Haiku com tools). Vale o investimento dado o volume de rework que previne.

### SR-3: State machine com session.md (1 hora)

Formalizar o workflow do agente com estado persistente. Criar `.claude/session.md` atualizado pelo agente a cada acao. Formato:

```markdown
# Session State
Task: [descricao]
Status: WORKING | AWAITING_REVIEW | BLOCKED
Modified: [lista de arquivos]
Pending cross-refs: [lista]
Last action: [timestamp] [acao]
Next step: [proxima acao planejada]
```

Agente atualiza este arquivo como parte do workflow. PreCompact/PostCompact usam para recovery.

### SR-4: claude-mem MCP para memoria de longo prazo (2-3 horas)

Para sessoes que se acumulam em semanas/meses, o Auto Memory nativo pode nao ser suficiente. `claude-mem` (21.5k stars, ativo) captura tudo automaticamente e reinjecta contexto relevante. Util quando o HANDOFF.md sozinho nao captura toda a historia.

**Avaliar quando**: se apos implementar QW-1 a QW-6, o rework continuar significativo.

### SR-5: Per-step constraints nos skills/agents (1-2 horas)

Revisar cada agente em `.claude/agents/` e classificar cada step como Procedural, Criteria, Template, ou Guardrail. Adicionar constraint type explicito no frontmatter ou no corpo do agente.

---

## 6. Top 5 Actions (ordenado por impacto no problema rework/drift/cross-ref)

| # | Acao | Resolve | Esforco | Impacto |
|---|------|---------|---------|---------|
| **1** | **QW-1 + QW-3 + QW-6: Context-essentials + PreCompact checkpoint + PostCompact recovery** | Rework, Lost direction | 35 min | ALTO. Elimina o principal vetor de amnesia: compaction sem checkpoint. O OLMO ja tem metade disso; falta a outra metade. |
| **2** | **QW-2: Propagation Map no CLAUDE.md** | Cross-ref failures | 10 min | ALTO. Zero custo, melhora imediata. Transforma "CUIDADOS" generico em mapa estruturado. |
| **3** | **SR-1: ifttt-lint para cross-ref enforcement** | Cross-ref failures | 1-2h | MUITO ALTO. Unica solucao que e *deterministico* — bloqueia commit se cross-ref nao foi feito. Resolve pain point #2 definitivamente. |
| **4** | **QW-5: Stop hook prompt para cross-ref check** | Cross-ref failures, Drift | 15 min | MEDIO-ALTO. Catch probabilistico (Haiku pode errar), mas custo minimo e feedback imediato. |
| **5** | **QW-4: plansDirectory** | Lost direction, Rework | 2 min | MEDIO. Planos sobrevivem sessoes. Sem ele, cada sessao recria o plano do zero. |

### Sequencia recomendada de implementacao

```
Dia 1 (< 1 hora):
  QW-1 → QW-2 → QW-4 → QW-3 → QW-6

Dia 2 (1-2 horas):
  QW-5 → SR-1 (ifttt-lint)

Semana seguinte (se necessario):
  SR-2 → SR-3 → SR-5

Avaliar depois de 5 sessoes:
  SR-4 (claude-mem) so se rework persistir
```

---

## Sources

### Claude Code Official
- [Claude Code Hooks Guide](https://code.claude.com/docs/en/hooks-guide)
- [Hooks Reference](https://code.claude.com/docs/en/hooks)
- [Memory & CLAUDE.md](https://code.claude.com/docs/en/memory)
- [Common Workflows](https://code.claude.com/docs/en/common-workflows)
- [How Claude Code Works](https://code.claude.com/docs/en/how-claude-code-works)
- [Best Practices](https://code.claude.com/docs/en/best-practices)
- [1M Context GA](https://claude.com/blog/1m-context-ga)
- [Changelog](https://code.claude.com/docs/en/changelog)

### Context & Compaction
- [Post-Compaction Hooks for Context Renewal](https://medium.com/@porter.nicholas/claude-code-post-compaction-hooks-for-context-renewal-7b616dcaa204) — Nick Porter, Mar 2026
- [Claude Saves Tokens, Forgets Everything](https://golev.com/post/claude-saves-tokens-forgets-everything/) — Alexander Golev
- [Context Management Guide](https://claudefa.st/blog/guide/mechanics/context-management)
- [Context Compaction Research](https://gist.github.com/badlogic/cd2ef65b0697c4dbe2d13fbecb0a0a5f)
- [post_compact_reminder](https://github.com/Dicklesworthstone/post_compact_reminder)
- [claude-code-context-handoff](https://github.com/who96/claude-code-context-handoff)

### Cross-File Enforcement
- [ifttt-lint](https://github.com/simonepri/ifttt-lint) — LINT.IfChange/ThenChange directives, 40+ languages
- [Production Quality Gates](https://dev.to/edwardkubiak/how-i-built-production-quality-gates-into-a-multi-agent-claude-code-workflow-4i55) — Edward Kubiak

### Anti-Drift & Guardrails
- [Per-Step Constraint Design](https://dev.to/akari_iku/how-to-stop-claude-code-skills-from-drifting-with-per-step-constraint-design-2ogd) — Akari Iku
- [rulebricks/claude-code-guardrails](https://github.com/rulebricks/claude-code-guardrails)
- [dwarvesf/claude-guardrails](https://github.com/dwarvesf/claude-guardrails)
- [CLAUDE.md Examples & Best Practices](https://www.morphllm.com/claude-md-examples)

### Task Management & Workflows
- [Minimalist Task Management Workflow](https://medium.com/nick-tune-tech-strategy-blog/minimalist-claude-code-task-management-workflow-7b7bdcbc4cc1) — Nick Tune
- [Plan Mode Guide](https://codewithmukesh.com/blog/plan-mode-claude-code/)
- [Agent Teams Guide](https://www.morphllm.com/claude-code-agent-teams)
- [Worktree Guide](https://claudefa.st/blog/guide/development/worktree-guide)

### Memory Frameworks
- [claude-mem](https://github.com/thedotmack/claude-mem) — 21.5k stars, auto-capture + reinject
- [Mem0 + Claude Code](https://mem0.ai/blog/claude-code-memory)
- [Agent Memory Frameworks 2026](https://dev.to/nebulagg/top-6-ai-agent-memory-frameworks-for-devs-2026-1fef)
- [Mem0 vs Letta Comparison](https://vectorize.io/articles/mem0-vs-letta)

### Competitive Landscape
- [Best AI Coding Agents 2026](https://codegen.com/blog/best-ai-coding-agents/)
- [Codex CLI Features](https://developers.openai.com/codex/cli/features)
- [Cursor Agent Best Practices](https://cursor.com/blog/agent-best-practices)
- [Aider CONVENTIONS.md Guide](https://www.claudemdeditor.com/aider-conventions-guide)

### Protocols
- [MCP vs A2A Protocols 2026](https://dev.to/pockit_tools/mcp-vs-a2a-the-complete-guide-to-ai-agent-protocols-in-2026-30li)
- [AI Agent Protocol Ecosystem Map](https://www.digitalapplied.com/blog/ai-agent-protocol-ecosystem-map-2026-mcp-a2a-acp-ucp)
