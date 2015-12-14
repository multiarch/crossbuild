FROM buildpack-deps:jessie-curl

RUN set -x; \
    echo deb http://emdebian.org/tools/debian/ jessie main > /etc/apt/sources.list.d/emdebian.list \
 && curl -sL http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add - \
 && dpkg --add-architecture arm64 \
 && dpkg --add-architecture armel \
 && dpkg --add-architecture armhf \
 && dpkg --add-architecture mips \
 && dpkg --add-architecture mipsel \
 && dpkg --add-architecture powerpc \
 && dpkg --add-architecture ppc64el \
 && apt-get update

RUN apt-get install -y -q crossbuild-essential-arm64
RUN apt-get install -y -q crossbuild-essential-armel
RUN apt-get install -y -q crossbuild-essential-armhf
RUN apt-get install -y -q crossbuild-essential-mips
RUN apt-get install -y -q crossbuild-essential-mipsel
RUN apt-get install -y -q crossbuild-essential-powerpc
RUN apt-get install -y -q crossbuild-essential-ppc64el
