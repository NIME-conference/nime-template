
# Output PDF names
PAPER_TEMPLATE = nime-paper-template
MUSIC_TEMPLATE = nime-music-workshop-template
ALT_NIME_TEMPLATE = nime-alt-template

# Full compilation rule with BibTeX
define compile_tex
	@mkdir -p $(dir $@)
	cd $(dir $<) && pdflatex -interaction=nonstopmode $(notdir $<)
	cd $(dir $<) && bibtex $(basename $(notdir $<))
	cd $(dir $<) && pdflatex -interaction=nonstopmode $(notdir $<)
	cd $(dir $<) && pdflatex -interaction=nonstopmode $(notdir $<)
endef

$(PAPER_TEMPLATE).pdf: $(PAPER_TEMPLATE).tex
	$(compile_tex)

$(MUSIC_TEMPLATE).pdf: $(MUSIC_TEMPLATE).tex
	$(compile_tex)

$(ALT_NIME_TEMPLATE).pdf: $(ALT_NIME_TEMPLATE).tex
	$(compile_tex)

all: $(MUSIC_TEMPLATE).pdf $(PAPER_TEMPLATE).pdf $(ALT_NIME_TEMPLATE).pdf

# ===========================================================================
# Markdown / DOCX -> NIME PDF pipeline (pandoc + pdflatex)
#
#   make md-pdf                          # builds pandoc/example.md
#   make md-pdf   SRC=mypaper.md
#   make docx-pdf SRC=mypaper.docx META=mypaper-meta.yaml
#   make docx-md  SRC=mypaper.docx       # extract .docx -> editable Markdown
#
# Output <name>.tex and <name>.pdf are written to the repository root so that
# image and .bib paths in the metadata resolve relative to the repo.
# See pandoc/README.md for the metadata format.
# ===========================================================================
PANDOC          ?= pandoc
PANDOC_DEFAULTS  = pandoc/nime-defaults.yaml
MD_READER        = markdown+yaml_metadata_block+tex_math_dollars+raw_tex
DOCX_READER      = docx+citations

SRC  ?= pandoc/example.md
META ?=
OUT   = $(notdir $(basename $(SRC)))

# pdflatex + bibtex cycle for a pandoc-generated $(OUT).tex
define pandoc_latex
	pdflatex -interaction=nonstopmode $(OUT).tex
	-bibtex $(OUT)
	pdflatex -interaction=nonstopmode $(OUT).tex
	pdflatex -interaction=nonstopmode $(OUT).tex
endef

# Markdown (with YAML front matter) -> NIME PDF
md-pdf:
	$(PANDOC) --defaults $(PANDOC_DEFAULTS) -f $(MD_READER) -o $(OUT).tex $(SRC)
	$(pandoc_latex)

# Word .docx (+ metadata sidecar via META=...) -> NIME PDF
docx-pdf:
	$(PANDOC) --defaults $(PANDOC_DEFAULTS) -f $(DOCX_READER) \
		$(if $(META),--metadata-file $(META),) -o $(OUT).tex $(SRC)
	$(pandoc_latex)

# Extract a .docx to a Markdown starting point (then add front matter + md-pdf)
docx-md:
	$(PANDOC) -f $(DOCX_READER) -t markdown --wrap=preserve \
		--extract-media=images/$(OUT)-media -o $(OUT).md $(SRC)
	@echo "Wrote $(OUT).md. Add YAML front matter (see pandoc/example.md), then:"
	@echo "    make md-pdf SRC=$(OUT).md"

# Clean generated files
clean:
	rm -f $(PAPER_TEMPLATE).pdf $(MUSIC_TEMPLATE).pdf $(ALT_NIME_TEMPLATE).pdf
	rm -f example.pdf example.tex
	rm -f *.aux *.log *.out \
		*.bbl *.blg *.fls *.fdb_latexmk \
		*.synctex.gz

.PHONY: all clean md-pdf docx-pdf docx-md