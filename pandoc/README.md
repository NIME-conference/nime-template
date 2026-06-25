# Markdown / DOCX → NIME PDF pipeline

Write your NIME paper in **Markdown** (or a **Word `.docx`**) and render it to a
NIME-formatted PDF using [pandoc](https://pandoc.org) and the `nimeart` LaTeX
class. This is an alternative authoring route to writing LaTeX directly — the
output uses the same class, fonts, and reference style as the `.tex` templates.

## Requirements

- [pandoc](https://pandoc.org) 3.x
- A TeX distribution with `pdflatex` and `bibtex` (TeX Live / MacTeX) — the same
  toolchain the LaTeX templates need, including the `nimeart.cls` in this repo.

## Quick start

From the repository root:

```sh
make md-pdf                 # builds the example: pandoc/example.md -> example.pdf
make md-pdf SRC=mypaper.md  # build your own Markdown file
```

Outputs `<name>.tex` and `<name>.pdf` are written to the repository **root** so
that image paths (e.g. `images/...`) and the `.bib` file resolve relative to the
repo, exactly as in the LaTeX templates.

## Files

| File | Purpose |
|------|---------|
| `nime.latex`          | Pandoc LaTeX template; maps YAML metadata onto the `nimeart` front-matter commands. |
| `nime-defaults.yaml`  | Pandoc options (template, citation method, table filter, variables). |
| `nime-tables.lua`     | Renders Markdown tables as `table`+`tabular` floats (pandoc's default `longtable` fails in two-column mode). |
| `example.md`          | A complete example paper with all supported metadata fields. |
| `example-meta.yaml`   | A metadata sidecar for the DOCX path. |

## Markdown front matter

All NIME front-matter lives in a YAML block at the top of the Markdown file.
See `example.md` for a full, commented example. The supported fields:

```yaml
---
title: "Your Paper Title"
shorttitle: "Short Title"          # optional, for page headers
subtitle: "Optional Subtitle"      # optional
classoption: sigconf               # or [sigconf, anonymous, review] for blind review

author:
  - name: First Author
    email: first@example.org
    institution: Their University
    department: Optional Department # optional
    city: City
    state: ST                       # optional
    country: Country
    orcid: 0000-0000-0000-0000      # optional
    note: Shared-contribution note. # optional (\authornote)
  - name: Second Author
    email: second@example.org
    institution: Another University
    city: City
    country: Country
    notemark: 1                     # optional, references an earlier note

shortauthors: "First and Second"    # optional, for page headers
abstract: |
  Your abstract here.
keywords: [one, two, three]

teaser:                             # optional page-spanning teaser figure
  image: images/sampleteaser.png
  caption: "Caption."
  description: "Accessibility description."
  label: "fig:teaser"

bibliography: sample-references.bib  # BibTeX, rendered with ACM-Reference-Format
acknowledgments: |                   # optional, emitted as acmart \begin{acks}
  Thanks to ...
---
```

The document body is plain Markdown: `#`/`##`/`###` headings become numbered
`\section`/`\subsection`/`\subsubsection`, images become `figure`s (alt text →
accessibility `\Description`), pipe tables become booktabs tables, `$...$` /
`$$...$$` are maths, and citations use pandoc's `@key` syntax (`[@a; @b]`),
rendered through BibTeX. You can also drop in raw LaTeX where you need it.

## Word (`.docx`)

A Word document carries prose but not the structured NIME front matter, so
supply that in a metadata sidecar (same fields as above):

```sh
make docx-pdf SRC=mypaper.docx META=pandoc/example-meta.yaml
```

Or convert the `.docx` into a Markdown starting point, add the front matter, and
use the Markdown path (recommended if you want full citation support):

```sh
make docx-md SRC=mypaper.docx   # -> mypaper.md (media extracted to images/)
# add YAML front matter to mypaper.md, then:
make md-pdf SRC=mypaper.md
```

### Citation caveat for `.docx`

Pandoc only parses `[@key]` citation syntax from Markdown-family input. Citations
typed as `[@key]` text inside a Word document are **not** converted and will
appear literally. For cited work, prefer the Markdown path (or the `docx-md`
→ `md-pdf` route above), or manage references with a Word/Zotero citation plugin
whose native fields pandoc can read.

## How it works

```
Markdown ─┐
          ├─ pandoc (--template nime.latex, --natbib, table filter) ─► .tex ─► pdflatex + bibtex ─► .pdf
.docx  ───┘  (+ metadata sidecar)
```

acmart/nimeart provides its own fonts (Libertine/newtxmath), `hyperref`, and
page geometry, so the template deliberately omits pandoc's font and geometry
partials to avoid clashes (notably the `\Bbbk` redefinition from reloading
`amssymb`). Paragraphs are forced to `indent` mode so pandoc does not load
`parskip`, which would override acmart's paragraph formatting.
