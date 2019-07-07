#!/bin/bash
BUILD_START=$(date +"%s")

# Colours
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

# Kernel details
KERNEL_NAME="HyperPlus"
VERSION="Pie"
DATE=$(date +"%d-%m-%Y-%I-%M")
DEVICE="VKY"
FINAL_ZIP=$KERNEL_NAME-$VERSION-$DATE-$DEVICE.zip

# Dirs
KERNEL_DIR=~/Desktop/Code_Opensource
OUT_DIR=~/Desktop/out
UPLOAD_DIR=~/Desktop/Files/flash_zip
KERNEL_IMG=~/Desktop/out/arch/arm64/boot/Image.gz

# Make kernel
function make_kernel() {
  echo -e "$cyan***********************************************"
  echo -e "          Initializing defconfig          "
  echo -e "***********************************************$nocol"
  make ARCH=arm64 O=../out hyperplus_defconfig
  echo -e "$cyan***********************************************"
  echo -e "             Building kernel          "
  echo -e "***********************************************$nocol"
  PATH=~/Desktop/tools/toolchain/linux-x86/clang-r353983c/bin:~/Desktop/tools/toolchain/aarch64-linux-android-4.9/bin:${PATH} \
  make -j$(nproc --all) O=../out \
                      ARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-android-
  if ! [ -a $KERNEL_IMG ];
  then
    echo -e "$red Kernel Compilation failed! Fix the errors! $nocol"
    exit 1
  fi
}

# Options
function options() {
  echo -e "$cyan                                                 "
  echo -e " __  __     __  __     ______   ______     ______     "
  echo -e "/\ \_\ \   /\ \_\ \   /\  == \ /\  ___\   /\  == \    "
  echo -e "\ \  __ \  \ \____ \  \ \  _-/ \ \  __\   \ \  __<    "
  echo -e " \ \_\ \_\  \/\_____\  \ \_\    \ \_____\  \ \_\ \_\  "
  echo -e "  \/_/\/_/   \/_____/   \/_/     \/_____/   \/_/ /_/  "
  echo -e " "
  echo -e " ______   __         __  __     ______                "
  echo -e "/\  == \ /\ \       /\ \/\ \   /\  ___\               "
  echo -e "\ \  _-/ \ \ \____  \ \ \_\ \  \ \___  \              "
  echo -e " \ \_\    \ \_____\  \ \_____\  \/\_____\             "
  echo -e "  \/_/     \/_____/   \/_____/   \/_____/             "
  echo -e "                                                 $noco"
echo -e "$cyan***********************************************"
  echo "          Compiling HyperPlus kernel          "
  echo -e "***********************************************$nocol"
  echo -e " "
  echo -e " Select one of the following types of build : "
  echo -e " 1.Dirty"
  echo -e " 2.Clean"
  echo -n " Your choice : ? "
  read ch
  echo
  echo
  echo
  echo

case $ch in
  1) echo -e "$cyan***********************************************"
     echo -e "          	Dirty          "
     echo -e "***********************************************$nocol"
     make_kernel ;;
  2) echo -e "$cyan***********************************************"
     echo -e "          	Clean          "
     echo -e "***********************************************$nocol"
     make ARCH=arm64 distclean
     rm -rf ../out
     make_kernel ;;
esac

     echo
     echo
}

options
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"

