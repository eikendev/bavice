TARGET := ./bin

.PHONY: lint
lint:
	shellcheck ${TARGET}/*

.PHONY: install
install:
	sudo chown root:bavice bin/bavice
	sudo chmod 750 bin/bavice
