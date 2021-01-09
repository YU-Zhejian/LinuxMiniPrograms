export CC=gcc
export RM=rm -rf
export VERBOSE = TRUE
export MKDIR = mkdir -p

export PROJDIR := $(CURDIR)
export SOURCEDIR := $(PROJDIR)/src
export INCLUDES := $(PROJDIR)/include
export SRC_SUBDIRS := $(wildcard */)

.PHONY : all $(SRC_SUBDIRS) clean $(CLEAN_SUBDIRS)

all: $(SRC_SUBDIRS)

$(SRC_SUBDIRS):
	@-$(MAKE) -C $@
