# VERSION=1.0
ifeq ($(strip $(TT)),) # TT is empty
SOURCES := $(wildcard *.t.py)
TARGETS := $(foreach fn, $(SOURCES), $(addsuffix .ex, $(fn)))
else
TARGETS := $(foreach fn, $(TT), $(addsuffix .t.py.ex, $(fn)))
endif

# Disable implicit rules and variables
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: all
all: $(TARGETS)

%.t.py.ex: %.t.py
	-$(PYTHON) $^

clean:
	 $(RM) *.t/

distclean:
