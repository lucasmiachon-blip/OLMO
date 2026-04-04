---
paths:
  - content/aulas/**
---

# Regra: Higiene de Processos

> Max por aula: 1 headed (Vite dev) + 1 headless (Playwright/QA). Matar apos uso.

## Portas reservadas

| Aula | Dev | Preview |
|------|-----|---------|
| cirrose | 4100 | 4173 |
| grade | 4101 | — |
| metanalise | 4102 | — |

## Regras

1. Antes de `npm run dev:*`: verificar porta livre (`netstat -ano | grep ":PORT "`)
2. Matar sempre por PID (`taskkill //PID <pid> //F`). **NUNCA `taskkill //IM node.exe`**
3. Apos teste/verificacao: matar o processo
4. Antes de encerrar sessao: matar todos os processos que o agente iniciou
5. Headless (Playwright/QA): rodar com timeout, matar ao terminar
6. NUNCA segundo dev server na mesma porta
7. NUNCA background processes sem controle de PID
