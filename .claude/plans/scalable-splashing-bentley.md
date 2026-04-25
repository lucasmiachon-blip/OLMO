# S248 — infra3 + agents

> **Plan file** | Sessão S248 | 2026-04-25 | Coautoria: Lucas + Opus 4.7
> **Codex benchmark overlay (2026-04-25):** ver `docs/research/external-benchmark-execution-plan-S248.md`. Mantem "infra primeiro", mas gateia "agents depois": Debug Team phases 2-5 (#60) so devem avancar apos B1-B3 (CI truth, hook containment, content pipeline truth), salvo override explicito de Lucas. Racional: benchmarks externos favorecem small CLs, subagents focados, hooks testados e CI verdadeiro antes de ampliar meta-tooling.

---

## Context

S247 deixou duas frentes pendentes formando o nome desta sessão:

- **infra3** — 3 schema bugs em hooks (BACKLOG #57-59 P1) causando ruído recorrente "No stderr output" e fail-closed silencioso. Specs literais documentados; patches são pequenos (5 linhas total) mas tocam arquivo guardado pelo próprio guard-write-unified.sh, exigindo deploy KBP-19 (Write→temp→cp).
- **agents** — Debug Team Phases 2-5 (BACKLOG #60). Phase 1 (`debug-symptom-collector.md`) shipou em S247 com schema JSON 12-field e exemplo do bug #191 como âncora. Agora completar a pipeline: archaeologist → adversarial → patch-architect+editor+validator → orchestrator skill.

Resultado esperado ao fim da sessão: hooks limpos (sem ruído), 5 agents + 1 skill commitados, restart pronto para validação `/debug-team` em próxima sessão.

---

## Ordem aprovada

**Infra primeiro, agents depois.** Razões:

1. ~30min vs 3h — momentum. Quick win commitado primeiro = checkpoint limpo se sessão ficar curta.
2. Schema fixes mecânicos. Agents work é criativo + design-heavy, merece contexto fresco.
3. Ambos requerem restart para validar (CC não hot-reload nem hooks nem agents). Commit conjunto = 1 restart total.

**Sequência interna Frente 1:** simplest first → mais complexo (#58 jq inline → #57 heredoc → #59 arquivo protegido com 3 fixes).
**Sequência interna Frente 2:** segue ordem #60 literal (Phase 2 → 3 → 4 → 5).

---

## Frente 1 — Infra (3 schema bugs)

### F1.1 — #58 `hooks/post-compact-reread.sh:17`

**Atual:**
```bash
jq -cn --arg msg "$MSG" '{hookSpecificOutput:{message:$msg}}'
```
**Fix:**
```bash
jq -cn --arg msg "$MSG" '{systemMessage:$msg}'
```

**Schema:** PostCompact aceita apenas top-level `systemMessage|continue|stopReason|suppressOutput`. `hookSpecificOutput` ignorado.

**Deploy:** Write→`.claude-tmp/post-compact-reread.sh.new`→`cp` (conservador; assumindo `hooks/*.sh` também guardado — verificar guard-write-unified.sh patterns no início).

---

### F1.2 — #57 `hooks/post-tool-use-failure.sh:38-39`

**Atual:**
```bash
cat <<EOF
{"hookSpecificOutput":{"systemMessage":"Tool '$TOOL_NAME' failed: $SAFE_ERROR. Read the complete error, diagnose root cause before retrying. Do not retry the same command blindly."}}
EOF
```
**Fix:**
```bash
cat <<EOF
{"additionalContext":"Tool '$TOOL_NAME' failed: $SAFE_ERROR. Read the complete error, diagnose root cause before retrying. Do not retry the same command blindly."}
EOF
```

**Decisão D1:** `additionalContext` (informacional, encaixa em failure context) ao invés de `decision`+`reason` (semântica de gating, não aplicável).

**Deploy:** mesmo padrão F1.1.

---

### F1.3 — #59 `.claude/hooks/guard-write-unified.sh:31,42,122` (arquivo PROTEGIDO)

3 substituições. Todas `printf '{"error": "..."}'` → schema PreToolUse fail-closed.

**L31 (parse error):**
```bash
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"BLOQUEADO: guard-write-unified falhou ao parsear input (fail-closed)"}}\n'
```

**L42 (Guard 1 index.html):**
```bash
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"BLOQUEADO: index.html e gerado por npm run build:{aula}. Editar slides/*.html ou index.template.html, depois rodar build."}}\n'
```

**L122 (Guard 3 hook scripts):**
```bash
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"BLOQUEADO: %s e hook de seguranca. Deploy via Write→temp→cp (guard-bash-write pede aprovacao)."}}\n' "$BASENAME"
```

**Decisão D2:** L31 reason é literal "guard-write-unified falhou ao parsear input (fail-closed)" — texto auto-explicativo sem nome de arquivo (não disponível nesse branch).

**Deploy obrigatório KBP-19:**
1. Read full guard-write-unified.sh (precisão whitespace KBP-25 — printf usa quoting fragil)
2. Write `.claude-tmp/guard-write-unified.sh.new` (versão completa com 3 fixes)
3. `cp .claude-tmp/guard-write-unified.sh.new .claude/hooks/guard-write-unified.sh` (Bash pede aprovação Lucas)
4. Verify: `head -50 .claude/hooks/guard-write-unified.sh` mostra L31 + L42 atualizadas

**Verificação Frente 1:** Após cp, próximo Edit em arquivo protegido deve retornar JSON novo schema (testar com Bash trigger de guard-write fail-closed). Sem ruído "No stderr output" em PostToolUseFailure após próxima falha de tool.

---

## Frente 2 — Agents (Debug Team — tribunal 3 paralelos + juiz Opus)

### Topologia revisada (S248 Lucas adjustment 2026-04-25)

```
Phase 1: collector (Sonnet) — DONE S247
   ↓
Phase 2 PARALELO (3 visões independentes, todas plano máximo):
   ├── archaeologist (Gemini 3.1 Pro max) — historical/git/issues
   ├── adversarial (Codex max) — challenge/alternativas/frame blindspots
   └── strategist (Opus 4.7 max) — first-principles, sem viés histórico/adversarial
   ↓
Phase 3: synthesizer (Opus 4.7 max) — recebe 3 outputs + collector
         organiza, prioriza, determina patch arquitetura
   ↓
Phase 4: patch-editor (Codex Aider-style) — aplica
   ↓
Phase 5: validator (Sonnet + Bash) — testa
```

**Por que 3 paralelos > 2 paralelos + sequencial:** adversarial era sequencial-pós-archaeologist no plano original — só podia atacar a frame que archaeologist trouxe. Em paralelo, cada visão ataca o symptom diretamente, sem contaminação de hipóteses prévias.

**Por que Opus duas vezes:** Opus paralelo é "voz" (peer perspective first-principles); Opus synthesizer é "juiz" (consolida 4 inputs e decide). Mesmo modelo, papéis cognitivos distintos.

**Por que Gemini para archaeologist:** 1M context window decisivo para ler git log completo + CHANGELOG inteiro + issues relacionadas (Opus/Codex sobrecarregam).

### Padrão template (replicar de `debug-symptom-collector.md`)

Frontmatter YAML + ENFORCEMENT header + Output Schema (JSON canônico) + Fases numeradas + Failure Modes (tabela) + Example (caso #191 como âncora) + Constraints (KBP refs) + ENFORCEMENT footer.

### Decisão D3 — External-API agents (CRÍTICA)

CC nativo aceita `model: sonnet|opus|haiku`. Para agents que delegam a Gemini/Codex:

- **Wrapper Claude + Bash tool** chamando gemini CLI ou codex CLI internamente. Agent recebe input estruturado, monta prompt, dispara Bash (`gemini -m gemini-3-1-pro -p "$prompt"` ou `codex exec ...`), parsea output, retorna schema JSON.
- **Modelo wrapper escolhido:** `sonnet` para Gemini/Codex agents (não haiku) — wrapper precisa raciocinar sobre prompt construction + parsing + schema validation; haiku pode under-perform em I/O complexo. Custo wrapper baixo vs. valor da chamada externa max plan justifica sonnet.
- Justificativa global: mantém schema-first discipline (Phase 1 pattern), aproveita modelos especializados sem tentar mapear `model: gemini` (não suportado).

### Decisão D4 — Tool permissions por agent (revisado)

| Agent | model | brain | allowedTools | disallowedTools | Read-only? |
|-------|-------|-------|--------------|-----------------|------------|
| debug-archaeologist | sonnet | Gemini 3.1 Pro max (via Bash) | Bash, Read, Grep, Glob | Write, Edit, Agent | sim |
| debug-adversarial | sonnet | Codex max (via Bash) | Bash, Read, Grep, Glob | Write, Edit, Agent | sim |
| debug-strategist | opus | Opus 4.7 max (nativo) | Read, Grep, Glob | Write, Edit, Bash, Agent | sim |
| debug-synthesizer | opus | Opus 4.7 max (nativo) | Read, Grep, Glob | Write, Edit, Bash, Agent | sim |
| debug-patch-editor | sonnet | Codex max (via Bash) + nativo | Bash, Read, Edit, Write | Agent | NÃO (escreve patches) |
| debug-validator | sonnet | Sonnet (nativo) + Bash testes | Bash, Read, Grep | Write, Edit, Agent | sim |

### F2.1 — Phase 2 PARALELO: `debug-archaeologist.md` (Gemini)

**Modelo wrapper:** sonnet. **Externo:** Gemini 3.1 Pro max plan (via Bash + gemini CLI).
**Input:** symptom-collector JSON.
**Output schema:** archaeology-report.json — `git_blame_relevant_commits[]`, `historical_pattern_matches[]`, `prior_fixes_attempted[]`, `related_issues_external[]`, `architectural_context`, `confidence`, `gaps`.
**Fases:** Ingest collector → Mine git history (`git log -S`, `git blame`, full CHANGELOG read) → Cross-ref HANDOFF + KBP + cc-gotchas → Construct Gemini prompt (max plan, full context) → Bash gemini call → Parse → Structure → Report.
**Diferenciador:** longo contexto Gemini decisivo — pode ler 50k+ tokens de git log de uma vez sem stream.
**Example âncora:** bug #191 — git_blame em codex plugin manifest (versionar) + busca histórica de hooks stdin issues.

### F2.2 — Phase 2 PARALELO: `debug-adversarial.md` (Codex)

**Modelo wrapper:** sonnet. **Externo:** Codex max plan (via Bash + `codex exec`).
**Input:** collector JSON (NÃO recebe archaeologist — paralelo independente).
**Output schema:** adversarial-report.json — `assumption_challenges[]`, `alternative_root_causes[]`, `frame_blindspots[]`, `confidence_per_challenge`, `failure_mode_categories_unexamined[]`.
**Fases:** Ingest collector → Frame extraction (lista assumptions implícitas no symptom report) → KBP-28 checklist (tipos comando se security) → Construct Codex adversarial prompt → Bash codex call → Parse → Structure → Report.
**Diferenciador:** Codex max é treinado em adversarial code review; trazer pra debug é approach novel mas alinhado.
**Example âncora:** bug #191 — challenge: "é stdin block ou race stopReviewGate? é Windows-specific ou cross-platform com prevalência diff? timeout 900ms é apertado independente de stdin?".

### F2.3 — Phase 2 PARALELO: `debug-strategist.md` (Opus first-principles)

**Modelo:** opus 4.7 max (nativo CC). **READ-ONLY — sem Bash externo.**
**Input:** collector JSON (igual aos outros 2 paralelos — independência garantida).
**Output schema:** strategist-report.json — `first_principles_decomposition` (problem → atomic claims), `proposed_root_cause_hypotheses[]` (ranked by likelihood), `architectural_lens_view`, `confidence`, `gaps`.
**Fases:** Ingest collector → Problem decomposition (atomic) → First-principles reasoning (sem buscar precedente) → Hypothesis ranking → Architectural lens → Report.
**Diferenciador:** raciocínio puro. Não busca git history, não desafia frames externos — começa do symptom e raciocina forward. Captura insights que historical/adversarial podem perder por viés.
**Example âncora:** bug #191 — first-principles "stdin block antes de check stopReviewGate é design error fundamental, independente de Windows-specific ou não — feature flag deveria gate I/O, não pós-I/O".

### F2.4 — Phase 3 SYNTHESIZER: `debug-synthesizer.md` (Opus juiz)

**Modelo:** opus 4.7 max (nativo). **READ-ONLY.**
**Input:** collector JSON + 3 paralelos JSONs (archaeologist, adversarial, strategist).
**Output schema:** synthesis-report.json — `prioritized_root_causes[]` (com source attribution: archaeologist|adversarial|strategist|combined + confidence weight), `proposed_patch_architecture` (file, line, before, after, rationale), `risk_analysis`, `rollback_plan`, `kbp_references[]`, `pre_patch_validation_checklist[]`.
**Fases:**
1. **Ingest 4 inputs** (collector + 3 paralelos)
2. **Cross-validation** — quais root causes aparecem em ≥2 sources? quais são únicas? quais discordam?
3. **Prioritization** — pesar confidence por agent + alignment com collector evidence
4. **Decision** — escolher root cause primário + secundários
5. **Patch architecture** — design file-by-file
6. **Rollback plan** + KBP refs
7. **Report**

**Constraint:** synthesizer NUNCA escreve patch — apenas determina arquitetura. Patch-editor (Phase 4) executa.
**Por que Opus aqui (não Sonnet):** decisão multi-source com tradeoffs — exatamente onde Opus brilha. Custo justificável (1 invocation por bug).
**Example âncora:** bug #191 — synthesizer integra "intermittent Windows-specific" (archaeologist) + "timeout 900ms apertado independente" (adversarial) + "design error pré-flag check" (strategist) → conclui no-local-patch (KBP-35) + tracking upstream + bug correlato manifest timeout 5ms.

### F2.5 — Phase 4 EXECUTOR: `debug-patch-editor.md`

**Modelo wrapper:** sonnet. **Externo:** Codex max (Aider-style via `codex exec --edit` ou stdin patch).
**Input:** synthesis-report.json (apenas).
**Output:** arquivos editados (Edit/Write actual) + edit-log.json (files modified, line counts, diff summary).
**Fases:** Ingest synthesis → Per-file edit via Codex → Verify diff matches plan (sem drift) → Log → Report.
**ÚNICO agent que escreve.** Constraint forte: edita APENAS files listados em synthesis.proposed_patch_architecture. Drift = KBP-01 violation.
**Por que Codex Aider:** patch application é exatamente o caso de uso Aider — surgical edits seguindo plan especificado. Wrapper sonnet só orquestra.

### F2.6 — Phase 5 VALIDATOR: `debug-validator.md`

**Modelo:** sonnet (nativo). **Bash p/ testes.**
**Input:** edit-log.json + collector.reproduction (steps).
**Output schema:** validation-report.json — `reproduction_steps_pass[]`, `regression_checks[]`, `lint_status`, `test_status`, `verdict` (pass|fail|partial), `failures[]`.
**Fases:** Ingest → Run repro → Run lint (project-specific) → Spot-check regressão (related files) → Verdict → Report.
**Verdict semantics:** pass = repro fixed + no regressions + lint clean. partial = repro fixed mas lint/regressão warning. fail = repro ainda reproduz OU regressão hard.

### F2.7 — Phase 6 ORCHESTRATOR: `.claude/skills/debug-team/SKILL.md`

**Modelo skill operator:** Opus 4.7 (Anthropic supervisor pattern).
**Subdir confirmado:** `.claude/skills/debug-team/SKILL.md`.
**Workflow consolidado:**
1. Trigger: `/debug-team` ou contexto bug-shaped (error + repro pendente)
2. Spawn `debug-symptom-collector` (Phase 1) — STOP, await output
3. Persist collector JSON em `.claude/plans/<bug-slug>.md`
4. Spawn **3 paralelos em single message multi-Agent** (archaeologist + adversarial + strategist) — STOP, await all 3
5. Persist 3 outputs em mesmo plan file (sections paralelas)
6. Spawn `debug-synthesizer` com 4 inputs (collector + 3 paralelos)
7. Persist synthesis em plan file. **Confirm gate: Lucas valida synthesis antes de Phase 4.**
8. Spawn `debug-patch-editor` com synthesis. STOP, await edit-log.
9. Spawn `debug-validator` com edit-log + collector.reproduction. STOP, await verdict.
10. Final report: collector summary + 3 paralelos summary + synthesis decision + edit-log + verdict. Save plan file.

**Constraints:**
- KBP-17: orchestrator spawna APENAS os 6 agents listados. Nenhum agent extra.
- KBP-29: cada output persiste em plan file ANTES do próximo agent.
- Failure handling: qualquer agent retorna confidence "low" overall → pause + ask Lucas.
- Confirm gate Phase 3→4: synthesis review ANTES de write (custo de patch errado >> 30s validação).
- TaskCreate budget: 7 tasks (1 per phase + 1 final report).

---

## Frente 3 — Tail tasks (sessão close)

1. **Commit infra** após F1.3 deploy + verify (separado de agents — atomic commit por área).
2. **Commit agents** após F2.4 (todos os 6 arquivos juntos — entregável coeso).
3. **Update HANDOFF.md** — pendências S248 → S249 (validar `/debug-team` pós-restart, posting #191 upstream se Lucas autorizar).
4. **Update CHANGELOG.md** — sessão S248 entry, max 5 li per anti-drift §Session docs.
5. **#191 upstream comment** — Lucas valida + posta (não autônomo). Plan menciona apenas como pendência.

---

## Decisões assumidas (transparency)

- **D1** #57 → `additionalContext` (informacional, não-gating).
- **D2** #59 L31 reason → texto literal sem path (path indisponível no branch fail-closed).
- **D3** External-API agents → wrapper Claude (haiku) + Bash chamando CLI externo. Não tentar `model: gemini`.
- **D4** Patch-editor é único com Write/Edit. Validator tem Bash p/ testes. Outros read-only.
- **D5** Skill em subdir `.claude/skills/debug-team/SKILL.md`.
- **D6** Deploy KBP-19 (Write→`.claude-tmp/`→`cp`) para todos os 3 hooks de Frente 1 (conservador — verificar Guard 3 patterns na Read inicial).

---

## Critical files

**Frente 1 (3 edits):**
- `C:\Dev\Projetos\OLMO\hooks\post-compact-reread.sh` (L17)
- `C:\Dev\Projetos\OLMO\hooks\post-tool-use-failure.sh` (L38-39)
- `C:\Dev\Projetos\OLMO\.claude\hooks\guard-write-unified.sh` (L31, L42, L122)

**Frente 2 (6 new agents + 1 skill):**
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-archaeologist.md` (Phase 2 paralelo Gemini)
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-adversarial.md` (Phase 2 paralelo Codex)
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-strategist.md` (Phase 2 paralelo Opus first-principles) ⚡NOVO
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-synthesizer.md` (Phase 3 Opus juiz — renomeado de patch-architect)
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-patch-editor.md` (Phase 4 Codex Aider)
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-validator.md` (Phase 5 Sonnet)
- `C:\Dev\Projetos\OLMO\.claude\skills\debug-team\SKILL.md` (Phase 6 orchestrator, novo subdir)

**Reference template (read-only):**
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-symptom-collector.md` — Phase 1, replicar estrutura

**State files (touch ao fim):**
- `C:\Dev\Projetos\OLMO\HANDOFF.md`
- `C:\Dev\Projetos\OLMO\CHANGELOG.md`
- `C:\Dev\Projetos\OLMO\.claude\BACKLOG.md` (marcar #57-59 RESOLVED, #60 partially)

---

## Verification

**Frente 1:**
1. After F1.3 cp: `Read .claude/hooks/guard-write-unified.sh` → confirmar L31+L42+L122 com novo schema.
2. Trigger sintético: editar arquivo guard-write-unified protegido em outro path → guard deve retornar JSON `{hookSpecificOutput:{permissionDecision:"block",...}}` (não mais `{error:...}`).
3. Trigger sintético PostCompact: `/compact` em sessão de teste → CC mostra `systemMessage` (não silencioso).
4. Trigger sintético PostToolUseFailure: tool com erro propositado → CC mostra `additionalContext` injetado.

**Frente 2 (requer restart CC):**
1. Pós-restart: `/agents` lista 7 novos (`debug-{symptom-collector,archaeologist,adversarial,strategist,synthesizer,patch-editor,validator}`).
2. `/help` ou skill registry mostra `/debug-team`.
3. Dry-run em bug histórico (sugestão: caso #191 ou outro de cc-gotchas) — orchestrator dispara collector → 3 PARALELOS (archaeologist + adversarial + strategist) → synthesizer (Lucas confirm gate) → editor → validator. Sem commit, só dry-run.

**Frente 3:**
1. `git log --oneline -3` mostra 2 commits novos (infra + agents).
2. HANDOFF S248→S249 < 50 li.
3. CHANGELOG S248 ≤ 5 li (Aprendizados + residual verification).

---

## Risk / open items

- **R1:** Se `hooks/post-tool-use-failure.sh` ou `hooks/post-compact-reread.sh` NÃO forem guardados pelo guard-write-unified Guard 3 (BASENAME mismatch), Edit direto funciona sem KBP-19. Verificar na primeira leitura. Custo de assumir guarded e fazer KBP-19: trivial (~30s extra).
- **R2:** External CLI calls (gemini, codex) podem não estar PATH-ed nos agents — testar disponibilidade antes de finalizar Phase 2 spec. Se ausente, definir dependency em SKILL.md preflight.
- **R3:** Codex CLI Aider-style semantics para Editor agent — checar se `codex exec --edit <file>` é a sintaxe correta vs. inline patch via stdin. Conferir antes de F2.3b.
- **R4:** 3h estimativa Frente 2 pode subestimar por ser primeira vez gerando 5 agents + 1 skill seguindo padrão template. Monitorar — se 60% do tempo após Phase 3, parar e commit parcial.

---

## Não-escopo (explícito)

- Postar comentário upstream #191 (Lucas owns).
- Tier 3-5 documental antigo (Q1/Q2/Q3/Q4 carryover) — fica para sessão futura.
- Carryover S246 schema-level adoptions — separado de S248 escopo.
- BACKLOG triage geral — tocar só #57-#60 e marcar status.
