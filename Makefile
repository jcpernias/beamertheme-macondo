SHELL := /bin/sh

# TEXI2DVI_SILENT :=

## Directories
## ================================================================================

DESTDIR := $(shell kpsewhich -var-value=TEXMFHOME)

## Binaries
## ================================================================================

EMACS := emacs
ENV := env
INSTALL := install

-include local.mk


# newline
define n


endef

# Update kpathsea database
define update-kpathsea
if [ -f $(DESTDIR)/ls-R ]; \
then \
	mktexlsr $(DESTDIR); \
fi;
endef

$(info $n-----------------------------------------------------------------)
$(info Using binaries:)
$(info emacs-bin: $(EMACS))
$(info texi2dvi-bin: $(TEXI2DVI))
$(info env-bin: $(ENV))
$(info -----------------------------------------------------------------$n)

## Variables
## ================================================================================

root-dir := .
demo-dir := $(root-dir)/demo
build-dir := $(demo-dir)/build
pdf-dir := $(demo-dir)
install-dir := $(DESTDIR)/tex/latex/beamertheme-macondo
doc-dir := $(DESTDIR)/doc/latex/beamertheme-macondo


EMACS_FLAGS := -Q -nw --batch
emacs-loads := --load=$(demo-dir)/setup.el
org-to-beamer := \
	--eval "(tobeamer \"$(build-dir)\")"

TEXI2DVI_ENV := $(ENV) TEXI2DVI_USE_RECORDER=yes

TEXI2DVI_FLAGS := --batch $(TEXI2DVI_SILENT) \
	-I $(demo-dir) --pdf --build=tidy \
	--build-dir=$(subst ./,,$(build-dir))

sty-files := \
	$(root-dir)/beamercolorthememacondo.sty \
	$(root-dir)/beamerfontthememacondo.sty \
	$(root-dir)/beamerinnerthememacondo.sty \
	$(root-dir)/beamerouterthememacondo.sty \
	$(root-dir)/beamerthememacondo.sty \


demo-deps := $(sty-files)

all: demo

demo: $(pdf-dir)/demo.pdf

# org to latex
.PRECIOUS: $(build-dir)/%.tex
$(build-dir)/%.tex: $(demo-dir)/%.org | $(build-dir)
	$(EMACS) $(EMACS_FLAGS) $(emacs-loads) --visit=$< $(org-to-beamer)

## latex to pdf
$(pdf-dir)/%.pdf: $(build-dir)/%.tex $(pdf_deps)| $(outdir)
	$(TEXI2DVI_ENV) $(TEXI2DVI) $(TEXI2DVI_FLAGS) --output=$@ $<

install:
	$(INSTALL) -d $(install-dir)
	$(INSTALL) -m 644 $(sty-files) $(install-dir)
	$(update-kpathsea)

uninstall:
	-@rm -rf $(install-dir)
	$(update-kpathsea)

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
	-@rm -rf $(pdf-dir)/demo.pdf
