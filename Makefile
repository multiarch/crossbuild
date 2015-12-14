IMAGE = multiarch/cross-build

build:
	docker build -t $(IMAGE) .


shell: build
	docker run -it --rm $(IMAGE) /bin/bash
