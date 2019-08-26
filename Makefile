.SILENT:
SUDO=sudo
SHELL=/bin/bash
.PHONY: help
RIOTKIT_UTILS_VER=v1.2.2

help:
	@grep -E '^[a-zA-Z\-\_0-9\.@]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build the image (VERSION)
	[[ "${VERSION}" ]] || (echo "VERSION param is required" && exit 1)
	echo " >> Building ${VERSION}"
	${SUDO} docker build --build-arg VERSION=${VERSION} . -f ./Dockerfile -t quay.io/riotkit/django-wiki:${VERSION}

build_snapshot: ## Build current snapshot
	make build VERSION=master

push: ## Push to the registry
	${SUDO} docker push quay.io/riotkit/django-wiki:${VERSION}

run: ## Run a test instance (VERSION)
	${SUDO} docker run --name djangowiki_test --rm quay.io/riotkit/django-wiki:${VERSION}


### COMMON AUTOMATION

generate_readme: ## Renders the README.md from README.md.j2
	RIOTKIT_PATH=./.helpers ./.helpers/docker-generate-readme

before_commit: generate_readme ## Git hook before commit
	git add README.md

develop: ## Setup development environment, install git hooks
	echo " >> Setting up GIT hooks for development"
	mkdir -p .git/hooks
	echo "#\!/bin/bash" > .git/hooks/pre-commit
	echo "make before_commit" >> .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit

all: _download_tools ## Build all recent versions from github
	./.helpers/for-each-github-release --exec "make build push VERSION=%RELEASE_TAG%" --repo-name django-wiki/django-wiki --dest-docker-repo quay.io/riotkit/django-wiki --dont-rebuild --allowed-tags-regexp="releases/([0-9\.]+)$$" --release-tag-template="%MATCH_0%" --max-versions=5 --verbose

_download_tools:
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/extract-envs-from-dockerfile > .helpers/extract-envs-from-dockerfile
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/env-to-json                  > .helpers/env-to-json
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/for-each-github-release      > .helpers/for-each-github-release
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/docker-generate-readme       > .helpers/docker-generate-readme
	chmod +x .helpers/extract-envs-from-dockerfile .helpers/env-to-json .helpers/for-each-github-release .helpers/docker-generate-readme
