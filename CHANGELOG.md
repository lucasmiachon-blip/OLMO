# CHANGELOG

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

## Sessao 264 — 2026-04-27 (qa-editorial-metanalise · Phase 1 dead-code cleanup s-absoluto)

> Lucas frame: "vamos so trabalhar nos slides forest" → "atualize os documentos de forma profissional para nao haver confusao quando vc hidratar".

- **`ac65ba6` feat(metanalise/S264): Phase 1 — dead-code cleanup s-absoluto + KBP-44** `[+175/-24, 12 files]` — slide s-absoluto deletado em S186 (commit `20489a2`) deixou 11 refs stale. Cleanup categorias A (state files HANDOFF root L19 + metanalise/HANDOFF.md L15/36/79) + B (evidence broken pointers em 7 files: meta-narrativa, s-contrato L87/103, s-ancora, s-objetivos, s-forest-plot-final L305, evidence-harvest-S112 L51/89, research-gaps-report L54/214/279) + KBP-44 fix `08a-forest1.html:34` (PMID source-tag removed — s-forest2 já compliant). lint:slides + build:metanalise PASS.
- **Refactor architectural batch deferred pós-clear** — 6 issues numerados Lucas turn 7. Plan completo: `.claude/plans/curious-enchanting-tarjan.md` (Phases A-G). Slides alvo: s-quality, s-forest1, s-forest2. Out of scope: s-contrato R11 REOPEN, qa-screenshots/s-absoluto/ dir delete (Lucas direta), reconcile geral metanalise/HANDOFF.md.

### Aprendizados (max 5 li)

- **HANDOFF stale vs manifest source of truth:** HANDOFF root referenciou `s-absoluto` (deletado há 41 commits). Detection: `_manifest.js` (S207, 17 slides) vs HANDOFF (16/16) divergence. KBP-40 generaliza para narrative state files.
- **KBP-44 propagation paradox:** regra S260 ("PMID exclusivo evidence HTML") não auto-propaga — `s-forest1` ainda tinha PMID inline source-tag em S264. Single-slide rule changes raramente back-propagated mecanicamente. Lint candidate: `grep -rn "PMID:" content/aulas/metanalise/slides/`.
- **Failsafe scoping pattern:** `.no-js section#s-forestN .forest-zone {opacity:1}` (scoped per-slide) é safe — anti-pattern oposto do bug `s-contrato` R11 (regra final unscoped vazando opacity:0 globalmente, score 5.9).
- **`calibrate-boxes.mjs` (port S262 OLMO_GENESIS) é canon anti-chute:** Playwright headless extrai percentagens bounding box reais — substituir guess CSS percentages.

## Sessao 263 — 2026-04-27 (BUILD_METANALISES · wrap-canonical bench Phase 0+1)

> Lucas frame: "rodas a pesquisa via agents skills subagents vs script ver qual performa melhora" → "todas as pernas sempre x todas as pernas sempre" → "wrap eh sempre um agente orquestrador".

- **`c353f53` feat(S263): Phase 0+1 — wrap-canonical rules + 2 research agents** `[+972/-1, 5 files]` — KBP-47 ensemble + KBP-48 wrap-canonical em SKILL.md ENFORCEMENT 4-5 + KBP file (Next bumped 47→49). gemini-deep-research.md (~250li) + perplexity-sonar-research.md (~210li) JSON schema-strict alinhados com codex-xhigh-researcher template. Plan splendid-munching-swing.md (9 phases, ~7-9h total).

### Aprendizados

- **KBP-47 ensemble obrigatório:** /research dispatches ALL pernas, never subset (debt KBP-31 closed Lucas turn 3 — regra existia mas nunca registrada).
- **KBP-48 wrap = sempre agente orquestrador:** scripts .mjs são legacy a migrar. Codex (xhigh) e evidence-researcher já canônicos; gemini/perplexity migrados S263 (Lucas turn 5).
- **KBP-38 reinforced:** Phase 1.3 smoke test + Phase 2-8 bench BLOCKED até daemon Ctrl+Q + reopen. Window-restart insuficiente (S250 lesson re-aplicada).
- Schema reuse `research-perna-output.json`: codex_cli_version nullable permite Gemini/Perplexity reaproveitarem schema sem fork — triangulator (S262+) consome 3 perna types via 1 schema.
- Bench reframe pós-Lucas turn 5: CONFIRMATÓRIO (não exploratório) — vies esperado MERGE; bench documenta empiricamente a transição script→agent.

## Sessao 262 — 2026-04-27 (Slides_build · s-quality content + visual evolution + S260 commit)

> Lucas frame: "Vamos fazer slides depois migramos tentamos migra o mjs" → "calma um slide por vez, comecar com conteudo e QA visual de slide quality" → "no bloco de qualidade como a revisao foi conduzida entram com animacoes (Prospero, PRISMA, a priori, transparencia)" → "segundo box vai ser RoB1, 2 ROBUST RCT ROBINS, ULTIMO carda GRADE" → "5 cliques agrupado" → "polimento profissional hiper-detalhado shared-v2".

### Phase 0 — S260 commit batch

- **`cc04bbd` feat(metanalise/S260): heterogeneity-evolve C1+C2+D — slides reformulados pedagogicamente** `[+72/-26, 6 files]` — slides s-heterogeneity (09a) + s-fixed-random (10) + _manifest.js + evidence/s-heterogeneity.html (#estrategias-didaticas + 3 refs validadas) + .slide-integrity + HANDOFF metanalise.

### Tooling adicionado (Lucas, paralelo)

- **`475d47d` QA: calibrate-boxes.mjs port OLMO_GENESIS** `[+82, 1 file]` — Playwright tool que abre slide específico, extrai bounding boxes (wrapper/zones forest-zone/forest-zone--rob) em coordenadas % relativas ao wrapper. Anti-chute pattern: agentes Claude usam dados precisos em vez de "chutar" coordenadas CSS. Default `--slide s-forest2`.

### Phase 2 — s-quality content evolution

- Card Qualidade (Pergunta): chips animados PROSPERO · A priori · PRISMA · Transparência (princípios de qualidade da RS, Lucas direção concreta).
- Card RoB (Ferramenta): chips RoB 1 · RoB 2 · ROBUST-RCT · ROBINS (substituiu texto plain).
- Card Certeza (Ferramenta): chip GRADE (consistent com pattern).
- Card Qualidade (Ferramenta): chips simétricos AMSTAR-2 · ROBIS (era texto plain — simetria entre os 3 cards).
- Row Confusão removida dos 3 cards (alinhamento + clareza pedagógica).
- HTML semantic: `<div role="list">` + `<span role="listitem">` (slide-rules.md proíbe `<ul>/<ol>` em slides projetados; ARIA preserva accessibility).

### Phase 3 — Visual evolution shared-v2 SOTA

- **Layout overflow fix:** `.slide-inner` scoped grid `auto 1fr auto auto` + `block-size: 100%` + `max-block-size: 100%` + `overflow: hidden`. `.term-grid` removido `flex: 1`, adicionado `align-content: start`. Dissoc 52% sempre visível no rodapé.
- **Glassmorphism cards:** `.term-card` background `color-mix(in oklch, var(--v2-surface-panel) 88%, transparent)` + `backdrop-filter: blur(12px) saturate(120%)` (com `-webkit-`) + hairline `border-inline/block-end: 1px color-mix(--v2-border-hair 60%, transparent)` + 3-layer shadow stack (hairline + close + ambient).
- **`:has()` reactive lift:** `.term-card:has(.term-chip[style*="opacity: 1"])` adiciona elevação +translateY -1px quando chip ativo (modern shared-v2 pattern, substitui MutationObserver pré-2022).
- **Chip stretching fix:** `.term-checklist` `align-items/content/self: start` + `block-size: fit-content`. `.term-chip` `height: fit-content` + `block-size: fit-content`.
- **Label contraste:** `.term-label` `var(--v2-text-muted)` (60%) → `var(--v2-text-body)` (52%) + font-weight 600 → 700 (legível em projetor 10m).
- **Tipografia confirmada:** `.term-name`/`.term-stat` usam `var(--font-display)` (Instrument Serif via base.css:104); `.term-content`/`.term-stat-claim`/`.term-stat-source` usam `var(--font-body)` (DM Sans via base.css:105). Sem Edit necessário.

### Phase 4 — Motion shared-v2

- **`slide-registry.js`** s-quality function rewrite: 5-beat agrupado.
  - Beat 0 (auto): h2 + 3 cards juntos (`stagger: 0.1`, `power2.out`, duration 0.6).
  - Beat 1 (click): 3 perguntas cross-cards + chips card 1 (PROSPERO/A priori/PRISMA/Transparência) com `stagger: 0.1` nativo GSAP.
  - Beats 2-4 (clicks): card 1 Ferramenta (AMSTAR-2/ROBIS) → card 2 (RoB 1/2/ROBUST/ROBINS) → card 3 (GRADE).
  - Beat 5 (click): dissociation panel (52% Alvarenga).
- **Easing `power3.out` → `power2.out`** em 6 lugares (cascata mais suave, menos bouncy).
- **Stagger nativo GSAP** (substituiu manual `delay: idx * 0.07` em forEach).

### Verificacao

`npm run lint:slides` PASS · `npm run build:metanalise` PASS (17 slides) · `bash scripts/validate-css.sh` PASS.

### Aprendizados (S262, 5 li)

- **Glassmorphism real precisa 3 ingredientes simultâneos:** background semi-transparent (`color-mix 88%`) + `backdrop-filter blur+saturate` + hairline border `color-mix 60%`. Sem os 3 vira só "card branco com sombra". `-webkit-backdrop-filter` ainda necessário em 2026 (Safari iOS).
- **Subgrid revertido (talvez prematuro):** S262 first attempt usou `grid-template-rows: subgrid` em term-card. Estado final prefere `auto auto auto` + `align-content: start` no parent. KBP candidate "subgrid quando rows variam (height tracking), auto-rows quando rows estáveis (content-sized)".
- **Chip stretching = grid-row 1fr + flex item default stretch:** combinação faz chip parents esticarem verticalmente. Fix layered: `align-self: start` + `height: fit-content` + `align-content: flex-start` — defensive layers robust.
- **Lucas direção iterativa:** turn 1 "5 dimensões" → turn N "calma um slide" → turn N+M "polimento hiper-detalhado". Anti-drift §Momentum brake honored em cada turn. Iteração rápida com vite hot reload + screenshots Lucas.
- **CSS/JS moderno gradual (strangler fig) > big-bang:** subgrid → revertido; `:has()` → aceito; color-mix → adotado; backdrop-filter → adotado; logical properties → adotado. Pattern: introduce 1 modern feature por phase, validate visual, keep ou revert.

---

## Sessao 261 — 2026-04-26 (multi-arm research migration bridge — Codex xhigh + .mjs hardening)

> Lucas frame: "vamos incorporar o chatgpt5.5 xhigh em nosso braco de pesquisa e vamos migraar o mjs de pesquisa fragil mas eficiente, para agents subagents e skill, nao ha espaco para erro, nao ha workaorund" → "harden in place para depois migrar todo para sistema de skills agents e subagntes" → "migrar mas sem apagar depois faremos um run lado a lado para ver qual sistema esta melhor" → "tire de todo lugar que eu sou cardio/gastro/hepato" → "be terse a menos que eu indique"

### Phase B — codex-xhigh-researcher hardened + JSON Schema

- **`d8b12c1` feat(S261): codex hardened com --output-schema** `[+484/-23, 3 files]` — NEW `.claude/schemas/research-perna-output.json` (additionalProperties:false + PMID regex `^[0-9]+$`); Phase 3 cmd + Phase 4 parse + Hard constraints PMID spot-check ≥2 (era ≥1).

### Phase C — Perna 7 wirada em /research SKILL.md

- **`cc451c1` feat(S261): Perna 7 wirada** `[+22/-7, 1 file]` — frontmatter (7 pernas), Step 2 dispatch table row 7, Step 2.5 JSON branch, Step 3.c hierarquia (cross-family peer abaixo MCPs), ENFORCEMENT primacy + recency (Codex CLI subagent na ferramenta list, KBP-08 preserved).

### Phase D — gemini + perplexity .mjs hardened in-place (11 fixes line-cited)

- **`1a116f6` feat(S261): .mjs 11 fixes** `[+145/-44, 2 files]` — gemini D.1-D.5 (res.ok guard, AbortSignal 60s, data.error inspection, MAX_TOKENS exit 4, prompt length pre-check vs thinkingBudget), perplexity D.6-D.11 (res.ok guard, AbortSignal 120s, temp 0.8→0.2, --domain-context flag aditivo, silent fallback removed = exit 5, data.error). Smoke validados: invalid keys → exit 3 + structured stderr JSON (era exit 2 misleading + stdout dump).

### Phase E — POC validation Perna 7 (lightweight, 1 question)

- **POC PASS:** HRS-AKI prevalence question, 5 findings produced, **5/5 PMIDs verified via NCBI E-utilities (100%, fab rate 0%)**, latency 3m08s, custo ~$0 (Max sub). Perna 7 atinge ADOPT-NOW threshold (fab≤10% AND conv≥60% met).
- **Empirical finding:** `--model gpt-5.5` flag failed com ChatGPT account type (codex CLI exit 1). Fix applied: removed `--model` from agent spec, deixa `~/.codex/config.toml` default aplicar (gpt-5.5 + xhigh já configurados lá).

### Phase F — Documentation + S262 handoff + cleanup directives

- **`<sha>` docs(S261): Phase F + cleanup** — HANDOFF S261 close + S262 forward; CHANGELOG §S261; KBP-44 (Source-tags PMID, S260 candidate formalized) + KBP-45 (Wholesale migrate frágil); KBP-44/45 prose-fix (KBP-16 self-violation cleanup); anti-drift §Tone (terse default global); VALUES.md L12+L63 specialty neutralized; perplexity comment example generalized; S262 plan with side-by-side methodology + research-triangulator + Living HTML capability scope; codex-xhigh-researcher.md `--model` flag removed.

### Aprendizados S261 (5 li)

- **POC > prediction (V3 humildade epistêmica reinforced):** Lucas previu "perna 7 provavelmente falhou" — POC empírico PROVOU ADOPT-NOW (5/5 PMIDs verified). Cross-family Anthropic+Codex realiza anti-shared-hallucination signal real, não só teórico (Aider 85% pass + tianpan structured outputs Oct 2025 confirmados).
- **Bridge > wholesale migrate (KBP-45 formalized):** hardening in-place primeiro torna failures visíveis (exit codes structured stderr) — vira spec correto pra agents nativos S262. Wholesale migrate código frágil arrasta bugs silenciosos pra arquitetura nova.
- **Schema enforcement at API boundary:** `--output-schema` Codex flag reduz fab rate de markdown-parse 2-3% para ~0% (POC: 5/5 verified inline pelo modelo via web search self-check). Substitui parsing layer fragile.
- **`--model` flag override conflicts com ChatGPT account type:** deixar `~/.codex/config.toml` default aplicar evita auth mismatch. POC empirically catched (subagent first attempt failed exit 1, second attempt sem `--model` flag PASS).
- **Specialty cleanup + tone propagation deferred S262 (KBP-31 enforced):** Lucas turn-tail "tire de todo lugar" + "be terse em todos agents" — VALUES.md L12+L63 + anti-drift.md §Tone done; immutable-gliding-galaxy.md (~8 edits) + 16 agents per-agent tone deferred to S262 dedicated cleanup phase via S262 plan §S261 carryover.

---

---

Sessoes anteriores (7b–260): `docs/CHANGELOG-archive.md`
