TARGETS := bin/b16c.co
SOURCES := $(wildcard *.c)
OBJECTS := $(foreach fn, $(SOURCES), $(addprefix obj/, $(fn)))
OBJECTS := $(OBJECTS:.c=.o)

all: $(TARGETS)
	$(CC) $(OBJECTS) -o $<

$(TARGETS): mkdir $(OBJECTS)

mkdir:
	$(MKDIR) bin obj

obj/%.o: %.c
	$(CC) $(CFLAGS) -I../include -c $< -o $@

clean:
	$(RM) obj bin
