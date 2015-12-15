# crossbuild
:earth_africa: multiarch cross compiling environments

This is a multiarch Docker build environment image.
You can use this image to produce multiarch binairies.

## Supported targets

         | linux | osx
---------|-------|-----
x86_64   |   X   |  X
i386     |       |  X
arm      |   X   |
armhf    |   X   |
mips     |   X   |
powerpc  |   X   |
x86_64h  |       |  X

## Using crossbuild

#### x86_64

```console
$ docker run --rm -v $(pwd):/workdir multiarch/crossbuild make helloworld
cc helloworld.c -o helloworld
$ file helloworld
helloworld: ELF 64-bit LSB  executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=9cfb3d5b46cba98c5aa99db67398afbebb270cb9, not stripped
```

Misc: using `cc` instead of `make`

```console
$ docker run --rm -v $(pwd):/workdir multiarch/crossbuild cc test/helloworld.c
```

#### arm

```console
$ docker run --rm -v $(pwd):/workdir -e CROSS_TRIPLE=arm-linux-gnueabi multiarch/crossbuild make helloworld
cc     helloworld.c   -o helloworld
$ file helloworld
helloworld: ELF 32-bit LSB  executable, ARM, EABI5 version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=c8667acaa127072e05ddb9f67a5e48a337c80bc9, not stripped
```

#### armhf

```console
$ docker run --rm -v $(pwd):/workdir -e CROSS_TRIPLE=arm-linux-gnueabihf multiarch/crossbuild make helloworld
cc     helloworld.c   -o helloworld
$ file helloworld
helloworld: ELF 32-bit LSB  executable, ARM, EABI5 version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=ad507da0b9aeb78e7b824692d4bae6b2e6084598, not stripped
```

#### powerpc 64-bit el

```console
$ docker run --rm -v $(pwd):/workdir -e CROSS_TRIPLE=powerpc64le-linux-gnu multiarch/crossbuild make helloworld
cc     helloworld.c   -o helloworld
$ file helloworld
helloworld: ELF 64-bit LSB  executable, 64-bit PowerPC or cisco 7500, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=035c50a8b410361d3069f77e2ec2454c70a140e8, not st
ripped
```

#### arm64

```console
$ docker run --rm -v $(pwd):/workdir -e CROSS_TRIPLE=aarch64-linux-gnu multiarch/crossbuild make helloworld
cc     helloworld.c   -o helloworld
$ file helloworld
helloworld: ELF 64-bit LSB  executable, ARM aarch64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 3.7.0, BuildID[sha1]=dce6100f0bc19504bc19987535f3cc04bd550d60, not stripped
```

#### mips el

```console
$ docker run --rm -v $(pwd):/workdir -e CROSS_TRIPLE=mipsel-linux-gnu multiarch/crossbuild make helloworld
cc     helloworld.c   -o helloworld
$ file helloworld
helloworld: ELF 32-bit LSB  executable, MIPS, MIPS-II version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=d6b2f608a3c1a56b8b990be66eed0c41baaf97cd, not stripped
```

#### darwin i386

```console
$ docker run -it --rm -v $(pwd):/workdir -e CROSS_TRIPLE=i386-apple-darwin  multiarch/crossbuild make helloworld
o32-clang     helloworld.c   -o helloworld
$ file helloworld
helloworld: Mach-O executable i386
```

#### darwin x86_64

```console
$ docker run -it --rm -v $(pwd):/workdir -e CROSS_TRIPLE=x86_64-apple-darwin  multiarch/crossbuild make helloworld
o64-clang     helloworld.c   -o helloworld
$ file helloworld
helloworld: Mach-O 64-bit executable x86_64
```

## Target aliases

Triple                 | Aliases
-----------------------|---------------------------------
x86_64-linux-gnu       | **(default)**, amd64, x86_64
arm-linux-gnueabi      | arm, armv5
arm-linux-gnueabihf    | armhf, armv7, armv7l
mipsel-linux-gnu       | mips, mipsel
powerpc64le-linux-gnu  | powerpc, powerpc64, powerpc64le
x86_64-apple-darwin    | darwin, osx
x86_64h-apple-darwin   |
i386-apple-darwin      | 

## Using crossbuild in a Dockerfile

```Dockerfile
FROM multiarch/crossbuild
RUN git clone https://github.com/bit-spark/objective-c-hello-world
ENV CROSS_TRIPLE=x86_64-apple-darwin
WORKDIR /workdir/objective-c-hello-world
RUN crossbuild ./compile-all.sh
```

## Credit

This project is inspired by the [cross-compiler](https://github.com/steeve/cross-compiler) by the venerable [Steeve Morin](https://github.com/steeve)

## License

MIT
