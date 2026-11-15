# Convenience shortcuts — hooks/CI still call scripts/validate.sh directly.
.PHONY: check bootstrap hooks

check:
	bash scripts/validate.sh

bootstrap:
	bash scripts/bootstrap.sh

hooks:
	git config core.hooksPath .githooks
	chmod +x .githooks/*
