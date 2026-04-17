# HANDOFF - Proxima Sessao

> Sessao 222 | CONTEXT_ROT 3 — infra CODIFICADA (nao validada), context weight NAO caiu

## HONESTIDADE S222 (leia antes do START HERE)

S222 **codificou** deteccao (integrity.sh Stop[5] + PROJECT_ROOT hardened + settings tracked). NAO validou em ciclo real, e NAO reduziu bytes carregados por turno.

**Verificado em S222:**
- `bash -n hooks/*.sh` sintaxe OK (11/11) — sintatico, nao funcional
- `jq` parseia settings.json + settings.local.json merged — parse OK, nao load-by-harness
- `bash tools/integrity.sh` manual → 0 violations — manual, nao Stop automatico
- `ls .claude/.claude .claude/tmp` → ausentes AGORA (deletados +-15min antes do commit)

**NAO verificado (pressupostos, nao fatos):**
- Hooks funcionam com novo PROJECT_ROOT em session end real
- integrity.sh Stop[5] fires automatico (so vi manual run)
- Harness Claude Code merge settings.json+local corretamente
- Sanity check `basename == ".claude" && exit 1` triggera (nao testei)
- Orfaos nao voltam proxima sessao

**Primeiro passo obrigatorio S223:** validar o acima ANTES de declarar infra estavel.

**Offenders reais de context weight (nao atacados):**
1. Skill `superpowers:using-superpowers` auto-loaded full (~150 li YAML/prose todo session start)
2. MCP `SCite` instructions auto-loaded (~80 li de obrigacoes inline)
3. SessionStart hook 3-block output (APL + KPI + HANDOFF dump)
4. CLAUDE.md + rules/*.md auto-loaded (~200 li soma)
5. Skills list enumerado inteiro (deferido mas nomes visiveis)

**Offenders reais de context weight (nao atacados):**
1. Skill `superpowers:using-superpowers` auto-loaded full (~150 li YAML/prose todo session start)
2. MCP `SCite` instructions auto-loaded (~80 li de obrigacoes inline)
3. SessionStart hook 3-block output (APL + KPI + HANDOFF dump)
4. CLAUDE.md + rules/*.md auto-loaded (~200 li soma)
5. Skills list enumerado inteiro (deferido mas nomes visiveis)

## S223 START HERE — VALIDAR S222 antes de avancar

**Passo 0 — VALIDATION S222 (30 min, obrigatorio):**
1. Session-start: `ls .claude/.claude .claude/tmp` → confirmar ausentes. Se voltaram → classe de bug NAO foi eliminada.
2. `cat .claude/integrity-report.md` → verificar timestamp do report. Se igual a S222 manual, Stop[5] NAO firou.
3. Forcar sanity check: `CLAUDE_PROJECT_DIR=$(pwd)/.claude bash hooks/session-start.sh` → deve exit 1 com ERROR.
4. Logs harness: procurar invocacao dos hooks com novo PROJECT_ROOT em session end anterior.

**Se Passo 0 FAIL em qualquer item:** nao e "fix refinement", e "S222 foi teatro". Reabrir `buzzing-wondering-hickey.md`.

**Se Passo 0 PASS:** seguir tema "arrumar a casa" — Track A prioritario.

**S222 fim — disabled (medir impacto em S223 baseline):**
- Plugin `superpowers@claude-plugins-official` = false (perde ~150 li/start)
- MCP `claude.ai SCite` + `claude.ai PubMed` = disabled (case-fix: estava `Scite` vs real `SCite`). Perde ~80+ li de instructions/start.
- MANTIDO: `explanatory-output-style` (~15 li, valor didatico explicito)

**Track A (context weight — percepcao "pesado" prioridade):**
1. Medir: baseline honesto do `ctx_pct` em session-start zero-input.
2. Skill auto-load: `using-superpowers` pode ser flag-gated ou lazy?
3. MCP SCite instructions: 80-li obrigacoes → mover on-demand (so quando tool usada).
4. SessionStart output: HANDOFF head-50 pode cair pra 30.

**Track B (semantic truth-decay — correctness prioridade):**
1. INV-3 pointer resolution — expandir integrity.sh para parsear `→ pointer`. Ataca CLAUDE.md:63+73, KBP-06/15.
2. INV-4 count integrity — SCHEMA vs MEMORY vs `ls`. 1 funcao bash.
3. INV-1 md destino — frontmatter + whitelist.

**Recomendacao:** Passo 0 (sempre). Depois Track A (percepcao progresso) > Track B (correctness invisivel).

## ESTADO POS-S222

- Hooks: 31 registered, 31 valid. integrity.sh async Stop[5] (INV-2+5 PASS).
- Settings: `.claude/settings.json` TRACKED (413 li baseline). `settings.local.json` = `{}`.
- PROJECT_ROOT hardened 11 hooks (`${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}`).
- Memory: 20/20 at cap, 9 merges pendentes. Rules: 5. Plans: 10 ativos.
- Build: 17 slides PASS. Python 53 tests PASS, ruff clean.

## STOP HOOKS (6)

Stop[0] prompt → [1] agent (git diff) → [2] quality → [3] metrics async → [4] notify async → [5] integrity.sh async

## PENDENTES

### P0 — S223
- Track A ou B (Lucas decide)
- Memory 9 merges (review via /dream)

### Hooks resto (S221 diagnose, deferred)
- momentum-brake exempta Bash (policia nao policia)
- PostToolUseFailure registrado em evento inexistente
- `/tmp/cc-session-id.txt` compartilhado entre sessoes

### Carryover (sem prazo)
- Docling: `cd tools/docling && uv sync` + testar `pdf_to_obsidian.py`
- Slides: s-quality, s-tipos-ma, drive-package PDF/PNG
- Wallace CSS: 29 raw px, #162032 sem token, 20 !important
- Obsidian plugins (Templater, Dataview, Periodic Notes, Spaced Rep, obsidian-git)
- Codex backlog: 40 findings em `.claude/plans/S220-codex-adversarial-report.md`

## DECISOES ATIVAS (key — detalhes em memory/)

- S220 context melt: C1-C3 DONE. C4 DEFERRED.
- KBP-23 First-turn discipline. HANDOFF target 50 li.
- Gemini QA temp 1.0, topP 0.95. OKLCH obrigatorio.
- Living HTML = source of truth. Agent effort: max.
- Self-improvement PAUSADO (resume gate S218).
- KBP-22 Silent Execution (Stop[0] enforcement S219).
- Opus 4.7 teste principal.
- Docling venv separado (tools/docling/.venv).
- ctx_pct_max metrica (statusline + stop-metrics).
- **S222 aprendizado: deteccao ≠ reducao. Metricar weight antes de declarar vitoria.**

## ESCOPO PROXIMOS DIAS (Lucas S222 fim)

**Tema: "arrumar a casa".** Slides **FROZEN**. CSS **FROZEN**. Zero content work ate novo OK.
Foco exclusivo: infra (context weight, hooks resto, memory merges, validacao S222).

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`. h2 = trabalho do Lucas.
- NUNCA `ANTHROPIC_API_KEY` no env (bypassa Max).
- Agent research: persistir em plan file ANTES de reportar.
- Hook scripts: Write→tmp→python shutil.copy (guard blocks Edit+cp).
- "Funciona" sem metrica = achismo.
- Docling venv ~2GB (separado).

---
Coautoria: Lucas + Opus 4.7 | S222 2026-04-17
