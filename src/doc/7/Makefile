SOURCES := $(wildcard *.adoc *.adoc)
DOC_TMP_PREFIX=../../../share/
PDF_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(DOC_TMP_PREFIX)/doc/pdf/, $(fn)))
PDF_OBJECTS := $(PDF_OBJECTS:.adoc=.pdf)
HTML_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(DOC_TMP_PREFIX)/doc/html/, $(fn)))
HTML_OBJECTS := $(HTML_OBJECTS:.adoc=.html)
MAN7_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(DOC_TMP_PREFIX)/man/man7/, $(fn)))
MAN7_OBJECTS := $(MAN7_OBJECTS:.adoc=.7)
USAGE_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(DOC_TMP_PREFIX)/doc/usage/, $(fn)))
USAGE_OBJECTS := $(USAGE_OBJECTS:.adoc=.usage)

.PHONY : all pdf html man7 usage

all:pdf html man7 usage
pdf:$(DOC_TMP_PREFIX)/doc/pdf/ $(PDF_OBJECTS)
html:$(DOC_TMP_PREFIX)/doc/html/ $(HTML_OBJECTS)
man7:$(DOC_TMP_PREFIX)/man/man7/ $(MAN7_OBJECTS)
usage:$(DOC_TMP_PREFIX)/doc/usage/ $(USAGE_OBJECTS)

$(DOC_TMP_PREFIX)/doc/pdf/:
	$(MKDIR) $@

$(DOC_TMP_PREFIX)/doc/html/:
	$(MKDIR) $@

$(DOC_TMP_PREFIX)/man/man7/:
	$(MKDIR) $@

$(DOC_TMP_PREFIX)/doc/usage/:
	$(MKDIR) $@

$(DOC_TMP_PREFIX)/doc/pdf/%.pdf: %.adoc
	$(ADOC_PDF) $(PDF_AOPTS) -o $@ $<

$(DOC_TMP_PREFIX)/doc/html/%.html: %.adoc
	$(ADOC) -o $@ $<

$(DOC_TMP_PREFIX)/man/man7/%.7: %.adoc
	$(ADOC) -b manpage -o $@ $<

$(DOC_TMP_PREFIX)/doc/usage/%.usage: %.adoc
	$(PYTHON) ../../exec/adoc2usage.py $< $@
