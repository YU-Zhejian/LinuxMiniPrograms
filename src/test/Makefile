# VERSION=1.0
ifeq ($(strip $(TT)),) # TT is empty
SOURCES := $(wildcard *.t.sh)
TARGETS := $(foreach fn, $(SOURCES), $(addsuffix .ex, $(fn)))
else
TARGETS := $(foreach fn, $(TT), $(addsuffix .t.sh.ex, $(fn)))
endif
REPORT := $(shell date +%Y-%m-%d_%H-%M-%S)_report.adoc
REPORT_IN := $(addsuffix .in, $(REPORT))
REPORT_SOURCE_IN := $(wildcard *.adoc.in) # Generate report from existing source
REPORT_SOURCE := $(subst .in,,$(REPORT_SOURCE_IN))

# Disable implicit rules and variables
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: all
all: $(TARGETS)
	$(MAKE) report

.PHONY: report
report: $(REPORT_SOURCE)

%.t.sh.ex: %.t.sh
	-bash $^ $(REPORT_IN)

%.adoc: %.adoc.in
	python3 reportgen.py $^ > $@

clean:
	$(RM) *.t/ *_report.adoc

distclean: clean
	$(RM)  *_report.adoc.in
