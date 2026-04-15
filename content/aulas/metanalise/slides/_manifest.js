/**
 * _manifest.js — Meta-análise
 * Source of truth para ordem dos slides, fases narrativas e interações.
 *
 * DERIVADO DE: evidence/blueprint.html + evidence/meta-narrativa.html
 * Validação: npm run lint:narrative-sync metanalise
 *
 * Coautoria: Lucas (decisão clínica) · Opus 4.6 (código + governance)
 * Atualizado: 2026-04-15 — 17 slides (S207: s-takehome suppressed, s-contrato-final added as bookend)
 */

export const slides = [
  // ── Fase 1: Criar importância ──
  { id: 's-title',        file: '00-title.html',        phase: 'F1', headline: 'Meta-análise — Leitura crítica para decisão clínica',                                                                timing: null, clickReveals: 0, customAnim: 's-title',        narrativeRole: null,         tensionLevel: 0, narrativeCritical: false },
  { id: 's-objetivos',   file: '00b-objetivos.html',   phase: 'F1', headline: 'Objetivos educacionais',                                                                                              timing: 30,   clickReveals: 3, customAnim: null,             narrativeRole: 'setup',      tensionLevel: 0, narrativeCritical: false }, // R11 editorial
  { id: 's-hook',         file: '01-hook.html',         phase: 'F1', headline: 'Por que isso importa',                                    timing: 60,   clickReveals: 0, customAnim: 's-hook',             narrativeRole: 'hook',       tensionLevel: 2, narrativeCritical: true,  evidence: 's-hook.html' },
  { id: 's-importancia',  file: '02-importancia.html',  phase: 'F1', headline: 'Porque é importante: metodologia',                                                                                    timing: 60,   clickReveals: 5, customAnim: 's-importancia',      narrativeRole: 'setup',      tensionLevel: 1, narrativeCritical: false, evidence: 's-importancia.html' },

  // ── Fase 2: Metodologia ──
  { id: 's-rs-vs-ma',     file: '04-rs-vs-ma.html',     phase: 'F2', headline: 'Nem toda revisão é sistemática — e RS ≠ MA',                                                                          timing: 90,   clickReveals: 0, customAnim: null,             narrativeRole: 'setup',      tensionLevel: 1, narrativeCritical: false },
  { id: 's-quality',      file: '05-quality.html',      phase: 'F2', headline: 'A qualidade metodológica de uma MA não garante a certeza da evidência',                                                                                                    timing: 90,   clickReveals: 3, customAnim: 's-quality',      narrativeRole: 'setup',      tensionLevel: 2, narrativeCritical: false, evidence: 's-quality-grade-rob.html' },
  { id: 's-contrato',     file: '02-contrato.html',     phase: 'F2', headline: '3 etapas para avaliar qualquer meta-análise de RCTs de intervenção',                                            timing: 45,   clickReveals: 2, customAnim: 's-contrato',             narrativeRole: 'setup',      tensionLevel: 1, narrativeCritical: false, evidence: 's-contrato.html' },
  { id: 's-pico',         file: '04-pico.html',         phase: 'F2', headline: 'O valor da RS e da MA depende em grande parte da concordância entre o study PICO e o seu target PICO', timing: 60, clickReveals: 1, customAnim: 's-pico', narrativeRole: 'setup', tensionLevel: 2, narrativeCritical: false },

  { id: 's-forest1',      file: '08a-forest1.html',     phase: 'F2', headline: 'Forest Plot 1 — Li et al. 2026',                                                                                        timing: 90,   clickReveals: 5, customAnim: 's-forest1',     narrativeRole: 'setup',      tensionLevel: 2, narrativeCritical: false, evidence: 's-forest-plot-final.html' },
  { id: 's-forest2',      file: '08b-forest2.html',     phase: 'F2', headline: 'Forest Plot 2 — Ebrahimi et al. 2025',                                                                                  timing: 90,   clickReveals: 8, customAnim: 's-forest2',     narrativeRole: 'payoff',     tensionLevel: 2, narrativeCritical: false, evidence: 's-forest-plot-final.html' },
  { id: 's-rob2',          file: '08c-rob2.html',        phase: 'F2', headline: 'Avaliação de vieses de estudo — RoB 2 e além',                                                                          timing: 90,   clickReveals: 3, customAnim: 's-rob2',        narrativeRole: 'setup',      tensionLevel: 2, narrativeCritical: false, evidence: 's-rob2.html' },
  { id: 's-pubbias1',      file: '11a-pubbias1.html',    phase: 'F2', headline: 'Até um terço dos ensaios clínicos nunca é publicado — e os que faltam não são aleatórios',                                    timing: 90,   clickReveals: 3, customAnim: 's-pubbias1',    narrativeRole: 'setup',      tensionLevel: 3, narrativeCritical: false, evidence: 's-pubbias.html' },
  { id: 's-pubbias2',      file: '11b-pubbias2.html',    phase: 'F2', headline: 'Interpretando o Funnel Plot',                                                                                          timing: 90,   clickReveals: 3, customAnim: 's-pubbias2',     narrativeRole: 'setup',      tensionLevel: 2, narrativeCritical: false, evidence: 's-pubbias.html' },

  { id: 's-heterogeneity', file: '09a-heterogeneity.html', phase: 'F2', headline: 'Dois forest plots com I² de 67% podem esconder realidades clínicas opostas',                                    timing: 90,   clickReveals: 3, customAnim: 's-heterogeneity', narrativeRole: 'setup',      tensionLevel: 3, narrativeCritical: true,  evidence: 's-heterogeneity.html' },

  { id: 's-fixed-random',  file: '10-fixed-random.html',    phase: 'F2', headline: 'Mesmos dados, conclusões diferentes',          timing: 90,   clickReveals: 3, customAnim: 's-fixed-random',  narrativeRole: 'payoff',     tensionLevel: 2, narrativeCritical: false, evidence: 's-heterogeneity.html' },


  // ── Fase 3: Aplicação (Valgimigli 2025) ──

  { id: 's-etd',          file: '14-etd.html',          phase: 'F3', headline: 'Aplicando EtD',                                                                                                         timing: 120,  clickReveals: 3, customAnim: 's-etd',          narrativeRole: 'payoff',     tensionLevel: 3, narrativeCritical: true,  evidence: 's-ancora.html' },

  { id: 's-contrato-final', file: '18-contrato-final.html', phase: 'F3', headline: '3 etapas para avaliar qualquer meta-análise de RCTs de intervenção', timing: 45, clickReveals: 2, customAnim: 's-contrato', narrativeRole: 'resolve', tensionLevel: 1, narrativeCritical: true },
];
