/* ============================================================================
 * content/aulas/shared-v2/js/presenter-safe.js
 * Presenter-mode auto-setup via URL params — letterbox + keybinds + safe mode.
 *
 * URL params (combinable):
 *   ?lock=1  — ativa letterbox #deck-wrapper + ResizeObserver clamp + teclas F/B/?
 *   ?safe=1  — força reduced-motion (independente de lock, válido sozinho em dev)
 *
 * Auto-run (sem export): <script type="module"> é deferred — equivalente a
 * DOMContentLoaded. Mocks NÃO precisam declarar wrapper manualmente;
 * ensureWrapper() auto-envelopa [data-slide] no primeiro setup. Ordering
 * natural em dialog.html: import presenter-safe → setupDeck → setupReveal.
 *
 * Contracts (S239 §5):
 *   1. URLSearchParams detect (não regex)
 *   2. html[data-presenter-mode="locked"] via setAttribute
 *   3. Wrapper #deck-wrapper auto-criado; box-shadow letterbox aplicado no wrapper (CSS)
 *   4. ResizeObserver em documentElement; clamp [0.5, 2.5]; console.warn se clamp
 *   5. Redundância HDMI: screen.orientation + matchMedia landscape
 *   6. ?safe=1 → html[data-reduced-motion="forced"] (motion.js respeita)
 *   7. F: fullscreen toggle via requestFullscreen/exitFullscreen
 *   8. B: blackout via dataset.blackout toggle
 *   9. ? (shift+/): help overlay lazy-create + toggle .visible
 *
 * F vs F11: F11 nativo do browser também entra fullscreen; document.fullscreenElement
 * reflete estado, toggleFullscreen subsequente funciona. Ensaio HDMI testa F E F11.
 *
 * Lifetime: ES module singleton = session lifetime. Listeners permanentes, sem
 * teardown exportado. Dev HMR pode duplicar listeners (não afeta produção static).
 * ==========================================================================*/

const params = new URLSearchParams(location.search);
const LOCK = params.get('lock') === '1';
const SAFE = params.get('safe') === '1';
const html = document.documentElement;

if (SAFE) html.setAttribute('data-reduced-motion', 'forced');

function ensureWrapper() {
  let wrapper = document.getElementById('deck-wrapper');
  if (wrapper) return wrapper;
  const slides = [...document.querySelectorAll('[data-slide]')];
  if (slides.length === 0) return null;
  wrapper = document.createElement('div');
  wrapper.id = 'deck-wrapper';
  const firstSlide = slides[0];
  firstSlide.parentNode.insertBefore(wrapper, firstSlide);
  for (const s of slides) wrapper.appendChild(s);
  return wrapper;
}

function recompute() {
  const raw = Math.min(window.innerWidth / 1280, window.innerHeight / 720);
  const clamped = Math.max(0.5, Math.min(2.5, raw));
  html.style.setProperty('--deck-scale', String(clamped));
  if (raw !== clamped) {
    console.warn('[presenter-safe] scale clamped', { raw, clamped });
  }
}

function toggleFullscreen() {
  if (document.fullscreenElement) {
    document.exitFullscreen();
  } else {
    html.requestFullscreen();
  }
}

function toggleBlackout() {
  if (html.dataset.blackout === 'true') delete html.dataset.blackout;
  else html.dataset.blackout = 'true';
}

function toggleHelp() {
  let el = document.getElementById('presenter-keybindings');
  if (!el) {
    el = document.createElement('div');
    el.id = 'presenter-keybindings';
    el.textContent = '←/→ nav · Space next · Home/End primeiro/último · F fullscreen · B blackout · ? este overlay';
    document.body.appendChild(el);
  }
  el.classList.toggle('visible');
}

function shouldSkip(e) {
  if (e.ctrlKey || e.altKey || e.metaKey) return true;
  const a = document.activeElement;
  return !!(a && (a.tagName === 'INPUT' || a.tagName === 'TEXTAREA' || a.isContentEditable));
}

function handleKey(e) {
  if (shouldSkip(e)) return;
  switch (e.key) {
    case 'f': case 'F':
      e.preventDefault();
      toggleFullscreen();
      break;
    case 'b': case 'B':
      e.preventDefault();
      toggleBlackout();
      break;
    case '?':
      e.preventDefault();
      toggleHelp();
      break;
  }
}

if (LOCK) {
  html.setAttribute('data-presenter-mode', 'locked');
  ensureWrapper();
  recompute();
  new ResizeObserver(recompute).observe(html);
  screen.orientation?.addEventListener('change', recompute);
  window.matchMedia('(orientation: landscape)').addEventListener('change', recompute);
  window.addEventListener('keydown', handleKey);
}
