IMAGE = multiarch/cross-build
TRIPLES = arm-linux-gnueabi powerpc64le-linux-gnu aarch64-linux-gnu arm-linux-gnueabihf mipsel-linux-gnu
DOCKER_TEST_ARGS ?= -it --rm -v $(shell pwd)/test:/test -w /test

build:
	docker build -t $(IMAGE) .


shell: build
	docker run -it --rm $(IMAGE) /bin/bash


testshell: build
	docker run $(DOCKER_TEST_ARGS) --entrypoint=/bin/bash $(IMAGE)


test: build
	for triple in "" $(TRIPLES); do  \
	  rm -f test/helloworld;      \
	  docker run $(DOCKER_TEST_ARGS) -e CROSS_TRIPLE=$$triple $(IMAGE) make helloworld; \
	  file test/helloworld; \
	done
