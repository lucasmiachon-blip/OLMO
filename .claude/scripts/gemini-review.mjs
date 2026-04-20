#!/usr/bin/env node
// gemini-review.mjs — adversarial/objective review de um arquivo via Gemini 3.1 Pro
// Uso:
//   node .claude/scripts/gemini-review.mjs <file-path> [--framing adversarial|objective]
//   node .claude/scripts/gemini-review.mjs .claude/plans/generic-snuggling-cloud.md --framing adversarial
//
// Requer: GEMINI_API_KEY no env.
// Pattern canonical: substitui node -e inline (bloqueado por deny list S227 KBP-26).

import fs from 'node:fs';

const args = process.argv.slice(2);
const filePath = args[0];
const framingIdx = args.indexOf('--framing');
const framing = framingIdx >= 0 ? args[framingIdx + 1] : 'adversarial';

if (!filePath) {
  console.error('Usage: node gemini-review.mjs <file-path> [--framing adversarial|objective]');
  process.exit(1);
}

if (!process.env.GEMINI_API_KEY) {
  console.error('ERROR: GEMINI_API_KEY not set in env');
  process.exit(1);
}

const content = fs.readFileSync(filePath, 'utf8');

const basePrompt = `You are reviewing an engineering plan for an AI agent system (OLMO — medical education on Claude Code, solo medico-developer Lucas, 2-day pre-production window before resuming slide production).

${framing === 'adversarial'
  ? 'Mode: ADVERSARIAL. Find flaws, over-promises, hidden dependencies, missed alternatives. Push back hard. The plan already has its own self-adversarial section — catch what the author STILL missed.'
  : 'Mode: OBJECTIVE deep-think. Weigh tradeoffs honestly. Use Google search for 2025-2026 state-of-the-art verification.'}

Prior external review (Codex GPT-5.4) already flagged:
- SOA framing stale: vendor direction 2026 = context engineering + typed handoffs + eval gates, NOT vector-memory-first
- Living-HTML migration should precede retrieval benchmarking (S227 anti-pattern unresolved)
- Orchestration gates > per-worker prose checklists
- memory-audit skill under-specified — needs precision/recall benchmark

Your task: independent triangulation via Google search grounding. Confirm/disagree Codex findings + identify what Codex ALSO missed.

<<<FILE_START>>>
${content}
<<<FILE_END>>>

Return (max 700 words, no markdown bloat):
CONFIRM_OR_DISAGREE: for each Codex P1 finding — cite 2025-2026 evidence
BEYOND_CODEX: 2 specific items Codex also missed with sources
NEWER_WORK: 2 papers/frameworks newer than April 17 2026 (verify recency via search)
FINAL_VERDICT: recommended 3 concrete moves for 2-day pre-production window`;

const res = await fetch(
  `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent?key=${process.env.GEMINI_API_KEY}`,
  {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      contents: [{ parts: [{ text: basePrompt }] }],
      tools: [{ google_search: {} }],
      generationConfig: {
        temperature: 1,
        maxOutputTokens: 32768,
        thinkingConfig: { thinkingBudget: 16384 },
      },
    }),
  },
);

const data = await res.json();
const finish = data.candidates?.[0]?.finishReason;
if (finish === 'MAX_TOKENS') console.error('WARNING: Truncated (MAX_TOKENS).');
const parts = data.candidates?.[0]?.content?.parts ?? [];
if (!parts.some((p) => p.text)) {
  console.error('ERROR: 0 text output — thinking consumed all tokens. Increase maxOutputTokens or decrease thinkingBudget.');
  console.error(JSON.stringify(data, null, 2));
  process.exit(2);
}
parts.forEach((p) => p.text && console.log(p.text));

// Citations / grounding metadata
const grounding = data.candidates?.[0]?.groundingMetadata;
if (grounding?.groundingChunks?.length) {
  console.log('\n--- SOURCES ---');
  grounding.groundingChunks.forEach((c, i) => {
    const title = c.web?.title ?? '(no title)';
    const uri = c.web?.uri ?? '';
    console.log(`${i + 1}. ${title} ${uri}`);
  });
}
