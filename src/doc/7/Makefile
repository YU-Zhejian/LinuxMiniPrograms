SOURCES := $(wildcard *.adoc)

PDF_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(DOC_TMP_PREFIX)/pdf/, $(fn)))
PDF_OBJECTS := $(PDF_OBJECTS:.adoc=.pdf)
HTML_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(DOC_TMP_PREFIX)/html/, $(fn)))
HTML_OBJECTS := $(HTML_OBJECTS:.adoc=.html)
MAN7_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(MAN_TMP_PREFIX)/man7/, $(fn)))
MAN7_OBJECTS := $(MAN7_OBJECTS:.adoc=.7)

.PHONY : all pdf html man7

pdf:$(DOC_TMP_PREFIX)/pdf/ $(PDF_OBJECTS)
html:$(DOC_TMP_PREFIX)/html/ $(HTML_OBJECTS)
man7:$(MAN_TMP_PREFIX)/man7/ $(MAN7_OBJECTS)

$(DOC_TMP_PREFIX)/pdf/:
	$(MKDIR) $@

$(DOC_TMP_PREFIX)/html/:
	$(MKDIR) $@

$(MAN_TMP_PREFIX)/man7/:
	$(MKDIR) $@

$(DOC_TMP_PREFIX)/pdf/%.pdf: %.adoc
	$(ADOC_PDF) $(PDF_AOPTS) -o $@ $<

$(DOC_TMP_PREFIX)/html/%.html: %.adoc
	$(ADOC) -o $@ $<

$(MAN_TMP_PREFIX)/man7/%.7: %.adoc
	$(ADOC) -b manpage -o $@ $<
