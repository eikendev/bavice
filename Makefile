TARGET := ./bin

.PHONY: check
check:
	shellcheck ${TARGET}/*
