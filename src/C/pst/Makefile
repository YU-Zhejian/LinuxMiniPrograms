TARGETS := ../../../bin/exec/pst.co

.PHONY : all $(TARGETS)

all: $(TARGETS)
	$(CC) -I$(INCLUDES) $(wildcard *.c) -lpthread -o $(TARGETS)
