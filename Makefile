TARGET := ./bin

.PHONY: lint
lint:
	shellcheck ${TARGET}/*
