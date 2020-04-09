TARGET := bavice

.PHONY: all
all: check

.PHONY: check
check:
	shellcheck ${TARGET}
