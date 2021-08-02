SOURCES := $(wildcard out/*.Dockerfile)
RUN_TARGETS := $(foreach fn, $(SOURCES), $(addsuffix .run, $(fn)))

# TODO: Need pandas and setuptools

# Disable implicit rules and variables
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: all
all: pre_req  $(RUN_TARGETS)

.PHONY: pre_req
pre_req:
	mkdir -p out
	bash bin/docker_pre_req.sh

%.Dockerfile.run: %.Dockerfile
	-bash bin/docker_run_wrapper.sh $^

.PHONY: clean
clean:
	 $(RM) log/*.log lmp_test*/

.PHONY: distclean
distclean: clean
	$(RM) out/*.Dockerfile

.PHONY: list
list:
	@echo $(RUN_TARGETS) | tr ' ' '\n'
