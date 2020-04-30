# Uncomment and adapt to your local system if needed
# DESTDIR := $(shell kpsewhich -var-value=TEXMFHOME)
# EMACS := /usr/local/bin/emacs
TEXI2DVI := /usr/local/opt/texinfo/bin/texi2dvi

# If uncommented texi2dvi only outputs errors
TEXI2DVI_SILENT := -q
