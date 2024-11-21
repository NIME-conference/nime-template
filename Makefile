
# Output PDF names
NIME_PDF = nime-paper-template.pdf
MUSIC_PDF = nime-music-workshop-template.pdf

# Full compilation rule with BibTeX
define compile_tex
	@mkdir -p $(dir $@)
	cd $(dir $<) && pdflatex -interaction=nonstopmode $(notdir $<)
	cd $(dir $<) && bibtex $(basename $(notdir $<))
	cd $(dir $<) && pdflatex -interaction=nonstopmode $(notdir $<)
	cd $(dir $<) && pdflatex -interaction=nonstopmode $(notdir $<)
endef

$(NIME_PDF): nime-paper-template.tex
	$(compile_tex)

$(MUSIC_PDF): nime-music-workshop-template.tex
	$(compile_tex)

# Clean generated files
clean:
	rm -f $(NIME_PDF) $(MUSIC_PDF)
	rm -f *.aux *.log *.out \
		*.bbl *.blg *.fls *.fdb_latexmk \
		*.synctex.gz

.PHONY: all clean