export ADOC=asciidoctor
export PYTHON=python
export RM=rm -rf
export VERBOSE = TRUE
export MKDIR = mkdir -p
export AOPTS= -a allow-uri-read

SOURCES := $(wildcard *.adoc)
PDF_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix ../../pdf/, $(fn)))
PDF_OBJECTS := $(PDF_OBJECTS:.adoc=.pdf)
HTML_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix ../../html/, $(fn)))
HTML_OBJECTS := $(HTML_OBJECTS:.adoc=.html)
MAN_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix ../../man/man1/, $(fn)))
MAN_OBJECTS := $(MAN_OBJECTS:.adoc=.1)
USAGE_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix ../../doc/, $(fn)))
USAGE_OBJECTS := $(USAGE_OBJECTS:.adoc=.usage)

.PHONY : all pdf html man usage

all:pdf html man usage
pdf:../../pdf/ $(PDF_OBJECTS)
html:../../html/ $(HTML_OBJECTS)
man:../../man/man1/ $(MAN_OBJECTS)
usage:../../doc/ $(USAGE_OBJECTS)

../../pdf/:
	$(MKDIR) ../../pdf/

../../html/:
	$(MKDIR) ../../html/

../../man/man1/:
	$(MKDIR) ../../man/man1/

../../doc/:
	$(MKDIR) ../../doc/

../../pdf/%.pdf: %.adoc
	$(ADOC) $(AOPTS) $< -o $@

../../html/%.html: %.adoc
	$(ADOC) $(AOPTS) -b html5 $< -o $@

../../man/man1/%.1: %.adoc
	$(ADOC) $(AOPTS) -b manpage $< -o $@

../../doc/%.usage: %.adoc
	$(PYTHON) ../exec/adoc2usage.py $< $@
