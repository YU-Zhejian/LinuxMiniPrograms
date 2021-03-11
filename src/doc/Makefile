SOURCES := $(wildcard *.adoc)
PDF_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix ../../share/doc/pdf/, $(fn)))
PDF_OBJECTS := $(PDF_OBJECTS:.adoc=.pdf)
HTML_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix ../../share/doc/html/, $(fn)))
HTML_OBJECTS := $(HTML_OBJECTS:.adoc=.html)
MAN_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix ../../share/man/man1/, $(fn)))
MAN_OBJECTS := $(MAN_OBJECTS:.adoc=.1)
USAGE_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix ../../share/doc/usage/, $(fn)))
USAGE_OBJECTS := $(USAGE_OBJECTS:.adoc=.usage)

.PHONY : all pdf html man usage

all:pdf html man usage
pdf:../../share/doc/pdf/ $(PDF_OBJECTS)
html:../../share/doc/html/ $(HTML_OBJECTS)
man:../../share/man/man1/ $(MAN_OBJECTS)
usage:../../share/doc/usage/ $(USAGE_OBJECTS)

../../share/doc/pdf/:
	$(MKDIR) ../../share/doc/pdf/

../../share/doc/html/:
	$(MKDIR) ../../share/doc/html/

../../share/man/man1/:
	$(MKDIR) ../../share/man/man1/

../../share/doc/usage/:
	$(MKDIR) ../../share/doc/usage/

../../share/doc/pdf/%.pdf: %.adoc
	$(ADOC_PDF) $(AOPTS) $< -o $@

../../share/doc/html/%.html: %.adoc
	$(ADOC) $(AOPTS) $< -o $@

../../share/man/man1/%.1: %.adoc
	$(ADOC) $(AOPTS) -b manpage $< -o $@

../../share/doc/usage/%.usage: %.adoc
	$(PYTHON) ../exec/adoc2usage.py $< $@
