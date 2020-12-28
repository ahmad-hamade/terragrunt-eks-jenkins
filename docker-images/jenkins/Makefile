.ONESHELL:

# Debian/Ubuntu don't use bash
SHELL := /bin/bash

# Function to print a line separator
define LINE
===================================================
endef

AWS_ACCOUNT_ID := "$(aws)"
AWS_REGION_ID := "$(region)"

IMAGE_NAME := $(image)
ifeq ($(IMAGE_NAME),)
IMAGE_NAME := "backend"
endif

IMAGE_TAG := $(tag)
ifeq ($(IMAGE_TAG),)
IMAGE_TAG := "latest"
endif

.PHONY: dev
dev: ## Build and push image to DEV with a specific tag.
	@echo "Build and push image to DEV with tag: $(IMAGE_TAG)"
	@echo $(LINE)
	@aws ecr get-login-password --region $(AWS_REGION_ID) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION_ID).amazonaws.com
	@docker build -t dev/jenkins/$(IMAGE_NAME):$(IMAGE_TAG) . -f $(IMAGE_NAME).Dockerfile && \
	docker tag dev/jenkins/$(IMAGE_NAME):$(IMAGE_TAG) $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION_ID).amazonaws.com/dev/jenkins/$(IMAGE_NAME):$(IMAGE_TAG) && \
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION_ID).amazonaws.com/dev/jenkins/$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: help
help: ## Show this list of commands
	@printf "\033[32mJenkins agent docker utils$(version)\033[0m\n"
	@echo $(LINE)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := default
default: help
