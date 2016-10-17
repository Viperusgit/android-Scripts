#Partial Credit to Nathan Chance
#Some things used from his DU script
#The rest handwritten

#NOTE: Double Hashtags used to represent where hashtags are or where hashtags can be added

#How to use: sudo(optional depending if used sudo to make anything in source) bash build-rom.sh <device> <sync/nosync> <clean/noclean> <log/nolog>
#e.g. sudo bash build-rom.sh angler sync noclean nolog
#Device=Device name
#Sync=Repo Sync
#Clean=Clean build
#Log=Makes log

#Examples
#SOURCE_DIR=/home/build/du <---- Rom Source Dir
#DEST_DIR=/home/build/DUBuildBackups <---- Place where you want rom saved
#LOGDIR=$( dirname ${SOURCE_DIR} )/build-logs <---- Nothing to change here don't change it
##DEVICE=angler <---- Remove hashtag explained below
##SYNC=sync <---- Remove hashtag explained below
##CLEAN=clean <---- Remove hashtag explained below
##LOG=log <---- Remove hashtag explained below
#OUTDIR=${SOURCE_DIR}/out/target/product/${DEVICE} <---- Nothing to change here don't change it
#ZIPFORMAT=DU_${DEVICE}_*.zip <---- Stock zipformat usally (Rom abriviation)_(Devive name)_(date/time).zip the * sums up date/time so dont change the star 
#MD5FORMAT=DU_${DEVICE}_*.zip.md5sum <---- Stock md5sum usally (Rom abriviation)_(Devive name)_(date/time).zip.md5sum the * sums up date/time so dont change the star 
#NEW_ZIP=DU-Unoffical-OMS-`date +"%m-%d"`.zip <---- What you want the zip to be named in Dest Dir
#NEW_MD5=DU-Unoffical-OMS-`date +"%m-%d"`.zip.md5sum <---- what you want the md5sum to be named in Dest Dir
#NINJA=false <---- use ninja? off by default as it causes more issues
#BUILD_USER=Skye <---- For custom user@host in kernel leave blank if you prefer stock
#BUILD_HOST=Unofficial <---- For custom user@host in kernel leave blank ifyou prefer stock
#BUILD_TYPE= <---- For custom rom version leave blank for stock
#ROM_NICK=DU <---- Two letters to represent rom

SOURCE_DIR=
DEST_DIR=
LOGDIR=$( dirname ${SOURCE_DIR} )/build-logs
#DEVICE= <---- if for some reason its not building insert device name here
#SYNC= <---- if not syncing insert sync here
#CLEAN= <---- If not clean insert clean here
#LOG= <---- if not making log insert log here
OUTDIR=${SOURCE_DIR}/out/target/product/${DEVICE}
ZIPFORMAT=DU_${DEVICE}_*.zip
MD5FORMAT=DU_${DEVICE}_*.zip.md5sum
NEW_ZIP=DU-Unoffical-OMS-`date +"%m-%d"`.zip
NEW_MD5=DU-Unoffical-OMS-`date +"%m-%d"`.zip.md5sum
NINJA=false
BUILD_USER=Skye
BUILD_HOST=Unofficial
BUILD_TYPE=
ROM_NICK=DU


# Functions
function echoText() {
   RED="\033[01;31m"
   RST="\033[0m"

   echo -e ${RED}
   echo -e "$( for i in `seq ${#1}`; do echo -e "-\c"; done )"
   echo -e "${1}"
   echo -e "$( for i in `seq ${#1}`; do echo -e "-\c"; done )"
   echo -e ${RST}
}

# Creates a new line
function newLine() {
   echo -e ""
}

# Parameters
#If hashtags removed above add hashtags here
#e.g.
##DEVICE=${1}
##SYNC=${2}
##CLEAN=${3}
##LOG=${4}
DEVICE=${1}
SYNC=${2}
CLEAN=${3}
LOG=${4}

export USE_NINJA=${NINJA}

rm -rf ~./jack*

export ANDROID_JACK_VM_ARGS="-Xmx5g -Dfile.encoding=UTF-8 -XX:+TieredCompilation"

./prebuilts/sdk/tools/jack-admin kill-server
./prebuilts/sdk/tools/jack-admin start-server

export KBUILD_BUILD_USER= ${BUILD_USER}
export KBUILD_BUILD_HOST= ${BUILD_HOST}
export ${ROM_NICK}_BUILD_TYPE= ${BUILD_TYPE}


# Start tracking the time to see how long it takes the script to run
START=$(date +%s)

# Sync the repo if requested
if [[ "${SYNC}" == "sync" ]]; then
   echoText "SYNCING LATEST SOURCES"; newLine
   repo sync --force-sync -j5
fi


# Setup the build environment
echoText "SETTING UP BUILD ENVIRONMENT"; newLine
. build/envsetup.sh


# Prepare device
newLine; echoText "PREPARING $( echo ${DEVICE} | awk '{print toupper($0)}' )"; newLine
breakfast ${DEVICE}


# Clean up the out folder
echoText "CLEANING UP OUT FOLDER"; newLine
if [[ "${CLEAN}" == "clean" ]]; then
   make clobber
else
   make installclean
fi


# Log the build if requested
if [[ "${LOG}" == "log" ]]; then
   echoText "MAKING LOG DIRECTORY"
   mkdir -p ${LOGDIR}
fi


# Start building the zip file
echoText "MAKING ZIP FILE"; newLine
NOW=$(date +"%m-%d")
if [[ "${LOG}" == "log" ]]; then
   rm ${LOGDIR}/*${DEVICE}*.log
   time mka bacon 2>&1 | tee ${LOGDIR}/du_${DEVICE}-${NOW}.log
else
   time mka bacon
fi
   
echoText "MOVING FILES"; newLine
cd ${DEST_DIR}
rm -rf ${NOW}
mkdir ${NOW}
cp ${OUTDIR}/${ZIPFORMAT} ${DEST_DIR}/${NOW}/${NEW_ZIP}
cp ${OUTDIR}/${MD5FORMAT} ${DEST_DIR}/${NOW}/${NEW_MD5}

# Delete the JACK server located in /home/<USER>/.jack*
rm -rf ~/.jack*

# Restart the JACK server
./prebuilts/sdk/tools/jack-admin kill-server

# Stop tracking time
END=$(date +%s)
echo -e ${RED}
echo -e "-------------------------------------"
echo -e "SCRIPT ENDING AT $(date +%D\ %r)\n"
echo -e "${BUILD_RESULT_STRING}!\n"
echo -e "TIME: $(echo $((${END}-${START})) | awk '{print int($1/60)" MINUTES AND "int($1%60)" SECONDS"}')"
echo -e "-------------------------------------"
echo -e ${RST}; newLine

