# S210: Memoria + Hooks + Settings — Plano baseado em dados (6 agentes, fontes verificadas)

## Diagnostico real (o que os dados mostram)

A pesquisa de S209 nao foi perdida porque o **sistema de memoria falhou**. Os 20 arquivos flat estao intactos. O que falhou:

1. Output de agente ficou em temp file que expirou
2. Recomendacao sintetizada ficou so no contexto da conversa
3. Compaction apagou o contexto
4. Nenhum mecanismo automatico persistiu os achados antes da compaction

**Jamie Lord (abril 2026, 2.455 avaliacoes comunitarias):** native CLAUDE.md + auto memory + hooks + skills cobrem ~80% do que ferramentas de memoria prometem. A <500 artigos, LLM lendo index estruturado supera vector search.

**OLMO tem 20 artigos.** Nao 500. Nao 2.000. O gargalo nao e retrieval — e processo.

Prioridade:
1. Settings que impactam qualidade AGORA (dados da comunidade)
2. Corrigir o processo que causou a perda (rapido, gratis)
3. Modernizar hooks (mecanico, ROI comprovado)
4. DEPOIS avaliar se ferramenta de memoria adiciona valor real

---

## Settings — dados da comunidade (issue tracking + power users)

**Descoberta critica:** Em marco 2026, Anthropic silenciamente rebaixou o default de effortLevel de `high` para `medium` em Pro/Max. Causou regressao massiva de qualidade. Boris Cherny (Head Claude Code) confirmou. A combinacao abaixo e o consenso da comunidade para qualidade maxima:

### Env vars de alto impacto (adicionar ao `env` em settings.local.json)

| Variavel | Valor | Porque | Fonte |
|----------|-------|--------|-------|
| `CLAUDE_CODE_EFFORT_LEVEL` | `max` | Bug: `"effortLevel": "max"` no JSON silenciosamente falha. So persiste via env var. Issues #30726, #33937, #43322 | community + bug tracking |
| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` | `1` | Adaptive thinking aloca ZERO tokens em alguns turns → halucinacoes. Desabilitar forca budget fixo maximo | dev.to/shuicici, pasqualepillitteri.it |
| `CLAUDE_CODE_SUBAGENT_MODEL` | `claude-sonnet-4-6` | Sem isso subagents herdam Opus (caro em contexto). Sonnet default, Opus via frontmatter quando necessario | docs oficiais |
| `CLAUDE_CODE_DISABLE_1M_CONTEXT` | `1` | Desabilitado por default. Session-start hook deve perguntar se sessao precisa de 1M (pesquisa pesada, contexto grande) | decisao Lucas |

### Settings JSON de alto impacto

| Chave | Valor | Porque |
|-------|-------|--------|
| `autoMemoryEnabled` | `false` | OLMO tem sistema manual curado (20 files + /dream). Auto memory conflita e polui | issue #23750 |
| `alwaysThinkingEnabled` | `true` | Forca extended thinking em todo turn | docs oficiais |

### NAO fazer
- **NAO** colocar `ANTHROPIC_API_KEY` no env — bypassa Max subscription, cobra API direto. Um usuario pagou $1.800 em 2 dias (issue #37686)
- **NAO** colocar `"effortLevel": "max"` no JSON — silenciosamente converte para undefined

---

## Dados consolidados — 6 agentes, fontes verificadas

### Memoria — o que existe de fato

| Solucao | Stars | Infra | Custo | Match OLMO | Risco |
|---------|-------|-------|-------|------------|-------|
| claude-mem | 55.8k | SQLite+ChromaDB+worker | API key leak (issue #733) | Baixo (pesado) | Token cost multiplica com subagents |
| ByteRover CLI | 4.3k | Zero (markdown) | $0 local | **Alto** (mesmo paradigma) | Elastic License, startup |
| Mem0 Cloud free | 50.2k | Cloud | $0 (1k retrieval/mo) | Medio | Dados medicos em cloud externo |
| claude-memory-compiler | ~800 | Zero (hooks+markdown) | Agent SDK no session end | **Mais alto** (= /dream automatizado) | Projeto novo |
| Graphiti+Kuzu | 25k | Neo4j ou FalkorDB | ~$2-5/mo | Baixo (overkill) | MCP+Kuzu nao documentado |
| kuzu-memory | 22 | Embedded graph | $0 | Medio | 1 maintainer, stale |
| @mcp/server-memory | 83.8k (parent) | JSONL local | $0 | Nenhum | Lateral move |

**Benchmarks sao lixo.** LoCoMo audit: 6.4% golden answers errados, LLM judge aceita 63% de respostas erradas, Mem0 reproduziu 0.20 vs 0.66 reportado, Zep corrigido 84%→58%. Nenhum vendor number e confiavel.

### Hooks — o que existe de fato

| Feature | Status | ROI OLMO | Esforco |
|---------|--------|----------|---------|
| `$CLAUDE_PROJECT_DIR` | Production | **ALTO** — 29 paths hardcoded | 15 min |
| `set -euo pipefail` | Best practice | **ALTO** — 28/29 sem protecao | 30 min |
| `async: true` | Production | **ALTO** — 4+ hooks nao-bloqueantes | 5 min |
| `if` conditions (v2.1.85+) | Production | **ALTO** — evita process spawn | 20 min |
| Prompt hooks (Stop) | Production (bugs fixados abr 2026) | **ALTO** — anti-rationalizacao semantica | 1h |
| Hookify | Production | **BAIXO** — so warn/block, 5/27 eventos | 30 min |
| Consolidacao matchers | Architectural | MEDIO — 9→5 PreToolUse | 1-2h |
| HTTP/Agent hooks | Production | **BAIXO** — solo dev, overhead alto | Skip |

### Audit atual (30 scripts)

- **28/29** sem `set -euo pipefail` (so guard-secrets.sh)
- **2 vulns confirmadas:** eval injection (retry-utils.sh:28), JSON hand-assembly (post-compact-reread.sh:15)
- **1 vuln possivelmente corrigida:** printf injection (nao encontrada)
- **0 scripts** usam `$CLAUDE_PROJECT_DIR`
- **1 node -e** restante (apl-cache-refresh.sh:42)
- **pre-push.sh/post-merge.sh:** NAO referenciados — finding stale, nao e bug

---

## Plano de execucao — ordem por ROI

### Fase 0: Commit pendente + session name (10 min)

Antes de qualquer coisa: commitar o trabalho S209 que esta solto.

Arquivos:
- `.claude/hooks/momentum-brake-enforce.sh` (WebFetch/WebSearch/Task* exempt)
- `HANDOFF.md` (atualizado)
- `.claude/plans/generic-wondering-manatee.md` (plano master com pesquisa)

### Fase 1: Anti-perda — corrigir o processo (1h)

**Problema real:** pesquisa de agente morreu no temp file + contexto.

**Acoes:**
1. **Melhorar pre-compact-checkpoint.sh** — alem de git status, salvar resumo de agentes recentes + achados pendentes em `.claude/.last-checkpoint`
2. **Corrigir vuln** em post-compact-reread.sh:15 (JSON hand-assembly → jq)
3. **Regra operacional:** toda pesquisa de agente deve ser persistida em plan file ANTES de reportar ao usuario. Isso ja acontece parcialmente (agents escrevem em `hashed-*-agent-*.md`) mas o RESUMO sintetizado ficou so no contexto.
4. **Avaliar claude-memory-compiler** (coleam00) — e essencialmente um `/dream` automatizado. Se funciona, resolve o gap de compilacao automatica que causou a perda.

### Fase 2: Hooks mecanicos — zero risco, ROI maximo (70 min)

Ordem por impacto/minuto:

1. **`async: true`** em hooks nao-bloqueantes (5 min)
   - `stop-metrics.sh`, `stop-notify.sh`, `chaos-inject-post.sh`, `model-fallback-advisory.sh`
   - Impacto: latencia reduzida em Stop e PostToolUse

2. **`$CLAUDE_PROJECT_DIR`** em settings.local.json (15 min)
   - Find-replace: `/c/Dev/Projetos/OLMO` → `"$CLAUDE_PROJECT_DIR"`
   - Impacto: portabilidade, correctness

3. **`set -euo pipefail`** nos 28 scripts sem protecao (30 min)
   - Mecanico: adicionar na linha 2 de cada script
   - Impacto: previne undefined variable bugs silenciosos

4. **`if` conditions** em PreToolUse (20 min)
   - guard-bash-write.sh: `"if": "Bash(*rm *|*mv *|*cp *|*> *)"` evita spawn em reads
   - guard-research-queries.sh: `"if": "Skill(research)"` narrow
   - Impacto: menos process spawns por tool call

### Fase 3: Hooks seguranca + consolidacao (2-3h)

1. **Fix eval injection** — retry-utils.sh:28 (30 min)
   - `eval "$cmd"` → funcao com validacao ou array execution

2. **Fix JSON hand-assembly** — post-compact-reread.sh:15 (15 min)
   - `echo "{...\"$MSG\"...}"` → `jq -cn --arg msg "$MSG" '{hookSpecificOutput:{message:$msg}}'`

3. **Prompt hook Stop** — anti-rationalizacao ✅ S213
   - Trail of Bits pattern: Haiku avalia se Claude racionalizou pular trabalho
   - Custo: $0 no Max subscription
   - Complementa stop-quality.sh (mecanico) com avaliacao semantica
   - Posicao: Stop[0] (antes de quality.sh). Model: default fast (Haiku). Timeout: 30s
   - Teste real: fim desta sessao. Se $ARGUMENTS nao tiver contexto, pivotar para hibrido

4. **Consolidar PreToolUse** — 9→5 entries (1h)
   - Merge 3 Bash matchers em 1 grupo (executam em paralelo)
   - `.*` catch-all (momentum-brake): avaliar se `if` pode narrow

### Fase 4: Memoria — avaliar com dados (2h, pode ser sessao separada)

**Decisao informada, nao por hype:**

O que o OLMO REALMENTE precisa:
- Persistencia automatica de achados antes de compaction ✓ (Fase 1 resolve)
- Retrieval semantico? A <500 artigos, index > vector (Lord 2026)
- Compilacao automatica? /dream existe mas e manual

**Avaliar em ordem:**
1. **claude-memory-compiler** — se resolve compilacao automatica sem infra, testa 2 sessoes
2. **ByteRover CLI** — se precisar de retrieval hierarquico alem do index, testa 2 sessoes
3. **Nenhum** — se Fase 1 + /dream melhorado resolve, nao adicionar complexidade

**NAO instalar agora:** Mem0 (dados medicos em cloud), claude-mem (infra pesada, API key risk), Graphiti (overkill).

---

## Verificacao

| Fase | Criterio de sucesso |
|------|-------------------|
| 0 | `git status` clean, session name definido |
| 1 | Simulacao: compaction nao perde pesquisa pendente |
| 2 | `grep -c 'CLAUDE_PROJECT_DIR' .claude/settings.local.json` = 29, `grep -rn 'set -euo' hooks/ .claude/hooks/ | wc -l` >= 28 |
| 3 | `grep -rn 'eval "' .claude/hooks/lib/` = 0, prompt hook Stop funcional |
| 4 | Decisao documentada: ferramenta X adotada/rejeitada com razao |

## Riscos

| Risco | Mitigacao |
|-------|-----------|
| `set -euo pipefail` quebra scripts com `||` ou vars opcionais | Testar cada script apos adicionar. `${VAR:-}` para opcionais |
| `$CLAUDE_PROJECT_DIR` nao resolve em algum contexto Windows | Testar 1 hook antes de migrar todos |
| Prompt hook Stop adiciona latencia | 1-3s Haiku, aceitavel. `async` se necessario |
| claude-memory-compiler usa Agent SDK (custo API) | Max subscription = $0. Verificar se nao escapa para API key |

## Fontes

### Memoria
- [claude-mem](https://github.com/thedotmack/claude-mem) — 55.8k stars, issue #733 (API key leak), issue #1464 (subagent cost)
- [ByteRover/Cipher](https://github.com/campfirein/cipher) — 3.6k stars, arXiv:2604.01599, Elastic License 2.0
- [claude-memory-compiler](https://github.com/coleam00/claude-memory-compiler) — ~800 stars, Karpathy pattern
- [Mem0](https://github.com/mem0ai/mem0) — 50.2k stars, self-hosted MCP archived Mar 2026
- [LoCoMo audit](https://github.com/dial481/locomo-audit) — 6.4% golden answers wrong
- [Jamie Lord: "Memory tools are mostly redundant"](https://lord.technology/2026/04/11/claude-codes-memory-tool-ecosystem-is-mostly-redundant-with-its-own-defaults.html) — 2,455 eval benchmark

### Hooks
- [Hooks Reference](https://code.claude.com/docs/en/hooks) — 27 eventos, 4 tipos handler
- [Hookify](https://github.com/anthropics/claude-code/tree/main/plugins/hookify) — 5 eventos, warn/block only
- [Trail of Bits](https://github.com/trailofbits/claude-code-config) — 2 hooks baseline + prompt anti-rationalization
- [disler/claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery) — 13 eventos, Python UV
- [Windows deadlock issue #34457](https://github.com/anthropics/claude-code/issues/34457) — fixed v2.1.90

### Settings (pesquisa comunidade — issue tracking + power users)
- [Effort Level Bug #30726](https://github.com/anthropics/claude-code/issues/30726) — max nao persiste em JSON
- [Max effortLevel #33937](https://github.com/anthropics/claude-code/issues/33937) — confirmado, so env var
- [effortLevel max #43322](https://github.com/anthropics/claude-code/issues/43322) — serializer converte para undefined
- [Adaptive Thinking Regression](https://dev.to/shuicici/claude-codes-feb-mar-2026-updates-quietly-broke-complex-engineering-heres-the-technical-5b4h) — zero-think turns causam halucinacoes
- [Two Settings 90% Don't Know](https://pasqualepillitteri.it/en/news/805/claude-code-effort-adaptive-thinking-guida) — max + disable adaptive = consenso comunidade
- [Auto Memory Disable #23750](https://github.com/anthropics/claude-code/issues/23750) — `autoMemoryEnabled: false` ou `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`
- [Subagent Model #19174](https://github.com/anthropics/claude-code/issues/19174) — `CLAUDE_CODE_SUBAGENT_MODEL` env var
- [API Key Billing Accident #37686](https://github.com/anthropics/claude-code/issues/37686) — $1.800 em 2 dias, ANTHROPIC_API_KEY bypassa Max
- [1M Context Billing Regression #40223](https://github.com/anthropics/claude-code/issues/40223) — Opus 1M mostra "extra usage" incorretamente
- [Settings Reference](https://claudefa.st/blog/guide/settings-reference) — referencia completa

### Claude-mem triangulacao (6 solucoes comparadas)
- [claude-mem](https://github.com/thedotmack/claude-mem) — 55.8k stars, v10.6.3. SQLite+ChromaDB+worker. API key leak issue #733, subagent cost issue #1464. Infra pesada.
- [claude-memory-compiler](https://github.com/coleam00/claude-memory-compiler) — ~800 stars. Karpathy "compile don't embed". Session-end hook + Agent SDK. Maior match filosofico com /dream.
- [memsearch (Zilliz)](https://github.com/zilliztech/memsearch) — 1.2k stars, v0.3.0. Markdown-first, Milvus shadow index. "Markdown is source of truth, vector DB is cache." Pesado para uso pessoal.
- [Jamie Lord analysis](https://lord.technology/2026/04/11/claude-codes-memory-tool-ecosystem-is-mostly-redundant-with-its-own-defaults.html) — "Memory tools are mostly redundant." <500 artigos: LLM index > vector search. 2,455 evals.
- [MemPalace](https://github.com/MemPalace/mempalace) — 19-23k stars. **EVITAR:** benchmark gaming (100%→96.6%), crypto pump-and-dump associado, autoria disputada.

### Audit
- 31 scripts on disk, 29 registered, 28/29 sem set -u, 2 vulns confirmadas
- 0/29 usam $CLAUDE_PROJECT_DIR, 1 node -e restante
