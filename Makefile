APP_NAME=amiga-cc-toolchain
DOCKER_REPO=mikaheim
VERSION=$(shell git symbolic-ref -q --short HEAD || git describe --tags --exact-match)
GIT_REF=$(shell git rev-parse --short HEAD)
NOW_DATE=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')

# Show help if no command given
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# Docker build
build: ## Build the container
	docker build -t $(APP_NAME) --build-arg VERSION=$(VERSION) --build-arg GIT_REF=$(GIT_REF) --build-arg BUILD_DATE=$(NOW_DATE) .
build-nc: ## Build the container without caching
	docker build --no-cache -t $(APP_NAME) --build-arg VERSION=$(VERSION) --build-arg GIT_REF=$(GIT_REF) --build-arg BUILD_DATE=$(NOW_DATE) .

# Make release
release: build-nc publish ## Make a release by building and publishing the `{version}` ans `latest` tagged containers

# Docker publish
publish: publish-latest publish-version ## Publish the `{version}` ans `latest` tagged containers

publish-latest: tag-latest ## Publish the `latest` taged container
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `{version}` taged container
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` and `latest`

tag-latest: ## Generate container `{version}` tag
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Generate container `latest` tag
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

version: ## Output the current version
	@echo $(VERSION)