---
# ===========================================================================
# NIME paper metadata. Everything in this YAML block maps onto the nimeart
# (acmart) front-matter commands via pandoc/nime.latex.
# ===========================================================================

title: "Writing NIME Papers in Markdown"
shorttitle: "NIME Papers in Markdown"   # used in page headers; omit if title is short
# subtitle: "An Optional Subtitle"

# For double-anonymous submission, set:
#   classoption: [sigconf, anonymous, review]
classoption: sigconf

author:
  - name: Ada Lovelace
    email: ada@example.org
    institution: Analytical Engine Lab
    city: London
    country: United Kingdom
    orcid: 0000-0000-0000-0000
    note: Both authors contributed equally to this research.
  - name: Alan Turing
    email: alan@example.org
    institution: Bletchley University
    department: Department of Computing
    city: Milton Keynes
    country: United Kingdom
    notemark: 1          # references the note above (shared-contribution mark)

shortauthors: "Lovelace and Turing"

abstract: |
  This document demonstrates how to author a NIME paper in Markdown and render
  it to a NIME-formatted PDF with pandoc and the `nimeart` LaTeX class. It
  shows headings, citations, figures, tables, and maths so you can see how a
  Markdown source maps onto the conference template.

keywords: [markdown, pandoc, NIME, authoring, music]

# Optional teaser image spanning the page width (place above \maketitle).
teaser:
  image: images/sampleteaser.png
  caption: "A teaser image rendered from Markdown."
  description: "Tangled banana patch cables."
  label: "fig:teaser"

# Bibliography (BibTeX). bibtex + ACM-Reference-Format are run by the Makefile.
bibliography: sample-references.bib

# Acknowledgments are emitted inside acmart's \begin{acks} ... \end{acks}.
acknowledgments: |
  To the maintainers of pandoc and the NIME template, for making this possible.
---

# Introduction

You can write your NIME paper in **Markdown** and still get a properly
formatted PDF. Inline formatting such as *emphasis*, **bold**, and `code`
all work, as do footnotes.[^1] Citations use pandoc's `@key` syntax and are
rendered through BibTeX with the ACM reference format, e.g. a classic
reference [@Lamport:LaTeX] or several at once [@Abril07; @Cohen07].

[^1]: Footnotes render as endnotes/footnotes per the class.

# Sectioning

Markdown headings map onto LaTeX sectioning commands.

## A Subsection

Text under a subsection.

### A Subsubsection

Text under a subsubsection.

# Figures

Reference a figure with standard Markdown image syntax; the caption becomes
the `\caption` and the alt text becomes the accessibility `\Description`.

![A Bela board in action at a workshop.](images/sample-image.jpg){#fig:bela width=80%}

# Tables

| Symbol      | Frequency      | Comments          |
|-------------|----------------|-------------------|
| Ø           | 1 in 1,000     | For Swedish names |
| $\pi$       | 1 in 5         | Common in math    |
| \$          | 4 in 5         | Used in business  |

: Frequency of special characters. {#tbl:freq}

# Maths

Inline maths such as $\lim_{n\to\infty} x = 0$ works, as do display equations:

$$\sum_{i=0}^{\infty} x_i = \int_0^{\pi+2} f \, .$$

# Ethical Standards

The Ethical Standards section is mandatory for all NIME submissions. State
sources of funding, conflicts of interest, and informed-consent information
here.
