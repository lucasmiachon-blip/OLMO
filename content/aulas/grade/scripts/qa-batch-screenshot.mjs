#!/usr/bin/env node
/**
 * QA Batch Screenshots — Grade
 *
 * Adapted from cirrose QA script. Captures screenshots + readability metrics.
 * Focus: legibility at 5m projection distance (minimum font-size audit).
 *
 * Usage:
 *   node grade/scripts/qa-batch-screenshot.mjs
 *   node grade/scripts/qa-batch-screenshot.mjs --slide s-10
 *   node grade/scripts/qa-batch-screenshot.mjs --range 1-20
 *
 * Options:
 *   --slide  Single slide ID (e.g., s-10)
 *   --range  Slide range by file number (e.g., 1-20, 30-58)
 *   --port   Dev server port (default: 3000)
 *   --scale  Device scale factor (default: 2)
 *   --all    Capture all 58 slides
 *
 * Output: qa-screenshots/{slide-id}/{slide}_{date}_{time}_{state}.png
 *
 * Readability check (C8): flags text elements with computed font-size < 18px
 * at 1280x720. At standard projection (~2m screen, 5m viewing distance),
 * 18px ≈ 7mm glyph height — the minimum for normal visual acuity.
 */

import { chromium } from 'playwright';
import { mkdirSync, writeFileSync, readdirSync, unlinkSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const GRADE = join(__dirname, '..');
const OUT_BASE = join(GRADE, 'qa-screenshots');

// --- Args ---
const args = process.argv.slice(2);

if (args.includes('--help') || args.includes('-h')) {
  console.log(`Usage: node qa-batch-screenshot.mjs [options]

Options:
  --slide <id>    Single slide ID (e.g., s-10)
  --range <N-M>   Slide range by file number (e.g., 1-20)
  --all           All slides (default if no filter given)
  --port <N>      Dev server port (default: 3000)
  --scale <N>     Device scale factor (default: 2)

Output: qa-screenshots/{slide-id}/{slide}_{date}_{time}.png`);
  process.exit(0);
}

function getArg(name, fallback) {
  const idx = args.indexOf(`--${name}`);
  return idx >= 0 && args[idx + 1] ? args[idx + 1] : fallback;
}

const PORT = getArg('port', '3000');
const SINGLE_SLIDE = getArg('slide', null);
const RANGE = getArg('range', null);
const SCALE = parseInt(getArg('scale', '2'));

const NOW = new Date();
const DATE_STAMP = NOW.toISOString().slice(0, 10);
const TIME_STAMP = String(NOW.getHours()).padStart(2, '0') + String(NOW.getMinutes()).padStart(2, '0');

const PAGE_URL = `http://localhost:${PORT}/grade/index.html`;

// Import manifest
const { slides } = await import(pathToFileURL(join(GRADE, 'slides', '_manifest.js')).href);

// Build index map
const slideIndexMap = new Map();
slides.forEach((s, i) => slideIndexMap.set(s.id, i));

// Determine target slides
let targetSlides;
if (SINGLE_SLIDE) {
  targetSlides = slides.filter(s => s.id === SINGLE_SLIDE);
  if (targetSlides.length === 0) throw new Error(`Slide ${SINGLE_SLIDE} not found`);
} else if (RANGE) {
  const [start, end] = RANGE.split('-').map(Number);
  targetSlides = slides.filter(s => {
    const num = parseInt(s.file.replace('.html', ''));
    return num >= start && num <= end;
  });
} else {
  targetSlides = slides; // default: all
}

console.log(`\nQA Batch Screenshots — GRADE`);
console.log(`Port: ${PORT} | Scale: ${SCALE}x | Slides: ${targetSlides.length}`);
console.log(`Target: ${SINGLE_SLIDE || RANGE || 'ALL'}\n`);

// --- Readability audit ---
// Minimum font-size for 5m viewing distance on ~2m projected screen
const MIN_FONT_PX = 18;

async function measureElements(page, slideId) {
  return page.evaluate(({ id, minFont }) => {
    const section = document.querySelector(`#${id}`);
    if (!section) return null;

    const result = { slideId: id, elements: {}, computed: {}, readability: {} };

    // Measure key elements
    const classes = [
      'section-tag', 'slide-headline', 'slide-inner',
      'source-tag', 'lead', 'evidence',
      'flow-container', 'compare-grid'
    ];

    for (const cls of classes) {
      const el = section.querySelector(`.${cls}`);
      if (el) {
        const r = el.getBoundingClientRect();
        result.elements[cls] = {
          top: Math.round(r.top), bottom: Math.round(r.bottom),
          width: Math.round(r.width), height: Math.round(r.height),
        };
      }
    }

    // h2 measurement
    const h2 = section.querySelector('h2');
    if (h2) {
      const r = h2.getBoundingClientRect();
      result.elements['h2'] = {
        top: Math.round(r.top), bottom: Math.round(r.bottom),
        width: Math.round(r.width), height: Math.round(r.height),
        text: h2.textContent.trim().slice(0, 80),
        lines: Math.round(r.height / parseFloat(getComputedStyle(h2).lineHeight)),
      };
    }

    // --- Readability audit: measure computed font-size of ALL visible text ---
    const inner = section.querySelector('.slide-inner');
    const tooSmall = [];
    let smallestFont = Infinity;
    let totalTextElements = 0;

    if (inner) {
      const walker = document.createTreeWalker(inner, NodeFilter.SHOW_TEXT, {
        acceptNode(node) {
          // Skip notes, hidden elements
          if (node.parentElement.closest('aside')) return NodeFilter.FILTER_REJECT;
          if (node.textContent.trim().length === 0) return NodeFilter.FILTER_REJECT;
          const style = getComputedStyle(node.parentElement);
          if (style.display === 'none' || style.visibility === 'hidden' || style.opacity === '0') {
            return NodeFilter.FILTER_REJECT;
          }
          return NodeFilter.FILTER_ACCEPT;
        }
      });

      const seen = new Set();
      while (walker.nextNode()) {
        const el = walker.currentNode.parentElement;
        if (seen.has(el)) continue;
        seen.add(el);
        totalTextElements++;

        const style = getComputedStyle(el);
        const fontSize = parseFloat(style.fontSize);
        if (fontSize < smallestFont) smallestFont = fontSize;

        if (fontSize < minFont) {
          tooSmall.push({
            tag: el.tagName.toLowerCase(),
            class: el.className?.split?.(' ')?.[0] || '',
            fontSize: Math.round(fontSize * 10) / 10,
            text: el.textContent.trim().slice(0, 50),
          });
        }
      }

      // Fill ratio
      const ir = inner.getBoundingClientRect();
      let minTop = Infinity, maxBottom = 0;
      for (const child of inner.children) {
        if (child.tagName === 'ASIDE') continue;
        const cr = child.getBoundingClientRect();
        if (cr.height === 0 || getComputedStyle(child).opacity === '0') continue;
        minTop = Math.min(minTop, cr.top);
        maxBottom = Math.max(maxBottom, cr.bottom);
      }
      result.computed.fillRatio = Math.round(((maxBottom - minTop) / ir.height) * 100) / 100;

      // Word count
      const clone = inner.cloneNode(true);
      const notes = clone.querySelector('aside');
      if (notes) notes.remove();
      result.computed.bodyWordCount = clone.textContent.trim().split(/\s+/).filter(w => w.length > 0).length;
    }

    result.readability = {
      smallestFontPx: smallestFont === Infinity ? null : Math.round(smallestFont * 10) / 10,
      totalTextElements,
      belowMinimum: tooSmall.length,
      tooSmallElements: tooSmall.slice(0, 10), // top 10
    };

    return result;
  }, { id: slideId, minFont: MIN_FONT_PX });
}

// --- Automated checks ---
const EXEMPT = new Set(['title']);

function runChecks(metrics, slide, consoleErrors) {
  const checks = [];
  const m = metrics?.computed || {};
  const r = metrics?.readability || {};
  const els = metrics?.elements || {};

  // C1: Body word count
  if (m.bodyWordCount != null && m.bodyWordCount > 40) {
    checks.push({ id: 'C1', rule: 'bodyWordCount<=40', status: 'FAIL', value: m.bodyWordCount,
      msg: `Body has ${m.bodyWordCount} words (max 40 for readability)` });
  } else if (m.bodyWordCount != null) {
    checks.push({ id: 'C1', rule: 'bodyWordCount<=40', status: 'PASS', value: m.bodyWordCount });
  }

  // C2: Fill ratio
  if (m.fillRatio != null && !EXEMPT.has(slide.archetype)) {
    if (m.fillRatio > 0.95) {
      checks.push({ id: 'C2', rule: 'fillRatio<=0.95', status: 'FAIL', value: m.fillRatio,
        msg: 'Content overflows slide area' });
    } else if (m.fillRatio < 0.20) {
      checks.push({ id: 'C2', rule: 'fillRatio>=0.20', status: 'WARN', value: m.fillRatio,
        msg: 'Very low fill ratio — slide may look empty' });
    } else {
      checks.push({ id: 'C2', rule: 'fillRatio', status: 'PASS', value: m.fillRatio });
    }
  }

  // C3: h2 present
  if (!EXEMPT.has(slide.archetype)) {
    if (!els.h2) {
      checks.push({ id: 'C3', rule: 'h2Present', status: 'WARN', msg: 'No h2 found' });
    } else {
      checks.push({ id: 'C3', rule: 'h2Present', status: 'PASS' });
      if (els.h2.lines > 2) {
        checks.push({ id: 'C4', rule: 'h2Lines<=2', status: 'WARN', value: els.h2.lines,
          msg: `h2 wraps to ${els.h2.lines} lines` });
      }
    }
  }

  // C5: Console errors
  if (consoleErrors?.length > 0) {
    checks.push({ id: 'C5', rule: 'noConsoleErrors', status: 'FAIL', value: consoleErrors.length,
      msg: `${consoleErrors.length} JS error(s): ${consoleErrors[0].slice(0, 80)}` });
  } else {
    checks.push({ id: 'C5', rule: 'noConsoleErrors', status: 'PASS' });
  }

  // C8: READABILITY — minimum font-size for 5m viewing distance
  if (r.belowMinimum > 0) {
    const worst = r.tooSmallElements[0];
    checks.push({ id: 'C8', rule: `minFont>=${MIN_FONT_PX}px`, status: 'FAIL',
      value: r.smallestFontPx,
      msg: `${r.belowMinimum} text element(s) below ${MIN_FONT_PX}px. Smallest: ${r.smallestFontPx}px (${worst.tag}.${worst.class}: "${worst.text.slice(0, 30)}")` });
  } else if (r.totalTextElements > 0) {
    checks.push({ id: 'C8', rule: `minFont>=${MIN_FONT_PX}px`, status: 'PASS',
      value: r.smallestFontPx });
  }

  const failCount = checks.filter(c => c.status === 'FAIL').length;
  const warnCount = checks.filter(c => c.status === 'WARN').length;
  return { checks, failCount, warnCount, passAll: failCount === 0 };
}

async function main() {
  const browser = await chromium.launch({ headless: true });
  try {
    const context = await browser.newContext({
      viewport: { width: 1280, height: 720 },
      deviceScaleFactor: SCALE,
    });
    const page = await context.newPage();

    const consoleErrors = [];
    page.on('console', msg => { if (msg.type() === 'error') consoleErrors.push(msg.text()); });
    page.on('pageerror', err => consoleErrors.push(err.message));

    console.log(`Loading ${PAGE_URL}...`);
    await page.goto(PAGE_URL, { waitUntil: 'networkidle' });
    await page.waitForTimeout(2000);

    const results = [];

    for (const slide of targetSlides) {
      const targetIndex = slideIndexMap.get(slide.id);
      const slideDir = join(OUT_BASE, slide.id);
      mkdirSync(slideDir, { recursive: true });

      // Clean old files
      const oldFiles = readdirSync(slideDir).filter(f => f.endsWith('.png'));
      for (const f of oldFiles) unlinkSync(join(slideDir, f));

      // Navigate
      await page.evaluate(idx => window.__deckGoTo(idx), targetIndex);
      await page.waitForTimeout(1200);

      // Verify
      const activeId = await page.evaluate(() => {
        for (const s of document.querySelectorAll('section[id]')) {
          if (s.classList.contains('slide-active')) return s.id;
        }
        return 'unknown';
      });

      // Screenshot
      const fileName = `${slide.id}_${DATE_STAMP}_${TIME_STAMP}.png`;
      await page.screenshot({ path: join(slideDir, fileName), type: 'png' });

      // Metrics + readability
      const metrics = await measureElements(page, slide.id);
      const slideConsoleErrors = consoleErrors.length > 0 ? [...consoleErrors] : undefined;
      consoleErrors.length = 0;

      const checkResult = runChecks(metrics, slide, slideConsoleErrors);

      writeFileSync(
        join(slideDir, 'metrics.json'),
        JSON.stringify({
          slideId: slide.id, archetype: slide.archetype,
          timestamp: `${DATE_STAMP}_${TIME_STAMP}`,
          screenshot: fileName,
          readability: metrics?.readability,
          computed: metrics?.computed,
          checks: checkResult.checks,
          failCount: checkResult.failCount,
          warnCount: checkResult.warnCount,
        }, null, 2)
      );

      // Print results
      const tag = checkResult.passAll ? '✓' : `✗`;
      const fontInfo = metrics?.readability?.smallestFontPx
        ? ` | smallest: ${metrics.readability.smallestFontPx}px`
        : '';
      console.log(`[${slide.id}] (${activeId})${fontInfo}`);

      for (const c of checkResult.checks) {
        if (c.status === 'FAIL') console.log(`  ✗ [FAIL] ${c.id}: ${c.msg}`);
        else if (c.status === 'WARN') console.log(`  ⚠ [WARN] ${c.id}: ${c.msg}`);
      }
      if (checkResult.passAll) console.log(`  ✓ all checks pass`);

      results.push({ id: slide.id, path: slideDir, checks: checkResult, readability: metrics?.readability });
    }

    // Batch manifest
    const totalFails = results.reduce((a, r) => a + r.checks.failCount, 0);
    const totalWarns = results.reduce((a, r) => a + r.checks.warnCount, 0);

    // Readability summary
    const readabilityFails = results.filter(r => r.readability?.belowMinimum > 0);
    const allSmallest = results
      .filter(r => r.readability?.smallestFontPx != null)
      .map(r => ({ id: r.id, px: r.readability.smallestFontPx, below: r.readability.belowMinimum }))
      .sort((a, b) => a.px - b.px);

    const manifest = {
      runDate: DATE_STAMP, runTime: TIME_STAMP,
      minFontThreshold: MIN_FONT_PX,
      slides: results.map(r => ({
        slideId: r.id,
        failCount: r.checks.failCount, warnCount: r.checks.warnCount,
        passAll: r.checks.passAll,
        smallestFontPx: r.readability?.smallestFontPx,
        textBelowMinimum: r.readability?.belowMinimum,
      })),
      totalSlides: results.length,
      totalFails, totalWarns,
      readabilitySummary: {
        slidesWithSmallText: readabilityFails.length,
        worstSlides: allSmallest.slice(0, 10),
      },
      allPass: totalFails === 0,
    };
    writeFileSync(join(OUT_BASE, 'batch-manifest.json'), JSON.stringify(manifest, null, 2));

    // Summary
    console.log('\n=== SUMMARY ===');
    console.log(`Slides: ${results.length} | Fails: ${totalFails} | Warns: ${totalWarns}`);
    console.log(`\n--- Readability (min ${MIN_FONT_PX}px for 5m distance) ---`);
    if (readabilityFails.length === 0) {
      console.log('✓ All slides pass readability check');
    } else {
      console.log(`✗ ${readabilityFails.length}/${results.length} slides have text below ${MIN_FONT_PX}px:`);
      for (const s of allSmallest.slice(0, 15)) {
        console.log(`  ${s.id}: ${s.px}px (${s.below} element(s) too small)`);
      }
    }
    console.log(`\nManifest: qa-screenshots/batch-manifest.json`);
  } finally {
    await browser.close();
  }
}

main().catch(err => {
  console.error(err);
  process.exitCode = 1;
});
