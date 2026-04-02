# Design Reference — Semântica, Dados Médicos

> Apenas o que NÃO está no código. Tokens/tipografia/spacing → `content/aulas/cirrose/cirrose.css` (seção :root).
> Princípios de design (27) → `docs/aulas/design-principles.md` (consultar sob demanda).

---

## 1. Semântica de Cor

Cores clínicas ≠ UI. ΔL ≥ 10% entre safe/warning/danger. Ícone obrigatório: ✓ ⚠ ✕ ↓.

| Token | Significado clínico | Uso |
|-------|---------------------|-----|
| `--safe` | Manter conduta | Resultado favorável, meta atingida |
| `--warning` | Investigar/monitorar | Zona cinza, requer acompanhamento |
| `--danger` | Intervir agora | Risco real: morte, sangramento, falência |
| `--downgrade` | Rebaixar evidência | Limitação, caveat (sempre com ↓) |
| `--ui-accent` | Chrome/UI | Progresso, tags, decoração — NUNCA clínico |

HEX é verdade. Se OKLCH divergir, HEX vence. Paleta de dados: Tol (daltonism-safe).

### Hierarquia Semântica Intra-Slide (E073, E074, E075)

- **Punchline > Suporte:** O elemento culminante do argumento DEVE ter tratamento visual superior (cor elevada, tamanho/peso maior, ou ambos). Mesma cor entre suportes é OK.
- **Cor semântica em texto:** Só quando o texto É o elemento semântico primário (título, punchline). Dados numéricos e labels de suporte usam `--text-primary` — o sinal vem de ícone + borda + bg.
- **Diferenciação dentro da mesma cor:** Usar peso visual (outline vs filled vs punchline), não mais cor. Ex: 3 tiers — outline (labels) → filled (evidência) → highlight (punchline).
- **Ícones DEVEM ter cor explícita** matching severity — nunca herdar genérico.

## 2. Tipografia — Regras (valores em cirrose.css :root)

| Regra | Detalhe |
|-------|---------|
| Serif = autoridade | `--font-display` (Instrument Serif) para títulos |
| NUNCA peso 300 em projetor | Mínimo 400 para corpo |
| tabular-nums lining-nums | Em dados numéricos |
| `font-display: swap` | Obrigatório. WOFF2 em `shared/assets/fonts/` |
| NUNCA `vw` sem `clamp()` | `scaleDeck()` + vw = overflow (E52) |

## 3. Dados Médicos

### Princípio Absoluto
**NUNCA inventar, estimar ou usar de memória** dado numérico médico. Sem fonte → `[TBD]`.
**País-alvo padrão:** Brasil.

### Checklist E21 — antes de QUALQUER dado em slide
- [ ] Valor vem de paper (não memória)?
- [ ] Paper verificado via PubMed/WebSearch?
- [ ] Time frame explícito?
- [ ] NNT com IC 95% e time frame?
- [ ] Se guideline: leu a guideline, não extrapolou?

### Formato NNT
```
NNT [valor] (IC 95%: [lower]–[upper]) em [tempo] | [população]
```
Hierarquia: **NNT > ARR > HR**. NNT=decisão (hero, --safe). HR=acadêmico (menor destaque).

### Regras
- **PMIDs:** NUNCA usar PMID de LLM sem verificar em PubMed. Marcar `[CANDIDATE]` até verificado. Taxa de erro observada: **56% (5/9)** — é frequente, não excepcional (Meta E011).
- **Propagação:** Ao corrigir PMID/dado: `grep -rn "VALOR_ANTIGO" content/aulas/{aula}/`. Atualizar TODOS no mesmo batch. evidence-db é canônico.
- **Verificação PMID:** Confirmar author + title + patient count. PMID errado pode ser de paper similar (mesmo journal, tema próximo).
- **População:** Verificar população do trial. Prevenção 1ª ≠ 2ª. Trial de pop A ≠ hero de slide pop B.
- **HR ≠ RR (E25):** HR = trial isolado. RR = meta-análise. NUNCA misturar.
- **Speaker notes:** `[DATA] Fonte: EASL 2024, Tab.3 | Verificado: 2026-02-12`

### Vocabulário de Verificação (canônico)

| Status | Significado | Quando usar |
|--------|------------|-------------|
| `VERIFIED` | PubMed MCP confirmou (author + title + patient count match) | Fonte ideal. Requer MCP funcional |
| `WEB-VERIFIED` | PubMed web ou WebSearch confirmou (MCP indisponível) | Fallback aceitável para reports |
| `CANDIDATE` | Não verificado — gerado por LLM, aguardando verificação | NUNCA em report final ou slide projetado |
| `SECONDARY` | Confirmado por 2+ fontes independentes | Cross-referência adicional |
| `UNRESOLVED` | Fontes discordam — flagged para revisão humana | Requer decisão do Lucas |

### Conteúdo — Permitido vs Proibido
**OK:** Reduzir texto mantendo significado, reorganizar hierarquia, adicionar de fontes verificadas, remover drogas não disponíveis no Brasil.
**PROIBIDO:** Inventar dados/referências, modificar números sem fonte, extrapolar entre estudos.

### Diagnostic Tool Framing
Frame: "Recebi este resultado. Quais condições no MEU paciente tornam este número não confiável?"
Anti-padrão: "Este é um escore que mede a rigidez hepática dividindo..."

### Fontes Tier 1 — Hepatologia

| Fonte | Tipo | ID |
|-------|------|----|
| BAVENO VII | Consenso HP | DOI:10.1016/j.jhep.2021.12.012 |
| EASL Cirrose 2024 | CPG | DOI: TBD |
| AASLD Varizes 2024 | Practice Guidance | DOI: TBD |
| PREDESCI | RCT | PMID:30910320 |
| CONFIRM | RCT | PMID:33657294 |
| ANSWER | RCT | PMID:29861076 |
| D'Amico 2006 | Systematic review | PMID:16298014 |

## 4. Color Safety — OKLCH & color-mix()

> Fonte: Cirrose E059, E072, E073

### Armadilhas

- **color-mix() com endpoint acromático** (hue=0) interpola hue pelo caminho mais curto → salmon/coral inesperado em vez de cinza neutro. NUNCA confiar em `var(--safe-light)` para backgrounds neutros (E059).
- **CSS Color 5** (`oklch(from var(--token) l c h / alpha)`) = relative color syntax, suporte limitado. Usar **color-mix() (Color 4)** para derivações de cor (E072).

### Constraints de Token

| Token | Constraint | Razão |
|-------|-----------|-------|
| `--danger` root | hue ≤ 10°, chroma ≥ 0.20 | hue 25° = terracotta, não vermelho (E073) |
| Severity bg (cards, zones) | 25-40% color-mix | -light tokens (15%) = invisível em projeção a 6m |
| Severity text | `--text-primary` para dados | Sinal vem de ícone+borda+bg, não do texto |

### Regra Geral
HEX é verdade de renderização. Se OKLCH divergir do HEX pretendido, ajustar OKLCH para match.
