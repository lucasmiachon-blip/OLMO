#!/usr/bin/env node
// research-dlite-runner.mjs
// Thin deterministic facade for S269 D-lite research agents.

import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import process from 'node:process';

const REPO_ROOT = process.cwd();
const FINAL_SCHEMA_PATH = resolve(REPO_ROOT, '.claude/schemas/research-perna-output.json');
const CANDIDATE_SCHEMA_PATH = resolve(REPO_ROOT, '.claude/schemas/research-candidate-set.json');
const DEFAULTS = {
  gemini: {
    model: 'gemini-3.1-pro-preview',
    timeoutMs: 60_000,
    exploratoryTemperature: 1,
    deterministicTemperature: 0,
    maxOutputTokens: 32_768,
    thinkingBudget: 16_384,
  },
  perplexity: {
    model: 'sonar-deep-research',
    timeoutMs: 120_000,
    exploratoryTemperature: 0.2,
    deterministicTemperature: 0,
    maxTokens: 8_000,
    reasoningEffort: 'medium',
  },
};

function usage() {
  console.log(`Usage:
  node .claude/scripts/research-dlite-runner.mjs --provider gemini|perplexity --question-id <id> --question "<text>" [--out <path>]
  echo "<question>" | node .claude/scripts/research-dlite-runner.mjs --provider gemini --question-id <id>

Options:
  --provider <name>          gemini or perplexity
  --question-id <id>         research question id
  --question <text>          research question; stdin fallback
  --output-kind <kind>       candidates or final (default: candidates)
  --validate-file <path>     validate an existing JSON file, optionally with --verify-pmids for final outputs
  --domain-context <text>    optional clinical/domain focus
  --mode <name>              exploratory or deterministic (default: exploratory)
  --model <id>               provider model override
  --out <path>               write validated JSON to path
  --dry-run                  print provider payload without network/API key
  --self-test                run local schema validator checks
  --verify-pmids             verify candidate PMIDs with NCBI ESummary after schema validation
  --verify-limit <n>         max unique PMIDs to verify (default: 5)
`);
}

function parseArgs(argv) {
  const out = {
    provider: '',
    questionId: '',
    question: '',
    outputKind: 'candidates',
    domainContext: '',
    mode: 'exploratory',
    model: '',
    outPath: '',
    dryRun: false,
    selfTest: false,
    verifyPmids: false,
    verifyLimit: 5,
    validateFile: '',
  };

  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    const next = argv[i + 1];
    if (arg === '--provider') { out.provider = next ?? ''; i++; }
    else if (arg === '--question-id') { out.questionId = next ?? ''; i++; }
    else if (arg === '--question') { out.question = next ?? ''; i++; }
    else if (arg === '--output-kind') { out.outputKind = next ?? ''; i++; }
    else if (arg === '--validate-file') { out.validateFile = next ?? ''; i++; }
    else if (arg === '--domain-context') { out.domainContext = next ?? ''; i++; }
    else if (arg === '--mode') { out.mode = next ?? ''; i++; }
    else if (arg === '--model') { out.model = next ?? ''; i++; }
    else if (arg === '--out') { out.outPath = next ?? ''; i++; }
    else if (arg === '--dry-run') out.dryRun = true;
    else if (arg === '--self-test') out.selfTest = true;
    else if (arg === '--verify-pmids') out.verifyPmids = true;
    else if (arg === '--verify-limit') { out.verifyLimit = Number(next ?? 5); i++; }
    else if (arg === '--help' || arg === '-h') { usage(); process.exit(0); }
    else if (!out.question) out.question = arg;
  }

  return out;
}

function readStdin() {
  return new Promise((resolveText) => {
    let data = '';
    process.stdin.on('data', (chunk) => { data += chunk; });
    process.stdin.on('end', () => resolveText(data.trim()));
  });
}

function schemaPathFor(kind) {
  if (kind === 'candidates') return CANDIDATE_SCHEMA_PATH;
  if (kind === 'final') return FINAL_SCHEMA_PATH;
  throw new Error('--output-kind must be candidates or final');
}

function loadSchema(kind) {
  const schemaPath = schemaPathFor(kind);
  if (!existsSync(schemaPath)) {
    throw new Error(`schema missing: ${schemaPath}`);
  }
  return JSON.parse(readFileSync(schemaPath, 'utf8'));
}

function toProviderSchema(value) {
  if (Array.isArray(value)) return value.map((item) => toProviderSchema(item));
  if (!value || typeof value !== 'object') return value;

  const out = {};
  for (const [key, child] of Object.entries(value)) {
    if (['$schema', '$id', 'format', 'minLength', 'pattern'].includes(key)) continue;
    if (key === 'const') {
      out.enum = [child];
      continue;
    }
    out[key] = toProviderSchema(child);
  }
  return out;
}

function providerSchema(schema) {
  const out = toProviderSchema(schema);
  if (out?.type === 'object' && out.properties?.candidate_documents) {
    out.propertyOrdering = [
      'schema_version',
      'produced_at',
      'research_question_id',
      'research_question',
      'capture_perna',
      'capture_mode',
      'domain_context',
      'candidate_documents',
      'missing_expected_documents',
      'provider_gaps',
    ];
    out.properties.candidate_documents.maxItems = 25;
    const item = out.properties.candidate_documents.items;
    if (item?.type === 'object' && item.properties) {
      item.propertyOrdering = [
        'title',
        'document_type',
        'source_tier',
        'indexing_signal',
        'why_candidate',
        'pmid',
        'doi',
        'url',
        'fallback_id',
        'landmark_signal',
        'evidence_hierarchy',
        'triage_status',
        'validation_status',
      ];
    }
    return out;
  }

  if (out?.type === 'object' && out.properties) {
    out.propertyOrdering = [
      'schema_version',
      'produced_at',
      'research_question_id',
      'research_question',
      'external_brain_used',
      'codex_cli_version',
      'findings',
      'candidate_pmids_unverified',
      'convergence_flags',
      'confidence_overall',
      'gaps',
    ];
  }

  const findings = out?.properties?.findings;
  if (findings) findings.maxItems = 5;
  const findingItem = findings?.items;
  if (findingItem?.type === 'object' && findingItem.properties) {
    findingItem.propertyOrdering = ['claim', 'supporting_sources', 'confidence', 'convergence_signal'];
  }
  const sources = findingItem?.properties?.supporting_sources;
  if (sources) sources.maxItems = 4;
  const sourceItem = sources?.items;
  if (sourceItem?.type === 'object' && sourceItem.properties) {
    sourceItem.propertyOrdering = ['type', 'value', 'verified'];
  }

  const candidatePmids = out?.properties?.candidate_pmids_unverified;
  if (candidatePmids) candidatePmids.maxItems = 10;
  const flags = out?.properties?.convergence_flags;
  if (flags) flags.maxItems = 8;
  const flagItem = flags?.items;
  if (flagItem?.type === 'object' && flagItem.properties) {
    flagItem.propertyOrdering = ['type', 'description'];
  }
  const gaps = out?.properties?.gaps;
  if (gaps) gaps.maxItems = 8;

  return out;
}

function buildPrompt(opts) {
  const domainLine = opts.domainContext ? `DOMAIN_CONTEXT: ${opts.domainContext}\n` : '';
  if (opts.outputKind === 'candidates') {
    return `You are one high-recall research capture perna in an EBM pipeline.

QUESTION_ID: ${opts.questionId}
QUESTION: ${opts.question}
${domainLine}MODE: ${opts.mode}

Return ONLY JSON matching schema_version 1.0 from .claude/schemas/research-candidate-set.json.
Goal: maximize recall of credible candidate documents before Opus/MCP triage.
Rules:
- Prefer Tier 1 indexed sources: major guidelines, systematic reviews/meta-analyses, landmark RCTs, high-impact journals, Cochrane, major societies, reference textbooks, Scite/Consensus/PubMed-indexed signals.
- Include books/reference works when they are authoritative, using fallback_id such as ISBN or stable publisher/org id.
- Candidate documents are NOT final evidence. Set triage_status="candidate" and validation_status="unverified" unless externally verified.
- Capture 10-25 candidates when available, including non-obvious documents that conventional PubMed searches may miss.
- Do not invent PMIDs. Use null when PMID is absent or not expected for guideline/book/web source.
- Use missing_expected_documents for obvious anchor papers/guidelines you expected but could not locate.
- Use provider_gaps for search limitations, quota, unclear indexing, or uncertainty.
- Do not add markdown fences, preamble, or postamble.`;
  }

  return `You are one research perna in an EBM pipeline.

QUESTION_ID: ${opts.questionId}
QUESTION: ${opts.question}
${domainLine}MODE: ${opts.mode}

Return ONLY JSON matching schema_version 1.0 from .claude/schemas/research-perna-output.json.
Rules:
- Do not add markdown fences, preamble, or postamble.
- Keep 3-5 findings maximum.
- Put all unverified PMIDs in candidate_pmids_unverified.
- Set verified=false unless you actually verified a source externally.
- Use gaps when the answer is incomplete or the provider cannot verify a claim.
- "I do not know" with a gap is better than fabricating PMIDs.`;
}

function buildGeminiPayload(opts, schema) {
  const cfg = DEFAULTS.gemini;
  const model = opts.model || cfg.model;
  const temperature = opts.mode === 'deterministic' ? cfg.deterministicTemperature : cfg.exploratoryTemperature;
  return {
    endpoint: `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=$GEMINI_API_KEY`,
    request: {
      contents: [{ parts: [{ text: buildPrompt(opts) }] }],
      tools: [{ google_search: {} }],
      generationConfig: {
        temperature,
        maxOutputTokens: cfg.maxOutputTokens,
        thinkingConfig: { thinkingBudget: cfg.thinkingBudget },
        responseMimeType: 'application/json',
        responseJsonSchema: providerSchema(schema),
      },
    },
  };
}

function buildPerplexityPayload(opts, schema) {
  const cfg = DEFAULTS.perplexity;
  const model = opts.model || cfg.model;
  const domain = opts.domainContext ? ` Domain focus: ${opts.domainContext}.` : '';
  const temperature = opts.mode === 'deterministic' ? cfg.deterministicTemperature : cfg.exploratoryTemperature;
  const schemaName = opts.outputKind === 'candidates' ? 'research_candidate_set' : 'research_perna_output';
  const systemRole = opts.outputKind === 'candidates'
    ? `Return only JSON that matches the provided JSON Schema. Optimize for high recall of Tier 1 candidate documents, landmark trials, indexed guidelines, reference books, and non-obvious sources. Mark everything unverified until triage.${domain}`
    : `Return only JSON that matches the provided JSON Schema. Prefer Tier 1 sources and mark all PMIDs as candidate until verified.${domain}`;
  return {
    endpoint: 'https://api.perplexity.ai/chat/completions',
    request: {
      model,
      messages: [
        {
          role: 'system',
          content: systemRole,
        },
        { role: 'user', content: buildPrompt(opts) },
      ],
      temperature,
      max_tokens: cfg.maxTokens,
      return_citations: true,
      search_context_size: 'high',
      reasoning_effort: cfg.reasoningEffort,
      response_format: {
        type: 'json_schema',
        json_schema: {
          name: schemaName,
          schema: providerSchema(schema),
        },
      },
    },
  };
}

function buildPayload(opts, schema) {
  if (opts.provider === 'gemini') return buildGeminiPayload(opts, schema);
  if (opts.provider === 'perplexity') return buildPerplexityPayload(opts, schema);
  throw new Error(`unsupported provider: ${opts.provider}`);
}

function noExtraKeys(obj, allowed, path, errors) {
  for (const key of Object.keys(obj)) {
    if (!allowed.includes(key)) errors.push(`${path}.${key}: additional property`);
  }
}

function validateResearchOutput(value) {
  const errors = [];
  const topKeys = [
    'schema_version',
    'produced_at',
    'research_question_id',
    'research_question',
    'external_brain_used',
    'codex_cli_version',
    'findings',
    'candidate_pmids_unverified',
    'convergence_flags',
    'confidence_overall',
    'gaps',
  ];

  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    return ['root: expected object'];
  }
  noExtraKeys(value, topKeys, 'root', errors);
  for (const key of topKeys) {
    if (!(key in value)) errors.push(`root.${key}: required`);
  }
  if (value.schema_version !== '1.0') errors.push('root.schema_version: expected 1.0');
  for (const key of ['produced_at', 'research_question_id', 'research_question']) {
    if (typeof value[key] !== 'string' || value[key].length === 0) errors.push(`root.${key}: expected non-empty string`);
  }
  if (Number.isNaN(Date.parse(value.produced_at))) errors.push('root.produced_at: expected ISO date-time');
  if (!(typeof value.external_brain_used === 'string' || value.external_brain_used === null)) errors.push('root.external_brain_used: expected string|null');
  if (!(typeof value.codex_cli_version === 'string' || value.codex_cli_version === null)) errors.push('root.codex_cli_version: expected string|null');
  if (!['high', 'medium', 'low'].includes(value.confidence_overall)) errors.push('root.confidence_overall: invalid enum');

  if (!Array.isArray(value.findings)) errors.push('root.findings: expected array');
  else {
    value.findings.forEach((finding, index) => {
      const path = `root.findings[${index}]`;
      const keys = ['claim', 'supporting_sources', 'confidence', 'convergence_signal'];
      if (!finding || typeof finding !== 'object' || Array.isArray(finding)) {
        errors.push(`${path}: expected object`);
        return;
      }
      noExtraKeys(finding, keys, path, errors);
      for (const key of keys) if (!(key in finding)) errors.push(`${path}.${key}: required`);
      if (typeof finding.claim !== 'string' || finding.claim.length === 0) errors.push(`${path}.claim: expected non-empty string`);
      if (!['high', 'medium', 'low'].includes(finding.confidence)) errors.push(`${path}.confidence: invalid enum`);
      if (typeof finding.convergence_signal !== 'string') errors.push(`${path}.convergence_signal: expected string`);
      if (!Array.isArray(finding.supporting_sources)) errors.push(`${path}.supporting_sources: expected array`);
      else {
        finding.supporting_sources.forEach((source, sourceIndex) => {
          const sourcePath = `${path}.supporting_sources[${sourceIndex}]`;
          const sourceKeys = ['type', 'value', 'verified'];
          if (!source || typeof source !== 'object' || Array.isArray(source)) {
            errors.push(`${sourcePath}: expected object`);
            return;
          }
          noExtraKeys(source, sourceKeys, sourcePath, errors);
          for (const key of sourceKeys) if (!(key in source)) errors.push(`${sourcePath}.${key}: required`);
          if (!['pmid', 'doi', 'url', 'verbatim'].includes(source.type)) errors.push(`${sourcePath}.type: invalid enum`);
          if (typeof source.value !== 'string' || source.value.length === 0) errors.push(`${sourcePath}.value: expected non-empty string`);
          if (typeof source.verified !== 'boolean') errors.push(`${sourcePath}.verified: expected boolean`);
        });
      }
    });
  }

  if (!Array.isArray(value.candidate_pmids_unverified)) errors.push('root.candidate_pmids_unverified: expected array');
  else {
    value.candidate_pmids_unverified.forEach((pmid, index) => {
      if (typeof pmid !== 'string' || !/^[0-9]+$/.test(pmid)) errors.push(`root.candidate_pmids_unverified[${index}]: expected numeric string`);
    });
  }

  if (!Array.isArray(value.convergence_flags)) errors.push('root.convergence_flags: expected array');
  else {
    value.convergence_flags.forEach((flag, index) => {
      const path = `root.convergence_flags[${index}]`;
      const keys = ['type', 'description'];
      if (!flag || typeof flag !== 'object' || Array.isArray(flag)) {
        errors.push(`${path}: expected object`);
        return;
      }
      noExtraKeys(flag, keys, path, errors);
      if (!['alignment', 'divergence', 'gap'].includes(flag.type)) errors.push(`${path}.type: invalid enum`);
      if (typeof flag.description !== 'string' || flag.description.length === 0) errors.push(`${path}.description: expected non-empty string`);
    });
  }

  if (!Array.isArray(value.gaps)) errors.push('root.gaps: expected array');
  else {
    value.gaps.forEach((gap, index) => {
      if (typeof gap !== 'string' || gap.length === 0) errors.push(`root.gaps[${index}]: expected non-empty string`);
    });
  }

  return errors;
}

function validateCandidateSet(value) {
  const errors = [];
  const topKeys = [
    'schema_version',
    'produced_at',
    'research_question_id',
    'research_question',
    'capture_perna',
    'capture_mode',
    'domain_context',
    'candidate_documents',
    'missing_expected_documents',
    'provider_gaps',
  ];

  if (!value || typeof value !== 'object' || Array.isArray(value)) return ['root: expected object'];
  noExtraKeys(value, topKeys, 'root', errors);
  for (const key of topKeys) if (!(key in value)) errors.push(`root.${key}: required`);
  if (value.schema_version !== '1.0') errors.push('root.schema_version: expected 1.0');
  for (const key of ['produced_at', 'research_question_id', 'research_question']) {
    if (typeof value[key] !== 'string' || value[key].length === 0) errors.push(`root.${key}: expected non-empty string`);
  }
  if (Number.isNaN(Date.parse(value.produced_at))) errors.push('root.produced_at: expected ISO date-time');
  if (!['gemini', 'perplexity', 'codex-xhigh', 'evidence-researcher', 'nlm', 'opus-triage'].includes(value.capture_perna)) errors.push('root.capture_perna: invalid enum');
  if (!['high_recall', 'triage', 'verification'].includes(value.capture_mode)) errors.push('root.capture_mode: invalid enum');
  if (!(typeof value.domain_context === 'string' || value.domain_context === null)) errors.push('root.domain_context: expected string|null');

  if (!Array.isArray(value.candidate_documents)) errors.push('root.candidate_documents: expected array');
  else {
    value.candidate_documents.forEach((doc, index) => {
      const path = `root.candidate_documents[${index}]`;
      const keys = [
        'title',
        'document_type',
        'source_tier',
        'indexing_signal',
        'why_candidate',
        'pmid',
        'doi',
        'url',
        'fallback_id',
        'landmark_signal',
        'evidence_hierarchy',
        'triage_status',
        'validation_status',
      ];
      if (!doc || typeof doc !== 'object' || Array.isArray(doc)) {
        errors.push(`${path}: expected object`);
        return;
      }
      noExtraKeys(doc, keys, path, errors);
      for (const key of keys) if (!(key in doc)) errors.push(`${path}.${key}: required`);
      if (typeof doc.title !== 'string' || doc.title.length === 0) errors.push(`${path}.title: expected non-empty string`);
      if (!['guideline', 'meta_analysis', 'systematic_review', 'rct', 'landmark_trial', 'book', 'consensus_statement', 'registry', 'web'].includes(doc.document_type)) errors.push(`${path}.document_type: invalid enum`);
      if (!['tier1', 'tier2', 'reference_book', 'candidate_uncertain'].includes(doc.source_tier)) errors.push(`${path}.source_tier: invalid enum`);
      if (typeof doc.indexing_signal !== 'string') errors.push(`${path}.indexing_signal: expected string`);
      if (typeof doc.why_candidate !== 'string' || doc.why_candidate.length === 0) errors.push(`${path}.why_candidate: expected non-empty string`);
      if (!(doc.pmid === null || (typeof doc.pmid === 'string' && /^[0-9]+$/.test(doc.pmid)))) errors.push(`${path}.pmid: expected numeric string|null`);
      for (const key of ['doi', 'url', 'fallback_id']) {
        if (!(doc[key] === null || typeof doc[key] === 'string')) errors.push(`${path}.${key}: expected string|null`);
      }
      if (!['landmark', 'practice_changing', 'supporting', 'uncertain'].includes(doc.landmark_signal)) errors.push(`${path}.landmark_signal: invalid enum`);
      if (!['guideline', 'meta_analysis', 'systematic_review', 'rct', 'observational', 'reference_book', 'expert_consensus', 'other'].includes(doc.evidence_hierarchy)) errors.push(`${path}.evidence_hierarchy: invalid enum`);
      if (!['candidate', 'triage_keep', 'triage_reject', 'defer'].includes(doc.triage_status)) errors.push(`${path}.triage_status: invalid enum`);
      if (!['unverified', 'pmid_verified', 'doi_verified', 'url_verified', 'rejected_false_positive'].includes(doc.validation_status)) errors.push(`${path}.validation_status: invalid enum`);
    });
  }

  for (const key of ['missing_expected_documents', 'provider_gaps']) {
    if (!Array.isArray(value[key])) errors.push(`root.${key}: expected array`);
    else {
      value[key].forEach((item, index) => {
        if (typeof item !== 'string' || item.length === 0) errors.push(`root.${key}[${index}]: expected non-empty string`);
      });
    }
  }
  return errors;
}

function validateByKind(kind, value) {
  if (kind === 'candidates') return validateCandidateSet(value);
  if (kind === 'final') return validateResearchOutput(value);
  throw new Error('--output-kind must be candidates or final');
}

function stripJsonFences(text) {
  return text.trim().replace(/^```(?:json)?\s*/i, '').replace(/\s*```$/i, '').trim();
}

function parseProviderOutput(provider, data) {
  if (provider === 'gemini') {
    if (data.error) throw new Error(`gemini api_error: ${JSON.stringify(data.error).slice(0, 500)}`);
    const finish = data.candidates?.[0]?.finishReason;
    if (finish === 'MAX_TOKENS') throw new Error('gemini max_tokens_truncated');
    const text = (data.candidates?.[0]?.content?.parts ?? []).map((part) => part.text ?? '').join('').trim();
    if (!text) throw new Error('gemini empty text output');
    return JSON.parse(stripJsonFences(text));
  }

  if (provider === 'perplexity') {
    if (data.error) throw new Error(`perplexity api_error: ${JSON.stringify(data.error).slice(0, 500)}`);
    const text = data.choices?.[0]?.message?.content;
    if (!text) throw new Error('perplexity malformed_response: missing choices[0].message.content');
    return JSON.parse(stripJsonFences(text));
  }

  throw new Error(`unsupported provider: ${provider}`);
}

async function callProvider(opts, payload) {
  if (opts.provider === 'gemini' && !process.env.GEMINI_API_KEY) {
    throw new Error('GEMINI_API_KEY not set');
  }
  if (opts.provider === 'perplexity' && !process.env.PERPLEXITY_API_KEY) {
    throw new Error('PERPLEXITY_API_KEY not set');
  }

  const endpoint = opts.provider === 'gemini'
    ? payload.endpoint.replace('$GEMINI_API_KEY', process.env.GEMINI_API_KEY)
    : payload.endpoint;
  const headers = opts.provider === 'gemini'
    ? { 'Content-Type': 'application/json' }
    : { 'Content-Type': 'application/json', Authorization: `Bearer ${process.env.PERPLEXITY_API_KEY}` };
  const timeoutMs = opts.provider === 'gemini' ? DEFAULTS.gemini.timeoutMs : DEFAULTS.perplexity.timeoutMs;

  const res = await fetch(endpoint, {
    method: 'POST',
    headers,
    body: JSON.stringify(payload.request),
    signal: AbortSignal.timeout(timeoutMs),
  });

  if (!res.ok) {
    const body = await res.text().catch(() => '<unread>');
    throw new Error(`http_error ${res.status} ${res.statusText}: ${body.slice(0, 500)}`);
  }

  return res.json();
}

function writeJson(path, value) {
  mkdirSync(dirname(path), { recursive: true });
  writeFileSync(path, `${JSON.stringify(value, null, 2)}\n`);
}

function artifactBase(opts) {
  const target = opts.outPath
    ? resolve(REPO_ROOT, opts.outPath)
    : resolve(REPO_ROOT, `.claude/.research-tmp/${opts.provider}-${opts.questionId}.json`);
  return target.endsWith('.json') ? target.slice(0, -5) : target;
}

function writeFailureArtifacts(opts, raw, error) {
  const base = artifactBase(opts);
  const rawPath = `${base}.raw.json`;
  const failurePath = `${base}.failure.json`;
  writeJson(rawPath, raw);
  writeJson(failurePath, {
    error: 'provider_parse_failed',
    provider: opts.provider,
    question_id: opts.questionId,
    message: error.message,
    raw_artifact: rawPath,
  });
  return { rawPath, failurePath };
}

function writeFailureArtifact(opts, details) {
  const failurePath = `${artifactBase(opts)}.failure.json`;
  writeJson(failurePath, {
    provider: opts.provider || null,
    question_id: opts.questionId || null,
    ...details,
  });
  return failurePath;
}

function collectPmids(value) {
  const pmids = new Set();
  for (const pmid of value.candidate_pmids_unverified ?? []) {
    if (/^[0-9]+$/.test(pmid)) pmids.add(pmid);
  }
  for (const finding of value.findings ?? []) {
    for (const source of finding.supporting_sources ?? []) {
      if (source.type === 'pmid' && /^[0-9]+$/.test(source.value)) pmids.add(source.value);
    }
  }
  return [...pmids];
}

function applyPmidVerification(value, checkedPmids, verifiedPmids) {
  const out = JSON.parse(JSON.stringify(value));
  const checkedSet = new Set(checkedPmids);
  const verifiedSet = new Set(verifiedPmids);
  const unverified = new Set(out.candidate_pmids_unverified ?? []);
  let resetNonPmidVerified = false;

  for (const finding of out.findings ?? []) {
    for (const source of finding.supporting_sources ?? []) {
      if (source.type !== 'pmid') {
        if (source.verified === true) {
          source.verified = false;
          resetNonPmidVerified = true;
        }
        continue;
      }
      if (!checkedSet.has(source.value)) continue;
      source.verified = verifiedSet.has(source.value);
      if (source.verified) unverified.delete(source.value);
      else unverified.add(source.value);
    }
  }

  for (const pmid of checkedSet) {
    if (verifiedSet.has(pmid)) unverified.delete(pmid);
    else unverified.add(pmid);
  }

  out.candidate_pmids_unverified = [...unverified].filter((pmid) => /^[0-9]+$/.test(pmid));
  out.convergence_flags.push({
    type: verifiedSet.size > 0 ? 'alignment' : 'gap',
    description: `NCBI ESummary verified ${verifiedSet.size}/${checkedSet.size} checked PMID(s).`,
  });

  const invalidPmids = [...checkedSet].filter((pmid) => !verifiedSet.has(pmid));
  if (invalidPmids.length) {
    out.convergence_flags.push({
      type: 'divergence',
      description: `NCBI ESummary did not verify PMID(s): ${invalidPmids.join(', ')}.`,
    });
  }
  if (resetNonPmidVerified) {
    out.convergence_flags.push({
      type: 'gap',
      description: 'Non-PMID sources were not reverified by this runner; DOI/URL/verbatim verified flags were reset to false.',
    });
  }

  if (checkedSet.size > 0 && invalidPmids.length / checkedSet.size > 0.1) {
    out.confidence_overall = 'low';
  }

  return out;
}

async function verifyPmidsWithNcbi(value, opts) {
  const limit = Number.isFinite(opts.verifyLimit) && opts.verifyLimit > 0 ? Math.floor(opts.verifyLimit) : 5;
  const pmids = collectPmids(value).slice(0, limit);
  if (!pmids.length) {
    const out = JSON.parse(JSON.stringify(value));
    out.convergence_flags.push({ type: 'gap', description: 'No PMID candidates to verify via NCBI ESummary.' });
    return out;
  }

  const endpoint = `https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&id=${pmids.join(',')}&retmode=json`;
  const res = await fetch(endpoint, { signal: AbortSignal.timeout(30_000) });
  if (!res.ok) {
    const out = JSON.parse(JSON.stringify(value));
    out.gaps.push(`NCBI ESummary verification failed: http ${res.status} ${res.statusText}`);
    out.convergence_flags.push({ type: 'gap', description: 'PMID verification unavailable due to NCBI HTTP failure.' });
    return out;
  }

  const data = await res.json();
  const verified = pmids.filter((pmid) => {
    const record = data.result?.[pmid];
    return record?.uid === pmid && typeof record.title === 'string' && record.title.length > 0;
  });
  return applyPmidVerification(value, pmids, verified);
}

function sampleOutput() {
  return {
    schema_version: '1.0',
    produced_at: new Date('2026-04-28T00:00:00.000Z').toISOString(),
    research_question_id: 'smoke',
    research_question: 'What is PRISMA 2020?',
    external_brain_used: 'self-test',
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
    convergence_flags: [{ type: 'gap', description: 'self-test does not verify PMID' }],
    confidence_overall: 'medium',
    gaps: ['No live provider call in self-test'],
  };
}

function sampleCandidateSet() {
  return {
    schema_version: '1.0',
    produced_at: new Date('2026-04-28T00:00:00.000Z').toISOString(),
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
  };
}

function runSelfTest() {
  const valid = sampleOutput();
  const validErrors = validateResearchOutput(valid);
  if (validErrors.length) throw new Error(`valid fixture failed: ${validErrors.join('; ')}`);

  const invalid = { ...valid, extra: true, findings: [{ claim: '' }] };
  const invalidErrors = validateResearchOutput(invalid);
  if (!invalidErrors.length) throw new Error('invalid fixture unexpectedly passed');

  const verified = applyPmidVerification(valid, ['33782057'], ['33782057']);
  const verifiedErrors = validateResearchOutput(verified);
  if (verifiedErrors.length) throw new Error(`verified fixture failed: ${verifiedErrors.join('; ')}`);
  if (verified.findings[0].supporting_sources[0].verified !== true) throw new Error('verified fixture did not update source');

  const candidateErrors = validateCandidateSet(sampleCandidateSet());
  if (candidateErrors.length) throw new Error(`candidate fixture failed: ${candidateErrors.join('; ')}`);

  console.log(JSON.stringify({
    ok: true,
    checks: ['valid fixture', 'invalid fixture', 'pmid verification fixture', 'candidate fixture'],
    invalidErrors,
  }, null, 2));
}

const opts = parseArgs(process.argv.slice(2));

if (opts.selfTest) {
  runSelfTest();
  process.exit(0);
}

if (opts.validateFile) {
  const inputPath = resolve(REPO_ROOT, opts.validateFile);
  const input = JSON.parse(readFileSync(inputPath, 'utf8'));
  const inputErrors = validateByKind(opts.outputKind, input);
  if (inputErrors.length) {
    console.error(JSON.stringify({ error: 'schema_validation_failed', errors: inputErrors }, null, 2));
    process.exit(5);
  }

  const finalOutput = opts.verifyPmids && opts.outputKind === 'final' ? await verifyPmidsWithNcbi(input, opts) : input;
  const finalErrors = validateByKind(opts.outputKind, finalOutput);
  if (finalErrors.length) {
    console.error(JSON.stringify({ error: 'post_verification_schema_validation_failed', errors: finalErrors }, null, 2));
    process.exit(6);
  }

  const finalJson = JSON.stringify(finalOutput, null, 2);
  if (opts.outPath) {
    const outPath = resolve(REPO_ROOT, opts.outPath);
    mkdirSync(dirname(outPath), { recursive: true });
    writeFileSync(outPath, `${finalJson}\n`);
    console.error(`Wrote ${outPath}`);
  } else {
    console.log(finalJson);
  }
  process.exit(0);
}

if (!opts.question) opts.question = await readStdin();

if (!opts.provider || !opts.questionId || !opts.question) {
  usage();
  process.exit(1);
}
if (!['gemini', 'perplexity'].includes(opts.provider)) throw new Error('--provider must be gemini or perplexity');
if (!['exploratory', 'deterministic'].includes(opts.mode)) throw new Error('--mode must be exploratory or deterministic');
if (!['candidates', 'final'].includes(opts.outputKind)) throw new Error('--output-kind must be candidates or final');

const schema = loadSchema(opts.outputKind);
const payload = buildPayload(opts, schema);

if (opts.dryRun) {
  console.log(JSON.stringify({
    provider: opts.provider,
    question_id: opts.questionId,
    mode: opts.mode,
    payload,
  }, null, 2));
  process.exit(0);
}

let raw;
try {
  raw = await callProvider(opts, payload);
} catch (error) {
  const failurePath = writeFailureArtifact(opts, {
    error: 'provider_call_failed',
    message: error.message,
  });
  console.error(JSON.stringify({
    error: 'provider_call_failed',
    provider: opts.provider,
    question_id: opts.questionId,
    message: error.message,
    failure_artifact: failurePath,
  }, null, 2));
  process.exit(3);
}

let parsed;
try {
  parsed = parseProviderOutput(opts.provider, raw);
} catch (error) {
  const artifacts = writeFailureArtifacts(opts, raw, error);
  console.error(JSON.stringify({
    error: 'provider_parse_failed',
    provider: opts.provider,
    question_id: opts.questionId,
    message: error.message,
    failure_artifact: artifacts.failurePath,
    raw_artifact: artifacts.rawPath,
  }, null, 2));
  process.exit(4);
}

const errors = validateByKind(opts.outputKind, parsed);
if (errors.length) {
  const failurePath = writeFailureArtifact(opts, {
    error: 'schema_validation_failed',
    errors,
  });
  console.error(JSON.stringify({ error: 'schema_validation_failed', errors, failure_artifact: failurePath }, null, 2));
  process.exit(5);
}

const finalOutput = opts.verifyPmids && opts.outputKind === 'final' ? await verifyPmidsWithNcbi(parsed, opts) : parsed;
const finalErrors = validateByKind(opts.outputKind, finalOutput);
if (finalErrors.length) {
  const failurePath = writeFailureArtifact(opts, {
    error: 'post_verification_schema_validation_failed',
    errors: finalErrors,
  });
  console.error(JSON.stringify({
    error: 'post_verification_schema_validation_failed',
    errors: finalErrors,
    failure_artifact: failurePath,
  }, null, 2));
  process.exit(6);
}

const finalJson = JSON.stringify(finalOutput, null, 2);
if (opts.outPath) {
  const outPath = resolve(REPO_ROOT, opts.outPath);
  mkdirSync(dirname(outPath), { recursive: true });
  writeFileSync(outPath, `${finalJson}\n`);
  console.error(`Wrote ${outPath}`);
} else {
  console.log(finalJson);
}
