# export common environment variables
DOCKER_REGISTRY_USERNAME = $(or $(shell printenv DOCKER_REGISTRY_USERNAME), )
DOCKER_REGISTRY_PASSWORD = $(or $(shell printenv DOCKER_REGISTRY_PASSWORD), )
DOCKER_REGISTRY = $(or $(shell printenv DOCKER_REGISTRY), datavocals)

# https://www.gnu.org/software/make/manual/make.html#index-_002eEXPORT_005fALL_005fVARIABLES
.EXPORT_ALL_VARIABLES:
export DOCKER_REGISTRY

# remove the PHONY no longer needed
.PHONY: all
all: docker-login docker-build-hadoop

.PHONY: docker-login
docker-login:
	docker login --username=$(DOCKER_REGISTRY_USERNAME)  --password=$(DOCKER_REGISTRY_PASSWORD)

.PHONY: docker-build-spark
docker-build-spark: spark/docker-build.sh
	/bin/bash spark/docker-build.sh

.PHONY: docker-build-hadoop
docker-build-hadoop: hadoop/docker-build.sh
	/bin/bash hadoop/docker-build.sh
