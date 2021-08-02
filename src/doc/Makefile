.PHONY : all pdf html man

export DOC_TMP_PREFIX=$(CURDIR)/../../share/doc/linuxminiprograms/
export MAN_TMP_PREFIX=$(CURDIR)/../../share/man/

all:pdf html man

# TODO: Errors in msys2

pdf:
	@-$(MAKE) -C 1 $@
	@-$(MAKE) -C 7 $@

html:
	@-$(MAKE) -C 1 $@
	@-$(MAKE) -C 7 $@

man:
	@-$(MAKE) -C 1 man1
	@-$(MAKE) -C 7 man7
