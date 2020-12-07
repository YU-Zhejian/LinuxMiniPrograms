export CC=gcc
export RM=rm -rf
export VERBOSE = TRUE
export MKDIR = mkdir -p

PROJDIR := $(CURDIR)
BUILDDIR := $(PROJDIR)/build
SOURCEDIR := $(PROJDIR)/src
INCLUDES := $(PROJDIR)/include
SRC_SUBDIRS := $(wildcard src/*/)

.PHONY : all $(SRC_SUBDIRS) clean $(CLEAN_SUBDIRS)

all: $(SRC_SUBDIRS)
	mv src/*/bin/* build

$(SRC_SUBDIRS):
	@-$(MAKE) -C $@
