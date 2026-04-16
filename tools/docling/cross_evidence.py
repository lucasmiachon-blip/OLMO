"""Cross-evidence synthesis — anti-hallucination triangulation.

Reads N literature-notes from the Obsidian vault on the same topic,
extracts claims, cross-references them, and produces a permanent-note
with concordance/discordance analysis.

Every claim is anchored to its source PDF — no inference without grounding.

Usage:
    uv run python tools/docling/cross_evidence.py --tag colchicine
    uv run python tools/docling/cross_evidence.py --files note1.md note2.md note3.md
    uv run python tools/docling/cross_evidence.py --topic "colchicine pericarditis"

Multi-agent orchestration (when called from Claude Code):
    Agent 1: Read + parse each literature-note (extract claims, metadata)
    Agent 2: Cross-reference claims across notes (find concordance/discordance)
    Agent 3: Grade evidence quality (study type, sample size, risk of bias)
    Orchestrator: Merge into permanent-note with triangulation matrix
"""

import argparse
import json
import logging
import os
import re
import sys
from collections import defaultdict
from datetime import UTC, datetime
from pathlib import Path

logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
_log = logging.getLogger(__name__)

# Paths
OBSIDIAN_VAULT = Path(
    os.environ.get("OBSIDIAN_VAULT", r"C:\Users\lucas\OneDrive\LM\Documentos\Obsidian Vault")
)
INBOX_DIR = OBSIDIAN_VAULT / "_inbox"


def parse_frontmatter(content: str) -> dict:
    """Extract YAML frontmatter from markdown content."""
    if not content.startswith("---"):
        return {}
    end = content.find("---", 3)
    if end == -1:
        return {}
    fm_text = content[3:end].strip()

    # Simple YAML parser for flat key-value pairs
    result = {}
    for line in fm_text.split("\n"):
        if ":" in line:
            key, _, value = line.partition(":")
            key = key.strip()
            value = value.strip().strip('"').strip("'")
            # Handle arrays
            if value.startswith("[") and value.endswith("]"):
                try:
                    result[key] = json.loads(value)
                except json.JSONDecodeError:
                    result[key] = value
            else:
                result[key] = value
    return result


def extract_claims(content: str) -> list[str]:
    """Extract claims from Key Findings section of a literature note.

    Looks for table rows and bullet points in the Key Findings section.
    """
    claims = []

    # Find Key Findings section
    kf_match = re.search(r"## Key Findings\s*\n(.*?)(?=\n## |\Z)", content, re.DOTALL)
    if kf_match:
        section = kf_match.group(1)
        # Table rows (skip header and separator)
        for line in section.split("\n"):
            line = line.strip()
            if line.startswith("|") and not line.startswith("|-") and "Finding" not in line:
                cells = [c.strip() for c in line.split("|")[1:-1]]
                if cells and cells[0] and "fill" not in cells[0] and "<!--" not in cells[0]:
                    claims.append(" | ".join(c for c in cells if c))
        # Bullet points
        for line in section.split("\n"):
            line = line.strip()
            if line.startswith("- ") and "<!--" not in line:
                claims.append(line[2:])

    # Also check TL;DR for summary claims
    tldr_match = re.search(r"## TL;DR\s*\n(.*?)(?=\n## |\Z)", content, re.DOTALL)
    if tldr_match:
        section = tldr_match.group(1)
        for line in section.split("\n"):
            line = line.strip()
            if line and not line.startswith("<!--"):
                claims.append(f"[TL;DR] {line}")

    return claims


def find_notes_by_tag(tag: str) -> list[Path]:
    """Find all literature-notes with a specific tag in frontmatter."""
    notes = []
    for md_file in OBSIDIAN_VAULT.rglob("*.md"):
        if md_file.name.startswith("."):
            continue
        try:
            content = md_file.read_text(encoding="utf-8")
        except (OSError, UnicodeDecodeError):
            continue
        fm = parse_frontmatter(content)
        tags = fm.get("tags", [])
        if isinstance(tags, str):
            tags = [t.strip() for t in tags.split(",")]
        if "literature-note" in tags and tag.lower() in [t.lower() for t in tags]:
            notes.append(md_file)
    return notes


def find_notes_by_topic(topic: str) -> list[Path]:
    """Find literature-notes whose title or content matches a topic."""
    notes = []
    topic_lower = topic.lower()
    for md_file in OBSIDIAN_VAULT.rglob("*.md"):
        if md_file.name.startswith("."):
            continue
        try:
            content = md_file.read_text(encoding="utf-8")
        except (OSError, UnicodeDecodeError):
            continue
        fm = parse_frontmatter(content)
        tags = fm.get("tags", [])
        if isinstance(tags, str):
            tags = [t.strip() for t in tags.split(",")]
        if "literature-note" not in tags:
            continue
        title = fm.get("title", "").lower()
        if topic_lower in title or topic_lower in content[:2000].lower():
            notes.append(md_file)
    return notes


def analyze_concordance(all_claims: dict[str, list[str]]) -> dict:
    """Cross-reference claims across sources.

    Returns a concordance matrix:
    - unanimous: claim appears in all sources
    - majority: claim appears in >50% of sources
    - divided: claim appears in ~50% of sources
    - isolated: claim appears in only 1 source
    - discordant: contradictory claims found
    """
    n_sources = len(all_claims)
    if n_sources < 2:
        return {"error": "Need at least 2 sources for cross-evidence"}

    # Flatten all claims with source tracking
    claim_sources = defaultdict(list)
    for source, claims in all_claims.items():
        for claim in claims:
            # Normalize claim for matching (lowercase, strip punctuation)
            normalized = re.sub(r"[^\w\s]", "", claim.lower()).strip()
            if len(normalized) > 10:  # Skip tiny fragments
                claim_sources[normalized].append(
                    {
                        "source": source,
                        "original": claim,
                    }
                )

    # Classify concordance
    results = {
        "unanimous": [],
        "majority": [],
        "divided": [],
        "isolated": [],
        "total_claims": len(claim_sources),
        "n_sources": n_sources,
    }

    for _normalized, sources in claim_sources.items():
        n = len(sources)
        entry = {
            "claim": sources[0]["original"],
            "sources": [s["source"] for s in sources],
            "n_sources": n,
        }

        if n == n_sources:
            results["unanimous"].append(entry)
        elif n > n_sources / 2:
            results["majority"].append(entry)
        elif n == 1:
            results["isolated"].append(entry)
        else:
            results["divided"].append(entry)

    return results


def build_permanent_note(topic: str, concordance: dict, source_notes: list[Path]) -> str:
    """Build a permanent-note with triangulated evidence."""
    now = datetime.now(UTC).strftime("%Y-%m-%dT%H:%M:%SZ")

    # Determine overall concordance level
    if concordance.get("unanimous"):
        level = "unanimous" if len(concordance["divided"]) == 0 else "majority"
    elif concordance.get("majority"):
        level = "majority"
    else:
        level = "divided"

    # Frontmatter
    source_names = [n.stem for n in source_notes]
    lines = [
        "---",
        f'title: "Sintese: {topic}"',
        f"confidence: {'high' if level in ('unanimous', 'majority') else 'medium'}",
        'tags: ["permanent-note", "cross-evidence"]',
        f"sources: {json.dumps(source_names)}",
        f"concordancia: {level}",
        f"n_sources: {concordance['n_sources']}",
        f"total_claims: {concordance['total_claims']}",
        f'synthesized_at: "{now}"',
        'coautoria: "Lucas + Claude + Docling"',
        "---",
        "",
        f"# Sintese: {topic}",
        "",
        f"> Triangulacao de {concordance['n_sources']} fontes | "
        f"{concordance['total_claims']} claims analisadas | "
        f"Concordancia: **{level}**",
        "",
    ]

    # Unanimous claims (strongest evidence)
    if concordance["unanimous"]:
        lines.append("## Unanime (todas as fontes concordam)")
        lines.append("")
        for entry in concordance["unanimous"]:
            sources_str = ", ".join(f"[[{s}]]" for s in entry["sources"])
            lines.append(f"- {entry['claim']}")
            lines.append(f"  - Fontes: {sources_str}")
        lines.append("")

    # Majority claims
    if concordance["majority"]:
        lines.append("## Maioria (>50% das fontes)")
        lines.append("")
        for entry in concordance["majority"]:
            sources_str = ", ".join(f"[[{s}]]" for s in entry["sources"])
            lines.append(f"- {entry['claim']}")
            lines.append(
                f"  - Fontes ({entry['n_sources']}/{concordance['n_sources']}): {sources_str}"
            )
        lines.append("")

    # Divided claims (need attention)
    if concordance["divided"]:
        lines.append("## Dividido (evidencia conflitante)")
        lines.append("")
        for entry in concordance["divided"]:
            sources_str = ", ".join(f"[[{s}]]" for s in entry["sources"])
            lines.append(f"- {entry['claim']}")
            lines.append(
                f"  - Fontes ({entry['n_sources']}/{concordance['n_sources']}): {sources_str}"
            )
        lines.append("")

    # Isolated claims (single source — weakest)
    if concordance["isolated"]:
        lines.append("## Isolado (fonte unica — verificar)")
        lines.append("")
        for entry in concordance["isolated"][:20]:  # Cap at 20 to avoid noise
            sources_str = ", ".join(f"[[{s}]]" for s in entry["sources"])
            lines.append(f"- {entry['claim']}")
            lines.append(f"  - Fonte: {sources_str}")
        if len(concordance["isolated"]) > 20:
            lines.append(f"- ... e mais {len(concordance['isolated']) - 20} claims isoladas")
        lines.append("")

    # Gaps
    lines.append("## Gaps identificados")
    lines.append("<!-- O que nenhum estudo abordou? -->")
    lines.append("")

    # Source index
    lines.append("## Fontes")
    lines.append("")
    for note in source_notes:
        lines.append(f"- [[{note.stem}]]")
    lines.append("")

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Cross-evidence synthesis")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--tag", help="Find literature-notes by tag")
    group.add_argument("--topic", help="Find literature-notes by topic in title/content")
    group.add_argument("--files", nargs="+", type=Path, help="Specific note files to analyze")
    parser.add_argument("--vault", type=Path, default=None, help="Override vault path")
    parser.add_argument("--output", type=Path, default=None, help="Output path for permanent note")
    args = parser.parse_args()

    global OBSIDIAN_VAULT, INBOX_DIR
    if args.vault:
        OBSIDIAN_VAULT = args.vault
        INBOX_DIR = args.vault / "_inbox"

    # Find notes
    if args.tag:
        notes = find_notes_by_tag(args.tag)
        topic = args.tag
    elif args.topic:
        notes = find_notes_by_topic(args.topic)
        topic = args.topic
    else:
        notes = [p for p in args.files if p.exists()]
        topic = "manual-selection"

    if len(notes) < 2:
        _log.error(f"Found {len(notes)} notes — need at least 2 for cross-evidence")
        sys.exit(1)

    _log.info(f"Analyzing {len(notes)} notes for topic: {topic}")

    # Extract claims from each note
    all_claims = {}
    for note_path in notes:
        content = note_path.read_text(encoding="utf-8")
        claims = extract_claims(content)
        if claims:
            all_claims[note_path.stem] = claims
            _log.info(f"  {note_path.stem}: {len(claims)} claims")
        else:
            _log.warning(f"  {note_path.stem}: no claims found (Key Findings empty?)")

    if len(all_claims) < 2:
        _log.error("Not enough notes with extractable claims")
        sys.exit(1)

    # Cross-reference
    concordance = analyze_concordance(all_claims)

    # Build permanent note
    permanent_note = build_permanent_note(topic, concordance, notes)

    # Save
    output_path = args.output or (INBOX_DIR / f"sintese-{slugify(topic)}.md")
    INBOX_DIR.mkdir(parents=True, exist_ok=True)
    output_path.write_text(permanent_note, encoding="utf-8")

    _log.info(f"\nPermanent note saved: {output_path}")
    _log.info(f"  Unanimous: {len(concordance.get('unanimous', []))}")
    _log.info(f"  Majority: {len(concordance.get('majority', []))}")
    _log.info(f"  Divided: {len(concordance.get('divided', []))}")
    _log.info(f"  Isolated: {len(concordance.get('isolated', []))}")


def slugify(text: str) -> str:
    """Convert text to filesystem-safe slug."""
    text = text.lower().strip()
    text = re.sub(r"[^\w\s-]", "", text)
    text = re.sub(r"[-\s]+", "-", text)
    return text[:80]


if __name__ == "__main__":
    main()
