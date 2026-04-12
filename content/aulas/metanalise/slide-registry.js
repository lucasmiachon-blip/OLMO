/**
 * slide-registry.js — Meta-análise
 * State machines for interactive slides (hook, checkpoints).
 * Pattern: cirrose slide-registry.js
 *
 * Direction param (S166): direction < 0 means backward entry.
 * Factories show final state instantly on backward, enabling symmetric navigation.
 */
// SplitText import removed S139 — click-reveal replaces auto-stagger

export const slideRegistry = {
  's-title': (slide, gsap, direction) => {
    const h1 = slide.querySelector('h1');
    const subtitle = slide.querySelector('.title-subtitle');
    const pillarSpans = slide.querySelectorAll('.pillar > span');
    const dots = slide.querySelectorAll('.pillar-dot');
    const identity = slide.querySelector('.title-identity');

    if (direction < 0) {
      // Backward: show all elements at final state
      gsap.set([h1, subtitle, identity].filter(Boolean), { opacity: 1, y: 0 });
      gsap.set(pillarSpans, { yPercent: 0 });
      gsap.set(dots, { opacity: 1 });
      return;
    }

    // Forward: full choreography
    if (h1) {
      gsap.fromTo(h1,
        { opacity: 0, y: 12 },
        { opacity: 1, y: 0, duration: 0.7, ease: 'power3.out' }
      );
    }
    if (subtitle) {
      gsap.fromTo(subtitle,
        { opacity: 0, y: 10 },
        { opacity: 1, y: 0, duration: 0.6, ease: 'power3.out', delay: 0.3 }
      );
    }
    gsap.fromTo(pillarSpans,
      { yPercent: 100 },
      { yPercent: 0, duration: 0.8, stagger: 0.2, ease: 'power3.out', delay: 0.6 }
    );
    gsap.fromTo(dots,
      { opacity: 0 },
      { opacity: 1, duration: 0.4, stagger: 0.2, delay: 0.8, ease: 'power2.out' }
    );
    if (identity) {
      gsap.fromTo(identity,
        { opacity: 0, y: 8 },
        { opacity: 1, y: 0, duration: 0.6, ease: 'power2.out', delay: 1.4 }
      );
    }
  },

  's-hook': (slide, gsap, direction) => {
    const volume = slide.querySelector('.hook-volume');
    const divider = slide.querySelector('.hook-divider');
    const facts = slide.querySelectorAll('.hook-fact');
    const nums = slide.querySelectorAll('.hook-num');

    if (direction < 0) {
      // Backward: show all elements + final number values
      gsap.set(volume, { opacity: 1, x: 0 });
      gsap.set(divider, { scaleY: 1 });
      gsap.set(facts, { opacity: 1, x: 0 });
      nums.forEach((num) => {
        const decimals = parseInt(num.getAttribute('data-decimals') || '0', 10);
        const target = decimals > 0 ? parseFloat(num.getAttribute('data-val')) : parseInt(num.getAttribute('data-val'), 10);
        num.textContent = decimals > 0
          ? target.toFixed(decimals).replace('.', ',')
          : Math.round(target);
      });
      return;
    }

    // Forward: full choreography
    const tl = gsap.timeline({ defaults: { ease: 'power3.out' } });
    tl.fromTo(volume, { opacity: 0, x: -24 }, { opacity: 1, x: 0, duration: 0.9 });
    tl.to(divider, { scaleY: 1, duration: 0.6, ease: 'expo.inOut' }, '-=0.3');
    tl.fromTo(facts, { opacity: 0, x: 24 }, { opacity: 1, x: 0, duration: 0.7, stagger: 0.25 }, '-=0.2');
    nums.forEach((num) => {
      const decimals = parseInt(num.getAttribute('data-decimals') || '0', 10);
      const target = decimals > 0 ? parseFloat(num.getAttribute('data-val')) : parseInt(num.getAttribute('data-val'), 10);
      num.textContent = '0';
      const obj = { val: 0 };
      const isVolume = num.closest('.hook-volume');
      const delay = isVolume ? 0 : (num.closest('.hook-fact') === facts[0] ? 1.0 : 1.25);
      const snapVal = decimals > 0 ? Math.pow(10, -decimals) : 1;
      gsap.to(obj, {
        val: target,
        duration: 1.4,
        delay: delay,
        ease: 'power2.out',
        snap: { val: snapVal },
        onUpdate: () => {
          num.textContent = decimals > 0
            ? obj.val.toFixed(decimals).replace('.', ',')
            : Math.round(obj.val);
        }
      });
    });
  },

  's-importancia': (slide, gsap, direction) => {
    const mechanism = slide.querySelector('.imp-mechanism');
    const groups = [1, 2, 3, 4, 5];
    let revealed = 0;
    const getGroup = (n) => slide.querySelectorAll(`[data-reveal="${n}"]`);

    if (direction < 0) {
      // Backward: show mechanism + all reveals at final state
      gsap.set(mechanism, { opacity: 1, scale: 1 });
      groups.forEach(n => {
        const items = getGroup(n);
        gsap.set(items, { opacity: 1, y: 0 });
        items.forEach(el => el.classList.add('revealed'));
      });
      revealed = groups.length;
    } else {
      // Forward: auto mechanism + click-reveals
      gsap.fromTo(mechanism,
        { opacity: 0, scale: 0.92 },
        { opacity: 1, scale: 1, duration: 0.7, ease: 'power2.out' }
      );
    }

    const advance = () => {
      if (revealed >= groups.length) return false;
      revealed++;
      const items = getGroup(revealed);
      gsap.fromTo(items,
        { opacity: 0, y: 24 },
        { opacity: 1, y: 0, duration: 0.5, ease: 'power3.out' }
      );
      items.forEach(el => el.classList.add('revealed'));
      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;
      const items = getGroup(revealed);
      gsap.to(items, { opacity: 0, y: 24, duration: 0.35, ease: 'power3.in' });
      items.forEach(el => el.classList.remove('revealed'));
      revealed--;
      return true;
    };

    slide.__clickRevealNext = advance;
    slide.__hookRetreat = retreat;
    slide.__hookCurrentBeat = () => revealed;
  },

  's-contrato': (slide, gsap, direction) => {
    const cards = slide.querySelectorAll('.contrato-card');

    const revealCard = (card) => {
      const q = card.querySelector('.contrato-question');
      const s = card.querySelector('.contrato-skill');
      const tl = gsap.timeline({ defaults: { ease: 'power3.out' } });
      tl.fromTo(card, { opacity: 0, y: 40 }, { opacity: 1, y: 0, duration: 0.6 })
        .fromTo(q, { opacity: 0, y: 12 }, { opacity: 1, y: 0, duration: 0.4 }, '-=0.2')
        .fromTo(s, { opacity: 0, y: 10 }, { opacity: 1, y: 0, duration: 0.35 }, '-=0.1');
    };

    const showCardInstant = (card) => {
      const q = card.querySelector('.contrato-question');
      const s = card.querySelector('.contrato-skill');
      gsap.set([card, q, s].filter(Boolean), { opacity: 1, y: 0 });
    };

    let revealed = 0;
    const clickCards = [cards[1], cards[2]];

    if (direction < 0) {
      // Backward: all 3 cards visible at final state
      cards.forEach(c => showCardInstant(c));
      revealed = clickCards.length;
    } else {
      // Forward: card 1 auto, cards 2-3 click-reveal
      revealCard(cards[0]);
    }

    const advance = () => {
      if (revealed >= clickCards.length) return false;
      revealCard(clickCards[revealed]);
      revealed++;
      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;
      revealed--;
      const card = clickCards[revealed];
      const q = card.querySelector('.contrato-question');
      const s = card.querySelector('.contrato-skill');
      gsap.to([card, q, s], { opacity: 0, y: 20, duration: 0.3, ease: 'power3.in' });
      return true;
    };

    slide.__clickRevealNext = advance;
    slide.__hookRetreat = retreat;
    slide.__hookCurrentBeat = () => revealed;
  },

  's-pico': (slide, gsap, direction) => {
    const items = slide.querySelectorAll('.pico-item');
    const punchline = slide.querySelector('.pico-punchline');
    if (!items.length || !punchline) return;

    let state = 0;
    const MAX = 1;

    if (direction < 0) {
      // Backward: all items + punchline visible
      gsap.set(items, { opacity: 1, y: 0 });
      gsap.set(punchline, { opacity: 1, y: 0 });
      state = MAX;
    } else {
      // Forward: auto stagger P→I→C→O
      gsap.fromTo(items,
        { opacity: 0, y: 16 },
        { opacity: 1, y: 0, duration: 0.6, stagger: 0.3, ease: 'power3.out' }
      );
    }

    function advance() {
      if (state >= MAX) return false;
      state++;
      if (state === 1) {
        gsap.fromTo(punchline,
          { opacity: 0, y: 8 },
          { opacity: 1, y: 0, duration: 0.5, ease: 'power2.out' }
        );
      }
      return true;
    }

    function retreat() {
      if (state <= 0) return false;
      if (state === 1) {
        gsap.to(punchline, { opacity: 0, y: 8, duration: 0.3 });
      }
      state--;
      return true;
    }

    slide.__hookAdvance = advance;
    slide.__hookRetreat = retreat;
    slide.__hookCurrentBeat = () => state;
  },

  's-checkpoint-2': (slide, gsap, direction) => {
    const scenario = slide.querySelector('.checkpoint-scenario');
    const question = slide.querySelector('.checkpoint-question');
    const steps = slide.querySelectorAll('.checkpoint-step');
    const verdict = slide.querySelector('.checkpoint-verdict');
    if (!scenario || !question) return;

    let state = 0;
    const MAX = 3;

    if (direction < 0) {
      // Backward: all elements visible at final state
      gsap.set([scenario, question, verdict].filter(Boolean), { y: 0, opacity: 1 });
      gsap.set(steps, { y: 0, opacity: 1 });
      state = MAX;
    } else {
      // Forward: scenario + question auto
      gsap.to(scenario, { y: 0, opacity: 1, duration: 0.6, ease: 'power3.out' });
      gsap.to(question, { y: 0, opacity: 1, duration: 0.6, delay: 0.3, ease: 'power3.out' });
    }

    function advance() {
      if (state >= MAX) return false;
      state++;
      if (state === 1 && steps[0]) {
        gsap.to(steps[0], { y: 0, opacity: 1, duration: 0.5, ease: 'power3.out' });
      }
      if (state === 2) {
        if (steps[1]) gsap.to(steps[1], { y: 0, opacity: 1, duration: 0.5, ease: 'power3.out' });
        if (steps[2]) gsap.to(steps[2], { y: 0, opacity: 1, duration: 0.5, delay: 0.3, ease: 'power3.out' });
      }
      if (state === 3 && verdict) {
        gsap.to(verdict, { y: 0, opacity: 1, duration: 0.6, ease: 'power3.out' });
      }
      return true;
    }

    function retreat() {
      if (state <= 0) return false;
      if (state === 3 && verdict) {
        gsap.to(verdict, { opacity: 0, y: 12, duration: 0.3 });
      }
      if (state === 2) {
        gsap.to([steps[1], steps[2]].filter(Boolean), { opacity: 0, y: 12, duration: 0.3 });
      }
      if (state === 1 && steps[0]) {
        gsap.to(steps[0], { opacity: 0, y: 12, duration: 0.3 });
      }
      state--;
      return true;
    }

    slide.__hookAdvance = advance;
    slide.__hookRetreat = retreat;
    slide.__hookCurrentBeat = () => state;
  },

  's-objetivos': (slide, gsap, direction) => {
    const groups = [1, 2, 3];
    let revealed = 0;
    const getGroup = (n) => slide.querySelectorAll(`[data-reveal="${n}"]`);

    if (direction < 0) {
      // Backward: all groups visible at final state
      groups.forEach(n => {
        const items = getGroup(n);
        gsap.set(items, { opacity: 1, y: 0 });
        items.forEach(el => el.classList.add('revealed'));
      });
      revealed = groups.length;
    }

    const advance = () => {
      if (revealed >= groups.length) return false;
      revealed++;
      const items = getGroup(revealed);
      gsap.fromTo(items,
        { opacity: 0, y: 16 },
        { opacity: 1, y: 0, duration: 0.4, stagger: 0.12, ease: 'power2.out' }
      );
      items.forEach(el => el.classList.add('revealed'));
      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;
      const items = getGroup(revealed);
      gsap.to(items, { opacity: 0, y: 16, duration: 0.3, ease: 'power2.in' });
      items.forEach(el => el.classList.remove('revealed'));
      revealed--;
      return true;
    };

    slide.__clickRevealNext = advance;
    slide.__hookRetreat = retreat;
    slide.__hookCurrentBeat = () => revealed;
  },

  's-forest2': (slide, gsap, direction) => {
    const img = slide.querySelector('.forest-annotated img');
    const logo = slide.querySelector('.cochrane-logo');
    const annotated = slide.querySelector('.forest-annotated');
    const MAX = 7;
    let revealed = 0;
    const getReveal = (n) => slide.querySelectorAll(`[data-reveal="${n}"]`);

    // Logo: prevent click from advancing beat (professor clicks to open site)
    if (logo) {
      logo.addEventListener('click', (e) => e.stopPropagation());
    }

    if (direction < 0) {
      // Backward: show final state (all 7 beats + img + zoom)
      if (img) gsap.set(img, { opacity: 1, y: 0 });
      for (let i = 1; i <= MAX; i++) {
        const items = getReveal(i);
        if (i === 6) {
          gsap.set(items, { clipPath: 'inset(0 0 0 0)', opacity: 1 });
        } else {
          gsap.set(items, { opacity: 1 });
        }
        items.forEach(el => el.classList.add('revealed'));
      }
      if (annotated) {
        gsap.set(annotated, { scale: 1.35, transformOrigin: '90% 50%' });
      }
      revealed = MAX;
    } else {
      // Forward: auto img fade-up
      if (img) {
        gsap.fromTo(img,
          { opacity: 0, y: 20 },
          { opacity: 1, y: 0, duration: 0.7, ease: 'power3.out' }
        );
      }
    }

    const advance = () => {
      if (revealed >= MAX) return false;
      revealed++;
      const items = getReveal(revealed);
      if (revealed === 6) {
        gsap.fromTo(items,
          { clipPath: 'inset(0 100% 0 0)', opacity: 1 },
          { clipPath: 'inset(0 0 0 0)', duration: 0.8, ease: 'power2.inOut' }
        );
      } else if (revealed === 7) {
        gsap.fromTo(items,
          { opacity: 0 },
          { opacity: 1, duration: 0.5, ease: 'power2.out' }
        );
        if (annotated) {
          gsap.to(annotated, {
            scale: 1.35,
            transformOrigin: '90% 50%',
            duration: 0.8,
            ease: 'power2.inOut'
          });
        }
      } else {
        gsap.fromTo(items,
          { opacity: 0 },
          { opacity: 1, duration: 0.4, ease: 'power2.out' }
        );
      }
      items.forEach(el => el.classList.add('revealed'));
      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;
      const items = getReveal(revealed);
      if (revealed === 7 && annotated) {
        gsap.to(annotated, { scale: 1, duration: 0.4, ease: 'power2.out' });
      }
      if (revealed === 6) {
        gsap.to(items, { clipPath: 'inset(0 100% 0 0)', duration: 0.4, ease: 'power2.in' });
      } else {
        gsap.to(items, { opacity: 0, duration: 0.25, ease: 'power2.in' });
      }
      items.forEach(el => el.classList.remove('revealed'));
      revealed--;
      return true;
    };

    slide.__clickRevealNext = advance;
    slide.__hookRetreat = retreat;
    slide.__hookCurrentBeat = () => revealed;
  },

  's-forest1': (slide, gsap, direction) => {
    const img = slide.querySelector('.forest-annotated img');
    const beats = [1, 2, 3, 4, 5];
    let revealed = 0;
    const getGroup = (n) => slide.querySelectorAll(`[data-reveal="${n}"]`);

    if (direction < 0) {
      // Backward: show final state (img + all 5 zones)
      if (img) gsap.set(img, { opacity: 1, y: 0 });
      beats.forEach(n => {
        const items = getGroup(n);
        gsap.set(items, { opacity: 1 });
        items.forEach(el => el.classList.add('revealed'));
      });
      revealed = beats.length;
    } else {
      // Forward: auto img fade-up
      if (img) {
        gsap.fromTo(img,
          { opacity: 0, y: 20 },
          { opacity: 1, y: 0, duration: 0.7, ease: 'power3.out' }
        );
      }
    }

    const advance = () => {
      if (revealed >= beats.length) return false;
      revealed++;
      const items = getGroup(revealed);
      gsap.fromTo(items,
        { opacity: 0 },
        { opacity: 1, duration: 0.4, ease: 'power2.out' }
      );
      items.forEach(el => el.classList.add('revealed'));
      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;
      const items = getGroup(revealed);
      gsap.to(items, { opacity: 0, duration: 0.25, ease: 'power2.in' });
      items.forEach(el => el.classList.remove('revealed'));
      revealed--;
      return true;
    };

    slide.__clickRevealNext = advance;
    slide.__hookRetreat = retreat;
    slide.__hookCurrentBeat = () => revealed;
  },
};
