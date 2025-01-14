CC     ?= cc
PREFIX ?= /usr/local

ifeq ($(OS),Windows_NT)
BINS    = main.exe
LDFLAGS = -lcurldll
CP      = copy /Y
RM      = del /Q /S
MKDIR_P = mkdir
else
BINS    = main
LDFLAGS = -lcurl
CP      = cp -f
RM      = rm -f
MKDIR_P = mkdir -p
endif

SRC  = $(wildcard src/*.c)
DEPS = $(wildcard deps/*/*.c)
OBJS = $(DEPS:.c=.o)

CFLAGS  = -std=c99 -Ideps -Wall -Wno-unused-function -U__STRICT_ANSI__

all: $(BINS)

$(BINS): $(SRC) $(OBJS) $(RES)
	$(CC) $(CFLAGS) -o $@ src/$(@:.exe=).c $(OBJS) $(RES) $(LDFLAGS)

%.o: %.c
	$(CC) $< -c -o $@ $(CFLAGS)

clean:
	$(foreach c, $(BINS), $(RM) $(c);)
	$(RM) $(OBJS)

install: $(BINS)
	$(MKDIR_P) $(PREFIX)/bin
	$(foreach c, $(BINS), $(CP) $(c) $(PREFIX)/bin/$(c);)

uninstall:
	$(foreach c, $(BINS), $(RM) $(PREFIX)/bin/$(c);)

test:
	@./test.sh

format:
	clang-format -style=file -i src/*

.PHONY: test all clean install uninstall format
