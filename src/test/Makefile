# VERSION=1.0
ifeq ($(strip $(TT)),) # TT is empty
SOURCES := $(wildcard *.t.sh)
TARGETS := $(foreach fn, $(SOURCES), $(addsuffix .ex, $(fn)))
else
TARGETS := $(foreach fn, $(TT), $(addsuffix .t.sh.ex, $(fn)))
endif

# Disable implicit rules and variables
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: all
all: $(TARGETS)

%.t.sh.ex: %.t.sh
	-bash $^

clean:
	 $(RM) *.t/

distclean:
