#!/usr/bin/env node
// perplexity-research.mjs — Perplexity Sonar deep-research with Tier 1 citations
// Uso (Perna 5 do research skill):
//   node .claude/scripts/perplexity-research.mjs "<prompt>"
//   echo "<prompt>" | node .claude/scripts/perplexity-research.mjs
//
// Requer: PERPLEXITY_API_KEY.
// Pattern canonical: substitui node -e inline (bloqueado por deny list S227 KBP-26).
// Reference: .claude/skills/research/SKILL.md Perna 5.

const prompt = process.argv[2] || await new Promise((resolve) => {
  let data = '';
  process.stdin.on('data', (c) => (data += c));
  process.stdin.on('end', () => resolve(data.trim()));
});

if (!prompt) {
  console.error('Usage: perplexity-research.mjs "<prompt>"  OR  echo "<prompt>" | perplexity-research.mjs');
  process.exit(1);
}

if (!process.env.PERPLEXITY_API_KEY) {
  console.error('ERROR: PERPLEXITY_API_KEY not set');
  process.exit(1);
}

const SYSTEM_PROMPT = 'Return findings as markdown tables ONLY. No prose paragraphs. Every finding = 1 column in a table with rows: Author+Year, Title, Journal, PMID, DOI, Population, Intervention, Comparator, Outcome, Effect size, CI 95%, I², N studies, N patients, Clinical significance (1-2 sentences). Mark all PMIDs as CANDIDATE. Only Tier 1 sources (NEJM, Lancet, JAMA, BMJ, Ann Intern Med, Cochrane). NO introductions, NO conclusions — ONLY the table.';

const res = await fetch('https://api.perplexity.ai/chat/completions', {
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
    temperature: 0.8,
    max_tokens: 8000,
    return_citations: true,
    search_context_size: 'high',
  }),
});

const data = await res.json();
console.log(data.choices?.[0]?.message?.content || JSON.stringify(data));

if (data.citations?.length) {
  console.log('\n--- CITATIONS ---');
  data.citations.forEach((c, i) => console.log(`${i + 1}. ${c}`));
}
