# Lua on microbit
[Lua](https://www.lua.org/) on [microbit(V1.5)](https://tech.microbit.org/hardware/1-5-revision/)

# gcc
```
$ arm-none-eabi-gcc --version
arm-none-eabi-gcc (GNU Tools for Arm Embedded Processors 7-2018-q2-update) 7.3.1 20180622 (release) [ARM/embedded-7-branch revision 261907]
Copyright (C) 2017 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

# build
```
$ git clone https://github.com/NordicSemiconductor/nrfx.git
$ cd nrfx
$ git checkout v2.4.0
$ cd ..
$ git clone https://sourceware.org/git/newlib-cygwin.git
$ cd newlib-cygwin
$ git checkout newlib-3.3.0
$ cd ..
$ git https://github.com/ARM-software/CMSIS_5.git

$ cd ..
$ make
```

# Run qemu
```
$ qemu-system-arm --version
  QEMU emulator version 4.2.1 (Debian 1:4.2-3ubuntu6.10)
  Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers
$ qemu-system-arm -M microbit -device loader,file=main.hex -serial stdio
```

# build new libs

## Newlib(crt0.o libc.a libm.a libnosys.a)
```
$ git clone https://sourceware.org/git/newlib-cygwin.git
$ cd newlib-cygwin
$ git checkout newlib-3.3.0
$ mkdir build
$ ../configure --build=x86_64-linux-gnu --host=x86_64-linux-gnu \
--target=arm-none-eabi --disable-newlib-supplied-syscalls \
 --enable-newlib-reent-check-verify --enable-newlib-reent-small \
 --enable-newlib-retargetable-locking --disable-newlib-fvwrite-in-streamio \
 --disable-newlib-fseek-optimization --disable-newlib-wide-orient \
 --enable-newlib-nano-malloc --disable-newlib-unbuf-stream-opt --enable-lite-exit \
 --enable-newlib-global-atexit --enable-newlib-nano-formatted-io --disable-nls
$ CFLAGS='-g -Os -ffunction-sections -fdata-sections' make -j4
```

## printf
```
$ cd printf
$ make
```

