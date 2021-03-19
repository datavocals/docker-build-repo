# export common environment variables
DOCKER_REGISTRY_USERNAME = $(or $(shell printenv DOCKER_REGISTRY_USERNAME), "")
DOCKER_REGISTRY_PASSWORD = $(or $(shell printenv DOCKER_REGISTRY_PASSWORD), "")
DOCKER_REGISTER = $(or $(shell printenv DOCKER_REGISTRY), "tinkmaster")

# remove the PHONY no longer needed
.PHONY: all
all: export-env docker-login docker-build-spark-2.4.7

.PHONY: export-env
export-env:
	export DOCKER_REGISTER=$DOCKER_REGISTER

.PHONY: docker-login
docker-login:
	docker login --username=$(DOCKER_REGISTRY_USERNAME)  --password=$(DOCKER_REGISTRY_PASSWORD)

.PHONY: docker-build-spark-2.4.7
docker-build-spark-2.4.7: spark/2.4.7/docker-build.sh
	/bin/bash spark/2.4.7/docker-build.sh
