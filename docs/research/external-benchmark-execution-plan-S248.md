# S248 External Benchmark Merge Plan

> Status: ADOPT AS EXECUTION GATE | Created: 2026-04-25 | Scope: OLMO control plane, hooks, agents, CI, content pipeline

## Tese

OLMO deve incorporar benchmarks externos como criterio de execucao, nao como mais uma camada cerimonial. O objetivo e transformar "processo documentado" em "processo que roda": checks verdadeiros, hooks testados, agentes focados, claims auditaveis e backlog com prioridade operacional.

## Benchmarks externos

| Fonte | Pratica relevante | Leitura para OLMO | Decisao de merge |
|---|---|---|---|
| Anthropic Claude Code - Hooks | Hooks dao controle deterministico, mas rodam comandos automaticamente e exigem review, teste, validacao de input, paths seguros e schema correto. | OLMO ja usa hooks como control plane, mas ha schema bugs #57-59 e excesso de superficie. | ADOPT: todo hook deve ter evento, matcher, schema, smoke test, failure mode e criterio de remocao. |
| Anthropic Claude Code - Subagents | Subagents devem ter responsabilidade clara, contexto proprio e tool access minimo. | OLMO tem 10 agentes e plano #60 para expandir debug team. | ADOPT: novos agentes so entram um por vez, com tools explicitas, exemplo de uso e 3 usos reais antes de virar padrao. |
| Google Engineering Practices | Small CLs reduzem risco, revisao fica mais rapida e bugs ficam mais localizaveis. | #60 e um pacote grande de meta-tooling; CI/hooks ainda tem drift. | ADOPT: dividir execucao em lotes pequenos; infra truth antes de expansao. |
| DORA CI / trunk-based development | CI precisa ser feedback rapido e verdadeiro, com build verde como responsabilidade diaria. | CI ainda roda `mypy agents/ subagents/ config/` e `pytest`, apesar do repo declarar runtime Python purgado. | ADOPT: CI deve refletir o repo real antes de branch protection ou novos gates. |
| GitHub protected branches / Actions | Required checks so tem valor se os jobs exigidos forem unicos, relevantes e confiaveis. | PR template e Makefile diferem do workflow CI. | ADOPT: alinhar nomes e comandos antes de exigir checks protegidos. |
| Microsoft SDL | Seguranca e privacidade entram em requisitos, design, implementacao, verificacao, release e resposta. | OLMO tem guards e deny-list, mas falta uma rotina leve por mudanca relevante. | ADOPT: toda mudanca em hooks/MCP/content pipeline declara risco, dado sensivel, rollback e teste. |
| OWASP SAMM | Modelo de seguranca deve ser mensuravel, iterativo e risk-driven. | CMMI/antifragile como rito amplo vira custo se nao tiver execucao. | ADOPT: maturidade leve por metricas, sem framework pesado novo. |
| OpenSSF Scorecard | Checks automatizados ajudam a avaliar risco de supply chain e higiene OSS. | Repo tem pre-commit e secrets guard, mas nao ha score externo consolidado. | EVAL: rodar Scorecard/secret/dependency checks inicialmente nao-bloqueantes. |
| Google SRE postmortems | Falhas relevantes devem virar registro com impacto, causa, mitigacao e follow-up. | Hook failure recorrente vira backlog, mas nao necessariamente aprendizagem fechada. | ADOPT: falha recorrente de hook/CI cria mini-postmortem e acao preventiva, nao novo hook por reflexo. |
| CMMI levels | Nivel managed exige trabalho planejado, executado, medido e controlado. | OLMO tem planejamento e backlog, mas algumas verificacoes nao executam a realidade atual. | ADOPT: usar CMMI so como vocabulario de controle; sem processo formal pesado. |

## O que aproveitar no OLMO

Ja existe base boa para aproveitar:

- `.claude/settings.json` como control plane de hooks e permissoes.
- `.claude/BACKLOG.md` como SSoT persistente.
- `.claude/agents/*.md` e `.claude/skills/*/SKILL.md` versionados, alinhados ao modelo Anthropic.
- Pre-commit com ruff, secrets e checks basicos.
- Logs/metrics de hooks em vez de depender so de memoria de sessao.
- Documentacao explicita de "sem runtime Python", que permite deletar checks falsos.

O merge deve fortalecer esses pontos, nao criar outro sistema paralelo.

## Decisoes

1. **Freeze de expansao:** nao criar novos hooks, agentes ou skills ate fechar os drifts B1-B3 abaixo, salvo override explicito de Lucas.
2. **CI truth first:** o workflow precisa validar a arquitetura atual, nao a arquitetura purgada.
3. **Hook budget:** hook sem registro ativo, schema correto, smoke test e valor operacional vira candidato a disable/delete.
4. **Agent gate:** agente novo precisa de responsabilidade unica, tool allow-list minima, exemplo de invocacao, criterio de pronto e 3 usos reais.
5. **Claim registry:** "antifragile L1-L7" so fica como claim externo depois de auditoria por camada.
6. **Maturity lite:** substituir CMMI cerimonial por 5 metricas mensais: CI truth, hooks failing/firing, backlog P0/P1 velocity, security/supply-chain, incidentes/postmortems.

## Plano de execucao

### B0 - Benchmark gate

Objetivo: tornar este plano o gate de execucao antes de novas camadas.

Done:
- Backlog aponta para este arquivo.
- HANDOFF menciona que #60 debug team depende de B1-B3.
- Plan ativo recebe overlay de benchmark.

### B1 - Verification truth

Objetivo: alinhar CI, Makefile e docs com o repo real.

Done:
- GitHub Actions nao chama diretórios Python purgados (`agents/`, `subagents/`, `tests/`) como se fossem runtime ativo.
- PR template, Makefile e CI usam os mesmos comandos base.
- Aulas tem check minimo real (`lint`/`build` ou script equivalente) se for produto P0.

Risco se pular: branch protection ou green build vao validar uma arquitetura fantasma.

### B2 - Hook containment

Objetivo: corrigir schema bugs e reduzir superficie de falha.

Done:
- #57 `post-tool-use-failure.sh` usa schema correto.
- #58 `post-compact-reread.sh` usa schema correto.
- #59 `guard-write-unified.sh` usa PreToolUse fail-closed correto.
- Criado inventario simples: evento, matcher, comando, owner, last evidence, smoke test, retire condition.

Risco se pular: hooks continuam parecendo protecao enquanto falham silenciosamente.

### B3 - Content pipeline truth

Objetivo: remover comandos mortos do pacote de aulas.

Done:
- `content/aulas/package.json` nao aponta para `scripts/content-research.mjs` se o script foi removido.
- `/research` skill vira fonte canonica documentada, ou o script e restaurado de forma testada.

Risco se pular: comandos de package viram documentacao falsa.

### B4 - Antifragile claim audit

Objetivo: separar claim, runtime e evidencia.

Done:
- Para L1-L7, tabela com `claim`, `runtime`, `evidence`, `gap`, `decision`.
- L3/L6 sem runtime/evidencia sao rebaixados ou marcados explicitamente como BASIC/NOT IMPLEMENTED.

Risco se pular: antifragile continua narrativo e nao operacional.

### B5 - Security and maturity lite

Objetivo: incorporar SDL/SAMM/OpenSSF sem burocracia.

Done:
- Checklist curto por mudanca sensivel: dado, ameaca, rollback, teste, log.
- Scorecard/dependency/secret checks avaliados como nao-bloqueantes antes de virar gate.
- Mini-postmortem para hook/CI failure recorrente.

Risco se pular: seguranca fica espalhada em guards sem governanca mensuravel.

### B6 - Resume debug team only after gates

Objetivo: permitir #60 sem repetir crescimento sem consumidor.

Done:
- B1-B3 fechados.
- Cada novo debug agent tem tools explicitas e exemplo real.
- Orchestrator skill so nasce depois de pelo menos 2 agentes provarem utilidade em caso real.

Risco se pular: o debug team vira nova camada elegante sobre fundacao desalinhada.

## Referencias

- Anthropic Claude Code Hooks: https://docs.anthropic.com/en/docs/claude-code/hooks
- Anthropic Claude Code Subagents: https://docs.anthropic.com/en/docs/claude-code/sub-agents
- Google Engineering Practices - Small CLs: https://google.github.io/eng-practices/review/developer/small-cls.html
- DORA Continuous Integration: https://dora.dev/capabilities/continuous-integration/
- DORA Trunk-based Development: https://dora.dev/capabilities/trunk-based-development/
- GitHub Protected Branches: https://docs.github.com/articles/about-required-status-checks
- GitHub Actions Quickstart: https://docs.github.com/en/actions/get-started/quickstart
- Microsoft Security Development Lifecycle: https://learn.microsoft.com/en-us/compliance/assurance/assurance-microsoft-security-development-lifecycle
- OWASP SAMM: https://owasp.org/www-project-samm/
- OpenSSF Scorecard: https://openssf.org/projects/scorecard/
- Google SRE Postmortem Culture: https://sre.google/sre-book/postmortem-culture/
- CMMI Levels: https://cmmiinstitute.com/learning/appraisals/levels
