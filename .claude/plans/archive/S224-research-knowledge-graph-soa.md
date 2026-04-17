# S224: Knowledge Graph SoA — Agent Memory Research (Abril 2026)

> Contexto: OLMO usa flat markdown (agent-memory/ + skills/) como sistema de memoria.
> Objetivo: avaliar se vale substituir/augmentar com knowledge graphs em 2026.
> Prior art: S210-research-persistent-memory.md (Abril 2026) — lido e incorporado aqui.

---

## 1. Executive Summary

O estado-da-arte em agent memory para 2026 e dominado por graphs temporais (Graphiti/Zep) e memory layers hibridas (Mem0), mas **nenhum deles supera flat-files em ROI para single-user de baixo volume** (<100 entries, Windows 11, custo zero). O sistema OLMO atual funciona para o escopo presente; os gaps reais sao semantic retrieval e staleness detection — ambos resolvíveis sem graphs completos. Graphiti/Zep so se justificam se OLMO escalar para 100+ entries ou precisar de queries temporais multi-session.

---

## 2. Comparison Matrix

| Dimensao | **Graphiti (Zep OSS)** | **Mem0 OSS** | **Letta (MemGPT v2)** | **LangGraph Memory** | **Zep Cloud** | **Flat-file wiki (OLMO atual)** |
|---|---|---|---|---|---|---|
| **Architecture** | Bi-temporal KG: entities + edges com valid_at/invalid_at. Episodic + semantic subgraph. Triple-store. | Hybrid: vector embeddings + optional graph + key-value. Extrai fatos de conversas via LLM. | Hierarquico OS-style: core memory (RAM), archival memory (disco), recall memory (log). Swapping entre tiers. | StateGraph com checkpointing. 3 tipos: semantic, episodic, procedural. Persistencia via checkpointer externo. | Managed Graphiti + context assembly. Adds domain entity models, compliance layer. | Markdown files planos. Index manual (MEMORY.md). Sem search semantico. |
| **Deployment** | Python 3.10+. Neo4j 5.26+ OR FalkorDB OR Kuzu (embedded, sem servidor). OpenAI API obrigatoria (default). Suporte Anthropic via pip extra. | pip install. OpenAI default. Qualquer LLM via config. Cloud ou local. Self-hosted MCP arquivado Mar 2026 — direcao cloud. | Docker + PostgreSQL (Letta Code CLI) ou API cloud. Mais pesado que Graphiti. MemFS (novo, git-tracked) em beta. | Python + langgraph + checkpointer (SQLite, PostgreSQL, Redis). Pode ser leve (SQLite). | SaaS. API key. SDK Python/TS/Go. Sem infra propria. | Zero infra. Git-tracked. Sem dependencias. |
| **Integration difficulty** | MEDIO-ALTO. MCP server existe (v1.0, Mar 2026). Kuzu nao documentado no MCP server (gap marketing vs realidade — S210 §2D). Windows: Docker Desktop ou Kuzu manual. | BAIXO (cloud) / MEDIO (self-hosted). pip + API key + MCP config = 5 min (cloud). | ALTO. Docker + PostgreSQL para self-host. API cloud mais simples mas lock-in. | MEDIO. Bem documentado mas requer escolher backend de persistencia. | BAIXO. API key + SDK. 5-10 min. | ZERO. Ja em uso. |
| **Cost (mensal)** | ~$2-5 OpenAI API (embedding + extraction). DB: $0 se Kuzu local. | $0 (free: 10k adds, 1k retrievals/mo) ou $249/mo (Pro com graph). Cloud lock-in. | Self-host: custo infra + LLM API. Cloud: preco nao divulgado. | $0 se SQLite. LLM API variavel. | Free tier (sem CC). Pricing nao publicado. SOC2+HIPAA disponivel. | $0 absoluto. |
| **Temporal awareness** | ALTO. Bi-temporal (event time + ingestion time). Invalida fatos antigos sem deletar. Queries: "o que era verdade em X data?" | NENHUMA (free). Graph Pro da relacoes mas sem temporalidade real. | BAIXA. Recency bias via swapping — sem timestamps explícitos nas relacoes. | MEDIA. Checkpointing captura estado por sessao, mas sem timestamps de validade de fatos. | ALTO. Igual Graphiti + entity resolution automatica. | NENHUMA. Staleness invisivel — maior gap atual do OLMO. |
| **Semantic search** | ALTO. Cosine similarity + BM25 full-text + graph traversal (3 engines combinados). P95 <300ms. | ALTO. Vector embeddings (text-embedding-3-small default). 26% melhor que OpenAI memory (LoCoMo — ver §3). | MEDIO. Archival via embedding search. Core memory: keyword. | MEDIO. Depende do backend. Pode integrar vector stores externas. | ALTO. Context assembly <200ms P95. LoCoMo benchmark: 58.44% (score corrigido — ver §3). | NENHUMA. Grep/string match apenas. |
| **Data sovereignty** | LOCAL (Kuzu/Neo4j self-hosted). Dados nunca saem da maquina. | CLOUD por default. Self-hosted MCP arquivado. Problematico para contexto medico. | Self-hosted possivel mas complexo. | LOCAL se SQLite checkpointer. | CLOUD (SaaS). SOC2+HIPAA mas dados no servidor deles. | LOCAL 100%. Git-tracked. |
| **Maturidade / Stars** | 25k stars, Apache 2.0. Ativo. MCP 1.0 Mar 2026. | 48k stars, Apache 2.0 (OSS). Ativo. | Fork do MemGPT (10k stars). Transicao para Letta V1 em andamento. | Parte do LangChain ecosystem (90k+ stars). Maduro. | Produto comercial sobre Graphiti. SOC2 Type II. | N/A — padrao de fato para Claude Code. |
| **Fit OLMO single-user** | BAIXO agora / ALTO se escalar. Overkill para 21 files. | MEDIO. Semantic retrieval e o unico beneficio real. Privacy concern bloqueia. | BAIXO. Arquitetura para multi-session agents com infra dedicada. Overhead excessivo. | MEDIO. LangGraph e framework de orquestracao, nao memoria isolavel facilmente. | BAIXO. SaaS, custo opaco, dados off-premise. | BASELINE. Funciona. Gaps conhecidos. |

---

## 3. Benchmark Reality Check (herdado de S210 §3)

**AVISO CRITICO:** Todos os benchmarks vendor-reported sao inflados. S210 documenta o dial481/locomo-audit:
- LoCoMo tem 6.4% de respostas douradas factualmente erradas (ceiling = 93.57%)
- LLM-judge aceita 63% de respostas intencionalmente erradas
- 56% dos comparativos por categoria sao estatisticamente indistinguiveis

**Numeros corrigidos (nao confiar nos numeros dos vendors):**
| Sistema | Claim vendor | Score corrigido / evidencia |
|---|---|---|
| Zep/Graphiti | 84% LoCoMo | 58.44% (auditado) |
| Mem0 | 66.9% LoCoMo | ~20% (Issue #3944, GPT-4o-mini) |
| ByteRover | 96.1% LoCoMo | Nao auditado independentemente |

**arXiv:2604.01707 (Abril 2026, independente):** Avaliou 10 sistemas em condicoes identicas com F1+BLEU-1. Zep falhou em completar no prazo de 2 dias. MemTree (36.92 F1) e MemOS (37.05 F1) lideraram. Mem0 melhora 18.6% F1 sobre MemoryBank em LongMemEval Multi-Session, mas numeros absolutos longe dos claims de marketing.

**Conclusao:** Nenhum sistema tem benchmark independente verificado robusto. Avaliar por solucao de problemas especificos do OLMO, nao por numeros de marketing.

---

## 4. OLMO Gap Analysis

### Sistema Atual
- **Localizacao:** `.claude/agent-memory/evidence-researcher/` (8 topic files + MEMORY.md index)
- **Skills relacionadas:** `/dream` (consolidacao), `/wiki-lint` (health check), `/wiki-query` (retrieval), `/knowledge-ingest` (ingestion)
- **Volume:** ~8 topic files de pesquisa medica, ~20KB total
- **Formato:** Markdown plano, PMID-verificado, versionado em Git

### O que funciona bem
1. **Data sovereignty total** — dados locais, Git-tracked, auditaveis
2. **Legibilidade humana** — Lucas pode inspecionar/editar qualquer arquivo
3. **Zero custo** — sem API keys, sem infra
4. **Portabilidade** — qualquer modelo futuro le os arquivos frios
5. **Provenance** — PMIDs verificados, timestamps de pesquisa no index
6. **Integracao Git** — historico de mudancas, reversao possivel
7. **Skills de manutenção** — /dream, /wiki-lint, /wiki-query formam um ciclo de vida funcional

### Gaps reais (nao hipoteticos)
1. **Semantic retrieval ausente** — busca e string match / grep. "Hipertensao portal" nao encontra "HVPG > 10mmHg". Este e o gap mais doloroso em escala.
2. **Staleness invisivel** — nenhuma marcacao de quando um fato foi supersedido. Um paper de 2022 pode contradizer guideline de 2025 sem warning.
3. **Cross-file linking fraco** — referencias entre topicos sao manuais (texto livre). Sem grafo de dependencias.
4. **Cap de 20 arquivos artificial** — regra administrativa, nao tecnica. Ja em 8 arquivos de pesquisa, proximo de triggers de consolidacao.
5. **Retrieval nao rankeado** — /wiki-query retorna contexto, mas sem score de relevancia. Modelo decide o que importa sem metadata de confianca.
6. **Sem decay** — memories antigas tem mesmo peso que recentes. Sem mecanismo de importancia decrescente.

### Quando os gaps se tornam bloqueadores
- **Agora:** Nao. 8 arquivos, <20KB, /wiki-query funciona adequadamente.
- **Em 30-50 arquivos:** Semantic retrieval vai ser bloqueador. String match em 50 arquivos de hepatologia vai gerar falsos negativos frequentes.
- **Em 100+ arquivos:** Staleness e cross-file linking vao criar inconsistencias nao detectadas.

---

## 5. Recommendations

### REC-1: AUGMENTAR com ByteRover CLI (Free) — ROI ALTO, agora

**O que e:** CLI com Context Tree hierarquico em markdown. 5-tier progressive retrieval (local → LLM). Adaptive Knowledge Lifecycle (decay, maturity). MCP-native. Arquivos continuam como markdown no disco.

**Por que supera graphs completos para OLMO:**
- Evolucao natural do sistema atual (mesmo formato, mesma portabilidade)
- Resolve semantic retrieval via LLM-curated search sem vector infra
- Resolve staleness via AKL lifecycle scoring
- $0 com propria LLM key (Claude/OpenAI)
- Setup 10 min, reversivel (arquivos persistem se desinstalar)
- Risco: Elastic License 2.0 (nao open source puro); startup pode pivotar

**Acao:** `npm i -g byterover-cli && brv init && brv mcp`. Avaliar 2 sessoes de pesquisa medica real.

**AMBIGUOUS:** Performance de semantic retrieval em terminologia medica especifica (hepatologia/elastografia) nao foi testada. ByteRover usa LLM-as-judge para retrieval — qualidade depende do modelo configurado.

---

### REC-2: IGNORAR Graphiti/Zep/Mem0/Letta/LangGraph — por enquanto

**Justificativa consolidada:**

| Sistema | Razao para ignorar agora |
|---|---|
| Graphiti | Overkill para 8 arquivos. Requer OpenAI API key. MCP/Kuzu path nao documentado. Revisar em 100+ entries. |
| Mem0 Cloud | Privacy concern critical: dados medicos em servidor deles. Self-hosted MCP arquivado Mar 2026. |
| Zep Cloud | SaaS, custo opaco, dados off-premise. HIPAA claim nao verificado independentemente. |
| Letta | Framework para multi-session agents com infra dedicada. Nao e uma biblioteca de memoria isolavel. |
| LangGraph | Framework de orquestracao, nao memoria standalone. Requer mudanca de toda a stack de agentes. |

**Quando revisar Graphiti:** Se OLMO escalar para 50+ topic files, precisar de queries temporais (ex: "o que sabiamos sobre MELD em 2024 vs 2026?"), ou construir sistema multi-agente com shared memory.

---

### REC-3: MONITORAR kuzu-memory e A-Mem — watch list

**kuzu-memory:** Graph embedding local, zero custo API, <3ms recall, setup one-command. 22 stars (Apr 2026) — risco de maturidade. Se chegar a 500+ stars com comunidade ativa, substituiria server-memory como baseline estruturado.

**A-Mem (Zettelkasten):** NeurIPS 2025, conceito elegante (notas auto-linked). MCP fork tem 6 stars — muito novo. Monitorar se ganhar tração; seria upgrade natural do wiki atual se o fork amadurecer.

**Karpathy Knowledge Bank (llm-wiki):** Arquitetura de referencia para flat-file AI memory. Confirma que o modelo OLMO atual e academicamente defensavel para single-user de baixo volume.

---

## 6. References

| Fonte | URL | Data de acesso |
|---|---|---|
| Graphiti GitHub | https://github.com/getzep/graphiti | 2026-04-17 |
| Zep paper (arXiv:2501.13956) | https://arxiv.org/abs/2501.13956 | 2026-04-17 |
| Zep Cloud | https://www.getzep.com/ | 2026-04-17 |
| Mem0 GitHub | https://github.com/mem0ai/mem0 | 2026-04-17 |
| Mem0 State of Memory 2026 | https://mem0.ai/blog/state-of-ai-agent-memory-2026 | 2026-04-17 |
| Mem0 paper (arXiv:2504.19413) | https://arxiv.org/abs/2504.19413 | 2026-04-17 |
| Letta GitHub | https://github.com/letta-ai/letta | 2026-04-17 |
| MemGPT paper (arXiv:2310.08560) | https://arxiv.org/abs/2310.08560 | 2026-04-17 |
| LangGraph memory docs | https://docs.langchain.com/oss/python/langgraph/overview | 2026-04-17 |
| LangGraph architecture guide | https://latenode.com/blog/ai-frameworks-technical-infrastructure/langgraph-multi-agent-orchestration/langgraph-ai-framework-2025-complete-architecture-guide-multi-agent-orchestration-analysis | 2026-04-17 |
| Neo4j Graphiti post | https://neo4j.com/blog/developer/graphiti-knowledge-graph-memory/ | 2026-04-17 |
| FalkorDB Graphiti guide | https://www.falkordb.com/blog/building-temporal-knowledge-graphs-graphiti/ | 2026-04-17 |
| AWS Mem0 + Neptune | https://aws.amazon.com/blogs/database/build-persistent-memory-for-agentic-ai-applications-with-mem0-open-source-amazon-elasticache-for-valkey-and-amazon-neptune-analytics/ | 2026-04-17 |
| Mem0 graph solutions blog | https://mem0.ai/blog/graph-memory-solutions-ai-agents | 2026-04-17 |
| Agent Memory Paper List (survey Dec 2025) | https://github.com/Shichun-Liu/Agent-Memory-Paper-List | 2026-04-17 |
| MAGMA (arXiv:2601.03236, Jan 2026) | https://arxiv.org/html/2601.03236v1 | 2026-04-17 |
| AriGraph (IJCAI 2025) | https://www.ijcai.org/proceedings/2025/0002.pdf | 2026-04-17 |
| A-Mem paper (arXiv:2502.12110) | https://arxiv.org/abs/2502.12110 | 2026-04-17 |
| Karpathy llm-wiki | https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f | 2026-04-17 |
| Karpathy VentureBeat coverage | https://venturebeat.com/data/karpathy-shares-llm-knowledge-base-architecture-that-bypasses-rag-with-an | 2026-04-17 |
| kuzu-memory GitHub | https://github.com/bobmatnyc/kuzu-memory | 2026-04-17 |
| ByteRover paper (arXiv:2604.01599) | https://arxiv.org/abs/2604.01599 | 2026-04-17 |
| ByteRover GitHub | https://github.com/campfirein/byterover-cli | 2026-04-17 |
| arXiv:2604.01707 (unified eval) | https://arxiv.org/abs/2604.01707 | 2026-04-17 |
| dial481 locomo-audit | https://github.com/dial481/locomo-audit | 2026-04-17 |
| Mem0 benchmark issue #3944 | https://github.com/mem0ai/mem0/issues/3944 | 2026-04-17 |
| DEV: markdown vs semantic graph | https://dev.to/eahm60/i-replaced-my-agents-markdown-memory-with-a-semantic-graph-1elp | 2026-04-17 |
| DEV: when markdown is enough | https://dev.to/imaginex/ai-agent-memory-management-when-markdown-files-are-all-you-need-5ekk | 2026-04-17 |
| S210 prior research | .claude/plans/archive/S210-research-persistent-memory.md | (OLMO internal) |
| S213 hooks+memoria SoA | .claude/plans/archive/S213-hooks-memory-state-of-art.md | (OLMO internal) |
