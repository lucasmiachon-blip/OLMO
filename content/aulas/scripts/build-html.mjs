#!/usr/bin/env node
/**
 * build-html.mjs — Unified slide build for all aulas
 * Replaces per-aula build-html.ps1 scripts.
 *
 * Usage: node scripts/build-html.mjs --aula metanalise
 *
 * Steps:
 *   1. Read _manifest.js → extract file: values (skip commented lines)
 *   2. Validate all slide files exist
 *   3. Ghost canary check (abort if obsolete patterns found)
 *   4. Concatenate slide HTML
 *   5. Replace %%SLIDES%% in index.template.html → index.html
 *   6. Write integrity fingerprint (.slide-integrity)
 *
 * Coautoria: Lucas + Opus 4.6 | S161
 */

import { readFileSync, writeFileSync, existsSync } from 'node:fs';
import { resolve, join } from 'node:path';
import { createHash } from 'node:crypto';
import { fileURLToPath } from 'node:url';

// --- Args ---
const aulaFlag = process.argv.indexOf('--aula');
const aula = aulaFlag !== -1 ? process.argv[aulaFlag + 1] : null;
if (!aula) {
  console.error('Usage: node scripts/build-html.mjs --aula <name>');
  process.exit(1);
}

const scriptsDir = fileURLToPath(new URL('.', import.meta.url));
const root = resolve(scriptsDir, '..', aula);
const slidesDir = join(root, 'slides');
const templatePath = join(root, 'index.template.html');
const outputPath = join(root, 'index.html');
const manifestPath = join(slidesDir, '_manifest.js');

// --- 1. Read manifest ---
if (!existsSync(manifestPath)) {
  console.error(`Manifest not found: ${manifestPath}`);
  process.exit(1);
}

const manifestRaw = readFileSync(manifestPath, 'utf-8');
const activeLines = manifestRaw
  .split('\n')
  .filter(line => !/^\s*\/\//.test(line));
const activeContent = activeLines.join('\n');

const fileRegex = /file:\s*['"]([^'"]+)['"]/g;
const files = [];
let match;
while ((match = fileRegex.exec(activeContent)) !== null) {
  files.push(match[1]);
}

if (files.length === 0) {
  console.error('No slide files found in manifest');
  process.exit(1);
}

// --- 2. Validate files ---
for (const f of files) {
  if (!existsSync(join(slidesDir, f))) {
    console.error(`Missing slide file: ${f}`);
    process.exit(1);
  }
}

// --- 3. Ghost canary ---
const canaryPath = join(root, '.ghost-canary');
if (existsSync(canaryPath)) {
  const ghostFails = [];
  const canaryLines = readFileSync(canaryPath, 'utf-8').split('\n');

  for (const raw of canaryLines) {
    const line = raw.trim();
    if (!line || line.startsWith('#')) continue;
    const pipeIdx = line.indexOf('|');
    if (pipeIdx === -1) continue;
    const ghostFile = line.slice(0, pipeIdx);
    const ghostPattern = line.slice(pipeIdx + 1);
    const ghostPath = join(slidesDir, ghostFile);
    if (existsSync(ghostPath)) {
      const content = readFileSync(ghostPath, 'utf-8');
      if (new RegExp(ghostPattern).test(content)) {
        ghostFails.push(`  -> ${ghostFile} matches '${ghostPattern}'`);
      }
    }
  }

  if (ghostFails.length > 0) {
    console.error('');
    console.error('!! BUILD ABORTADO: Conteudo fantasma detectado !!');
    console.error('!! Slide contem padrao obsoleto listado em .ghost-canary.');
    console.error('');
    ghostFails.forEach(f => console.error(f));
    console.error('');
    console.error(`Canary: ${canaryPath}`);
    process.exit(1);
  }
}

// --- 4-5. Concatenate + template ---
if (!existsSync(templatePath)) {
  console.error(`Template not found: ${templatePath}`);
  process.exit(1);
}

const slides = files
  .map(f => readFileSync(join(slidesDir, f), 'utf-8'))
  .join('\n');

const template = readFileSync(templatePath, 'utf-8');
const html = template.replace('%%SLIDES%%', slides);
writeFileSync(outputPath, html, 'utf-8');
console.log(`Built index.html (${files.length} slides from _manifest.js)`);

// --- 6. Integrity fingerprint ---
const integrityPath = join(root, '.slide-integrity');
const currentHashes = files.map(f => {
  const content = readFileSync(join(slidesDir, f), 'utf-8');
  const hash = createHash('sha256').update(content).digest('hex').slice(0, 16);
  const idMatch = content.match(/id="([^"]+)"/);
  const sectionId = idMatch ? idMatch[1] : f;
  return `${hash} ${sectionId} ${f}`;
});

if (existsSync(integrityPath)) {
  const previous = readFileSync(integrityPath, 'utf-8').split('\n');
  const prevCount = previous.filter(l => /^\w/.test(l)).length;
  const currCount = currentHashes.length;

  if (currCount < prevCount) {
    console.warn('');
    console.warn(`!! ROLLBACK DETECTADO: slide count caiu de ${prevCount} para ${currCount} !!`);
    console.warn('!! Verifique se git merge nao reverteu slides. !!');
    console.warn('');
  }

  const prevMap = new Map();
  for (const line of previous) {
    const m = line.match(/^(\w+)\s+(\S+)\s+(.+)$/);
    if (m) prevMap.set(m[3], m[1]);
  }

  const changed = [];
  for (const line of currentHashes) {
    const m = line.match(/^(\w+)\s+(\S+)\s+(.+)$/);
    if (m && prevMap.has(m[3]) && prevMap.get(m[3]) !== m[1]) {
      changed.push(m[3]);
    }
  }

  if (changed.length > 0) {
    console.warn('');
    console.warn(`!! ATENCAO: ${changed.length} slide(s) mudaram desde o ultimo build:`);
    changed.forEach(c => console.warn(`  -> ${c}`));
    console.warn('!! Se isso foi intencional, tudo certo. Se nao, verifique git log.');
    console.warn('');
  }
}

writeFileSync(integrityPath, currentHashes.join('\n'), 'utf-8');
