# Decision Protocol — Lucas ↔ Agentes

> Protocolo para decisões não-triviais sobre slides.
> Agente propõe → Lucas decide → decisão registrada.
> Coautoria: ver `shared/coautoria.md`

---

## Quando usar

- Mudança de h2 (assertion) de slide crítico
- Reordenação de slides no `_manifest.js`
- Alteração de dados clínicos (NNT, HR, dose, PMID)
- Qualquer mudança que afete 3+ slides em cascata
- Remoção de callback narrativo ou elemento estrutural

## Formato da proposta (agente → Lucas)

```
## DR-NNN: [título curto]

**Slide(s):** s-xxx, s-yyy
**Estado:** PROPOSTA | APROVADO | REJEITADO | ALTERNATIVA

### Proposta
[O que o agente quer fazer, em 2-3 frases]

### Justificativa
[Por que — referência a narrative.md, evidence-db.md, ou princípio de design]

### Trade-off
[O que se perde se fizer. O que se perde se NÃO fizer.]

### Alternativa
[Opção B, se houver]
```

## Resposta (Lucas → agente)

| Estado | Significado | Ação do agente |
|--------|-------------|----------------|
| AGREE | Prosseguir como proposto | Implementar e registrar em CHANGELOG |
| DISAGREE | Não fazer | Registrar razão em CHANGELOG, não implementar |
| RISK | Preocupação específica | Agente mitiga o risco e re-propõe |
| BETTER OPTION | Lucas propõe alternativa | Agente implementa a alternativa |

## Registro

Decisões aprovadas vão para CHANGELOG.md com prefixo `[DR-NNN]`.
Decisões rejeitadas ficam em CHANGELOG como lição aprendida.

## Escopo

Este protocolo **não** se aplica a:
- Fixes de lint, CSS, build (agente faz direto)
- Atualização de speaker notes (append-only)
- Correções factuais com PMID verificado
- Ajustes cosméticos sem impacto no conteúdo

Para esses, o agente age e commita normalmente.

## See also

- Regras de edição de slides → `.claude/rules/slide-rules.md`
- Disclosure AI → `shared/coautoria.md`
- Docs por aula: `{aula}/references/narrative.md`, `{aula}/references/evidence-db.md`
