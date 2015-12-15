FROM buildpack-deps:jessie-curl

# Install deps
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


# Install OSx cross-tools
ENV OSXCROSS_REVISION=a845375e028d29b447439b0c65dea4a9b4d2b2f6  \
    DARWIN_SDK_VERSION=10.10
RUN mkdir -p "/tmp/osxcross"                                                                                   \
 && cd "/tmp/osxcross"                                                                                         \
 && curl -sLo osxcross.tar.gz "https://codeload.github.com/tpoechtrager/osxcross/tar.gz/${OSXCROSS_REVISION}"  \
 && tar --strip=1 -xzf osxcross.tar.gz                                                                         \
 && rm -f osxcross.tar.gz                                                                                      \
 && curl -sLo tarballs/MacOSX${DARWIN_SDK_VERSION}.sdk.tar.xz                                                  \
        "https://www.dropbox.com/s/yfbesd249w10lpc/MacOSX${DARWIN_SDK_VERSION}.sdk.tar.xz"                     \
 && yes "" | SDK_VERSION="${DARWIN_SDK_VERSION}" OSX_VERSION_MIN=10.6 ./build.sh                               \
 && mv target /usr/osxcross                                                                                    \
 && rm -rf /tmp/osxcross                                                                                       \
 && rm -rf /usr/osxcross/SDK/MacOSX10.10.sdk/usr/share/man


# Create symlinks for triples
ENV LINUX_TRIPLES=arm-linux-gnueabi,powerpc64le-linux-gnu,aarch64-linux-gnu,arm-linux-gnueabihf,mipsel-linux-gnu  \
    DARWIN_TRIPLES=x86_64h-apple-darwin14,x86_64-apple-darwin14,i386-apple-darwin14
RUN for triple in $(echo ${LINUX_TRIPLES} | tr "," " "); do                       \
      for bin in /etc/alternatives/$triple-* /usr/bin/$triple-*; do               \
        if [ ! -f /usr/$triple/bin/$(basename $bin | sed "s/$triple-//") ]; then  \
          ln -s $bin /usr/$triple/bin/$(basename $bin | sed "s/$triple-//");      \
        fi;                                                                       \
      done;                                                                       \
    done
COPY ./assets/osxcross-wrapper /usr/bin/osxcross-wrapper
RUN for triple in $(echo ${DARWIN_TRIPLES} | tr "," " "); do                                     \
      mkdir -p /usr/$triple/bin;                                                                 \
      for bin in /usr/osxcross/bin/$triple-*; do                                                 \
        ln /usr/bin/osxcross-wrapper /usr/$triple/bin/$(basename $bin | sed "s/$triple-//");     \
      done &&                                                                                    \
      rm -f /usr/$triple/bin/clang*;                                                             \
    done
# we need to use default clang binary to avoid a bug in osxcross that recursively call himself
# with more and more parameters


# Image metadata
ENTRYPOINT ["/usr/bin/crossbuild"]
CMD ["/bin/bash"]
WORKDIR /workdir
COPY ./assets/crossbuild /usr/bin/crossbuild

