/* ============================================================================
 * content/aulas/shared-v2/js/reveal.js
 * Declarative reveal engine via [data-reveal] attribute.
 *
 * Pattern: JS toggla classes (.revealed), CSS faz transição (motion/
 * transitions.css). Zero animate() direto — reveal é CSS-authoritative.
 * motion.js.animate() reservado para slide-registry.js futuro (counter
 * count-up, chart morph, etc).
 *
 * API:
 *   setupReveal(root)   — scan + IntersectionObserver setup (DOMContentLoaded)
 *   revealAll(slide)    — força reveal em todos [data-reveal] do slide (deck nav)
 *   resetReveal(slide)  — remove .revealed + re-observa (volta ao estado inicial)
 *
 * Stagger (Q2 R2):
 *   data-reveal-stagger="fast|base|slow" — auto-cumulative. Delay para cada
 *     element = calc(var(--motion-stagger-{value}) * index), onde index é
 *     posição entre siblings diretos do parent com mesmo stagger value.
 *   data-reveal-delay="<raw>"             — escape hatch: aceita ms/calc/var.
 *   Ambos presentes: stagger wins.
 *
 * Trigger (Q2 R1 hybrid):
 *   (a) IntersectionObserver default — scroll-reveal em slides longos.
 *       threshold=0.1, rootMargin='0px 0px -10% 0px', unobserve após 1st reveal.
 *   (b) revealAll(slide) chamado por deck.js em nav — coverage garantida quando
 *       slide vira active, independente de scroll.
 * ==========================================================================*/

const OBSERVER_OPTIONS = {
  threshold: 0.1,
  rootMargin: '0px 0px -10% 0px',
};

function applyStagger(el) {
  const stagger = el.dataset.revealStagger;
  const delay = el.dataset.revealDelay;

  if (stagger) {
    const parent = el.parentElement;
    if (!parent) return;
    const siblings = [...parent.querySelectorAll(`:scope > [data-reveal-stagger="${stagger}"]`)];
    const index = siblings.indexOf(el);
    if (index > 0) {
      el.style.transitionDelay = `calc(var(--motion-stagger-${stagger}) * ${index})`;
    }
  } else if (delay) {
    el.style.transitionDelay = delay;
  }
}

let observer = null;

function getObserver() {
  if (observer) return observer;
  observer = new IntersectionObserver((entries, obs) => {
    for (const entry of entries) {
      if (entry.isIntersecting) {
        entry.target.classList.add('revealed');
        obs.unobserve(entry.target);
      }
    }
  }, OBSERVER_OPTIONS);
  return observer;
}

export function setupReveal(root = document) {
  const elements = root.querySelectorAll('[data-reveal]');
  const obs = getObserver();
  for (const el of elements) {
    applyStagger(el);
    obs.observe(el);
  }
}

export function revealAll(slide) {
  const obs = getObserver();
  for (const el of slide.querySelectorAll('[data-reveal]')) {
    el.classList.add('revealed');
    obs.unobserve(el);
  }
}

export function resetReveal(slide) {
  const obs = getObserver();
  for (const el of slide.querySelectorAll('[data-reveal]')) {
    el.classList.remove('revealed');
    obs.observe(el); // re-enter observer para próximo scroll-in ou nav
  }
}

export default { setupReveal, revealAll, resetReveal };
