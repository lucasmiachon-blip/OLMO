# PENDENCIAS - O Que Falta Para Rodar

> Checklist de setup. Atualizado: 29 de Marco de 2026

## MCPs (16 configurados)

### Conectados (13)
- [x] **Notion** — OAuth, connected
- [x] **PubMed** — claude.ai nativo, connected
- [x] **SCite** — assinatura ativa, connected
- [x] **Consensus** — assinatura ativa, connected
- [x] **Scholar Gateway** — connected
- [x] **Perplexity** — API key configurada, connected
- [x] **Gemini** — npx @rlabs-inc/gemini-mcp, connected
- [x] **NotebookLM** — npx notebooklm-mcp@latest, connected
- [x] **Zotero** — uvx zotero-mcp, local mode (Zotero app precisa estar aberto)
- [x] **Excalidraw** — connected
- [x] **Gmail** — claude.ai nativo, connected (sessao 15)
- [x] **Google Calendar** — claude.ai nativo, connected (sessao 15)
- [x] **Canva** — connected (sessao 15)

### Planejados (3)
- [ ] **Google Drive** — `@piotr-agier/google-drive-mcp` (requer Google Cloud Console OAuth)
- [ ] **ChatGPT 5.4 MCP** — cross-validator para Notion writes
- [ ] **Anki MCP** — `@ankimcp/anki-mcp-server` (requer Anki Desktop + AnkiConnect)

## FERRAMENTAS JA TEM

- [x] Perplexity Max
- [x] Excalidraw
- [x] Canva Pro
- [x] Google One Ultra 30TB (Drive + Gemini)
- [x] Claude Max (Opus 4.6)
- [x] Scite.ai (assinatura)
- [x] Consensus (assinatura)
- [x] Zotero (desktop)
- [x] Obsidian (vault local)

## WORKFLOW DE PESQUISA

```
Artigos → Zotero (biblioteca) + NotebookLM (estudo profundo)
Busca   → PubMed + Scholar + Perplexity (discovery)
Validar → SCite + Consensus (smart citations, consenso)
Sintese → Claude Opus (excerpts, nunca full-text no contexto)
Output  → Notion / Obsidian / Anki
```

Regra: **nunca** ler PDF inteiro no contexto do Claude. Usar MCPs.

## CONCURSO R3 CLINICA MEDICA DEZ/2026 (120 questoes) — PRIORIDADE DO ANO

> Foco total a partir de maio/2026. Ate la, housekeeping aulas + preparar terreno.
> R3 Clinica Medica — so especialidades clinicas (sem cirurgia).
> Fontes: provas reais de bancas + SAPs (MKSAP, outros SAPs de especialidade).

### Proximo Passo Concreto
- [ ] **Instalar AnkiConnect** — Anki Desktop > Tools > Add-ons > 2055492159
- [ ] **Configurar Anki MCP** — `npx -y @ankimcp/anki-mcp-server --stdio` (v0.15.0, 18 tools)
- [ ] **Colocar provas reais em `assets/provas/`** — PDFs de bancas R3 para analise de padroes
- [ ] **Colocar SAPs em `assets/sap/`** — MKSAP e outros SAPs de especialidade

### Pipeline: Provas + SAPs → Questoes Calibradas
```
Provas reais + SAPs (PDF) → Analise de padroes (formato, temas, dificuldade)
→ Topicos errados → Gerar questoes no mesmo formato (anti-cue protocol)
→ Anki cards (spaced repetition) → Error log → Revisao dirigida
```

### Backlog
- [ ] Primeiro simulado baseline (120 questoes cronometrado)
- [ ] Plano macro Mai-Dez no Notion (fases: fundacao → consolidacao → sprint final)
- [ ] Criar decks Anki por especialidade clinica (Gastro, Hepato, Cardio, Pneumo, Nefro, etc.)
- [ ] NotebookLM: notebooks por tema de estudo

## AULAS CONGELADAS (migrar em sessao futura)

- **Metanalise** — 18 slides, deck.js, branch `feat/metanalise-mvp` (wt-metanalise)
- **Osteoporose** — 70 slides, Reveal.js (frozen), repo `aulas-magnas`. Decidir formato.

## ENSINO

- [x] ~~Aulas infra~~ — npm install + vite dev + build cirrose validados (sessao 24)
- [ ] Database Notion "Teaching Log"
- [ ] Curriculo "AI para Alunos de Medicina" (8 aulas)
- [x] ~~Split teaching-improvement~~ → teaching + concurso + ai-fluency (sessao 15)

## INFRA

- [x] ~~Haiku 3 aposentadoria~~ — config ja usa `claude-haiku-4-5` em todos os lugares
- [ ] BudgetTracker ativar (SQLite)
- [ ] claude-task-master (MCP GTD)
- [ ] n8n self-hosted (automacao 24/7)
- [ ] Cowork Skills: Extrair UpToDate, DynaMed, BMJ Best Practice

## CUSTO MENSAL

| Item | Custo/mes |
|------|----------|
| Claude Max (Opus 4.6) | incluso no plano |
| Perplexity Max | incluso no plano |
| Google One Ultra (Gemini) | incluso no plano |
| Scite + Consensus | ~$20-30 |
| Tudo mais | $0 |
| **TOTAL** | **~$20-30** (dentro do budget $100) |
