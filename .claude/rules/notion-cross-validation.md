---
paths:
  - "**/*notion*"
---

# Regra: Cross-Validation Notion (Claude + ChatGPT)

> Writes no Notion que reorganizam, arquivam ou reclassificam paginas DEVEM passar por cross-validation.
> Writes simples (criar pagina, editar conteudo de 1 pagina, adicionar tag) NAO precisam — ver "Quando NAO precisa".

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
