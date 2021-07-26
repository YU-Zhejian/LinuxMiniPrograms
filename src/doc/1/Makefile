SOURCES := $(wildcard *.adoc *.adoc)
DOC_TMP_PREFIX=../../../share/
PDF_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(DOC_TMP_PREFIX)/doc/pdf/, $(fn)))
PDF_OBJECTS := $(PDF_OBJECTS:.adoc=.pdf)
HTML_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(DOC_TMP_PREFIX)/doc/html/, $(fn)))
HTML_OBJECTS := $(HTML_OBJECTS:.adoc=.html)
MAN1_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(DOC_TMP_PREFIX)/man/man1/, $(fn)))
MAN1_OBJECTS := $(MAN1_OBJECTS:.adoc=.1)
USAGE_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(DOC_TMP_PREFIX)/doc/usage/, $(fn)))
USAGE_OBJECTS := $(USAGE_OBJECTS:.adoc=.usage)

.PHONY : all pdf html man1 usage

all:pdf html man1 usage
pdf:$(DOC_TMP_PREFIX)/doc/pdf/ $(PDF_OBJECTS)
html:$(DOC_TMP_PREFIX)/doc/html/ $(HTML_OBJECTS)
man1:$(DOC_TMP_PREFIX)/man/man1/ $(MAN1_OBJECTS)
usage:$(DOC_TMP_PREFIX)/doc/usage/ $(USAGE_OBJECTS)

$(DOC_TMP_PREFIX)/doc/pdf/:
	$(MKDIR) $@

$(DOC_TMP_PREFIX)/doc/html/:
	$(MKDIR) $@

$(DOC_TMP_PREFIX)/man/man1/:
	$(MKDIR) $@

$(DOC_TMP_PREFIX)/doc/usage/:
	$(MKDIR) $@

$(DOC_TMP_PREFIX)/doc/pdf/%.pdf: %.adoc
	$(ADOC_PDF) $(PDF_AOPTS) -o $@ $<

$(DOC_TMP_PREFIX)/doc/html/%.html: %.adoc
	$(ADOC) -o $@ $<

$(DOC_TMP_PREFIX)/man/man1/%.1: %.adoc
	$(ADOC) -b manpage -o $@ $<

$(DOC_TMP_PREFIX)/doc/usage/%.usage: %.adoc
	$(PYTHON) ../../exec/adoc2usage.py $< $@
