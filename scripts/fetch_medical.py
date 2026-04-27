"""Busca em PubMed, Zotero e outras fontes medicas.

Fontes suportadas neste modulo:
- PubMed (E-utilities, gratuito, sem API key)
- Zotero (pyzotero, requer ZOTERO_API_KEY + ZOTERO_LIBRARY_ID no .env)

Outras fontes (via MCP no Cursor/Claude):
- healthcare-mcp: PubMed, FDA, ClinicalTrials, CID-10, medRxiv, NCBI Bookshelf
- pubmed-mcp: busca avancada 39M+ citacoes
- biomcp: queries em linguagem natural
- scite: Smart Citations (suporte vs contraste), full-text
- consensus: consenso cientifico (% suporte/contradicao)
"""

from __future__ import annotations

import os
import time
from dataclasses import dataclass, field

import httpx

PUBMED_BASE = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils"


@dataclass
class RefItem:
    """Referencia de paper ou item."""

    title: str
    authors: str = ""
    year: str = ""
    pmid: str = ""
    doi: str = ""
    abstract: str = ""
    source: str = ""  # pubmed, zotero
    url: str = ""
    evidence_type: str = ""  # systematic_review, meta_analysis, rct, guideline
    pub_types: list[str] = field(default_factory=list)  # PubMed pub types


def fetch_pubmed(
    query: str,
    max_results: int = 5,
    tier1_only: bool = False,
    sort_by_date: bool = False,
) -> list[RefItem]:
    """Busca no PubMed via E-utilities (gratuito, sem API key)."""
    items: list[RefItem] = []
    search_term = query
    if tier1_only:
        # Tier 1: meta-análise + revisão sistemática (Oxford CEBM top)
        tier1_filter = '("meta-analysis"[pt] OR "systematic review"[pt])'
        search_term = f"({query}) AND {tier1_filter}"
    try:
        with httpx.Client(timeout=15.0) as client:
            # ESearch
            r = client.get(
                f"{PUBMED_BASE}/esearch.fcgi",
                params={
                    "db": "pubmed",
                    "term": search_term,
                    "retmax": max_results,
                    "retmode": "json",
                    "sort": "date" if sort_by_date else "relevance",
                    "tool": "OLMO",
                    "email": "user@example.com",
                },
            )
            r.raise_for_status()
            data = r.json()
            id_list = data.get("esearchresult", {}).get("idlist", [])
            if not id_list:
                return items

            time.sleep(0.4)  # rate limit 3 req/s

            # EFetch para abstracts
            r2 = client.get(
                f"{PUBMED_BASE}/efetch.fcgi",
                params={
                    "db": "pubmed",
                    "id": ",".join(id_list),
                    "retmode": "xml",
                    "rettype": "abstract",
                    "tool": "OLMO",
                    "email": "user@example.com",
                },
            )
            r2.raise_for_status()
            import xml.etree.ElementTree as ET

            root = ET.fromstring(r2.text)

            # PubMed XML: tags podem ter namespace, usar local name
            def find_text(el: ET.Element | None, path: str) -> str:
                if el is None:
                    return ""
                for child in el.iter():
                    if child.tag.endswith(path.split("/")[-1]) or path in child.tag:
                        return "".join(child.itertext()).strip()
                sub = el.find(f".//*[local-name()='{path.split('/')[-1]}']")
                return "".join(sub.itertext()).strip() if sub is not None else ""

            for art in root.iter():
                if "PubmedArticle" not in (art.tag or ""):
                    continue
                try:
                    pmid = ""
                    for e in art.iter():
                        if "PMID" in (e.tag or ""):
                            pmid = (e.text or "").strip()
                            break
                    title = ""
                    for e in art.iter():
                        if "ArticleTitle" in (e.tag or ""):
                            title = "".join(e.itertext()).strip()
                            break
                    abstract = ""
                    for e in art.iter():
                        if "AbstractText" in (e.tag or ""):
                            abstract += "".join(e.itertext()).strip() + " "
                    authors = []
                    for e in art.iter():
                        if "Author" in (e.tag or ""):
                            last = first = ""
                            for c in e:
                                if "LastName" in (c.tag or ""):
                                    last = (c.text or "").strip()
                                if "ForeName" in (c.tag or ""):
                                    first = (c.text or "").strip()
                            if last:
                                authors.append(f"{first} {last}".strip())
                    year = ""
                    for e in art.iter():
                        if "PubDate" in (e.tag or ""):
                            year = (e.text or "")[:4]
                            break
                    pub_types_raw: list[str] = []
                    for e in art.iter():
                        if "PublicationType" in (e.tag or ""):
                            pt = (e.text or "").strip()
                            if pt:
                                pub_types_raw.append(pt)
                    evidence_type = ""
                    if "Meta-Analysis" in pub_types_raw:
                        evidence_type = "meta_analysis"
                    elif "Systematic Review" in pub_types_raw:
                        evidence_type = "systematic_review"
                    elif "Randomized Controlled Trial" in pub_types_raw:
                        evidence_type = "rct"
                    elif "Practice Guideline" in pub_types_raw:
                        evidence_type = "guideline"
                    elif pub_types_raw:
                        evidence_type = pub_types_raw[0].lower().replace(" ", "_")
                    if title:
                        items.append(
                            RefItem(
                                title=title,
                                authors="; ".join(authors[:5]),
                                year=year,
                                pmid=pmid,
                                abstract=abstract.strip()[:500],
                                source="pubmed",
                                url=f"https://pubmed.ncbi.nlm.nih.gov/{pmid}/" if pmid else "",
                                evidence_type=evidence_type,
                                pub_types=pub_types_raw,
                            )
                        )
                except Exception:
                    continue
    except Exception as e:
        print(f"  [PubMed] Erro: {e}")
    return items


def fetch_zotero(query: str, max_results: int = 5) -> list[RefItem]:
    """Busca no Zotero via API (requer ZOTERO_API_KEY e ZOTERO_LIBRARY_ID)."""
    items: list[RefItem] = []
    api_key = os.environ.get("ZOTERO_API_KEY")
    library_id = os.environ.get("ZOTERO_LIBRARY_ID")
    if not api_key or not library_id:
        return items
    try:
        from pyzotero.zotero import Zotero  # type: ignore[import-not-found]

        zot = Zotero(library_id, "user", api_key)
        results = zot.items(q=query, limit=max_results)
        for item in results:
            data = item.get("data", {})
            title = data.get("title", "")
            creators = data.get("creators", [])
            authors = "; ".join(c.get("lastName", "") or c.get("name", "") for c in creators[:5])
            year = data.get("date", "")[:4] if data.get("date") else ""
            doi = ""
            for e in data.get("extra", "").split("\n") or []:
                if e.startswith("DOI:"):
                    doi = e.replace("DOI:", "").strip()
                    break
            abstract = data.get("abstractNote", "")[:500]
            key = item.get("key", "")
            items.append(
                RefItem(
                    title=title,
                    authors=authors,
                    year=year,
                    doi=doi,
                    abstract=abstract,
                    source="zotero",
                    url=f"https://www.zotero.org/items/{key}" if key else "",
                )
            )
    except ImportError:
        print("  [Zotero] pyzotero nao instalado: pip install pyzotero")
    except Exception as e:
        print(f"  [Zotero] Erro: {e}")
    return items


def fetch_all(
    query: str,
    sources: list[str] | None = None,
    max_per_source: int = 5,
    tier1_only: bool = False,
    sort_by_date: bool = False,
) -> tuple[list[RefItem], str]:
    """Busca em todas as fontes e retorna (items, conteudo formatado)."""
    sources = sources or ["pubmed", "zotero"]
    all_items: list[RefItem] = []
    seen_pmid: set[str] = set()

    if "pubmed" in sources:
        items = fetch_pubmed(
            query,
            max_per_source,
            tier1_only=tier1_only,
            sort_by_date=sort_by_date,
        )
        for r in items:
            if r.pmid and r.pmid not in seen_pmid:
                seen_pmid.add(r.pmid)
                all_items.append(r)
            elif not r.pmid:
                all_items.append(r)
        print(f"  PubMed: {len(items)} resultados")

    if "zotero" in sources:
        items = fetch_zotero(query, max_per_source)
        all_items.extend(items)
        print(f"  Zotero: {len(items)} resultados")

    # Formatar referencias para o conteudo
    ref_lines = []
    for r in all_items:
        cite = f"- **{r.title}**"
        if r.evidence_type:
            cite += f" [{r.evidence_type}]"
        if r.authors:
            cite += f" ({r.authors}"
        if r.year:
            cite += f", {r.year}" if r.authors else f" ({r.year}"
        if r.authors or r.year:
            cite += ")"
        if r.pmid:
            cite += f" PMID:{r.pmid}"
        if r.doi:
            cite += f" DOI:{r.doi}"
        if r.url:
            cite += f" {r.url}"
        ref_lines.append(cite)
        if r.abstract:
            ref_lines.append(f"  > {r.abstract[:200]}...")

    ref_content = "\n".join(ref_lines) if ref_lines else "- (nenhuma referencia encontrada)"
    return all_items, ref_content
