# VERSION=1.3
TARGETS := lib bin
export BASE=$(PWD)/src/C
export VPATH += $(BASE)/bin/ $(BASE)/lib/ $(BASE)/include/
export CFLAGS += -I$(BASE)/include

all: $(TARGETS)

lib:
	@$(MAKE) -C lib/
.PHONY: lib

bin: lib
	@$(MAKE) -C bin/
.PHONY: bin

clean:
	@$(MAKE) -C lib clean
	@$(MAKE) -C bin clean
	$(RM) .libs $(PACKAGE_NAME)
.PHONY: clean

distclean: clean
	@$(MAKE) -C bin distclean
	@$(MAKE) -C lib distclean
	@$(MAKE) -C include distclean
.PHONY: distclean

# TODO: Install them to bin
