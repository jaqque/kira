TAG=docker.io/jaqque/kira:latest
CONTAINER_ENGINE=podman
CONTAINER_NAME=kira

.PHONY: all
all: build run

.PHONY: build
build:
	@$(CONTAINER_ENGINE) build --tag ${TAG} .

run:
	@$(CONTAINER_ENGINE) run \
	  --hostname $(CONTAINER_NAME) \
	  --interactive \
	  --name $(CONTAINER_NAME) \
          --publish 3389:3389 \
	  --tty \
	  --volume $$PWD:/opt/repo \
	  ${TAG}

root:
	@$(CONTAINER_ENGINE) run \
	  --interactive \
	  --tty \
	  --user=root \
	  --volume $$PWD:/opt/repo \
	  ${TAG}
