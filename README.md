# nime-template: A NIME-flavoured Publication Template

This repository includes publication templates for the International Conference on New Interfaces for Musical Expression (NIME). Specifically we have templates for paper, music and workshop tracks:

- `nime-paper-template.tex` (2-column, paper track)
- `nime-music-workshop-template.tex` (1-column, music and workshop tracks)

The templates have example text demonstrating many interesting and useful features, but you should check the call for specific editions of the NIME conference to make sure you are structuring your submission correctly.

## `nimeart.cls`

`nimeart.cls` is the LaTeX class for generating PDF documents from these templates. `nimeart` is a fork of the [ACM publication format](https://www.acm.org/publications/proceedings-template) `acmart` to provide specific features for the NIME conference:

  - A4 paper size
  - 1-column conference format based on acmsmall
  - sample outputs are focussed on NIME tracks

You can use the same features as `acmart` as documented in it's [manual](https://portalparts.acm.org/hippo/latex_templates/acmart.pdf).

This derived work is distributed in compliance with the LPPL.

The original source code can be found at: <https://github.com/borisveytsman/acmart>

This derived work is only useful for the NIME community. Any issues with `nimeart.cls` should be flagged in this repository: <https://github.com/nime-conference/nimeart> or reported in the [NIME forum](https://forum.nime.org).

The authors of the original acmart are in no way responsible for use of nimeart.

We thank the authors of acmart and the ACM community for their ongoing contributions to academic publishing within and outside of ACM-sponsored events and publications.

## History

NIME traditionally used the old ACM sig-alternate (2-column) class forked in 2009. In 2019, NIME began to use a fork of acmart for 1-column music submissions. NIME used PubPub in 2021-2022, an alternative web-based publication platform. For 2025, the NIME template has been updated to adopt a fork of the latest ACM publication format.
