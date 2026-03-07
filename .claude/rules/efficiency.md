# Regra: Eficiencia de API

Antes de qualquer API call:
1. Verifique cache local primeiro
2. Tente resolver localmente (regex, parsing, busca em arquivos)
3. Se precisar de API, use o modelo mais barato que resolve
4. Combine perguntas relacionadas em 1 chamada (batch)
5. Registre o custo no BudgetTracker
