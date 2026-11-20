# renovate: datasource=docker depName=squidfunk/mkdocs-material
MKDOCS_VERSION ?= 9.6.22

.PHONY: help docs docs-serve check

help: ## Show this help.
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-12s %s\n", $$1, $$2}'

docs: ## Build the website strictly (fails on broken links).
	docker run --rm -v "$(CURDIR):/docs" squidfunk/mkdocs-material:$(MKDOCS_VERSION) build --strict --site-dir /tmp/site

docs-serve: ## Preview the website on http://localhost:8000.
	docker run --rm -it -p 8000:8000 -v "$(CURDIR):/docs" squidfunk/mkdocs-material:$(MKDOCS_VERSION)

check: ## Check punctuation and umlauts, then build the website.
	./scripts/lint.sh
	$(MAKE) docs
