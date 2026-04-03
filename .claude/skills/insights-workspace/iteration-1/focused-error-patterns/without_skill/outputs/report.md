# Focused Error Patterns Report

> Scope: 10 sessoes mais recentes (S44-S53, Apr 01-03 2026)
> Metodo: parse JSONL, extracao de tool errors (is_error=true), user corrections (<400 chars), agent admissions
> Coautoria: Lucas + Opus 4.6

---

## Resumo Executivo

44 tool errors, 25 user corrections, 16 agent admissions analisados. **7 patterns recorrentes** (2+ sessoes). Os 3 maiores: pre-commit hooks (7x/5 sessoes), write-before-read (4x/4 sessoes), e agent oversight (6x/2 sessoes).

---

## Pattern 1: Pre-commit Hook Failures (7x across 5 sessions)

**Sessions:** S2, S5, S6, S7, S10
**What:** Hooks `trailing-whitespace`, `end-of-file-fixer`, `ruff-format` falham repetidamente no commit.

**Evidence:**
- S2: `trim trailing whitespace...Passed | ruff-format...Failed`
- S5: `end-of-file-fixer...Failed` + `ruff-format...Failed` (same session)
- S7: `trailing-whitespace...Failed` + `ruff-format...Failed`
- S10: `end-of-file-fixer...Failed`

**Root cause:** O agente gera arquivos com trailing whitespace, missing newlines, ou formatacao fora do padrao ruff. Os hooks detectam corretamente, mas o ciclo fix-commit-fail-fix repete a cada sessao.

**Severity:** MEDIUM. Nao causa perda de dados, mas gasta tempo e contexto em retries.

**Proposed fix:** Rodar `ruff format` e `pre-commit run --all-files` ANTES do `git commit`, nao depender do hook para pegar na hora do commit.

---

## Pattern 2: Write-Before-Read Guard (4x across 4 sessions)

**Sessions:** S2, S5, S6, S8
**What:** `File has not been read yet. Read it first before writing to it.`

**Evidence:**
- S2, S5, S6, S8: todas com o mesmo erro exato.

**Root cause:** O agente tenta editar/escrever um arquivo que nao foi lido naquela sessao. O guard existe para prevenir overwrites cegos, mas o agente esquece de ler primeiro.

**Severity:** LOW-MEDIUM. O guard previne o dano, mas o retry gasta tokens.

**Proposed fix:** Antes de Write/Edit, verificar se o arquivo ja foi lido na sessao. Pattern: always Read before Write.

---

## Pattern 3: File Does Not Exist (4x across 3 sessions)

**Sessions:** S5, S7, S8
**What:** Agent tenta ler/acessar arquivo que nao existe no caminho esperado.

**Evidence:**
- S5: `File does not exist. Note: your current working directory is C:\Dev\Projetos\OLMO\content\aulas.`
- S7: `File does not exist. Note: your current working directory is C:\Dev\Projetos\OLMO.`
- S8: 2x `File does not exist`

**Root cause:** Caminhos construidos de memoria em vez de verificados com Glob. Paths mudam entre sessoes (refactoring, renames) e o agente usa caminhos stale.

**Severity:** MEDIUM. Gasta tokens em retries e pode causar cascata de erros.

**Proposed fix:** Regra existente (`anti-drift.md`: "File not found: use Glob to locate it") nao esta sendo seguida consistentemente. Reforcar.

---

## Pattern 4: Agent Oversight / Forgot Existing Protocol (6x across 2 sessions)

**Sessions:** S5, S8
**What:** Agente ignora protocolos, skills ou roteiros que ja existem no repositorio.

**Evidence:**
- S5: "Deveria ter renderizado inline" (Excalidraw MCP nao funcionou como esperado)
- S8: "Me desculpe. Vou buscar o roteiro que existe." (lancou pesquisa ad-hoc em vez de usar /medical-researcher)
- S8: "Voce tem razao. Lancei subagent generico, deveria ter usado /medical-researcher skill"
- S8: "Encontrei. A cirrose tem um protocolo completo de pesquisa" (existia e nao foi consultado)
- S8: "Eval assertions enviesadas a favor da skill" (auto-critica do proprio eval design)

**User correction (S8):** "vc usou o modelo melhor o prompt que era pra ser usada, temos um roteiro para isso nao eh lancar qualquer coisa"

**Root cause:** Context rot em sessoes longas + falta de lookup sistematico de skills/protocolos existentes antes de agir. O agente age por impulso em vez de verificar o que ja existe.

**Severity:** HIGH. Gera retrabalho significativo e frustracao do usuario. Viola diretamente anti-drift.md.

**Proposed fix:** Antes de iniciar qualquer tarefa de pesquisa ou producao, fazer lookup explicito: `ls .claude/skills/` + `grep` no HANDOFF para protocolos existentes.

---

## Pattern 5: User Has to Say "I Can't See That" (4x across 3 sessions)

**Sessions:** S1, S5, S6
**What:** O agente afirma que algo foi produzido/renderizado, mas o usuario nao consegue ver.

**Evidence:**
- S1: "nao consigo ver o viewer" + "sem o viewer ainda" (viewer de benchmark nao apareceu)
- S5: "nao vejo" (output nao visivel)
- S6: "onde esta o novo html referencia" + "nao vejo no meu html" (alteracoes nao apareceram)

**Root cause:** O agente declara sucesso sem verificar que o output esta acessivel ao usuario. Problema de verificacao — o agente ve o resultado no tool output, mas nao confirma que o usuario tem acesso ao mesmo artefato.

**Severity:** MEDIUM-HIGH. Viola anti-drift.md gate function (step 4: "Confirm the output matches your claim").

**Proposed fix:** Apos produzir output visual, fornecer caminho absoluto + instrucao explicita de como acessar. Nunca dizer "pronto" sem path verificavel.

---

## Pattern 6: User Stops Agent Mid-Action (5x across 3 sessions)

**Sessions:** S3, S4, S5
**What:** Usuario interrompe o agente porque ele esta fazendo algo errado ou desnecessario.

**Evidence:**
- S3: "espere commita, push" (agente estava continuando quando devia parar)
- S4: "pare os agentes estao rodando sem sucesso" (subagents rodando sem resultado)
- S4: "aparece em baixo accet edits os 2 local agents" (agente nao percebia falha)
- S5: "tire e analise visual e pare" (agente ia continuar editando)
- S5: "deixar ele mais estetico separe um pouco os elementos" (redirecionamento)

**Root cause:** O agente continua executando apos sinais de que deveria pausar e pedir direcao. Especialmente problematico com subagents que rodam sem supervisao.

**Severity:** MEDIUM. Gasta tokens e contexto, mas o usuario consegue redirecionar.

**Proposed fix:** Apos cada batch de mudancas, pausar e pedir feedback em vez de continuar automaticamente. Subagents: timeout + checkpoint.

---

## Pattern 7: Windows Encoding (cp1252/mojibake) (recorrente, documentado)

**Sessions:** S1, S5, S8 (tool errors + user complaints)
**What:** Scripts Python e outputs com encoding errado no Windows.

**Evidence:**
- S1: nlm CLI crash por cp1252 encoding (caracter check)
- S8: "funcionando mas com mojibakes" + "ainda mojibake" (2x user complaint)
- S8: Agent fix: "Varios read_text() sem encoding='utf-8'"

**Root cause:** Windows default encoding e cp1252, nao UTF-8. Todo `open()` ou `read_text()` sem `encoding='utf-8'` explicito causa mojibake.

**Severity:** MEDIUM. Ja documentado em memoria (`feedback_defensive_coding.md`) mas ainda ocorre em codigo novo.

**Proposed fix:** Lint rule ou hook que detecta `open(` ou `.read_text(` sem `encoding=`. Regra ja existe na memoria, mas nao e enforcement automatico.

---

## Patterns Menores (nao-recorrentes mas notaveis)

| Pattern | Sessions | Count | Note |
|---------|----------|-------|------|
| File too large (>10k tokens) | S3, S8 | 3x | Usar offset/limit |
| check-evidence-db hook block | S5, S6 | 3x | Hook funciona corretamente, agente precisa ler evidence-db.md primeiro |
| MCP session expired | S5 | 2x | Sessoes MCP duram ~20min, agente nao re-autentica |
| Browser connection errors | S5 | 5x | Dev server nao estava rodando quando Playwright tentou acessar |
| User rejected edit | S6, S7, S8 | 4x | Agente propoe edits que usuario recusa — alinhamento |

---

## Cross-Cutting Observations

### 1. Sessao S5 foi a mais problematica
18 tool errors em uma unica sessao. Combinou: browser automation, MCP issues, hook blocks, encoding, file-not-found. Sessao longa e complexa (slide creation + evidence lookup + QA).

### 2. Anti-drift.md gate function nao esta sendo seguida
Steps 1-5 existem na regra, mas patterns 4 e 5 mostram que steps 2 ("Execute it") e 4 ("Confirm output matches claim") sao frequentemente pulados.

### 3. Memoria existe mas nao previne repeticao
`feedback_no_parameter_guessing.md`, `feedback_defensive_coding.md` documentam patterns que ainda ocorrem. A memoria registra o aprendizado, mas nao ha enforcement automatico.

### 4. Hooks funcionam como guardas
Pre-commit hooks, evidence-db hook, guard-generated hook — todos funcionam corretamente. O problema nao e os hooks, e que o agente gera output que nao passa neles. Hooks sao sintoma, nao causa.

---

## Recomendacoes (priorizadas por impacto)

| # | Acao | Pattern | Impacto |
|---|------|---------|---------|
| 1 | Rodar `ruff format` + `pre-commit run` ANTES de `git commit` | P1 | Elimina 7x retries |
| 2 | Lookup explicito de skills/protocolos antes de iniciar tarefa | P4 | Evita retrabalho S8 |
| 3 | Apos output visual, fornecer path absoluto + instrucao de acesso | P5 | Reduz "nao vejo" |
| 4 | Always Read before Write (nao confiar em memoria de sessao) | P2 | Elimina 4x errors |
| 5 | Glob antes de ler arquivo — nunca construir path de memoria | P3 | Elimina 4x errors |
| 6 | Lint enforcement para `encoding='utf-8'` em Python | P7 | Previne mojibake futuro |
| 7 | Pausar e pedir feedback apos cada batch de mudancas | P6 | Reduz interrupcoes |

---

*Generated: 2026-04-03 | Method: JSONL parse + manual categorization | 10 sessions analyzed*
