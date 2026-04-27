#!/usr/bin/env node
// gemini-research.mjs — Gemini 3.1 Pro deep-think research with google_search grounding
// Uso (Perna 1 do research skill):
//   node .claude/scripts/gemini-research.mjs "<prompt>"
//   echo "<prompt>" | node .claude/scripts/gemini-research.mjs
//
// Requer: GEMINI_API_KEY.
// Pattern canonical: substitui node -e inline (bloqueado por deny list S227 KBP-26).
// Reference: .claude/skills/research/SKILL.md Perna 1.
//
// S261 hardening (5 fixes line-cited do legado):
//   D.1 — res.ok HTTP guard antes de res.json() (antes: silent failure mascarado)
//   D.2 — AbortSignal.timeout(60s) em fetch (antes: hang potencial sem guard)
//   D.3 — data.error field inspection (Gemini API quota/auth → 200 + error obj)
//   D.4 — MAX_TOKENS = exit 4 (antes: warn + continue, caller ingere truncado)
//   D.5 — Pre-check prompt length vs thinkingBudget (warn se >50%)
//
// Exit codes: 0=ok | 1=usage/key | 2=empty output (thinking consumed) | 3=API/HTTP error | 4=MAX_TOKENS truncated

const prompt = process.argv[2] || await new Promise((resolve) => {
  let data = '';
  process.stdin.on('data', (c) => (data += c));
  process.stdin.on('end', () => resolve(data.trim()));
});

if (!prompt) {
  console.error('Usage: gemini-research.mjs "<prompt>"  OR  echo "<prompt>" | gemini-research.mjs');
  process.exit(1);
}

if (!process.env.GEMINI_API_KEY) {
  console.error('ERROR: GEMINI_API_KEY not set');
  process.exit(1);
}

// D.5 — Prompt length pre-check vs thinkingBudget (rough char→token ~4/1)
const THINKING_BUDGET = 16384;
const promptTokensEstimate = Math.ceil(prompt.length / 4);
if (promptTokensEstimate > THINKING_BUDGET / 2) {
  console.error(`WARN: prompt ~${promptTokensEstimate} tokens (>50% of thinkingBudget=${THINKING_BUDGET}). Risk of 0 output (thinking consumes all tokens). Consider shorter prompt.`);
}

let res;
try {
  res = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent?key=${process.env.GEMINI_API_KEY}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        tools: [{ google_search: {} }],
        generationConfig: {
          temperature: 1,
          maxOutputTokens: 32768,
          thinkingConfig: { thinkingBudget: THINKING_BUDGET },
        },
      }),
      // D.2 — AbortSignal timeout 60s
      signal: AbortSignal.timeout(60_000),
    },
  );
} catch (err) {
  console.error(JSON.stringify({ error: 'fetch_failed', message: err.message, code: err.code || err.name }));
  process.exit(3);
}

// D.1 — HTTP status guard
if (!res.ok) {
  let errBody = '<unread>';
  try { errBody = await res.text(); } catch {}
  console.error(JSON.stringify({ error: 'http_error', status: res.status, statusText: res.statusText, body: errBody.slice(0, 500) }));
  process.exit(3);
}

const data = await res.json();

// D.3 — data.error field inspection
if (data.error) {
  console.error(JSON.stringify({ error: 'api_error', code: data.error.code, message: data.error.message, status: data.error.status }));
  process.exit(3);
}

const finish = data.candidates?.[0]?.finishReason;
if (finish === 'MAX_TOKENS') {
  // D.4 — MAX_TOKENS = exit 4
  console.error(JSON.stringify({ error: 'max_tokens_truncated', finish, hint: 'Output truncated; reduce prompt or increase maxOutputTokens.' }));
  process.exit(4);
}

const parts = data.candidates?.[0]?.content?.parts ?? [];
if (!parts.some((p) => p.text)) {
  console.error('ERROR: 0 text output — thinking consumed all tokens.');
  process.exit(2);
}
parts.forEach((p) => p.text && console.log(p.text));

const grounding = data.candidates?.[0]?.groundingMetadata;
if (grounding?.groundingChunks?.length) {
  console.log('\n--- SOURCES ---');
  grounding.groundingChunks.forEach((c, i) => {
    const title = c.web?.title ?? '(no title)';
    const uri = c.web?.uri ?? '';
    console.log(`${i + 1}. ${title} ${uri}`);
  });
}
