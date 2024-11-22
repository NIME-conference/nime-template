
# Output PDF names
PAPER_TEMPLATE = nime-paper-template
MUSIC_TEMPLATE = nime-music-workshop-template

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

all: $(MUSIC_TEMPLATE).pdf $(PAPER_TEMPLATE).pdf

# Clean generated files
clean:
	rm -f $(PAPER_TEMPLATE).pdf $(MUSIC_TEMPLATE).pdf
	rm -f *.aux *.log *.out \
		*.bbl *.blg *.fls *.fdb_latexmk \
		*.synctex.gz

.PHONY: all clean