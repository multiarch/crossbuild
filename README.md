# crossbuild
:earth_africa: multiarch cross compiling environments

This is a multiarch Docker build environment image.
You can use this image to produce multiarch binairies.

## Using crossbuild

#### x86_64

```command
$ docker run --rm -v $(pwd):/workdir multiarch/cross-build make helloworld
cc helloworld.c -o helloworld
$ file helloworld
helloworld: ELF 64-bit LSB  executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=9cfb3d5b46cba98c5aa99db67398afbebb270cb9, not stripped
```

Misc: using `cc` instead of `make`

```command
$ docker run --rm -v $(pwd):/workdir multiarch/cross-build cc helloworld.c
```

#### arm

```command
$ docker run --rm -v $(pwd):/workdir -e CROSS_TRIPLE=arm-linux-gnueabi multiarch/cross-build make helloworld
cc     helloworld.c   -o helloworld
$ file helloworld
helloworld: ELF 32-bit LSB  executable, ARM, EABI5 version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=c8667acaa127072e05ddb9f67a5e48a337c80bc9, not stripped
```

#### powerpc 64-bit el

```command
$ docker run --rm -v $(pwd):/workdir -e CROSS_TRIPLE=powerpc64le-linux-gnu multiarch/cross-build make helloworld
cc     helloworld.c   -o helloworld
$ file helloworld
helloworld: ELF 64-bit LSB  executable, 64-bit PowerPC or cisco 7500, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=035c50a8b410361d3069f77e2ec2454c70a140e8, not st
ripped
```

#### arm64

```command
$ docker run --rm -v $(pwd):/workdir -e CROSS_TRIPLE=aarch64-linux-gnu multiarch/cross-build make helloworld
cc     helloworld.c   -o helloworld
$ file helloworld
helloworld: ELF 64-bit LSB  executable, ARM aarch64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 3.7.0, BuildID[sha1]=dce6100f0bc19504bc19987535f3cc04bd550d60, not stripped
```

#### mips el

```command
$ docker run --rm -v $(pwd):/workdir -e CROSS_TRIPLE=mipsel-linux-gnu multiarch/cross-build make helloworld
cc     helloworld.c   -o helloworld
$ file helloworld
helloworld: ELF 32-bit LSB  executable, MIPS, MIPS-II version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=d6b2f608a3c1a56b8b990be66eed0c41baaf97cd, not stripped
```

## Credit

This project is inspired by the [cross-compiler](https://github.com/steeve/cross-compiler) by the venerable [Steeve Morin](https://github.com/steeve)

## License

MIT
