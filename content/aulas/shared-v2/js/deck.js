/* ============================================================================
 * content/aulas/shared-v2/js/deck.js
 * Deck navigation engine — keybindings + hash/popstate + aria-live announcer.
 *
 * API (Q3 hybrid named + default export):
 *   setupDeck({slidesSelector='[data-slide]'}) — attach listeners, initial slide
 *   nextSlide / prevSlide / firstSlide / lastSlide / goToSlide(key)
 *
 * Keybindings (skip if modifier OR editable focus):
 *   ArrowRight/Space/PageDown → next
 *   ArrowLeft/PageUp         → prev
 *   Home/End                 → first/last
 *   F, B, ?, Esc             → NOT intercepted (presenter-safe.js OR reserved)
 *
 * Hash sync: location.hash = '#{data-slide}', history.pushState em nav.
 * hashchange + popstate listeners redundantes (setActive idempotente).
 *
 * Visibility: [hidden] attribute (semantic + ARIA-tree removal).
 *
 * Announcer: aria-live="polite" aria-atomic="true" sr-only div criado inline
 * (zero surface CSS). Anuncia "Slide X de Y: {título}" em nav e load inicial.
 * textContent clear + rAF set força re-read em nav para mesma key.
 *
 * Integration: transition() envolve DOM mutations (VT API captura start/end).
 * revealAll(new) + resetReveal(prev) chamados dentro do transition callback.
 *
 * Ordering (N≥2 slides): call setupDeck() BEFORE setupReveal().
 * setupDeck hides non-active slides via [hidden], prevenindo
 * IntersectionObserver de trigger reveals em offscreen slides.
 * Para N=1 (mocks atuais hero/evidence) a ordem não importa.
 * ==========================================================================*/

import { revealAll, resetReveal } from './reveal.js';
import { transition } from './motion.js';

const STATE = {
  slides: [],
  index: 0,
  announcer: null,
};

function getSlideKey(slide) {
  return slide.dataset.slide;
}

function getTitle(slide) {
  const el = slide.querySelector('h1, h2, .slide-headline, .slide-claim');
  return el?.textContent?.trim() ?? '';
}

function createAnnouncer() {
  const div = document.createElement('div');
  div.setAttribute('aria-live', 'polite');
  div.setAttribute('aria-atomic', 'true');
  div.style.cssText =
    'position:absolute;width:1px;height:1px;margin:-1px;padding:0;' +
    'overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0;';
  return div;
}

// aria-live polite anuncia em diff de texto. Clear + rAF set força re-read
// quando re-navegamos para slide com mesmo título (popstate, goToSlide repetido).
function announce(message) {
  if (!STATE.announcer) return;
  STATE.announcer.textContent = '';
  requestAnimationFrame(() => {
    STATE.announcer.textContent = message;
  });
}

function setActive(newIndex) {
  const clamped = Math.max(0, Math.min(STATE.slides.length - 1, newIndex));
  if (clamped === STATE.index) return;

  const prev = STATE.slides[STATE.index];
  const next = STATE.slides[clamped];

  transition(() => {
    prev.hidden = true;
    next.hidden = false;
    resetReveal(prev);
    revealAll(next);
  });

  STATE.index = clamped;

  const key = getSlideKey(next);
  if (key && location.hash !== `#${key}`) {
    history.pushState({ key }, '', `#${key}`);
  }

  announce(`Slide ${clamped + 1} de ${STATE.slides.length}: ${getTitle(next)}`);
}

export function nextSlide() { setActive(STATE.index + 1); }
export function prevSlide() { setActive(STATE.index - 1); }
export function firstSlide() { setActive(0); }
export function lastSlide() { setActive(STATE.slides.length - 1); }

export function goToSlide(key) {
  const target = STATE.slides.findIndex(s => getSlideKey(s) === key);
  if (target < 0) return;
  setActive(target);
}

function shouldSkip(e) {
  if (e.ctrlKey || e.altKey || e.metaKey) return true;
  const active = document.activeElement;
  if (!active) return false;
  const tag = active.tagName;
  return tag === 'INPUT' || tag === 'TEXTAREA' || active.isContentEditable;
}

function handleKey(e) {
  if (shouldSkip(e)) return;
  switch (e.key) {
    case 'ArrowRight':
    case ' ':
    case 'PageDown':
      e.preventDefault();
      nextSlide();
      break;
    case 'ArrowLeft':
    case 'PageUp':
      e.preventDefault();
      prevSlide();
      break;
    case 'Home':
      e.preventDefault();
      firstSlide();
      break;
    case 'End':
      e.preventDefault();
      lastSlide();
      break;
    // F, B, ?, Esc, outras: não intercepta (presenter-safe exclusive ou reservado)
  }
}

function handleHashOrPop() {
  const key = location.hash.replace(/^#/, '');
  if (!key) return;
  goToSlide(key);
}

export function setupDeck({ slidesSelector = '[data-slide]' } = {}) {
  STATE.slides = [...document.querySelectorAll(slidesSelector)];
  if (STATE.slides.length === 0) return;

  const hashKey = location.hash.replace(/^#/, '');
  let startIndex = 0;
  if (hashKey) {
    const found = STATE.slides.findIndex(s => getSlideKey(s) === hashKey);
    if (found >= 0) startIndex = found;
  }
  STATE.index = startIndex;
  STATE.slides.forEach((s, i) => { s.hidden = i !== startIndex; });

  STATE.announcer = createAnnouncer();
  document.body.appendChild(STATE.announcer);

  window.addEventListener('keydown', handleKey);
  window.addEventListener('hashchange', handleHashOrPop);
  window.addEventListener('popstate', handleHashOrPop);

  // Initial announce após rAF: garante announcer no DOM + diff detectável.
  requestAnimationFrame(() => {
    const slide = STATE.slides[startIndex];
    announce(`Slide ${startIndex + 1} de ${STATE.slides.length}: ${getTitle(slide)}`);
  });
}

export default { setupDeck, nextSlide, prevSlide, firstSlide, lastSlide, goToSlide };
