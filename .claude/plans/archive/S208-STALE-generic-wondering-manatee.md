# S208 Diagnóstico + Redesign — Quality Loops & System Maturity

> **Status: STALE — S224 audit** — Fase 2 agendada L190 para "proximas 3 sessoes" nunca executada. Artifacts L257, L265 nao existem. Self-improvement PAUSADO por gate (HANDOFF). Ver `BACKLOG-S220-codex-adversarial-report.md` L54.

## Context

S205-S207 expuseram falhas sistêmicas: CSS com 17 raw px apesar de 1,102 linhas de rules dizendo "NUNCA", PDF cortando slides, árvore desorganizada. Lucas identificou corretamente que o problema não é "faltou um hook" — é que o sistema inteiro de QC está em feedback loop negativo: mais regras → mais contexto → menos compliance → mais regras.

Pesquisa empírica (5 agents, 6 fontes) confirmou:

| Fonte | Achado-chave |
|-------|-------------|
| **Karpathy** | ~50 linhas, 4 princípios. "LLM Wiki" 3 camadas: raw→compiled→schema |
| **Boris Cherny** (Head Claude Code) | ~100 linhas, 3 hooks. "Give Claude a verification loop = 2-3x quality" |
| **Anthropic oficial** | <200 linhas. "CLAUDE.md = probably listens. Hook = always enforces" |
| **Pesquisa empírica** | 3 mecanismos de violação: attention allocation, context compaction, probabilistic exemption |
| **Graphiti** (getzep) | Temporal knowledge graph, MCP server, bi-temporal model, 25k stars |
| **Hookify** | Plugin oficial Anthropic: linguagem natural → hooks, conversation analyzer |

---

## Diagnóstico: Por Que o QC Falha

### 1. Budget de instrução saturado
- Modelo tem ~100-150 slots de instrução efetivos
- OLMO carrega 1,102 linhas de rules + CLAUDE.md. Saturação completa.
- Resultado: modelo faz triagem interna — tarefas vencem, regras de processo perdem

### 2. Ratio fatos:processo invertido
- Recomendado: 80% fatos ("use oklch"), 20% processo ("faça EC checkpoint")
- OLMO atual: 30% fatos, 70% processo
- Regras de processo (elite-conduct, anti-drift momentum brake, delegation gate) são as primeiras a cair sob pressão

### 3. Feedback loop instável
- `/insights` e `/dream` produzem regras
- Cada KBP novo consome instruction budget
- Quanto mais regras → menos compliance → mais KBPs
- 21 KBPs atualmente, tendência crescente

### 4. Verificação ausente para CSS
- Boris: "Give Claude a verification loop" = 2-3x quality
- Slides HTML: lint-slides.js (verificação mecânica) ✓
- CSS: ZERO verificação mecânica ✗
- Rules dizem "NUNCA raw px" mas nenhum mecanismo verifica

### 5. Memória flat sem temporalidade
- 20 arquivos markdown, append-only
- Sem provenance, sem versioning, sem graph de relações
- wiki/ implementa Karpathy 3-layer pattern mas dormiu 87 sessões
- `/dream` consolida mas não mantém wiki/ vivo

---

## Tiers de Maturidade — CMMI Enterprise Model

Adaptado do Capability Maturity Model Integration (CMMI) para o contexto OLMO.

### Level 1: Initial (estado atual)
Processos ad hoc, dependentes do indivíduo. Resultados imprevisíveis. Rules existem mas não são seguidas de forma consistente. Sucesso depende de esforço heroico (Lucas pegando erros manualmente).
**Indicadores:** 17 raw px apesar de rules, retrabalho frequente, sem métricas.

### Level 2: Managed → Fase 1
Processos planejados e monitorados. Requisitos gerenciados. Trabalho é planejado, executado, medido e controlado.

**Ressalva crítica sobre hooks:** Hooks são freio, não motor. Um hook que bloqueia `font-size: 30px` impede o erro mas não gera melhoria — não faz o modelo entender POR QUE tokens importam, não produz CSS melhor, não ensina. Hooks são necessários no Level 2 (evitar regressão) mas insuficientes para Level 3+ (melhoria real). A melhoria vem de verification loops (o modelo vê o resultado e aprende), knowledge temporal (facts que compõem), e métricas de convergência (decisões baseadas em dados). Hooks travam; loops ensinam.

**Indicadores:** Hook CSS BLOCK ativo, rules <300 linhas, baseline metrics definidos.

### Level 3: Defined → Fase 2
Processos padronizados e documentados. Verificação mecânica em loop (build→lint→screenshot→verify). Organização aprende com dados, não com intuição. Proativo em vez de reativo.
**Indicadores:** 0 novos raw px em 3+ sessões, PNG export funcional, verification loop CSS operacional.

### Level 4: Quantitatively Managed → Fase 3
Processos medidos com dados quantitativos. Performance previsível. Knowledge graph temporal (Graphiti) permite queries sobre evolução do sistema. Decisões baseadas em dados, não em acúmulo de rules.
**Indicadores:** Métricas de convergência (retrabalho/sessão), Graphiti operacional, wiki/ atualizado.

### Level 5: Optimizing (futuro)
Melhoria contínua baseada em análise quantitativa. Sistema se auto-corrige. Policy "one in, one out" mantém complexidade constante. Self-improvement real, não acúmulo.
**Indicadores:** Taxa de retrabalho decrescente, complexidade estável, zero feedback loop negativo.

---

## Fase 1 — Rules Reduction ✅ COMPLETA

### 1A. Rules: 1,102 → 198 linhas ✅
- S208: 13→5 files, 1102→315 li (tiered architecture T2/T3/T4)
- S209: constraints-only pass, 315→198 li
- T4 reference: `docs/aulas/slide-advanced-reference.md` com todo conhecimento migrado

### ~~1B. Hook CSS lint~~ REMOVIDO (Lucas S208)
CSS quality = verification loop (L3), não hook BLOCK (L2).

### 1C. Hookify — instalar e avaliar (PENDENTE)
### 1D. exports/ gitignore (PENDENTE)

---

## Pesquisa S209 — Hooks Estado da Arte (fontes verificadas)

> Fontes: code.claude.com/docs/en/hooks, github.com/anthropics/claude-plugins-official,
> howborisusesclaudecode.com, github.com/disler/claude-code-hooks-mastery,
> github.com/trailofbits/claude-code-config

### Sistema de hooks real (vs o que usamos)
- **27 eventos de lifecycle** (usamos 8). Não usamos: FileChanged, SubagentStart/Stop, TaskCreated/Completed, SessionEnd, InstructionsLoaded, Elicitation, CwdChanged, WorktreeCreate/Remove, ConfigChange, etc.
- **4 tipos de handler:** `command` (shell), `http` (endpoint), `prompt` (Haiku avalia linguagem natural), `agent` (subagent com tools). Usamos só `command`.
- **`if` conditions (v2.1.85+):** narrow scope sem scripts separados.
- **`$CLAUDE_PROJECT_DIR`:** portabilidade. Nosso settings.local.json tinha 25+ caminhos absolutos hardcoded.
- **`async`:** fire-and-forget para hooks não-bloqueantes.
- **Exit 2:** hard block. **10k chars cap** no additionalContext.

### Hookify — plugin oficial Anthropic
- YAML frontmatter em `.claude/hookify.<nome>.local.md`. Traduz para hooks no runtime.
- `/hookify <descrição>` cria regra de linguagem natural. `/hookify` sem args analisa conversa e sugere.
- Python 3.7+, zero deps. Efeito imediato sem restart.
- Limitações: AND logic only, sem versionamento, sem rollback.

### `prompt` type hooks
- Manda contexto para Haiku, que avalia com linguagem natural. Custo mínimo.
- Substitui pattern matching bash por avaliação semântica.
- Exemplo: guard-bash-write (162 li, 19 regex) → prompt hook de ~5 linhas.

### Boris Cherny (Head Claude Code)
- PostToolUse + formatter = padrão canônico. Setup pessoal "vanilla" — mínimo de hooks.
- "Hooks are deterministic lifecycle interception" — freio, não lógica de negócio.

### Projetos referência
- disler/claude-code-hooks-mastery: 13 eventos, Python UV single-file, testes automatizados.
- trailofbits/claude-code-config: 2 hooks bloqueantes como baseline. "Hooks são guardrails, não security boundaries."

### Limitações documentadas
- PostToolUse não desfaz (tool já executou).
- Múltiplos updatedInput no mesmo tool: last-write-wins (não-determinístico).
- PermissionRequest não dispara em modo headless (-p).

---

## Pesquisa S209 — Memória Estado da Arte (fontes verificadas)

> Fontes: code.claude.com/docs/en/memory, arxiv.org/abs/2604.01599, arxiv.org/abs/2501.13956,
> github.com/mem0ai/mem0, docs.mem0.ai, github.com/getzep/graphiti, github.com/WujiangXu/A-mem

### Limitações flat files (documentadas)
- MEMORY.md: só 200 linhas / 25KB carregadas no session start.
- Sem retrieval semântico (grep falha em paráfrases).
- Staleness invisível. Post-compact frágil. Sem sync cross-machine.

### Opções de upgrade por custo

| Opção | Infra | Integração | Benchmark | Fonte |
|-------|-------|-----------|-----------|-------|
| ByteRover | Zero (markdown hierárquico) | Nativa | SOTA LoCoMo | arXiv:2604.01599 (abr 2026) |
| MCP server-memory | Zero (JSON local) | Oficial Anthropic | N/A | github.com/modelcontextprotocol/servers |
| Mem0 free | Cloud (10k adds, 1k retrievals/mo) | Plugin Claude Code | 66.9% LOCOMO (auto-reportado) | docs.mem0.ai |
| Mem0 + Kuzu | Embedded graph | Plugin + self-hosted | ~68.4% LOCOMO | mem0.ai |
| Graphiti/Zep | Neo4j/FalkorDB | MCP server | 94.8% DMR | arXiv:2501.13956 |
| A-Mem | Zero (Zettelkasten) | Não integrado | NeurIPS 2025 | github.com/WujiangXu/A-mem |

### Notas de cautela
- Benchmark Mem0 é auto-publicado. Issue #3944: reprodutibilidade questionada (0.20 vs 0.66 reportado).
- "90% token reduction" compara vs full-context (26k tokens), não vs flat files (~1-3k).
- Graphiti requer Neo4j/FalkorDB — não é zero-infra.
- ByteRover (abr 2026) é o mais recente, zero-infra, evolução direta de flat files.

---

## Audit S209 — Infraestrutura (30 hooks, 12 scripts)

### 4 bugs runtime
1. `install-hooks.sh` — `pre-push.sh` / `post-merge.sh` não existem. Push protection off.
2. `package.json` — research scripts apontam `_archived/`. Fail ao rodar.
3. `model-fallback-advisory.sh` — BSD date fallback silencioso no Windows. Circuit breaker quebrado.
4. `chaos-inject.sh` — session ID errado. L3 chaos injection não funciona.

### 3 vulnerabilidades
5. `pre-commit.sh:110` — `printf "$GHOST_FAIL"` sem `%s`. Format string injection.
6. `retry-utils.sh:28` — `eval "$cmd"`. Code injection vector.
7. `post-compact-reread.sh:15` — JSON hand-assembled, aspas corrompe output.

### 5 scripts órfãos
- `apca-audit.mjs` (96 li), `lint-gsap-css-race.mjs` (513 li), `validate-css.sh` (138 li), `install-fonts.js` (138 li), `export-pdf.js` (115 li) — não wired no pipeline.

### Dívida sistêmica
- 26/30 hooks sem `set -u`. gemini-qa3.mjs = 1871 li monolito. 2 últimos `node -e` em APL hooks.

### Já corrigido S209
- Permissions cleanup: settings.local.json 145→38 entradas (redundâncias removidas).
- Momentum brake: WebFetch/WebSearch/Task* adicionados à lista de isentos.

---

## Fase 2 — Verification Loops + PNG (próximas 3 sessões)

### 2A. CSS verification loop (Boris pattern)

Ciclo mecânico após cada edit CSS:
1. Edit CSS
2. Hook lint-css valida tokens (BLOCK se falhar)
3. Build (`npm run build:{aula}`)
4. Screenshot (`qa-capture.mjs --slide {id}`)
5. Agente verifica screenshot
6. Resultado → Lucas

Isso é o "give Claude a verification loop" do Boris aplicado ao CSS.

### 2B. export-png.mjs

- Playwright 1920×1080, navega cada slide, captura PNG
- npm script: `export:png:metanalise`
- Popula `drive-package/slides-png/` para backup offline
- Substitui PDF como fallback (PDF corta conteúdo)

### 2C. HDMI prep no LEIA.txt

Seção "HDMI — se a janela comprimiu" com Win+P, F11, Win+Shift+Arrow.

### 2D. Métricas de convergência

Medir se as mudanças estão funcionando:
- **Antes (baseline S207):** 17 raw px, 0 BLOCK CSS, 1,102 linhas rules
- **Meta S211:** 0 novos raw px por sessão, hook CSS ativo, rules <300 linhas
- **Meta S215:** 3+ sessões sem retrabalho CSS, wiki/ atualizado

---

## Fase 3 — Knowledge Graph + Self-Improvement Real (S215+)

### 3A. Graphiti avaliação

- Instalar `graphiti-core[kuzu]` (embedded, sem servidor)
- MCP server apontando para Gemini (budget-friendly)
- Teste: ingestar últimas 5 sessões como episodes
- Verificar: facts temporais reproduzem o que Memory Wiki tem?
- Decisão: substituir Memory Wiki flat ou manter dual?

### 3B. Wiki revival

- Atualizar wiki/ com estado real (hooks 29→corrigir, agents 10→verificar)
- Conectar `/dream` para atualizar wiki/ além de memory/
- Ou: Graphiti substitui ambos

### 3C. Self-improvement estável

**Policy "one in, one out":** cada KBP novo remove ou merge um existente.
**Cap absoluto:** 21 KBPs max (atual). Novo KBP = merge 2 existentes em 1.
**Métrica:** taxa de retrabalho por sessão (não número de rules).

### 3D. Árvore — caminho canônico

- `assets/` root → renomear para `concurso/` (é material de concurso, não assets do projeto)
- `scripts/` root (Python) → manter mas documentar distinção no TREE.md
- Regenerar `docs/TREE.md` (S93 → S208+)

---

## Arquivos Tocados

### Fase 1 (esta sessão)
- **Criar:** `.claude/hooks/lint-css-on-edit.sh`
- **Editar:** `.claude/settings.local.json` (registrar hook)
- **Editar:** `content/aulas/.gitignore` (exports/)
- **Editar:** 6-8 rules files (redução radical)
- **Instalar:** hookify plugin
- **NÃO criar:** novos rules, novos KBPs

### Fase 2 (S209-S211)
- **Criar:** `content/aulas/scripts/export-png.mjs`
- **Editar:** `content/aulas/package.json`, `drive-package/LEIA.txt`
- **Medir:** baseline metrics

### Fase 3 (S215+)
- **Instalar:** graphiti-core
- **Avaliar:** temporal knowledge vs flat memory
- **Atualizar:** wiki/, TREE.md

---

## Verificação do Plano

- Fase 1: `wc -l .claude/rules/*.md` < 300 total. Hook CSS bloqueia `font-size: 30px`.
- Fase 2: 17 PNGs gerados 1920×1080. 0 novos raw px em 3 sessões.
- Fase 3: Graphiti ingere 5 sessões, retorna facts verificáveis.

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Redução excessiva de rules perde proteções úteis | Git tracked — revert fácil. Medir 3 sessões. |
| Hook CSS com falsos positivos | Whitelist `#deck`/`:root`. Testar antes de deploy. |
| Hookify duplica hooks existentes | Audit cruzado antes de adotar. |
| Graphiti adiciona complexidade | Kuzu embedded (zero infra). Avaliar antes de adotar. |
