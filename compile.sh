#!/usr/bin/env bash


rm -rf $(pwd)/out
rm -f $(pwd)/Kernel-for-atoll.tar

export ARCH=arm64
export PATH="${HOME}/aarch64-linux-android-4.9/bin:${HOME}/linux-x86/clang-r383902/bin:${PATH}"
make -j8 clean
make -j8 mrproper
make -j8 distclean
make O=out ARCH=arm64 vendor/kernel_defconfig
read -p "Enter a Key to continue"
make -j8 O=out ARCH=arm64 \
CROSS_COMPILE=aarch64-linux-android- \
CLANG_TRIPLE=aarch64-linux-gnu- \
CC=clang \
DTC_EXT=$(pwd)/tools/dtc

mv $(pwd)/out/arch/arm64/boot/dts/qcom/*.dtb $(pwd)/AIK/split_img/boot.img-dtb
mv $(pwd)/out/arch/arm64/boot/Image $(pwd)/AIK/split_img/boot.img-kernel
cd $(pwd)/AIK/
rm -f $(pwd)/*.gz
rm -f $(pwd)/image-new.img
./repackimg.sh
mv image-new.img boot.img
tar -cvf $(pwd)/Kernel-for-atoll.tar boot.img
mv $(pwd)/Kernel-for-atoll.tar ../../
