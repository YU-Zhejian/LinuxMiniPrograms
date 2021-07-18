# VERSION=1.0
TARGETS = b16c pst

SOURCES := $(wildcard *.c *.cpp)
OBJECTS := $(SOURCES:.c=.o)
OBJECTS := $(OBJECTS:.cpp=.o)
LIBTOOL_OBJECTS := $(OBJECTS:.o=.lo)

LDFLAGS += -lyuzjstd

all: $(TARGETS)

.PHONY : all

b16c: b16c.lo
	$(LIBTOOL) --tag=CC --mode=link $(LIBTOOL_FLAGS) $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $<

pst: pst.lo
	$(LIBTOOL) --tag=CXX --mode=link $(LIBTOOL_FLAGS) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) -lpthread -o $@ $<

%.lo: %.c
	$(LIBTOOL) --tag=CC --mode=compile  $(LIBTOOL_FLAGS) $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< -c -o $@

%.lo: %.cpp
	$(LIBTOOL) --tag=CXX --mode=compile  $(LIBTOOL_FLAGS) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) $< -c -o $@

clean:
	$(RM) .libs $(PACKAGE_NAME) $(LIBTOOL_OBJECTS) $(OBJECTS) $(TARGETS)
.PHONY : clean

distclean:
.PHONY : distclean
