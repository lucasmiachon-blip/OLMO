/**
 * slide-registry.js — Meta-análise
 * State machines for interactive slides (hook, checkpoints).
 * Pattern: cirrose slide-registry.js
 */
// SplitText import removed S139 — click-reveal replaces auto-stagger

export const slideRegistry = {
  's-title': (slide, gsap) => {
    // Full choreography: h1 → subtitle → pillars (masking) → dots → identity
    const h1 = slide.querySelector('h1');
    const subtitle = slide.querySelector('.title-subtitle');
    const pillarSpans = slide.querySelectorAll('.pillar > span');
    const dots = slide.querySelectorAll('.pillar-dot');
    const identity = slide.querySelector('.title-identity');

    // h1: gentle fade+rise (0s)
    if (h1) {
      gsap.fromTo(h1,
        { opacity: 0, y: 12 },
        { opacity: 1, y: 0, duration: 0.7, ease: 'power3.out' }
      );
    }
    // subtitle: fade+rise (0.3s)
    if (subtitle) {
      gsap.fromTo(subtitle,
        { opacity: 0, y: 10 },
        { opacity: 1, y: 0, duration: 0.6, ease: 'power3.out', delay: 0.3 }
      );
    }
    // pillars: masking reveal (0.6s) — overflow:hidden + yPercent
    gsap.fromTo(pillarSpans,
      { yPercent: 100 },
      { yPercent: 0, duration: 0.8, stagger: 0.2, ease: 'power3.out', delay: 0.6 }
    );
    // dots: fade in between pillars (0.8s)
    gsap.fromTo(dots,
      { opacity: 0 },
      { opacity: 1, duration: 0.4, stagger: 0.2, delay: 0.8, ease: 'power2.out' }
    );
    // identity: fade+rise last (1.4s)
    if (identity) {
      gsap.fromTo(identity,
        { opacity: 0, y: 8 },
        { opacity: 1, y: 0, duration: 0.6, ease: 'power2.out', delay: 1.4 }
      );
    }
  },

  's-hook': (slide, gsap) => {
    const volume = slide.querySelector('.hook-volume');
    const divider = slide.querySelector('.hook-divider');
    const facts = slide.querySelectorAll('.hook-fact');
    const nums = slide.querySelectorAll('.hook-num');

    const tl = gsap.timeline({ defaults: { ease: 'power3.out' } });

    // 1. Volume enters from left (hero moment)
    tl.fromTo(volume, { opacity: 0, x: -24 }, { opacity: 1, x: 0, duration: 0.9 });

    // 2. Divider scales in like a cut
    tl.to(divider, { scaleY: 1, duration: 0.6, ease: 'expo.inOut' }, '-=0.3');

    // 3. Reality facts enter from right, staggered
    tl.fromTo(facts, { opacity: 0, x: 24 }, { opacity: 1, x: 0, duration: 0.7, stagger: 0.25 }, '-=0.2');

    // 4. CountUp on all numbers (reset to 0 first — HTML has final values for no-js)
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

  's-importancia': (slide, gsap) => {
    const mechanism = slide.querySelector('.imp-mechanism');

    // ΣN hero — scale from 0.92 (growth = combining samples)
    // Auto-plays on slide enter. Professor contextualises the symbol.
    gsap.fromTo(mechanism,
      { opacity: 0, scale: 0.92 },
      { opacity: 1, scale: 1, duration: 0.7, ease: 'power2.out' }
    );

    // Click-reveal: 5 advantages, one per click
    // Professor controls pacing — each click = pedagogical beat
    const groups = [1, 2, 3, 4, 5];
    let revealed = 0;
    const getGroup = (n) => slide.querySelectorAll(`[data-reveal="${n}"]`);

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

  's-contrato': (slide, gsap) => {
    const cards = slide.querySelectorAll('.contrato-card');

    // Reveal a card + its children as a unit
    const revealCard = (card) => {
      const q = card.querySelector('.contrato-question');
      const s = card.querySelector('.contrato-skill');
      const tl = gsap.timeline({ defaults: { ease: 'power3.out' } });
      tl.fromTo(card, { opacity: 0, y: 40 }, { opacity: 1, y: 0, duration: 0.6 })
        .fromTo(q, { opacity: 0, y: 12 }, { opacity: 1, y: 0, duration: 0.4 }, '-=0.2')
        .fromTo(s, { opacity: 0, y: 10 }, { opacity: 1, y: 0, duration: 0.35 }, '-=0.1');
    };

    // Card 1: auto-play on slide enter
    revealCard(cards[0]);

    // Cards 2-3: click-reveal (professor controls pacing per question)
    let revealed = 0;
    const clickCards = [cards[1], cards[2]];

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

  's-pico': (slide, gsap) => {
    const items = slide.querySelectorAll('.pico-item');
    const punchline = slide.querySelector('.pico-punchline');
    if (!items.length || !punchline) return;

    let state = 0;
    const MAX = 1;

    // Beat 0 (auto): stagger P→I→C→O — models expert letter-by-letter check
    gsap.fromTo(items,
      { opacity: 0, y: 16 },
      { opacity: 1, y: 0, duration: 0.6, stagger: 0.3, ease: 'power3.out' }
    );

    function advance() {
      if (state >= MAX) return false;
      state++;
      if (state === 1) {
        // Beat 1: punchline — name the concept after feeling the gap
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

  's-checkpoint-2': (slide, gsap) => {
    const scenario = slide.querySelector('.checkpoint-scenario');
    const question = slide.querySelector('.checkpoint-question');
    const steps = slide.querySelectorAll('.checkpoint-step');
    const verdict = slide.querySelector('.checkpoint-verdict');
    if (!scenario || !question) return;

    let state = 0;
    const MAX = 3;

    gsap.to(scenario, { y: 0, opacity: 1, duration: 0.6, ease: 'power3.out' });
    gsap.to(question, { y: 0, opacity: 1, duration: 0.6, delay: 0.3, ease: 'power3.out' });

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

  's-objetivos': (slide, gsap) => {
    // Click-reveal: 3 groups (1-2 conceitos, 3-4 metodologia, 5 punchline)
    const groups = [1, 2, 3];
    let revealed = 0;

    // Initial state: all reveal items hidden (CSS handles opacity:0 + translateY)
    const getGroup = (n) => slide.querySelectorAll(`[data-reveal="${n}"]`);

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

  's-forest2': (slide, gsap) => {
    // Auto: image fade-up on slide enter
    const img = slide.querySelector('.forest-annotated img');
    const logo = slide.querySelector('.cochrane-logo');
    const annotated = slide.querySelector('.forest-annotated');

    if (img) {
      gsap.fromTo(img,
        { opacity: 0, y: 20 },
        { opacity: 1, y: 0, duration: 0.7, ease: 'power3.out' }
      );
    }

    // Logo: prevent click from advancing beat (professor clicks to open site)
    if (logo) {
      logo.addEventListener('click', (e) => e.stopPropagation());
    }

    // Click-reveal: 8 beats (anatomy + MA count + Cochrane + RoB)
    // 1: CI + diamond | 2: Weight | 3: Events | 4: Studies | 5: Het
    // 6: MA count badge | 7: Cochrane logo (clipPath) | 8: RoB (highlight + zoom)
    const MAX = 8;
    let revealed = 0;
    const getGroup = (n) => slide.querySelectorAll(`[data-reveal="${n}"]`);

    const advance = () => {
      if (revealed >= MAX) return false;
      revealed++;
      const items = getGroup(revealed);
      if (revealed === 7) {
        // Cochrane logo: clipPath curtain L→R
        gsap.fromTo(items,
          { clipPath: 'inset(0 100% 0 0)', opacity: 1 },
          { clipPath: 'inset(0 0 0 0)', duration: 0.8, ease: 'power2.inOut' }
        );
      } else if (revealed === 8) {
        // RoB: zoom only — no yellow overlay (professor reads the column directly)
        if (annotated) {
          gsap.to(annotated, {
            scale: 2,
            xPercent: -35,
            transformOrigin: '88% 25%',
            duration: 1.2,
            ease: 'power3.inOut'
          });
        }
      } else {
        // Beats 1-6: zone highlights + MA stat badge
        gsap.fromTo(items,
          { opacity: 0 },
          { opacity: 1, duration: 0.25, ease: 'power2.out' }
        );
      }
      items.forEach(el => el.classList.add('revealed'));
      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;
      const items = getGroup(revealed);
      if (revealed === 8 && annotated) {
        gsap.to(annotated, { scale: 1, xPercent: 0, duration: 0.4, ease: 'power2.out' });
      }
      if (revealed === 7) {
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

  's-forest1': (slide, gsap) => {
    // Auto: image fade-up on slide enter
    const img = slide.querySelector('.forest-annotated img');
    if (img) {
      gsap.fromTo(img,
        { opacity: 0, y: 20 },
        { opacity: 1, y: 0, duration: 0.7, ease: 'power3.out' }
      );
    }

    // Click-reveal: 5 highlight zones, one per click
    // Colored transparent overlays — professor narrates anatomy
    const beats = [1, 2, 3, 4, 5];
    let revealed = 0;
    const getGroup = (n) => slide.querySelectorAll(`[data-reveal="${n}"]`);

    const advance = () => {
      if (revealed >= beats.length) return false;
      revealed++;
      const items = getGroup(revealed);
      gsap.fromTo(items,
        { opacity: 0 },
        { opacity: 1, duration: 0.35, ease: 'power2.out' }
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

  's-rob2': (slide, gsap) => {
    // Auto: image fade-up on slide enter
    const img = slide.querySelector('.rob2-figure img');
    if (img) {
      gsap.fromTo(img,
        { opacity: 0, y: 16 },
        { opacity: 1, y: 0, duration: 0.7, ease: 'power3.out' }
      );
    }

    // Click-reveal: 3 beats (domains → kappa bars → alternatives)
    const MAX = 3;
    let revealed = 0;

    const advance = () => {
      if (revealed >= MAX) return false;
      revealed++;

      if (revealed === 1) {
        // Domains: stagger D1→D5 + rule
        const domains = slide.querySelectorAll('.rob2-domain');
        const rule = slide.querySelector('.rob2-rule');
        gsap.fromTo(domains,
          { opacity: 0, y: 12 },
          { opacity: 1, y: 0, duration: 0.4, stagger: 0.15, ease: 'power2.out' }
        );
        if (rule) {
          gsap.fromTo(rule,
            { opacity: 0 },
            { opacity: 1, duration: 0.3, delay: 0.5, ease: 'power2.out' }
          );
        }
      }

      if (revealed === 2) {
        // Kappa bars: stagger top→bottom, D2 arrives last with dramatic pause
        const bars = slide.querySelectorAll('.rob2-bar');
        const fills = slide.querySelectorAll('.rob2-bar-fill');
        const vals = slide.querySelectorAll('.rob2-bar-val');
        const note = slide.querySelector('.rob2-kappa-note');
        // D2 (index 3) gets extra 0.3s pause — worst domain = punchline
        const d2Pause = (i) => i === 3 ? 0.75 : i * 0.15;
        gsap.fromTo(bars,
          { opacity: 0, x: -12 },
          { opacity: 1, x: 0, duration: 0.4, stagger: d2Pause, ease: 'power2.out' }
        );
        // Bar fills grow left→right via scaleX (GPU, no reflow)
        gsap.fromTo(fills,
          { scaleX: 0 },
          { scaleX: 1, duration: 0.6, stagger: d2Pause, delay: 0.1, ease: 'power3.out' }
        );
        // Values fade in after each fill completes (staging: see bar size, then read number)
        gsap.fromTo(vals,
          { opacity: 0 },
          { opacity: 1, duration: 0.3, stagger: d2Pause, delay: 0.8, ease: 'power2.out' }
        );
        if (note) {
          gsap.fromTo(note,
            { opacity: 0 },
            { opacity: 1, duration: 0.3, delay: 1.4, ease: 'power2.out' }
          );
        }
      }

      if (revealed === 3) {
        // Alternatives: fade up
        const alts = slide.querySelectorAll('.rob2-alt');
        const trend = slide.querySelector('.rob2-alt-trend');
        gsap.fromTo(alts,
          { opacity: 0, y: 12 },
          { opacity: 1, y: 0, duration: 0.4, stagger: 0.12, ease: 'power2.out' }
        );
        if (trend) {
          gsap.fromTo(trend,
            { opacity: 0 },
            { opacity: 1, duration: 0.3, delay: 0.35, ease: 'power2.out' }
          );
        }
      }

      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;

      if (revealed === 1) {
        const els = slide.querySelectorAll('[data-reveal="1"]');
        gsap.to(els, { opacity: 0, y: 12, duration: 0.3, ease: 'power2.in' });
      }
      if (revealed === 2) {
        const bars = slide.querySelectorAll('.rob2-bar');
        const fills = slide.querySelectorAll('.rob2-bar-fill');
        const vals = slide.querySelectorAll('.rob2-bar-val');
        const note = slide.querySelector('.rob2-kappa-note');
        gsap.to(vals, { opacity: 0, duration: 0.2, ease: 'power2.in' });
        gsap.to(fills, { scaleX: 0, duration: 0.25, delay: 0.1, ease: 'power2.in' });
        gsap.to([...bars, note].filter(Boolean),
          { opacity: 0, x: -12, duration: 0.3, delay: 0.15, ease: 'power2.in' }
        );
      }
      if (revealed === 3) {
        const els = slide.querySelectorAll('[data-reveal="3"]');
        gsap.to(els, { opacity: 0, y: 12, duration: 0.3, ease: 'power2.in' });
      }

      revealed--;
      return true;
    };

    slide.__clickRevealNext = advance;
    slide.__hookRetreat = retreat;
    slide.__hookCurrentBeat = () => revealed;
  },

  's-pubbias2': (slide, gsap) => {
    // Click-reveal: 3 funnel plot zones (topo → meio → base)
    const groups = [1, 2, 3];
    let revealed = 0;
    const getGroup = (n) => slide.querySelectorAll(`[data-reveal="${n}"]`);

    const advance = () => {
      if (revealed >= groups.length) return false;
      revealed++;
      const items = getGroup(revealed);
      gsap.fromTo(items,
        { opacity: 0 },
        { opacity: 1, duration: 0.5, ease: 'power2.out' }
      );
      items.forEach(el => el.classList.add('revealed'));
      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;
      const items = getGroup(revealed);
      gsap.to(items, { opacity: 0, duration: 0.35, ease: 'power2.in' });
      items.forEach(el => el.classList.remove('revealed'));
      revealed--;
      return true;
    };

    slide.__clickRevealNext = advance;
    slide.__hookRetreat = retreat;
    slide.__hookCurrentBeat = () => revealed;
  },
};
