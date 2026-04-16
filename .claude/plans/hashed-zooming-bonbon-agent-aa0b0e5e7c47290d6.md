# Persistent Memory Solutions for Claude Code — Research Report (April 2026)

**Context:** Current system uses flat markdown (21 files, ~20KB, wiki-index v1). Problems: 200-line cap, no semantic retrieval, staleness invisible, context lost on compaction, no cross-session learning.

---

## 1. Comparison Table

| Criterion | @mcp/server-memory | ByteRover CLI | Mem0 Cloud (Free) | Graphiti + Kuzu | A-Mem MCP | kuzu-memory (bonus) |
|---|---|---|---|---|---|---|
| **Setup time** | 5 min | 10 min | 5 min | 30-60 min | 20-30 min | 10 min |
| **Monthly cost** | $0 | $0 (local) / $19 (Pro+cloud) | $0 (10k adds, 1k retrieval/mo) | $0 (needs OpenAI key ~$2-5/mo) | $0 (needs Ollama or OpenRouter) | $0 (no LLM needed) |
| **Integration** | MCP native (npx) | MCP (`brv mcp`) + npm | MCP (pip install) | MCP (Python, Docker optional) | MCP (Python) | MCP + hooks (npm) |
| **Windows 11** | Yes | Yes (npm) | Yes (pip) | Partial (Docker Desktop) | Yes (Python) | Yes (cross-platform) |
| **Infra required** | None (JSONL file) | None (markdown files) | Cloud API (OpenAI embedding on their side) | OpenAI API key + Kuzu embedded | Ollama or OpenRouter | None |
| **Semantic retrieval** | No (string match only) | Yes (5-tier: local→LLM) | Yes (vector embeddings) | Yes (graph + embedding) | Yes (ChromaDB + graph) | No (pattern matching, <3ms) |
| **Temporal awareness** | No | Yes (AKL lifecycle) | No (free tier) | Yes (bi-temporal graph) | No | Yes (decay, reinforcement) |
| **Data sovereignty** | Local JSONL | Local markdown | Cloud (mem0.ai servers) | Local (Kuzu file) | Local (NetworkX + ChromaDB) | Local (Kuzu DB <10MB) |
| **Stars (GitHub)** | 83.8k (parent repo) | 4.5k | 48k (mem0 org) | 25k | 853 (paper) / 6 (MCP) | 22 |
| **Last active** | Maintained (Anthropic) | Apr 15, 2026 (v3.5.0) | Active (self-hosted MCP archived Mar 2026 → cloud only) | Mar 2026 (MCP 1.0) | Active (paper repo) / Active (MCP fork) | Apr 9, 2026 (v1.12.9) |
| **License** | MIT | Elastic License 2.0 | Apache 2.0 (OSS) / Proprietary (cloud) | Apache 2.0 | MIT | MIT |
| **Benchmark (self-reported)** | N/A | 96.1% LoCoMo | 66.9% LoCoMo | 94.8% DMR (Zep paper) | "Superior to SOTA" (paper) | N/A |

---

## 2. Per-Solution Deep Dive

### 2A. @modelcontextprotocol/server-memory (Official Anthropic)

**What it is:** Reference MCP server from Anthropic. Stores entities + relations + observations in a local JSONL file. Exposes 9 tools (create_entities, create_relations, add_observations, delete_*, read_graph, search_nodes, open_nodes).

**What it solves vs flat files:**
- Persistent structured data (entities + relations, not just text)
- MCP-native — Claude Code discovers tools automatically
- Zero config, zero cost

**What it does NOT solve:**
- No semantic search (string matching only, like grep)
- No temporal awareness, no decay, no lifecycle
- No embedding, no vector retrieval
- Scales poorly with large graphs (JSON parsing issues reported, Issue #2689)
- Essentially flat files in JSON format — not materially better than current wiki

**Setup:** `npx @modelcontextprotocol/server-memory` in MCP config. Done.

**Verdict:** Too primitive. Lateral move from current flat files, not an upgrade. The structured entity model is marginally useful but the lack of semantic retrieval makes it equivalent to what you already have.

---

### 2B. ByteRover CLI

**What it is:** Commercial CLI tool (formerly Cipher) that implements the arXiv:2604.01599 paper. Hierarchical "Context Tree" stored as local markdown files. The LLM itself curates memory (ADD/UPDATE/UPSERT/MERGE/DELETE as tool calls).

**Architecture:** 5-tier progressive retrieval: file index → keyword → section scan → LLM summary → agentic reasoning. Most queries resolve at tiers 1-2 (<100ms, no LLM call).

**What it solves vs flat files:**
- Semantic retrieval (LLM-curated, not vector-based)
- Hierarchical organization (Domain > Topic > Entry)
- Adaptive Knowledge Lifecycle (importance scoring, maturity tiers, recency decay)
- Provenance tracking per entry
- Human-readable (markdown files on disk — you can inspect/edit)
- Direct evolution from your current flat-file approach

**Benchmark caveat:** 96.1% LoCoMo is self-reported by ByteRover authors using their own harness with Gemini 3 Flash as judge. LoCoMo audit found 6.4% of answers are wrong (ceiling = 93.57%), LLM judge accepts 63% of intentionally wrong answers, and 56% of per-category comparisons are statistically indistinguishable. ByteRover was NOT included in the independent audit (dial481/locomo-audit) or the arXiv:2604.01707 unified evaluation. Their numbers are plausible but unverified.

**Pricing:**
- Free: local-only, limited built-in LLM credits, no cloud sync. Full CLI access.
- Pro ($19/mo): 4,500 credits/mo, cloud sync, context management.
- You can use your own LLM provider (OpenAI/Anthropic key) on free tier — credits are only for ByteRover's built-in provider.

**License concern:** Elastic License 2.0 — not truly open source. Cannot offer as competing service, cannot modify and redistribute commercially. Fine for personal use.

**Setup:** `npm install -g byterover-cli && brv init && brv mcp` then add to .mcp.json. ~10 min.

---

### 2C. Mem0 Cloud (Free Tier)

**What it is:** Cloud-hosted memory API. Stores memories as vector embeddings on mem0.ai servers. MCP integration via `pip install mem0-mcp-server`.

**Free tier limits:** 10,000 add requests/mo + 1,000 retrieval requests/mo. No graph memory (Pro at $249/mo). No analytics.

**What it solves vs flat files:**
- True semantic retrieval (vector embeddings — paraphrase-robust)
- Cross-client memory (Cursor, Claude Code, Windsurf share memories)
- Simple setup (5 min, no Docker)

**What it does NOT solve:**
- No temporal awareness on free tier
- No graph memory on free tier
- Data lives on mem0.ai cloud (privacy concern for medical context)
- 1,000 retrievals/mo is tight for active Claude Code usage (~30-50 retrievals/session x 20 sessions = 600-1000/mo)
- Self-hosted MCP repo ARCHIVED (Mar 2026) — cloud lock-in is the direction

**Benchmark reality:** Mem0 claims 66.9% LoCoMo. Independent reproduction (Issue #3944): 0.20 LLM score with GPT-4o-mini due to timestamp handling bug. arXiv:2604.01707 independent evaluation found Mem0 improves 18.6% F1 over MemoryBank on LongMemEval Multi-Session, but absolute numbers are far below vendor claims. LoCoMo audit found Zep's corrected score is 58.44% (vs claimed 84%), suggesting all vendor-reported LoCoMo numbers are inflated.

**Setup:** pip install, get API key from app.mem0.ai, add to .mcp.json with env var. 5 min.

---

### 2D. Graphiti + Kuzu (Embedded)

**What it is:** Temporal knowledge graph engine by Zep. Bi-temporal model (valid time + transaction time). Entities, relations, and episodes with timestamps. Supports Kuzu as embedded DB (no Neo4j required).

**Critical finding:** The Graphiti MCP server README lists FalkorDB (default) and Neo4j only — Kuzu is NOT listed as supported in the MCP server config. graphiti-core[kuzu] works at the Python API level, but wiring it through the MCP server may require custom config. This is a gap between marketing ("supports Kuzu!") and MCP reality.

**What it solves vs flat files:**
- True temporal knowledge graph (when was X true? has X changed?)
- Semantic search + graph traversal
- Bi-temporal queries (what did we know on date Y?)
- Episode management (session-level context)
- Most sophisticated data model of all options

**What it does NOT solve easily:**
- Requires OpenAI API key for LLM operations (embedding + extraction) — ~$2-5/mo
- Setup complexity: Python 3.10+, uv, Docker Compose (default), or manual Kuzu config
- MCP server + Kuzu integration is not documented as a supported path
- Overkill for 21 files / 20KB of memory data
- Windows: Docker Desktop required for default setup

**Stars:** 25k (Apache 2.0). Active maintenance. MCP 1.0 released Mar 2026.

**Setup:** 30-60 min. Clone repo, configure YAML, set up database, install dependencies, run MCP server. Not trivial.

---

### 2E. A-Mem (Zettelkasten) + MCP Fork

**What it is:** NeurIPS 2025 paper (arXiv:2502.12110) implementing Zettelkasten-style memory for LLM agents. Original repo (WujiangXu/A-mem, 853 stars) is research code — no MCP. A third-party MCP fork exists (tobs-code/a-mem-mcp-server, 6 stars).

**Architecture:** Notes with keywords, tags, contextual descriptions. Semantic retrieval via ChromaDB + graph traversal (NetworkX/RustworkX). 15 MCP tools. "Memory Enzymes" for background maintenance.

**What it solves vs flat files:**
- Semantic retrieval (ChromaDB vectors + graph)
- Zettelkasten linking (notes reference each other)
- Dynamic reorganization ("Memory Enzymes")
- Academic rigor (NeurIPS 2025 peer review)

**What it does NOT solve easily:**
- MCP fork has 6 stars — essentially one person's project
- Requires Ollama (local LLM) or OpenRouter — LLM calls for every memory operation
- ChromaDB dependency adds complexity
- No independent benchmarks on the MCP implementation
- Research-grade code, not production-hardened

**Not included in arXiv:2604.01707 unified evaluation.** Paper benchmarks are on research datasets, not real-world coding memory.

**Setup:** 20-30 min. Clone, pip install, configure .env (Ollama or OpenRouter), add to MCP config.

---

### 2F. BONUS: kuzu-memory (Lightweight Embedded Graph)

**What it is:** Standalone embedded graph memory using Kuzu DB. NOT Graphiti — independent project. MIT license, 22 stars, last release Apr 9, 2026.

**Key differentiator:** No LLM API calls required for core operations. Uses pattern matching + local NER. Memory recall <3ms. Database <10MB. Optional Haiku reranking.

**What it solves vs flat files:**
- Graph-based memory (entities + relations)
- Cognitive memory types (semantic, procedural, episodic, emotional, reflective)
- Temporal decay + reinforcement
- Offline-first, zero API cost
- Claude Code integration via MCP + hooks
- One-command setup: `kuzu-memory install claude-code`

**Limitations:**
- 22 stars — very new, single maintainer
- No semantic/vector retrieval (pattern matching only)
- No academic benchmarks
- Maturity risk

---

## 3. Benchmark Reality Check

**LoCoMo is unreliable.** The dial481/locomo-audit found:
- 99 of 1,540 golden answers are factually wrong (6.4%)
- Theoretical ceiling = 93.57% (not 100%)
- LLM judge accepts 63% of intentionally wrong answers
- 56% of per-category comparisons are statistically indistinguishable
- EverMemOS reported 92.32% but third-party reproduction got 38.38%
- Zep corrected from 84% → 58.44%
- Mem0 corrected from 66.9% → ~20% (Issue #3944)

**arXiv:2604.01707 (independent, April 2026):** Evaluated 10 systems under identical conditions with F1+BLEU-1. Top scorers: MemTree (36.92 F1), MemOS (37.05 F1), authors' method (38.79 F1) on LoCoMo with Qwen2.5-7B. Zep failed to complete within 2-day timeframe. ByteRover and A-Mem were NOT included.

**Bottom line:** No memory system has a reliable, independently verified benchmark score. All vendor numbers should be treated as marketing. The real question is: does it solve YOUR specific problems?

---

## 4. ROI Ranking for Solo Developer (Windows 11, $0 preferred)

### Tier 1: Best ROI — Do First

**1. ByteRover CLI (Free tier)** — ROI: HIGH
- Why: Direct evolution of your flat-file approach. Markdown on disk. Hierarchical. LLM-curated. MCP native. 10-min setup.
- Solves: semantic retrieval, staleness (AKL lifecycle), context loss (persistent tree), cross-session learning (agent curates knowledge per session).
- Cost: $0 with your own LLM key. $19/mo only if you want cloud sync.
- Risk: Elastic License 2.0, startup company (campfirein), could pivot/paywall.
- Action: `npm i -g byterover-cli && brv init && brv mcp`. Evaluate for 2 sessions.

### Tier 2: Solid Alternative

**2. kuzu-memory** — ROI: MEDIUM-HIGH
- Why: Zero LLM cost, <3ms recall, embedded graph, one-command Claude Code setup.
- Solves: structured memory, temporal decay, cognitive types, graph relations.
- Does not solve: semantic retrieval (pattern matching only — same grep limitation).
- Cost: $0 absolute. No API keys.
- Risk: 22 stars, single maintainer, maturity unknown.
- Action: `npm i -g kuzu-memory && kuzu-memory install claude-code`. Quick test.

**3. Mem0 Cloud (Free)** — ROI: MEDIUM
- Why: True semantic retrieval. Cross-client. 5-min setup.
- Solves: paraphrase-robust search (the ONE thing flat files can't do).
- Cost: $0 (1k retrievals/mo may be tight).
- Risk: Cloud lock-in, data sovereignty (medical context!), archived self-hosted repo.
- Action: pip install, get API key, add to .mcp.json. Test semantic retrieval quality.

### Tier 3: Worth Watching, Not Now

**4. Graphiti + Kuzu** — ROI: LOW (for current scale)
- Why: Most powerful data model, but overkill for 21 files.
- When: If you scale to 100+ memory entries, need temporal queries across sessions, or build a multi-agent system with shared memory.
- Blocker: MCP server does not officially support Kuzu backend. Requires OpenAI API key.

**5. A-Mem MCP** — ROI: LOW
- Why: Interesting academic concept (Zettelkasten), but MCP fork has 6 stars, requires Ollama, and adds ChromaDB + NetworkX dependencies for marginal gain over ByteRover.
- When: If ByteRover disappoints and you want a self-hosted semantic solution.

**6. @mcp/server-memory** — ROI: NEGATIVE
- Why: Lateral move. JSONL entities are not meaningfully better than your current MEMORY.md + topic files. No semantic search. No temporal awareness.
- Never: Unless you want structured entity storage for a different use case.

---

## 5. Recommendation

**Start with ByteRover CLI (free).** It is the natural evolution of your flat-file wiki system:
- Same storage format (markdown on disk)
- Adds what you lack (semantic retrieval, lifecycle, hierarchy, decay)
- Zero infra, zero cost with own LLM key
- 10-minute setup, reversible (markdown files stay if you uninstall)
- MCP native → Claude Code sees it as tools

**If ByteRover's semantic retrieval is weak** (it uses LLM-curated search, not vectors — could be slow/expensive on complex queries), **add Mem0 Cloud free tier** as a secondary semantic layer. The two can coexist: ByteRover for structured project memory, Mem0 for cross-session semantic recall.

**Monitor kuzu-memory** as the zero-dependency graph option. If it matures (needs more stars, testing, community), it could replace server-memory as the baseline.

**Defer Graphiti** until your memory needs exceed ~100 entries or you need true temporal queries.

---

## Sources

- [ByteRover paper (arXiv:2604.01599)](https://arxiv.org/abs/2604.01599)
- [ByteRover CLI GitHub](https://github.com/campfirein/byterover-cli)
- [ByteRover pricing](https://www.byterover.dev/pricing)
- [Mem0 pricing](https://mem0.ai/pricing)
- [Mem0 Claude Code setup](https://mem0.ai/blog/claude-code-memory)
- [Mem0 benchmark issue #3944](https://github.com/mem0ai/mem0/issues/3944)
- [Mem0 MCP archived](https://github.com/mem0ai/mem0-mcp)
- [Graphiti GitHub](https://github.com/getzep/graphiti)
- [Graphiti Kuzu config](https://help.getzep.com/graphiti/configuration/kuzu-db-configuration)
- [Graphiti MCP server](https://github.com/getzep/graphiti/blob/main/mcp_server/README.md)
- [A-Mem paper (arXiv:2502.12110)](https://arxiv.org/abs/2502.12110)
- [A-Mem MCP server](https://lobehub.com/mcp/tobs-code-a-mem-mcp-server)
- [A-Mem GitHub](https://github.com/WujiangXu/A-mem)
- [@mcp/server-memory](https://github.com/modelcontextprotocol/servers/tree/main/src/memory)
- [kuzu-memory GitHub](https://github.com/bobmatnyc/kuzu-memory)
- [CaviraOSS/OpenMemory](https://github.com/CaviraOSS/OpenMemory)
- [LoCoMo audit](https://github.com/dial481/locomo-audit)
- [Independent benchmark (arXiv:2604.01707)](https://arxiv.org/abs/2604.01707)
- [Zep corrected LoCoMo score](https://github.com/getzep/zep-papers/issues/5)
- [Memory comparison 2026](https://dev.to/anajuliabit/mem0-vs-zep-vs-langmem-vs-memoclaw-ai-agent-memory-comparison-2026-1l1k)
