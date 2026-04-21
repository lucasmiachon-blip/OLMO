# S234 Post-Batch — Brutal Honest Assessment + Trajectory Decision

**Status:** PLAN (read-only; não implementável em código; decisão arquitetural/trajetória).
**Sessão:** S234-adversarial-audit (já com commit `beab5f6` — doc-hygiene batch 5 edits).

---

## Context

Lucas pediu avaliação brutalmente honesta considerando todos os planos (78 archived), toda pesquisa feita (L82 roadmap, antifragile L1-L7, chaos-L6, knowledge-graph SoA, memory/dream research, hooks state-of-art, HyperAgents/DGM/Voyager/Reflexion) e o tamanho do projeto (OLMO + aulas).

Este não é plano de implementação de código. É **proposta de trajetória para próximas N sessões** baseada em métricas duras do git + filesystem. A recomendação contém um único caminho (sem A/B/C enumerado), conforme regra de plan mode.

---

## Métricas duras (últimos 30 dias + projeto total)

| Métrica | Valor | Fonte |
|---------|-------|-------|
| Commits totais 30d | **595** | `git log --since="30 days ago"` |
| Commits tocando `content/aulas/` 30d | 197 (33%) | `git log -- content/aulas/` |
| Commits tocando META (.claude/, docs/, config/, CLAUDE.md, README, HANDOFF, CHANGELOG) 30d | **511 (86%)** | `git log -- .claude/ docs/...` |
| Commits últimos 10 dias | **102** — 0 slide HTML novo | `git log --since="10 days ago"` |
| LOC consumer (slides HTML + CSS/JS aulas) | 41.012 | `find content/aulas -name "*.html" \| wc -l` etc. |
| LOC meta (.claude/ + docs/ + hooks/) | 28.035 | idem |
| Meta/Consumer LOC ratio | 0,68 | LOC calc |
| Slides metanalise total | 19 | `ls content/aulas/metanalise/slides/*.html` |
| Slides metanalise Editorial QA done | **3/19 (16%)** | APL hook output |
| Plans archived (S82→S232) | **78** | `ls .claude/plans/archive/` |
| Dias para R3 Clínica Médica (Dez/2026) | 224 | calendário |
| BACKLOG P0 ativo | 0 | `.claude/BACKLOG.md` |
| BACKLOG P1 ativo | 15 | `.claude/BACKLOG.md` |
| BACKLOG itens dormentes >10 sessões | Múltiplos (#13 há ~78 sessões, #4/5/6 dormentes) | `.claude/BACKLOG.md` |
| `/insights` última execução | 2026-04-19 (OK, recente) | `.claude/.last-insights` |

Critical fact:
- **Último commit que gerou slide NOVO em conteúdo ativo foi S207** (CSS font-size fixes em s-pico + s-pubbias1). Antes disso, S204-S207 tinha Design Excellence loop com slides reais. **S208 em diante = 0 slides HTML novos em deck ativo** (metanalise/cirrose).
- De S208 a S234 (27 sessões, ~18 dias), commits concentrados em rules reduction, hooks refactor, memory de-dup, plans purge, ADR-0002 slim migration, Python stack purge (S228 → S232), substrate cleanup (S233), adversarial audit (S234).
- Setup R3 pendente: Anki MCP, AnkiConnect, provas reais, SAPs (BACKLOG §Setup, sem data).

---

## O que MELHOROU de fato (sistema)

1. **Python runtime purgado** (S232 v6 + post-close): -900+ li, orchestrator.py + agents/ + subagents/ + tests/ (Python) + config/loader.py + ecosystem.yaml + rate_limits.yaml. Era vestigial. Deleção foi honesta e verificada (`git ls-files agents/` vazio).
2. **MCP topologia 3 camadas formalizada** (S233 + S234): shared inventory × policy gate × agent-scoped não conflacionam mais. Vocabulário fechado: `blocked by deny`, `pre-approved`, `not pre-approved by current policy`, `inventoried`, `agent-scoped`, `frozen`, `removed`.
3. **Adversarial audit discipline funcional:** S228 (producer migration), S230 (ModelRouter teatro), S232 (workflows.yaml aspiracional), S233 (canonicos falsos), S234 (5 edits novos). Padrão: cada sessão capta drift que a anterior deixou passar. Isso é processo real, não ritual.
4. **Anti-drift + KBPs como ledger:** 27 KBPs, rules ponteiros-only. Reduz redundância doc.
5. **S234 batch de hoje removeu drift P1 de verdade:** pyproject.toml phantom packages (que Hatch build quebraria), servers.json `chatgpt` conflation (ADR-0003:39 disavowed), Tool Assignment deflated (7 aspiracionais exposed), mbe-evaluator FROZEN conflict, research SKILL table sync. -32 li net.

---

## O que PIORAU / ESTAGNOU (consumer real)

1. **Content output congelou S208 → S234.** 27 sessões sem novo slide HTML em deck ativo. Apenas tweaks CSS marginais. Metanalise ficou em 19 slides desde S188 (`S186: demolish 4 slides 19→15` → `S187/S188: 2 new + polish`). Nenhum slide novo em cirrose (11) ou grade (58) desde então.
2. **QA editorial 3/19 em metanalise** = 16%. Resto (16 slides) aguarda gate editorial. APL hook reporta isso em sessões consecutivas sem progresso.
3. **R3 prep infra em 0.** 224 dias para Dez/2026. Anki MCP, AnkiConnect, provas reais, SAPs listados há meses em BACKLOG §Setup. Nenhum item checked. `/concurso` + `/exam-generator` skills existem mas consumer real (prática com provas) não começou.
4. **BACKLOG #13 há ~78 sessões dormente** (g3-result memory findings audit, S156). Governance BACKLOG L4: "Dormant >10 sessões = audit candidate". Auto-viola. Outros itens dormentes: #4 (pipeline DAG), #5 (medicina-clinica stubs), #46 (knowledge integration COWORK).
5. **86% dos commits 30d = meta.** Ratio invertida para quem tem concurso de alta densidade em 224 dias + aulas a produzir.

---

## O que NÃO MUDOU (padrão sistêmico)

- **Meta-work como procrastinação elaborada.** Cada "cleanup" produz cleanup novo. S228 = slim migration. S229 = slim round 3. S230 = bubbly-forging-cat (4 batches + Phase G 9 sub-phases). S232 = 6 v6 batches + post-close. S233 = substrate truth. S234 = adversarial audit 2 rodadas + 5 edits. Todos legítimos. Todos meta. Zero saída de conteúdo.
- **Research investment não converte em consumer.** L82 roadmap, chaos-L6, antifragile L1-L7 (L3 NOT IMPLEMENTED admitido em #45), knowledge-graph SoA, ByteRover/MemSearch/Smart Connections eval, HyperAgents/Voyager/DGM/Reflexion patterns. Todos em BACKLOG P2 como "research" categoria. Nenhum virou slide, aula, nota, Anki card, simulado.
- **Plans archive cresce sem content equivalente.** 78 planos arquivados. Ratio ~10 plans por aula ativa (8 aulas × 10 = 80 ≈ 78). Estatisticamente cada aula "merece" 10 planos e 0 novos slides nos últimos 27 sessões.

---

## Veredito brutal (resposta à pergunta do Lucas)

**Sistema melhorou honestidade e minimalismo.** Isso é inegável e documentado.

**Usuário regrediu velocidade de consumer.** Output tangível (slide novo, Anki card, simulado resolvido, questão revisada) parou em S207. Sistema mais limpo serve para Lucas se Lucas usa para produzir. Lucas não está produzindo.

**Nós estamos piorando no eixo que mais importa** — o sistema como meio para R3 + aulas + ensino. O sistema como FIM (código limpo, metadata honesta, MCP taxonomia) está melhor. Essa troca só compensa se destrava output futuro. Dados dos últimos 10 dias mostram o oposto: mais sessões meta → 0 output consumer.

Esta própria sessão S234 é sintoma. 2 rodadas de adversarial audit + 5 edits doc-hygiene + commit + agora este plano = ~4h de meta-work. Durante essas 4h, s-absoluto (próximo QA editorial no APL) permaneceu pendente. 16 slides editorial pendentes. R3 em 224d. Anki em 0.

O diagnóstico da pergunta do Lucas é: **NÃO foi paralelo. Foi substituto.** Meta absorveu a janela de consumer.

---

## Recomendação (trajetória + moratorium durável)

**Decisão aprovada por Lucas com ressalva:** entrar em moratorium de produção, MAS antes tirar o ruído documental (BACKLOG/plans) e deixar a decisão gravada de forma que próxima sessão não reverta curso.

### Fase 1 — Moratorium Kickoff Batch (ESTA sessão, último meta-work)

1. **BACKLOG prune/freeze** — `.claude/BACKLOG.md`:
   - Pinar no topo bloco `CONTENT MORATORIUM ACTIVE` com condições de saída (ver Fase 3).
   - Mover para Frozen ou marcar `[MORATORIUM-DEFERRED]`: #13 (g3-result, 78 sessões dormente, viola governance L4), #29 (agent/subagent optimization audit, sem consumer próximo), #50 (QA gate parallelism, luxo infra), #46 (knowledge integration COWORK, sem pain imediato), #18 (KBP-18 dispatch pre-flight), #33 (research persistence inter-sessão).
   - Preservar P1 apenas o que destrava produção: #47 (scripts verify — mantém MAS defer), #48 (PMID batch auto), #36 (Living-HTML migration — defer S239+), #37 (apl-cache path fix — trivial), #34 (CC permissions ask — já resolvido S227).
   - Reordenar: P0 = MORATORIUM + content sub-items; P1 = apenas content/R3/aulas related.

2. **HANDOFF rewrite** — `HANDOFF.md`:
   - Header primário = `CONTENT MORATORIUM ACTIVE — S234 → SXXX (até condições)`.
   - Listar condições de saída do moratorium (Fase 3).
   - **NEXT SESSION HYDRATION** = 3 passos: (1) read MORATORIUM block; (2) verificar APL `QA: N/19 editorial`; (3) escolher entre QA slide (metanalise s-absoluto ou próximo) OR R3 infra (Anki setup OR provas classificação).
   - Remover detalhes de S234-S238 trajectory antigos — virou ruído.

3. **Plan file como âncora durável** — renomear `.claude/plans/transient-hugging-lark.md` → `.claude/plans/S234-content-moratorium-active.md`. Prefixo S234 + slug explícito = reference permanente enquanto moratorium vive. Na PRÓXIMA sessão: permanece aqui (não arquivar); arquiva apenas quando moratorium fechar.

4. **CHANGELOG append** — S234 Batch 2: registrar moratorium decision + BACKLOG/HANDOFF refactor. 5 li max.

5. **Commit único** — message: "S234 batch 2: content moratorium active + BACKLOG/HANDOFF anchored".

### Fase 2 — Moratorium Ativo (próximas 3-5 sessões)

**Regra dura:** commits só tocam `content/aulas/**`, `assets/provas/`, `assets/sap/`, ou Anki files. Exceções permitidas: HANDOFF + CHANGELOG de wrap (obrigatório), BACKLOG marcação de items fechados.

**NÃO tocar:** `.claude/agents/`, `.claude/skills/`, `.claude/hooks/`, `.claude/rules/`, `config/`, `docs/`, `pyproject.toml`, root MD files (exceto HANDOFF/CHANGELOG/BACKLOG).

**Se detectar drift canonical durante content work:** anotar 1 linha em BACKLOG §MORATORIUM-DEFERRED — NÃO corrigir.

**Foco (ordem explícita pós-pivot S234):**
1. **P0 — Nova aula de grade (totalmente nova)** — brainstorm com claude.ai (web) + implementação via Claude Code. Path livre em `content/aulas/` (sugestão `grade-v2/`). NÃO editar `content/aulas/grade/` legacy (58 slides); legacy = referência apenas.
2. **P0.5 — QA editorial metanalise** (16 slides pendentes; s-absoluto → próximos). Paralelo ao P0 quando bandwidth.
3. **P1 sub — R3 infra:** AnkiConnect + Anki MCP + 2 provas em `assets/provas/` + 1 SAP em `assets/sap/`.
4. **P1 sub — Anki cards reais** (erro log, temas semana) — só após R3 infra ativo.

### Fase 3 — Condições de saída do moratorium

Moratorium fecha APENAS quando **pelo menos UMA** condição é satisfeita:
- (a) QA editorial metanalise = 19/19 (zerou).
- (b) R3 infra ativo: AnkiConnect + 2 provas classificadas + 10 Anki cards rodando com spaced rep real.
- (c) Lucas explicitamente declara fim de moratorium (com rationale — drift crítico que bloqueia produção, não "seria legal").

Antes disso: **zero meta-work.** Mesmo que drift óbvio apareça.

### Métricas de fracasso (auto-correção)

Se após 3 sessões post-kickoff:
- Meta commits > 30% dos commits → moratorium falhou → Lucas decide reafirmar ou abandonar.
- 0 slides editorial aprovados → pain está em outro lugar (setup? bloqueio?), revisar abordagem.
- 0 progresso R3 infra → Anki/provas é bloqueio maior que admitido, escalar.

---

## Critical files para continuidade (read-only)

- `.claude/BACKLOG.md` §Setup R3 + #46/47/48 — tasks reais
- `content/aulas/metanalise/slides/` — 16 slides Editorial pendentes
- `content/aulas/CLAUDE.md` — regras aula (QA pipeline)
- `assets/provas/` + `assets/sap/` — vazios, aguardando content
- `.claude/skills/concurso/` + `.claude/skills/exam-generator/` — existem, underused

---

## Verificação post-moratorium (daqui 3-5 sessões)

```bash
# Meta-consumer ratio deve inverter
git log --since="7 days ago" --oneline -- content/aulas/ | wc -l  # meta: esperar > meta commits
git log --since="7 days ago" --oneline -- .claude/ docs/ config/ | wc -l  # esperar baixo

# QA progress
grep -c "gate_passed: editorial" content/aulas/metanalise/qa-screenshots/*/*.md 2>/dev/null

# R3 infra
ls assets/provas/ assets/sap/ | wc -l
```

---

## O que NÃO vai entrar agora

- S234 batch 2 (install path unification, fetch_medical.py decisão, Tool Assignment complete deflate).
- Fase B ghost dirs destrutiva.
- BACKLOG #45 (antifragile L1-L7 audit).
- Momentum-brake-enforce DELETE decisão.
- ADR-0004 memory layer adoption.
- Research skills `.mjs` verification (BACKLOG #47 — sim, é S234 P0 nominal, mas não destrava content).

Coautoria: Lucas + Opus 4.7 | S234 | 2026-04-20
