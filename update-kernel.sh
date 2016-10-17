#Variables
#Edit These Appropriately

#Examples
#ANYKERNEL_DIR=/home/build/FKernel/AnyKernel2 <---Points to AnyKernelDir
#SOURCE_DIR=/home/build/FKernel/angler  <--- Points to Kernel Source Dir
#SCRIPTS_DIR=/home/build/FKernel/Scripts <--- Points to Scripts Dir
#ANYKERNEL_BRANCH=angler-flash-personal <--- Branch of AnyKernel chosen to run
#KERNEL_BRANCH=staging <--- Branch of Kernel chosen to compile
#SCRIPT=build-kernel.sh <--- Script to build Kernel
#UPDATE=update-kernel.sh <---- Current script name
#SLEEP=1 <--- if you want it to not pause and run fast set this to 0 set to 1 by default as it looks nicerthen spamming commands in cmd fast

ANYKERNEL_DIR=
SOURCE_DIR=
SCRIPTS_DIR=
ANYKERNEL_BRANCH=
KERNEL_BRANCH=
SCRIPT=
UPDATE=
SLEEP=1

#Don't Change These
KERNEL="Image.gz-dtb"
RED='\033[1;31m'
NC='\033[0m'

#Check if you forgot to set variables

if [[ -z ${ANYKERNEL_DIR} ]]; then
   echo "You did not edit the ANYKERNEL_DIR variable! Please edit that variable at the top of the update script and run it again."
   exit
fi

if [[ -z ${SOURCE_DIR} ]]; then
   echo "You did not edit the SOURCE_DIR variable! Please edit that variable at the top of the update script and run it again."
   exit
fi

if [[ -z ${SCRIPTS_DIR} ]]; then
   echo "You did not edit the SCRIPTS_DIR variable! Please edit that variable at the top of the update script and run it again."
   exit
fi

if [[ -z ${ANYKERNEL_BRANCH} ]]; then
   echo "You did not edit the ANYKERNEL_BRANCH variable! Please edit that variable at the top of the update script and run it again."
   exit
fi

if [[ -z ${KERNEL_BRANCH} ]]; then
   echo "You did not edit the KERNEL_BRANCH variable! Please edit that variable at the top of the update script and run it again."
   exit
fi

if [[ -z ${SCRIPT} ]]; then
   echo "You did not edit the SCRIPT variable! Please edit that variable at the top of the update script and run it again."
   exit
fi

if [[ -z ${UPDATE} ]]; then
   echo "You did not edit the UPDATE variable! Please edit that variable at the top of the update script and run it again."
   exit
fi


echo -e "${RED}Start Update"

echo
sleep ${SLEEP}
echo Cleaning AnyKernel Dir
echo -e "${NC}"
sleep ${SLEEP}

cd ${ANYKERNEL_DIR}
git checkout ${ANYKERNEL_BRANCH}
git reset --hard origin/${ANYKERNEL_BRANCH}
git clean -f -d -x > /dev/null 2>&1
rm -rf ${KERNEL} > /dev/null 2>&1
git pull
echo

echo -e "${RED}======================================================================="

echo
sleep ${SLEEP}
echo -e "Cleaning Source Dir${NC}"
sleep ${SLEEP}
echo
cd ${SOURCE_DIR}
git checkout ${BRANCH}
git reset --hard origin/${BRANCH}
git clean -f -d -x > /dev/null 2>&1
git pull
echo

echo -e "${RED}======================================================================="

echo
sleep ${SLEEP}
echo Copying ${SCRIPT}
echo
sleep ${SLEEP}
rm -rf ${SCRIPT}
sleep ${SLEEP}
cp ${SCRIPTS_DIR}/${SCRIPT} ${SOURCE_DIR}/${SCRIPT}
echo Copy Complete!
echo

echo -e "======================================================================="

echo
sleep ${SLEEP}
echo Copying ${UPDATE}
echo
sleep ${SLEEP}
cp ${SCRIPTS_DIR}/${UPDATE} ${SOURCE_DIR}/${UPDATE}
echo Copy Complete!
echo

echo -e "======================================================================="

echo
sleep 2
echo Update Complete!