/**
 * apca-audit.mjs — APCA contrast audit for slide CSS tokens
 *
 * Usage: node scripts/apca-audit.mjs
 * Deps: apca-w3, colorjs.io (devDependencies)
 *
 * Computes APCA Lc (perceptual contrast) for foreground/background pairs.
 * Thresholds based on APCA guidelines for projected content:
 *   Lc >= 75  body text at 10m projection
 *   Lc >= 60  large text / headings
 *   Lc >= 45  decorative / non-critical
 */

import Color from 'colorjs.io';
import { APCAcontrast, sRGBtoY } from 'apca-w3';

// --- Token definitions (source: metanalise.css + base.css) ---
const tokens = {
  // s-quality accents
  'q-study':      'oklch(48% 0.18 85)',
  'q-process':    'oklch(48% 0.16 185)',
  'q-evidence':   'oklch(48% 0.20 258)',
  'q-fail-fill':  'oklch(52% 0.20 10)',
  'q-pass-text':  'oklch(35% 0.16 170)',
  'q-pass-border':'oklch(50% 0.14 170)',

  // s-quality backgrounds
  'q-bg-study':   'oklch(92% 0.03 85)',
  'q-bg-process': 'oklch(92% 0.03 185)',
  'q-bg-evidence':'oklch(92% 0.03 258)',
  'q-pass-bg':    'oklch(94% 0.02 170)',

  // base tokens
  'bg-elevated':  'oklch(98% 0.005 258)',
  'bg-surface':   'oklch(95% 0.01 258)',
  'text-primary': 'oklch(13% 0.02 258)',
  'text-secondary':'oklch(35% 0.01 258)',
};

function toRGB(oklchStr) {
  const c = new Color(oklchStr).to('srgb');
  return c.coords.map(v => Math.max(0, Math.min(255, Math.round(v * 255))));
}

// [foreground, background, description, threshold]
const pairs = [
  // Primary text on backgrounds
  ['text-primary',  'bg-surface',     'h3 question on slide bg',     75],
  ['text-secondary','bg-surface',     'description on slide bg',     60],
  ['text-primary',  'q-bg-study',     'h3 on study card bg',         75],
  ['text-primary',  'q-bg-process',   'h3 on process card bg',       75],
  ['text-primary',  'q-bg-evidence',  'h3 on evidence card bg',      75],

  // White text on colored pills
  ['bg-elevated',   'q-study',        'white on study pill (RoB 2)', 60],
  ['bg-elevated',   'q-process',      'white on process pill (AMSTAR-2)', 60],
  ['bg-elevated',   'q-evidence',     'white on evidence pill (GRADE)', 60],

  // Punchline badges
  ['bg-elevated',   'q-fail-fill',    'white on fail badge (punchline)', 75],
  ['q-pass-text',   'q-pass-bg',      'green text on pass badge bg', 60],

  // Numbers on slide bg
  ['q-study',       'bg-surface',     'number 1 (amber) on slide bg', 45],
  ['q-process',     'bg-surface',     'number 2 (teal) on slide bg',  45],
  ['q-evidence',    'bg-surface',     'number 3 (blue) on slide bg',  45],

  // Borders (visual, not text — lower threshold)
  ['q-study',       'q-bg-study',     'left border on card bg',       30],
  ['q-process',     'q-bg-process',   'left border on card bg',       30],
  ['q-evidence',    'q-bg-evidence',  'left border on card bg',       30],
];

console.log('APCA Contrast Audit — s-quality tokens');
console.log('═'.repeat(60));
console.log('Lc >= 75 body@10m | >= 60 large | >= 45 deco | >= 30 border\n');

let fails = 0;
for (const [fgKey, bgKey, desc, threshold] of pairs) {
  const fgRGB = toRGB(tokens[fgKey]);
  const bgRGB = toRGB(tokens[bgKey]);
  const Lc = Math.abs(APCAcontrast(sRGBtoY(fgRGB), sRGBtoY(bgRGB)));
  const pass = Lc >= threshold;
  if (!pass) fails++;

  const mark = pass ? 'PASS' : 'FAIL';
  const margin = pass ? `+${(Lc - threshold).toFixed(0)}` : `${(Lc - threshold).toFixed(0)}`;
  console.log(`${mark} Lc=${Lc.toFixed(1)} (need ${threshold}, ${margin}) | ${desc}`);
  if (!pass) {
    console.log(`  fg: ${fgKey} rgb(${fgRGB.join(',')}) → bg: ${bgKey} rgb(${bgRGB.join(',')})`);
  }
}

console.log(`\n${'═'.repeat(60)}`);
console.log(`Results: ${pairs.length - fails}/${pairs.length} PASS, ${fails} FAIL`);
if (fails === 0) console.log('All pairs meet APCA thresholds for projected content.');
