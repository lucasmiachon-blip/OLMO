/* ============================================================================
 * content/aulas/shared-v2/js/motion.js
 * WAAPI helpers + View Transitions wrapper + reduced-motion guard.
 *
 * API (Q3 brief, hybrid named + default export):
 *   animate(el, keyframes, options) -> Promise
 *   transition(callback) -> ViewTransition | ViewTransition-shaped mock
 *   prefersReducedMotion() -> boolean
 *
 * Reduced-motion guard obrigatório em animate(): se user prefers reduce OU
 * html[data-reduced-motion="forced"] (set by presenter-safe.js via ?safe=1),
 * pula WAAPI e aplica final state direto via el.style. Zero element.animate()
 * nesse path. Retorna Promise.resolve() para manter contrato async uniforme.
 *
 * matchMedia é cached (1 query/session) + listener live-updates cache em
 * change event. Attribute check é per-call (lookup barato). Defesa
 * REDUNDANTE a tokens/*.css @media blocks — ambos caminhos (JS + CSS)
 * respeitam reduced-motion (ADR-0005 §A11y).
 *
 * Consumers esperados: reveal.js (toggla classes, zero animate() direto),
 * slide-registry.js futuro (animações imperativas per-slide).
 * ==========================================================================*/

const mediaQuery = window.matchMedia('(prefers-reduced-motion: reduce)');
let reducedByMedia = mediaQuery.matches;

// Listener intencionalmente permanente — lifetime do módulo = lifetime da session.
// Não aplicável em SSR/hot-reload de dev (não afeta produção de apresentação).
mediaQuery.addEventListener('change', event => {
  reducedByMedia = event.matches;
});

export function prefersReducedMotion() {
  const forced = document.documentElement.dataset.reducedMotion === 'forced';
  return reducedByMedia || forced;
}

/* WAAPI keyframes aceita 2 formatos:
 *  Array form:  [{ opacity: 0, translate: '0 16px' }, { opacity: 1, translate: '0 0' }]
 *  Object form: { opacity: [0, 1], translate: ['0 16px', '0 0'] }
 * finalState extrai último estado de qualquer formato. */
function finalState(keyframes) {
  if (Array.isArray(keyframes)) {
    return keyframes[keyframes.length - 1] ?? {};
  }
  const state = {};
  for (const [prop, val] of Object.entries(keyframes)) {
    state[prop] = Array.isArray(val) ? val[val.length - 1] : val;
  }
  return state;
}

function applyFinalState(el, keyframes) {
  const state = finalState(keyframes);
  for (const [prop, value] of Object.entries(state)) {
    // Skip WAAPI meta keys (offset/easing/composite) — não são CSS props
    if (prop === 'offset' || prop === 'easing' || prop === 'composite') continue;
    if (prop.startsWith('--')) {
      el.style.setProperty(prop, value);
    } else {
      el.style[prop] = value;
    }
  }
}

export function animate(el, keyframes, options = {}) {
  if (prefersReducedMotion()) {
    applyFinalState(el, keyframes);
    return Promise.resolve();
  }
  const animation = el.animate(keyframes, options);
  return animation.finished;
}

/**
 * @param {() => void | Promise<void>} callback
 * @returns {ViewTransition | {finished: Promise, ready: Promise, updateCallbackDone: Promise}}
 * Retorna ViewTransition nativo (Chrome 111+) ou mock duck-type com as 3
 * Promises esperadas. Consumer pode fazer `await t.finished` sem checar gate.
 */
export function transition(callback) {
  if (prefersReducedMotion() || typeof document.startViewTransition !== 'function') {
    const result = callback();
    const resolved = Promise.resolve(result);
    return {
      finished: resolved,
      ready: resolved,
      updateCallbackDone: resolved,
    };
  }
  return document.startViewTransition(callback);
}

export default { animate, transition, prefersReducedMotion };
