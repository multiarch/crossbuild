IMAGE = multiarch/cross-build
LINUX_TRIPLES = arm-linux-gnueabi powerpc64le-linux-gnu aarch64-linux-gnu arm-linux-gnueabihf mipsel-linux-gnu
DARWIN_TRIPLES = x86_64-apple-darwin14 i386-apple-darwin14
# FIXME: handle x86_64h-apple-darwin14
DOCKER_TEST_ARGS ?= -it --rm -v $(shell pwd)/test:/test -w /test


all: build


.PHONY: build
build: .built


.built: Dockerfile $(shell find ./assets/)
	docker build -t $(IMAGE) .
	docker inspect -f '{{.Id}}' $(IMAGE) > $@


.PHONY: shell
shell: .built
	docker run -it --rm $(IMAGE) /bin/bash


.PHONY: testshell
testshell: .built
	docker run $(DOCKER_TEST_ARGS) --entrypoint=/bin/bash $(IMAGE)


.PHONY: test
test: .built
	for triple in "" $(DARWIN_TRIPLES) $(LINUX_TRIPLES); do                         \
	  docker run $(DOCKER_TEST_ARGS) -e CROSS_TRIPLE=$$triple $(IMAGE) make test;   \
	done


.PHONY: clean
clean:
	@rm -f .built
	@for cid in `docker ps | grep crossbuild | awk '{print $$1}'`; do docker kill $cid; done || true


.PHONY: re
re: clean all
