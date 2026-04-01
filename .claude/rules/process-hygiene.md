# Regra: Higiene de Processos

> Maximo por aula: 1 headed (Vite dev) + 1 headless (Playwright/QA). Matar apos uso.

## Antes de iniciar

```bash
# Checar se porta ja esta ocupada
netstat -ano | grep ":${PORT} " | grep LISTENING
```

Se ocupada: matar por PID especifico. **NUNCA `taskkill //IM node.exe`** (mata tudo do usuario).

## Portas reservadas

| Aula | Dev (headed) | Preview |
|------|-------------|---------|
| cirrose | 4100 | 4173 |
| grade | 4101 | — |
| metanalise | 4102 | — |

## Matar por PID (unico metodo permitido)

```bash
# Achar PID pela porta
netstat -ano | grep ":4100 " | grep LISTENING | awk '{print $NF}'
# Matar
taskkill //PID <pid> //F
```

## Ciclo de vida obrigatorio

1. **Antes de `npm run dev:*`**: verificar se porta livre
2. **Apos teste/verificacao**: matar o processo
3. **Antes de encerrar sessao**: matar todos os processos que o agente iniciou
4. **Headless (Playwright/QA)**: rodar com timeout, matar ao terminar

## Proibido

- `taskkill //IM node.exe` — mata dev server do usuario
- Deixar Vite rodando entre tarefas sem necessidade
- Iniciar segundo dev server na mesma porta (--strictPort impede, mas verificar antes)
- Background processes sem controle de PID
