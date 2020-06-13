TARGET := bavice

.PHONY: check
check:
	shellcheck ${TARGET}
