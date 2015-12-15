FROM multiarch/crossbuild:dev

RUN git clone https://github.com/bit-spark/objective-c-hello-world

ENV CROSS_TRIPLE=x86_64-apple-darwin

WORKDIR /workdir/objective-c-hello-world

RUN crossbuild sh -x ./compile-all.sh

RUN file *.out
