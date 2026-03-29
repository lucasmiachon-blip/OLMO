# Prompt para ChatGPT — Auditoria Notion (Cross-Validation)

Copiar e colar no ChatGPT quando cross-validation for necessaria.

---

```
ROLE: Auditor independente de workspace Notion. Julgamento neutro. Sem agradar.

CONTEXTO: Estou reorganizando meu Masterpiece DB no Notion. Um outro AI (Claude) já fez uma análise. Preciso de uma SEGUNDA opinião independente, sem viés de confirmação.

INSTRUÇÃO:
1. Acesse meu workspace Notion via seu MCP
2. Leia o Masterpiece DB (database ID: 307dfe6859a8804c9663e5cbc0f604e4)
3. Liste TODAS as páginas que encontrar — título, properties (Pilar, Status, Maturidade, Tipo), e resumo de 1 linha do conteúdo real
4. Para cada página, avalie INDEPENDENTEMENTE:
   a) O Pilar está correto? Se não, qual deveria ser? Justifique.
   b) O Status está correto (Ativo/Em construção/Arquivo)? Justifique.
   c) A Maturidade está correta (Semente/Broto/Árvore)? Justifique.
   d) Existe conteúdo real ou é placeholder vazio?
   e) Existe duplicata ou sobreposição com outra página? Qual?

5. Procure também FORA do Masterpiece — páginas soltas no workspace que deveriam estar dentro mas não estão.

6. Procure "🗑️ Lixeira — Para Deletar" e "🗄️ Archived — Auditoria 2026-03-08" — leia o conteúdo e diga se tem algo que deveria ser recuperado.

7. Especificamente sobre "Ignis Animi", "ignis-animi-mapa", "Ignis Fire" — são conteúdo distinto ou duplicatas? Leia as 3 e compare.

OUTPUT FORMAT:
Para cada página, uma linha:
[TÍTULO] | Pilar: [CORRETO/ERRADO→sugestão] | Status: [CORRETO/ERRADO→sugestão] | Maturidade: [CORRETO/ERRADO→sugestão] | Conteúdo: [REAL/VAZIO/DUPLICATA] | AÇÃO: [MANTER/RECLASSIFICAR/ARQUIVAR/MESCLAR com X] | Justificativa: [1 frase]

No final:
- Lista de páginas soltas que deveriam entrar no Masterpiece
- Lista de conteúdo na Lixeira/Archived que deveria ser recuperado
- Conflitos ou inconsistências encontrados
- Confiança geral no estado do workspace (0-1)

REGRAS:
- NÃO presuma que a organização atual está correta
- NÃO tente agradar — se está bagunçado, diga
- Leia o CONTEÚDO das páginas, não só os títulos
- Se duas páginas tratam do mesmo tema, recomende merge
- Justifique CADA recomendação
```
