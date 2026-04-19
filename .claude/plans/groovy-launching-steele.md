# Diagnostico Adversarial OLMO — S228

> **Modo:** adversarial, evidencia-primeiro, sem sycophancy
> **Data:** 2026-04-18 | **Sessao:** 228 (melhoria_continua)
> **Restricao:** NAO IMPLEMENTAR. Diagnostico + recomendacao.

## Context

Lucas pediu auditoria adversarial em 5 hipoteses sobre drift entre arquitetura declarada e runtime real. A auditoria foi feita por leitura literal do codigo (sem delegar a agentes, delegation gate KBP-17). Resultado: **4 das 5 hipoteses TRUE, 1 PARCIAL.** O drift e material — o sistema promete mais do que entrega, e ha descoberta bonus nao anticipada pelo prompt original: o `model_router` e decorativo end-to-end.

---

## Bloco 1 — Findings

| File | Lines | Severity | Verdict | Problem | Evidence | Concrete fix |
|---|---|---|---|---|---|---|
| `orchestrator.py` | 44 | **P1** | **TRUE** | `Orchestrator()` instanciado sem `agents_config`. `ModelRouter` recebe `None`, `agent_models` fica `{}`, toda task roteada por agent_name cai em `DEFAULT_MODEL` ("claude-sonnet-4-6") — independente do que `ecosystem.yaml` declara | `orchestrator.py:44` vs `agents/core/orchestrator.py:26-34` vs `model_router.py:24-27,37` | Uma linha: `orch = Orchestrator(agents_config=config.get("agents", {}))` |
| `agents/core/orchestrator.py` | 64-65 vs 78-84 | P1 | **TRUE-cosmetico** | Tasks com `agent:` explicito pulam `model_router.resolve()`; tasks roteadas por `type:` passam. Asimetria semantica real, MAS impacto pratico ~zero porque (ver finding abaixo) `_resolved_model` nunca e lido | `orchestrator.py:64-65` (direct dispatch) vs `:78-84` (resolved + injected); `grep _resolved_model` retorna **1 hit — a propria escrita** | Unificar: resolver modelo nos dois ramos. Ou — mais honesto — **remover `model_router` ate que algum agente o consuma** |
| `agents/core/orchestrator.py` | 83 | **P1** | **TRUE (descoberta nova)** | `task_with_model = {**task, "_resolved_model": resolved_model}` escreve a chave, mas **nenhum agente em `agents/*` le `task.get("_resolved_model")`**. O roteamento de modelo e log-only | `grep -rn "_resolved_model"` → unico hit: `orchestrator.py:83`. BaseAgent guarda `self.model` mas agentes nao fazem LLM calls | Decidir: (a) fazer agentes usarem o valor, ou (b) deletar `model_router` ate haver consumidor real. Nao manter teatro |
| `config/workflows.yaml` vs `agents/core/orchestrator.py` | 61-89, 120-143 | **P1** | **TRUE** | `route_task` entende apenas chaves `{mcp_operation, agent, type ∈ [research,automate,organize,update,analyze,schedule,monitor]}`. workflows.yaml usa: `type: [mcp, api_call, local]`, `skill:`, `subagent:`, `action: [batch_query, api_query, check_cache, human_review]`. Resultado: **demo workflow do `python -m orchestrator run` falha no step 1** | `orchestrator.py:147` chama `batch_morning_digest`; step 1 e `action: "batch_query"` sem `agent` nem type valido; `route_task` retorna `"No agent found for task type ''"`; `run_workflow` quebra em `result.success==False` | Ou (a) implementar dispatchers para `mcp`/`api_call`/`local`/`skill`/`subagent`/`batch_query` em `route_task`, ou (b) **remover workflows nao-executaveis** do YAML ate dispatcher existir. Manter contrato que o codigo nao cumpre e divida tecnica |
| `agents/core/orchestrator.py` | 45-48 | **P1** | **TRUE** | Safety gate so dispara se `task["mcp_operation"]` existe. `grep mcp_operation` mostra que **nenhum workflow, teste ou caller seta essa chave**. A unica referencia em codigo produtivo e o proprio gate lendo. Gate = codigo morto com aparencia de seguranca | `grep mcp_operation` → apenas `orchestrator.py` (gate) + `database.py` (logging nao relacionado). workflows.yaml tem 20+ steps `type: "mcp"` — nenhum seta `mcp_operation` | Fazer o gate disparar em `type: "mcp"` OR `mcp_operation`. E **adicionar teste que prove que o gate bloqueia um write real** — sem isso, a garantia e assumida |
| `agents/scientific/scientific_agent.py` | 129-215 | **P1** | **TRUE** | `_search_papers`: KB local e inicializada vazia e **nunca populada por codigo do agente** (so tem `add_paper` definido, nunca chamado). External search e comentario `# seria delegada`. Resultado: **toda busca retorna `status: "search_initiated"` com `local_results: []`**. `_analyze_paper`, `_create_literature_review`, `_find_trends`, `_generate_hypothesis` retornam placeholders `pending`/`template_created`/`analysis_initiated`/`generation_initiated` | scientific_agent.py:80 (`KnowledgeBase()` vazio), :129-151 (fluxo search), :153-215 (stubs). Nao ha chamada a PubMed, Semantic Scholar, arXiv em lugar nenhum do codigo | Decidir: (a) implementar integracao real com pelo menos 1 source, ou (b) **renomear funcoes para `_search_papers_stub` e marcar `NotImplementedError`**. Retornar `success=True` com placeholder e pior que falhar honesto — engana callers |
| `README.md` | 35-39 | **P2** | **PARCIAL** | Drift numerico: "22 hooks" (real: ~31 shell hooks entre `hooks/` e `.claude/hooks/`, HANDOFF diz "31/31 valid"), "11 MCP servers" (ecosystem.yaml comenta "13 connected, 3 planned"), "8 agents" (ambiguo — ver abaixo). "53 tests" e TRUE (confirmei: 9+31+13=53) | `README.md:35-39` vs `Glob hooks/*.sh + .claude/hooks/*.sh` vs `ecosystem.yaml:192` vs contagem real de test functions | Atualizar numeros OR remover numeros e apontar para `docs/ARCHITECTURE.md` como fonte unica |
| `docs/ARCHITECTURE.md` | 36-47 vs 10-32 | **P2** | **TRUE** | "Agents (8)" lista **Claude Code subagents** de `.claude/agents/*.md` (evidence-researcher, qa-engineer, mbe-evaluator...). DAG mostra **Python runtime agents** (Cientifico, Automacao, Organizacao, Atualizacao AI). Sao **dois sistemas ortogonais** chamados de "agents". Leitor nao distingue. Isso e confusao conceitual, nao bug — mas documenta um ecossistema que nao existe como entidade unificada | ARCHITECTURE.md:10-32 (DAG Python) vs :36-47 (tabela CC subagents) | Separar secoes: "Runtime Agents (Python)" vs "Claude Code Subagents (.claude/agents/)". Ou unificar arquitetonicamente — mas isso e mudanca grande, nao doc |
| (ambient) | — | **P2** | **TRUE** | `base_agent.py:54,66-68` armazena `self.model`. Nenhum `execute()` em agente concreto faz chamada LLM usando `self.model`. Todos retornam dicts locais ou placeholders. O campo `model` e lifecycle-metadata — nao ha producao de tokens via agente Python | `base_agent.py:54,66-68`; inspecao de todos os `execute()` em `agents/*/`*.py` | Decidir intencao: (a) agentes Python devem chamar Claude API e usam `self.model` — entao adicionar SDK integration, ou (b) agentes sao apenas orquestradores semanticos que dispatch via MCP/subagents — entao remover `self.model` para honestidade |

---

## Bloco 2 — Reflection On Each Change

### Mudanca 1 — Wire `agents_config` em `Orchestrator()`

- **Por que fazer:** linha trivial de 1 char, destrava a unica intencao expressa da classe `ModelRouter`. Sem isso, o router e teatro.
- **Por que pode ser decisao errada:** **e pode.** Se `_resolved_model` nao e lido por ninguem (confirmado), wirear o config so melhora log fidelity. O beneficio real so existe SE algum agente vier a consumir a chave. **Wire sem consumidor = perfumaria.** O fix honesto e decidir PRIMEIRO se model routing tem cliente real.
- **Alternativa mais simples:** deletar `ModelRouter` e `_resolved_model` inteiro. Se ninguem usa, codigo morto nao merece fix.
- **Teste minimo:** `test_orchestrator_respects_yaml_model_for_agent` — cria Orchestrator com config, roteia task com `agent: "cientifico"`, verifica que `_resolved_model == "claude-sonnet-4-6"` (o que YAML declara). Depois, verifica que um agente concreto efetivamente usa essa chave — sem o 2o passo o teste valida teatro.

### Mudanca 2 — Unificar roteamento direto vs por type

- **Por que fazer:** duas tasks semanticamente equivalentes (`{agent: "X"}` vs `{type: mapeia_para_X}`) seguem paths diferentes. Ou ambos resolvem modelo ou nenhum.
- **Por que pode ser decisao errada:** depende de (1). Se `_resolved_model` for deletado, a asimetria deixa de importar.
- **Alternativa mais simples:** **nao fazer ate decidir** o destino do `model_router`. Fix prematuro.
- **Teste minimo:** test parametrizado: mesma task em duas formas retorna mesmo `_resolved_model`.

### Mudanca 3 — Dispatcher real para `type: mcp/api_call/local/skill/subagent` ou remocao de workflows

- **Por que fazer:** `python -m orchestrator run` chama `batch_morning_digest` que **quebra imediatamente**. Isto e, a primeira execucao user-facing do CLI falha. workflows.yaml documenta ~12 workflows; maioria nao roda. Isso e divida tecnica disfarcada de feature set.
- **Por que pode ser decisao errada:** implementar dispatchers completos e caro (MCP dispatch, LLM API dispatch, local skill dispatch — 3 sub-sistemas). Pode ser que o uso real do projeto nunca passe pelo orchestrator CLI (Lucas opera via Claude Code + slash commands). Se sim, o CLI e artefato morto e o fix correto e **deletar** ou marcar `# TODO: not wired`.
- **Alternativa mais simples:** remover do YAML os workflows que o runtime nao executa. Manter apenas `full_organization` e `research_pipeline` (que usam `agent:` — funcionam). workflows.yaml vira documentacao do que EXISTE, nao do que FOI PROMETIDO.
- **Teste minimo:** `test_run_workflow_batch_morning_digest` executa e assert `all(r.success for r in results)`. Se passar, CLI funciona. Se falhar, o YAML estava mentindo.

### Mudanca 4 — Safety gate disparar em `type: "mcp"` alem de `mcp_operation`

- **Por que fazer:** gate hoje tem 0% de cobertura de trafego real. Seguranca nao-exercitada e falsa seguranca (KBP-13).
- **Por que pode ser decisao errada:** se a decisao arquitetural for **"orquestrador Python nao executa MCP — so Claude Code executa"**, entao o gate no Python e dead code e nao deveria existir no orchestrator. Fix errado mantem um check onde nao ha trafego.
- **Alternativa mais simples:** documentar explicitamente que MCP safety e enforcada em `.claude/hooks/guard-mcp-queries.sh`, nao no Python. E **deletar** o gate Python se for duplicacao inutil.
- **Teste minimo:** teste que constroi task com `type: "mcp", mode: "write"` sem `mcp_operation`, chama `route_task`, verifica que **foi bloqueado**. Se hoje passar, o gate e teatro.

### Mudanca 5 — Renomear/NotImplementedError nos stubs do scientific_agent

- **Por que fazer:** retornar `success=True` com `status: "search_initiated"` engana qualquer caller que cheque `result.success`. Falha honesta > sucesso falso.
- **Por que pode ser decisao errada:** se alguem esta construindo sobre essa superficie assumindo stubs, mudar contrato quebra downstream. Mas — ao grep — nenhum caller checa o shape desses returns (ver: `research_pipeline` declara steps mas runtime nao executa, ver finding 4).
- **Alternativa mais simples:** documentar no docstring que o retorno e placeholder. Menos invasivo, mas mantem a mentira em runtime.
- **Teste minimo:** `test_search_papers_raises_or_delegates` — se assumirmos que a decisao e falhar, teste espera `NotImplementedError`. Se assumirmos delegacao a subagente, teste espera dispatch para `trend_analyzer` ou equivalente.

### Mudanca 6 — Atualizar numeros em README

- **Por que fazer:** baixo custo, alto sinal de rigor. Numeros errados minam confianca em TODO o documento.
- **Por que pode ser decisao errada:** numeros vao drifar de novo. Regra sem mecanismo = promessa.
- **Alternativa mais simples:** substituir numeros por "~30 hooks, dezenas de testes" — vago, mas nao mente.
- **Teste minimo:** pre-commit hook que compara README counts com counts reais. Se divergir, bloqueia commit. Sem automation, drift retorna em 2 sessoes.

### Mudanca 7 — Separar "Runtime Agents" vs "Claude Code Subagents" em ARCHITECTURE.md

- **Por que fazer:** dois ecossistemas distintos com mesmo nome. Isso confunde TODA discussao sobre "agents" no projeto.
- **Por que pode ser decisao errada:** pode ser que a visao seja **unificar** os dois — entao separar na doc adia a decisao arquitetural. Mas: unificar 10 agents Python + 8 CC subagents e epico e nao esta em nenhum backlog. Separar e o realismo.
- **Alternativa mais simples:** renomear `agents/` Python para `orchestration/` ou `runtime/`. Ataca a ambiguidade na raiz (filesystem).
- **Teste minimo:** ler a doc como novato. Em <30s, conseguir responder "quantos agentes, de que tipo, quem executa o que?". Se nao — ambiguo.

---

## Bloco 3 — Hard Call

### Fazer agora (alto ROI, baixo custo, sem depender de decisoes abertas)

1. **Atualizar numeros do README** (finding H5) — 5min, elimina drift visivel. Aceitar risco de re-drift.
2. **Separar secoes em ARCHITECTURE.md** (Runtime Agents vs CC Subagents) — 15min, resolve confusao conceitual sem mudar codigo.
3. **Adicionar `NotImplementedError` em stubs do scientific_agent OU marcar docstring `[STUB — not implemented]`** — 10min, para de mentir para callers. Escolher a mais leve.
4. **Adicionar teste que tenta rodar `batch_morning_digest`** — se falhar, documenta a quebra existente. So CLI. Nao corrige, **expoe**. Isso cria pressao saudavel para decidir (3) abaixo.

### Nao fazer agora (ideias boas, mas prematuras — dependem de decisao arquitetural)

1. **NAO** wire `agents_config` em `Orchestrator()` (mudanca 1) **ate decidir se `model_router` tem consumidor real**. Fix cosmetico sem cliente = teatro polido.
2. **NAO** implementar dispatchers `mcp/api_call/local` em `route_task` **ate decidir se o CLI Python e viavel ou artefato legacy**. O investimento e grande; se Lucas opera 99% via Claude Code, o runtime Python esta morrendo — e isso muda o fix de "construir dispatchers" para "deletar CLI".
3. **NAO** unificar roteamento direto vs por-type — mesma razao: depende de (1).
4. **NAO** adicionar features ao scientific_agent (PubMed integration, etc) **ate que exista um caller Python real**. Se toda pesquisa cientifica passa pelo agente Claude Code `evidence-researcher`, o `ScientificAgent` Python e codigo sem demanda. Adicionar features sem demanda e overfitting arquitetural.

### Suspender narrativa (rebaixar em docs ate runtime alcancar)

1. **"Orchestrator (Opus 4.6) — rota, planeja, decide"** (README + ARCHITECTURE) — rotear **nao decide modelo** (finding 1+3). "Planeja" retorna 4 steps hardcoded (orchestrator.py:111-118). "Decide" — decide agente por dict lookup, OK. **Reescrever para algo como: "Orchestrator — dispatcha task para agente por type-keyword ou nome explicito. Roteamento de modelo por YAML planejado, nao ativo."**
2. **"Pesquisa e analise cientifica"** (ecosystem.yaml: cientifico) — o agente nao pesquisa. Rebaixar para "Stub de interface para pesquisa cientifica — integracao pendente."
3. **workflows.yaml lista ~12 workflows como se fossem executaveis** — maioria nao roda. Rebaixar os nao-executaveis com `status: planned` ou comentario `# NOT WIRED`. Ou mover para `workflows/planned/`.
4. **"7-layer antifragile stack"** — nao auditei as 7 camadas, mas dado o padrao observado (features documentadas sem runtime), provavelmente **PARCIAL**. Requer audit proprio antes de continuar usando como claim de maturidade.
5. **`mcp_safety.py` e `validate_mcp_step`** — dado que o gate nunca e disparado por trafego real, a doc/code que sugere "MCP safety integrada" e aspiracional. Nao remover agora, mas nao tratar como linha de defesa ate ter teste que prove bloqueio.

---

## Anti-Sycophancy Self-Check

- [x] **Desafiei a proposta principal ou apenas refinei?** Desafiei: o prompt original pediu auditoria de 5 hipoteses; descobri uma 6a mais grave (`_resolved_model` nunca lido) que subordina 3 das 5.
- [x] **Encontrei ao menos 1 regressao plausivel por mudanca importante?** Sim — em (1), (2), (3), (4), (5), (6), (7) ha contra-argumento explicito em "Por que pode ser decisao errada".
- [x] **Distingui problema real de cheiro arquitetural?** Sim: H1 e H2 classifiquei TRUE mas com ressalva cosmetica (impacto pratico nulo ate que `_resolved_model` seja consumido). H3/H4/H5 sao problemas reais.
- [x] **Marquei provado vs presumido?** Sim — "7-layer antifragile" marquei como nao-auditado (presumido PARCIAL). PMID drift em H5 marquei PARCIAL por partes verificadas. NAO PROVADO nao foi necessario — todos os claims testaveis tiveram codigo correspondente lido.
- [x] **Recusei ideia que parecia boa?** Sim — recusei a mudanca 1 ("wire `agents_config`") como primeira acao, apesar do prompt original ter essa expectativa. Evidencia de que `_resolved_model` e unused subverte o fix.

---

## Paths & Evidence (para verificacao)

- `orchestrator.py:44` — Orchestrator() no args
- `agents/core/orchestrator.py:26,34,64,78-84,83` — class init, router wire, routing branches
- `agents/core/model_router.py:24-27,37,44-54` — router nao usado
- `agents/scientific/scientific_agent.py:75-117,129-215` — stubs
- `config/workflows.yaml` — workflows com tipos nao-suportados
- `config/ecosystem.yaml:11-108` — agents + subagents declarados
- `README.md:35-39` — drift numerico
- `docs/ARCHITECTURE.md:36-47` vs `:10-32` — dois sistemas, mesmo nome
- `grep _resolved_model` → 1 hit
- `grep mcp_operation` → 2 hits (gate + unrelated logging)
- `tests/test_core/` → 3 arquivos, 53 tests confirmados; sem test_orchestrator, sem test_workflows

---

## Proxima acao proposta

Antes de implementar qualquer coisa do "Fazer agora", preciso de **1 decisao arquitetural** de Lucas:

> **O CLI Python (`python -m orchestrator run`) e target vivo ou legacy?**

- Se **vivo** → justifica implementar dispatchers de workflow + wire model router + integrar APIs reais nos agentes. Mudanca grande.
- Se **legacy** → justifica deletar `model_router`, marcar agentes como stubs, remover workflows nao-wireados, reduzir orchestrator.py a minimo funcional. Mudanca cirurgica honesta.

Sem essa decisao, qualquer fix esta otimizando localmente um sistema cuja direcao e incerta.
