# S224: Memory / Dream / Wiki SOA — Sleep-Dream Consolidation, PKM, & Scaling Research
> Criado: 2026-04-17 | Contexto: OLMO memory excederá 20 files na próxima semana.
> Companion: `ACTIVE-S224-research-knowledge-graph-soa.md` (graphs, Graphiti, Mem0, ByteRover — não duplicar).
> Foco deste arquivo: sleep/dream consolidation em LLMs, PKM tools (Mem.ai, Reflect, Obsidian, Roam, Logseq), Semantic Kernel, scaling flat-file → 50 files.

---

## 1. OLMO Audit — Estado Atual (2026-04-17)

### 1.1 Estrutura de memória

| Componente | Localização | Volume atual |
|---|---|---|
| Evidence-researcher memory | `.claude/agent-memory/evidence-researcher/` | 8 topic files + MEMORY.md index |
| Reference-checker memory | `.claude/agent-memory/reference-checker/` | 1 audit file |
| Skills (projet-local) | `.claude/skills/` | 22 skills, nenhuma é dream/wiki-lint/wiki-query |
| Skills (built-in plugins) | Registradas via settings.json | `/dream`, `/wiki-lint`, `/wiki-query` |
| Plans | `.claude/plans/` | 4 ACTIVE + 1 BACKLOG |

**Observação crítica:** `/dream`, `/wiki-lint` e `/wiki-query` são skills built-in do Claude Code SDK
(plugin skills), não residem em `.claude/skills/`. A estrutura OLMO atual usa essas três skills como
ciclo de vida completo de memória: ingestão → consolidação (/dream) → health check (/wiki-lint) →
retrieval (/wiki-query).

### 1.2 O que cada skill faz

**`/dream` (Memory Consolidation)**
- Varre session transcripts em busca de correções, decisões, preferências, padrões
- Merge findings em memory files persistentes
- Auto-trigger via Stop hook a cada 24h
- Analogia: consolidação hipocampal durante sono REM
- Gap: não tem temporal awareness — não sabe se um fato foi supersedido

**`/wiki-lint` (Health Check — read-only)**
- Detecta contradições, orphans, broken links, stale claims, frontmatter gaps, index drift
- Reporta por severidade; NUNCA modifica arquivos
- Gap: opera sobre estrutura, não sobre semântica; não ranqueia relevância das issues

**`/wiki-query` (Retrieval — index-first)**
- Carrega "Load when" triggers, faz match com task context
- Carrega apenas páginas relevantes (não carrega tudo)
- Gap: retrieval por keyword/string match, sem embedding; sem score de confiança

### 1.3 Scaling concerns (dado que Lucas confirma >20 files em breve)

| Limiar | Risco identificado | Mecanismo de falha |
|---|---|---|
| **20-30 files** | `/wiki-query` começa a errar por sinonímia | "hipertensão portal" ≠ "HVPG >10mmHg" para grep |
| **30-50 files** | `/wiki-lint` reporta mais orphans que o usuário consegue processar | Alert fatigue; issues ignoradas |
| **50+ files** | Staleness invisível cria inconsistências não detectadas | Fato de 2022 contradiz guideline 2025 sem warning |
| **100+ files** | Cross-file linking manual colapsa | Dependências implícitas, propagação de erro |

**Evidência da literatura (DEV.to, 2026):** Grep/ripgrep permanece adequado até ~1.000 files para
exact keyword match. Degradação em recall começa em ~30-50 files para *queries conceituais*
(não literais). Ponto de inflexão real para OLMO: não é volume, é terminologia médica especializada
(hepatologia, elastografia) onde sinonímia e o problema central.

---

## 2. SOA Landscape

### 2.1 Sleep/Dream Consolidation em LLMs (2024-2026)

#### 2.1.1 SleepGate (arXiv:2603.14517, Mar 2026)
**Mecanismo:** Framework inspirado em sono que opera sobre KV cache de transformers.
Três componentes: (1) Conflict-aware temporal tagger — detecta quando entradas novas supersede
antigas via assinaturas semânticas + locality-sensitive hashing (O(1) amortized);
(2) Forgetting Gate — rede 2 camadas que atribui retention scores (keep/compress/evict);
(3) Consolidation Module — merge de entradas relacionadas via recency-biased weighted averaging
(análogo a hipocampal replay).

**Resultados:** 99.5% retrieval accuracy em PI depth 5; 97.0% em depth 10 (baselines <18%).
Reduz interference horizon de O(n) para O(log n).

**Aplicabilidade a OLMO:** DIRETA para inspiração conceitual; INDIRETA para implementação.
SleepGate opera sobre KV cache, não sobre arquivos externos. O mecanismo de "consolidation
module" é análogo ao que `/dream` faz manualmente — mas sem o temporal tagging automático.
**PROPOSTA DERIVADA:** Adicionar ao `/dream` um passo de conflict detection — antes de
consolidar, verificar se o novo fato contradiz um fato existente no mesmo arquivo.

#### 2.1.2 NeuroDream (Tutuncuoglu, SSRN:5377250, Dez 2024)
**Mecanismo:** Fase de sonho explícita no pipeline de treino. O modelo desconecta de dados de
entrada e engaja em simulações geradas internamente a partir de embeddings latentes — rehearsal,
consolidation, abstraction sem re-exposição aos dados brutos.

**Resultados:** 38% redução em forgetting, 17.6% aumento em zero-shot transfer, robustez a
noise/domain drift. Sequência: treino → dream phase periódica → consolidação → novo treino.

**Aplicabilidade a OLMO:** Inspiração para `/dream` periódico. A ideia de "simulação interna
baseada em embeddings" é análoga a: durante a dream run, o agente deveria *gerar queries de
teste* sobre o conteúdo existente e verificar se consegue respondê-las corretamente — detectando
lacunas antes que se tornem problemas.

#### 2.1.3 "Language Models Need Sleep" (OpenReview:iiZy6xyVVE — acesso 403)
**Status:** Abstract público indica que propõe Sleep em duas fases: Memory Consolidation
(parameter expansion + RL-based upward distillation = "Knowledge Seeding") e Dreaming
(auto-modification). **AMBIGUOUS:** Não foi possível verificar resultados completos (acesso restrito).

#### 2.1.4 ICLR 2026 MemAgents Workshop (Jan-Apr 2026)
**Contexto:** Workshop dedicado a memory layer para LLM agents, cobrindo arquiteturas episódic/
semantic/working, explicit vs. in-weights memory, semantic retrieval em escala.
**Paper relevante — SimpleMem (arXiv:2601.02553):** Three-stage pipeline:
(1) Semantic Structured Compression → compacta interações em memory units multi-indexed;
(2) Online Semantic Synthesis → consolidação intra-sessão elimina redundância;
(3) Intent-Aware Retrieval Planning → infere search intent para retrieval preciso.
Resultados: F1 +26.4%, token consumption -30x. Usa LanceDB (vector) + SQLite (sessões).
**Não adequado para OLMO** (requer API embeddings, arquitetura agent-centric).

#### 2.1.5 A-MAC: Adaptive Memory Admission Control (arXiv:2603.04549, ICLR 2026 MemAgents)
**Mecanismo:** Decompõe valor de memória em 5 fatores interpretáveis: future utility, factual
confidence, semantic novelty, temporal recency, content type prior. Combina rule-based feature
extraction + single LLM utility assessment.
**Resultados:** F1 0.583 no LoCoMo; latência -31% vs. LLM-native systems.
**Aplicabilidade a OLMO:** O fator "content type prior" (mais influente) é implementável em
flat-file sem vector infra — `/dream` poderia classificar cada novo fato por tipo (factual claim,
procedural rule, preference, decision) e aplicar admission thresholds diferentes.

#### 2.1.6 SSGM Framework (arXiv:2603.11768, Mar 2026)
**Mecanismo:** Stability and Safety-Governed Memory. Decouples memory evolution from governance
via middleware. Dual-track storage: mutable active graph + immutable episodic log. Truth
Maintenance System valida updates contra core facts. Weibull decay function para temporal
freshness. Reconciliation periódico replays correções contra o immutable ledger.
**Aplicabilidade a OLMO:** O conceito de "immutable episodic log" é o Git! OLMO já tem isso.
O gap é o Weibull decay — OLMO não tem mecanismo de freshness scoring por fato individual.

---

### 2.2 Zep / Graphiti — Temporal Facts (cobertura expandida de S224-KG)

(Ver `ACTIVE-S224-research-knowledge-graph-soa.md` §2 para matriz completa.)
**Adição específica para este arquivo — temporal decay:**
Bi-temporal modeling (valid_at + transaction_at) resolve o staleness invisível do OLMO.
P95 graph search: 150ms (após otimizações late 2025, down from 600ms).
**Conclusão:** Temporal awareness de Graphiti é o modelo conceitual correto para o gap de staleness
do OLMO. Implementação de Graphiti completa é overkill, mas o padrão de dois timestamps por fato
(quando foi verdade + quando foi ingerido) é implementável em frontmatter YAML dos arquivos.

---

### 2.3 Mem.ai e Reflect — PKM com AI

#### Mem.ai
**Arquitetura:** Cloud-first, AI-first. Auto-organização por LLM — zero folders necessários.
Mem Chat permite queries em linguagem natural sobre toda a base. $12/month Pro.
**Gap crítico para OLMO:** Dados processados remotamente em servidores Mem.ai. Inaceitável para
conteúdo médico com identificadores de pacientes ou dados sensíveis. Sem local-first option.

#### Reflect
**Arquitetura:** Zero-knowledge sync — servidores Reflect não acessam conteúdo dos usuários.
End-to-end encryption. Bidirectional linking ([[double brackets]]). AI só para writing assistance,
não para organização automática. $10/month.
**Relevância para OLMO:** Filosofia "Reflect" (controle intencional + privacy-by-design) é
mais alinhada com os valores OLMO do que "Mem" (automação maximalista). O padrão de
[[double brackets]] para linking é implementável em markdown plano sem ferramentas externas.
**Limitação:** Nem Mem nem Reflect são truly local-first. Ambos requerem conectividade.

---

### 2.4 Obsidian + Smart Connections — Graph Structure

**Smart Connections Plugin (Jan 2026):**
- 786,090 downloads, plugin AI mais popular do Obsidian
- RAG sobre vault completo: chat com notas, semantic search via embeddings
- Suporte: GPT-4, Gemini, Claude, modelos locais (Ollama)
- Smart Connections Visualizer: force-directed graph com relevância como proximidade
- MCP server disponível: Claude Code pode fazer semantic search via `smart-connections` MCP

**Relevância para OLMO:**
O padrão Obsidian (vault de markdown + Smart Connections MCP + Claude Code) é funcionalmente
equivalente ao que OLMO precisa — sem mudar o formato dos arquivos. O MCP server exporia
as `.claude/agent-memory/` files com semantic search para Claude Code diretamente.
**PROPOSTA:** Avaliar `smart-connections` MCP apontado para `.claude/agent-memory/` como
semantic retrieval layer sobre o sistema atual. Setup: instalar Obsidian, apontar vault para
`.claude/agent-memory/`, instalar Smart Connections, habilitar MCP.
Custo: $0 (Smart Connections tem tier free). Risco: adiciona Obsidian como dependência.

---

### 2.5 Semantic Kernel — Abordagem Microsoft

**Memory Architecture (Maio 2025, experimental):**
Dois providers de memória: (1) **Whiteboard Provider** — extrai requirements, proposals,
decisions, actions de cada mensagem; retém para contexto de longo prazo; suporta truncação de
chat history sem perder contexto crítico. (2) **Mem0 Provider** — integração com Mem0 cloud
para memória cross-thread.

**Microsoft Agent Framework 1.0 (Abril 7, 2026):** Merge de Semantic Kernel + AutoGen em SDK único.
Foundry Agent Service inclui long-term memory persistente (chat summaries, user preferences,
key tasks) integrado ao runtime.

**Aplicabilidade a OLMO:**
O padrão Whiteboard é análogo ao que `/dream` deveria fazer a cada sessão: extrair structured
decisions/actions e guardá-las separadamente dos fatos brutos. O `/dream` atual consolida tudo
junto — separar "decisions" de "factual claims" aumentaria a precisão do `/wiki-query`.
**PROPOSTA DERIVADA:** Adicionar ao `/dream` uma seção `## Decisions` separada de `## Facts`
em cada topic file, espelhando o padrão Whiteboard do Semantic Kernel.

---

### 2.6 Roam Research / Logseq — Block Granularity e Bidirectional Linking

#### Roam Research
**Status (2026):** $15/month, desenvolvimento lento, mobile limitado. Pioneiro em block-level
bidirectional linking. Cada bloco referenciável individualmente. Queries sobre o graph.
**Relevância para OLMO:** Conceito de block-level references é superior a file-level references
para memória médica densa. Um parágrafo sobre "MELD 3.0" pode ser referenciado de um arquivo
sobre "CSPH" sem duplicar conteúdo. **Não implementado no OLMO atual.**

#### Logseq
**Status (2026):** Open source, local-first, free. Mesmo modelo de daily notes + block references
que Roam. DB version (em desenvolvimento ativo) introduz:
- Semantic Search via HNSWLIB local (WebGPU — desktop)
- Plugin marketplace: `logseq-plugin-semantic-search` usa Ollama (`nomic-embed-text`) — zero API cost
- MCP server: `mcp-logseq` para Claude Code interagir com graph via HTTP API

**Logseq DB Version como upgrade path para OLMO:**
Migrar `.claude/agent-memory/` para um Logseq graph (DB version) daria:
- Block-level bidirectional linking automático
- Semantic search local sem API (via Ollama)
- MCP integration com Claude Code
- Custo: $0, dados locais, Git-trackable (Logseq exporta markdown)
**Risco:** Logseq DB version ainda em desenvolvimento; formato proprietário no DB mode.
**AMBIGUOUS:** Maturidade do MCP server (`mcp-logseq`, 2026) não verificada independentemente.

---

### 2.7 MemSearch by Zilliz — Markdown-First com Shadow Index

**Arquitetura:**
- Markdown files como source of truth (humano-editável, Git-versionável)
- Milvus Lite como "shadow index" — derivado, reconstruível, nunca o canonical store
- Hybrid search: dense vectors + BM25 + RRF reranking (89% recall vs. 76% vector-only, 68% BM25-only)
- ONNX embeddings locais (zero API cost, CPU)
- SHA-256 content hashing para dedup — só reindexá arquivos alterados

**Por que isso é diferente de Graphiti/Mem0:**
MemSearch NÃO substitui os markdown files — eles continuam sendo a fonte canônica.
O vector index é um cache derivado. Se o sistema quebrar, os arquivos markdown continuam
sendo legíveis. Filosofia identica ao OLMO atual, com semantic retrieval adicionado.

**Aplicabilidade a OLMO:** ALTA. É exatamente a evolução natural: mesmo formato, mesma
portabilidade, semantic retrieval adicionado sem lock-in. Setup: `pip install memsearch` +
configurar Milvus Lite (single file, zero server). Integração com Claude Code via MCP.
Custo: $0 se ONNX local; mínimo se OpenAI embeddings.
**Gap:** Maturidade do projeto (GitHub recente, poucas stars — verificar antes de adotar).

---

## 3. Gaps OLMO dado crescimento 20→50 files

| Gap | Urgência (20 files) | Urgência (30 files) | Urgência (50 files) |
|---|---|---|---|
| Semantic retrieval ausente | BAIXA | MEDIA | ALTA — bloqueador |
| Staleness invisível | BAIXA | MEDIA | ALTA — inconsistências ativas |
| Conflict detection no /dream | BAIXA | MEDIA | ALTA |
| Block-level references | BAIXA | BAIXA | MEDIA |
| Decay/freshness scoring | BAIXA | BAIXA | MEDIA |
| Alert fatigue no /wiki-lint | BAIXA | MEDIA | ALTA |

**Conclusão:** A curto prazo (20→30 files), o sistema atual é sustentável. O gap que se tornará
bloqueador primeiro NÃO é performance (grep é rápido até 1.000 files) mas sim RECALL SEMÂNTICO
— queries sobre terminologia médica especializada que o grep não consegue fazer sinonímia.

---

## 4. Proposals Concretas

### PROP-1: Augmentar `/dream` com Conflict Detection (inspirado em SleepGate + SSGM)
**O que:** Antes de consolidar um novo fato, `/dream` verifica se ele contradiz um fato existente
no mesmo arquivo topic via string/keyword match.
**Como:** Adicionar passo no skill `/dream`: para cada novo claim, buscar no arquivo target por
termos chave; se encontrar afirmação anterior com negação ou valor diferente, marcar como
CONFLICT e não consolidar automaticamente — surfacear para Lucas.
**Custo:** Zero. Implementado em lógica do skill, sem infra adicional.
**Inspiração:** SleepGate conflict-aware temporal tagger + SSGM Truth Maintenance System.
**Impacto:** Resolve staleness invisível sem mudar formato dos arquivos.

### PROP-2: Adicionar bi-temporal frontmatter aos topic files (inspirado em Graphiti/Zep)
**O que:** Cada claim nos topic files ganha dois timestamps em frontmatter YAML:
`valid_from` (quando o fato se tornou verdade) e `ingested_at` (quando foi adicionado ao arquivo).
**Como:** `/dream` popula esses campos ao consolidar. `/wiki-lint` detecta claims sem timestamps
e os marca como staleness-risk.
**Custo:** Zero — frontmatter YAML em markdown plano, Git-tracked.
**Impacto:** Resolve staleness sem infraestrutura adicional; modelo conceitual correto para escalar.

### PROP-3: MemSearch como semantic retrieval layer (Markdown-first, zero lock-in)
**O que:** Instalar MemSearch apontado para `.claude/agent-memory/`. Milvus Lite como shadow index.
ONNX embeddings locais (zero API cost). Hybrid search: dense + BM25 + RRF.
**Como:**
```bash
pip install memsearch
# Configurar apontando para .claude/agent-memory/
# Ativar MCP para Claude Code
```
**Custo:** ~$0 (ONNX local). Risco: maturidade do projeto.
**Impacto:** `/wiki-query` passa a usar semantic search em vez de grep. PROP-3 é complementar
(não substitui) PROP-1 e PROP-2.
**Dependência:** Verificar maturidade/stars do GitHub antes de adotar. Se imatura, avaliar
MemSearch vs. Smart Connections MCP (Obsidian) como alternativa.

**Alternativa a PROP-3 se MemSearch imatura:** Smart Connections MCP apontado para o vault
(Obsidian + plugin). Mesma filosofia local-first, projeto mais maduro (786k downloads).

---

## 5. Decision Tree para Lucas

```
Agora (20 files):
  → PROP-1 (conflict detection no /dream) — implementar. Custo zero, impacto imediato.
  → PROP-2 (bi-temporal frontmatter) — aplicar em novos files. Retrofitting gradual.
  → PROP-3 (MemSearch) — AVALIAR maturidade do GitHub antes de instalar.

Em 30 files:
  → Se PROP-3 adotada: integrar ao /wiki-query.
  → Se não adotada: definir alternativa (Smart Connections MCP ou ByteRover).

Em 50 files:
  → Semantic retrieval obrigatório (PROP-3 ou alternativa).
  → Reavaliar Logseq DB version (bloquear se ainda imatura).
  → Reavaliar Graphiti se queries temporais multi-sessão forem necessárias.
```

---

## 6. References

| Fonte | URL | Data de acesso |
|---|---|---|
| SleepGate (arXiv:2603.14517) | https://arxiv.org/abs/2603.14517 | 2026-04-17 |
| SleepGate HTML | https://arxiv.org/html/2603.14517 | 2026-04-17 |
| NeuroDream (SSRN:5377250) | https://papers.ssrn.com/sol3/papers.cfm?abstract_id=5377250 | 2026-04-17 |
| Dream-Augmented NNs (SSRN:5402490) | https://papers.ssrn.com/sol3/papers.cfm?abstract_id=5402490 | 2026-04-17 |
| ICLR 2026 MemAgents Workshop | https://sites.google.com/view/memagent-iclr26/ | 2026-04-17 |
| SimpleMem (arXiv:2601.02553) | https://arxiv.org/abs/2601.02553 | 2026-04-17 |
| A-MAC (arXiv:2603.04549) | https://arxiv.org/abs/2603.04549 | 2026-04-17 |
| SSGM (arXiv:2603.11768) | https://arxiv.org/html/2603.11768v1 | 2026-04-17 |
| Zep paper (arXiv:2501.13956) | https://arxiv.org/abs/2501.13956 | 2026-04-17 |
| Zep Cloud | https://www.getzep.com/ | 2026-04-17 |
| Mem.ai overview | https://www.salesforge.ai/directory/sales-tools/mem-ai | 2026-04-17 |
| Mem vs Reflect comparison | https://aloa.co/ai/comparisons/ai-note-taker-comparison/mem-vs-reflect | 2026-04-17 |
| Smart Connections GitHub | https://github.com/brianpetro/obsidian-smart-connections | 2026-04-17 |
| Smart Connections app | https://smartconnections.app/ | 2026-04-17 |
| Obsidian AI guide 2026 | https://www.fahimai.com/how-to-use-obsidian-ai | 2026-04-17 |
| Semantic Kernel memory docs | https://learn.microsoft.com/en-us/semantic-kernel/frameworks/agent/agent-memory | 2026-04-17 |
| Microsoft Agent Framework 1.0 | https://www.openaitoolshub.org/en/blog/microsoft-agent-framework-review | 2026-04-17 |
| Roam Research alternatives 2026 | https://get-alfred.ai/blog/best-roam-research-alternatives | 2026-04-17 |
| Logseq semantic search plugin | https://github.com/twaugh/logseq-plugin-semantic-search | 2026-04-17 |
| Logseq MCP server | https://github.com/ergut/mcp-logseq | 2026-04-17 |
| Logseq DB version semantic search | https://discuss.logseq.com/t/logseq-db-changelog/30013/28 | 2026-04-17 |
| MemSearch GitHub (Zilliz) | https://github.com/zilliztech/memsearch | 2026-04-17 |
| Markdown memory when enough? (DEV) | https://dev.to/imaginex/ai-agent-memory-management-when-markdown-files-are-all-you-need-5ekk | 2026-04-17 |
| Markdown → semantic search evolution | https://medium.com/@tglaraujo/how-my-agents-memory-evolved-from-a-markdown-file-to-semantic-search-in-practice-28043c85d329 | 2026-04-17 |
| Databricks memory scaling | https://www.databricks.com/blog/memory-scaling-ai-agents | 2026-04-17 |
| Markdown paradigm AI agents | https://micheallanham.substack.com/p/the-markdown-memory-paradigm-in-ai | 2026-04-17 |
| Markdown vs semantic graph (DEV) | https://dev.to/eahm60/i-replaced-my-agents-markdown-memory-with-a-semantic-graph-1elp | 2026-04-17 |
| Agent Memory Paper List survey | https://github.com/Shichun-Liu/Agent-Memory-Paper-List | 2026-04-17 |
