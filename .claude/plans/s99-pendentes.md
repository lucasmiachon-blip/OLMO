# S99 Pendentes — Para S100

> Sessao 99 | 2026-04-07
> Foco: momentum-brake hooks + QA editorial + batches adversariais

## O que foi feito

1. **Momentum-brake hooks implementados** (3 scripts + registro)
   - `.claude/hooks/momentum-brake-arm.sh` (PostToolUse: Write|Edit|Bash|Agent)
   - `.claude/hooks/momentum-brake-enforce.sh` (PreToolUse: .*)
   - `.claude/hooks/momentum-brake-clear.sh` (UserPromptSubmit)
   - Registrados em `settings.local.json` (28 registrations agora)
   - Testados manualmente: arm cria lock, enforce pede ask, clear remove lock

2. **QA capture s-objetivos COM video**
   - `node scripts/qa-capture.mjs --aula metanalise --slide s-objetivos --video`
   - Screenshot S0 + video .webm capturados em `qa-screenshots/s-objetivos/`
   - Metrics: fillRatio 0.82, all checks PASS
   - Video pronto para editorial gate

3. **Feedback salvo**: agent-delegation (memory 20/20)

## Pendentes para S100

### A. Fixes momentum-brake (Batch 5 findings)

| ID | Sev | Fix |
|----|-----|-----|
| B5-02 | P1 | `momentum-brake-arm.sh`: add `set -euo pipefail` |
| B5-04 | P1 | `settings.local.json`: arm matcher `Write\|Edit\|Bash\|Agent` → `.*` (armar em TUDO) |
| B5-05 | P1 | `momentum-brake-enforce.sh`: remover Write\|Edit da lista de exempcoes (aceitar double-ask com guard-pause) |

Aceitos (nao fixar):
- B5-01 (P0 symlink): local tool, requer acesso fisico
- B5-03 (P1 race): janela minima, impacto baixo
- B5-06 (P1 self-bypass via rm): bypass explicito detectavel
- B5-07 (P2 node spawn): ~100ms, rare path

### B. Editorial Pro s-objetivos

Pipeline step 10 (gemini-qa3.mjs --editorial):
```
node scripts/gemini-qa3.mjs --aula metanalise --slide s-objetivos --editorial
```
- Video ja capturado (animation-1280x720.webm)
- Inspect ja PASS (S98)
- Motion agora tera score valido (video presente)
- Salvar output em `qa-screenshots/s-objetivos/editorial-suggestions.md`

### C. Batches adversariais (redo correto)

S99 falhou: codex:codex-rescue delega ao Codex CLI externo, nao faz review.
**Abordagem correta para S100:**
- Usar `general-purpose` agent type (nao codex:codex-rescue)
- Incluir no prompt: "escreva findings em .claude/plans/batch-N-findings.md"
- Confirmar com Lucas antes de lancar
- Testar 1 batch antes de lancar multiplos

Escopo sugerido:
- Batch 6: hooks ecosystem cross-reference (scripts vs registrations vs README)
- Batch 7: antifragile health (KBPs enforced? self-healing loop functional?)

### D. Backlog herdado (nao tocado S99)

| # | Item | Status |
|---|------|--------|
| 1 | /insights (last S91) | Nao rodado |
| 2 | Memory governance review | Cap 20/20 atingido — precisa /dream audit |
| 3 | Slide novo metanalise (tema TBD) | Nao iniciado |
| 4 | Docker stack test | Nao testado |
| 5 | notion-ops write tools (Codex #5) | Pendente |

### E. Falha sistematica identificada S99

**Agent delegation sem verificacao**: lancei 3 agentes que falharam antes de diagnosticar root cause (agente errado para a tarefa). Memory salva em `feedback_agent_delegation.md`. Regra: verificar tipo + output + aprovacao ANTES de lancar.

### F. Payloads que falharam (preservados para retry correto)

**Tentativa 1 — Batch 5 (codex:codex-rescue):** retornou findings no task summary apos 4min, mas output file vazio.
**Tentativa 2 — Batch 6 (codex:codex-rescue):** retornou em 33s com "submitted to Codex", zero work.
**Tentativa 3 — Batch 6 redo (researcher):** 43 tool uses, output file vazio (findings nao persistidos).

#### Payload Batch 5 (momentum-brake adversarial)
```
Tipo usado: codex:codex-rescue (ERRADO — delega ao Codex CLI)
Tipo correto: general-purpose

Prompt resumido:
- Review 3 scripts (.claude/hooks/momentum-brake-*.sh) + settings.local.json
- 10 dimensoes: input validation, race conditions, bypass vectors, error handling,
  path safety, interaction com hooks existentes, performance, completeness,
  lock file security, registration correctness
- Output: ID B5-NN, severity P0/P1/P2, file+line, description, fix
```

#### Payload Batch 6 (hooks ecosystem + antifragile health)
```
Tipo usado: codex:codex-rescue (ERRADO), depois researcher (output nao persistido)
Tipo correto: general-purpose COM instrucao de escrever em arquivo

Prompt resumido:
Part A — Hooks cross-reference:
- Ler settings.local.json, listar ALL registrations
- Listar .sh em .claude/hooks/ e hooks/
- Cross-ref: scripts nao registrados? Registrations apontando para scripts missing?
- Verificar README.md counts
- Checar stdin consumption em cada script

Part B — Antifragile KBP audit:
- Para cada KBP (1-5): verificar se o fix declarado esta implementado
- Checar self-healing loop (stop-detect → pending-fixes → session-start)
- Checar OTel config, cost-circuit-breaker thresholds

Part C — Gaps:
- Hooks mortos/unused, protection gaps, layers declaradas mas nao funcionais

Output: ID B6-NN, category HOOKS|ANTIFRAGILE|GAP, severity, description+evidence, fix
CRITICO: escrever findings em .claude/plans/batch-6-findings.md (faltou essa instrucao)
```

#### Licoes para S100
1. Usar `general-purpose` (nao codex:codex-rescue) para adversarial review
2. Incluir no prompt: "escreva todos os findings em [arquivo.md]"
3. Confirmar com Lucas o agente + escopo ANTES de lancar
4. Testar 1 batch, verificar output, depois lancar os demais
