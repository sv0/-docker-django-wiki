.SILENT:
SUDO=sudo
SHELL=/bin/bash
.PHONY: help

help:
	@grep -E '^[a-zA-Z\-\_0-9\.@]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build the image (VERSION)
	[[ "${VERSION}" ]] || (echo "VERSION param is required" && exit 1)
	${SUDO} docker build --build-arg VERSION=${VERSION} . -f ./Dockerfile -t quay.io/riotkit/django-wiki:${VERSION}

run: ## Run a test instance (VERSION)
	${SUDO} docker run --name djangowiki_test --rm quay.io/riotkit/django-wiki:${VERSION}

