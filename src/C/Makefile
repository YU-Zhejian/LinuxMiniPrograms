# VERSION=1.5
TARGETS := lib bin
export VPATH += $(CURDIR)/bin/ $(CURDIR)/lib/ $(CURDIR)/include/
export CFLAGS += -I$(CURDIR)/include --std=c99
export LDFLAGS += -L$(CURDIR)/lib

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

assess: # Used for developmental purpose only.
	scan-build -o scan-build make clean all RM="rm -rf" LIBTOOL=libtool CP="echo"
	cppcheck --library=zlib --library=posix -I include --platform=unix64  bin include lib
.PHONY: assess

install: all
	@-$(MAKE) install_bin
	@-$(MAKE) install_lib
	@-$(MAKE) install_include

.PHONY: install_bin
install_bin:
	$(MKDIR) $(PREFIX)/bin/
	$(CP) -uv $(CURDIR)/bin/*.co $(PREFIX)/bin/ >> install_$(TIMESTAMP).log

.PHONY: install_lib
install_lib:
	$(MKDIR) $(PREFIX)/lib/
	$(CP) -uv $(CURDIR)/lib/*.so $(PREFIX)/lib/ >> install_$(TIMESTAMP).log

.PHONY: install_include
install_include:
	$(MKDIR) $(PREFIX)/include/
	$(CP) -uv $(CURDIR)/include/*.h $(PREFIX)/include/ >> install_$(TIMESTAMP).log
