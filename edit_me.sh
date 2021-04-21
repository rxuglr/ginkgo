#! /bin/bash
## Build script example variables to set
## Cygnus OS

#ROMGIT="https://github.com/cygnus-rom/manifest.git"
#SOURCEFILE=Android.bp
#ROMNAME=cygnus
#ROMBUILD=cygnus

echo "Enter sync link"
read ROMGIT
SOURCEFILE=Android.bp
echo "Enter ROM Name"
read ROMNAME
echo "Enter ROM Build"
read ROMBUILD

VENDOR_CONFIG=$ROMNAME
PATH_DIR=$ROMNAME"_olivewood"

cd .. 
#Make work directory if not present
if [[ ! -d "$PATH_DIR" ]] 
then
mkdir $PATH_DIR
fi
## Check if sources are present and download if not present
if [[ ! -f $SOURCEFILE ]] 
then 
cp olivewood/roomservice.xml $PATH_DIR/roomservice.xml
cd $PATH_DIR
repo init -u $ROMGIT 
mkdir .repo/local_manifests
mv roomservice.xml .repo/local_manifests/local_manifest.xml
repo sync -j$(nproc --all) --force-sync
#recheck
repo sync -j$(nproc --all) --force-sync
cp hardware/qcom-caf/msm8996/Android.* hardware/qcom-caf/msm8937/
cd ..
cat olivewood/device_mk_changes-msm8937.txt >> $PATH_DIR/device/xiaomi/olivewood/device.mk
cd $PATH_DIR
echo "TARGET_KERNEL_CLANG_COMPILE=true" >> device/xiaomi/olivewood/BoardConfig.mk

## match device tree files to rom tree
mv device/xiaomi/olivewood/lineage_olivewood.mk device/xiaomi/olivewood/$ROMNAME\_olivewood.mk
sed -i "s|vendor/lineage/config|vendor/$VENDOR_CONFIG/config|" device/xiaomi/olivewood/$ROMNAME\_olivewood.mk
sed -i "s|lineage|$ROMNAME|" device/xiaomi/olivewood/$ROMNAME\_olivewood.mk
sed -i "s|lineage|$ROMNAME|" device/xiaomi/olivewood/AndroidProducts.mk
echo "WITH_GAPPS := true" >> device/xiaomi/olivewood/$ROMNAME\_olivewood.mk

## Build section sequence A
. build/envsetup.sh
export USE_CCACHE=1
export LC_ALL=C
export WITHOUT_CHECK_API=true
#time brunch olivewood
brunch $ROMNAME/_olivewood-userdebug -j$(nproc --ignore=8)

## Build section sequence B
else

. build/envsetup.sh
export USE_CCACHE=1
export LC_ALL=C
export WITH_CHECK_API=true
#time brunch olivewood
brunch $ROMNAME/_olivewood-userdebug -j$(nproc --ignore=8)
fi
