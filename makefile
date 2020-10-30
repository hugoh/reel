.DEFAULT_GOAL := help

.PHONY: pretty
pretty:
	fish_indent -w ./**/*.fish

.PHONY: help
help:
	@echo "help"
	@echo "    shows this message"
	@echo ""
	@echo "pretty"
	@echo "    Run fish_indent against all fish files. "
