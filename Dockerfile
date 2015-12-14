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
        python-software-properties                     \
        software-properties-common                     \
        subversion                                     \
        wget                                           \
 && apt-get clean
# FIXME: install gcc-multilib
# FIXME: add mips and powerpc architectures
