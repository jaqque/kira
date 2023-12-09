TAG=docker.io/jaqque/kira:latest

.PHONY: all
all: build run

.PHONY: build
build:
	@docker build --tag ${TAG} .

run:
	@docker run \
	  --interactive \
	  --tty \
	  --volume $$PWD:/opt/repo \
	  ${TAG}

root:
	@docker run \
	  --interactive \
	  --tty \
	  --user=root \
	  --volume $$PWD:/opt/repo \
	  ${TAG}
