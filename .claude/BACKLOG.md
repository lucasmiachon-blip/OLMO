# BACKLOG — Persistent Self-Improvement Channel

> Non-auto-loaded. Consulted on-demand via Read. Extracted from HANDOFF.md S156 INFRA_3.
> Governance: items surgem via backlog gate (S155). RESOLVED items stay for historical reference.

| # | Item | Detalhe |
|---|------|---------|
| 1 | Pernas pendentes (research) | Perna 2 (evidence-researcher), Perna 6 (NLM: requer login) |
| 2 | Adversarial deferred M-01/M-10 | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 3 | Hook/config system review | JSON adequado? YAGNI audit. Lucas flagged S152 |
| 4 | Pipeline DAG end-to-end | cowork→NLM→wiki |
| 5 | medicina-clinica stubs | 4 concepts stub/low aguardam Cowork harvest |
| 6 | Skill de slides consolidada | Usar skill-creator para criar skill nova |
| 7 | P006: plan pre-flight tool availability | Re-design: Step 1.5 em research/SKILL.md ou static allowlist |
| 8 | Postmortem dead JSON+py pipeline | Lucas pediu "para registrar". S156+ |
| 9 | S155 Group E slide-patterns vs slide-rules drift | 5 findings em `.claude/tmp/c1-result.md` (C1 #6-#10). Defer slide-focused session (touches CSS/runtime + Lucas working area) |
| 10 | [RESOLVED S156] settings.local.json wildcard collapse | Executado S156 Commit 2. 68→26 entries. MCP wildcards incluidos (pubmed/biomcp/crossref) |
| 11 | S155 Group G hooks lazy load | Complexity-as-ceremony per backlog gate |
| 12 | [RESOLVED S158] settings.local.json reflection S157 | Fix aplicado: removeu `"Edit"` e `"Write"` do allow. Volta ao default=ask. Manual via editor pelo Lucas (guard A6 bloqueou agent). |
| 13 | g3-result memory findings audit | 15 findings Gemini sobre memory duplication/drift (S156 INFRA_3 `.claude/tmp/g3-result.md` foi capturado). Memory ja no cap 20/20 — audit antes de next /dream |
| 14 | content/aulas metanalise: s-objetivos customAnim | stagger nao wired — apos QA visual |
| 15 | Hooks reduction audit | 38 hooks sem reducao em S156 (so permissions 68→26). Smells: 3 wildcard `.*` PreToolUse + 6 Bash hooks + momentum-brake trio + hook-calibration/success-capture em PreToolUse (deveriam ser Post). Stop hygiene 7 hooks ~OK. Next /insights target. |
| 16 | Zombie refs audit post-archival | S154 arquivou `lint-narrative-sync.js` + `s-checkpoint-1` mas deixou dangling refs. S157 fixou 4 active (done-gate, AGENTS.md, content/aulas/CLAUDE.md, quality-gate). Ainda: docs/aulas/AGENT-AUDIT-S79.md + research-gaps-report.md + cowork-evidence-harvest-S112.md (historicos, baixo risco). |
| 17 | Context reduction — qualitative findings S157 | Adversarial review S158 descartou numeros (bytes/4, nao tokenizado), P11/P12 (dispatch failure), §6 meta-proposals (scope creep), KBP-17 conflict. **Trigo preservado:** (a) P5 ground truth = 8 files auto-loaded (nao 15); (b) Codex R6/R7 demoted (files nao auto-loaded); (c) preservar procedural gates que nao existem em pointer target (R1/R2/R3/R5 caveats); (d) KBP renumerado para KBP-18 (abaixo, item 18). **Pre-exec obrigatorio:** tokenizer real (nao bytes/4), red team verdadeiro (nao auto-validacao). Synthesis consumido+superseded em `.claude/workers/reducao-context/synthesis-2026-04-11-1631.md`. |
| 18 | KBP-18 — dispatch sem prompting skill | Ex-"KBP-17 candidate" do worker S157 (conflito de numero — KBP-17 ja ocupado por Gratuitous Agent Spawning). 5 root causes: no pre-dispatch ritual, name-matching bias, momentum after correction, complexity-as-ceremony inversion, cognitive vs hook layer. Add como Format C+ pointer → `feedback_agent_delegation §Pre-dispatch ritual`. Hook enforcement proposal separado (L4 move, warn-level primeiro). |
| 19 | Symmetric vs adversarial triangulation doctrine | §6.4 synthesis: agreement entre modelos similares (mesma training distro) pode ser coherence bias compartilhada, nao validacao independente. Future multi-leg = 1 symmetric + 1 adversarial pair, nao N symmetric legs. Value density de red team genuino > N-esima perna simetrica. Add como decision doctrine em `patterns_adversarial_review.md` apos proximo /dream. |
| 20 | guard-bash-write.sh gap — python script file bypass | Pattern 7 cobre `python -c` mas NAO `python script.py` ou `python ./file.py`. Worker dream S158 contornou o hook criando script file e executando (evidencia: dream report "Worked around using Python os.remove()" — nao menciona -c flag). KBP-07 violado pelo subagent. Fix: expandir pattern 7 para cobrir ambos. Test cases necessarios: python -c, python file.py, python ./file.py, python3 variants, py variants. Defer /insights futuro (nao hot fix). |
| 21 | Backward nav: restore beat state (nao beat 0) | Re-entry sempre volta ao beat 0 (replay auto-play + reveals from scratch). UX ideal: backward retorna ao ultimo beat visitado. Requer persistir `revealed` count fora da factory closure (ex: Map no dispatcher ou data-attr no DOM). Baixa prioridade — beat 0 funciona, professor pode re-clicar. S167. |
| 22 | /dream auto-trigger firing >1x in <24h | S187: dream markers rodaram mesmo com <24h desde ultimo run. Repetitivo — investigar logica de `.dream-pending` creation (hook stop?) vs `.last-dream` check. Nao urgente mas consome tokens. |
| 23 | Edit/Write permission glob nao funciona em Windows | Edit(.claude/skills/**) nao faz match com paths absolutos Windows. Workaround S189: Edit e Write sem args (hooks protegem). Root cause: permission system usa prefix match, nao glob. Investigar se :* syntax funciona ou se precisa path absoluto. Relacionado: backlog #12 (mesmo ciclo add/remove). |
