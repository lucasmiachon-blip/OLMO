# S213: Hooks + Memoria — Estado da Arte (Abril 2026)

> Pesquisa completa. OLMO = projeto pessoal de medico aprendendo dev.
> Referencia = melhores devs e criadores do Claude Code.
> Objetivo: identificar gaps reais com honestidade, sem inflar o OLMO.

---

## 1. Paradigmas de Configuracao de Hooks

### 1.1 Os 4 paradigmas que existem

| Paradigma | Como funciona | Quem usa | Pros | Contras |
|-----------|---------------|----------|------|---------|
| **JSON nativo** | `settings.local.json` com command/prompt/agent/http | Todos (obrigatorio) | Zero deps, oficial | Strings longas ilegíveis, sem multi-line, sem template |
| **Bash scripts** | `.sh` referenciados no JSON | OLMO, Trail of Bits, maioria | Flexivel, unix pipes | Nao cross-platform (Windows!), jq para JSON parse |
| **Python/UV** | `.py` com UV single-file scripts | disler, pydevtools | Type-safe, json.loads nativo, testavel | Dep UV, overhead startup |
| **YAML declarativo** | Ferramentas que traduzem YAML → JSON | cchook (Go), claude-yaml-hooks (TS) | Legivel, multi-line, template engine | Dep externa, camada extra |

### 1.2 YAML tools detalhados

**cchook** (syou6162) — Go CLI
- Template engine com `{.field}` syntax + jq queries completas
- Conditional execution por file type, command, prompt
- Dry-run mode para testar antes de deploy
- Cache de jq queries compiladas (performance)
- Config: `~/.config/cchook/config.yaml`
- Companion: `ccstatusline` (YAML-based statusline)
- Limitacao: Go binary, precisa instalar

**claude-yaml-hooks** (professional-ALFIE) — TypeScript
- `hooks.yaml` global + por projeto
- Matchers: pipe `|` (OR), glob `*`, regex `/pattern/`
- Setup registra 17 eventos via `scripts/setup.ts` (dry-run disponivel)
- StatusLine como array de commands sequenciais
- Limitacao: Node/TS, precisa build step

### 1.3 Onde OLMO esta

OLMO usa **JSON nativo + Bash scripts**. Paradigma 1+2.

**Gaps reais vs profissionais:**
- **Cross-platform**: OLMO roda bash no Windows via Git Bash. Funciona, mas profissionais usam Node.js (`.mjs`) para hooks portaveis. A recomendacao oficial e: "all settings.json commands should use `node` (not cmd, powershell, bash)". OLMO ignora isso completamente.
- **YAML**: OLMO tem 29 scripts + JSON longo e dificil de manter. cchook ou claude-yaml-hooks reduziria a complexidade de configuracao. Mas: adiciona dependencia. Trade-off real.
- **Testabilidade**: Scripts bash do OLMO nao tem testes. Profissionais em Python/TS testam hooks com unit tests.
- **JSON parsing**: OLMO usa `cat >/dev/null` para drenar stdin. Profissionais parseiam o JSON de entrada para tomar decisoes contextuais.

---

## 2. Os 4 Tipos de Handler

### 2.1 Comparacao completa

| Tipo | O que faz | Quando usar | Custo | OLMO usa? |
|------|-----------|-------------|-------|-----------|
| **command** | Executa shell script. Recebe JSON no stdin. Retorna via exit code + stdout JSON. | Checks deterministicos (format, lint, git state) | $0, ~100ms | ✅ 29 scripts |
| **prompt** | Envia prompt + $ARGUMENTS para LLM (fast model). Single-turn. | Avaliacao semantica simples (yes/no) | $0 no Max | ✅ 1 (Stop anti-racionalizacao, S213) |
| **agent** | Spawna subagent com acesso a Read/Grep/Glob. Multi-turn (ate 50 tool uses). | Verificacao profunda contra codebase real | $0 no Max, ~10-60s | ❌ NAO USA |
| **http** | POST JSON para URL externa. | Dashboard, audit trail, Notion, webhooks | Variavel | ❌ NAO USA |

### 2.2 Agent hooks — o que OLMO esta perdendo

Agent hooks sao o handler mais poderoso e OLMO nao usa nenhum. Exemplos reais:

```json
{
  "type": "agent",
  "prompt": "Verify that all unit tests pass before allowing Claude to stop. Run the test suite and check results.",
  "timeout": 120
}
```

```json
{
  "type": "agent",
  "prompt": "Verify all test files have corresponding implementation files. Read the project structure and check.",
  "timeout": 60
}
```

**Por que importa para OLMO:** O prompt hook anti-racionalizacao que implementei hoje faz uma avaliacao single-turn sem acesso a arquivos. Um agent hook poderia LER o HANDOFF.md, ver o git diff, verificar se o CHANGELOG foi atualizado — tudo programaticamente. Mais fiel que um prompt cego.

**Response format (agent/prompt):** `{ok: true}` para permitir, `{ok: false, reason: "..."}` para bloquear.

### 2.3 ⚠️ BUG PROVAVEL no hook que implementei hoje

A pesquisa revelou que prompt/agent hooks usam formato `{ok: true/false}`, NAO `{decision: "block"}`. O formato `decision` e para command hooks (exit 0 + JSON stdout).

No prompt hook Stop[0] que implementei, instrui o Haiku a responder com `{decision: "block"}`. Isso pode nao funcionar. **Precisa testar e possivelmente corrigir para `{ok: false, reason: "..."}`.**

---

## 3. Eventos — Gap Analysis Honesta

### 3.1 Os 21 eventos reais (nao 27)

| Categoria | Eventos | OLMO cobre? |
|-----------|---------|-------------|
| Session | SessionStart, SessionEnd | ✅ Start, ❌ End |
| Turn | UserPromptSubmit, Stop, StopFailure | ✅ UPS, ✅ Stop, ❌ StopFail |
| Tool | PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest, PermissionDenied | ✅ Pre, ✅ Post, ❌ Fail, ❌ PermReq, ❌ PermDen |
| Agent | SubagentStart, SubagentStop, TeammateIdle | ❌❌❌ |
| Tasks | TaskCreated, TaskCompleted | ❌❌ |
| Files | FileChanged, CwdChanged | ❌❌ |
| Config | InstructionsLoaded, ConfigChange, PreCompact, PostCompact | ❌❌ ✅ Pre, ✅ Post |
| MCP | Elicitation, ElicitationResult | ❌❌ |
| Notification | Notification | ✅ |
| Worktree | WorktreeCreate, WorktreeRemove | ❌❌ |

**Score: 8/21 (38%)**

### 3.2 Gaps por prioridade (para OLMO especificamente)

**Alta prioridade:**

| Evento | Por que | O que faria |
|--------|---------|-------------|
| **SessionEnd** | Stop fires por turn. SessionEnd fires UMA vez no exit real. `stop-should-dream.sh` esta no lugar errado. | Mover dream flag + metrics finais para SessionEnd |
| **PostToolUseFailure** | Falhas de tool sao silenciosas hoje. OLMO nao loga nem injeta guidance. | Script que loga em `.claude/tool-failures.log` + injeta systemMessage corretivo |
| **StopFailure** | Se o Stop hook falha, nao ha fallback. | Log + notify |

**Media prioridade:**

| Evento | Por que | O que faria |
|--------|---------|-------------|
| **SubagentStart** | Subagents nao recebem contexto do projeto (rules, conventions). Drift risk. | Inject context minimo |
| **SubagentStop** | Output de subagent nao e validado antes de aceitar. | Quality gate |
| **PermissionRequest** | Auto-approve patterns safe (read-only MCP, `npm run lint`). Reduz fricao. | Allowlist declarativa |

**Baixa prioridade (para OLMO):**

TaskCreated/Completed, TeammateIdle (Agent Teams), WorktreeCreate/Remove, CwdChanged, FileChanged, InstructionsLoaded, ConfigChange, Elicitation — irrelevantes ou ROI minimo para solo dev.

---

## 4. Feature Requests Relevantes

### 4.1 Sequential/Chainable hooks (issue #4446)

**Problema:** Todos os hooks num evento rodam em paralelo. Para pipeline sequencial (format → lint → test), precisa montar tudo num unico script monolitico.

**Proposta:** Nova chave `sequence` (ao lado de `hooks`) com steps sequenciais. stdout de step N → stdin de step N+1 (Unix pipe style).

**Status:** Feature request aberta. Nao implementada.

**Impacto OLMO:** `stop-quality.sh` e monolitico justamente por isso — nao da pra dividir em steps sequenciais. Se `sequence` existisse, cada check seria um script independente.

### 4.2 `--bare` flag

Pula hooks, LSP, plugin sync, skill walks. Util para `-p` scriptado. OLMO nao usa mas e bom saber.

---

## 5. Cross-Platform — Gap Critico do OLMO

### 5.1 Estado atual

OLMO roda no **Windows 11** mas todos os 29 scripts sao **bash**. Funcionam via Git Bash mas isso e um hack, nao uma solucao profissional.

### 5.2 O que profissionais fazem

Padrao profissional cross-platform (claudefa.st "Code Kit"):
- Todos os hooks sao `.mjs` (ES modules) invocados com `node`
- `os.homedir()` em vez de `$HOME` ou `%USERPROFILE%`
- `os.tmpdir()` em vez de `/tmp`
- `path.join()` em vez de separadores hardcoded
- Zero dependencia de bash, cmd, ou powershell

### 5.3 Implicacao para OLMO

OLMO funciona porque Git Bash esta instalado. Mas:
- Nao e portable (outro Windows sem Git Bash quebraria)
- `$CLAUDE_PROJECT_DIR` funciona em bash mas seria mais robusto em Node
- jq e uma dependencia implicita em varios scripts
- Testes automatizados de hooks sao praticamente impossiveis em bash

**Decisao necessaria:** Migrar para Node.js (.mjs)? Trade-off: reescrita de 29 scripts vs robustez. Para um solo dev num unico Windows, bash funciona. Para "profissional" de verdade, Node.js seria o caminho.

---

## 6. Memoria — Veredicto Final

### 6.1 Mudanca de cenario desde S210

**Auto Dream nativo** (Anthropic, rolling out marco/abril 2026): consolidacao noturna automatica. Faz o que `/dream` faz manualmente. Se ja chegou na conta do Lucas, o sistema `.dream-pending` e redundante.

### 6.2 Comparacao atualizada

| Ferramenta | Stars | Status abr 2026 | OLMO match |
|------------|-------|------------------|------------|
| Auto Memory + Auto Dream (nativo) | — | Production, rolling out | **Verificar conta** |
| claude-memory-compiler | ~237→? | Recém-lancado (abr 6). Value prop encolheu com Auto Dream nativo | Skip |
| ByteRover CLI | ~4k | Rebrand de Cipher. Elastic License. Sem mudanca material | Skip |
| claude-mem | ~46k | Infra pesada. API key risk. | Skip |
| memsearch (Zilliz) | ~1.2k | Milvus backend. Overkill para 20 artigos. | Skip |
| Graphiti (Zep) | ~25k | MCP Server 1.0. Neo4j obrigatorio. | **Overkill** — resolve problemas de escala (temporal, multi-hop). OLMO tem 20 files. |
| Hookify | 1st party | Markdown+YAML rules. Warn/block only. Bug cosmético #35587. Fork hookify-plus. | **Abaixo do OLMO** — menos eventos, menos flex |
| MemPalace | ~20k | Benchmark gaming, crypto. | **Evitar** |

### 6.3 Decisao

**Fase 4 cancelada.** Nenhuma ferramenta justifica adocao.

Acoes:
1. Verificar se Auto Dream nativo chegou na conta (menu `/memory`)
2. Se sim: avaliar se substitui o flag `.dream-pending` (mesma funcao, zero manutencao)
3. Se nao: manter sistema atual. Funciona.

---

## 7. O que os melhores fazem que OLMO nao faz

Lista honesta de gaps, ordenada por impacto:

### 7.1 Gaps arquiteturais (fundamentais)

1. **Node.js hooks (.mjs) para cross-platform** — OLMO usa bash no Windows. Funciona, nao e profissional.
2. **Agent hooks (type: agent)** — OLMO nao usa o handler mais poderoso. Verificacao deep contra codebase real.
3. **Testes de hooks** — OLMO tem 0 testes. Profissionais testam hooks com unit tests (Python/TS).
4. **JSON stdin parsing** — OLMO drena stdin (`cat >/dev/null`). Profissionais parseiam o JSON para decisoes contextuais.

### 7.2 Gaps de cobertura (eventos)

5. **SessionEnd** vs Stop — dream flag no lugar errado
6. **PostToolUseFailure** — falhas silenciosas
7. **SubagentStart/Stop** — subagents sem contexto nem validacao

### 7.3 Gaps de DX (developer experience)

8. **YAML config** — cchook ou claude-yaml-hooks > JSON raw para manutencao
9. **Sequential hooks** — feature nao existe ainda (issue #4446), mas monolitismo atual e debt

### 7.4 O que OLMO faz BEM (honestamente)

- **Prompt hook anti-racionalizacao** — poucos fazem isso. Trail of Bits tem 2 hooks basicos. OLMO tem avaliacao semantica.
- **`if` conditions** — OLMO usa. Maioria nao.
- **`async: true`** em hooks nao-bloqueantes — correto.
- **`set -euo pipefail`** em todos scripts — melhor que maioria.
- **`$CLAUDE_PROJECT_DIR`** — correto, path portavel.
- **Cross-ref checks** no Stop — unico. Ninguem na comunidade faz verificacao de consistencia de arquivos ao parar.

---

## 8. O Gap Real: Self-Improvement Loop

> "Hooks nao fazem self-improving nem melhoram a memoria." — Lucas, S213

### 8.1 O problema que nenhum repo resolve

Toda a pesquisa acima e sobre **mecanica** — eventos, formatos, paradigmas. Mas hooks sao **freios** (CMMI L2: controle). Nao sao **melhoria** (CMMI L3+: aprendizado).

O ciclo fechado que nao existe em lugar nenhum:
```
Hook detecta problema → Loga → Alguem analisa os logs → Novo hook/rule/memory
```

Hoje no OLMO:
- `stop-quality.sh` detecta issues → grava em `pending-fixes.md` → session-start surfacea
- `/dream` consolida memoria → mas nao lê logs de hooks
- `known-bad-patterns.md` acumula anti-patterns → mas e manual via `/insights`

O que falta: **nenhum mecanismo automatico transforma falhas detectadas por hooks em melhoria do sistema** (nova rule, novo hook, novo memory entry). O humano (Lucas) e o elo entre deteccao e melhoria. Isso e correto para decisoes, mas para padroes mecanicos (mesmo erro 3x = regra) deveria ser automatico.

### 8.2 Evidencias academicas: self-improving agents

**Fontes primarias verificadas:**

#### SICA — A Self-Improving Coding Agent (arXiv:2504.15228, Robeyns et al., Bristol, maio 2025)
- Agente que edita seu proprio codigo para se melhorar
- Mantem archive de versoes anteriores + benchmark results
- Seleciona melhor agente do archive como meta-agent para implementar proxima melhoria
- **Resultados: 17-53% ganho em SWE-Bench Verified + LiveCodeBench**
- Repo: github.com/MaximeRobeyns/self_improving_coding_agent
- **Relevancia OLMO:** O conceito de "archive + selecao do melhor" e implementavel com hooks. Cada sessao poderia gerar um score (tarefas completas/falhas) e acumular no archive.

#### Reflexion (arXiv:2303.11366, Shinn et al., 2023)
- Verbal reinforcement learning: agente reflete em linguagem natural sobre falhas
- Reflexoes armazenadas em memoria episodica → condiciona tentativas futuras
- **Nao requer treinamento de modelo** — funciona na camada de prompt
- **Relevancia OLMO:** Equivalente conceitual a um `/insights` automatizado que le logs de hooks e gera reflexoes estruturadas.

#### Survey: Memory for Autonomous LLM Agents (arXiv:2603.07670, Du, mar 2026)
- Formaliza memoria como ciclo **write-manage-read** acoplado a percepcao e acao
- Taxonomia 3D: escopo temporal × substrato representacional × politica de controle
- 5 familias: compressao em contexto, retrieval-augmented, **reflexive self-improvement**, hierarquico, policy-learned
- **Gap identificado:** "continual consolidation" e "trustworthy reflection" sao desafios abertos
- **Relevancia OLMO:** /dream ja faz "continual consolidation" manual. O gap e automacao + reflexao sobre dados de hooks.

#### MemR3 — Memory Retrieval via Reflective Reasoning (arXiv:2512.20237, dez 2025)
- Evidence-gap tracker: mantem explicitamente "o que e sabido" vs "o que falta"
- Refina queries iterativamente
- **Relevancia OLMO:** pending-fixes.md e um evidence-gap tracker rudimentar. Poderia ser formalizado.

### 8.3 Implementacoes praticas verificadas (nao academicas)

#### David Oliver — Auto MoC (3 niveis de RSI, mar 2026)
- **Level 1:** Sistema aprende QUANDO pode agir (trust scoring por acao)
- **Level 2:** Sistema aprende O QUE fazer (padroes que se repetem → regras)
- **Level 3:** Sistema identifica COMO melhorar e escreve proposta de nova regra
- Comeca com zero trust, score por acao, gradua padroes que se provam
- **Relevancia OLMO:** Level 1 = hooks atuais (freios). Level 2 = o gap real. Level 3 = aspiracional.

#### Learnings Loop (MindStudio, Skills 2.0, jan 2026)
- Skill atualiza suas proprias instrucoes baseado em feedback do usuario
- Componentes: `Learnings.md` (acumula conhecimento) + Wrap-Up Skill (captura ao fim da sessao)
- Categorias: sucessos, falhas, padroes, erros, perguntas abertas
- CLAUDE.md aponta para Learnings.md → toda sessao comeca com conhecimento acumulado
- **Relevancia OLMO:** /dream + MEMORY.md ja fazem isso parcialmente. O gap: nao consomem dados de hooks.

#### Addy Osmani — Self-Improving Coding Agents (jan 2026)
- Progress log: cada ciclo registra tarefa tentada + pass/fail + erros
- Git commit history como persistencia entre iteracoes
- Testes de alta qualidade como ancora: agente mimetiza padroes dos testes existentes
- **Relevancia OLMO:** git log ja e persistencia. O que falta e progress log estruturado por sessao.

#### mcpmarket.com — Feedback Loop & Self-Improvement Skill
- Skill pronta para Claude Code que implementa o ciclo detectar→refletir→propor
- **Status:** nao verificado em producao. Listado no marketplace.

### 8.4 Sintese: o que o OLMO tem vs o que precisa (com evidencias)

| Componente | Estado da arte | OLMO tem? | Gap |
|------------|---------------|-----------|-----|
| **Deteccao** (hooks) | Deterministico + semantico | ✅ Parcial (29 scripts + 1 prompt) | Falhas silenciosas (PostToolUseFailure) |
| **Log estruturado** | JSON com event/pattern/count/timestamps | ❌ | pending-fixes.md e texto livre |
| **Reflexao** (Reflexion) | Verbal RL sobre episodios | ❌ | /dream nao le logs de hooks |
| **Acumulacao** (Learnings Loop) | Categorizado: sucesso/falha/padrao | ✅ Parcial (MEMORY.md + /dream) | Nao categoriza por tipo |
| **Proposta automatica** (Auto MoC L3) | Gera candidato a regra | ❌ | /insights e manual |
| **Trust scoring** (Auto MoC L1) | Score por acao, gradua autonomia | ❌ | Tudo ou nada |
| **Archive + benchmark** (SICA) | Versoes rankeadas por performance | ❌ | Sem metricas de performance por sessao |
| **Evidence-gap tracker** (MemR3) | Explicita o que falta | ✅ Rudimentar (pending-fixes.md) | Nao formalizado |

### 8.5 Fase 5: Self-Improvement Loop (proposta baseada em evidencias)

**Pre-requisito:** Dados. Antes de construir o loop, precisa ter logs estruturados para alimenta-lo.

**Step 1: Log estruturado** (mecanico, 1 sessao)
- Todos os hooks que detectam problemas gravam em `.claude/hook-log.jsonl`
- Formato: `{"ts":"ISO","event":"Stop","hook":"stop-quality","category":"cross-ref","pattern":"slide-without-manifest","severity":"warn"}`
- Substitui texto livre em pending-fixes.md

**Step 2: /dream consome hook-log** (1 sessao)
- Ao consolidar, /dream le hook-log.jsonl
- Identifica padroes com 3+ ocorrencias
- Gera entrada em known-bad-patterns.md com dados (N ocorrencias, primeira/ultima vez)

**Step 3: /insights propoe regras** (1 sessao)
- Le known-bad-patterns.md + hook-log.jsonl
- Para padroes com 5+ ocorrencias, gera candidato a nova rule ou hook
- Output: proposta formatada para aprovacao do Lucas

**Step 4: Trust scoring** (futuro, decisao do Lucas)
- Cada proposta aprovada incrementa trust score do tipo de sugestao
- Apos N aprovacoes consecutivas do mesmo tipo, pode auto-aplicar com notificacao

**Risco:** Over-engineering. O sistema atual funciona. Adicionar complexidade so vale se os logs mostrarem padroes recorrentes que justifiquem automacao. **Comecar pelo Step 1 (log) e decidir o resto com dados.**

---

## 9. Plano de Acao Proposto

### Feito nesta sessao (S213)

- [x] Prompt hook Stop anti-racionalizacao — implementado e testado (disparou e pegou gap real)
- [x] Response format corrigido: `{decision:"block"}` → `{ok:false, reason:"..."}` (formato prompt/agent hooks)
- [x] Pesquisa completa persistida neste plan file

### Tambem feito nesta sessao (S213) — Self-Improvement Loop Step 1

- [x] Log estruturado: `.claude/hook-log.jsonl` + `hooks/lib/hook-log.sh` utility
- [x] PostToolUseFailure hook: log falhas + corrective systemMessage
- [x] SessionEnd hook: dream flag movido de Stop → SessionEnd (fire-once)
- [x] stop-quality.sh atualizado com hook_log calls (cross-ref, hygiene)
- [x] stop-should-dream.sh removido de Stop (logica em session-end.sh)
- [x] Eventos: 8→10 (PostToolUseFailure, SessionEnd)
- [ ] Verificar Auto Dream nativo: Lucas roda `/memory` e reporta

### Sessoes seguintes: Steps 2-3

- [ ] /dream consome hook-log.jsonl → identifica padroes 3+ ocorrencias
- [ ] /insights propoe regras para padroes 5+ ocorrencias → aprovacao Lucas
- [ ] Agent hook no Stop: substituir prompt por agent que LE diff, HANDOFF, CHANGELOG

### Decisoes arquiteturais (Lucas decide com dados)

- [ ] Migrar bash → Node.js (.mjs)? 29 scripts. Trade-off: cross-platform vs reescrita massiva.
- [ ] YAML config (cchook)? Dep Go mas melhora DX de manutencao.
- [ ] Trust scoring (Auto MoC L1)? So apos Steps 1-3 provarem valor com dados reais.

---

## Fontes

### Hooks — documentacao e guias
- [Hooks Reference — Claude Code Docs](https://code.claude.com/docs/en/hooks)
- [Hooks Guide — Claude Code Docs](https://code.claude.com/docs/en/hooks-guide)
- [Complete Guide to All 12 Lifecycle Events — claudefa.st](https://claudefa.st/blog/tools/hooks/hooks-guide)
- [Cross-Platform Hooks — claudefa.st](https://claudefa.st/blog/tools/hooks/cross-platform-hooks)
- [Hook Control Flow — Steve Kinney](https://stevekinney.com/courses/ai-development/claude-code-hook-control-flow)
- [Settings Hooks Deep Dive — Vincent Qiao](https://blog.vincentqiao.com/en/posts/claude-code-settings-hooks/)

### Hooks — repos e tools
- [Trail of Bits config](https://github.com/trailofbits/claude-code-config) — 2 hooks basicos
- [disler/claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery) — Python UV, 13 eventos, observability
- [cchook (syou6162)](https://github.com/syou6162/cchook) — Go CLI, YAML config com template engine
- [claude-yaml-hooks (professional-ALFIE)](https://github.com/professional-ALFIE/claude-yaml-hooks) — TS, declarativo
- [hookify-plus (adrozdenko)](https://github.com/adrozdenko/hookify-plus) — Community fork com fixes
- [Hookify bug #35587](https://github.com/anthropics/claude-code/issues/35587)
- [Sequential hooks issue #4446](https://github.com/anthropics/claude-code/issues/4446)
- [PostToolUseFailure bug #27886](https://github.com/anthropics/claude-code/issues/27886) — cosmético

### Hooks — artigos e tutoriais
- [Production Quality Gates — Edward Kubiak (DEV)](https://dev.to/edwardkubiak/how-i-built-production-quality-gates-into-a-multi-agent-claude-code-workflow-4i55)
- [5 Production Hooks — Blake Crosley](https://blakecrosley.com/blog/claude-code-hooks-tutorial)
- [Complete Guide — SmartScope (Mar 2026)](https://smartscope.blog/en/generative-ai/claude/claude-code-hooks-guide/)
- [Workflow Automation — DataCamp](https://www.datacamp.com/tutorial/claude-code-hooks)
- [Architecture Behind Claude Code — Penligent](https://www.penligent.ai/hackinglabs/inside-claude-code-the-architecture-behind-tools-memory-hooks-and-mcp/)
- [Hooks and Subagents — Samuel Lawrentz](https://samuellawrentz.com/blog/claude-code-hooks-subagents/)
- [Practical Guide — eesel AI](https://www.eesel.ai/blog/hooks-in-claude-code)

### Self-Improvement — papers academicos
- [SICA: A Self-Improving Coding Agent — arXiv:2504.15228](https://arxiv.org/abs/2504.15228) — Robeyns et al., Bristol, 2025. 17-53% ganho SWE-Bench.
- [Reflexion — arXiv:2303.11366](https://arxiv.org/abs/2303.11366) — Shinn et al., 2023. Verbal RL com memoria episodica.
- [Memory for Autonomous LLM Agents — arXiv:2603.07670](https://arxiv.org/abs/2603.07670) — Du, mar 2026. Survey com taxonomia 3D.
- [MemR3 — arXiv:2512.20237](https://arxiv.org/abs/2512.20237) — Evidence-gap tracker, dez 2025.
- [MAR: Multi-Agent Reflexion — arXiv:2512.20845](https://arxiv.org/abs/2512.20845) — Dez 2025.
- [AgentDevel — arXiv:2601.04620](https://arxiv.org/abs/2601.04620) — Self-evolving como release engineering, jan 2026.

### Self-Improvement — implementacoes praticas
- [Auto MoC: 3 Levels RSI — David Oliver (Medium, mar 2026)](https://medium.com/@davidroliver/claude-code-ai-agents-three-levels-of-recursive-self-improvement-the-auto-moc-system-2eb7b8c3d305)
- [Learnings Loop — MindStudio](https://www.mindstudio.ai/blog/learnings-loop-claude-code-skills-self-improvement)
- [Self-Improving Coding Agents — Addy Osmani (jan 2026)](https://addyosmani.com/blog/self-improving-agents/)
- [Feedback Loop Skill — mcpmarket.com](https://mcpmarket.com/tools/skills/feedback-loop-self-improvement)
- [Self-Improving Claude Code seed prompt — ChristopherA (gist)](https://gist.github.com/ChristopherA/fd2985551e765a86f4fbb24080263a2f)
- [Hooks, Rules, Skills Feedback Loops — Jesse (Medium, mar 2026)](https://jessezam.medium.com/hooks-rules-and-skills-feedback-loops-in-claude-code-d47e5f58364d)

### Memoria
- [Auto Memory/Dream — Claude Code Docs](https://code.claude.com/docs/en/memory)
- [Auto Dream — claudefa.st](https://claudefa.st/blog/guide/mechanics/auto-dream)
- [Auto Memory + Dream — Antonio Cortes](https://antoniocortes.com/en/2026/03/30/auto-memory-and-auto-dream-how-claude-code-learns-and-consolidates-its-memory/)
- [Jamie Lord: Memory tools mostly redundant](https://lord.technology/2026/04/11/claude-codes-memory-tool-ecosystem-is-mostly-redundant-with-its-own-defaults.html)
- [claude-memory-compiler](https://github.com/coleam00/claude-memory-compiler)
- [ByteRover CLI](https://github.com/campfirein/byterover-cli)
- [memsearch (Zilliz/Milvus)](https://milvus.io/blog/adding-persistent-memory-to-claude-code-with-the-lightweight-memsearch-plugin.md)
- [Graphiti (Zep)](https://github.com/getzep/graphiti) — 25k stars, MCP Server 1.0
- [Memory 4 Layers — DEV](https://dev.to/chen_zhang_bac430bc7f6b95/claude-codes-memory-4-layers-of-complexity-still-just-grep-and-a-200-line-cap-2kn9)

---

Pesquisa: S213, 2026-04-16
Coautoria: Lucas + Opus 4.6
