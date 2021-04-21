echo "Enter ROM Name, for example \"potato\""
read ROMNAME
PATH_DIR=$ROMNAME"_olivewood"
cd ..
cd $PATH_DIR
. build/envsetup.sh
export USE_CCACHE=1
export LC_ALL=C
export WITHOUT_CHECK_API=true
#time brunch olivewood
lunch $ROMNAME\_olivewood-userdebug 
mka bacon | tee build_log.txt
