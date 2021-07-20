SOURCES := $(wildcard *.Dockerfile)
RUN_TARGETS := $(foreach fn, $(SOURCES), $(addsuffix .run, $(fn)))

# Disable implicit rules and variables
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: all
all: pre_req  $(RUN_TARGETS)

.PHONY: pre_req
pre_req:
	bash docker_pre_req.sh

%.Dockerfile.run: %.Dockerfile
	-bash docker_run_wrapper.sh $^

.PHONY: clean
clean:
	 $(RM) log/*.log

.PHONY: distclean
distclean: clean
	$(RM) *.Dockerfile

.PHONY: list
list:
	@echo $(RUN_TARGETS)
