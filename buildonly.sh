echo "Enter ROM Name, for example \"potato\""
read ROMNAME
echo "Enter ROM build command (including device codename) copy paste from github of the ROM, for example \"mka bacon\""
read MAKECOM

PATH_DIR=$ROMNAME"_olivewood"
cd ..
cd $PATH_DIR
. build/envsetup.sh
export USE_CCACHE=1
export LC_ALL=C
export WITHOUT_CHECK_API=true
#time brunch olivewood
lunch $ROMNAME\_olivewood-userdebug 
$MAKECOM -j$(nproc --all) | tee build_log.txt
