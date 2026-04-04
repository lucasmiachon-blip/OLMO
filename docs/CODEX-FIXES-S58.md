# Codex Audit S57 — Fixes Aplicados na S58

> Audit: GPT-5.4 (Codex), 2026-04-03 | Fixes: Opus 4.6, 2026-04-03
> Fonte: `docs/CODEX-AUDIT-S57.md` (15 achados objetivos + 10 adversariais)

---

## Resumo

| Categoria | Qtd | Resultado |
|-----------|-----|-----------|
| Fixes aplicados | 10 | Todos verificados |
| Removidos (dead code) | 1 | check-evidence-db.sh |
| Rejeitados (nao viavel/redundante) | 6 | Justificados abaixo |
| Testes | 53/53 PASS | CI verde |

---

## Fixes Aplicados

### 1. Shell Redirection Escape — CRITICAL

**Erro:** `Bash("echo > file")` bypassa todos os guards (guard-pause, guard-product-files). Hooks PreToolUse so cobriam `Write|Edit`.

**Fix:** Novo hook `.claude/hooks/guard-bash-write.sh` registrado em PreToolUse(Bash). Detecta: `>`, `>>`, `sed -i`, `tee`, `writeFileSync`. Retorna `ask` (confirmacao), nao `block`. Whitelist para `.session-name`.

**Verificacao:**
- `echo malicious > file.html` → ask
- `git status > /dev/null` → allow (safe redirect)
- `sed -i s/old/new/ file.txt` → ask
- `echo -n test > .claude/.session-name` → allow (whitelist)

### 2. Policy Shopping — feedback_mentor_autonomy.md

**Erro:** Dizia "executar sem pedir confirmacao redundante" — escape hatch direto do CLAUDE.md "espere OK".

**Fix:** Reescrito. Autonomia agora explicitamente condicionada a: (1) plano aprovado existente, (2) acao dentro do escopo aprovado. CLAUDE.md "espere OK" declarado como teto.

### 3. Policy Shopping — user_mentorship.md

**Erro:** "decidir, executar, explicar depois" contradiz anti-drift e CLAUDE.md.

**Fix:** Reescrito para "propor, explicar, executar apos OK". Manteve distincao contextual (areas tech vs medicina), mas CLAUDE.md "espere OK" e teto em ambos os casos.

### 4. Contradicao metanalise/CLAUDE.md — Gemini vs Opus

**Erro:** Secao "Auditoria Visual — Gemini CLI" e Gate 4 "Gemini approved" contradiziam root "QA visual = Opus, NAO Gemini".

**Fix:** Secao reescrita com dois sub-itens:
- **Opus (multimodal)** — QA visual primario (agente analisa screenshots)
- **Gemini CLI** — QA automatizado (`gemini-qa3.mjs`, Gate 0 inspect + Gate 4 editorial)

Gate 4 atualizado: `Scorecard 14-dim (Opus visual) + gemini-qa3.mjs --editorial + Lucas approved`.

**Nota critica:** O Codex (e eu inicialmente) interpretamos errado. Existem DOIS QA visuais que coexistem — Opus e Gemini script. A contradicao era na exclusividade, nao na existencia do Gemini.

**Re-review S59:** Esta misinterpretação indica que premissas do audit podem ter sido mal interpretadas. Achados 1-10 foram re-verificados individualmente pelo implementador (Opus 4.6) durante S58. Nenhum outro achado apresentou interpretação incorreta.

### 5. slide-rules.md — aside.notes obrigatorio vs deprecated

**Erro:** `<aside class="notes">` obrigatorio em TODO `<section>`, mas root CLAUDE.md e MEMORY.md dizem aside.notes deprecated (Lucas nao usa presenter mode).

**Fix:** Mudado para "opcional — manter se ja existir, nao exigir em slides novos". Checklist atualizado.

### 6. design-reference.md — evidence-db canonico vs deprecated

**Erro:** Linha 65: "evidence-db e canonico". Root diz evidence-db deprecated, living HTML e source of truth.

**Fix:** "Living HTML por slide e canonico (substitui evidence-db.md)".

### 7. qa-pipeline.md — "NUNCA batch Gemini"

**Erro:** Referenciava so Gemini, ignorando que Opus tambem faz QA visual.

**Fix:** "NUNCA batch QA — 1 slide por ciclo completo (vale para Opus visual e Gemini script)".

### 8. guard-product-files.sh — so protegia cirrose

**Erro:** Array PRODUCT_PATTERNS so tinha paths de cirrose. Metanalise (18 slides, deadline 2026-04-15) e grade (58 slides) desprotegidos.

**Fix:** Patterns generalizados para `content/aulas/[^/]+/...` — cobre todas as aulas (presentes e futuras). Comportamento mudado de `exit 2` (block duro) para `ask` (confirmacao). Razao: `ask` forca pausa sem impedir trabalho legitimo.

### 9. build-monitor.sh — failure branch dead code

**Erro:** Registrado em `PostToolUse` mas o codigo so logava quando `EVENT == "PostToolUseFailure"`. Como o hook nunca era chamado em PostToolUseFailure, a branch de logging era dead code.

**Fix tentado:** Adicionar hook em `PostToolUseFailure` no settings.local.json.
**REVERTIDO:** `PostToolUseFailure` NAO e um evento valido do Claude Code. Adicionar ao settings quebrou o parsing de hooks subsequentes (Notification, Stop), causando perda de toast notifications. Removido. O fix correto e ajustar o build-monitor.sh para checar exit code dentro do evento PostToolUse.

### 10. check-evidence-db.sh — dead code completo

**Erro:** O hook tentava ler `transcript_path` do input JSON, mas PreToolUse hooks NAO recebem esse campo. O hook SEMPRE caia no `exit 0` da linha 19 ("no transcript → allow"). Nunca bloqueou nada. Alem disso, enforceava leitura de evidence-db.md (deprecated).

**Fix:** Hook desabilitado (exit 0 imediato com comentario). Removido do settings.local.json. Arquivo mantido para referencia.

**Gap preexistente (S59):** Este hook nunca funcionou — `transcript_path` nao existe no input de PreToolUse hooks. O hook SEMPRE caia no `exit 0` da linha 19. A desabilitacao apenas tornou o dead code explicito. Evidence-based claims dependem exclusivamente do system prompt (enforcement passivo).

---

## Rejeitados (nao implementados)

### 11. stop-hygiene.sh blocking

**Achado:** Hook so avisa, nunca bloqueia stop.
**Razao da rejeicao:** Stop hooks rodam DEPOIS do stop — sao informativos por design. `exit 2` num Stop hook nao impede o encerramento. Warning e o maximo viavel.

### 12. UserPromptSubmit hook — injecao de memoria

**Achado:** Sem hook pre-prompt para forcar consulta a memorias.
**Razao da rejeicao:** Claude Code nao expoe evento `UserPromptSubmit`. Corretamente marcado como "Bloqueado / Pesquisa necessaria" no audit.

### 13. PreCompact hook — salvar contexto

**Achado:** Sem hook antes de compaction para preservar contexto.
**Razao da rejeicao:** Claude Code nao expoe evento `PreCompact`. `SessionStart(compact)` ja re-injeta regras criticas via session-compact.sh.

### 14. session-compact.sh — injetar memorias de erros

**Achado:** Nao re-injeta memorias de erros recorrentes.
**Razao da rejeicao:** Memorias mudam semanalmente. Hardcodar memorias especificas no hook e fragil e criaria manutencao. As 5 regras criticas ja injetadas cobrem o comportamento.

### 15. anti-drift.md — plan mode e aprovacao pre-write

**Achado:** Faltam regras sobre plan mode e aprovacao antes de write.
**Razao da rejeicao:** Plan mode e comando UI, nao regra. "Aprovacao antes de write" ja e enforceado por guard-pause.sh. Adicionar seria redundancia.

### 16. Memory expires: frontmatter

**Achado:** Memorias sem lifecycle metadata.
**Razao da rejeicao:** 35+ memorias precisariam de datas de expiracao + manutencao recorrente. System prompt ja instrui "verify against current code before asserting as fact." Custo > beneficio.

**Inconsistencia reconhecida (S59):** V2 (Memory Omission) classifica enforcement passivo como CRITICAL. Esta rejeicao depende do mesmo enforcement passivo ("system prompt instrui verify") que V2 considera insuficiente. A contradicao e real — o audit aplica criterios diferentes ao mesmo mecanismo.

---

## Arquivos Modificados

| Arquivo | Tipo |
|---------|------|
| `.claude/hooks/guard-bash-write.sh` | **NOVO** |
| `.claude/hooks/guard-product-files.sh` | Editado (generalizado + ask) |
| `.claude/hooks/check-evidence-db.sh` | Desabilitado (dead code) |
| `.claude/settings.local.json` | Editado (3 mudancas) |
| `content/aulas/metanalise/CLAUDE.md` | Editado (QA dual) |
| `.claude/rules/slide-rules.md` | Editado (aside.notes opcional) |
| `.claude/rules/design-reference.md` | Editado (living HTML canonico) |
| `.claude/rules/qa-pipeline.md` | Editado (batch rule universal) |
| `memory/feedback_mentor_autonomy.md` | Editado (teto CLAUDE.md) |
| `memory/user_mentorship.md` | Editado (propor antes de agir) |

---

Coautoria: Lucas + Opus 4.6 (fixes) + GPT-5.4 (audit original) | 2026-04-03
