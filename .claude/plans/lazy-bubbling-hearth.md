# Plan: Wiki Karpathy Status + Obsidian + Ruflo

## Context

S111 established the Karpathy Wiki system (SCHEMA.md, wiki-index, changelog, Dream v2.2, wiki-lint skill). S112 needs to assess where we are vs the full vision, integrate Obsidian for visual "living tree", and evaluate Ruflo for potential leverage.

---

## Part 1: Wiki Karpathy — Status Assessment

### What EXISTS (done in S111)

| Component | File | Status |
|-----------|------|--------|
| SCHEMA.md (3-layer arch) | `memory/SCHEMA.md` | DONE |
| Wiki-index v1 | `MEMORY.md` (semantic "Load when" triggers) | DONE |
| Changelog | `memory/changelog.md` | DONE (19 rows) |
| Dream v2.2 | `~/.claude/skills/dream/SKILL.md` | DONE (supersession + changelog) |
| wiki-lint skill | `~/.claude/skills/wiki-lint/SKILL.md` | DONE (never run yet) |
| 20 topic files | `memory/*.md` | DONE (at cap) |
| Full frontmatter | tags + lifecycle + confidence + review_by + last_challenged | ~11/20 verified |
| Wikilinks | `[[filename]]` "See also" sections | 9/20 topic files |

### What's INCOMPLETE or OUTDATED

| Item | Issue | Fix |
|------|-------|-----|
| SCHEMA.md checklist | Says wikilinks/tags "adding" — but they're done | Update checkboxes to [x] |
| Wikilinks coverage | 9/20 files have [[wikilinks]], not 11 as HANDOFF claims | Add wikilinks to remaining 11 files |
| Frontmatter gaps | Need to verify remaining 9 files have full frontmatter | Audit + fill gaps |
| overview.md | SCHEMA.md Layer 2 mentions it as TODO | Decide: create or defer |
| wiki-query skill | SCHEMA.md operation #2, not built | Build or defer |
| wiki-update skill | SCHEMA.md operation #4, partially via Dream | Decide scope |
| .obsidian/ config | SCHEMA.md mentions "future" | Part 2 of this plan |
| README Wiki | HANDOFF item #9 (marked Alta) | Part of this plan |

### Findings (wiki-lint-like pre-check)

1. **Index drift risk**: HANDOFF says "11 with wikilinks" but actual count is 9 topic files
2. **SCHEMA.md out of sync**: Checklist doesn't reflect S111 work completion
3. **Orphan candidates**: Files with NO inbound wikilinks from ANY other file need identification
4. **No overview.md**: Central synthesis page still missing (Layer 2 gap)

---

## Part 2: Obsidian Integration — "Arvore com Vida"

### Approach: Direct vault (no symlink)

The `memory/` directory IS the Obsidian vault. No copying, no syncing.

```
Obsidian Vault Root = ~/.claude/projects/C--Dev-Projetos-OLMO/memory/
```

### Steps

1. **Create `.obsidian/` inside memory/**
   - `app.json` — basic UI (font size, strict line breaks)
   - `core-plugins.json` — enable: graph, outgoing-links, backlink, tag-pane
   - `community-plugins.json` — initially empty, then add Dataview + Juggl
   - `graph.json` — force-directed physics, color by `type:` field

2. **Graph View visualization**
   - Nodes = each .md file (20 topic + 3 operational)
   - Edges = [[wikilinks]] (currently ~24 links across 9 files)
   - Color coding by `type:` from frontmatter (feedback=red, project=blue, patterns=green, etc.)
   - MEMORY.md is the hub node (most connections)

3. **Essential plugins** (install via Obsidian GUI)
   - **Dataview** — query pages by frontmatter (lifecycle, confidence, tags)
   - **Juggl** — tree-like hierarchical graph (maps to 3-layer architecture)
   - **Graph Analysis** — centrality metrics, orphan detection

4. **.gitignore additions** for the memory/ vault
   ```
   .obsidian/workspace.json
   .obsidian/workspace-alt.json
   .obsidian/cache/
   ```

### What Lucas will see
- **Graph view**: Nodes clustered by type, with edges showing knowledge flow
- **Backlinks panel**: Click any file, see what references it
- **Tag search**: Filter by `#agent`, `#medical`, `#meta` etc.
- **Dataview queries**: Dynamic tables of files by lifecycle, confidence, stale dates

---

## Part 3: Ruflo Evaluation

### What Ruflo is
AI agent orchestration platform by rUv. Multi-agent swarms, 313 tools, MCP integration, self-learning (SONA/RuVector), WebAssembly optimization.

### OLMO vs Ruflo overlap

| Capability | OLMO Has | Ruflo Offers |
|-----------|----------|-------------|
| Agent orchestration | 8 agents + maxTurns | 100+ pre-built agents |
| MCP integration | 12 MCPs configured | MCP server framework |
| Skills system | 20+ skills | Plugin architecture |
| Self-learning | Dream consolidation, KBPs, /insights | SONA, EWC++, vector learning |
| Cost optimization | Model routing (Haiku→Sonnet→Opus) | WASM kernel skipping LLM calls |
| Hooks system | 29 registrations, 31 scripts | Native Claude Code hooks |

### Honest assessment

**Potentially useful:**
- Agent definition patterns (`.agents/` directory structure)
- Plugin architecture for extending skills
- Consensus mechanisms (Raft, Byzantine) — interesting for multi-agent reliability
- GitHub Actions tutorial for CI/CD agent automation

**Probably not useful (overlap/overkill):**
- 100+ pre-built agents — OLMO needs 8 curated ones, not 100 generic
- WASM optimization — OLMO's scale doesn't justify the complexity
- Swarm coordination — OLMO's linear orchestration pattern works fine

**Recommendation:** Study Ruflo's README and `.agents/` patterns for inspiration, but don't adopt wholesale. Extract 2-3 specific patterns that strengthen OLMO. The "arvore com vida" is better served by Obsidian than by Ruflo's agent swarms.

---

## Part 4: Agent Ecosystem Research — Debug & Self-Improvement Repos

### TIER 1: Anthropic Official (direct integration)

| # | Repo | Stars | What | Read-only? | OLMO fit |
|---|------|-------|------|-----------|----------|
| 1 | `anthropics/claude-code-security-review` | ~4.2k | GitHub Action — Claude analyzes PRs for security vulns | YES | Add as GH Action, complements `/review` |
| 2 | `anthropics/skills` | ~113k | Official skill patterns/templates | YES | Compare 20+ skills against canonical format |
| 3 | `anthropics/claude-agent-sdk-python` | ~6.2k | Python SDK for custom agents | analysis mode | Build dedicated read-only analysis agent |
| 4 | `anthropics/claude-code-monitoring-guide` | ~250 | Observability patterns for agent behavior | YES | Improve OTel + `/insights` patterns |

### TIER 2: Community Ecosystem (high relevance)

| # | Repo | Stars | What | OLMO fit |
|---|------|-------|------|----------|
| 5 | `affaan-m/everything-claude-code` | ~147k | Harness optimization: skills, instincts, memory, security | Compare context/memory patterns |
| 6 | `project-codeguard/rules` | ~400 | Model-agnostic security rules + validators | Import rules into `.claude/rules/` |
| 7 | `darrenhinde/OpenAgentsControl` | ~3.3k | Plan-first + approval gates + validation | Mirrors "Proponha, espere OK, execute" |
| 8 | `spencermarx/open-code-review` | ~118 | Multi-agent discourse review (agents debate findings) | Anti-sycophancy: agents challenge each other |
| 9 | `LerianStudio/ring` | ~166 | 89 skills + 38 agents + 10-gate dev cycle | Cherry-pick debugging agents |

### TIER 3: Self-Improvement & Memory (novel patterns)

| # | Repo | Stars | What | OLMO fit |
|---|------|-------|------|----------|
| 10 | `sandroandric/AgentHandover` | ~485 | Observes work patterns, auto-generates skills | Evolve `/dream` + `/insights` automation |
| 11 | `MaximeRobeyns/self_improving_coding_agent` | ~304 | Agent improves its own tools/prompts | Inform automated KBP detection |
| 12 | `cortex-tms/cortex-tms` | ~173 | Tiered Memory System (hot/warm/cold) | Compare vs wiki-index + TTL stagger |
| 13 | `dsifry/metaswarm` | ~192 | Multi-agent multi-CLI (Claude+Gemini+Codex) | Compare 18 agents vs OLMO's 8 |

### TIER 4: Observability Infrastructure

| # | Repo | Stars | What | OLMO fit |
|---|------|-------|------|----------|
| 14 | `traceloop/opentelemetry-mcp-server` | ~182 | OTel traces via MCP — agents query own perf | MCP #13: self-diagnostic traces |
| 15 | `hesreallyhim/awesome-claude-code` | ~37.5k | Curated ecosystem list | Reference catalog |

### Recommended priorities

1. **Immediate (zero effort):** Study `anthropics/skills` + `everything-claude-code` harness patterns
2. **Short-term:** Add `claude-code-security-review` GH Action + `opentelemetry-mcp-server` as MCP #13
3. **Medium-term:** Adapt `open-code-review` discourse for multi-agent review; study `AgentHandover` for automated learning
4. **Architecture study:** `cortex-tms` tiered memory + `project-codeguard/rules` security framework

### Not found
- **Google DeepMind**: No public read-only debugging agent repos (ADK is framework-level)
- **OpenAI**: Agents SDK is execution-focused, not analysis-focused
- **"AI system design review"**: No mature dedicated repo exists yet

---

## Part 5: Proposed S112 Actions

### Track A: Wiki Health (quick wins)
1. Run `/wiki-lint` — first baseline health check
2. Fix SCHEMA.md checklist (mark completed items [x])
3. Add wikilinks to remaining 11 orphan files
4. Verify/fill frontmatter gaps in 9 unchecked files

### Track B: Obsidian Vault ("arvore com vida")
5. Create `.obsidian/` config in memory/ (app.json, core-plugins.json, graph.json)
6. Lucas opens vault in Obsidian — verify graph view renders 23 nodes
7. Update SCHEMA.md §Obsidian Integration with setup complete
8. Add .gitignore entries for Obsidian cache

### Track C: Ecosystem Study (research only, no code)
9. Study top repos from Part 4 research (Ruflo + debug/self-improvement agents)
10. Extract actionable patterns → note in memory or plan
11. Prioritize: `everything-claude-code` harness patterns + `cortex-tms` memory tiers

### Track D: README Wiki (if time permits)
12. Create README.md for wiki system with Mermaid diagrams
13. Architecture overview, 3-layer diagram, operations, governance rules

---

## Critical files

- `~/.claude/projects/C--Dev-Projetos-OLMO/memory/SCHEMA.md` — wiki architecture
- `~/.claude/projects/C--Dev-Projetos-OLMO/memory/MEMORY.md` — wiki index
- `~/.claude/projects/C--Dev-Projetos-OLMO/memory/changelog.md` — audit trail
- `~/.claude/skills/wiki-lint/SKILL.md` — health check skill
- `~/.claude/skills/dream/SKILL.md` — consolidation skill
- `.gitignore` — needs Obsidian cache entries

## Verification

1. After wiki-lint: review report, count errors vs warnings
2. After Obsidian setup: open vault, verify graph view renders all 23 nodes
3. After wikilink additions: grep `\[\[.*\]\]` — should find entries in 20/20 topic files
4. After SCHEMA.md update: all checkboxes should be [x] or have clear "future" annotation
