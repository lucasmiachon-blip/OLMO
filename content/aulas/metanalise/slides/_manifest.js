/**
 * _manifest.js — Meta-análise
 * Source of truth para ordem dos slides, fases narrativas e interações.
 *
 * DERIVADO DE: evidence/blueprint.html + evidence/meta-narrativa.html
 * Validação: npm run lint:narrative-sync metanalise
 *
 * Coautoria: Lucas (decisão clínica) · Opus 4.6 (código + governance)
 * Atualizado: 2026-04-12 — 17 slides (S161: +s-forest1, +s-forest2; archetype field removido)
 */

export const slides = [
  // ── Fase 1: Criar importância ──
  { id: 's-title',        file: '00-title.html',        phase: 'F1', headline: 'Meta-análise — Leitura crítica para decisão clínica',                                                                timing: null, clickReveals: 0, customAnim: 's-title',        narrativeRole: null,         tensionLevel: 0, narrativeCritical: false },
  { id: 's-objetivos',   file: '00b-objetivos.html',   phase: 'F1', headline: 'Objetivos educacionais',                                                                                              timing: 30,   clickReveals: 3, customAnim: null,             narrativeRole: 'setup',      tensionLevel: 0, narrativeCritical: false }, // R11 editorial
  { id: 's-hook',         file: '01-hook.html',         phase: 'F1', headline: 'Por que isso importa',                                    timing: 60,   clickReveals: 0, customAnim: 's-hook',             narrativeRole: 'hook',       tensionLevel: 2, narrativeCritical: true,  evidence: 's-hook.html' },
  { id: 's-importancia',  file: '02-importancia.html',  phase: 'F1', headline: 'Porque é importante: metodologia',                                                                                    timing: 60,   clickReveals: 5, customAnim: 's-importancia',      narrativeRole: 'setup',      tensionLevel: 1, narrativeCritical: false, evidence: 's-importancia.html' },

  // ── Fase 2: Metodologia ──
  { id: 's-rs-vs-ma',     file: '04-rs-vs-ma.html',     phase: 'F2', headline: 'Nem toda revisão é sistemática — e RS ≠ MA',                                                                          timing: 90,   clickReveals: 0, customAnim: null,             narrativeRole: 'setup',      tensionLevel: 1, narrativeCritical: false },
  { id: 's-contrato',     file: '02-contrato.html',     phase: 'F2', headline: '3 perguntas que você faz a toda meta-análise',                                            timing: 45,   clickReveals: 2, customAnim: 's-contrato',             narrativeRole: 'setup',      tensionLevel: 1, narrativeCritical: false, evidence: 's-contrato.html' },
  { id: 's-pico',         file: '04-pico.html',         phase: 'F2', headline: 'O valor da RS e da MA depende em grande parte da concordância entre o study PICO e o seu target PICO', timing: 60, clickReveals: 1, customAnim: 's-pico', narrativeRole: 'setup', tensionLevel: 2, narrativeCritical: false },

  { id: 's-forest1',      file: '08a-forest1.html',     phase: 'F2', headline: 'Forest Plot 1 — Li et al. 2026',                                                                                        timing: 90,   clickReveals: 5, customAnim: 's-forest1',     narrativeRole: 'setup',      tensionLevel: 2, narrativeCritical: false, evidence: 's-forest-plot-final.html' },
  { id: 's-forest2',      file: '08b-forest2.html',     phase: 'F2', headline: 'Forest Plot 2 — Ebrahimi et al. 2025',                                                                                  timing: 90,   clickReveals: 7, customAnim: 's-forest2',     narrativeRole: 'payoff',     tensionLevel: 2, narrativeCritical: false, evidence: 's-forest-plot-final.html' },

  { id: 's-heterogeneity',file: '09-heterogeneity.html',phase: 'F2', headline: 'I² alto não invalida a MA — importa se a heterogeneidade é explicável e clinicamente relevante',                      timing: 60,   clickReveals: 0, customAnim: null,             narrativeRole: 'payoff',     tensionLevel: 2, narrativeCritical: false },
  { id: 's-fixed-random', file: '10-fixed-random.html', phase: 'F2', headline: 'Random-effects alarga o IC quando há heterogeneidade — resultado significativo em fixed-effect pode desaparecer',      timing: 60,   clickReveals: 0, customAnim: null,             narrativeRole: 'payoff',     tensionLevel: 1, narrativeCritical: false },

  // ── Interação 2: Checkpoint de consolidação ──
  { id: 's-checkpoint-2', file: '12-checkpoint-2.html', phase: 'I2', headline: 'RR 0,75 (IC 0,60–0,93), I²=72%, GRADE baixa — o diamante favorece. Você muda?',                                     timing: 120,  clickReveals: 3, customAnim: 's-checkpoint-2', narrativeRole: 'checkpoint', tensionLevel: 4, narrativeCritical: true },

  // ── Fase 3: Aplicação (Valgimigli 2025) ──
  { id: 's-ancora',       file: '13-ancora.html',       phase: 'F3', headline: 'Clopidogrel reduziu eventos CV vs aspirina — 7 RCTs e 28.982 pacientes com dados individuais',                       timing: 90,   clickReveals: 0, customAnim: null,             narrativeRole: 'setup',      tensionLevel: 2, narrativeCritical: false, evidence: 's-ancora.html' },

  { id: 's-aplicabilidade',file:'15-aplicabilidade.html',phase:'F3', headline: 'Prevenção secundária de DAC, seguimento 2,3a — antes de adotar, verifique se seu paciente se encaixa',                timing: 90,   clickReveals: 0, customAnim: null,             narrativeRole: 'payoff',     tensionLevel: 2, narrativeCritical: false },
  { id: 's-absoluto',     file: '16-absoluto.html',     phase: 'F3', headline: 'Mesmo RR pode significar NNT 25 ou NNT 250 — sem risco basal, efeito relativo não informa decisão',                  timing: 90,   clickReveals: 0, customAnim: null,             narrativeRole: 'payoff',     tensionLevel: 3, narrativeCritical: false },
  { id: 's-takehome',     file: '17-takehome.html',     phase: 'F3', headline: 'Três perguntas que você faz a toda MA antes de mudar sua conduta',                                                   timing: 60,   clickReveals: 0, customAnim: null,             narrativeRole: 'resolve',    tensionLevel: 1, narrativeCritical: true },
];
