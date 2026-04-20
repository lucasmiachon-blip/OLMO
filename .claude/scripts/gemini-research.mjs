#!/usr/bin/env node
// gemini-research.mjs — Gemini 3.1 Pro deep-think research with google_search grounding
// Uso (Perna 1 do research skill):
//   node .claude/scripts/gemini-research.mjs "<prompt>"
//   echo "<prompt>" | node .claude/scripts/gemini-research.mjs
//
// Requer: GEMINI_API_KEY.
// Pattern canonical: substitui node -e inline (bloqueado por deny list S227 KBP-26).
// Reference: .claude/skills/research/SKILL.md Perna 1.

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

const res = await fetch(
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
