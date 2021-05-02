echo "Enter ROM Name used for build, for example \"potato\""
read ROMNAME
cd $ROMNAME"_ginkgo"
make clean
cd .. 
cd ginkgo
