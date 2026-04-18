# S226 — Purga Arquitetural Cowork↔OLMO (lado OLMO)

> Status: PROPOSED (plan mode) | 2026-04-17 | Session: Melhorias1.1 (repurposed → Purga)
> Origin: ADR-0001 enforcement. Cowork instance em paralelo limpa seu lado.
> Contract: `OLMO_COWORK\docs\adr\0001-bridge-via-inbox.md` — bridge unidirecional via `OLMO_COWORK\pipeline\output\`
> Plan-file rename pós-approval: `ACTIVE-S226-purga-cowork-plan.md`

---

## Context

S226 scope pivot: descartado Melhorias1.1 discipline plan. Nova missão = purga arquitetural.

**ADR-0001 (2026-04-17):** Cowork NUNCA escreve em `OLMO\`. Cowork produz em `OLMO_COWORK\pipeline\output\`. OLMO consome via `/digest-pull`, `/research-pull`. Exceção única: leitura read-only de `OLMO\HANDOFF.md`.

**Drift detectado:** 51 hits "cowork" em 13 arquivos OLMO. Cada ref (fora archive/changelog) = violação conceitual do ADR. O problema não é o texto — é que sua existência normalizou acoplamento.

**Paralelismo:** Cowork instance limpa `OLMO_COWORK\CLAUDE.md`, 7 skills `cowork-*/SKILL.md`, HANDOFF.md, README.md, global `/mnt/.claude/CLAUDE.md`. Paths disjuntos → zero risco sobrescrita.

**Outcome intended:** OLMO sem refs Cowork exceto archive imutável + CHANGELOG histórico. Contagem residual ≤10 hits (archive 4 + CHANGELOG 6). Meta: 41 hits ACTIVE → 0.

---

## Audit verified (my Grep count)

Resultado `Grep "cowork" -i C:\Dev\Projetos\OLMO`:

| File | Hits | Classe | Action |
|------|-----:|--------|--------|
| `wiki\topics\sistema-olmo\raw\best-practices-cowork-skills-2026-04-08.md` | 14 | ACTIVE | DELETE (ou migrate pre-delete) |
| `.claude\skills\skill-creator\SKILL.md` | 6 | ACTIVE | Clean (generic examples) |
| `CHANGELOG.md` | 6 | IMMUTABLE | NO-OP (histórico) |
| `.claude\BACKLOG.md` | 4 | ACTIVE | Clean (remove/rewrite items) |
| `content\aulas\metanalise\evidence\cowork-evidence-harvest-S112.md` | 4 | ACTIVE | RENAME + header |
| `.claude\skills\nlm-skill\SKILL.md` | 3 | ACTIVE | Clean (remove Cowork refs) |
| `config\workflows.yaml` | 3 | ACTIVE | Clean (remove/env-var) |
| `wiki\README.md` | 3 | ACTIVE | Clean |
| `.claude\plans\archive\S154-sunny-plotting-fountain.md` | 3 | IMMUTABLE | NO-OP |
| `wiki\topics\sistema-olmo\raw\ecosystem-study-S115.md` | 2 | ACTIVE | Clean |
| `wiki\topics\sistema-olmo\_index.md` | 1 | ACTIVE | Clean |
| `wiki\topics\medicina-clinica\_index.md` | 1 | ACTIVE | Clean |
| `.claude\plans\archive\S214-curious-honking-platypus.md` | 1 | IMMUTABLE | NO-OP |
| **TOTAL** | **51** | | |

ACTIVE subtotal: 41 hits em 10 arquivos. IMMUTABLE: 10 hits em 3 arquivos. Meta residual ≤10.

---

## Strategy

Ordem: **shallow→deep** (quick wins cedo, decisões complexas depois). Cada phase = 1 commit atômico. Verificação regressiva per-phase (grep contagem decrescente).

Propose-before-pour aplicado: proposta alto-nível agora, volume no execution após OK.

---

## Phase A — Quick wins (4 files, 9 hits, ~10min, 1 commit)

Edits pontuais, low risk. Primeira validação de que a abordagem funciona.

### A.1 `wiki\topics\sistema-olmo\_index.md` (1 hit)
Ação: localizar ref (Grep context), remover linha/menção. Wiki OLMO deve falar só OLMO.

### A.2 `wiki\topics\medicina-clinica\_index.md` (1 hit)
Ação: idem A.1. Provável ref a workflow médico Cowork.

### A.3 `wiki\README.md` (3 hits)
Ação: remover menções Cowork em ecosystem overview. Wiki é SSoT OLMO conceitual.

### A.4 `wiki\topics\sistema-olmo\raw\ecosystem-study-S115.md` (2 hits)
Ação: raw study de ecosystem pode ter ADR-0001 histórico legítimo. Decisão: se é ecosystem architecture anterior a ADR-0001, marcar `<!-- Pre ADR-0001 -->` + remover refs prospectivas. Senão, remover completo.

**Commit A:** `S226 purga: wiki cowork refs (Phase A — 4 files)`

**Verification A:** `Grep "cowork" -i wiki/` retorna apenas hits archive (0 ACTIVE em wiki).

---

## Phase B — Structured edits (3 files, 13 hits, ~15min, 1 commit)

### B.1 `.claude\BACKLOG.md` (4 hits)
Ação: ler cada hit em context. Para cada:
- Se item é **roadmap Cowork-only** (ex: "criar skill cowork-X") → **remover** (Cowork instance tracks it).
- Se item é **misto** (toca OLMO também) → **reescrever** focado no delivery OLMO. Exemplo: "bridge OLMO ↔ Cowork" vira "verificar HANDOFF bridge contract (ADR-0001)".
- Se item referencia Cowork como **dependência** (ex: "aguarda Cowork concluir X") → reescrever sem nome "Cowork", usar "external producer" ou similar.

Requer leitura contextual per-hit. Lucas aprova cada decisão ou delega.

### B.2 `.claude\skills\skill-creator\SKILL.md` (6 hits)
Ação: skill-creator gera novas skills. 6 hits provavelmente são exemplos usando `cowork-research`, `cowork-*` como referência. Substituir por exemplos **genéricos** (`my-skill`, `medical-example`, placeholder). Remove referências a skills específicas Cowork — skill-creator deve ser project-agnostic.

### B.3 `.claude\skills\nlm-skill\SKILL.md` (3 hits)
Ação: nlm-skill (NotebookLM). 3 hits provavelmente em "cowork→NLM path + DAG docs" (evidenciado em CHANGELOG S113 L2629). Remover step "cowork→" do DAG, manter NLM skill como ingester de outputs já disponíveis em `data/extracted/` ou similar — abstrair producer.

**Commit B:** `S226 purga: BACKLOG + skills (skill-creator, nlm-skill)`

**Verification B:** `Grep "cowork" -i .claude/` retorna apenas archive (0 ACTIVE em .claude/).

---

## Phase C — config workflows (1 file, 3 hits, ~10min, 1 commit)

### C.1 `config\workflows.yaml` (3 hits)
Contexto identificado: `paid_source_extraction` workflow L396-453 usa `browser_agent` com `primario: claude_cowork, backup: chatgpt_agent` (L410-411). Possível outras refs em headers/comments.

Ação proposta: duas opções:

**Option C-a (remove delegation):** remover workflow `paid_source_extraction` inteiro do config OLMO. Cowork tracks seus workflows em `OLMO_COWORK\config\workflows.yaml` (se houver). OLMO consome output via `/digest-pull` quando pronto.

**Option C-b (env-var producer):** manter workflow mas substituir `primario: claude_cowork` por `primario: external_producer_env` + env var `OLMO_COWORK_INBOX=C:\Dev\Projetos\OLMO_COWORK\pipeline\output`. Config agnóstica.

**Recomendação:** C-a. Workflows.yaml deve expressar o que OLMO executa. Extração de fontes pagas = Cowork job. OLMO apenas consome quando inbox entrega.

**Commit C:** `S226 purga: workflows.yaml (remove paid_source_extraction delegation)`

**Verification C:** `Grep "cowork" -i config/` retorna 0.

---

## Phase D — Complex decisions (2 files, 18 hits, ~15min, 2 commits)

### D.1 `content\aulas\metanalise\evidence\cowork-evidence-harvest-S112.md` (4 hits)

**Contexto:** evidência MBE gerada via bridge legítima em S112 (pré-ADR-0001 mas consistente com spirit). Lucas: "MANTER conteúdo".

**Ação:**
1. `git mv content/aulas/metanalise/evidence/cowork-evidence-harvest-S112.md content/aulas/metanalise/evidence/evidence-harvest-S112.md` (rename, sem prefixo cowork-).
2. Edit header: add HTML comment `<!-- Origem: gerado via bridge ADR-0001 em S112 (OLMO_COWORK\pipeline\output\) -->` como primeira linha (depois do frontmatter se houver).
3. Verificar se há links internos em outros files apontando para o nome antigo (`grep cowork-evidence-harvest` em OLMO). Se sim, atualizar.

**Decisão Lucas:** approve novo nome (`evidence-harvest-S112.md`) ou sugere variante?

**Commit D.1:** `S226 purga: rename cowork-evidence-harvest → evidence-harvest (+ bridge origin header)`

### D.2 `wiki\topics\sistema-olmo\raw\best-practices-cowork-skills-2026-04-08.md` (14 hits — 37% da carga)

**Contexto:** arquivo 242 li dentro de wiki OLMO, mas conteúdo é best-practices para OLMO_COWORK. Seções:
- 1: Anthropic Skill Authoring (generic, copy-paste docs)
- 2: Claude Code CLAUDE.md (generic, copy-paste docs)
- 3: GitHub repos de referência (curated list)
- 4: **Aplicação ao OLMO_COWORK — Melhorias Concretas** ← esta é a razão do arquivo

**Análise:** seções 1-3 são duplicata de docs upstream (Anthropic + GitHub awesome lists). Valor único reside em §4, que é **Cowork-specific planning** — pertence a OLMO_COWORK, não OLMO wiki.

**Options:**
- **D.2-a (DELETE):** arquivo inteiro deletado. §1-3 recuperáveis em upstream. §4 já é de interesse Cowork-side, Cowork instance cria equivalente em `OLMO_COWORK\docs\practices\` se quiser.
- **D.2-b (SPLIT):** keep §1-3 em OLMO wiki (renomear para `best-practices-skills-authoring.md` sem "cowork"), delete §4 (Cowork cria próprio).
- **D.2-c (MIGRATE full):** Cowork instance (paralelo) cria `OLMO_COWORK\docs\practices\skill-authoring-2026-04.md` com conteúdo. Após confirmação, delete OLMO side.

**Recomendação:** D.2-a (DELETE full). Por quê:
1. §1-3 são copy-paste Anthropic docs — não adicionam valor único ao OLMO wiki.
2. §4 é Cowork planning — pertence Cowork.
3. Lucas audit direction: "AÇÃO: deletar. Se conteúdo tem valor, migrar para OLMO_COWORK\docs\practices\ antes de deletar."
4. Migration exigiria write em OLMO_COWORK — fora do meu escopo S226. Cowork instance paralela pode pick up se quiser.

**Decisão Lucas:** aprovar D.2-a (delete) ou pedir D.2-b/c?

**Commit D.2:** `S226 purga: delete best-practices-cowork-skills (Cowork-scope content)`

---

## Phase F — ADR OLMO-side (new, ~8min, 1 commit)

Contrato simétrico lado OLMO. Formaliza inbox sem nomear producer = producer-agnostic, future-proof (troca de producer sem re-engenharia).

### F.1 Create `docs/adr/0002-external-inbox-integration.md`

**Pré-check:** verificar se `docs/adr/` existe via Glob. Se não, `mkdir -p docs/adr`. Checar convention de naming em ADRs existentes (se houver).

**Conteúdo proposto:**

```markdown
# ADR-0002: External Inbox Integration

- **Status:** accepted
- **Data:** 2026-04-17
- **Deciders:** Lucas + Claude (Opus 4.7)

## Contexto
OLMO consome artefatos produzidos por sistemas externos (browser agents, research delegados, extração de fontes pagas). Sem contrato explícito, tendência: producer externo escreve direto em `OLMO\`, poluindo git + authority ambígua.

## Decisão
OLMO define env var `OLMO_INBOX` (default `../OLMO_COWORK/pipeline/output/`, override via shell env). OLMO lê APENAS desse path em `/digest-pull`, `/research-pull` e consumer workflows. OLMO é **opaque** quanto à origem dos artefatos — não conhece topologia interna do producer. Sistemas externos nunca escrevem em `OLMO\`.

## Consequências
### Positivas
- Git OLMO limpo (simetria com ADR-0001, agora expressa lado consumer).
- Producer-agnostic: qualquer sistema que siga contrato pode ser plug-in.
- Substituibilidade: troca producer (OLMO_COWORK → outro browser agent) sem re-engenharia OLMO.

### Negativas
- Descoberta tardia de inbox mal-formado (integrity check em `/digest-pull` é crítico).
- Pull-based (não push) — trade-off aceito para preservar independence.

## Alternativas consideradas
1. **Hardcode producer path** — rejeitado: acoplamento reverso.
2. **Push-based (producer notifica consumer)** — rejeitado: quebra independence, exige protocolo sync.
3. **DB compartilhado** — rejeitado: dependência extra, perde auditabilidade arquivos timestamped.

## Ref cruzada
- `OLMO_COWORK/docs/adr/0001-bridge-via-inbox.md` — contrato simétrico do producer-default (OLMO_COWORK). ADR-0001 + ADR-0002 formam sistema bidirecionalmente consistente.
```

**Verification F:** file exists, markdown lint clean, ref cruzada a ADR-0001 presente, nenhuma menção literal "Cowork" no corpo exceto §Ref cruzada como producer-default SoT externo.

**Commit F:** `S226 purga: ADR-0002 external inbox integration (OLMO-side symmetric contract)`

---

## Phase G — KBP-24 preventivo (new, ~5min, 1 commit)

Impede regressão: futura ref sistema externo em OLMO = violação grepável + documentada.

### G.1 Add KBP-24 em `.claude/rules/known-bad-patterns.md`

**KBP id:** arquivo atual sinaliza "Next: KBP-24" em header (S225 state). Confirmar via Read antes de edit. Se outro ID tiver sido usado entretanto, incrementar.

**Format (pointer-only, honra KBP-16 verbosity drift):**

```markdown
## KBP-24 Docs sobre sistemas externos dentro de OLMO
→ docs/adr/0002-external-inbox-integration.md §Decisão
```

**Prose vive em ADR-0002 §Decisão + §Consequências.** Sem inline prose em known-bad-patterns.md — respeita KBP-16 (verbosity drift in auto-loaded docs).

**Conteúdo conceitual no ADR-0002 (referenciado via pointer):**
- **Sintoma:** file em `wiki/`, `content/`, `config/`, `.claude/skills/` descrevendo arquitetura/workflows/best-practices de sistema externo.
- **Por que drift:** viola ADR-0001 + ADR-0002. OLMO opaque quanto ao producer — conhecer internals = acoplamento conceitual.
- **Exceção única:** artifacts em `$OLMO_INBOX` (default `../OLMO_COWORK/pipeline/output/`). Artifact-in-transit, não docs.
- **Prevenção:** antes de criar file, perguntar: "é sobre OLMO ou sobre sistema externo?" Externo → escrever no repo do externo ou abstrair para producer-agnostic.
- **Evidência histórica:** S226 removeu 41 refs "cowork" em 10 OLMO files (incluindo `best-practices-cowork-skills-2026-04-08.md` com 14 hits, arquivo inteiro Cowork-scope).

**Update header KBP file:** `> Next: KBP-25`.

**Commit G:** `S226 purga: KBP-24 docs sobre sistemas externos (preventivo)`

---

## Phase E — Documentation + verification (3 files, ~10min, 1 commit)

### E.1 `HANDOFF.md`
- Remover §MELHORIAS S226 (pre-pivot, obsoleto)
- Substituir por §S226 PURGA DONE + §S227 TARGETS
- Manter VERDICT S225 (histórico)
- Adicionar linha próximas sessões: "Melhorias1.1 discipline rules **deferred** S227" (se Lucas confirmar — ou abandonar)

### E.2 `CHANGELOG.md`
Append:
```
## S226 Melhorias1.1 → Purga Cowork (2026-04-17)
- ADR-0001 enforcement: 41 ACTIVE cowork refs → 0 em OLMO
- Phase A: wiki cleanup (4 files)
- Phase B: BACKLOG + 2 skills (skill-creator, nlm-skill)
- Phase C: workflows.yaml (remove paid_source_extraction)
- Phase D: rename cowork-evidence-harvest-S112 + delete best-practices-cowork-skills
- Residual: 10 hits (archive 4 + CHANGELOG 6 histórico)
```

### E.3 Final verification (mandatory)
```bash
grep -ri "cowork" C:\Dev\Projetos\OLMO --include="*.md" --include="*.yaml" --include="*.yml" --exclude-dir=".git" | wc -l
```
- **Target:** ≤10 hits
- Listar arquivos residuais, confirmar pertencem archive+CHANGELOG
- Reportar a Lucas antes do commit final

**Commit E:** `S226 purga CLOSED: HANDOFF + CHANGELOG + verification (residual X/10)`

---

## Commit strategy (8 commits atômicos, order A→B→C→D→F→G→E)

| # | Commit | Phase | Files | Hits removed |
|---|--------|-------|-------|:------------:|
| 1 | purga: wiki cowork refs | A | 4 wiki files | 7 |
| 2 | purga: BACKLOG + skills | B | BACKLOG + 2 skills | 13 |
| 3 | purga: workflows.yaml | C | config | 3 |
| 4 | purga: rename cowork-evidence-harvest | D.1 | 1 evidence file | 4 |
| 5 | purga: delete best-practices-cowork-skills | D.2 | 1 wiki file | 14 |
| 6 | purga: ADR-0002 external inbox integration | F | docs/adr (new) | 0 |
| 7 | purga: KBP-24 docs sobre sistemas externos | G | known-bad-patterns | 0 |
| 8 | purga CLOSED: docs + verification | E | HANDOFF + CHANGELOG | 0 |

Total: 41 hits → 0 ACTIVE. Residual ≤10 (archive + CHANGELOG histórico). Phase F+G são **institucionais** (zero hit removed, but prevent future regression).

Separação granular: bisect + revert cirúrgico se algum commit causar regressão inesperada (ex: link interno quebrado post-rename).

---

## Critical files inspecionados (read-only)

- `OLMO_COWORK\docs\adr\0001-bridge-via-inbox.md` — contrato bridge
- `OLMO\wiki\topics\sistema-olmo\raw\best-practices-cowork-skills-2026-04-08.md` — 242 li full
- `OLMO\config\workflows.yaml` — 600 li skimmed, found paid_source_extraction L396+
- Grep "cowork" -i count + 26KB content (13 files)

Não-inspecionados (budget tight, skimmed em execution):
- `.claude\BACKLOG.md` (4 hits — lerei em B.1)
- Skills SKILL.md files (9 hits total — lerei em B.2/B.3)
- Wiki small files (quick wins — lerei em A.1-A.4)
- `cowork-evidence-harvest-S112.md` (4 hits — lerei em D.1 antes de rename)

---

## Budget & risk

**Budget total:** 60-90min (Lucas update S226 +F+G institucionais). Checkpoint ao atingir 75min, parar se >90min.

**Phase-level:**
- A: ~10min (4 files quick)
- B: ~15min (3 files, contextual decisions)
- C: ~10min (1 file, workflow decision)
- D: ~15min (2 files, rename + delete)
- F: ~8min (1 new ADR file)
- G: ~5min (1 KBP pointer + header update)
- E: ~10min (3 files docs + final grep verification)
- Overhead (commits + per-phase grep regression check): ~7min
- Total: ~80min com margem dentro banda 60-90

**Risks:**

1. **[MED]** `best-practices-cowork-skills-2026-04-08.md` delete perde conteúdo valioso (§3 GitHub curation). Mitigation: antes de delete, Lucas confirmar. Se quiser preservar, Cowork instance cria equivalent em OLMO_COWORK\docs\practices\ (fora meu scope).

2. **[MED]** BACKLOG items "mistos" — decisão ambígua (roadmap puro Cowork vs misto). Mitigation: Lucas decide item-a-item em B.1 (pause for approval se >2 casos ambíguos).

3. **[LOW]** Rename `cowork-evidence-harvest-S112.md` quebra link em outro file. Mitigation: grep link antes do rename (Phase D.1 step 3).

4. **[LOW]** Cowork instance paralela edita mesmo arquivo por engano. Mitigation: zero-overlap enforcement (paths disjuntos confirmados — eu só OLMO/, Cowork só OLMO_COWORK/).

5. **[LOW]** workflows.yaml remove quebra cron job ativo. Mitigation: check if `paid_source_extraction` is referenced em cron jobs/schedules (likely no — manual trigger per config L402).

**Rollback plan:**
- Cada phase = commit isolado. `git revert <commit-hash>` reverte granular.
- Rename (D.1) → `git mv` inverso.
- Delete (D.2) → `git revert` restaura.

---

## Decision points Lucas (antes ExitPlanMode)

**D1. Phase D.2 (best-practices file, 14 hits):** delete full (D.2-a) ou split/migrate (D.2-b/c)?
→ *Meu voto: D.2-a delete. Seções 1-3 são copy-paste Anthropic docs; §4 é Cowork-specific.*

**D2. Phase D.1 (evidence-harvest rename):** aceitar novo nome `evidence-harvest-S112.md` ou sugerir variante?
→ *Default: `evidence-harvest-S112.md`. Alternativa: `metanalise-evidence-cross-ref-S112.md` (mais descritivo).*

**D3. Phase C (workflows.yaml):** C-a (remove workflow) ou C-b (env-var producer)?
→ *Meu voto: C-a. Workflow delega browser work para Cowork — conceito Cowork-side. OLMO consome via inbox quando pronto.*

**D4. Phase B.1 (BACKLOG items):** Lucas decide item-a-item em real-time ou delega decisão para mim com report final?
→ *Meu default: pause após 1ª leitura, mostrar os 4 items em context + proposta per-item, aguardar OK batch.*

**D5. Plan-file rename pós-approval:** `immutable-crunching-fairy.md` → `ACTIVE-S226-purga-cowork-plan.md`?
→ *Default: sim (signal strengthening per S225 APRENDIZADOS L89).*

**D6. Session theme:** manter `.claude/.session-name = "Melhorias1.1"` (historical intent) ou atualizar para `"purga-cowork"` (actual work)?
→ *Meu voto: atualizar para `purga-cowork` (statusline reflete verdade operacional).*

---

## Coordenação com Cowork instance (reminder)

- Cowork paths (FORA meu scope): `OLMO_COWORK\CLAUDE.md`, 7 `skills\cowork-*\SKILL.md`, `OLMO_COWORK\HANDOFF.md`, `OLMO_COWORK\README.md`, `/mnt/.claude/CLAUDE.md` (global).
- Leituras read-only OLMO_COWORK permitidas para verificar estado.
- Zero write em OLMO_COWORK nesta sessão (enforcement strict — ADR-0001 bidirecional).
- Se Cowork precisa de conteúdo de `best-practices-cowork-skills-2026-04-08.md` antes do meu delete, Cowork instance lê e escreve em seu próprio `docs/practices/`. Eu delete após sinalização (HANDOFF Cowork ou direct message Lucas).

---

Coautoria: Lucas + Opus 4.7 | S226 Purga Cowork plan proposed | 2026-04-17
