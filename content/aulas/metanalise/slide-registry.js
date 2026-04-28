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
    // Staging: staggered fadeUp guides attention sequentially.
    // Numbers are static — the label IS the message, not the count.
    gsap.fromTo(
      slide.querySelectorAll('.hook-fact'),
      { opacity: 0, y: 12 },
      { opacity: 1, y: 0, duration: 0.5, stagger: 0.4, ease: 'power2.out' }
    );
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

  's-quality': (slide, gsap) => {
    // S262 v2: 5 beats agrupado (cards juntos em Beat 0, perguntas Beat 1, ferramentas por card 2/3/4).
    // Beat 0 (auto): h2 + 3 cards aparecem juntos (apenas headers term-name; rows ainda invisíveis).
    // Beat 1 (click): 3 perguntas (cross-cards) + chips PROSPERO/A priori/PRISMA/Transparência (card 1).
    // Beat 2 (click): card 1 Ferramenta — chips AMSTAR-2 / ROBIS.
    // Beat 3 (click): card 2 Ferramenta — chips RoB 1 / RoB 2 / ROBUST-RCT / ROBINS.
    // Beat 4 (click): card 3 Ferramenta — chip GRADE.
    // Beat 5 (click): dissociation panel (synthesis empírica 52% Alvarenga).
    const cards = Array.from(slide.querySelectorAll('.term-card'));
    const perguntaRows = Array.from(slide.querySelectorAll('.term-row--pergunta'));
    const ferramentaRows = cards.map(c => c.querySelector('.term-row--ferramenta'));
    const dissociation = slide.querySelector('.term-dissociation');
    const MAX = 5;
    let revealed = 0;

    // Beat 0 (auto): cards aparecem em cascata suave (power2.out + stagger 0.1 — Lucas S262).
    gsap.fromTo(cards,
      { opacity: 0, y: 12 },
      { opacity: 1, y: 0, duration: 0.6, stagger: 0.1, ease: 'power2.out' }
    );

    // revealRow — easing power2.out (suave, não-bouncy). Stagger nativo 0.1 nos chips.
    const revealRow = (row, chipDelay = 0.2) => {
      if (!row) return;
      gsap.fromTo(row,
        { opacity: 0, y: 6 },
        { opacity: 1, y: 0, duration: 0.5, ease: 'power2.out' }
      );
      const chips = row.querySelectorAll('.term-chip');
      if (chips.length) {
        gsap.fromTo(chips,
          { opacity: 0, y: 4, scale: 0.94 },
          { opacity: 1, y: 0, scale: 1, duration: 0.4, stagger: 0.1, delay: chipDelay, ease: 'power2.out' }
        );
      }
    };

    const hideRow = (row) => {
      if (!row) return;
      const chips = row.querySelectorAll('.term-chip');
      gsap.to(chips, { opacity: 0, y: 4, scale: 0.94, duration: 0.24, ease: 'power2.in' });
      gsap.to(row, { opacity: 0, y: 6, duration: 0.28, delay: 0.05, ease: 'power2.in' });
    };

    const advance = () => {
      if (revealed >= MAX) return false;
      revealed++;
      if (revealed === 1) {
        // 3 perguntas cross-cards stagger nativo 0.1 + chips card 1 cascata
        gsap.fromTo(perguntaRows,
          { opacity: 0, y: 6 },
          { opacity: 1, y: 0, duration: 0.5, stagger: 0.1, ease: 'power2.out' }
        );
        const chipsCard1 = perguntaRows[0]?.querySelectorAll('.term-chip') ?? [];
        if (chipsCard1.length) {
          gsap.fromTo(chipsCard1,
            { opacity: 0, y: 4, scale: 0.94 },
            { opacity: 1, y: 0, scale: 1, duration: 0.4, stagger: 0.1, delay: 0.45, ease: 'power2.out' }
          );
        }
      } else if (revealed === 2) {
        revealRow(ferramentaRows[0]);
      } else if (revealed === 3) {
        revealRow(ferramentaRows[1]);
      } else if (revealed === 4) {
        revealRow(ferramentaRows[2]);
      } else if (revealed === 5 && dissociation) {
        gsap.fromTo(dissociation,
          { opacity: 0, y: 12 },
          { opacity: 1, y: 0, duration: 0.6, delay: 0.1, ease: 'power2.out' }
        );
      }
      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;
      if (revealed === 5 && dissociation) {
        gsap.to(dissociation, { opacity: 0, y: 12, duration: 0.25, ease: 'power2.in' });
      } else if (revealed === 4) {
        hideRow(ferramentaRows[2]);
      } else if (revealed === 3) {
        hideRow(ferramentaRows[1]);
      } else if (revealed === 2) {
        hideRow(ferramentaRows[0]);
      } else if (revealed === 1) {
        perguntaRows.forEach(hideRow);
      }
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

    // Click-reveal: 3 beats (overlays removed S273)
    // 1: MA count badge | 2: Cochrane logo (clipPath) | 3: RoB zoom on .forest-annotated
    const MAX = 3;
    let revealed = 0;
    const getGroup = (n) => slide.querySelectorAll(`[data-reveal="${n}"]`);

    const advance = () => {
      if (revealed >= MAX) return false;
      revealed++;
      const items = getGroup(revealed);
      if (revealed === 2) {
        // Cochrane logo: clipPath curtain L→R
        gsap.fromTo(items,
          { clipPath: 'inset(0 100% 0 0)', opacity: 1 },
          { clipPath: 'inset(0 0 0 0)', duration: 0.8, ease: 'power2.inOut' }
        );
      } else if (revealed === 3) {
        // RoB: zoom on the annotated wrapper (no overlay)
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
        // Beat 1: MA count badge fade-in
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
      const items = getGroup(revealed);
      if (revealed === 3) {
        if (annotated) {
          gsap.to(annotated, { scale: 1, xPercent: 0, duration: 0.4, ease: 'power2.out' });
        }
      } else if (revealed === 2) {
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
    // Auto-only: image fade-up — no click-reveal (overlays removed S273)
    const img = slide.querySelector('.forest-annotated img');
    if (img) {
      gsap.fromTo(img,
        { opacity: 0, y: 20 },
        { opacity: 1, y: 0, duration: 0.7, ease: 'power3.out' }
      );
    }
  },

  's-rob2': (slide, gsap) => {
    // Auto: image fade-up on slide enter (target = container, where opacity:0 lives)
    const figure = slide.querySelector('.rob2-figure');
    if (figure) {
      gsap.fromTo(figure,
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
        // Kappa header: context label appears first (name → then data)
        const header = slide.querySelector('.rob2-kappa-header');
        if (header) {
          gsap.fromTo(header,
            { opacity: 0, y: 8 },
            { opacity: 1, y: 0, duration: 0.4, ease: 'power2.out' }
          );
        }
        // Kappa bars: stagger top→bottom, D2 arrives last with dramatic pause
        const bars = slide.querySelectorAll('.rob2-bar');
        const fills = slide.querySelectorAll('.rob2-bar-fill');
        const vals = slide.querySelectorAll('.kappa-stats');
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
        const vals = slide.querySelectorAll('.kappa-stats');
        const note = slide.querySelector('.rob2-kappa-note');
        const header = slide.querySelector('.rob2-kappa-header');
        gsap.to(vals, { opacity: 0, duration: 0.2, ease: 'power2.in' });
        gsap.to(fills, { scaleX: 0, duration: 0.25, delay: 0.1, ease: 'power2.in' });
        gsap.to([...bars, note].filter(Boolean),
          { opacity: 0, x: -12, duration: 0.3, delay: 0.15, ease: 'power2.in' }
        );
        if (header) {
          gsap.to(header, { opacity: 0, duration: 0.3, delay: 0.15, ease: 'power2.in' });
        }
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

  's-pubbias1': (slide, gsap) => {
    // Click-reveal: 3 beats (bars → punchline → taxonomy chips)
    const MAX = 3;
    let revealed = 0;

    const advance = () => {
      if (revealed >= MAX) return false;
      revealed++;

      if (revealed === 1) {
        // Bars: fade container, then stagger fills — FDA first, pause, Literature grows past
        const comp = slide.querySelector('.pubbias-comparison');
        const fdaFill = slide.querySelector('.pubbias-bar--fda');
        const litFill = slide.querySelector('.pubbias-bar--lit');
        gsap.fromTo(comp,
          { opacity: 0, y: 16 },
          { opacity: 1, y: 0, duration: 0.5, ease: 'power2.out' }
        );
        gsap.fromTo(fdaFill,
          { scaleX: 0 },
          { scaleX: 1, duration: 0.8, delay: 0.3, ease: 'power2.out' }
        );
        gsap.fromTo(litFill,
          { scaleX: 0 },
          { scaleX: 1, duration: 1.0, delay: 1.5, ease: 'power2.out' }
        );
      }

      if (revealed === 2) {
        // Punchline: fade + rise
        const punch = slide.querySelector('.pubbias-punchline');
        gsap.fromTo(punch,
          { opacity: 0, y: 12 },
          { opacity: 1, y: 0, duration: 0.5, ease: 'power2.out' }
        );
      }

      if (revealed === 3) {
        // Taxonomy chips: staggered fade
        const chips = slide.querySelectorAll('.pubbias-chip');
        gsap.fromTo(chips,
          { opacity: 0, y: 8 },
          { opacity: 1, y: 0, duration: 0.35, stagger: 0.1, ease: 'power2.out' }
        );
      }

      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;
      if (revealed === 1) {
        const comp = slide.querySelector('.pubbias-comparison');
        const fdaFill = slide.querySelector('.pubbias-bar--fda');
        const litFill = slide.querySelector('.pubbias-bar--lit');
        gsap.to(litFill, { scaleX: 0, duration: 0.3, ease: 'power2.in' });
        gsap.to(fdaFill, { scaleX: 0, duration: 0.3, delay: 0.1, ease: 'power2.in' });
        gsap.to(comp, { opacity: 0, duration: 0.35, delay: 0.2, ease: 'power2.in' });
      }
      if (revealed === 2) {
        const punch = slide.querySelector('.pubbias-punchline');
        gsap.to(punch, { opacity: 0, duration: 0.35, ease: 'power2.in' });
      }
      if (revealed === 3) {
        const chips = slide.querySelectorAll('.pubbias-chip');
        gsap.to(chips, { opacity: 0, duration: 0.35, ease: 'power2.in' });
      }
      revealed--;
      return true;
    };

    slide.__clickRevealNext = advance;
    slide.__hookRetreat = retreat;
    slide.__hookCurrentBeat = () => revealed;
  },

  's-heterogeneity': (slide, gsap) => {
    const MAX = 3;
    let revealed = 0;
    const panels = slide.querySelectorAll('.het-panel');
    const insight = slide.querySelector('.het-insight');

    const advance = () => {
      if (revealed >= MAX) return false;
      revealed++;
      if (revealed <= 2) {
        const dir = revealed === 1 ? -20 : 20;
        gsap.fromTo(panels[revealed - 1],
          { opacity: 0, x: dir },
          { opacity: 1, x: 0, duration: 0.6, ease: 'power3.out' }
        );
      } else {
        gsap.fromTo(insight,
          { opacity: 0, y: 12 },
          { opacity: 1, y: 0, duration: 0.5, ease: 'power2.out' }
        );
      }
      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;
      if (revealed <= 2) {
        const dir = revealed === 1 ? -20 : 20;
        gsap.to(panels[revealed - 1],
          { opacity: 0, x: dir, duration: 0.3, ease: 'power2.in' }
        );
      } else {
        gsap.to(insight,
          { opacity: 0, y: 12, duration: 0.3, ease: 'power2.in' }
        );
      }
      revealed--;
      return true;
    };

    slide.__clickRevealNext = advance;
    slide.__hookRetreat = retreat;
    slide.__hookCurrentBeat = () => revealed;
  },

  's-fixed-random': (slide, gsap) => {
    // Click-reveal only: FE panel → RE panel → insight
    const MAX = 3;
    let revealed = 0;

    const advance = () => {
      if (revealed >= MAX) return false;
      revealed++;
      if (revealed === 1) {
        const panel = slide.querySelector('.fr-panel[data-reveal="1"]');
        gsap.fromTo(panel, { opacity: 0, x: -16 }, { opacity: 1, x: 0, duration: 0.5, ease: 'power2.out' });
      }
      if (revealed === 2) {
        const panel = slide.querySelector('.fr-panel[data-reveal="2"]');
        gsap.fromTo(panel, { opacity: 0, x: 16 }, { opacity: 1, x: 0, duration: 0.5, ease: 'power2.out' });
      }
      if (revealed === 3) {
        const insight = slide.querySelector('.fr-insight');
        gsap.fromTo(insight, { opacity: 0, y: 8 }, { opacity: 1, y: 0, duration: 0.4, ease: 'power2.out' });
      }
      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;
      if (revealed === 1) {
        const panel = slide.querySelector('.fr-panel[data-reveal="1"]');
        gsap.to(panel, { opacity: 0, duration: 0.3, ease: 'power2.in' });
      }
      if (revealed === 2) {
        const panel = slide.querySelector('.fr-panel[data-reveal="2"]');
        gsap.to(panel, { opacity: 0, duration: 0.3, ease: 'power2.in' });
      }
      if (revealed === 3) {
        const insight = slide.querySelector('.fr-insight');
        gsap.to(insight, { opacity: 0, duration: 0.3, ease: 'power2.in' });
      }
      revealed--;
      return true;
    };

    slide.__clickRevealNext = advance;
    slide.__hookRetreat = retreat;
    slide.__hookCurrentBeat = () => revealed;
  },

  's-pubbias2': (slide, gsap) => {
    // Auto: funnel image fade-up (FOUC fix — multiply blend)
    const container = slide.querySelector('.funnel-container');
    if (container) {
      gsap.fromTo(container,
        { opacity: 0, y: 12 },
        { opacity: 1, y: 0, duration: 0.7, ease: 'power3.out' }
      );
    }

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

  's-etd': (slide, gsap) => {
    /* Dark-bg edge bleed fix — body.stage-c has light background that shows
       through scaling gaps in fullscreen. Toggle body to near-black when active. */
    const setEdgeBg = () => {
      document.body.style.background =
        slide.classList.contains('slide-active') ? '#0a0e16' : '';
    };
    new MutationObserver(setEdgeBg)
      .observe(slide, { attributes: true, attributeFilter: ['class'] });
    setEdgeBg();

    const table  = slide.querySelector('.etd-table');
    const rows   = slide.querySelectorAll('.etd-row');
    const badges = slide.querySelectorAll('.etd-badge');
    const caveat = slide.querySelector('.etd-caveat');
    const MAX = 3;
    let revealed = 0;

    const advance = () => {
      if (revealed >= MAX) return false;
      revealed++;

      if (revealed === 1) {
        gsap.to(table, { opacity: 1, duration: 0.3 });
        gsap.fromTo(rows,
          { opacity: 0, x: -20 },
          { opacity: 1, x: 0, duration: 0.7, stagger: 0.2, ease: 'power3.out', delay: 0.25 }
        );
      } else if (revealed === 2) {
        gsap.fromTo(badges,
          { opacity: 0, scale: 0.85 },
          { opacity: 1, scale: 1, duration: 0.55, stagger: 0.15, ease: 'power2.out' }
        );
      } else if (revealed === 3) {
        gsap.fromTo(caveat,
          { opacity: 0, y: 16 },
          { opacity: 1, y: 0, duration: 0.8, ease: 'power3.out' }
        );
      }
      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;
      if (revealed === 3) {
        gsap.to(caveat, { opacity: 0, y: 16, duration: 0.3, ease: 'power2.in' });
      } else if (revealed === 2) {
        gsap.to(badges, { opacity: 0, scale: 0.85, duration: 0.25, ease: 'power2.in' });
      } else if (revealed === 1) {
        gsap.to(rows, { opacity: 0, x: -20, duration: 0.3, ease: 'power2.in' });
        gsap.to(table, { opacity: 0, duration: 0.15, delay: 0.25 });
      }
      revealed--;
      return true;
    };

    slide.__clickRevealNext = advance;
    slide.__hookRetreat    = retreat;
    slide.__hookCurrentBeat = () => revealed;
  },

  's-takehome': (slide, gsap) => {
    const cards = slide.querySelectorAll('.takehome-card');
    if (!cards.length) return;

    let revealed = 0;

    const advance = () => {
      if (revealed >= cards.length) return false;
      gsap.fromTo(cards[revealed],
        { opacity: 0, y: 16, scale: 0.96 },
        { opacity: 1, y: 0, scale: 1, duration: 0.5, ease: 'power2.out' }
      );
      revealed++;
      return true;
    };

    const retreat = () => {
      if (revealed <= 0) return false;
      revealed--;
      gsap.to(cards[revealed], { opacity: 0, y: 16, scale: 0.96, duration: 0.3, ease: 'power2.in' });
      return true;
    };

    slide.__clickRevealNext = advance;
    slide.__hookRetreat    = retreat;
    slide.__hookCurrentBeat = () => revealed;
  },
};

// Bookend: s-contrato-final reuses s-contrato animation (S207)
slideRegistry['s-contrato-final'] = slideRegistry['s-contrato'];
