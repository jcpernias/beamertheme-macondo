SHELL := /bin/sh

# TEXI2DVI_SILENT :=

## Directories
## ================================================================================

root-dir := .
demo-dir := $(root-dir)/demo
build-dir := $(demo-dir)/build
out-dir := $(demo-dir)

## Binaries
## ================================================================================

EMACS := emacs
ENV := env

-include local.mk


define n


endef

$(info $n-----------------------------------------------------------------)
$(info Using binaries:)
$(info emacs-bin: $(EMACS))
$(info texi2dvi-bin: $(TEXI2DVI))
$(info env-bin: $(ENV))
$(info -----------------------------------------------------------------$n)

## Variables
## ================================================================================

EMACS_FLAGS := -Q -nw --batch
emacs-loads := --load=$(demo-dir)/setup.el
org-to-beamer := \
	--eval "(tobeamer \"$(build-dir)\")"

TEXI2DVI_ENV := $(ENV) TEXI2DVI_USE_RECORDER=yes

TEXI2DVI_FLAGS := --batch $(TEXI2DVI_SILENT) \
	-I $(demo-dir) --pdf --build=tidy \
	--build-dir=$(subst ./,,$(build-dir))

beamer-theme-files := \
	$(root-dir)/beamercolorthememacondo.sty \
	$(root-dir)/beamerfontthememacondo.sty \
	$(root-dir)/beamerinnerthememacondo.sty \
	$(root-dir)/beamerouterthememacondo.sty \
	$(root-dir)/beamerthememacondo.sty \

pdf-deps := $(beamer-theme-files) $(demo-dir)/preamble.tex

all: $(out-dir)/demo.pdf

# org to latex
.PRECIOUS: $(build-dir)/%.tex
$(build-dir)/%.tex: $(demo-dir)/%.org | $(build-dir)
	$(EMACS) $(EMACS_FLAGS) $(emacs-loads) --visit=$< $(org-to-beamer)

## latex to pdf
$(out-dir)/%.pdf: $(build-dir)/%.tex $(pdf_deps)| $(outdir)
	$(TEXI2DVI_ENV) $(TEXI2DVI) $(TEXI2DVI_FLAGS) --output=$@ $<

## Auxiliary directories
## --------------------------------------------------------------------------------

$(build-dir):
	mkdir $(build-dir)


## Cleaning rules
## --------------------------------------------------------------------------------

.PHONY: clean
clean:
	-@rm -rf $(build-dir)


.PHONY: veryclean
veryclean: clean
	-@rm -rf $(out-dir)/demo.pdf
