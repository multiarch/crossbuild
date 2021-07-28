#!/bin/bash
set -xeo pipefail

# A POSIX variable
OPTIND=1 # Reset in case getopts has been used previously in the shell.

while getopts "d:" opt; do
    case "$opt" in
        d)  DOCKER_REPO=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

LINUX_TRIPLES="arm-linux-gnueabihf arm-linux-gnueabi powerpc64le-linux-gnu aarch64-linux-gnu arm-linux-gnueabihf mipsel-linux-gnu"
DARWIN_TRIPLES="x86_64-apple-darwin i386-apple-darwin x86_64h-apple-darwin"
WINDOWS_TRIPLES="x86_64-w64-mingw32 i686-w64-mingw32"
ALIAS_TRIPLES="arm armhf arm64 amd64 x86_64 mips mipsel powerpc powerpc64 powerpc64le osx darwin windows"
DOCKER_TEST_ARGS="--rm -v $(pwd)/test:/test -w /test"

for triple in ${DARWIN_TRIPLES} ${LINUX_TRIPLES} ${WINDOWS_TRIPLES} ${ALIAS_TRIPLES}; do
    docker run ${DOCKER_TEST_ARGS} -e CROSS_TRIPLE=${triple} ${DOCKER_REPO} make test;
done

docker run ${DOCKER_TEST_ARGS} -e CROSS_TRIPLE=i386-apple-darwin ${DOCKER_REPO} /usr/osxcross/bin/i386-apple-darwin14-cc helloworld.c -o helloworld
file test/helloworld
docker run ${DOCKER_TEST_ARGS} -e CROSS_TRIPLE=i386-apple-darwin ${DOCKER_REPO} /usr/i386-apple-darwin14/bin/cc helloworld.c -o helloworld
file test/helloworld
docker run ${DOCKER_TEST_ARGS} -e CROSS_TRIPLE=i386-apple-darwin ${DOCKER_REPO} cc helloworld.c -o helloworld
file test/helloworld
