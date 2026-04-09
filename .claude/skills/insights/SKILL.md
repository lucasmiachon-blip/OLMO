---
name: insights
disable-model-invocation: true
description: "Retrospective session analysis — audits error patterns, rule/skill compliance, proposes systemic fixes."
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

If a `.last-insights` timestamp exists (see Phase 4 save step), only scan sessions newer than that timestamp.

#### Step 1b: Read success and calibration logs

If these files exist, read them as additional signal:

```bash
cat .claude/success-log.jsonl 2>/dev/null   # clean commits (timestamp, session, hash, files, message)
cat .claude/hook-stats.jsonl 2>/dev/null     # proactive hook firings (timestamp, hook, session)
```

**Success log:** patterns in clean commits — which sessions flow well? Which file types commit cleanly? Use to recommend "preserve this workflow" instead of only "add more guards".

**Hook stats:** which proactive hooks fire often? If a hook fires frequently but the user never acts on it, recommend increasing its threshold or disabling it. Calibration data.

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

**Known false positives:** Skill invocations (via Skill tool) inject the SKILL.md content as user messages. Grep hits on these are noise — filter out messages starting with "Base directory for this skill:" or containing SKILL.md header patterns (e.g., "# SkillName —").

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
date +%s > ~/.claude/projects/C--Dev-Projetos-OLMO/.last-insights
```

If a previous report exists, move it to `references/previous-report.md` before overwriting.

#### Structured JSON Output (obrigatorio ao final de cada /insights)

Apos escrever o report em prosa, gerar e imprimir o bloco JSON abaixo. Ele alimenta automaticamente `known-bad-patterns.md` e `pending-fixes.md` quando Lucas aprovar.

```json
{
  "insights_run": "<YYYY-MM-DD>",
  "sessions_analyzed": 0,
  "proposals": [
    {
      "id": "P001",
      "category": "RULE_VIOLATION|RULE_GAP|RULE_STALE|SKILL_GAP|SKILL_UNDERTRIGGER|HOOK_GAP|PATTERN_REPEAT",
      "title": "<titulo curto>",
      "target_file": "<caminho relativo do arquivo a modificar>",
      "priority": "high|medium|low",
      "frequency": 0,
      "draft": "<texto exato a adicionar/modificar, pronto para copy-paste>"
    }
  ],
  "kbps_to_add": [
    {
      "pattern": "<anti-pattern identificado>",
      "trigger": "<quando ocorre>",
      "fix": "<como evitar>"
    }
  ],
  "pending_fixes_to_add": [
    {
      "item": "<descricao da tarefa>",
      "priority": "P0|P1|P2",
      "target": "<arquivo ou sistema>"
    }
  ],
  "metrics": {
    "rule_violations": 0,
    "user_corrections": 0,
    "retries": 0,
    "patterns_resolved_since_last": 0,
    "patterns_new": 0
  }
}
```

**Regras do JSON:**
- `proposals[].draft` deve ser texto pronto para copiar — sem placeholders
- `kbps_to_add` alimenta diretamente `known-bad-patterns.md` (Lucas revisa antes de aplicar)
- `pending_fixes_to_add` alimenta `pending-fixes.md` (session-start vai surfacea-los)
- Se nada a adicionar em algum campo: array vazio `[]`
- NUNCA aplicar automaticamente — sempre aguardar aprovacao do Lucas

#### Phase 5: Failure Registry Update (obrigatorio apos cada /insights)

Apos gerar o JSON output, atualizar o failure registry em `.claude/insights/failure-registry.json`:

1. **Append session entry** — add a new object to `sessions[]` with the current session metrics from the JSON output above:
   ```json
   {
     "id": "S{N}",
     "date": "YYYY-MM-DD",
     "metrics": {
       "sessions_in_sample": <from insights_run>,
       "user_corrections_total": <from metrics.user_corrections>,
       "user_corrections_per_session": <calculated>,
       "kbp_violations": { "KBP-01_scope_creep": N, ... },
       "kbp_total": <sum>,
       "kbp_per_session": <calculated>,
       "tool_errors": 0,
       "retries": <from metrics.retries>
     },
     "insights_run": true,
     "new_kbps_added": <count of kbps_to_add>,
     "proposals_accepted": 0,
     "proposals_rejected": 0
   }
   ```
   Note: `proposals_accepted/rejected` start at 0. Lucas updates after reviewing.

2. **Recompute trend** — calculate 5-session rolling averages:
   - `corrections_per_session_5avg` = avg of last 5 `user_corrections_per_session`
   - `kbp_violations_per_session_5avg` = avg of last 5 `kbp_per_session`
   - `direction` = "improving" if both avgs decreased, "regressing" if either increased, "stable" otherwise

3. **Constrained optimization check** — compare new trend against previous trend:
   - If EITHER rolling average **increased**: print `WARNING: Regression detected. corrections_5avg: {old} -> {new}, kbp_5avg: {old} -> {new}. Review proposals carefully — the system may be degrading.`
   - If both **decreased or stable**: print `OK: Trend improving or stable.`
   - This check applies to the PROPOSALS in the current run. If proposals are applied and the NEXT run shows regression, that is a signal to revert.

4. **Write the updated registry** — use Edit tool to update the JSON file. Validate with `node -e` before saving.

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
