# Directories
LATEX_DIR = papers/latex
MUSIC_DIR = music/latex

# Output PDF names
NIME_PDF = $(LATEX_DIR)/nime-template.pdf
MUSIC_PDF = $(MUSIC_DIR)/music-proceedings-template.pdf

# Source files
NIME_TEX = $(LATEX_DIR)/nime-template.tex
MUSIC_TEX = $(MUSIC_DIR)/music-proceedings-template.tex

# Export BST paths for bibtex to find style files
export BSTINPUTS := .:$(LATEX_DIR):$(MUSIC_DIR):${BSTINPUTS}

# Default target to build both PDFs
all: verify_files $(NIME_PDF) $(MUSIC_PDF)

# Verify that source files exist
verify_files:
	@if [ ! -f $(NIME_TEX) ]; then \
		echo "Error: $(NIME_TEX) not found"; \
		exit 1; \
	fi
	@if [ ! -f $(MUSIC_TEX) ]; then \
		echo "Error: $(MUSIC_TEX) not found"; \
		exit 1; \
	fi

# Full compilation rule with BibTeX
define compile_tex
	@mkdir -p $(dir $@)
	cd $(dir $<) && pdflatex -interaction=nonstopmode $(notdir $<)
	cd $(dir $<) && bibtex $(basename $(notdir $<))
	cd $(dir $<) && pdflatex -interaction=nonstopmode $(notdir $<)
	cd $(dir $<) && pdflatex -interaction=nonstopmode $(notdir $<)
endef

$(NIME_PDF): $(NIME_TEX)
	$(compile_tex)

$(MUSIC_PDF): $(MUSIC_TEX)
	$(compile_tex)

# Clean generated files
clean:
	rm -f $(NIME_PDF) $(MUSIC_PDF)
	rm -f $(LATEX_DIR)/*.aux $(LATEX_DIR)/*.log $(LATEX_DIR)/*.out \
		$(LATEX_DIR)/*.bbl $(LATEX_DIR)/*.blg
	rm -f $(MUSIC_DIR)/*.aux $(MUSIC_DIR)/*.log $(MUSIC_DIR)/*.out \
		$(MUSIC_DIR)/*.bbl $(MUSIC_DIR)/*.blg

.PHONY: all clean verify_files