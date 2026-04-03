---
name: insights
description: >
  Agent self-improvement through retrospective session analysis. Audits error
  patterns, rule/skill compliance, and proposes systemic fixes to rules, skills,
  hooks, and memory. Like an M&M conference for the AI agent. Use this skill
  whenever the user says 'insights', 'self-improve', 'auditoria de sessoes',
  'o que melhorar', 'error patterns', 'quais erros se repetem', 'agent
  performance', or wants to analyze how the agent has been performing. Also
  trigger when the user mentions improving rules, skills, or hooks based on
  past sessions. Proactively suggest running /insights weekly or after major
  milestones.
---

# Insights — Agent Self-Improvement

> M&M conference for the AI agent. Retrospective analysis of sessions to find
> systemic issues and propose fixes. Complements `/dream` (which consolidates
> memory); `/insights` improves the operating system (rules, skills, hooks).

## How It Differs from /dream

| | /dream | /insights |
|---|--------|-----------|
| **Focus** | What happened (facts, preferences, decisions) | How well the agent performed |
| **Frequency** | Daily (24h auto-trigger) | Weekly or on-demand |
| **Reads** | Session transcripts → memory | Session transcripts → rules, skills, hooks |
| **Writes** | Memory files | Report + proposed changes to rules/skills/hooks |
| **Analogy** | Sleep consolidation | Morbidity & Mortality conference |

**Cardinal rule:** /insights NEVER modifies memory files. That is /dream's job.

---

## Phases

Execute in order. Do not skip phases.

```
SCAN → AUDIT → DIAGNOSE → PRESCRIBE
```

### Phase 1: SCAN — Extract Signal from Sessions

**Goal:** Find errors, corrections, retries, and friction in recent sessions.

#### Step 1: Identify sessions to analyze

```bash
# Sessions from last 7 days (or since last /insights run)
find ~/.claude/projects/C--Dev-Projetos-OLMO/ -name "*.jsonl" -mtime -7 2>/dev/null | sort -r
```

If a `.last-insights` timestamp exists in the memory directory, only scan sessions newer than that timestamp.

#### Step 2: Targeted grep for error signals

Scan JSONL files for these categories. Use grep, not full reads.

**Agent errors** (tool failures, wrong assumptions):
```bash
grep -l "Error\|FAIL\|error\|failed\|not found\|does not exist\|permission denied" <files>
```

**User corrections** (highest signal — the user fixing the agent):
```bash
grep -l '"role":"user"' <files> | xargs grep -l "no,\|nao\|wrong\|errado\|para\|stop\|nao era\|I said\|eu disse\|actually\|na verdade"
```

**Retries and workarounds** (agent struggling):
```bash
grep -l "retry\|trying again\|let me try\|alternative approach\|workaround\|tentando\|vou tentar" <files>
```

**Rule violations** (explicit mentions of rules being broken):
```bash
grep -l "anti-drift\|fabricat\|should have\|deveria\|forgot\|esquec" <files>
```

#### Step 3: Extract context around matches

For each match, read only the surrounding 5-10 lines. Parse the JSONL line as JSON to get the message content. Focus on `"type":"user"` and `"type":"assistant"` messages.

**Output of Phase 1:** A list of incidents, each with:
- Session ID + timestamp
- Category (error / correction / retry / violation)
- Brief description (1 line)
- Severity estimate (high / medium / low)

---

### Phase 2: AUDIT — Cross-Reference Against Rules and Skills

**Goal:** Determine which rules/skills were relevant to each incident and whether they were followed.

#### Step 1: Load all rules

```bash
ls .claude/rules/*.md
```

Read each rule file. Build a mental map of what each rule covers.

#### Step 2: Load active skills

```bash
ls .claude/skills/*/SKILL.md
```

Note which skills exist and their trigger conditions.

#### Step 3: Cross-reference

For each incident from Phase 1:
1. Which rule(s) should have prevented this?
2. Was the rule clear enough? Or is there a gap?
3. Was a skill available that should have helped?
4. Was the skill triggered? If not, why?

#### Step 4: Check rule staleness

For each rule, search recent sessions for evidence it was:
- **Followed** (behavior matches rule)
- **Violated** (behavior contradicts rule)
- **Irrelevant** (rule covers something that never came up)
- **Outdated** (rule references things that no longer exist)

**Output of Phase 2:** A compliance matrix — each rule rated as followed/violated/stale/gap-identified.

---

### Phase 3: DIAGNOSE — Categorize and Prioritize

**Goal:** Turn raw findings into actionable categories.

#### Taxonomy

| Category | Description | Fix target |
|----------|-------------|------------|
| `RULE_VIOLATION` | Rule exists but was not followed | Strengthen rule or add hook enforcement |
| `RULE_GAP` | No rule covers this error pattern | Write new rule |
| `RULE_STALE` | Rule references outdated state | Update or archive rule |
| `SKILL_GAP` | No skill covers a repeated workflow | Write new skill |
| `SKILL_UNDERTRIGGER` | Skill exists but didn't activate | Improve description/triggers |
| `HOOK_GAP` | Error could be caught automatically | Write new hook |
| `PATTERN_REPEAT` | Same error across 3+ sessions | Systemic issue, high priority |

#### Prioritization

Rank findings by:
1. **Frequency** — errors that repeat across sessions > one-time errors
2. **Impact** — user corrections > agent self-corrections > minor friction
3. **Fixability** — concrete fix possible > vague improvement needed

**Output of Phase 3:** Prioritized list of findings, each tagged with category + proposed fix target.

---

### Phase 4: PRESCRIBE — Propose Specific Changes

**Goal:** Write concrete, diff-ready proposals for each finding.

#### For each finding, produce:

```markdown
### [CATEGORY] Finding title

**Evidence:** Session(s) where this occurred, with brief quote
**Root cause:** Why it happened (1-2 sentences)
**Proposed fix:**
- **Target:** rules/X.md | skills/Y/SKILL.md | hooks/Z.sh
- **Change:** [specific addition/modification/removal]
- **Draft:** [the actual text to add/change, ready to copy-paste]
```

#### Rules for proposals:
- Every proposal must cite specific session evidence
- Proposals modify existing files when possible (no new files unless truly needed)
- Rule additions should be concise (1-3 lines added, not paragraphs)
- Hook proposals include the shell command and where to wire it
- NEVER auto-apply changes. Present the report, let Lucas decide.

#### Evolution metrics

If a previous `/insights` report exists (check `references/previous-report.md`):
- Compare error counts by category
- Note which previous proposals were implemented
- Track which error patterns resolved vs persisted

#### Save the report

Write the full report to `.claude/skills/insights/references/latest-report.md` and update the timestamp:

```bash
date +%s > ~/.claude/projects/C--Dev-Projetos-OLMO/memory/.last-insights
```

If a previous report exists, move it to `references/previous-report.md` before overwriting.

---

## Workflows

### Recipe 1: Weekly Retrospective (default)

> "Rode /insights" or "insights semanal"

Run all 4 phases on the last 7 days of sessions. Full report.

### Recipe 2: Focused Error Audit

> "Quais erros se repetem?" or "error patterns"

Run Phase 1 (SCAN) with emphasis on `PATTERN_REPEAT`. Skip full rule audit.
Quick report: top 5 recurring patterns + proposed fixes.

### Recipe 3: Rule Health Check

> "Auditoria das rules" or "quais rules estao desatualizadas?"

Run Phase 2 (AUDIT) focused on rule staleness.
Output: compliance matrix + list of stale/gap rules.

---

## Safety

- **Read-only by default.** Never modify rules, skills, or hooks without Lucas's explicit approval.
- **Never modify memory files.** That is /dream's domain.
- **Session transcripts are sensitive.** Do not quote user messages verbatim in reports unless directly relevant to a finding. Paraphrase instead.
- **Proposals, not commands.** Every output is a suggestion. Lucas decides what to implement.
