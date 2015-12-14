IMAGE = multiarch/cross-build

build:
	docker build -t $(IMAGE) .


shell: build
	docker run -it --rm $(IMAGE) /bin/bash


test: build
	rm -f test/helloworld
	docker run -it --rm -v $(shell pwd)/test:/test -w /test $(IMAGE) /bin/bash
