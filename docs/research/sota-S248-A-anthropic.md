# SOTA-A: Anthropic Agent Creation Evidence (S248, 2026-04-25)

> **Pesquisador:** Claude Code Guide agent (Haiku) com WebFetch + WebSearch.
> **Session:** S248 — 2026-04-25.
> **Evidence requirement:** CLAUDE.md §ENFORCEMENT #6 + KBP-36. URLs verificadas pelo agent; KBP-32 spot-check executado via Grep em `.claude/agents/*.md`.

## Sources cited (URL + data acesso/publicação)

| # | URL | Data |
|---|-----|------|
| S1 | https://code.claude.com/docs/en/sub-agents | acessado 2026-04-25 |
| S2 | https://platform.claude.com/docs/en/managed-agents/agent-setup.md | acessado 2026-04-25 |
| S3 | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices.md | acessado 2026-04-25 |
| S4 | https://www.anthropic.com/research/building-effective-agents | pub. 2024-12-19 |
| S5 | https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents | pub. 2025-11-26 |
| S6 | https://platform.claude.com/docs/en/about-claude/models/overview.md | acessado 2026-04-25 |
| S7 | https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills | acessado 2026-04-25 |
| S8 | https://platform.claude.com/llms.txt (docs map) | acessado 2026-04-25 |

Total: 8 URLs verificadas. Nenhuma fabricada.

---

## Anthropic agent creation principles 2026

### Princípio 1 — Simplicity first (S4, 2024-12-19)

> "Find the simplest solution possible, and only increase complexity when needed."

Anthropic explicitamente recomenda começar com single LLM calls antes de considerar agents. Agents só quando: (a) steps não podem ser pré-determinados, (b) LLM decision-making é necessário em escala, (c) tarefa é genuinamente open-ended.

### Princípio 2 — Context preservation via isolation (S1, 2026-04-25)

Subagents existem primariamente para **preservar context window** do main thread. A Anthropic descreve o caso de uso primário como: "use one when a side task would flood your main conversation with search results, logs, or file contents you won't reference again."

### Princípio 3 — Description drives delegation (S1, S3)

Claude usa o campo `description` como sinal primário para decidir quando delegar. A description deve conter:
- O que o agent faz (terceira pessoa)
- Quando usar (triggers explícitos)
- Termos-chave que aparecem nas tarefas

### Princípio 4 — Harness determines outcome (S5, 2025-11-26)

> "The harness determines the outcome, not just a smarter model."

Cada componente do harness (hooks, tools, permissionMode) codifica uma assunção sobre o que o modelo não consegue fazer sozinho. Quando modelos melhoram, essas assunções devem ser re-testadas.

### Princípio 5 — Progressive disclosure (S3, S7)

Skill/agent content deve adotar "progressive disclosure": apenas metadata (name + description) é pre-loaded. O corpo completo é lido on-demand. Reference files são lidas apenas quando necessárias. Isso mantém custo de contexto baixo.

### Princípio 6 — Single agent vs multi-agent (S5)

Anthropic nota que é "ainda uma questão aberta de research" se single general-purpose agent performa melhor ou multi-agent. Recomendação conservadora: começar single, especializar apenas quando uso real demonstra gap.

---

## Frontmatter schema — Claude Code subagents (S1, 2026-04-25)

Campos suportados em `.claude/agents/*.md`. Apenas `name` e `description` são required.

| Campo | Required | Tipo/Opções | Notas |
|-------|----------|-------------|-------|
| `name` | Sim | string, lowercase + hyphens | Unique identifier; sem espaços |
| `description` | Sim | string, max ~1024 chars | Signal primário para delegação; terceira pessoa |
| `model` | Não | `sonnet`, `opus`, `haiku`, full ID (ex: `claude-opus-4-7`), `inherit` | Default: `inherit` |
| `tools` | Não | lista de tool names | Allowlist; se omitido herda todos |
| `disallowedTools` | Não | lista de tool names | Denylist; removido do pool herdado |
| `permissionMode` | Não | `default`, `acceptEdits`, `auto`, `dontAsk`, `bypassPermissions`, `plan` | Herda do parent; alguns não podem ser overridden |
| `maxTurns` | Não | integer | Limite de turns agenticos antes de parar |
| `skills` | Não | lista de skill names | Injeta conteúdo completo no contexto; não herda do parent |
| `mcpServers` | Não | lista (inline ou referência por nome) | Inline: scoped ao subagent; referência: reutiliza conexão do parent |
| `hooks` | Não | objeto de lifecycle hooks | Scoped ao subagent |
| `memory` | Não | `user`, `project`, `local` | Persistent memory directory cross-session |
| `background` | Não | boolean | `true` = sempre roda como background task |
| `effort` | Não | `low`, `medium`, `high`, `xhigh`, `max` | Override do session effort level |
| `isolation` | Não | `worktree` | Roda em git worktree temporário isolado; cleanup automático se sem mudanças |
| `color` | Não | `red`, `blue`, `green`, `yellow`, `purple`, `orange`, `pink`, `cyan` | Display color no UI |
| `initialPrompt` | Não | string | Auto-submitted como primeiro user turn quando agent roda como main session (via `--agent`) |

**Resolução de model (ordem de precedência):**
1. `CLAUDE_CODE_SUBAGENT_MODEL` env var
2. Per-invocation `model` parameter (quando Claude invoca)
3. `model` frontmatter
4. Main conversation model

**Plugin subagents:** campos `hooks`, `mcpServers`, `permissionMode` são ignorados em plugin agents por segurança (S1).

---

## Managed Agents API schema (S2, 2026-04-25)

Campos para agents via API (diferente de Claude Code subagents):

| Campo | Required | Descrição |
|-------|----------|-----------|
| `name` | Sim | Human-readable name |
| `model` | Sim | Claude model ID. All Claude 4.5+ supported |
| `system` | Não | System prompt (persona e behavior) |
| `tools` | Não | Pre-built agent tools, MCP tools, custom tools |
| `mcp_servers` | Não | MCP servers para capabilities externas |
| `skills` | Não | Domain-specific context com progressive disclosure |
| `callable_agents` | Não | Outros agents que este pode invocar (research preview) |
| `description` | Não | O que o agent faz |
| `metadata` | Não | Key-value pairs arbitrários |

Header obrigatório: `anthropic-beta: managed-agents-2026-04-01`

Modelos suportados: claude-4.5 e posteriores. Alias de velocidade: `{"id": "claude-opus-4-6", "speed": "fast"}` para fast mode.

---

## Tool permission patterns (S1, 2026-04-25)

### allowlist (`tools` field)
```yaml
tools: Read, Grep, Glob, Bash
```
Apenas essas tools ficam disponíveis. Qualquer outra (incluindo MCPs) bloqueada.

### denylist (`disallowedTools` field)
```yaml
disallowedTools: Write, Edit
```
Herda tudo do parent exceto os listados. Mais permissivo que allowlist.

### Interação quando ambos definidos:
`disallowedTools` é aplicado primeiro, depois `tools` resolve contra o pool restante. Tool em ambos = removida.

### Agent tool scoping (para main-thread agents):
```yaml
tools: Agent(worker, researcher), Read, Bash
```
Restringe quais subagents podem ser spawned (allowlist). `Agent` sem parênteses = pode spawnar qualquer um. Sem `Agent` = não pode spawnar nenhum.

**Nota crítica:** Subagents NÃO podem spawnar outros subagents. `Agent(type)` só tem efeito em agents rodando como main thread via `claude --agent`.

### permissionMode por caso de uso:
| Mode | Quando usar |
|------|-------------|
| `default` | Padrão; prompts normais |
| `acceptEdits` | Agent faz file edits em paths conhecidos sem prompt |
| `auto` | Background classifier revisa; equilibrio segurança/velocidade |
| `dontAsk` | Auto-deny prompts (allowed tools ainda funcionam) |
| `bypassPermissions` | Skip total; usar com extrema cautela |
| `plan` | Read-only exploration |

**Warning oficial:** `bypassPermissions` skipa prompts exceto para `.git`, `.claude`, `.vscode`, `.idea`, `.husky` (com exceções em `.claude/commands`, `.claude/agents`, `.claude/skills`).

**Inheritance rule:** Se parent usa `bypassPermissions` ou `acceptEdits`, toma precedência e não pode ser overridden pelo subagent.

---

## Model selection guidance (S6, 2026-04-25)

| Modelo | ID API | Contexto | Latência | Preço Input/Output | Uso recomendado |
|--------|--------|----------|----------|--------------------|-----------------|
| Claude Opus 4.7 | `claude-opus-4-7` | 1M tokens | Moderada | $5/$25 MTok | Tarefas complexas, agentic coding; step-change sobre Opus 4.6 |
| Claude Sonnet 4.6 | `claude-sonnet-4-6` | 1M tokens | Rápida | $3/$15 MTok | Balanced speed+intelligence; default para maioria |
| Claude Haiku 4.5 | `claude-haiku-4-5` | 200k tokens | Mais rápida | $1/$5 MTok | Read-only, exploração, cost-sensitive |

**Guidance de Anthropic por tier de task (S3):**
- Haiku: tasks que requerem mais orientação (skill precisa de mais detalhe)
- Sonnet: tasks com instrução clara e eficiente
- Opus: tasks complexas; tende a over-explain se skill for muito verbosa

**Built-in subagent defaults (S1):**
- Explore agent: **Haiku** (fast, low-latency, read-only)
- Plan agent: herda do main
- General-purpose: herda do main
- statusline-setup: Sonnet
- Claude Code Guide: Haiku

**Nota:** Sonnet 4 e Opus 4 (versão 4.0) são deprecated, retirement 2026-06-15. Migrar para Sonnet 4.6 e Opus 4.7.

---

## Anti-patterns documentados (S1, S3, S4, S5)

### AP-01 — Framework opacity (S4)
> "Frameworks hiding underlying prompts/responses obscure debugging. Starting with complex frameworks instead of direct API calls."

Anthropic recomenda começar com chamadas diretas; adicionar abstração só quando value é demonstrado.

### AP-02 — Complexidade prematura (S4)
Adicionar multi-agent quando single LLM call resolve. Regra: só escalar complexidade quando demonstradamente necessário.

### AP-03 — One-shotting projetos inteiros (S5)
Tentar completar projeto longo em single session. Solução: feature list JSON + incremental progress por session.

### AP-04 — description vaga (S3)
```yaml
# Evitar:
description: Helps with documents
description: Processes data

# Preferir:
description: Extracts text and tables from PDF files, fills forms, and merges documents.
  Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

### AP-05 — Nested references em skills (S3)
SKILL.md → advanced.md → details.md = Claude lê parcialmente com `head -100`. Manter references um nível de profundidade.

### AP-06 — Declarar vitória prematuramente (S5)
Agent "declara" task completa sem verificação real. Solução: feature tracking JSON com status explícito.

### AP-07 — Multiple choices sem default (S3)
```yaml
# Evitar: "Use pypdf, ou pdfplumber, ou PyMuPDF..."
# Preferir: "Use pdfplumber. Para PDFs escaneados, use pdf2image."
```

### AP-08 — Paths Windows-style em skills/agents (S3)
Sempre forward slashes, mesmo no Windows. Backslashes causam erros em Unix.

### AP-09 — bypassPermissions sem necessidade real (S1)
Anthropic avisa explicitamente: usar com cautela. Ainda bloqueia writes em dirs protegidos.

### AP-10 — Subagent sem description acionável (S1)
Claude usa description para decidir delegação. Description ruim = delegação incorreta.

---

## OLMO matriz por dimensão (KBP-32 spot-check concluído pelo agent)

Nota: spot-check via Grep em `.claude/agents/*.md` confirmou todos os "AUSENTE" abaixo (per agent claim).

| Dimensão | Anthropic recommends | OLMO state | Decision |
|----------|---------------------|------------|----------|
| `name` + `description` | Required; description em terceira pessoa, acionável, com triggers | Presente em todos os 10 agents | ALREADY |
| `model` field | Especificar explicitamente; Haiku p/ read-only, Sonnet p/ balanced | Presente em 3/10 (reference-checker=haiku, evidence-researcher=sonnet, systematic-debugger=inherit pattern); 7/10 sem model explícito (herda do main = `claude-sonnet-4-6`) | EVAL: considerar adicionar `model: haiku` em agents read-only (researcher, sentinel, repo-janitor) |
| `effort` | Overrides session-level; não documentado como obrigatório | `effort: max` em todos os 10 agents | ALREADY (mas considerar se read-only agents realmente precisam de max) |
| `maxTurns` | Limite de segurança; recomendado para agents que podem loop | Presente em todos os 10 (10-35 range) | ALREADY |
| `color` | Valores válidos: red, blue, green, yellow, purple, orange, pink, cyan | `reference-checker.md` usa `color: magenta` — **INVALIDO** per spec | FIX: trocar `magenta` por `purple` ou `pink` |
| `memory` | `project` = default recomendado para agents com domain knowledge | Presente em 5/10 (evidence-researcher, qa-engineer, reference-checker, systematic-debugger, sentinel) | ALREADY para agents com estado; EVAL para researcher (ausente) |
| `isolation` | `worktree` para agents que precisam de repo isolado sem afetar main | Ausente em todos os 10 | EVAL: considerar em agents que fazem writes destrutivos |
| `background` | `true` para agents que sempre rodam async | Ausente em todos os 10 | EVAL: considerar para sentinel e integrity checks |
| `disallowedTools` | Denylist para agents que herdam mas devem ser restritos | Presente em 7/10 (sempre bloqueia Write, Edit, Agent) | ALREADY |
| `permissionMode` | Explícito quando comportamento diferente de default | Ausente em todos os 10 | EVAL: considerar `plan` para agents read-only ao invés de disallowedTools manual |
| `skills` preload | Injetar skills no contexto do subagent explicitamente | Ausente em todos os 10 | EVAL: qa-engineer poderia preload qa-pipeline skill |
| `hooks` scoped | Hooks específicos do subagent para validação de operações | Ausente em todos os 10 | EVAL: db-reader pattern (validate antes de Bash) aplicável a systematic-debugger |
| `mcpServers` format | Lista com dashes; inline = scoped; string = referência ao parent | evidence-researcher usa lista correta; reference-checker usa dict sem dashes | FIX: reference-checker mcpServers format incorreto (dict vs lista) |
| description triggers | Incluir "Use when..." com contexto explícito | Variável; alguns têm triggers (evidence-researcher, systematic-debugger), outros vagos | EVAL: audit descriptions para adicionar trigger phrases |
| `initialPrompt` | Quando agent roda como main thread; processa commands e skills | Ausente em todos os 10 | IGNORE: não relevante para pattern atual (todos como subagents) |

---

## Open questions / gaps documentados

1. **Effort levels por model:** A documentação lista `low`, `medium`, `high`, `xhigh`, `max` mas não especifica quais níveis estão disponíveis por model. "available levels depend on the model" (S1) — sem tabela explícita.

2. **Single vs multi-agent performance:** Anthropic explicitamente declara como "open research question" (S5). Sem guideline definitiva.

3. **mcpServers inline vs referência — scoping exato:** Documentado que inline = scoped ao subagent; referência = reutiliza conexão. Comportamento quando MCP server está no parent mas não no subagent: tools aparecem no subagent? Não documentado explicitamente.

4. **Subagent não herda skills do parent:** Documentado em S1 — deve listar explicitamente em `skills:`. Mas não documentado como isso interage com `disable-model-invocation: true` em skills.

5. **`magenta` como color value:** OLMO usa, não está na lista oficial. Comportamento (silencioso fallback vs erro) não documentado.

6. **`dontAsk` vs `bypassPermissions`:** Diferença sutil — `dontAsk` auto-nega mas allowed tools ainda funcionam; `bypassPermissions` pula o mecanismo. Casos edge não documentados.

7. **Managed Agents vs Claude Code subagents:** Dois sistemas paralelos — API/SDK (Managed Agents) vs file-based (Claude Code). Interoperabilidade não documentada. OLMO usa file-based; Managed Agents requer `managed-agents-2026-04-01` beta header.

---

## Resumo executivo

**Findings principais:**
1. Frontmatter tem 16 campos, apenas `name`+`description` obrigatórios.
2. **`color: magenta` em `reference-checker.md` é valor inválido** per spec (deve ser `purple` ou `pink`).
3. **`mcpServers` em `reference-checker.md` usa formato dict** ao invés de lista.
4. **7/10 agents OLMO não declaram `model` explícito** (herdam `claude-sonnet-4-6`).
5. `permissionMode` nunca usado — OLMO usa `disallowedTools` como alternativa, ambos válidos.
6. `isolation: worktree` disponível mas não utilizado.
7. Anthropic classifica single vs multi-agent como "open research question" (2025-11-26).
8. description deve ser em terceira pessoa com trigger phrases "Use when...".

**Ações prioritárias OLMO (FIX imediato):**
- `color: magenta` → `color: purple` em `reference-checker.md`
- `mcpServers` format em `reference-checker.md` (dict → lista)

**Ações EVAL (próxima sessão):**
- Adicionar `model: haiku` em agents read-only (researcher, sentinel, repo-janitor)
- `permissionMode: plan` como alternativa mais limpa ao `disallowedTools: Write, Edit, Agent`

**Caveat:** verification das URLs é claim do agent SOTA-A (que tinha WebFetch). Re-verification não executada por mim. KBP-32 spot-check executado pelo agent via Grep — taxa erro AUSENTE histórica ~33%.
