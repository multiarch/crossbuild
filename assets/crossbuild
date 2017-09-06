#!/bin/sh

# alternative names mapping
case "${CROSS_TRIPLE}" in
    x86_64-linux-gnu|linux|x86_64|amd64)
	CROSS_TRIPLE="x86_64-linux-gnu" ;;
    arm-linux-gnueabi|arm|armv5)
	CROSS_TRIPLE="arm-linux-gnueabi" ;;
    arm-linux-gnueabihf|armhf|armv7|armv7l)
	CROSS_TRIPLE="arm-linux-gnueabihf" ;;
    aarch64-linux-gnu|arm64|aarch64)
	CROSS_TRIPLE="aarch64-linux-gnu" ;;
    mipsel-linux-gnu|mips|mipsel)
	CROSS_TRIPLE="mipsel-linux-gnu" ;;
    powerpc64le-linux-gnu|powerpc|powerpc64|powerpc64le)
	CROSS_TRIPLE="powerpc64le-linux-gnu" ;;
    x86_64-apple-darwin|osx|osx64|darwin|darwin64)
	CROSS_TRIPLE="x86_64-apple-darwin${DARWIN_VERSION}" ;;
    x86_64h-apple-darwin|osx64h|darwin64h|x86_64h)
	CROSS_TRIPLE="x86_64h-apple-darwin${DARWIN_VERSION}" ;;
    i386-apple-darwin|osx32|darwin32)
	CROSS_TRIPLE="i386-apple-darwin${DARWIN_VERSION}" ;;
    *-apple-darwin)
	CROSS_TRIPLE="${CROSS_TRIPLE}${DARWIN_VERSION}" ;;
    x86_64-w64-mingw32|windows|win64)
	CROSS_TRIPLE="x86_64-w64-mingw32" ;;
    i686-w64-mingw32|win32)
	CROSS_TRIPLE="i686-w64-mingw32" ;;
    i386-linux-gnu|i386)
	echo "i386-linux-gnu not yet implemented." && exit 1 ;;
    *)
	echo "${CROSS_TRIPLE} not yet implemented." && exit 1 ;;
esac

# store original PATH and LD_LIBRARY_PATH
if [ -z ${PATH_ORIGIN+x} ]; then export PATH_ORIGIN=${PATH}; fi
if [ -z ${LD_LIBRARY_PATH_ORIGIN+x} ]; then export LD_LIBRARY_PATH_ORIGIN=${LD_LIBRARY_PATH}; fi

# configure environment
if [ -n "${CROSS_TRIPLE}" ]; then
    export CROSS_ROOT="/usr/${CROSS_TRIPLE}"
    export PATH="${CROSS_ROOT}/bin:${PATH_ORIGIN}"
    export LD_LIBRARY_PATH="/usr/x86_64-linux-gnu/${CROSS_TRIPLE}/lib:${LD_LIBRARY_PATH_ORIGIN}"
fi

# try to exec direct binary instead on relying on the $PATH
binary=$1
shift
if [ -n "${CROSS_TRIPLE}" -a -f "${CROSS_ROOT}/bin/$binary" ]; then
    binary="${CROSS_ROOT}/bin/$binary"
fi

# finally exec
exec "${binary}" "$@"
exit $?
