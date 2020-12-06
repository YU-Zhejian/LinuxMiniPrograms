TARGETS := bin/pst
SOURCES := $(wildcard *.c)
OBJECTS := $(foreach fn, $(SOURCES), $(addprefix obj/, $(fn)))
OBJECTS := $(OBJECTS:.c=.o)

all: $(TARGETS)
	$(CC) $(OBJECTS) -lpthread -o $<

$(TARGETS): mkdir $(OBJECTS)


mkdir:
	$(MKDIR) bin obj



obj/%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@


clean:
	$(RM) obj bin
