TARGETS := ../../../bin/exec/b16c.co
SOURCES := $(wildcard *.c)
OBJECTS := $(foreach fn, $(SOURCES), $(addprefix obj/, $(fn)))
OBJECTS := $(OBJECTS:.c=.o)

all: $(TARGETS)

$(TARGETS): obj $(OBJECTS)
	$(CC) $(OBJECTS) -o $<

obj:
	$(MKDIR) obj

obj/%.o: %.c
	$(CC) $(CFLAGS) -I$(INCLUDES) -c $< -o $@

clean:
	$(RM) obj
