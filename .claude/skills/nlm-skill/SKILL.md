---
name: nlm-skill
disable-model-invocation: true
description: "NotebookLM CLI guide for medical education. OAuth required."
version: "1.0.0"
---

# NotebookLM for Medical Education

## Tool Selection

- **CLI only**: use `nlm` commands via Bash. MCP frozen S128 — CLI e o unico caminho.
- OAuth obrigatorio: `! nlm login` antes de qualquer comando.

## Critical Rules

1. **OAuth PRIMEIRO — ANTES de qualquer comando NLM**: Pedir ao usuario `! nlm login` (sessao ~20min). Se expirar: `! nlm login` novamente. NUNCA tentar queries sem auth — falha silenciosa. Em Windows: `PYTHONIOENCODING=utf-8 nlm login` se encoding falhar.
2. **`--confirm` required**: every generation and delete command needs `--confirm` or `-y`.
3. **NEVER `nlm chat start`**: it opens an interactive REPL. Use `nlm notebook query` for one-shot Q&A.
4. **ASK user before delete**: deletions are irreversible. Show what will be deleted.
5. **Capture IDs**: create/start commands return IDs needed for subsequent operations (poll status, download).
6. **Use aliases**: `nlm alias set <name> <uuid>` to avoid repeating long UUIDs.
7. **Windows encoding**: CLI output may crash on cp1252. Use `--json` for reliable parsing or set `PYTHONIOENCODING=utf-8`.

---

## Workflow 1: Paper to Study Materials

Complete pipeline for ingesting medical papers and generating concurso study materials.

```bash
# 1. Create notebook + alias
nlm notebook create "HRS Concurso"
nlm alias set hrs <notebook-id>

# 2. Add papers via PubMed URLs (pattern: https://pubmed.ncbi.nlm.nih.gov/{PMID}/)
nlm source add hrs --url "https://pubmed.ncbi.nlm.nih.gov/34233093/" --wait
nlm source add hrs --url "https://pubmed.ncbi.nlm.nih.gov/34388394/" --wait
nlm source add hrs --url "https://doi.org/10.1016/j.jhep.2023.04.001" --wait

# 3. Generate study materials with CLINICAL focus prompts
nlm quiz create hrs --count 10 --difficulty 3 --focus "Criterios diagnosticos ICA-AKI, fisiopatologia reflexo hepatorrenal, manejo primeira linha terlipressina+albumina, endpoints primarios CONFIRM e ATTIRE" --confirm
nlm flashcards create hrs --difficulty medium --focus "Numeros-chave: NNT, mortalidade, taxas de resposta, IC 95% dos trials CONFIRM e ATTIRE" --confirm
nlm audio create hrs --format deep_dive --confirm

# 4. Check status + download
nlm studio status hrs          # wait for "completed"
nlm download audio hrs --output hrs-podcast.mp3
nlm download quiz hrs --format html --output hrs-quiz.html
```

**Key**: `--focus` must contain clinical terminology specific to the topic — not generic "Exam prep". This dramatically improves quiz/flashcard quality.

**Source types**: URLs, YouTube (`--url`), pasted text (`--text --title`), local files (`--file`), Google Drive (`--drive <doc-id>`).

---

## Workflow 2: Research to Deep Study

Discover sources, study, and synthesize — the NLM research pipeline.

```bash
# 1. Create + alias
nlm notebook create "TIPS Deep Dive"
nlm alias set tips <notebook-id>

# 2. Deep research (~5min, ~40-80 sources)
nlm research start "TIPS transjugular intrahepatic portosystemic shunt indications contraindications survival" --notebook-id tips --mode deep

# 3. WAIT for completion (critical — do not skip)
nlm research status tips --max-wait 300

# 4. Import discovered sources
nlm research import tips <task-id>

# 5. Generate Study Guide (exact string: "Study Guide" — capital S, capital G, with space)
nlm report create tips --format "Study Guide" --confirm

# 6. One-shot Q&A (NOT chat start)
nlm notebook query tips "Quais as contraindicacoes absolutas vs relativas do TIPS segundo AASLD?"

# 7. Audio debate for passive review
nlm audio create tips --format debate --confirm
nlm studio status tips          # poll until completed
```

**Research modes**: `fast` (~30s, ~10 sources) | `deep` (~5min, ~40+ sources, web only).
**Report formats**: `"Briefing Doc"`, `"Study Guide"`, `"Blog Post"`, `"Create Your Own"` (needs `--prompt`).

---

## Workflow 3: Batch Concurso Prep

Multi-specialty notebooks with batch operations and cross-notebook queries.

```bash
# 1. Tag notebooks by specialty
nlm tag add hepato --tags "concurso,r3,2026,hepato"
nlm tag add cardio --tags "concurso,r3,2026,cardio"
nlm tag add nefro  --tags "concurso,r3,2026,nefro"

# 2. Batch add source to ALL tagged notebooks
nlm batch add-source --url "https://www.nejm.org/doi/full/10.1056/NEJMra2310713" --tags "concurso" --confirm

# 3. Batch generate flashcards across all
nlm batch studio --type flashcards --tags "concurso" --confirm

# 4. Cross-notebook comparative query
nlm cross query "Compare o manejo de hipertensao portal entre especialidades" --tags "concurso"

# 5. Targeted single-notebook query
nlm notebook query hepato "Quais as indicacoes de TIPS na ascite refrataria?"
```

**Batch actions**: `query`, `add-source`, `create`, `delete`, `studio`. Select by `--notebooks`, `--tags`, or `--all`.

---

## OLMO Ecosystem Integration

| Tool/Skill | Integration with NLM |
|------------|---------------------|
| `/research` | Feed evidence sources into NLM notebooks for deep study after PubMed discovery |
| `/concurso` | NLM flashcards complement Anki spaced repetition. Download `--format json` for Anki import pipeline |
| `/exam-generator` | Alternative to NLM quiz — anti-cue protocol + NBME calibration. Use both, compare |
| Zotero | Export library items as URLs → `nlm source add --url` for NLM ingestion |
| `/evidence` | After `/evidence` finds PMIDs, batch-add to NLM: `nlm source add <nb> --url "https://pubmed.ncbi.nlm.nih.gov/{PMID}/"` |
| `/knowledge-ingest` | Transforms any source → Obsidian note + NLM commands. The primary `raw → NLM` pipeline entry point |
| `/dream` | NLM study insights feed back into wiki via Dream consolidation (`NLM → wiki` path) |
| Obsidian | Wiki pages with [[wikilinks]] render in Obsidian graph view (`wiki → obsidian` path) |

### Knowledge Pipeline DAG (S113)

```
external harvest (via $OLMO_INBOX) ──→ NLM study ──→ wiki pages ──→ Obsidian graph
raw sources ────────────────────→ wiki pages ──→ Obsidian graph
```

**External harvest → NLM path**: After an external evidence harvest session (producer-agnostic per ADR-0002):
1. Collect PMIDs from `evidence-harvest-S*.md`
2. Batch-add to NLM notebook: `nlm source add <nb> --url "https://pubmed.ncbi.nlm.nih.gov/{PMID}/" --wait`
3. Generate deep dive: `nlm audio create <nb> --format deep_dive --confirm`
4. Study insights from NLM → Dream consolidates into wiki topic files

---

## Command Quick Reference

| Action | CLI |
|--------|-----|
| Authenticate | `nlm login` |
| List notebooks | `nlm notebook list` |
| Create notebook | `nlm notebook create "Title"` |
| Add URL source | `nlm source add <nb> --url "URL" --wait` |
| Add text source | `nlm source add <nb> --text "..." --title "T"` |
| Add local file | `nlm source add <nb> --file path.pdf --wait` |
| List sources | `nlm source list <nb>` |
| One-shot Q&A | `nlm notebook query <nb> "question"` |
| Research (deep) | `nlm research start "q" --notebook-id <nb> --mode deep` |
| Research status | `nlm research status <nb> --max-wait 300` |
| Import sources | `nlm research import <nb> <task-id>` |
| Generate content | `nlm <type> create <nb> --confirm` |
| Check artifacts | `nlm studio status <nb>` |
| Download | `nlm download <type> <nb> --output file` |
| Set alias | `nlm alias set <name> <uuid>` |
| Batch operations | `nlm batch <action> --tags "..." --confirm` |
| Cross-query | `nlm cross query "Q" --tags "..."` |
| Tag notebooks | `nlm tag add <nb> --tags "t1,t2"` |

---

## Content Generation Options

| Type | CLI Command | Key Flags | Gotchas |
|------|-------------|-----------|---------|
| Audio/Podcast | `nlm audio create` | `--format` deep_dive/brief/critique/debate, `--length` short/default/long | 1-5 min generation |
| Report | `nlm report create` | `--format` "Briefing Doc"/"Study Guide"/"Blog Post"/"Create Your Own" | Exact string required (case-sensitive) |
| Quiz | `nlm quiz create` | `--count N --difficulty 1-5 --focus "..."` | Default: 2 questions, difficulty 2 |
| Flashcards | `nlm flashcards create` | `--difficulty` easy/medium/hard `--focus "..."` | Default: medium |
| Mind Map | `nlm mindmap create` | `--title "..."` | |
| Slides | `nlm slides create` | `--format` detailed_deck/presenter_slides, `--length` short/default | Revise: `nlm slides revise <artifact-id> --slide '1 instruction'` |
| Infographic | `nlm infographic create` | `--orientation` L/P/S, `--detail` concise/standard/detailed | Multiple styles available |
| Video | `nlm video create` | `--format` explainer/brief, `--style` whiteboard/classic/etc | 1-5 min generation |
| Data Table | `nlm data-table create` | `"description"` (required 2nd arg) | Description is positional |

**Common flags**: `--confirm` (required), `--source-ids id1,id2` (limit sources), `--language en/pt-BR` (BCP-47), `--focus "topic"`.

---

## Error Recovery

| Error | Fix |
|-------|-----|
| "Cookies have expired" / auth errors | `nlm login` |
| "Notebook not found" | `nlm notebook list` to get correct ID |
| "Research already in progress" | `--force` flag or import first |
| Rate limit exceeded | Auto-retried 3x with backoff. Wait 30s if persists |
| Server 500/502/503 | Auto-retried. Wait and retry if persists |
| Import timed out | `--timeout 600` for large source sets |
| cp1252 encoding crash (Windows) | `PYTHONIOENCODING=utf-8` or `--json` |
| `nlm --ai` crashes | Known Windows bug (non-ASCII chars). Use `PYTHONIOENCODING=utf-8 nlm --ai` |

---

## Detailed Reference

For complete command syntax, all flags, sharing, config, pipelines, and verb-first alternatives: see `reference.md` in this directory or run `nlm <command> --help`.
