#!/bin/bash

## Credit goes to Nathan Chance
## Script based off build-flash

#  Variables
# These MUST be edited for the script to work
# SOURCE_DIR: Directory that holds your kernel source
# e.g. SOURCE_DIR=/home/build/FKernel/angler
SOURCE_DIR=
# ANYKERNEL_DIR: Directory that holds your AnyKernel source
# e.g. ANYKERNEL_DIR=/home/build/FKernel/AnyKernel2
ANYKERNEL_DIR=
# TOOLCHAIN_DIR: Directory that holds the toolchain repo
# e.g. TOOLCHAIN_DIR=/home/build/FKernel/aarch64-linux-android-6.1-linaro
TOOLCHAIN_DIR=
# UPDATE: Script to update and clean directories
# e.g. UPDATE=update-kernel.sh Totally optional but completly recommended
UPDATE=
# DEVICE: The device you want to compile for
# e.g. DEVICE=angler
DEVICE=
# DEFCONFIG: The config file for your kernel usually kernelname_defconfig 
# e.g. DEFCONFIG="flash_defconfig"
DEFCONFIG=
# FUNCTIONS

# Prints a formatted header; used for outlining what the script is doing to the user
function echoText() {
   RED="\033[01;31m"
   RST="\033[0m"

   echo -e ${RED}
   echo -e "====$( for i in $( seq ${#1} ); do echo -e "=\c"; done )===="
   echo -e "==  ${1}  =="
   echo -e "====$( for i in $( seq ${#1} ); do echo -e "=\c"; done )===="
   echo -e ${RST}
}


# Creates a new line
function newLine() {
   echo -e ""
}


#######################
##  OTHER VARIABLES  ##
#######################
# DO NOT EDIT
RED="\033[01;31m"
BLINK_RED="\033[05;31m"
RESTORE="\033[0m"
THREAD="-j$(grep -c ^processor /proc/cpuinfo)"
KERNEL="Image.gz-dtb"
ZIMAGE_DIR="${SOURCE_DIR}/arch/arm64/boot"


####################
##  SCRIPT START  ##
####################
# Configure build
export CROSS_COMPILE="${TOOLCHAIN_DIR}/bin/aarch64-linux-android-"
export ARCH=arm64
export SUBARCH=arm64


# Clear the terminal
clear


# Show the version of the kernel compiling
echo -e ${RED}; newLine

# Start tracking time
echoText "BUILD SCRIPT STARTING AT $(date +%D\ %r)"

DATE_START=$(date +"%s")


# Clean previous build and update repos
echoText "CLEANING UP AND UPDATING"; newLine

# Clean and update directories
bash ${UPDATE}

# Clean make
make clean
make mrproper


# Set kernel version
KERNEL_VER=$( grep -r "EXTRAVERSION = -" ${SOURCE_DIR}/Makefile | sed 's/EXTRAVERSION = -//' )
# Set zip name based on device and kernel version
ZIP_NAME=${KERNEL_VER}-${DEVICE}


# Make the kernel
newLine; echoText "MAKING ${KERNEL_VER}"; newLine

make ${DEFCONFIG}
make ${THREAD}


# If the above was successful
if [[ `ls ${ZIMAGE_DIR}/${KERNEL} 2>/dev/null | wc -l` != "0" ]]; then
   BUILD_RESULT_STRING="BUILD SUCCESSFUL"


   # Make the zip file
   newLine; echoText "MAKING FLASHABLE ZIP"; newLine

   cp -vr ${ZIMAGE_DIR}/${KERNEL} ${ANYKERNEL_DIR}/zImage
   cd ${ANYKERNEL_DIR}
   zip -r9 ${ZIP_NAME}.zip * -x README ${ZIP_NAME}.zip

else
   BUILD_RESULT_STRING="BUILD FAILED"
fi


# Go home
cd ${HOME}


# End the script
newLine; echoText "${BUILD_RESULT_STRING}!"; newLine

DATE_END=$(date +"%s")
DIFF=$((${DATE_END} - ${DATE_START}))

echo -e ${RED}"SCRIPT DURATION: $((${DIFF} / 60)) MINUTES AND $((${DIFF} % 60)) SECONDS"
if [[ "${BUILD_RESULT_STRING}" == "BUILD SUCCESSFUL" ]]; then
   echo -e "ZIP LOCATION: ${ANYKERNEL_DIR}/${ZIP_NAME}.zip"
   echo -e "SIZE: $( du -h ${ANYKERNEL_DIR}/${ZIP_NAME}.zip | awk '{print $1}' )"
fi
echo -e ${RESTORE}
