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
                                                
██████  ███████ ██████  ███    ███ ██                    
██   ██ ██      ██   ██  ████  ████ ██                    
██████  █████   ██   ██ ██ ████ ██ ██                    
██   ██ ██      ██   ██  ██  ██  ██ ██                    
██   ██ ███████ ██████  ██      ██ ██                    
                                                         
                                                         
███    ██  ██████  ████████ ███████     █████           
████   ██ ██    ██    ██    ██           ██   ██          
██ ██  ██ ██    ██    ██    █████        █████           
██  ██ ██ ██    ██    ██    ██           ██   ██          
██   ████  ██████     ██    ███████     █████           
                                                         
                                                        
███    ██  ██████  ████████ ███████     █████  ████████ 
████   ██ ██    ██    ██    ██           ██   ██    ██    
██ ██  ██ ██    ██    ██    █████        █████     ██    
██  ██ ██ ██    ██    ██    ██           ██   ██    ██    
██   ████  ██████     ██    ███████     █████      ██    
                                                         
                                                           
                                                
by Telegram @dsashwin and @rxuglr, many thanks to @Iprouteth0 for the script idea and for @mg712702 for all his trees
If does not work please PM me plox
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
echo "However, lunch" $ROMNAME"_ginkgo-userdebug will be run."
read MAKECOM

PATH_DIR=$ROMNAME"_ginkgo"

cd .. 
#Make work directory if not present
if [[ ! -d "$PATH_DIR/.repo" ]] 
then
mkdir $PATH_DIR
cd $PATH_DIR
repo init --depth=1 -v -u $ROMGIT  
repo sync -v -f -j$(nproc --all) --force-sync -c --no-clone-bundle --no-tags --optimized-fetch
cd ..
cp ginkgo/roomservice.xml $PATH_DIR/roomservice.xml 
cd $PATH_DIR
else 
cp ginkgo/roomservice.xml $PATH_DIR/roomservice.xml
cd $PATH_DIR
fi
mkdir .repo/local_manifests
rm .repo/local_manifests/local_manifest.xml
mv roomservice.xml .repo/local_manifests/local_manifest.xml
repo sync -j$(nproc --all) --force-sync -f -v
#recheck
repo sync -j$(nproc --all) --force-sync -f -v
## match device tree files to rom tree
mv device/xiaomi/ginkgo/lineage.dependencies device/xiaomi/ginkgo/$ROMNAME.dependencies 
mv device/xiaomi/ginkgo/lineage_olivewood.mk device/xiaomi/ginkgo/$ROMNAME\_ginkgo.mk
sed -i "s|vendor/lineage/config|vendor/$VENDOR_CONFIG/config|" device/xiaomi/ginkgo/$ROMNAME\_ginkgo.mk
sed -i "s|lineage|$ROMNAME|" device/xiaomi/ginkgo/$ROMNAME\_olivewood.mk
sed -i "s|lineage|$ROMNAME|" device/xiaomi/ginkgo/AndroidProducts.mk
echo "WITH_GAPPS := true" >> device/xiaomi/ginkgo/$ROMNAME\_olivewood.mk

if [[ -d "vendor/$VENDOR_CONFIG/config" ]]
then
if [[ ! -f "vendor/$VENDOR_CONFIG/config/common_full_phone.mk" ]]
then
    mv vendor/$VENDOR_CONFIG/config/common.mk vendor/$VENDOR_CONFIG/config/common_full_phone.mk
fi
fi

if [[ -d "vendor/$VENDOR_CONFIG/configs" ]]
then
if [[ ! -f "vendor/$VENDOR_CONFIG/configs/common_full_phone.mk" ]]
then
    mv vendor/$VENDOR_CONFIG/configs/common.mk vendor/$VENDOR_CONFIG/configs/common_full_phone.mk
fi
fi

## Build section
. build/envsetup.sh
export USE_CCACHE=1

#Brunch ginkgo
lunch $ROMNAME\_ginkgo-userdebug | tee lunch_log.txt
$MAKECOM | tee build_log.txt
cd .. 
cd olivewood
echo "Type . run.sh to build another rom!"
printf "\n"
echo "Type . cleaner.sh to clean files!"
printf "\n"
echo "Type . buildonly.sh to only build again, incase of buid errors!"
printf "\n"
echo "Type . only_modify_and_build.sh to repo sync, modify and build again, incase of sync error!"
printf "\n"
echo "type . updater.sh to update the ROM build files and run again"
echo "Refer github.com/geek0609/olivewood for Telegram group link to report issues"
