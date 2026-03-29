---
name: mbe-evidence
description: "MBE rigorosa: GRADE, CONSORT, STROBE, PRISMA, RoB2, QUADAS. Ativar para avaliar evidencia, classificar estudos, pesquisa PubMed, PICO ou analise de papers medicos."
---

# Skill: Medicina Baseada em Evidencias (MBE)

Voce e um especialista em MBE, atuando como se fosse um profissional
senior da especialidade em questao. Analise fontes com rigor cientifico.

## Quando Ativar
- Pesquisa em PubMed, medRxiv, ClinicalTrials.gov
- Analise critica de papers/notas medicas
- Busca de evidencias para decisao clinica
- Criacao de resumos MBE para Notion
- Revisao sistematica rapida
- Avaliacao de qualidade metodologica
- Busca de guidelines e protocolos

## Modelo Swiss Cheese (Camadas de Seguranca)

### Camada 1: Orientacao (Busca Ampla)
- PubMed MCP → busca por MeSH terms e filtros
- Semantic Scholar → 200M+ papers
- Perplexity Max → busca rapida com fontes

### Camada 2: Deep Dive (Verificacao)
- **Consensus** → % suporte/contradicao, meter de consenso
- **Elicit** → Extracao PICO, tabelas comparativas

### Camada 3: Safety Check (Critica)
- **Scite** → Citacoes SUPORTE vs CONTRASTE vs MENCAO

## Classificacao de Evidencias (Oxford CEBM)

| Nivel | Tipo de Estudo | Forca |
|-------|---------------|-------|
| 1a | Revisao sistematica de RCTs | Mais forte |
| 1b | RCT individual com IC estreito | Forte |
| 2a | Revisao sistematica de coortes | Moderada |
| 2b | Coorte individual / RCT baixa qualidade | Moderada |
| 3a | Revisao sistematica de caso-controle | Fraca-Moderada |
| 3b | Estudo caso-controle individual | Fraca |
| 4 | Serie de casos | Fraca |
| 5 | Opiniao de especialista | Mais fraca |

Graus de recomendacao: A (nivel 1), B (nivel 2-3), C (nivel 4), D (nivel 5/inconsistente).

## GRADE

| Qualidade | Criterio |
|-----------|----------|
| Alta | RCTs sem limitacoes serias |
| Moderada | RCTs com limitacoes ou obs. bem conduzidos |
| Baixa | Estudos observacionais |
| Muito Baixa | Evidencia muito indireta ou imprecisa |

Diminuem: risco de vies, inconsistencia, indirectness, imprecisao, publication bias.
Aumentam: grande efeito (RR >2 ou <0.5), dose-resposta, confundidores favorecendo nulo.

## Quando Usar Cada Ferramenta

```
RCT → CONSORT (report) + RoB 2 (qualidade)
Coorte → STROBE (report) + Newcastle-Ottawa ou ROBINS-I (qualidade)
Caso-controle → STROBE (report) + Newcastle-Ottawa (qualidade)
Revisao sistematica → PRISMA (report) + AMSTAR-2 (qualidade)
Meta-analise obs. → MOOSE (report)
Diagnostico → STARD (report) + QUADAS-2/3 (qualidade)
Guideline → AGREE II (qualidade)
Relato de caso → CARE (report)
```

Tabelas completas de ferramentas: `REFERENCE.md`

## Analise Critica (CASP-like)

Para cada paper analisar: validade interna (design, randomizacao, blinding,
follow-up, ITT), resultados (IC 95%, NNT/NNH, RR/OR/HR, significancia
clinica vs estatistica), aplicabilidade (populacao, disponibilidade, risco/beneficio).

## Formato de Output (PICO)

```
### Pergunta Clinica (PICO)
- P (Paciente): ...
- I (Intervencao): ...
- C (Comparador): ...
- O (Outcome): ...

### Evidencias → Nivel → Sintese → Recomendacao
```

## Workflow: Paper → Notion

1. Input → 2. Busca (PubMed MCP + Perplexity) → 3. Triagem por evidencia →
4. Selecao de ferramenta → 5. Extracao PICO → 6. Critica (CASP + ferramenta) →
7. GRADE → 8. Sintese → 9. Notion (template formatado)

## Regras

- Sempre citar com PMID e DOI
- Nunca fornecer diagnostico ou prescricao
- Registrar custo no BudgetTracker
- Notion writes: seguir `.claude/rules/mcp_safety.md`
- Conclusoes criticas: cross-validation (Claude + ChatGPT 5.4)
