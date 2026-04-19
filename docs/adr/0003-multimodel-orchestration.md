# ADR-0003: Multimodel Orchestration

- **Status:** accepted
- **Data:** 2026-04-19
- **Deciders:** Lucas + Claude (Opus 4.7)
- **Sessão:** S232-readiness-multimodel-agents-memory

## Contexto

OLMO usa múltiplos AI execution tools (Claude Code, Codex, Gemini, Ollama) mas invocation gates são informais. HANDOFF S231 residual: "Batch 5 multimodel integration gate — Codex/Gemini/Antigravity formalization" — deferred em S230 pendente "topologia limpa" (cumprida).

**Sintoma recorrente:** feature-shopping sem use case concreto (S230 §Batch 5 Antigravity recomendação). Padrão "setup pendente" (CHANGELOG entry antigo: Gemini+Antigravity intensificação) vira dívida sem enforcement.

**Distinção importante:**
- **Intra-Claude routing** (trivial→Ollama, simple→Haiku, medium→Sonnet, complex→Opus) = diretiva humana em `CLAUDE.md`, preservada.
- **Cross-model** (Claude Code ↔ Codex ↔ Gemini ↔ outro) = escopo deste ADR.

## Decisão

Cada AI execution tool que queira entrar no pipeline OLMO deve passar pelo **Framework de 5 critérios S230**:

| critério | requisito |
|---|---|
| **objetivo** | 1 frase declarativa: "o modelo X resolve Y que Claude Code não resolve bem" |
| **trigger** | condição objetiva/automática — NÃO "quando parecer útil" |
| **artefato** | arquivo concreto produzido (markdown, JSON, diff) com path canônico |
| **custo** | $/invocation ou token budget cap |
| **risco** | blast radius — read-only? editing? shared state? |

### Matriz aplicada (AI execution tier)

| Tool | Objetivo | Trigger | Artefato | Custo | Risco | Status |
|------|----------|---------|----------|-------|-------|--------|
| **Claude Code** (Opus/Sonnet/Haiku) | Default orchestrator + execução | session work | commits, edits, plans | Max subscription (incluso) | HIGH — shared state, writes | **ACTIVE** |
| **Codex** (GPT-5.4) | 2nd opinion / rescue de root-cause diagnosis | `/codex:rescue` skill OR stuck >3 attempts mesmo erro OR review gate pre-large-merge | investigation report em `.claude/plans/` | ChatGPT Plus (incluso) | MEDIUM — read-only review | **ACTIVE** (plugin integrado) |
| **Gemini** | Research conversacional + QA visual multimodal | MCP call explícita OR `npm run qa` | findings, QA screenshots, `gemini-qa3.mjs` output | OAuth $0 + API key (QA scripts apenas) | LOW — read-only | **ACTIVE** (passes gate) |
| **Ollama** | Trivial tasks routing ($0 tier) | task marked `trivial` (regex, cache lookup, simple classification) | local responses | $0 local | LOW — no cloud | **OPT-IN** (não cabling atual) |
| **Antigravity** | (candidato) artifacts + async multi-superfície | **REACTIVATION:** 3+ artifacts grandes/semana exigindo sandboxing ou reprodutibilidade multi-modal | — | unknown | HIGH se adoção prematura | **DEFERRED** (S230 rec preservada) |
| **ChatGPT** ("VALIDAR" em CLAUDE.md) | — | — | — | — | — | **DEFLATE** (redundante com Codex que tem plugin real) |

### Invocation gates (when to call which)

1. **Default = Claude Code** per complexity (intra-routing CLAUDE.md).
2. **Codex rescue** quando: (a) `/codex:rescue` invocado; (b) stuck >3 attempts mesmo erro; (c) review gate pre-merge ≥100 li.
3. **Gemini** quando: (a) MCP call explícita; (b) QA pipeline (`npm run qa`); (c) research conversacional exigindo >2M context window.
4. **Ollama** quando: task explicitamente marked trivial (raro em OLMO consumer-only atual).
5. **Antigravity**: NÃO. Reactivate apenas se trigger §Matriz disparar.
6. **ChatGPT**: remover slot "VALIDAR" de `CLAUDE.md §Tool Assignment` OU substituir por `Codex=VALIDAR`.

## Consequências

### Positivas

- Invocation gate explícito elimina "quando parecer útil" → decisão reproduzível.
- Framework S230 vira lens canônico para futuras propostas (ADR-0004+).
- Antigravity preservado como candidato com trigger concreto, não esquecido nem força-adotado.
- ChatGPT deflation reduz cognitive load + elimina aspiracional sem consumer.

### Negativas

- Manutenção: matriz precisa re-evaluation quando tools mudam (ByteRover CLI maturou de 22→4.6k stars entre S224 e S232 — 2 dias).
- Enforcement não é mecânico — depende de disciplina humana + pattern "propose/OK/execute".

## Alternativas consideradas

1. **Hook automático de routing cross-model** — rejeitado: S230 deletou ModelRouter Python justamente por ser teatro (escrito mas não lido). Preservar diretiva humana é mais honesto.
2. **"All-in on Claude Code only"** — rejeitado: Codex rescue + Gemini QA já provaram valor; monocultura AI perde triangulation adversarial.
3. **Adotar todos os tools candidatos (Antigravity incluso)** — rejeitado: sem use case concreto, setup cost > benefit (S230 auditoria).

## Reality check tools (S232 Task 1.2, 2026-04-19)

Verificação 2 dias pós-S224 research:

| Tool | S224 snapshot | 2026-04-19 | Shift |
|------|---------------|------------|-------|
| ByteRover CLI | watch, unclear maturity, Elastic 2.0 | 4.6k stars, v3.7.0 Apr 18 | matured — REC-1 viable for memory layer (separate ADR se adotado) |
| MemSearch (Zilliz) | new, gap=maturity | 1.3k stars, v0.3.1 Apr 16, MIT, Claude Code client support | confirmed usable |
| Smart Connections | 786k downloads, MCP claimed | 4.9k stars, v4.3.0 Apr 1, MCP status ambíguo | stable, MCP ambiguous |
| kuzu-memory | 22 stars | 22 stars, v1.12.9 Apr 9 | unchanged — abaixo threshold S224 |

Nota: memory layer tools não entram neste ADR (escopo = AI execution). Serão objeto de ADR-0004 se Lucas optar por adoção.

## Ref cruzada

- `.claude/plans/archive/S230-bubbly-forging-cat.md` §Batch 5 (framework origin, Antigravity rec)
- `CLAUDE.md` §Tool Assignment (tabela a ser deflated — ChatGPT slot)
- `docs/ARCHITECTURE.md` §Model Routing (linkar este ADR)
- `docs/adr/0002-external-inbox-integration.md` (template format)

## Enforcement

- **Matriz §Decisão** é SSoT para invocation gates. Novos tools: propor via framework S230 antes de integration.
- Reactivation trigger de tools DEFERRED (Antigravity) deve ser ativado via BACKLOG entry explícito com evidência.
- Anti-drift §Propose-before-pour aplica: adicionar tool = "operação substantiva" → OK explícito Lucas antes.

Pattern canônico futuro: se tool passa framework 5-crit + tem consumer real, entra em matriz via PR atualizando este ADR.
