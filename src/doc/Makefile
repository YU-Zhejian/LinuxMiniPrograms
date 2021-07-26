.PHONY : all pdf html man usage

all:pdf html man usage

pdf:
	@-$(MAKE) -C 1 $@
	@-$(MAKE) -C 7 $@

html:
	@-$(MAKE) -C 1 $@
	@-$(MAKE) -C 7 $@

man:
	@-$(MAKE) -C 1 man1
	@-$(MAKE) -C 7 man7

usage:
	@-$(MAKE) -C 1 $@
	@-$(MAKE) -C 7 $@
