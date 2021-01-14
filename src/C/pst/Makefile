TARGETS := ../../../bin/exec/pst.co
SOURCES := $(wildcard *.c)
OBJECTS := $(foreach fn, $(SOURCES), $(addprefix obj/, $(fn)))
OBJECTS := $(OBJECTS:.c=.o)

.PHONY : all $(TARGETS) $(OBJECTS) clean

all: $(TARGETS)

$(TARGETS): obj $(OBJECTS)
	$(CC) $(OBJECTS) -lpthread -o $(TARGETS)

obj:
	$(MKDIR) obj

obj/%.o: %.c
	$(CC) $(CFLAGS) -I$(INCLUDES) -c $< -o $@

clean:
	$(RM) obj
