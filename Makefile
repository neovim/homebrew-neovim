#
# Makefile to automate Formula updates
#


SHELL := $(shell which bash)

SCRIPTS := scripts


help:
	@echo "Target rules"
	@echo "version   - Updates Neo Vim version based on last commit"


version:
	./${SCRIPTS}/$@.sh
