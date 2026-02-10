#!/bin/bash

#u can use zyc clang 14 if u're unsure what toolchain to use. goodluck building sir
#edit the zyc clang directory name accordingly to ur toolchain.

export CROSS_COMPILE=~/toolchains/zyc-clang-14/bin/aarch64-linux-gnu-
export LD=~/toolchains/zyc-clang-14/bin/ld.lld
export OBJCOPY=~/toolchains/zyc-clang-14/bin/llvm-objcopy
export AS=~/toolchains/zyc-clang-14/bin/llvm-as
export NM=~/toolchains/zyc-clang-14/bin/llvm-nm
export STRIP=~/toolchains/zyc-clang-14/bin/llvm-strip
export OBJDUMP=~/toolchains/zyc-clang-14/bin/llvm-objdump
export READELF=~/toolchains/zyc-clang-14/bin/llvm-readelf
export CC=~/toolchains/zyc-clang-14/bin/clang
export CROSS_COMPILE_ARM32=~/toolchains/zyc-clang-14/bin/arm-linux-gnueabi-
export ARCH=arm64
export ANDROID_MAJOR_VERSION=r

export KCFLAGS=' -w -pipe -O3'
export KCPPFLAGS=' -O3'
export CONFIG_SECTION_MISMATCH_WARN_ONLY=y

make -C $(pwd) O=$(pwd)/out KCFLAGS=' -w -pipe -O3' CONFIG_SECTION_MISMATCH_WARN_ONLY=y clean -j$(nproc) && make -C $(pwd) O=$(pwd)/out KCFLAGS='-w -O3' CONFIG_SECTION_MISMATCH_WARN_ONLY=y mrproper -j$(nproc)
make -C $(pwd) O=$(pwd)/out KCFLAGS=' -w -pipe -O3' CONFIG_SECTION_MISMATCH_WARN_ONLY=y -j$(nproc) a32_vigus_defconfig
make -s -C $(pwd) O=$(pwd)/out KCFLAGS=' -w -pipe -O3' CONFIG_SECTION_MISMATCH_WARN_ONLY=y -j$(nproc)

read -p "copy to kornol directory? (are u vigus?) y/n   " choice
case "$choice" in 
  y|Y ) cp out/arch/arm64/boot/Image ~/Downloads/buildkernal/Image;;
  n|N ) echo "k";;
  * ) echo "nvm";;
esac
