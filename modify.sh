printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
printf "

   ___    _   _   _      __   __                
  / _ \  | \ | | | |     \ \ / /                
 | | | | |  \| | | |      \ V /                 
 | |_| | | |\  | | |___    | |                  
  \___/  |_| \_| |_____|   |_|                  
                                                
  _____    ___    ____                          
 |  ___|  / _ \  |  _ \                         
 | |_    | | | | | |_) |                        
 |  _|   | |_| | |  _ <                         
 |_|      \___/  |_| \_\                        
                                                
   ___    _       ___  __     __  _____         
  / _ \  | |     |_ _| \ \   / / | ____|        
 | | | | | |      | |   \ \ / /  |  _|    _____ 
 | |_| | | |___   | |    \ V /   | |___  |_____|
  \___/  |_____| |___|    \_/    |_____|        
                                                
         __        __   ___     ___    ____     
         \ \      / /  / _ \   / _ \  |  _ \    
  _____   \ \ /\ / /  | | | | | | | | | | | |   
 |_____|   \ V  V /   | |_| | | |_| | | |_| |   
            \_/\_/     \___/   \___/  |____/    
                                                
by Telegram @dsashwin, many thanks to @Iprouteth0 for the scripts
\n\n\n\n"

echo "Enter sync link, for example \"https://github.com/PotatoProject/manifest -b dumaloo-release\""
read ROMGIT
SOURCEFILE=Android.bp
echo "Enter ROM Name used for build, for example \"potato\""
read ROMNAME
echo "Enter ROMs Vendor Directory Name, for example \"potato\""
read ROMBUILD
echo "Enter ROM build command (including device codename) copy paste from github of the ROM, for example \"mka bacon\""
read MAKECOM

VENDOR_CONFIG=$ROMBUILD
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
$MAKECOM -j$(nproc --all) | tee build_log.txt
