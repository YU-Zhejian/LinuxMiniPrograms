TARGETS := ../../../bin/exec/b16c.co
SOURCES := $(wildcard *.c)
OBJECTS := $(foreach fn, $(SOURCES), $(addprefix obj/, $(fn)))
OBJECTS := $(OBJECTS:.c=.o)

.PHONY : all $(TARGETS) $(OBJECTS) clean

all: $(TARGETS)

$(TARGETS): obj $(OBJECTS)
	$(CC) $(OBJECTS) -o $(OBJECTS)

obj:
	$(MKDIR) obj

obj/%.o: %.c
	$(CC) $(CFLAGS) -I$(INCLUDES) -c $< -o $@

clean:
	$(RM) obj
