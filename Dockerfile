FROM buildpack-deps:stretch-curl
MAINTAINER Manfred Touron <m@42.am> (https://github.com/moul)

# Install deps
RUN set -x; echo "Starting image build for Debian Stretch" \
 && dpkg --add-architecture arm64                      \
 && dpkg --add-architecture armel                      \
 && dpkg --add-architecture armhf                      \
 && dpkg --add-architecture i386                       \
 && dpkg --add-architecture mips                       \
 && dpkg --add-architecture mipsel                     \
 && dpkg --add-architecture powerpc                    \
 && dpkg --add-architecture ppc64el                    \
 && apt-get update                                     \
 && apt-get install -y -q                              \
        autoconf                                       \
        automake                                       \
        autotools-dev                                  \
        bc                                             \
        binfmt-support                                 \
        binutils-multiarch                             \
        binutils-multiarch-dev                         \
        build-essential                                \
        ccache                                         \
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
        libtool                                        \
        llvm                                           \
        mercurial                                      \
        multistrap                                     \
        patch                                          \
        software-properties-common                     \
        subversion                                     \
        wget                                           \
        xz-utils                                       \
        cmake                                          \
        qemu-user-static                               \
        libxml2-dev                                    \
        lzma-dev                                       \
        openssl                                        \
        libssl-dev                                     \
 && apt-get clean
# FIXME: install gcc-multilib
# FIXME: add mips and powerpc architectures


# Install Windows cross-tools
RUN apt-get install -y mingw-w64 \
 && apt-get clean


# Install OSx cross-tools

#Build arguments
ARG osxcross_repo="tpoechtrager/osxcross"
ARG osxcross_revision="542acc2ef6c21aeb3f109c03748b1015a71fed63"
ARG darwin_sdk_version="10.10"
ARG darwin_osx_version_min="10.6"
ARG darwin_version="14"
ARG darwin_sdk_url="https://www.dropbox.com/s/yfbesd249w10lpc/MacOSX${darwin_sdk_version}.sdk.tar.xz"

# ENV available in docker image
ENV OSXCROSS_REPO="${osxcross_repo}"                   \
    OSXCROSS_REVISION="${osxcross_revision}"           \
    DARWIN_SDK_VERSION="${darwin_sdk_version}"         \
    DARWIN_VERSION="${darwin_version}"                 \
    DARWIN_OSX_VERSION_MIN="${darwin_osx_version_min}" \
    DARWIN_SDK_URL="${darwin_sdk_url}"

RUN mkdir -p "/tmp/osxcross"                                                                                   \
 && cd "/tmp/osxcross"                                                                                         \
 && curl -sLo osxcross.tar.gz "https://codeload.github.com/${OSXCROSS_REPO}/tar.gz/${OSXCROSS_REVISION}"  \
 && tar --strip=1 -xzf osxcross.tar.gz                                                                         \
 && rm -f osxcross.tar.gz                                                                                      \
 && curl -sLo tarballs/MacOSX${DARWIN_SDK_VERSION}.sdk.tar.xz                                                  \
             "${DARWIN_SDK_URL}"                \
 && yes "" | SDK_VERSION="${DARWIN_SDK_VERSION}" OSX_VERSION_MIN="${DARWIN_OSX_VERSION_MIN}" ./build.sh                               \
 && mv target /usr/osxcross                                                                                    \
 && mv tools /usr/osxcross/                                                                                    \
 && ln -sf ../tools/osxcross-macports /usr/osxcross/bin/omp                                                    \
 && ln -sf ../tools/osxcross-macports /usr/osxcross/bin/osxcross-macports                                      \
 && ln -sf ../tools/osxcross-macports /usr/osxcross/bin/osxcross-mp                                            \
 && sed -i -e "s%exec cmake%exec /usr/bin/cmake%" /usr/osxcross/bin/osxcross-cmake                             \
 && rm -rf /tmp/osxcross                                                                                       \
 && rm -rf "/usr/osxcross/SDK/MacOSX${DARWIN_SDK_VERSION}.sdk/usr/share/man"


# Create symlinks for triples and set default CROSS_TRIPLE
ENV LINUX_TRIPLES=arm-linux-gnueabi,arm-linux-gnueabihf,aarch64-linux-gnu,mipsel-linux-gnu,powerpc64le-linux-gnu                  \
    DARWIN_TRIPLES=x86_64h-apple-darwin${DARWIN_VERSION},x86_64-apple-darwin${DARWIN_VERSION},i386-apple-darwin${DARWIN_VERSION}  \
    WINDOWS_TRIPLES=i686-w64-mingw32,x86_64-w64-mingw32                                                                           \
    CROSS_TRIPLE=x86_64-linux-gnu
COPY ./assets/osxcross-wrapper /usr/bin/osxcross-wrapper
RUN mkdir -p /usr/x86_64-linux-gnu;                                                               \
    for triple in $(echo ${LINUX_TRIPLES} | tr "," " "); do                                       \
      for bin in /usr/bin/$triple-*; do                                                           \
        if [ ! -f /usr/$triple/bin/$(basename $bin | sed "s/$triple-//") ]; then                  \
          ln -s $bin /usr/$triple/bin/$(basename $bin | sed "s/$triple-//");                      \
        fi;                                                                                       \
      done;                                                                                       \
      for bin in /usr/bin/$triple-*; do                                                           \
        if [ ! -f /usr/$triple/bin/cc ]; then                                                     \
          ln -s gcc /usr/$triple/bin/cc;                                                          \
        fi;                                                                                       \
      done;                                                                                       \
    done &&                                                                                       \
    for triple in $(echo ${DARWIN_TRIPLES} | tr "," " "); do                                      \
      mkdir -p /usr/$triple/bin;                                                                  \
      for bin in /usr/osxcross/bin/$triple-*; do                                                  \
        ln /usr/bin/osxcross-wrapper /usr/$triple/bin/$(basename $bin | sed "s/$triple-//");      \
      done &&                                                                                     \
      rm -f /usr/$triple/bin/clang*;                                                              \
      ln -s cc /usr/$triple/bin/gcc;                                                              \
      ln -s /usr/osxcross/SDK/MacOSX${DARWIN_SDK_VERSION}.sdk/usr /usr/x86_64-linux-gnu/$triple;  \
    done;                                                                                         \
    for triple in $(echo ${WINDOWS_TRIPLES} | tr "," " "); do                                     \
      mkdir -p /usr/$triple/bin;                                                                  \
      for bin in /etc/alternatives/$triple-* /usr/bin/$triple-*; do                               \
        if [ ! -f /usr/$triple/bin/$(basename $bin | sed "s/$triple-//") ]; then                  \
          ln -s $bin /usr/$triple/bin/$(basename $bin | sed "s/$triple-//");                      \
        fi;                                                                                       \
      done;                                                                                       \
      ln -s gcc /usr/$triple/bin/cc;                                                              \
      ln -s /usr/$triple /usr/x86_64-linux-gnu/$triple;                                           \
    done
# we need to use default clang binary to avoid a bug in osxcross that recursively call himself
# with more and more parameters

ENV LD_LIBRARY_PATH /usr/osxcross/lib:$LD_LIBRARY_PATH

# Image metadata
ENTRYPOINT ["/usr/bin/crossbuild"]
CMD ["/bin/bash"]
WORKDIR /workdir
COPY ./assets/crossbuild /usr/bin/crossbuild
