echo "Enter ROM Name"
read ROMNAME
echo "Enter ROM Build"
read ROMBUILD

VENDOR_CONFIG=$ROMNAME
PATH_DIR=$ROMNAME"_olivewood"
cd .. 
cd $PATH_DIR
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
lunch $ROMNAME\_olivewood-userdebug 
mka bacon | tee build_log.txt
