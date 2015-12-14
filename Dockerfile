FROM buildpack-deps:jessie-curl

RUN set -x; \
    echo deb http://emdebian.org/tools/debian/ jessie main > /etc/apt/sources.list.d/emdebian.list \
 && curl -sL http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add - \
 && dpkg --add-architecture arm64                      \
 && dpkg --add-architecture armel                      \
 && dpkg --add-architecture armhf                      \
 && dpkg --add-architecture i386                       \
 && dpkg --add-architecture mips                       \
 && dpkg --add-architecture mipsel                     \
 && dpkg --add-architecture powerpc                    \
 && dpkg --add-architecture ppc64el                    \
 && apt-get update
RUN apt-get install -y -q                              \
        bc                                             \
        binfmt-support                                 \
        binutils-multiarch                             \
        binutils-multiarch-dev                         \
        build-essential                                \
        clang                                          \
        crossbuild-essential-arm64                     \
        crossbuild-essential-armel                     \
        crossbuild-essential-armhf                     \
        crossbuild-essential-mipsel                    \
        crossbuild-essential-ppc64el                   \
        curl                                           \
        devscripts                                     \
        gdb                                            \
        git-core                                       \
        llvm                                           \
        multistrap                                     \
        patch                                          \
        python-software-properties                     \
        software-properties-common                     \
        subversion                                     \
        wget                                           \
        xz-utils                                       \
 && apt-get clean
# FIXME: install gcc-multilib
# FIXME: add mips and powerpc architectures


# Install osxcross
ENV MACOSX_PATH "/root/OSXtoolchain"

RUN mkdir ${MACOSX_PATH}                                    \
 && cd ${MACOSX_PATH}                                       \
 && git clone https://github.com/tpoechtrager/osxcross.git  \
 && cd osxcross                                             \
 && git checkout a845375e028d29b447439b0c65dea4a9b4d2b2f6

ADD ./SDK ${MACOSX_PATH}/osxcross/tarballs

RUN cd ${MACOSX_PATH}/osxcross               \
 && (echo ""; echo ""; echo "") | ./build.sh

ENV TRIPLES=arm-linux-gnueabi,powerpc64le-linux-gnu,aarch64-linux-gnu,arm-linux-gnueabihf,mipsel-linux-gnu

RUN for triple in $(echo ${TRIPLES} | tr "," " "); do                       \
      for bin in /etc/alternatives/$triple-* /usr/bin/$triple-*; do         \
        ln -s $bin /usr/$triple/bin/$(basename $bin | sed "s/$triple-//");  \
      done;                                                                 \
    done;                                                                   \
    ls -la /usr/*-linux-*/bin

ENTRYPOINT ["/entrypoint"]
WORKDIR /workdir

ADD ./entrypoint /entrypoint
