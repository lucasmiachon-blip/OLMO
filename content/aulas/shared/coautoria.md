# AI Disclosure — Template Aulas

> Transparência sobre uso de IA na produção de material didático.
> Base: ICMJE 2024-2025 (diretrizes gerais para aulas/residência).
> Para congressos: aplicar diretrizes específicas da sociedade organizadora.

---

## Princípio

IA **não é autor nem coautor** (ICMJE 2024). IA é ferramenta.
O autor (Lucas Miachon) assume responsabilidade integral por todo conteúdo clínico.

---

## Ferramentas utilizadas

| Ferramenta | Modelo | Papel |
|------------|--------|-------|
| Claude Code | Claude Opus 4.6 | Código, CSS, lint, engine, governança de dados |
| ChatGPT | GPT 5.4 Pro | Draft narrativo, arco dramático, storyboard |
| Gemini | Gemini 3.1 | Auditoria visual, screenshots, video review |
| Cursor | Claude (via IDE) | Edição interativa de slides, CSS refinement |

---

## Classificação de uso (framework SAGE)

| Categoria | Definição | Aplicação típica |
|-----------|-----------|-----------------|
| AI-assisted | Refinamento de texto humano (grammar, readability) | Edição de speaker notes |
| AI-generated | IA criou conteúdo novo (código, layout, análise) | HTML/CSS, design system, lint |
| AI as author | IA na linha de autoria | **Não — proibido por ICMJE** |

Disclosure obrigatório para conteúdo AI-generated.

---

## Contribuição por artefato (template)

> Cada aula preenche sua própria tabela em `{aula}/references/coautoria.md` ou inline.

| Artefato | Autor | IA utilizada |
|----------|-------|-------------|
| `references/narrative.md` | Lucas | [modelo] |
| `references/evidence-db.md` | Lucas | [modelo] |
| `slides/*.html` | Lucas | [modelos] |
| `{aula}.css` | Lucas + Claude | Claude (código), Lucas (spec) |

---

## Disclosure para slides

### Slide final (acknowledgments)
> **AI Disclosure:** Ferramentas de IA (Claude, ChatGPT, Gemini) auxiliaram design visual,
> código e revisão de literatura. Todo conteúdo clínico verificado e aprovado pelo autor.
> Responsabilidade integral: Lucas Miachon.

### Para congressos (quando aplicável)
Adaptar conforme diretrizes da sociedade organizadora. ICMJE é o mínimo.

---

## Referências

- ICMJE Recommendations (jan/2024, jan/2025): IA não pode ser autor; disclosure em Methods/Acknowledgments
- COPE Position Statement (2024): autores responsáveis por output de IA
- SAGE AI Author Guidelines: framework assisted vs generated vs author

## See also

- Tabela completa de membros da aliança → `docs/coauthorship_reference.md`
- Protocolo de decisões → `shared/decision-protocol.md`
- Regras globais de coautoria → `.claude/rules/coauthorship.md`
