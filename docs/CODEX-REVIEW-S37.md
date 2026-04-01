# Codex Review S37 — Self-Improvement via GPT-5.4

> Data: 2026-04-01 | Modelo: GPT-5.4 (Codex exec, OAuth $0)
> Escopo: 7 agents, 4 rules adversariais, 12 scripts

---

## Scripts Review (16 findings)

### CRITICAL

1. **Root path computation duplica diretorios** — `path.resolve(__dirname, '..')` + `aulas/` gera `content/aulas/aulas/...`. Scripts falham silenciosamente ou leem arquivos errados.
   - **Afetados:** lint-slides.js:9,232 | lint-narrative-sync.js:22,36 | lint-case-sync.js:17,20 | lint-gsap-css-race.mjs:20,22 | done-gate.js:21,42
   - **Fix:** Derivar repo root uma vez (`git rev-parse --show-toplevel` ou walk up ate achar `package.json`), construir todos os paths a partir dele.

2. **export-pdf.js reporta sucesso quando DeckTape falha** — catch loga e continua, finally imprime "Export complete", exit 0. CI aceita PDFs quebrados.
   - **Refs:** export-pdf.js:77,83,87
   - **Fix:** Tracker de falhas + `process.exit(1)` se qualquer export falhar.

### HIGH

3. **done-gate.js nao-funcional** — procura `package.json` e `content/aulas/<aula>` sob diretorio errado (consequencia do #1).
   - **Refs:** done-gate.js:42,62

4. **qa-accessibility.js diretorio errado** — le `aulas/<lecture>` em vez de `content/aulas/<lecture>/slides`, sem guard no `readdirSync`. Crash antes de reportar.
   - **Refs:** qa-accessibility.js:18,19
   - **Fix:** Corrigir path + skip lectures ausentes explicitamente.

5. **lint-case-sync.js comparacao unidirecional** — checkpoints em `CASE.md` ausentes no `_manifest.js` passam silenciosamente.
   - **Refs:** lint-case-sync.js:143,146
   - **Fix:** Diff bidirecional (manifest→CASE + CASE→manifest).

6. **lint-case-sync.js regex panelStates fragil** — conteudo apos `panelStates` no arquivo faz parsing retornar `{}`, falso verde.
   - **Refs:** lint-case-sync.js:103,104
   - **Fix:** Parser brace-balanced ou importar o JS diretamente.

7. **browser-qa-act1.mjs + pre-commit.sh hardcoded cirrose** — outras aulas bypass gates ou recebem instrucoes erradas.
   - **Refs:** browser-qa-act1.mjs:22-25 | pre-commit.sh:15-16,58
   - **Fix:** Parametrizar aula via argumento CLI ou auto-detect por branch/cwd.

### MEDIUM

8. **validate-css.sh: WARN counter nunca incrementa** — summary sempre mostra `WARN: 0`.
   - **Refs:** validate-css.sh:15,75,87,114

9. **validate-css.sh: import order hardcoded `./cirrose.css`** — check errado para outras aulas.
   - **Refs:** validate-css.sh:12,26

10. **done-gate.js: `git status --porcelain` com `shell:true`** — fragil no Windows. Usar `execFileSync('git', ['status', '--porcelain=v1', '-z'])`.
    - **Refs:** done-gate.js:138,141

11. **lint-slides.js + qa-accessibility.js: notes matching rigido** — `<aside class="notes">` exato; single quotes, extra classes ou atributos reordenados = falso positivo.
    - **Refs:** lint-slides.js:75 | qa-accessibility.js:47

12. **lint-gsap-css-race.mjs: falsos positivos** — matching global de propriedade sem correlacao por scope/slide/seletor.
    - **Refs:** lint-gsap-css-race.mjs:396,402

13. **export-pdf.js: porta fixa + `server.kill()` no Windows** — pode deixar processo orfao (npx + shell:true).
    - **Refs:** export-pdf.js:19,57,88

### LOW

14. **install-fonts.js: sem validacao HTTP status/content-type** — error page pode ser salva como .woff2.
    - **Refs:** install-fonts.js:74,108

15. **install-hooks.sh: assume bash disponivel** — hook falha silenciosamente em Git nativo Windows sem bash no PATH.
    - **Refs:** install-hooks.sh:19,34,46

---

## Agents + Rules Review (39 findings)

### CRITICAL

1. **medical-researcher.md — verification deadlock**: "EVERY PMID must be verified via PubMed MCP". Se MCP indisponivel, agente trava sem fallback.
   - **Fix:** Criar tiers de verificacao: `VERIFIED` (PubMed MCP confirmou), `WEB-VERIFIED` (PubMed web confirmou), `CANDIDATE` (nao verificado). Nunca promover CANDIDATE sem pelo menos WEB-VERIFIED.

2. **qa-engineer.md — criterio de sucesso impossivel + mandate proativo**: "ALL 14 dimensions >= 9/10" + "Use PROACTIVELY after any slide is created or modified". Contradiz anti-drift.md (scope discipline) e efficiency.md (budget awareness).
   - **Fix:** Remover "Use PROACTIVELY" da description. Restringir a slides explicitamente pedidos pelo Lucas. Default = Gate 1-2 (lint+build). Gate 3-4 (visual+pedagogy) = sob demanda.

3. **medical-researcher memory — MELD-Na contradicao**: dados conflitantes em arquivo de memoria do agent.
   - **Fix:** Auditar `.claude/agents/medical-researcher/memory/` e corrigir inconsistencias.

### Problemas Sistemicos (cross-cutting)

**S1. "Verified" significa coisas diferentes em arquivos diferentes.**
- design-reference.md: PMID verificado = PubMed MCP confirmou
- medical-researcher.md: VERIFIED = 2+ fontes independentes
- evidence-db: campo "Verificado: YYYY-MM-DD" sem especificar metodo
- **Fix:** Vocabulario compartilhado: `VERIFIED` | `WEB-VERIFIED` | `CANDIDATE` | `SECONDARY` | `UNRESOLVED`. Definir em design-reference.md §3 como canonico.

**S2. Tensao exhaustive vs restrained.**
- medical-researcher: "Execute searches across ALL available MCPs"
- qa-engineer: "14 dimensions ALL >= 9/10", "Loop termina APENAS quando..."
- anti-drift: "Implement exactly what was requested, nothing more"
- efficiency: "Prefer the cheapest model that solves the task"
- **Fix:** Agents operam em modo economico por default. Modo exaustivo = flag explicita (`--deep`, `--full-qa`). Analogo a estratificacao de risco clinico.

**S3. Agents assumem arquivos que nao existem uniformemente.**
- qa-engineer: `cat content/aulas/{aula}/CLAUDE.md` (so cirrose e metanalise tem)
- repo-janitor: `content/aulas/{aula}/CLAUDE.md` como pre-condicao
- medical-researcher: `content/aulas/{aula}/references/CASE.md` (so cirrose)
- **Fix:** Adicionar fallback: `if file exists, read; else skip with warning`. Nunca crash por arquivo ausente.

### Top 3 Priority Fixes (agents)

1. **anti-drift.md:19** — Trocar "stop, revert the extra work" por "stop, identify the extra work, ask Lucas before reverting". Reverter automaticamente pode destruir trabalho em progresso.

2. **medical-researcher.md** — Unificar contrato de verificacao. PubMed MCP down → `WEB-VERIFIED`, nunca `VERIFIED`.

3. **qa-engineer.md** — Remover proactive mandate. Restringir scope a slides pedidos.

---

## Plano de Implementacao (proxima sessao)

### P0 — Corrigir agora (silent failures ativos)

| # | Fix | Arquivos | Estimativa |
|---|-----|----------|------------|
| 1 | Root path computation — derivar repo root uma vez | 5 scripts (lint-slides, lint-narrative-sync, lint-case-sync, lint-gsap-css-race, done-gate) | ~30min |
| 2 | export-pdf.js — fail hard on error | 1 script | ~10min |

### P1 — Agents (prompt engineering)

| # | Fix | Arquivo |
|---|-----|---------|
| 3 | anti-drift.md: "ask before reverting" | .claude/rules/anti-drift.md |
| 4 | qa-engineer.md: remover proactive, restringir scope | .claude/agents/qa-engineer.md |
| 5 | medical-researcher.md: verification tiers | .claude/agents/medical-researcher.md |
| 6 | Vocabulario "verified" unificado | .claude/rules/design-reference.md §3 |

### P2 — Scripts hardcoded → parametrizados

| # | Fix | Arquivos |
|---|-----|----------|
| 7 | Parametrizar aula (cirrose → argumento/auto-detect) | browser-qa-act1.mjs, pre-commit.sh, validate-css.sh |
| 8 | lint-case-sync.js: diff bidirecional + parser robusto | lint-case-sync.js |
| 9 | qa-accessibility.js: path correto + guard | qa-accessibility.js |
| 10 | done-gate.js: Windows-safe git status | done-gate.js |

### P3 — Polish

| # | Fix |
|---|-----|
| 11 | validate-css.sh: WARN counter + import order parametrizado |
| 12 | lint-slides.js: notes regex relaxado |
| 13 | install-fonts.js: HTTP status validation |
| 14 | Agents: fallback para arquivos ausentes |

---

Coautoria: Lucas + Opus 4.6 + GPT-5.4 (Codex) | 2026-04-01
