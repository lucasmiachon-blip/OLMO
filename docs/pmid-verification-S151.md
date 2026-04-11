# PMID Verification S151 — HTML + REFERENCES

> Sessão 151 | 2026-04-10
> Source: NCBI eutils (esummary/esearch) via WebFetch, SCite MCP como fallback
> Autoria: Lucas + Opus 4.6

## Contexto

Fase A do plano S151 (`.claude/plans/magical-growing-harbor.md`). Verifica 14 PMIDs pendentes (10 conhecidos + 4 autores sem PMID) antes de qualquer edit de HTML (Fase B). PubMed MCP tool schema não foi indexado no harness desta sessão — usamos NCBI eutils direto como equivalente funcional (é a mesma API que o MCP consome por baixo). SCite MCP usado pontualmente para Kastrati/Ioannidis por ambiguidade na query eutils inicial.

## Tabela de verdade

| # | PMID | Arquivo:linha | Esperado | PubMed/eutils retornou | Match | Categoria | Ação B |
|---|------|---------------|----------|-------------------------|-------|-----------|--------|
| 1 | 21366473 | s-checkpoint-1:183 | ACCORD Study Group 2011 NEJM | Gerstein HC. Long-term effects of intensive glucose lowering on cardiovascular outcomes. NEJM 2011;364(9):818-28. DOI 10.1056/NEJMoa1006524 | ✓ | VERIFIED | add `.v` badge; Gerstein é PI do ACCORD, citação "ACCORD Study Group" aceitável |
| 2 | 26822326 | s-checkpoint-1:184 | ACCORD Study Group 2016 Diabetes Care | ACCORD Study Group. Nine-Year Effects of 3.7 Years of Intensive Glycemic Control on Cardiovascular Outcomes. Diabetes Care 2016;39(5):701-8. DOI 10.2337/dc15-2283 | ✓ | VERIFIED | add `.v` badge |
| 3 | 31167051 | s-checkpoint-1:185 | Reaven PD 2019 VADT 15yr NEJM | Reaven PD. Intensive Glucose Control in Patients with Type 2 Diabetes — 15-Year Follow-up. NEJM 2019;380(23):2215-2224. DOI 10.1056/NEJMoa1806802 | ✓ | VERIFIED | add `.v` badge |
| 4 | 37146659 | s-pico:171 | Goldkuhle 2023 | Goldkuhle M. GRADE concept 4: rating the certainty of evidence when study interventions or comparators differ from PICO targets. J Clin Epidemiol 2023;159:40-48. DOI 10.1016/j.jclinepi.2023.04.018 | ✓ | VERIFIED | mover prose→`#referencias` |
| 5 | 21802903 | s-pico:176 | Guyatt 2011 GRADE indirectness | Guyatt GH. GRADE guidelines: 8. Rating the quality of evidence—indirectness. J Clin Epidemiol 2011;64(12):1303-10. DOI 10.1016/j.jclinepi.2011.04.014 | ✓ | VERIFIED | mover prose→`#referencias` |
| 6 | 40393729 | s-pico:181-186 | Guyatt (recente) | Guyatt G. Core GRADE 5: rating certainty of evidence-assessing indirectness. BMJ 2025;389:e083865. DOI 10.1136/bmj-2024-083865 | ✓ | VERIFIED | mover prose→`#referencias` |
| 7 | 41207400 | s-pico:181-186 | Colunga-Lozano | Colunga-Lozano LE. Core GRADE unpacked: a summary of recent innovations in complementary GRADE methodology. J Clin Epidemiol 2026;189:112047. DOI 10.1016/j.jclinepi.2025.112047 | ✓ | VERIFIED | mover prose→`#referencias` |
| 8 | 17238363 | s-pico:181-186 | Huang PICO | Huang X. Evaluation of PICO as a knowledge representation for clinical questions. AMIA Annu Symp Proc 2006;2006:359-63. DOI none | ✓ | VERIFIED | mover prose→`#referencias` · **ano 2006, não 2007** — corrigir se slide tiver 2007 |
| 9 | 28234219 | s-pico:181-186 | Adie | Adie S. Are outcomes reported in surgical randomized trials patient-important? A systematic review and meta-analysis. Can J Surg 2017;60(2):86-93. DOI 10.1503/cjs.010616 | ✓ | VERIFIED | mover prose→`#referencias` |
| 10 | 29713212 | s-objetivos:285 | Nasr JA 2018 Adv Med Educ Pract | Nasr JA. The impact of critical appraisal workshops on residents' evidence based medicine skills and knowledge. Adv Med Educ Pract 2018;9:267-272. DOI 10.2147/AMEP.S155676 | ✓ | **IDENTITY CONFIRMED** | remover comentário inline `[dados forest plot não no abstract]`; manter `.v` (decisão Lucas: só identidade, sem deep-read) |
| 11 | — | s-importancia (novo) | Borenstein 2021 | **NO PMID — book reference**: Borenstein M, Hedges LV, Higgins JP, Rothstein HR. *Introduction to Meta-Analysis*, 2nd ed. Wiley, 2021. ISBN 978-1-119-55835-4 | n/a | BOOK (no PubMed) | entry em `#referencias` sem link PubMed e sem badge `.v` (badge `.v` exige PMID). Texto completo da referência com ISBN |
| 12 | 39240561 | s-importancia (novo) | Kastrati & Ioannidis 2024 (concordância MA vs mega-trial) | Kastrati L, Raeisi-Dehkordi H, ..., Ioannidis JPA. Agreement Between Mega-Trials and Smaller Trials: A Systematic Review and Meta-Research Analysis. JAMA Netw Open 2024;7:e2432296. DOI 10.1001/jamanetworkopen.2024.32296 | ✓ | VERIFIED | entry em `#referencias` com `.v`. Nota: "Kastrati L" (Lum Kastrati, Bern) — **não** Adnan Kastrati (cardiologista Munich) |
| 13 | 2858114 | s-importancia (novo) | Yusuf 1985 beta-blockers | Yusuf S. Beta blockade during and after myocardial infarction: an overview of the randomized trials. Prog Cardiovasc Dis 1985;27. DOI 10.1016/s0033-0620(85)80003-7 | ✓ | VERIFIED | entry em `#referencias` com `.v`. Coautores clássicos: Peto R, Lewis J, Collins R, Sleight P |
| 14 | 1614465 | s-importancia (novo) | Lau 1992 estreptocinase cumulativo | Lau J. Cumulative meta-analysis of therapeutic trials for myocardial infarction. N Engl J Med 1992;327. DOI 10.1056/NEJM199207233270406 | ✓ | VERIFIED | entry em `#referencias` com `.v` |
| 15 | 37575761 | s-pico:232-236 | VTS med ed (audit S150 flag: INVALID) | Isa HM. Autoantibody Positivity in Two Bahraini Siblings With a Novel Alpha-Methylacyl-CoA Racemase Mutation. Cureus 2023;15. DOI 10.7759/cureus.41720 | ✗ | **INVALID — confirmado** | **remover totalmente** do arquivo (citação + entry se existir) — é case report pediátrico de Bahrein sobre AMACR mutation, fora do tema |

## Summary

- **13 VERIFIED** (bate autor + título + journal + ano): #1-#10, #12-#14
- **1 BOOK** (sem PMID, citação textual com ISBN): #11 Borenstein 2021
- **1 INVALID — confirmado** (PMID existe mas é paper não relacionado): #15 — 37575761 (audit S150 correto)
- **0 pendências** — Fase A está completa, Fase B pode começar

## Correções colaterais descobertas

1. **Huang X ano 2006, não 2007**: se `s-pico.html` cita Huang 2007, corrigir para 2006 durante B1.
2. **Kastrati L, não Adnan Kastrati**: Lum Kastrati (Bern) é o primeiro autor do paper JAMA Netw Open 2024. Importante não confundir com Adnan Kastrati (cardiologista Munich). s-importancia deve citar como "Kastrati L & Ioannidis 2024" ou "Kastrati, Ioannidis et al. 2024".
3. **Nasr flag S149 resolvido**: identidade 100% confirmada (PMID, autor, título, journal, ano, DOI). Remover comentário inline em B4. Decisão Lucas: não re-verificar dados numéricos (44%→76%) do forest plot — só identidade.

## Metodologia

- **Primário**: NCBI eutils (`esummary.fcgi`, `esearch.fcgi`) via WebFetch. Equivalente funcional ao PubMed MCP (é a mesma API upstream).
- **Fallback**: SCite MCP (`mcp__claude_ai_SCite__search_literature`) usado apenas para Kastrati/Ioannidis quando a query eutils inicial não bateu. Chamada única, autorizada por Lucas como "SCite quando em dúvida".
- **Não usado**: PubMed MCP direto (tool schema não indexado no harness S151); deep-read SCite para Nasr (decisão explícita Lucas: só identidade).

## Next

Lucas valida esta tabela → commit Fase A → iniciar Fase B1 (s-pico.html).
