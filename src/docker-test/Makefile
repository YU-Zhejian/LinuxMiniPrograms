SOURCES := $(wildcard *.Dockerfile)
TARGETS := $(foreach fn, $(SOURCES), $(addsuffix .ex, $(fn)))

# Disable implicit rules and variables
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: all
all: pre_req $(TARGETS)

.PHONY: pre_req
pre_req:
	bash docker_pre_req.sh

%.Dockerfile.ex: %.Dockerfile
	-bash docker_wrapper.sh $^

.PHONY: clean
clean:
	 $(RM) *.log

.PHONY: distclean
distclean: clean
	$(RM) *.Dockerfile
