# Plan: Dream Skill v2 — Melhorias em Micro-Passos

## Context

A dream skill atual (grandamenium/dream-skill, instalada em `~/.claude/skills/dream/`) funciona bem para consolidacao basica: 4 fases (Orient -> Gather Signal -> Consolidate -> Prune & Index), auto-trigger 24h via Stop hook, dedup, date normalization, contradiction flagging.

**Problema:** O OLMO esta no cap de 20/20 memory files, review overdue desde S105. A skill atual e ~70% autonoma e 30% human-in-the-loop, mas tem gaps que reduzem a qualidade da consolidacao.

**Abordagem:** Micro-passos — 1 melhoria por vez, testar, aprovar, next.

---

## Arquivo alvo

`C:\Users\lucas\.claude\skills\dream\SKILL.md` (284 linhas)

---

## Micro-passos (ordem por impacto/simplicidade)

### Step 1: Evergreen Fact Whitelist
**Onde:** Phase 4 (Prune & Index), secao "Check temporal metadata (TTL)"
**O que:** Adicionar classificacao `type: evergreen | seasonal | temporary` ao frontmatter de memory files. Entries evergreen (valores, decisoes arquiteturais) ignoram a heuristica "no recent references = stale". Entries temporary auto-flagged para archive apos 90 dias sem refresh.
**Por que:** Previne false-positive de staleness. Hoje `project_values.md` (permanente) e tratado igual a `project_metanalise.md` (contextual). Simples, baixo risco.
**Linhas afetadas:** ~220-227 do SKILL.md

### Step 2: Audit Trail com Session ID
**Onde:** Phase 3 (Consolidate), secao "Entry format"
**O que:** Expandir formato de `(source: session, confidence: high)` para `(source: S108 2026-04-07, confidence: high, explicit: true)`. Adicionar flag `explicit` (user disse diretamente) vs `inferred` (agente deduziu).
**Por que:** Permite rastrear reversoes ("eu nunca disse isso"). Hoje nao ha como verificar. Baixa complexidade — so muda o template.
**Linhas afetadas:** ~166-172 do SKILL.md

### Step 3: Repetition Detector
**Onde:** Phase 2 (Gather Signal), nova subsecao apos "What to extract"
**O que:** Apos grep dos patterns, contar quantas vezes o mesmo fato aparece em sessoes diferentes. Se count >= 3 em janela de 7 dias, flaggar: "User repete X — possivel falha de memoria (entry nao stuck)". Se memory ja contem o fato, atualizar `last_challenged`.
**Por que:** Detecta memorias que nao estao funcionando. Alto impacto, baixa complexidade.
**Linhas afetadas:** Nova secao entre ~140-145 do SKILL.md

### Step 4: Confidence-Weighted Merge
**Onde:** Phase 3 (Consolidate), secao "Rules"
**O que:** Adicionar heuristicas de merge baseadas em confidence:
- `high` explicito + `medium` inferido conflitantes -> aceitar explicito
- Ambos `high` conflitantes -> flag para Lucas (contradicao genuina)
- Source authority tiers: T1 (correcao explicita) > T2 (preferencia) > T3 (pattern 3+ sessoes) > T4 (inferencia unica)
**Por que:** Resolve ambiguidade na resolucao de contradicoes. Hoje e binario (old vs new). Media complexidade.
**Linhas afetadas:** ~150-165 do SKILL.md

### Step 5: TTL Auto-Downgrade (opcional, apos validar 1-4)
**Onde:** Phase 4 (Prune & Index), secao TTL
**O que:** Se `review_by` expirado + `confidence: medium` + `last_challenged > 90 dias` -> auto-downgrade para `low` + set novo review_by 60 dias. Se `low` + expirado -> archive (nunca delete silencioso).
**Por que:** Previne entries stale com confidence inflada. Media complexidade.
**Linhas afetadas:** ~220-227 do SKILL.md

---

## Verificacao (apos cada step)

1. Ler SKILL.md completo e confirmar que as 4 fases permanecem coerentes
2. Rodar `/dream` manualmente em dry-run e verificar que o novo comportamento aparece
3. Confirmar que nenhuma memory file foi corrompida

---

## NAO FAZER
- Alterar o auto-trigger (should-dream.sh funciona bem)
- Mudar a estrutura de 4 fases (validada, funcional)
- Implementar fuzzy dedup (complexidade alta, beneficio incerto)
- Implementar cross-project memory (futuro, requer redesign)
