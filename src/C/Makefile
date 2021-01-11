export PROJDIR := $(CURDIR)
export SOURCEDIR := $(PROJDIR)/src
export INCLUDES := $(PROJDIR)/include
export SRC_SUBDIRS := $(wildcard */)

.PHONY : all $(SRC_SUBDIRS) clean $(CLEAN_SUBDIRS)

all: $(SRC_SUBDIRS)

$(SRC_SUBDIRS):
	@-$(MAKE) -C $@
