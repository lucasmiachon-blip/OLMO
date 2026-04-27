#!/usr/bin/env node
// perplexity-research.mjs — Perplexity Sonar deep-research with Tier 1 citations
// Uso (Perna 5 do research skill):
//   node .claude/scripts/perplexity-research.mjs "<prompt>"
//   node .claude/scripts/perplexity-research.mjs --domain-context "hepatology" "<prompt>"
//   echo "<prompt>" | node .claude/scripts/perplexity-research.mjs
//
// Requer: PERPLEXITY_API_KEY.
// Pattern canonical: substitui node -e inline (bloqueado por deny list S227 KBP-26).
// Reference: .claude/skills/research/SKILL.md Perna 5.
//
// S261 hardening (6 fixes line-cited do legado):
//   D.6  — res.ok HTTP guard antes de res.json()
//   D.7  — AbortSignal.timeout(120s) — sonar-deep-research é mais lento
//   D.8  — temperature 0.8 → 0.2 (citation retrieval = deterministic, hallucination risk)
//   D.9  — --domain-context flag injeta clinical specificity em SYSTEM_PROMPT
//   D.10 — Silent fallback `|| JSON.stringify(data)` removido — explicit exit 5
//   D.11 — data.error field check (mesma falha mode que gemini)
//
// Exit codes: 0=ok | 1=usage/key | 3=API/HTTP error | 4=timeout | 5=malformed (no choices)

// D.9 — Parse args (--domain-context optional flag + positional prompt)
const args = process.argv.slice(2);
let domainContext = '';
let prompt = '';
for (let i = 0; i < args.length; i++) {
  if (args[i] === '--domain-context' && i + 1 < args.length) {
    domainContext = args[i + 1];
    i++;
  } else if (!prompt) {
    prompt = args[i];
  }
}

if (!prompt) {
  prompt = await new Promise((resolve) => {
    let data = '';
    process.stdin.on('data', (c) => (data += c));
    process.stdin.on('end', () => resolve(data.trim()));
  });
}

if (!prompt) {
  console.error('Usage: perplexity-research.mjs [--domain-context "<domain>"] "<prompt>"  OR  echo "<prompt>" | perplexity-research.mjs');
  process.exit(1);
}

if (!process.env.PERPLEXITY_API_KEY) {
  console.error('ERROR: PERPLEXITY_API_KEY not set');
  process.exit(1);
}

// D.9 — SYSTEM_PROMPT parameterized with optional domain-context injection
const DOMAIN_CLAUSE = domainContext ? ` Clinical domain focus: ${domainContext}.` : '';
const SYSTEM_PROMPT = `Return findings as markdown tables ONLY. No prose paragraphs. Every finding = 1 column in a table with rows: Author+Year, Title, Journal, PMID, DOI, Population, Intervention, Comparator, Outcome, Effect size, CI 95%, I², N studies, N patients, Clinical significance (1-2 sentences). Mark all PMIDs as CANDIDATE. Only Tier 1 sources (NEJM, Lancet, JAMA, BMJ, Ann Intern Med, Cochrane).${DOMAIN_CLAUSE} NO introductions, NO conclusions — ONLY the table.`;

let res;
try {
  res = await fetch('https://api.perplexity.ai/chat/completions', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${process.env.PERPLEXITY_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'sonar-deep-research',
      messages: [
        { role: 'system', content: SYSTEM_PROMPT },
        { role: 'user', content: prompt },
      ],
      temperature: 0.2,  // D.8 — was 0.8 (citation retrieval = deterministic)
      max_tokens: 8000,
      return_citations: true,
      search_context_size: 'high',
    }),
    // D.7 — AbortSignal timeout 120s
    signal: AbortSignal.timeout(120_000),
  });
} catch (err) {
  console.error(JSON.stringify({ error: 'fetch_failed', message: err.message, code: err.code || err.name }));
  process.exit(err.name === 'TimeoutError' ? 4 : 3);
}

// D.6 — HTTP status guard
if (!res.ok) {
  let errBody = '<unread>';
  try { errBody = await res.text(); } catch {}
  console.error(JSON.stringify({ error: 'http_error', status: res.status, statusText: res.statusText, body: errBody.slice(0, 500) }));
  process.exit(3);
}

const data = await res.json();

// D.11 — data.error field check (Perplexity quota/auth fail)
if (data.error) {
  console.error(JSON.stringify({ error: 'api_error', perplexity_error: data.error }));
  process.exit(3);
}

// D.10 — Replace silent fallback with explicit error
const content = data.choices?.[0]?.message?.content;
if (!content) {
  console.error(JSON.stringify({ error: 'malformed_response', hint: 'No choices[0].message.content', raw: JSON.stringify(data).slice(0, 1000) }));
  process.exit(5);
}
console.log(content);

if (data.citations?.length) {
  console.log('\n--- CITATIONS ---');
  data.citations.forEach((c, i) => console.log(`${i + 1}. ${c}`));
}
