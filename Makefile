CC := gcc

# Paths

SRC_DIR := src
INC_DIR = include
BUILD_DIR := build
TEST_DIR := tests
BIN := ripple

SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))

TEST_SRCS := $(wildcard $(TEST_DIR)/*.c)
TEST_BINS := $(patsubst $(TEST_DIR)/%.c, $(BUILD_DIR)/%, $(TEST_SRCS))

# Flags

CFLAGS_WARN := \
	-Wall \
	-Wextra \
	-Wpedantic \
	-Wstrict-prototypes \
	-Wmissing-prototypes \
	-Wshadow \
	-Wundef \
	-Wcast-align \
	-Wwrite-strings

CFLAGS_BASE := \
	-std=c99 \
	-D_POSIX_C_SOURCE=200809L \
	-I$(INC_DIR)

CFLAGS := $(CFLAGS_BASE) $(CFLAGS_WARN) -O2

CFLAGS_DEBUG := \
	-O0 \
	-g3 \
	-fno-omit-frame-pointer \
	-fsanitize=address,undefined

LDFLAGS := -lncurses -lm
LDFLAGS_DEBUG := $(LDFLAGS) -fsanitize=address,undefined

# Rules

.PHONY: all debug test clean help

all: $(BIN)

$(BIN): $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $@

# debug

debug: clean
debug: CFLAGS  := $(CFLAGS_BASE) $(CFLAGS_WARN) $(CFLAGS_DEBUG)
debug: LDFLAGS := $(LDFLAGS_DEBUG)
debug: $(BIN)

# test

TEST_OBJS := $(filter-out $(BUILD_DIR)/main.o, $(OBJS))

$(BUILD_DIR)/%: $(TEST_DIR)/%.c $(TEST_OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

test: $(BIN) $(TEST_BINS)
	@for t in $(TEST_BINS); do \
		echo "running $$t ..."; \
		$$t || exit 1; \
	done
	@echo "all tests passed"

# clean

clean:
	rm -rf $(BUILD_DIR) $(BIN)

# help

help:
	@echo "targets:"
	@echo "  all        release build (default)"
	@echo "  debug      ASan + UBSan build, no optimisation"
	@echo "  test       build and run unit tests"
	@echo "  clean      remove $(BUILD_DIR)/ and $(BIN)"