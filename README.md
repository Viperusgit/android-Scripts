# Scripts to make your life simpler #

# To use them first run #
git clone https://github.com/Viperusgit/android-Scripts Scripts

# To use the kernel script: #
1. Modify variables at the top of build-kernel.sh & update-kernel.sh
2. Copy modified build-kernel.sh & update-kernel.sh to Kernel Source Dir
3. Double check everything is defind correctly
4. Run bash build-kernel.sh

# To use the ROM script: #
1. Modify variables at the top of build-rom.sh
2. Copy build-rom.sh to ROM Source Dir
3. Double check everything is defind correctl
4. bash build-rom.sh <device> <sync/nosync> <clean/noclean> <log/nolog>


Credit to Nathan Chance.

Based parts of scripts off of his scripts.

Most handwritten.

All of kernel-update.sh was handwritten.

50-65% of build-kernel.sh was handwritten.

75% of build-rom.sh was handwritten.

Example of build-flash.sh was still changed but not as drastically as build-kernel.sh
