SOURCES := $(wildcard *.adoc)

PDF_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(DOC_TMP_PREFIX)/pdf/, $(fn)))
PDF_OBJECTS := $(PDF_OBJECTS:.adoc=.pdf)
HTML_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(DOC_TMP_PREFIX)/html/, $(fn)))
HTML_OBJECTS := $(HTML_OBJECTS:.adoc=.html)
MAN1_OBJECTS := $(foreach fn, $(SOURCES), $(addprefix $(MAN_TMP_PREFIX)/man1/, $(fn)))
MAN1_OBJECTS := $(MAN1_OBJECTS:.adoc=.1)

.PHONY : all pdf html man1

all:pdf html man1
pdf:$(DOC_TMP_PREFIX)/pdf/ $(PDF_OBJECTS)
html:$(DOC_TMP_PREFIX)/html/ $(HTML_OBJECTS)
man1:$(MAN_TMP_PREFIX)/man1/ $(MAN1_OBJECTS)

$(DOC_TMP_PREFIX)/pdf/:
	$(MKDIR) $@

$(DOC_TMP_PREFIX)/html/:
	$(MKDIR) $@

$(MAN_TMP_PREFIX)/man1/:
	$(MKDIR) $@

$(DOC_TMP_PREFIX)/pdf/%.pdf: %.adoc
	$(ADOC_PDF) $(PDF_AOPTS) -o $@ $<

$(DOC_TMP_PREFIX)/html/%.html: %.adoc
	$(ADOC) -o $@ $<

$(MAN_TMP_PREFIX)/man1/%.1: %.adoc
	$(ADOC) -b manpage -o $@ $<