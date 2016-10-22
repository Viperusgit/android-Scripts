#completly handwritten
#Variables
#Edit These Appropriately

#Examples
#ANYKERNEL_DIR=/home/build/FKernel/AnyKernel2 <---- Points to AnyKernelDir
#BACKUP=true <---- backup specific files
#BACKUP_DIR=/home/build/FKernel/Scripts/backup <---- Backup dir (must be named backup)
#BACKUP_FILEA=Makefile <---- first file to backup
#BACKUP_FILEB= <---- second file to backup
#BACKUP_FILEC= <---- third file to backup
#SOURCE_DIR=/home/build/FKernel/angler  <---- Points to Kernel Source Dir
#SCRIPTS_DIR=/home/build/FKernel/Scripts <---- Points to Scripts Dir
#ANYKERNEL_BRANCH=angler-flash-personal <---- Branch of AnyKernel chosen to run
#KERNEL_BRANCH=staging <---- Branch of Kernel chosen to compile
#SCRIPT=build-kernel.sh <---- Script to build Kernel
#UPDATE=update-kernel.sh <---- Current script name
#SLEEP=1 <---- if you want it to not pause and run fast set this to 0 set to 1 by default as it looks nicerthen spamming commands in cmd fast

ANYKERNEL_DIR=
BACKUP=false
BACKUP_DIR=#if you are gonna use this make sure /backup is the file name
BACKUP_FILEA=
BACKUP_FILEB=
BACKUP_FILEC=
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

if [[ "${BACKUP}" == "true" ]]; then
	if [[ ${BACKUP_DIR} =~ .*backup* ]]
	then
		sleep ${SLEEP}
		echo -e "${RED}Backing up selected files"
		sleep ${SLEEP}
		echo
    	echo =======================================================================
		echo
		cd ${SOURCE_DIR}
		if [[ "${BACKUP_FILEA}" == "" ]]; then
			echo
		else
			sleep ${SLEEP}
			cp ${BACKUP_FILEA} ${BACKUP_DIR}
			echo Copying ${BACKUP_FILEA}
			echo
		fi

		if [[ "${BACKUP_FILEB}" == "" ]]; then
			echo
		else
			sleep ${SLEEP}
			cp ${BACKUP_FILEB} ${BACKUP_DIR}
			echo Copying ${BACKUP_FILEB}
			echo
		fi

		if [[ "${BACKUP_FILEC}" == "" ]]; then
			echo
		else
			sleep ${SLEEP}
			cp ${BACKUP_FILEC} ${BACKUP_DIR}
			echo Copying ${BACKUP_FILEC}
			echo
		fi
		echo =======================================================================
	fi
else
	sleep ${SLEEP}
	echo -e "${RED}Back up mode disabled"
	echo
    echo =======================================================================
fi
echo 

echo Start Update

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
git checkout ${KERNEL_BRANCH}
git reset --hard origin/${KERNEL_BRANCH}
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

if [[ "${BACKUP}" == "true" ]]; then
	if [[ ${BACKUP_DIR} =~ .*backup* ]]
	then
		sleep ${SLEEP}
		echo -e "${RED}Restoring files"
		cd ${BACKUP_DIR}
			if [[ "${BACKUP_FILEA}" == "" ]]; then
			echo
		else
			sleep ${SLEEP}
			cd ${BACKUP_DIR}
			cp ${BACKUP_FILEA} ${SOURCE_DIR}
			echo Restoring ${BACKUP_FILEA}
			echo
		fi

		if [[ "${BACKUP_FILEB}" == "" ]]; then
			echo
		else
			sleep ${SLEEP}
			cd ${BACKUP_DIR}
			cp ${BACKUP_FILEB} ${SOURCE_DIR}
			echo Restoring ${BACKUP_FILEB}
			echo
		fi

		if [[ "${BACKUP_FILEC}" == "" ]]; then
			echo
		else
			sleep ${SLEEP}
			cd ${BACKUP_DIR}
			cp ${BACKUP_FILEC} ${SOURCE_DIR}
			echo Restoring ${BACKUP_FILEC}
			echo
		fi
	fi
	echo -e "======================================================================="
fi


echo
sleep 2
echo Update Complete!
