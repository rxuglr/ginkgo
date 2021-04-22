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
