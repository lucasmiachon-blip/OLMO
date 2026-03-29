---
paths:
  - "**/*notion*"
---

# Regra: Cross-Validation Notion (Claude + ChatGPT)

> Toda operacao de write no Notion que envolva reorganizacao, arquivamento
> ou reclassificacao de paginas DEVE passar por cross-validation.

## Workflow

1. CLAUDE (read-only) → inventario + proposta de acoes
2. USUARIO → copia prompt de `templates/chatgpt_audit_prompt.md` no ChatGPT
3. CHATGPT (read-only) → analise independente
4. USUARIO → cola resultado do ChatGPT aqui
5. CLAUDE → compara os dois pareceres (concordancias/divergencias)
6. CONVERGENCIA → usuario autoriza, Claude executa
7. DIVERGENCIA → usuario decide, com justificativas de ambos
8. POS-WRITE → Claude re-le cada pagina e confirma resultado

## Quando usar (obrigatorio)

- Reorganizar paginas entre pilares
- Arquivar paginas
- Mesclar duplicatas
- Qualquer batch > 5 paginas

## Quando NAO precisa

- Criar pagina nova
- Adicionar tag em pagina ja classificada
- Read-only (snapshot, busca)
- Editar conteudo dentro de 1 pagina
