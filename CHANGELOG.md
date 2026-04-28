# CHANGELOG

## Sessao 273 — 2026-04-28 (remove-forest-overlays · pedagogical pivot Lane A)

> Lucas frame: "tire os overlays do s-forest1 e 2 estao muito ruins" → pivot completo plan vigente curious-enchanting-tarjan.md (Phases B+C+D refinavam overlays) → novo plan swift-plotting-tome.md → execução auto mode.

- **Decisões Lucas via AskUserQuestion:** s-forest1 → auto-only (clickReveals 5→0); s-forest2 preserva 3 beats não-overlay renumerados 1→3 (badge "15 MAs" / Cochrane logo / zoom RoB; clickReveals 8→3); slide novo "criar um" deferred S274+.
- **Code Edits (14 Edits / 7 files):** HTMLs forest1/forest2 (zones removidas + data-reveal renumerado em forest2). CSS strip 5 blocos (zones forest1+forest2+RoB + 2 failsafes). slide-registry.js rewrites (s-forest1 ~10li auto-only, s-forest2 3-beat MAX). _manifest.js clickReveals.
- **Docs sync:** `.claude/plans/curious-enchanting-tarjan.md` banner SUPERSEDED no topo (Phases B+C+D obsoletas; Phase A done preservada). `metanalise/HANDOFF.md` L62-63 notas atualizadas. Plan novo `.claude/plans/swift-plotting-tome.md` criado (escopo + decisões + Pre-mortem).
- **Bonus:** `00-title.html` autor `Paulo da Ponte` → `Lucas Takeshi` (Edit Tier T inline).
- **Verificação:** lint:slides clean · build:metanalise PASS (17 slides regen) · grep `data-reveal="[6-8]"` em metanalise = 0 · grep `forest-zone` em metanalise = 0.

### Aprendizados (max 5 li)

- **Pivot pedagógico mid-plan:** Phases B+C+D do curious-enchanting-tarjan.md viraram SUPERSEDED via banner (KBP-15 archival pattern) — judgment do domain expert (Lucas é o professor) > otimização teórica refinando algo decidido como ruim.
- **Zone --rob beat 8 = código morto por inércia:** JS comment dizia "no overlay" mas HTML/CSS overlay existiam não-ativados. Remoção limpou ~20 li drift silencioso. KBP candidate: spot-check quando comment contradiz código.
- **Race-safe paralelo no mesmo file:** 5 Edits CSS + 3 HTML + 2 JS rewrites paralelos (non-overlapping linhas/old_strings) — KBP-25 confirmado, velocity preserva atomicidade.

## Sessao 272 — 2026-04-28 (AUDIT_HARD · adversarial S272 + 6 fix mecânicos pós-audit)

> Lucas frame: "auditor adversarial senior socio minoritario" → relatório 2380 palavras → "entre em plano e proponha sequencia de acao" → 6 waves Tier-S em auto mode.

- **Audit adversarial S272 (read-only, 14 findings):** 0 CRITICO + 4 ALTO (A1 hook breakdown drift recursivo + A2 VALUES.md count + A3 AGENTS.md fork + A4 CHANGELOG cap) + 6 MEDIO + 4 BAIXO. Relatório inline + plano `.claude/plans/purring-purring-bubble.md`. Padrão meta-recorrente: drift recursivo dentro do escopo do auto-validador (INV-4 v1) que motivou criação do validador em S271.
- **Wave 1 (`ae5bae7`) A2 VALUES.md fix:** :33 `agents (19) + skills (18)` → `(21) + (19)`. Truth-pass S270 em CHANGELOG:126 falsamente declarava VALUES sincronizado.
- **Wave 2 (`518718d`) A4 CHANGELOG truncate:** 13→10 sessions ativas. S261/S262/S263 (3 oldest) movidos para top de `docs/CHANGELOG-archive.md` (S263→S262→S261 reverse-chronological dentro do bloco). Plan literal dizia "S262/S263/S264" mas honest scan revelou S261 oldest. Footer "(7b–263)"; archive header sync.
- **Wave 3 (`d8742b6`) A1 INV-4 v2 + 5 docs hook breakdown sync:** `tools/integrity.sh check_inv_4` estendido com `fs_total/fs_cmds/fs_prompts` via jq + `hook_docs[]` array (4 docs) + 3 grep patterns. jq empírico revelou audit detectou só metade: real é "35 registrations: 33 cmd + 2 prompts" (não "34: 33+1" como audit assumiu). Sync CLAUDE.md/README.md(2x)/docs/ARCHITECTURE.md(2x)/.claude/hooks/README.md. INV-4 v2 self-test: 6 violations detected → 0 pós-fix.
- **Wave 4 (`6e86fca`) A3 AGENTS.md re-sync:** :17-19 Tier S/M/T qualifiers re-sync com `anti-drift.md:88-90` master. Tier M ganhou "novos agents/skills, deletes de hook/script versionado"; Tier T ganhou "em arquivo já owned"+"Edit não-canônica"+full Pre-mortem/Steelman elaboration. Self-aware fork comment :15 agora refletido em conteúdo.
- **Wave 5 (`2752b03`) M1 model precedence:** `docs/ARCHITECTURE.md §Model Routing` ganhou 1 linha clarificando agent frontmatter `model:` overrides `CLAUDE_CODE_SUBAGENT_MODEL` env var. Marked HIPOTESE inline pending empirical confirmation.
- **Wave 6 (`369eeb2`) M6 Stop[1] telemetry proxy:** `hooks/stop-quality.sh` ganhou bloco que captura Tier-S edit opportunities (uncommitted git diff + last 30min commits) em `.claude/stop1-telemetry.jsonl`. Pre-mortem confirmado: Stop[1] type:prompt output não vai pra stderr → captura direta inviável → PROXY signal pra cross-ref manual com Stop[1] feedback messages no turn-replay. Prerequisite a M2 regex calibration (deferred ≥3 sessions de dados).

### Aprendizados (max 5 li)

- **Drift recursivo é o cenário típico de validador novo:** S271 INV-4 nasceu pra catch count drift "19/18→21/19", mas mesma sessão adicionou Stop[1] prompt bumpando hooks 34→35 / prompts 1→2 — drift dentro do escopo do auditor recém-nascido. Lesson: ao adicionar validador, listar TODOS os contadores cobertos vs incobertos antes de fechar o ticket; INV-4 v2 cobre breakdown agora.
- **Auto-validador não substitui re-medição empírica:** integrity-report PASS S271 deu false confidence — INV-4 v1 só validava 2 de ~6 contadores possíveis em settings.json+docs. jq empirical (`33 cmd + 2 prompts = 35 total`) revelou que audit S272 inicial subestimou drift (assumi 34 total mantido, real era 35). Lesson: auditor deve rodar fonte mecânica (jq, find, wc) ANTES de propor fix, não confiar em INV report PASS.
- **Wave 2 plan literal vs honest scan:** plan dizia "S262/S263/S264" mas scan revelou S261 oldest. Aplicada correção dentro da aprovação (preserva intent "cap=10") + comunicada explícita. Lesson: plan approval cobre intent + scope, não cada literal — corrections ok se transparentes.
- **Stop[1] type:prompt telemetry inviável direto:** prompt output vai pra harness, não pra stderr. Wave 6 entregou PROXY (Tier-S edit opportunities) que requer manual cross-ref. Honest scope-correction do plan original ("via stderr log") feita visível em commit message + Pre-mortem capturado upfront. Lesson: telemetry de hook prompt-type precisa de mecanismo upstream (CC harness exposure) que não existe hoje.
- **6 waves × Tier-S em 1 sessão funcionou:** plan-mode + auto-mode + EC loop por wave + INV-4 PASS gate entre waves preservou momentum sem skipping safety. 6 commits one-concern, 0 violations final. KBP candidate: "audit-fix mecânico Tier-S em sequência ≤6 waves auto-mode é sustentável; >6 ou misturar decisão Lucas seria override do plan".

## Sessao 271 — 2026-04-28 (audit-fix: 5 findings mecanicos do S270)

> Lucas frame: "continuar audit, comecar pelos criticos". Plan-mode aprovado com scope mecanico vs governance defer explicito.

- **C1 [docs] Mermaid L3 honesty:** `docs/ARCHITECTURE.md:99` `fill:#2ecc71` → `#95a5a6` (cinza Wet Asphalt) + node label `<br>NOT IMPL` em :91. L3 visualmente distinto de L2/L4/L5/L7 (DONE verde) e L6 (BASIC laranja); tabela `:110` ja consistente.
- **A1 [docs] Component count sync:** filesystem source-of-truth = `21 agents / 19 skills` (verificado `ls .claude/agents/*.md | wc -l`). Edits: `README.md:17,18,37` + `docs/ARCHITECTURE.md:5,12,13,26`. Breakdown atualizado: `9 core + 7 debug-team + 5 research wrappers` (S269 D-lite adicionou +2). Date refresh `S266 → S271`. CLAUDE.md ja correto, nao tocado.
- **A2 [docs] EC loop master + pointers:** `anti-drift.md §EC loop` (linhas 84-107) declarado canonical. Conversoes para pointer: `CLAUDE.md` ENFORCEMENT #7 (lista de fases removida), `HANDOFF.md:23` (prosa-resumida → pointer + fork map), `.claude/context-essentials.md:25` (prosa-resumida → pointer). `AGENTS.md:13-29` mantida como cross-CLI fork (Codex/Gemini nao leem CLAUDE.md) + header blockquote declarando dependencia + obrigacao re-sync. Verificacao `grep -c "Fase 4 - Pre-mortem"`: master=1, fork=1, 3 pointers=0 cada (esperado).
- **A5 [rules] KBP-06/15 broken refs eliminadas:** `~/.claude/memory/` confirmado inexistente (`Glob **/feedback_*.md` = 0). KBP-06 → `anti-drift.md §Delegation gate #4 + KBP-32`; KBP-15 → `§Concurrent agent commit safety + KBP-51`. Conteudo equivalente ja vivo nestas secoes; pointer integrity restaurada sem criar arquivos novos (KBP-15 self-application).
- **B2 [rules] Tone propagation cleanup:** `anti-drift.md:10` `(16 agents pendentes)` removido — claim sem tracking file. Rule-base "Sub-agents propagam este default" preservada.
- **INV-4 [hook] Count integrity validator (audit §7 ALTO):** `tools/integrity.sh` ganhou `check_inv_4` que valida `find .claude/agents -name '*.md' | wc -l` vs primeiro `- N subagents` em CLAUDE.md/README.md/docs/ARCHITECTURE.md (mesmo para skills). Stop[5] hook (settings.json:445) já invoca o script — integration zero-config. Self-test PASS 6/6 (3 docs × 2 counts). Bug printf format (3 args para 2 `%s`) detectado e corrigido em mesmo commit. Header :13-14 marca INV-4 como DONE.
- **A3/A4 [rules+hook] EC loop "professional, not theatrical" (audit S270 §A3+§A4):** `anti-drift.md §EC tiers` introduzido (Tier S/M/T) — Pre-mortem obrigatório em tier S (`.claude/rules/`, `settings.json`, `.claude/hooks/`, `hooks/`, `CLAUDE.md`, `AGENTS.md`) e tier M (≥3 file refactor, migration, scope ext); opcional em tier T (typo, single-line). `[budget]` reframado de Xmin time-based para `calls atuais: N | última approval: K | delta` call-based (mecanicamente verificável via APL `calls:NNN` ou `~/.claude/stats-cache.json`). `settings.json` ganhou Stop[1] prompt hook detectando tier-S Edit sem `Fase 4 - Pre-mortem` visível e scope extension sem `[budget] calls atuais`. KBP-52 adicionado. AGENTS.md fork sincronizado com §Codex/Gemini EC tiers. Self-test pós: `jq '.hooks.Stop | length' .claude/settings.json` = 6 (era 5), Stop[1].type = prompt, integrity 0 violations.
- **A6 [docs] HANDOFF truncate (audit §A6, 113→52 li):** §0 Estado de 12 carryover bullets para 1 linha pointer (S271 status + CHANGELOG/CATALOG refs). Lane sections §1-3 trimmed de ~20 li cada para ~3 li (heading + triggers + Fonte/Plano + 1-line state). §4 Roadmap + §5 Regras intactos. Cap declaration em `anti-drift.md §Session docs` reframada de `max ~50` aspiracional (226% over) para `max ~60` calibrado com breakdown explícito. Truncate aggressive vs raise cap = doctrine "professional não teatral" aplicada (raise seria downgrade, audit `[budget]` lesson).
- **A7 [docs] CATALOG.md created (audit §A7):** `.claude/CATALOG.md` single source of truth para 40 entries (21 agents + 19 skills). Status taxonomy: `active` / `active-but-rare` / `intentional-dormant` / `candidate-delete`. Resultados: 6 agents `active` (research/QA/quality core), 7 debug-team `intentional-dormant`, 6 skills `candidate-delete` (skill-creator, improve, automation, docs-audit, knowledge-ingest, nlm-skill — revisar S275-280 com Lucas 1-a-1). Bulk delete proibido (audit §8). Pattern: KBP-16 pointer-only spirit (status registry, não description duplicate); review cadence formalizada (/dream + audit S275+ + pre-commit trigger).
- **Documental [archive+xref] S271 close:** `.claude/plans/snazzy-purring-dream.md` → `archive/S270-audit-adversarial-15-findings.md`; `.claude/plans/elegant-crafting-marshmallow.md` → `archive/S271-audit-fix-criticos.md` (`git mv` preserva history). `.claude/plans/README.md` sincronizado: header "S272 reidratação", Active plans labels normalized para `[Lane A]` / `[Lane B]`, §"Archived S270-S271" section adicionada, archive count 113→115, Histórico recente table +2 rows. HANDOFF.md cross-refs apontam paths archive; §0 ganhou stamp explícito (Stop[1] soak test pendente + S275-280 catalog review trigger). `.claude/context-essentials.md` trimmed: removida `Drift local conhecido` (settled state, S267 carryover noise), audit refs S267/S270/S271 consolidados em 1 line. Pattern: archive at session-end + `git mv` preserva history.

- **BACKLOG [cleanup] #43+#44 RESOLVED via S232 #51 (sub-agent paralelo):** Lucas pediu 2 quick wins paralelo a /dream. Sub-agent leu BACKLOG + spot-checked: `agents/core/orchestrator.py` = FILE_NOT_FOUND, Grep `orchestrator` em `**/*.py` = 0 hits — confirmou ambos referenciando código deletado em S232 commit `46489c0`. Marcados RESOLVED. Counts: P2 24→22, Resolved 18→20. Bonus deferido: `agents/` dir tree (6 subdirs `__pycache__`-only, gitignored) — repo-janitor target.
- **/dream Phase 4 close:** 4 memory files updated (em `~/.claude/projects/<hash>/memory/`, fora repo OLMO): MEMORY.md S253→S271 + Quick Reference SUPERSEDED counts (39→53 KBPs / 32→34+ hooks / 16→21 agents / 18→19 skills) + S270-S271 audit governance close summary line; project_tooling_pipeline.md frontmatter description + supersedes refresh; patterns_antifragile.md +Tier-based aspirational rule capture pattern + Audit close ritual pattern; changelog.md 4 dream rows. Dual-write `.last-dream` global + per-project. Memory cap 19/20 OK, MEMORY.md 68/200 li OK.

### Aprendizados (max 5 li)

- **Audit utility = trail decisional auditavel:** separar fix mecanico (C1+A1+A2+A5+B2, 30min) de decisao de governance (A3+A4+A6+A7) preserva commits limpos. Misturar = decisao honesta vira footnote do commit gordo.
- **`~/.claude/memory/` declarado mas nunca existiu:** CLAUDE.md user-global §Memory Governance descreve sistema de topic files com cap=20 + MEMORY.md index, mas dir nao existe nesta maquina. KBP design depende de pointer integrity — broken refs KBP-06/15 viviam ha sessoes. Resolucao: redirecionar para conteudo equivalente ja em master (`anti-drift.md`), nao criar arquivos para preencher pointer.
- **Component counts sem hook auto-validador continuam driftando — agora fechado:** Cenario 1 do pre-mortem S270 ("README perde credibilidade após 5 valores divergentes em 3 docs") foi prevenido com fix manual + INV-4 mecânico nesta mesma sessão. Drift futuro vira FAIL no integrity-report.md com `[INTEGRITY] violations` no Stop[5] hook. Lesson meta: "audit §7 ALTO/30min — incluir em proxima sessao" virou "doing now" em <5min porque tools/integrity.sh já existia com roadmap interno (KBP-37 §Doing now: cheap + value + zero risk).
- **Fork explicito > duplicacao implicita:** AGENTS.md mantida como fork porque Codex/Gemini nao leem CLAUDE.md/anti-drift.md. Header blockquote declara fonte + obrigacao re-sync — assim drift fica detectavel ao inves de invisivel. Nao tentar consolidar cross-CLI em arquivo unico (auditoria S270 §8).
- **A3/A4 forward: aspiracional → mecanicamente enforceable:** Pre-mortem aplicado pela primeira vez em 10 sessoes (S271 plan §Rollback/stop-loss listou 3 triggers objetivos), depois operacionalizado via tier system + Stop[1] prompt hook. `[budget]` reframado time-based → call-based eliminou o motor de decay confessado em `anti-drift.md:32` ("Habit sem gate mecanico decai"). Lesson meta: regras textuais "obrigatórias" que dependem de mental math do agent decay independente de boas intencoes; mecanizar via tier explicitos + grep-detectable patterns + Stop hook é a forma profissional, ritual decoracional é a forma teatral.

## Sessao 270 — 2026-04-28 (audit adversarial: 15 findings drift documental + ritual)

> Lucas frame: "auditor adversarial senior" -> read-only plan-mode -> "commitado e algo para apontar amanha".

- **Auditoria adversarial 4-fase:** mapeamento + steelman + teardown + pre-mortem produzidos via 3 Explore agents paralelos + spot-checks file:line. Output `.claude/plans/snazzy-purring-dream.md` (~2050 palavras, 8 secoes formato fixo: TL;DR, Steelman, Findings por severidade, Duplicacoes, Aspiracional vs operacional, Pre-mortem 6m, Acoes, O que NAO fazer).
- **15 findings rastreaveis com file:line:** 1 CRITICO C1 (`docs/ARCHITECTURE.md:99` Mermaid `fill:#2ecc71` colore L3 verde-DONE enquanto `:110` declara "NOT IMPLEMENTED — cost-circuit-breaker.sh removed S230 audit"; hook ausente confirmado via `ls .claude/hooks/ hooks/ | grep -i circuit` vazio).
- **7 ALTO:** count drift (CLAUDE=21/19, README=19/18 [internamente contradicto :17 vs :37], ARCHITECTURE=19/18 — FS=21/19 verificado); EC loop body em 5 arquivos sem master declarado (`anti-drift.md:84-107` + `AGENTS.md:13-29` + `CLAUDE.md` inline + `HANDOFF.md:23` + `context-essentials.md:25`); Pre-mortem definido 5x aplicado 0x em 10 sessoes (grep `Fase 4 - Pre-mortem` retorna so definicoes); `[budget]` gate 0 grep hits all-time (`anti-drift.md:32` auto-confessa "Habit sem gate mecanico decai"); broken refs `KBP-06`/`KBP-15` → `feedback_*.md` Glob 0 arquivos; HANDOFF.md 109 li vs anti-drift `:127` cap "max ~50" (218% over); catalog inflation 13/19 skills + 11/21 agents 0 hits S261-S269.
- **4 MEDIO:** Stop[0] EC enforcement prompt-side nao hook; plans ativos 1941 li totais; KBP-26 pointer plan arquivado bug aberto; AGENTS.md duplica EC loop apesar de "Claude Code NAO le".
- **3 BAIXO:** TODO Langfuse OTel S82 ~3 semanas; tone propagation `anti-drift.md:10` "16 agents pendentes" stale (FS agora 21); `tools/docling` candidato a delete sem follow-up.
- **Steelman explicito antes de critique:** repo tem disciplina rara (S258 hook audit 0 teatro reconfirmado spot-check; KBP-31 candidate-commit gate fechou loop S269 commits 67c2688 15min antes do audit; ADR-0007 reframe demonstra processo vivo; pointer-only KBP format 51 entradas zero inline prose). Critica focada em "forma supera funcao", nao "tudo teatro".
- **HANDOFF + CHANGELOG persistencia:** HANDOFF.md §0 Estado + §4 Roadmap Now apontam para plan; entry S270 nesta CHANGELOG. Audit findings nao implementados — Lucas decide entre 3 options nas Notas finais do plan.

### Aprendizados (max 5 li)

- **Diagrama vence footnote:** Mermaid screenshot propaga visual; tabela texto adjacente nao chega ao consumer. L3 verde-DONE com texto NOT IMPL = mentira propagavel via recall/slide.
- **Aspiracional silencioso erode operacional:** Pre-mortem 0/10 sessoes + `[budget]` 0/all-time, ambos auto-confessados anti-drift `:32`. Risco: ritual EC inteiro perde credibilidade quando 1 fase falha visivelmente, mesmo com Verificacao+Steelman+Autorizacao operacionais.
- **Audit como calibracao in vivo:** descoberto que esta sessao pulou Pre-mortem no EC do session-name write (trivial → pulado) demonstra a degradacao mapeada; segundo EC (commit) aplicou Fase 4 explicitamente, sinal que regra funciona quando trazida a frente.
- **Plan file > report ephemeral:** persistir audit em `.claude/plans/` + pointer HANDOFF + entry CHANGELOG = template repetivel; report soltao em chat = dust pos /clear (KBP-29).
- **3 Explore agents paralelos > sequential reads para audit broad scope:** breadth via agents (~2KB cada) + spot-checks diretos (file:line para citation) bate single-thread reads em ~10x velocidade preservando rigor KBP-32.

## Sessao 269 — 2026-04-28 (research D-lite anti-overengineering)

> Lucas frame: construir agentes/subagents conforme SOTA, sem deletar antigos, contra overengineering e com teste profissional.

- **Research Agent Contract:** criado `docs/research/sota-S269-agents-subagents-contract.md` com sintese SOTA, divisao deterministico vs exploratorio, `ResearchRunSpec`, output canonical e promotion gate.
- **D-lite paralelo aos antigos:** adicionados `.claude/scripts/research-dlite-runner.mjs`, `.claude/agents/gemini-dlite-research.md` e `.claude/agents/perplexity-dlite-research.md`. Os antigos `.mjs` e agents chatty continuam intactos.
- **Smoke sem API:** `scripts/smoke/research-dlite-contract.mjs` valida runner, payload dry-run Gemini/Perplexity, schema spot-check e anti-chattiness dos novos agents. Verificacao: `node scripts/smoke/research-dlite-contract.mjs` PASS.
- **Live smoke cost-gated:** Perplexity D-lite PASS com JSON valido + NCBI 2/2 PMIDs; Codex xhigh incluido via `--validate-file --verify-pmids` PASS + NCBI 4/4 PMIDs; Gemini bloqueado por `429 RESOURCE_EXHAUSTED` apos uma falha anterior por JSON truncado.
- **Confirmacao rigorosa:** runner agora suporta `--verify-pmids`, `--validate-file`, artefatos de falha bruta e `json_schema.name` para Perplexity conforme docs oficiais; DOI/URL nao verificados pelo runner sao rebaixados para `verified=false`.
- **Comparacao visivel:** contrato S269 ganhou diagrama ASCII do fluxo OPEN discovery -> CLOSED boundary -> NCBI confirmation -> comparison matrix, mais plano de comparacao legacy `.mjs` vs D-lite.
- **Capture-first correction:** adicionado `.claude/schemas/research-candidate-set.json`; D-lite agora preserva recall/novelty dos scripts antigos antes de triagem Opus/MCP, em vez de forcar 3-5 findings finais cedo demais.
- **ChatGPT-5.5/Codex como perna:** Codex/ChatGPT-5.5 xhigh ficou explicitado como perna #7 para captura cross-family e validacao critica, nao como substituto de Gemini/Perplexity/Google AI Studio.
- **Reidratacao Claude+Codex:** criado `docs/research/S269-dlite-rehydration.md`; `CLAUDE.md`, `AGENTS.md`, `.claude/context-essentials.md`, `HANDOFF.md` e contrato S269 apontam para o mesmo estado/gaps.
- **Research skill/handoff:** `.claude/skills/research/SKILL.md` agora aponta D-lite como experimental S269 sem promover para canonical; `HANDOFF.md` atualiza Lane B para o contrato e smoke novo.

### Aprendizados (max 5 li)

- **Nao e scripts vs agents:** o padrao robusto e thin-agent + deterministic runner + schema; `codex-xhigh-researcher` ja provava isso.
- **Anti-overengineering = additivo e mensuravel:** construir melhor ao lado, smoke local primeiro, live re-bench antes de promover.
- **Liberdade fica na busca, determinismo fica no boundary:** provider explora; JSON schema + validator + PubMed/CrossRef seguram o downstream.
- **Nao promover com n=parcial:** 2 pernas passaram, Gemini bloqueou; D-lite fica experimental ate re-bench completo.

## Sessao 269 — Lane D — 2026-04-28 (s269-document-conversion: epub→pdf pipeline + uv hardening)

> Lucas frame: "transformar epub em pdf mais profissional possivel" -> "deixe tudo mais profissional e atualizado" (uv migration, security audit, venv isolation). Lane paralela ao Lane B (research D-lite, outro agente).

- **Skill `.claude/skills/document-conversion/` criado:** v1.1.0 com decision tree (EPUB↔PDF↔Markdown via Pandoc+xelatex / Docling / Calibre). Case real `examples/fletcher-epidemiologia-2026-04-27.md`. Discoverable via Skill tool. Plan `.claude/plans/toasty-greeting-crown.md`.
- **EPUB → PDF Fletcher Epidemiologia 6ed (372pp, A4, 22.6MB):** Pandoc 3.9.0.2 + xelatex MiKTeX 25.12, Cambria mainfont, pt-BR Babel hyphenation, TOC 3-niveis NavyBlue. Output em `~/Downloads/` (fora git por copyright Artmed). Tools instaladas via winget (Pandoc/MiKTeX/Calibre 9.7.0 todos signed installers).
- **Security audit cross-source:** Pandoc/MiKTeX/Calibre 9.7.0 patched contra CVEs 2026 (path traversal CVE-2026-25636/26064/26065 fixed em Calibre 9.3+). Pandoc `--sandbox` agora default mitigation CVE-2025-51591 (SSRF iframe→AWS IMDS) + GHSA-xj5q-fv23-575g (file write `--extract-media`). Docling 2.91.0 IBM Research Zurich oficial (OpenSSF Best Practices, signed PyPI). Audit via pip-audit + WebFetch GitHub Security advisories.
- **uv-first hardening:** uv 0.10.6 → 0.11.8 (fix GHSA-pjjw-68hj-v9mw). Docling reinstalado em venv isolado `~/.venvs/document-conversion/` via `uv pip install`; removido do Python global (24 vulns no env compartilhado, agora ortogonal ao venv). pip-audit no venv: "No known vulnerabilities found".

### Aprendizados (max 5 li)

- **Skill > script standalone para reuso:** discoverability via Skill tool + decision tree estruturado bate README isolado em `tools/` quando ha ≥3 pipelines distintos.
- **Venv isolado para Python tools sempre:** global Python herda CVEs de outros projetos; venv per-task = audit clean garantido. KBP candidate.
- **uv e SOTA em Python tooling 2026:** 10-100x faster (Rust), lockfile, venv built-in; substitui pip+virtualenv+pip-tools num unico binario Astral.
- **Pandoc `--sandbox` default = custo zero, blinda input untrusted:** mitigation CVE-2025-51591 + GHSA-xj5q-fv23-575g. KBP candidate: "Native binary com input externo → sandbox flag default".
- **Concurrent agent commit safety:** `git fetch` + status detalhado antes de commit, stage per-file (nunca `-A`), Edit cirurgico em state files compartilhados (HANDOFF/CHANGELOG); aguardar liberacao explicita do usuario quando outro agente edita os mesmos shared docs. KBP candidate.

## Sessao 268 — 2026-04-27/28 (EC loop hardening + C1 guard-write fix + docs hygiene)

> Lucas frame: "contexto eh efemero" -> persistir loop verificacao/evidencia/autorizacao -> "C depois B" -> corrigir C1 -> "roadmap constante".

- **EC loop persistido e expandido:** `AGENTS.md`, `CLAUDE.md`, `.claude/rules/anti-drift.md`, `.claude/context-essentials.md` e pointers nos 3 writer agents (`debug-patch-editor`, `qa-engineer`, `evidence-researcher`). Loop canonico agora: Verificacao -> Evidencia -> Gap A3 -> Steelman -> Mudanca proposta -> Por que e mais profissional -> Pre-mortem -> Rollback/stop-loss -> Verificacao pos -> Learning capture -> AUTORIZACAO.
- **C1 guard-write boundary fixed:** `.claude/hooks/guard-write-unified.sh` normaliza paths Windows/MSYS, bloqueia `Write/Edit` fora do repo OLMO e transforma path interno nao classificado em `ask`; `scripts/smoke/hooks-health.sh` adiciona T9b/T9c. Verificacao: mocks especificos PASS, `bash scripts/smoke/hooks-health.sh` PASS 16/16, `bash -n` PASS, `git diff --check` PASS.
- **Lane C follow-up C2/A1/A2:** `done:cirrose:strict` adicionado, `pre-push.sh` versionado criado, `install-hooks.sh` fail-closed quando script versionado falta, `done-gate.js` chama npm via `cmd.exe` no Windows, hooks APL/StopFailure normalizados LF. Verificacao: `bash -n` PASS, `npm --prefix content/aulas run done:cirrose` Gate 1 PASS, strict bloqueia 2 blockers reais, `bash tools/integrity.sh` PASS 0 violations.
- **Docs hygiene + roadmap constante:** `HANDOFF.md` atualizado para S268, C1 marcado resolvido, Lane C residuals priorizados; `.claude/plans/README.md` adiciona Now/Next/Later e arquiva 4 planos fechados; KBP-45 pointer atualizado para archive; `docs/audit/codex-adversarial-audit-S267.md` recebe follow-up S268.

### Aprendizados (max 5 li)

- **Memoria de agente nao e governanca:** regra operacional precisa viver em AGENTS/CLAUDE/rules/context e pointers nos writer agents.
- **Boundary sem fixture regressa:** C1 so vira fix real quando `outside repo -> block` e `unclassified in-repo -> ask` entram no smoke.
- **Gate strict precisa falhar por razao real:** depois do fix, `done:cirrose:strict` falha por screenshots/ERROR-LOG pendentes, nao por comando inexistente.
- **Roadmap constante reduz ruido:** active plans devem conter so Now/Background; historico vai para archive com pointer vivo e grep-pass.

## Sessao 267 — 2026-04-27 (rehydration + Codex statusline + audit persistence)

> Lucas frame: "coloque contexto/cota no terminal" -> "vc eh codex diferente" -> pesquisar suporte Codex CLI -> "atualize tudo o plano... reidratar" -> "analise adversarial entrou?" -> cross-ref + commit/push.

- **Codex CLI statusline global:** `C:\Users\lucas\.codex\config.toml` atualizado fora do repo com `status_line = ["model-name", "context-used", "five-hour-limit", "weekly-limit", "used-tokens"]`; backup criado `config.toml.bak-statusline-20260427-211428`. Build local `@openai/codex@0.125.0` aceita lista de strings; forma docs array-of-objects falhou nesta build.
- **Claude Code statusline repo:** `.claude/statusline.sh` agora renderiza header OLMO + barra `ctx` + barras de cota dia/semana baseadas em contadores locais e limites env (`OLMO_*`/`CC_*`), com normalizacao Windows path `C:\...` -> `/mnt/c/...`.
- **Rehydration compression:** `HANDOFF.md` virou roteador de 3 lanes (metanalise, D-lite research, infra audit); `.claude/context-essentials.md` reduzido para survival kit; `.claude/plans/README.md` instrui abrir planos longos so por `rg`/range.
- **Codex adversarial audit persisted:** novo `docs/audit/codex-adversarial-audit-S267.md` guarda findings com evidencia linha/comando; `docs/audit/README.md`, `HANDOFF.md` e `context-essentials.md` apontam para ele.
- **Metanalise handoff stale label:** `content/aulas/metanalise/HANDOFF.md` sincronizado para S267 rehydrate sync, preservando estado operacional S265 (`s-quality` DONE; `s-forest1/2` pendentes).

### Aprendizados (max 5 li)

- **Statusline Codex != Claude statusline:** Codex usa `~/.codex/config.toml`; Claude Code usa `.claude/statusline.sh`. Misturar os dois cria falsa sensacao de configuracao.
- **Auditoria sem artefato vira memoria oral:** findings adversariais precisam de `docs/audit/*.md`; `HANDOFF.md` so deve conter ponteiro curto.
- **Reidratar por lanes reduz contexto:** start = `HANDOFF.md` + `context-essentials`; plano longo so depois que Lucas escolhe a lane.

## Sessao 266 — 2026-04-27 (safety + truth-pass documental)

> Lucas frame: "vamos em pequenos passos" → aprovar P0 safety → "atualize documental, commit e push" → priorizar documentos críticos antes de scripts/agents/subagents.

- **P0 safety:** removido `Bash(*)` de `.claude/settings.json`; removidos allows globais específicos de Chrome DevTools; `guard-bash-write.sh` agora bloqueia `rm/rmdir` por padrão enquanto KBP-26 (`ask` pode degradar para allow silent) segue aberto. Smoke manual: `rm temp.txt` retorna `permissionDecision:block`.
- **Gate Python:** `scripts/fetch_medical.py` trata `pyzotero` como import opcional para mypy (`type: ignore[import-not-found]`). `uv run mypy scripts/ config/` PASS; `uv run ruff check .` PASS.
- **Truth-pass documental crítico:** sincronizados runtime counts e comandos em `AGENTS.md`, `GEMINI.md`, `CLAUDE.md`, `README.md`, `VALUES.md`, `docs/ARCHITECTURE.md`, `docs/TREE.md`, `.claude/hooks/README.md`, `quality-gate`, `systematic-debugging` e `research/SKILL.md`. Estado canônico: 19 agents, 18 skills, 34 hook registrations; `.mjs` research hot path permanece canônico até D-lite re-bench.
- **Rehydration signal>noise:** `.claude/context-essentials.md` agora inclui loop profissional S266: rehydrate mínimo → verificar evidência → propor mudança/risco/verificação → esperar OK Lucas → editar → verificar → reportar curto.

### Aprendizados (max 5 li)

- **P0 pequeno > refactor amplo:** remover `Bash(*)` + bloquear `rm` fecha um risco real sem entrar na migração `.mjs`/agents.
- **Docs críticos são runtime:** `quality-gate` e `research/SKILL.md` instruem agentes; drift neles vira execução errada, não só documentação ruim.
- **KEEP-SEPARATE precisa aparecer no skill:** enquanto bench diz `.mjs` 9/9 e wrappers experimentais, proibir scripts no skill era contradição operacional.

## Sessao 264.c — 2026-04-27 (bench · Path A complete + Path B partial + Codex peer-review)

> Lucas frame: "rodas a pesquisa via agents skills subagents vs script ver qual performa melhora" → "comparacao so vai ser justa quando tudo funcionar" → "tem que ajustar os agentes" → "outro modelo trabalhando em outro terminal" → "deixe tudo, arrume ate ter outputs adequados pra comparacao justa" → "reflita... tem citacoes tier 1, o que deu certo, deu errado e por que" → "apresente o plano ao codex" → "entre em plan e proponha".

- **`1ff1f63` feat(bench/S264): Path A complete + Path B partial + agent fixes + Codex peer-review** `[+4539/-10, 60 files]` — bench `splendid-munching-swing.md` Phase 1.3 (smoke ✅ post-KBP-38 daemon refresh) + Phase 2 Path A 13/13 ✅ (gemini.mjs/perplexity.mjs/nlm/codex × 3 + evidence-researcher × 1) + Phase 3 Path B 1/6 emit ✅ (gemini-deep Q3 4 findings, 7/7 PMIDs NCBI-verified) + 5 raws preserved em path-b/. Agent fixes (S264.a): perplexity-sonar maxTurns 15→25, evidence-researcher drop biomcp + §Fase 1.5 Bench Mode (slide novo synthetic_context). Codex CLI peer-review (S264.c) corrigiu §S264.b: F1 count "14"→13, F2 Gemini Q2 HTTP 429 = orchestration confound meu (3 simultaneous contra plan §170 sequencial), F3 chattiness "principal hipótese pendente transcript proof". Outcome: **KEEP-SEPARATE provisional + D-lite refactor track S265+**.
- **`b6e8f7c` docs(GEMINI.md): v3.6 → v3.7 — QA Visual & Automação + scoped READ-ONLY** `[+10/-4, 1 file]` — concurrent session work outro agente Gemini CLI (loosened READ-ONLY pra `scratch/`, added §QA Visual com Playwright/Puppeteer/subagents browser ferramentas ativas).

### Aprendizados (max 5 li)

- **Codex bracket = thin-agent canonical robusto**: 0% PMID fab across 14 PMIDs sampled (NCBI-verified inline), 100% schema-strict. Body 1-phase (CLI subprocess produz JSON nativo) > 6-phase chatty wraps que natural-stop pré-emit Phase 6 (gemini-deep + perplexity-sonar pattern empírico).
- **Peer-review entre modelos = cheap quality gate**: Codex peer-review ($0 + ~5min Lucas paste) corrigiu 3 erros materiais (F1/F2/F3) + 4 blind spots (maxTurns docs, SubagentStop hooks alternative, KBP-48 over-strong, Perplexity system_prompt bug ortogonal). Pattern reusable.
- **Evidence-researcher §Fase 1.5 fix EMPIRICALLY validated**: hipótese "Phase 1 file-not-found stall em slide novo" confirmed via Q1 retest (9 sources MCP-verified, 0 CANDIDATE, ROBINS-I bonus PMID 27733354 emergiu como tool preferred over Newcastle-Ottawa).
- **Bash cwd persiste cross-tool-call (KBP-Candidate-A)**: absolute paths obrigatórios em dispatches sequenciais. Q2 batch-1 falhou exit 1 — cd `.claude/.parallel-runs/.../path-a` a partir de cwd já em path-a tentou path-a/path-a inexistente.
- **KBP-Candidate-D/E pendentes evidence**: chattiness root cause precisa transcript+stop_reason proof per Codex F3; SubagentStop hooks alternative lever vs maxTurns — defer S265 D-lite refactor + re-bench.

## Sessao 265 — 2026-04-27 (quality · s-quality Phase A architectural + quick wins contraste)

> Lucas frame: "quality" → "s quality bom defeitos pequenos principalmente contraste, analise sobre esse ponto ou eh esteticamente belo" → "considere s quality como done e vamos para os proximos".

- **Phase A — s-quality `.term-dissociation` overflow fix** (uncommitted): wrapper `.term-content-block` (grid `1fr auto`) encapsula `.term-grid` + `.term-dissociation`. `.slide-inner` 4-row → 3-row. Defensive `min-height: 0` + `overflow: hidden` em `.term-grid`. Files: `slides/05-quality.html` (re-indent +2 spaces L5-65) + `metanalise.css` §s-quality L347-358 + L362-367.
- **Quick wins contraste** (uncommitted): chip bg `color-mix 18% → 30%` (design-reference.md severity bg range mid). Label color `--v2-text-body → --v2-text-emphasis` (S262→S265 iteração inline documentada). Card borders `60% → 80%`. Lucas validou visualmente.
- **Verification:** lint:slides + build:metanalise PASS.
- **Pendente:** Phases B-G plan `.claude/plans/curious-enchanting-tarjan.md` (s-forest1/s-forest2).

### Aprendizados (max 5 li)

- **Iteração S262→S265 inline:** atualizar CSS comment com history (S262 "sem competir com term-content" → S265 "bumped emphasis, mono+caps differentiate") preserva decisão exata in-line vs CHANGELOG long-tail. KBP-31 satisfeito.
- **APCA defer (gate KBP-32):** Quick wins via parameter sweeps dentro do design-reference.md severity range declarado. APCA measurement (~30min × 9 chips) defer enquanto Lucas owns visual validation.
- **Re-indent +2 spaces inside wrapper > cosmetic indent off:** Re-indent durable (review clarity), diff one-time cost. Trade-off favorável quando file <100 li.

---

Sessoes anteriores (7b–264): `docs/CHANGELOG-archive.md`
