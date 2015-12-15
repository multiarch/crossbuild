IMAGE = multiarch/crossbuild:dev
LINUX_TRIPLES = arm-linux-gnueabihf arm-linux-gnueabi powerpc64le-linux-gnu aarch64-linux-gnu arm-linux-gnueabihf mipsel-linux-gnu
DARWIN_TRIPLES = x86_64-apple-darwin i386-apple-darwin x86_64h-apple-darwin
DOCKER_TEST_ARGS ?= -it --rm -v $(shell pwd)/test:/test -w /test


all: build


.PHONY: build
build: .built


.built: Dockerfile $(shell find ./assets/)
	docker build -t $(IMAGE) .
	docker inspect -f '{{.Id}}' $(IMAGE) > $@


.PHONY: shell
shell: .built
	docker run $(DOCKER_TEST_ARGS) $(IMAGE)


.PHONY: test
test: .built
	# generic test
	for triple in "" $(DARWIN_TRIPLES) $(LINUX_TRIPLES); do                         \
	  docker run $(DOCKER_TEST_ARGS) -e CROSS_TRIPLE=$$triple $(IMAGE) make test;   \
	done
	# osxcross wrapper testing
	docker run $(DOCKER_TEST_ARGS) -e CROSS_TRIPLE=i386-apple-darwin $(IMAGE) /usr/osxcross/bin/i386-apple-darwin14-cc helloworld.c -o helloworld
	file test/helloworld
	docker run $(DOCKER_TEST_ARGS) -e CROSS_TRIPLE=i386-apple-darwin $(IMAGE) /usr/i386-apple-darwin14/bin/cc helloworld.c -o helloworld
	file test/helloworld
	docker run $(DOCKER_TEST_ARGS) -e CROSS_TRIPLE=i386-apple-darwin $(IMAGE) cc helloworld.c -o helloworld
	file test/helloworld


.PHONY: test-inheritance
test-inheritance: .built
	docker build -t multiarch/crossbuild-test:objective-c-hello-world test/objective-c-hello-world


.PHONY: clean
clean:
	@rm -f .built
	@for cid in `docker ps | grep crossbuild | awk '{print $$1}'`; do docker kill $$cid; done || true


.PHONY: re
re: clean all
