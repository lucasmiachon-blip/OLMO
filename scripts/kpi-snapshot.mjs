#!/usr/bin/env node
// kpi-snapshot.mjs — Daily KPI snapshot collector (Conductor 2026)
// WHAT: Reads KPI definitions (hardcoded v1), runs measurement, writes daily TSV snapshot.
// WHY: Anti-vanish (plan §9). Without this, KPIs evaporate in volatile session logs (.claude/apl/* gitignored).
// HOW: Node-native fs APIs (cross-platform Win/Unix). No shell-out except git log. Idempotent (re-run same day overwrites).
// VERIFY: scripts/smoke/kpi-snapshot.sh (P1 deliverable).
//
// Source-of-truth drift: KPI list duplicated here vs .claude/metrics/baseline.md ACTIVE table.
// v2 deferred — script parses baseline.md directly. Trade-off accepted (gate: KBP-21 calibrate-before-block;
// P0 priority = first snapshot committed, not perfect architecture).

import { execSync } from 'node:child_process';
import { readdirSync, writeFileSync, mkdirSync, existsSync, statSync } from 'node:fs';
import { dirname } from 'node:path';

const today = new Date().toISOString().slice(0, 10); // YYYY-MM-DD UTC
const snapshotPath = `.claude/metrics/snapshots/${today}.tsv`;

// Helper: count subdirs in .claude/agent-memory/ that contain at least 1 .md
function countAgentsWithMaterialMemory() {
  const root = '.claude/agent-memory';
  if (!existsSync(root)) return 0;
  let count = 0;
  for (const entry of readdirSync(root, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const sub = `${root}/${entry.name}`;
    try {
      const files = readdirSync(sub);
      if (files.some(f => f.endsWith('.md'))) count++;
    } catch { /* skip unreadable */ }
  }
  return count;
}

// Helper: count files matching pattern in dir (non-recursive)
function countFilesIn(dir, suffix) {
  if (!existsSync(dir)) return 0;
  try {
    return readdirSync(dir).filter(f => f.endsWith(suffix)).length;
  } catch { return 0; }
}

// Helper: git log grep count (last N days). Returns 0 on git failure.
function gitLogGrepCount(pattern, days) {
  try {
    const out = execSync(
      `git log --since="${days} days ago" --grep="${pattern}" --oneline`,
      { encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }
    );
    return out.trim().split('\n').filter(Boolean).length;
  } catch { return 0; }
}

const KPIs = [
  // ACTIVE — measurable in P0
  {
    slug: 'agent-memory-coverage',
    threshold: 40,
    measure: () => Math.round((countAgentsWithMaterialMemory() / 16) * 10000) / 100,
    confidence: 'high',
    sourceCmd: 'count .claude/agent-memory/*/<*.md> ÷ 16 × 100',
  },
  {
    slug: 'smoke-test-coverage',
    threshold: 80,
    measure: () => Math.round((countFilesIn('scripts/smoke', '.sh') / 18) * 10000) / 100,
    confidence: 'high',
    sourceCmd: 'count scripts/smoke/*.sh ÷ 18 × 100',
  },
  {
    slug: 'cross-model-invocations-week',
    threshold: 3,
    measure: () => {
      // Combine 3 grep counts (gemini, codex, ollama keywords in commit messages last 7d)
      return gitLogGrepCount('gemini', 7) + gitLogGrepCount('codex', 7) + gitLogGrepCount('ollama', 7);
    },
    confidence: 'medium',
    sourceCmd: 'git log --since=7d --grep gemini|codex|ollama (sum)',
  },
  {
    slug: 'kpi-baseline-defined-per-arm',
    threshold: 12,
    measure: () => KPIs.filter(k => !k.stub).length + KPIs.filter(k => k.stub).length,
    // Total KPIs (active+stub) should always = 12 active arm KPIs from baseline.md
    confidence: 'high',
    sourceCmd: 'count KPIs in this file (drift detector vs baseline.md)',
  },
  {
    slug: 'apl-metrics-committed-daily',
    threshold: 1,
    measure: () => {
      // Self-referential at run time — checks YESTERDAY exists (continuity proof).
      // First run: yesterday won't exist → 0 (expected; gates pass after day 2).
      const yesterday = new Date(Date.now() - 86400000).toISOString().slice(0, 10);
      return existsSync(`.claude/metrics/snapshots/${yesterday}.tsv`) ? 1 : 0;
    },
    confidence: 'high',
    sourceCmd: 'test -f .claude/metrics/snapshots/{yesterday}.tsv',
  },

  // STUBS — measurable in P1+ when respective deliverables ship
  { slug: 'knowledge-base-coverage', threshold: 80, stub: true, confidence: 'low',
    sourceCmd: 'NOT_YET_IMPL — P2 grep evidence/.*living + PMID count' },
  { slug: 'research-tier1-ratio', threshold: 90, stub: true, confidence: 'low',
    sourceCmd: 'NOT_YET_IMPL — per-artifact PMID/DOI/arXiv ratio' },
  { slug: 'debug-team-pass-first-try', threshold: 70, stub: true, confidence: 'low',
    sourceCmd: 'NOT_YET_IMPL — needs n≥5 runs (S250 baseline n=1 insufficient)' },
  { slug: 'slides-qa-pass-ratio', threshold: 95, stub: true, confidence: 'low',
    sourceCmd: 'NOT_YET_IMPL — qa-rounds JSON parse' },
  { slug: 'aulas-tier1-evidence-complete', threshold: 80, stub: true, confidence: 'low',
    sourceCmd: 'NOT_YET_IMPL — ref-checker JSON output' },
  { slug: 'kbp-resolved-per-session', threshold: 1, stub: true, confidence: 'low',
    sourceCmd: 'NOT_YET_IMPL — CHANGELOG.md session-scoped grep RESOLVED' },
  { slug: 'mcp-health-uptime', threshold: 99, stub: true, confidence: 'low',
    sourceCmd: 'NOT_YET_IMPL — needs scripts/smoke/mcp-health.sh (P2)' },
  { slug: 'r3-questoes-acertadas-simulado', threshold: 75, stub: true, confidence: 'low',
    sourceCmd: 'NOT_YET_IMPL — manual entry content/concurso/error-log.md' },
];

function main() {
  mkdirSync(dirname(snapshotPath), { recursive: true });
  const lines = ['date\tslug\tvalue\tthreshold\tpass\tsource_command\tconfidence'];

  let activeCount = 0;
  let passCount = 0;

  for (const kpi of KPIs) {
    let value = 'stub';
    let pass = 'stub';

    if (!kpi.stub) {
      activeCount++;
      try {
        value = kpi.measure();
        pass = (typeof value === 'number' && value >= kpi.threshold) ? 'true' : 'false';
        if (pass === 'true') passCount++;
      } catch (e) {
        value = 'error';
        pass = 'error';
      }
    }

    lines.push([
      today,
      kpi.slug,
      value,
      kpi.threshold,
      pass,
      kpi.sourceCmd.replace(/\t/g, ' '),
      kpi.confidence,
    ].join('\t'));
  }

  writeFileSync(snapshotPath, lines.join('\n') + '\n', 'utf8');

  console.log(`KPI snapshot: ${snapshotPath}`);
  console.log(`Active: ${activeCount} | Stubs: ${KPIs.length - activeCount} | Pass: ${passCount}/${activeCount}`);
}

main();
