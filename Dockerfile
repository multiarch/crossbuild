FROM buildpack-deps:jessie-curl

RUN set -x; \
    echo deb http://emdebian.org/tools/debian/ jessie main > /etc/apt/sources.list.d/emdebian.list \
 && curl -sL http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add - \
 && dpkg --add-architecture arm64    \
 && dpkg --add-architecture armel    \
 && dpkg --add-architecture armhf    \
 && dpkg --add-architecture mips     \
 && dpkg --add-architecture mipsel   \
 && dpkg --add-architecture powerpc  \
 && dpkg --add-architecture ppc64el  \
 && apt-get update

RUN apt-get install -y -q crossbuild-essential-arm64   \
 && apt-get install -y -q crossbuild-essential-armel   \
 && apt-get install -y -q crossbuild-essential-armhf   \
 && apt-get install -y -q crossbuild-essential-mipsel  \
 && apt-get install -y -q crossbuild-essential-ppc64el
# FIXME: add mips and powerpc
