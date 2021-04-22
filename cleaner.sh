echo "Enter ROM Name used for build, for example \"potato\""
read ROMNAME
cd $ROMNAME"_olivewood"
make clean
cd .. 
cd olivewood
