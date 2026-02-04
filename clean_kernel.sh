#!/bin/bash

#To change the toolchain put its main path here

export TC=~/toolchains/zyc-clang-14
export CROSS_COMPILE=${TC}/bin/aarch64-linux-gnu-
export LD=${TC}/bin/ld.lld
export OBJCOPY=${TC}/bin/llvm-objcopy
export AS=${TC}/bin/llvm-as
export NM=${TC}/bin/llvm-nm
export STRIP=${TC}/bin/llvm-strip
export OBJDUMP=${TC}/bin/llvm-objdump
export READELF=${TC}/bin/llvm-readelf
export CC=${TC}/bin/clang
export CROSS_COMPILE_ARM32=${TC}/bin/arm-linux-gnueabi-
export ARCH=arm64
export ANDROID_MAJOR_VERSION=r

export KCFLAGS=' -w -pipe -O3'
export KCPPFLAGS=' -O3'
export CONFIG_SECTION_MISMATCH_WARN_ONLY=y

make -s -C $(pwd) O=$(pwd)/out KCFLAGS=' -w -pipe -O3' CONFIG_SECTION_MISMATCH_WARN_ONLY=y clean -j$(nproc) && make -s -C $(pwd) O=$(pwd)/out KCFLAGS='-w -O3' CONFIG_SECTION_MISMATCH_WARN_ONLY=y mrproper -j$(nproc)
make -C $(pwd) O=$(pwd)/out KCFLAGS=' -w -pipe -O3' CONFIG_SECTION_MISMATCH_WARN_ONLY=y -j$(nproc) nethunter_defconfig
