TARGETS := ../../../bin/exec/b16c.co
SOURCES := $(wildcard *.c)
OBJECTS := $(foreach fn, $(SOURCES), $(addprefix obj/, $(fn)))
OBJECTS := $(OBJECTS:.c=.o)

all: $(TARGETS)
	$(CC) $(OBJECTS) -o $<

$(TARGETS): mkdir $(OBJECTS)

mkdir:
	$(MKDIR) obj

obj/%.o: %.c
	$(CC) $(CFLAGS) -I$(INCLUDES) -c $< -o $@

clean:
	$(RM) obj
