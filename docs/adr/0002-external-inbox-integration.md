# ADR-0002: External Inbox Integration

- **Status:** accepted
- **Data:** 2026-04-17
- **Deciders:** Lucas + Claude (Opus 4.7)

## Contexto

OLMO consome artefatos produzidos por sistemas externos (browser agents, research delegados, extração de fontes pagas). Sem contrato explícito, tendência: producer externo escreve direto em `OLMO\`, poluindo git + authority ambígua.

## Decisão

OLMO define env var `OLMO_INBOX` apontando para diretório onde producer externo entrega artefatos. OLMO lê APENAS desse path em `/digest-pull`, `/research-pull` e consumer workflows. OLMO é **opaque** quanto à origem dos artefatos — não conhece topologia interna do producer. Sistemas externos nunca escrevem em `OLMO\`.

## Consequências

### Positivas

- Git OLMO limpo (simetria com ADR-0001, agora expressa lado consumer).
- Producer-agnostic: qualquer sistema que siga contrato pode ser plug-in.
- Substituibilidade: troca producer sem re-engenharia OLMO (apenas env var).

### Negativas

- Descoberta tardia de inbox mal-formado (integrity check em `/digest-pull` é crítico).
- Pull-based (não push) — trade-off aceito para preservar independence.

## Alternativas consideradas

1. **Hardcode producer path** — rejeitado: acoplamento reverso.
2. **Push-based (producer notifica consumer)** — rejeitado: quebra independence, exige protocolo sync.
3. **DB compartilhado** — rejeitado: dependência extra, perde auditabilidade arquivos timestamped.

## Ref cruzada

- `OLMO_COWORK/docs/adr/0001-bridge-via-inbox.md` — contrato simétrico do producer-default (OLMO_COWORK). ADR-0001 + ADR-0002 formam sistema bidirecionalmente consistente.

## Enforcement

KBP-24 em `.claude/rules/known-bad-patterns.md` aponta para este ADR §Decisão. Trigger: qualquer arquivo em `wiki/`, `content/`, `config/`, `.claude/skills/` que descreva arquitetura/workflows/practices de sistema externo.

Exceção documentada: upstream imports (ex: Anthropic skill-creator) onde tokens relativos a produtos Anthropic (headless environments) não refletem este contrato — esses files preservam identidade upstream e não contam como drift.
