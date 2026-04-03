# nlm Complete Reference

> Detailed command syntax for all `nlm` operations. The main SKILL.md has workflows and quick reference.
> For any command: `nlm <command> --help`

## Authentication

```bash
nlm login                              # Browser-based auth (primary)
nlm login --check                      # Validate current session
nlm login --profile work               # Named profile
nlm login --provider openclaw --cdp-url http://127.0.0.1:18800  # External CDP
nlm login switch <profile>             # Switch default profile
nlm login profile list                 # List profiles with emails
nlm login profile delete <name>        # Delete profile
nlm login profile rename <old> <new>   # Rename profile

nlm auth status                        # Check current auth (real API call)
nlm auth status --profile work         # Check specific profile
nlm auth list                          # List all profiles
nlm auth delete <name> --confirm       # Delete profile
```

**Session lifetime**: ~20 minutes. Both MCP and CLI share auth backend.

**Multi-Profile**: Each profile gets isolated browser session. Switch MCP account: `nlm login switch <name>`.

**Auto-Recovery** (3-layer): CSRF refresh → token reload from disk → headless auth. Server errors auto-retried 3x with exponential backoff.

## Notebook Management

```bash
nlm notebook list                      # Rich table
nlm notebook list --json               # JSON
nlm notebook list --quiet              # IDs only
nlm notebook list --title              # "ID: Title"
nlm notebook list --full               # All columns
nlm notebook create "Title"            # Returns ID
nlm notebook get <id>                  # Details
nlm notebook get <id> --json           # JSON
nlm notebook describe <id>             # AI summary + suggested topics
nlm notebook rename <id> "New Title"   # Rename
nlm notebook delete <id> --confirm     # PERMANENT
nlm notebook query <id> "question"     # One-shot Q&A
nlm notebook query <id> "Q" --json     # JSON response
nlm notebook query <id> "Q" --conversation-id <cid>  # Follow-up (persists in web UI)
nlm notebook query <id> "Q" --source-ids <id1,id2>   # Limit to specific sources
```

**MCP equivalents**: `notebook_list`, `notebook_create`, `notebook_get`, `notebook_describe`, `notebook_query`, `notebook_rename`, `notebook_delete`.

## Source Management

```bash
# Adding sources
nlm source add <nb> --url "https://..."                 # Web page
nlm source add <nb> --url "https://youtube.com/..."     # YouTube
nlm source add <nb> --url "https://..." --wait          # Wait until processed
nlm source add <nb> --text "content" --title "Title"    # Pasted text
nlm source add <nb> --file /path/to/doc.pdf             # Local file upload
nlm source add <nb> --file doc.pdf --wait               # Upload + wait
nlm source add <nb> --drive <doc-id>                    # Drive doc (auto-detect)
nlm source add <nb> --drive <doc-id> --type slides      # Explicit type

# Supported file types: PDF, TXT, MD, DOCX, CSV, MP3, M4A, WAV, AAC, OGG, OPUS, MP4, JPG, JPEG, PNG, GIF, WEBP
# Drive types: doc, slides, sheets, pdf

# Viewing
nlm source list <nb>                   # Table
nlm source list <nb> --full            # All details
nlm source list <nb> --url             # "ID: URL"
nlm source list <nb> --drive           # Drive sources + freshness
nlm source list <nb> --drive --skip-freshness  # Faster
nlm source get <source-id>             # Metadata
nlm source get <source-id> --json      # JSON
nlm source describe <source-id>        # AI summary + keywords
nlm source content <source-id>         # Raw text
nlm source content <source-id> -o file.txt  # Export

# Drive sync
nlm source stale <nb>                  # List outdated Drive sources
nlm source sync <nb> --confirm         # Sync all stale
nlm source sync <nb> --source-ids <ids> --confirm  # Sync specific

# Rename + Delete
nlm source rename <source-id> "New Title" --notebook <nb>
nlm source delete <source-id> --confirm
```

**MCP equivalents**: `source_add`, `source_list_drive`, `source_describe`, `source_get_content`, `source_rename`, `source_sync_drive`, `source_delete`.

## Research (Source Discovery)

```bash
nlm research start "query" --notebook-id <id>                # Fast web (~30s)
nlm research start "query" --notebook-id <id> --mode deep    # Deep web (~5min)
nlm research start "query" --notebook-id <id> --source drive # Fast drive
nlm research start "query" --notebook-id <id> --force        # Override pending

nlm research status <nb>                     # Poll until done (5min max)
nlm research status <nb> --max-wait 0        # Single check
nlm research status <nb> --task-id <tid>     # Specific task
nlm research status <nb> --full              # Full details

nlm research import <nb> <task-id>                 # Import all
nlm research import <nb> <task-id> --indices 0,2,5 # Import specific
nlm research import <nb> <task-id> --timeout 600   # Extended timeout
```

**Modes**: `fast` (~30s, ~10 sources, web or drive) | `deep` (~5min, ~40-80 sources, web only).
**MCP**: `research_start`, `research_status`, `research_import`.

## Content Generation

All commands share: `--confirm` (required), `--source-ids`, `--language <BCP-47>`, `--focus "topic"`.

```bash
# Audio (1-5 min generation)
nlm audio create <nb> --confirm
nlm audio create <nb> --format deep_dive --length default --confirm
# Formats: deep_dive, brief, critique, debate | Lengths: short, default, long

# Report
nlm report create <nb> --confirm
nlm report create <nb> --format "Study Guide" --confirm
nlm report create <nb> --format "Create Your Own" --prompt "Custom..." --confirm
# Formats: "Briefing Doc", "Study Guide", "Blog Post", "Create Your Own"

# Quiz
nlm quiz create <nb> --confirm
nlm quiz create <nb> --count 10 --difficulty 3 --focus "diagnostic criteria" --confirm
# Count: N questions (default 2) | Difficulty: 1-5 (default 2)

# Flashcards
nlm flashcards create <nb> --confirm
nlm flashcards create <nb> --difficulty hard --focus "key trial numbers" --confirm
# Difficulty: easy, medium (default), hard

# Mind Map
nlm mindmap create <nb> --confirm
nlm mindmap create <nb> --title "Topic Overview" --confirm

# Slides
nlm slides create <nb> --confirm
nlm slides create <nb> --format presenter --length short --confirm
nlm slides revise <artifact-id> --slide '1 Make title larger' --confirm
# Formats: detailed_deck (default), presenter_slides | Lengths: short, default
# Revise creates NEW deck — original unchanged. Slide numbers are 1-based.

# Infographic
nlm infographic create <nb> --confirm
nlm infographic create <nb> --orientation portrait --detail detailed --style professional --confirm
# Orientations: landscape (default), portrait, square
# Detail: concise, standard (default), detailed
# Styles: auto_select, sketch_note, professional, bento_grid, editorial, instructional, bricks, clay, anime, kawaii, scientific

# Video (1-5 min generation)
nlm video create <nb> --confirm
nlm video create <nb> --format brief --style whiteboard --confirm
# Formats: explainer (default), brief
# Styles: auto_select, classic, whiteboard, kawaii, anime, watercolor, retro_print, heritage, paper_craft

# Data Table
nlm data-table create <nb> "Extract all dates and events" --confirm
# DESCRIPTION is required as second argument
```

**MCP unified**: `studio_create(artifact_type="audio|video|report|quiz|flashcards|mind_map|slide_deck|infographic|data_table", ...)`.

## Studio (Artifact Management)

```bash
nlm studio status <nb>                           # List artifacts + status
nlm studio status <nb> --full                    # Full details (incl. custom_instructions)
nlm studio status <nb> --json                    # JSON
nlm studio rename <artifact-id> "New Title"      # Rename artifact
nlm studio delete <nb> <artifact-id> --confirm   # Delete artifact
```

**Status values**: `completed` (ready), `in_progress` (generating), `failed`.
**MCP**: `studio_status`, `studio_delete`. Rename: `studio_status(action="rename")`.

## Download

```bash
nlm download audio <nb> --output podcast.mp3
nlm download audio <nb> --id <artifact-id>        # Specific artifact
nlm download video <nb> --output video.mp4
nlm download report <nb> --output report.md
nlm download mind-map <nb>
nlm download slide-deck <nb>                      # PDF (default)
nlm download slide-deck <nb> --format pptx        # PPTX
nlm download infographic <nb>
nlm download data-table <nb>

# Interactive formats (quiz, flashcards)
nlm download quiz <nb> <artifact-id> --format json       # Structured
nlm download quiz <nb> <artifact-id> --format markdown   # Human-readable
nlm download quiz <nb> <artifact-id> --format html       # Interactive browser
nlm download flashcards <nb> <artifact-id> --format html # Interactive
```

**Default filenames**: `audio_<id>.mp3`, `video_<id>.mp4`, etc. Use `--output` for custom names.
**MCP**: `download_artifact(artifact_type="...", output_path="...")`.

## Export to Google Docs/Sheets

```bash
nlm export to-docs <nb> <artifact-id>                    # Report → Google Docs
nlm export to-docs <nb> <artifact-id> --title "My Doc"   # With custom title
nlm export to-sheets <nb> <artifact-id>                  # Data Table → Sheets
```

**MCP**: `export_artifact(export_type="docs|sheets")`.

## Chat Configuration & Notes

```bash
# Configure behavior (affects both query and REPL)
nlm chat configure <nb> --goal default
nlm chat configure <nb> --goal learning_guide
nlm chat configure <nb> --goal custom --prompt "Act as a tutor..."
nlm chat configure <nb> --response-length longer   # longer, default, shorter

# Notes
nlm note create <nb> "Content" --title "Title"
nlm note list <nb>
nlm note update <nb> <note-id> --content "New content"
nlm note delete <nb> <note-id> --confirm
```

**MCP**: `chat_configure`, `note(action="create|list|update|delete")`.

## Sharing

```bash
nlm share status <nb>                        # View sharing settings
nlm share public <nb>                        # Enable public link
nlm share private <nb>                       # Disable public link
nlm share invite <nb> user@example.com       # Invite as viewer
nlm share invite <nb> user@example.com --role editor  # Invite as editor
```

**MCP**: `notebook_share_status`, `notebook_share_public`, `notebook_share_invite`.

## Aliases

```bash
nlm alias set <name> <uuid>     # Create (auto-detects type)
nlm alias get <name>            # Resolve to UUID
nlm alias list                  # List all
nlm alias delete <name>         # Remove
```

Aliases work anywhere an ID is expected: `nlm notebook get myalias`, `nlm source list myalias`.

## Batch Operations

```bash
nlm batch query "Question" --notebooks "id1,id2"
nlm batch query "Question" --tags "tag1,tag2"
nlm batch query "Question" --all
nlm batch add-source --url "URL" --notebooks "id1,id2"
nlm batch add-source --url "URL" --tags "tag"
nlm batch create "Title A, Title B, Title C"
nlm batch delete --notebooks "id1,id2" --confirm
nlm batch studio --type audio --tags "tag" --confirm
```

**MCP**: `batch(action="query|add_source|create|delete|studio", ...)`.

## Cross-Notebook Query

```bash
nlm cross query "Compare approaches" --notebooks "id1,id2"
nlm cross query "Common themes" --tags "tag1,tag2"
nlm cross query "Summarize" --all
```

Returns aggregated answers with per-notebook citations. **MCP**: `cross_notebook_query`.

## Pipelines

```bash
nlm pipeline list
nlm pipeline run <nb> ingest-and-podcast --url "URL"
nlm pipeline run <nb> research-and-report --url "URL"
nlm pipeline run <nb> multi-format   # Audio + report + flashcards
```

Built-in: `ingest-and-podcast`, `research-and-report`, `multi-format`.
Custom: YAML files in `~/.notebooklm-mcp-cli/pipelines/`.

## Tags

```bash
nlm tag add <nb> --tags "ai,research,llm"
nlm tag add <nb> --tags "ai" --title "Display Name"
nlm tag remove <nb> --tags "ai"
nlm tag list                          # All tagged notebooks
nlm tag select "ai research"          # Find by tag match
```

Tags are local. Used by `--tags` flag in batch/cross operations.

## Configuration

```bash
nlm config show                       # Current config (TOML)
nlm config show --json                # JSON
nlm config get <key>                  # Specific setting
nlm config set <key> <value>          # Update

# Keys:
# output.format   = table (default) | json
# output.color    = true (default)
# output.short_ids = true (default)
# auth.browser    = auto (default) | chrome | arc | brave | edge | chromium | vivaldi | opera
# auth.default_profile = default
```

## Diagnostics & Setup

```bash
nlm doctor                   # Diagnose installation, auth, browser, AI tools
nlm doctor --verbose         # Extra details

nlm setup list               # Show all clients + MCP status
nlm setup add claude-code    # Add MCP to Claude Code
nlm setup add all            # Auto-configure all detected tools
nlm setup remove <client>    # Remove MCP config
```

**Supported clients**: claude-code, gemini, cursor, windsurf, cline, antigravity, codex.

## Skill Management

```bash
nlm skill list               # Installation status
nlm skill install <tool>     # Install (user-level)
nlm skill install <tool> --level project  # Project-level
nlm skill update             # Update all
nlm skill update <tool>      # Update specific
nlm skill uninstall <tool>   # Remove
nlm skill show               # Display skill content
```

## Output Formats

| Flag | Description | Available on |
|------|-------------|-------------|
| (none) | Rich table | All |
| `--json` | JSON (for parsing) | list, get, describe, query, content, status |
| `--quiet` | IDs only | list |
| `--title` | "ID: Title" | notebook list |
| `--url` | "ID: URL" | source list |
| `--full` | All columns | list, status |

**Auto-detection**: When stdout is not a TTY (piping), JSON output is used automatically.

## Verb-First Alternatives

All noun-first commands have verb-first equivalents: `nlm create notebook`, `nlm list sources`, `nlm add url`, `nlm delete notebook`, etc. Both styles call the same functions. See `nlm --ai` for full verb-first reference.
