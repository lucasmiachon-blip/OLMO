#!/usr/bin/env node
// No-network smoke for S269 D-lite research contract.

import { execFileSync } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { resolve } from 'node:path';
import process from 'node:process';

const root = process.cwd();
const runner = resolve(root, '.claude/scripts/research-dlite-runner.mjs');
const schema = resolve(root, '.claude/schemas/research-perna-output.json');
const candidateSchema = resolve(root, '.claude/schemas/research-candidate-set.json');
const doc = resolve(root, 'docs/research/sota-S269-agents-subagents-contract.md');
const rehydrationDoc = resolve(root, 'docs/research/S269-dlite-rehydration.md');
const agents = [
  resolve(root, '.claude/agents/gemini-dlite-research.md'),
  resolve(root, '.claude/agents/perplexity-dlite-research.md'),
];

function pass(name) {
  console.log(`PASS ${name}`);
}

function fail(name, detail) {
  console.error(`FAIL ${name}: ${detail}`);
  process.exitCode = 1;
}

function checkExists(path, name) {
  if (!existsSync(path)) fail(name, `missing ${path}`);
  else pass(name);
}

function runNode(args) {
  return execFileSync(process.execPath, args, { cwd: root, encoding: 'utf8' });
}

checkExists(runner, 'runner exists');
checkExists(schema, 'schema exists');
checkExists(candidateSchema, 'candidate schema exists');
checkExists(doc, 'contract doc exists');
checkExists(rehydrationDoc, 'rehydration doc exists');
for (const agent of agents) checkExists(agent, `agent exists ${agent}`);

try {
  const output = runNode(['.claude/scripts/research-dlite-runner.mjs', '--self-test']);
  const parsed = JSON.parse(output);
  if (parsed.ok !== true) fail('runner self-test', 'ok != true');
  else pass('runner self-test');
} catch (err) {
  fail('runner self-test', err.message);
}

try {
  const tmpDir = resolve(root, '.claude/.research-tmp');
  const fixture = resolve(tmpDir, 'research-dlite-smoke-fixture.json');
  mkdirSync(tmpDir, { recursive: true });
  writeFileSync(fixture, `${JSON.stringify({
    schema_version: '1.0',
    produced_at: '2026-04-28T00:00:00.000Z',
    research_question_id: 'smoke',
    research_question: 'What is PRISMA 2020?',
    external_brain_used: 'smoke-fixture',
    codex_cli_version: null,
    findings: [
      {
        claim: 'PRISMA 2020 is a reporting guideline update for systematic reviews.',
        supporting_sources: [{ type: 'pmid', value: '33782057', verified: false }],
        confidence: 'medium',
        convergence_signal: 'smoke fixture',
      },
    ],
    candidate_pmids_unverified: ['33782057'],
    convergence_flags: [{ type: 'gap', description: 'fixture does not verify PMID' }],
    confidence_overall: 'medium',
    gaps: ['No live provider call in smoke fixture'],
  }, null, 2)}\n`);
  const output = runNode(['.claude/scripts/research-dlite-runner.mjs', '--output-kind', 'final', '--validate-file', fixture]);
  const parsed = JSON.parse(output);
  if (parsed.schema_version !== '1.0') fail('runner validate-file', 'wrong schema_version');
  else pass('runner validate-file');
} catch (err) {
  fail('runner validate-file', err.message);
}

try {
  const tmpDir = resolve(root, '.claude/.research-tmp');
  const fixture = resolve(tmpDir, 'research-dlite-candidate-fixture.json');
  mkdirSync(tmpDir, { recursive: true });
  writeFileSync(fixture, `${JSON.stringify({
    schema_version: '1.0',
    produced_at: '2026-04-28T00:00:00.000Z',
    research_question_id: 'smoke',
    research_question: 'What is PRISMA 2020?',
    capture_perna: 'codex-xhigh',
    capture_mode: 'high_recall',
    domain_context: 'Evidence-based medicine methodology',
    candidate_documents: [
      {
        title: 'The PRISMA 2020 statement: an updated guideline for reporting systematic reviews',
        document_type: 'guideline',
        source_tier: 'tier1',
        indexing_signal: 'PubMed/MEDLINE indexed BMJ guideline statement',
        why_candidate: 'Anchor guideline statement for PRISMA 2020.',
        pmid: '33782057',
        doi: '10.1136/bmj.n71',
        url: null,
        fallback_id: null,
        landmark_signal: 'practice_changing',
        evidence_hierarchy: 'guideline',
        triage_status: 'candidate',
        validation_status: 'unverified',
      },
    ],
    missing_expected_documents: [],
    provider_gaps: ['Smoke fixture only; no live provider search.'],
  }, null, 2)}\n`);
  const output = runNode(['.claude/scripts/research-dlite-runner.mjs', '--output-kind', 'candidates', '--validate-file', fixture]);
  const parsed = JSON.parse(output);
  if (parsed.capture_mode !== 'high_recall') fail('runner validate-candidates', 'wrong capture_mode');
  else pass('runner validate-candidates');
} catch (err) {
  fail('runner validate-candidates', err.message);
}

for (const provider of ['gemini', 'perplexity']) {
  try {
    const output = runNode([
      '.claude/scripts/research-dlite-runner.mjs',
      '--provider', provider,
      '--question-id', 'smoke',
      '--question', 'What is PRISMA 2020?',
      '--dry-run',
    ]);
    const parsed = JSON.parse(output);
    if (parsed.provider !== provider) fail(`${provider} dry-run`, 'wrong provider');
    else if (!parsed.payload?.request) fail(`${provider} dry-run`, 'missing request');
    else if (JSON.stringify(parsed.payload.request).includes('"const"')) fail(`${provider} provider schema`, 'contains unsupported const keyword');
    else if (JSON.stringify(parsed.payload.request).includes('"$schema"')) fail(`${provider} provider schema`, 'contains draft marker');
    else if (provider === 'perplexity' && parsed.payload.request.response_format?.json_schema?.name !== 'research_candidate_set') {
      fail(`${provider} provider schema`, 'missing required json_schema.name');
    }
    else pass(`${provider} dry-run payload`);
  } catch (err) {
    fail(`${provider} dry-run`, err.message);
  }

  try {
    const output = runNode([
      '.claude/scripts/research-dlite-runner.mjs',
      '--provider', provider,
      '--question-id', 'smoke',
      '--question', 'What is PRISMA 2020?',
      '--mode', 'deterministic',
      '--dry-run',
    ]);
    const parsed = JSON.parse(output);
    const temperature = provider === 'gemini'
      ? parsed.payload?.request?.generationConfig?.temperature
      : parsed.payload?.request?.temperature;
    if (temperature !== 0) fail(`${provider} deterministic mode`, `temperature ${temperature} != 0`);
    else pass(`${provider} deterministic mode`);
  } catch (err) {
    fail(`${provider} deterministic mode`, err.message);
  }
}

for (const agent of agents) {
  const text = readFileSync(agent, 'utf8');
  const name = agent.replace(`${root}\\`, '').replace(`${root}/`, '');
  if (!text.includes('research-dlite-runner.mjs')) fail(`${name} runner reference`, 'missing runner command');
  else pass(`${name} runner reference`);

  if (/Write|Edit|MultiEdit|Agent/.test(text.split('---')[1] ?? '')) fail(`${name} tool allowlist`, 'frontmatter includes write/delegation tool');
  else pass(`${name} tool allowlist`);

  const maxTurnsMatch = text.match(/maxTurns:\s*(\d+)/);
  if (!maxTurnsMatch || Number(maxTurnsMatch[1]) > 6) fail(`${name} maxTurns`, 'missing or >6');
  else pass(`${name} maxTurns <=6`);

  const phaseCount = (text.match(/^## Phase/gm) ?? []).length;
  if (phaseCount > 0) fail(`${name} anti-chattiness`, `contains ${phaseCount} Phase sections`);
  else pass(`${name} anti-chattiness`);
}

const docText = readFileSync(doc, 'utf8');
for (const needle of ['ResearchRunSpec', 'ResearchPernaOutput', 'Anti-overengineering Rules', 'Promotion Gate']) {
  if (!docText.includes(needle)) fail(`doc ${needle}`, 'missing section');
  else pass(`doc ${needle}`);
}

const rehydrationText = readFileSync(rehydrationDoc, 'utf8');
for (const needle of ['What Stayed Canonical', 'What Was Created In S269', 'Open Gaps', 'Next Session Playbook']) {
  if (!rehydrationText.includes(needle)) fail(`rehydration ${needle}`, 'missing section');
  else pass(`rehydration ${needle}`);
}

if (process.exitCode) process.exit(process.exitCode);
