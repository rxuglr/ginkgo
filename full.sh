#! /bin/bash
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
                                                
by Telegram @dsashwin, many thanks to @Iprouteth0 for the scripts and to @Aghora7 for all his trees
If does not work please contact us at the group link given on the github readme.md 
\n\n\n\n\n\n\n"

#Get values
echo "Enter sync link, for example \"https://github.com/PotatoProject/manifest -b dumaloo-release\""
read ROMGIT
SOURCEFILE=Android.bp
echo "Enter ROM Name used for build, for example \"potato\""
read ROMNAME
echo "Enter ROMs Vendor Directory Name, for example \"potato\" in most cases it should be same as what was used for build, but some roms like Nusantara uses Nusantara as name for vendor folder and nad for building"
read VENDOR_CONFIG
echo "Enter ROM build command (including device codename) copy paste from github of the ROM, for example \"mka bacon\""
echo "However, lunch $ROMNAME\_olivewood-userdebug will be run."
read MAKECOM

PATH_DIR=$ROMNAME"_olivewood"

cd .. 
#Make work directory if not present
if [[ ! -d "$PATH_DIR/.repo" ]] 
then
mkdir $PATH_DIR
cd $PATH_DIR
repo init -u $ROMGIT 
repo sync -j$(nproc --all) --force-sync -f
cp olivewood/roomservice.xml $PATH_DIR/roomservice.xml 
else 
cp olivewood/roomservice.xml $PATH_DIR/roomservice.xml
cd $PATH_DIR
fi
mkdir .repo/local_manifests
rm .repo/local_manifests/local_manifest.xml
mv roomservice.xml .repo/local_manifests/local_manifest.xml
repo sync -j$(nproc --all) --force-sync -f
#recheck
repo sync -j$(nproc --all) --force-sync -f
## match device tree files to rom tree
mv device/xiaomi/sdm439-common/lineage.dependencies device/xiaomi/sdm439-common/$ROMNAME.dependencies 
echo "TARGET_KERNEL_CLANG_COMPILE=true" >> device/xiaomi/olivewood/BoardConfig.mk
mv device/xiaomi/olivewood/lineage_olivewood.mk device/xiaomi/olivewood/$ROMNAME\_olivewood.mk
sed -i "s|vendor/lineage/config|vendor/$VENDOR_CONFIG/config|" device/xiaomi/olivewood/$ROMNAME\_olivewood.mk
sed -i "s|lineage|$ROMNAME|" device/xiaomi/olivewood/$ROMNAME\_olivewood.mk
sed -i "s|lineage|$ROMNAME|" device/xiaomi/olivewood/AndroidProducts.mk
echo "WITH_GAPPS := true" >> device/xiaomi/olivewood/$ROMNAME\_olivewood.mk

## Build section
. build/envsetup.sh
export USE_CCACHE=1
export LC_ALL=C
export WITHOUT_CHECK_API=true

#Brunch olivewood
lunch $ROMNAME\_olivewood-userdebug 
$MAKECOM | tee build_log.txt
cd .. 
cd olivewood
echo "Type . run.sh to build another rom!"
printf "\n"
echo "Type . buildonly.sh to only build again, incase of buid errors!"
printf "\n"
echo "Type . only_modify_and_build.sh to repo sync, modify and build again, incase of sync error!"
printf "\n"
echo "type . updater.sh to update the ROM build files and run again"
echo "Refer github.com/geek0609/olivewood for Telegram group link to report issues"
