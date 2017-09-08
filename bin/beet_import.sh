#!/bin/bash
log=$HOME/Music/beets/auto.log
echo "" >> $log
echo "------------ beet-auto-import.sh ---------------" >> $log
beet import -iql $HOME/Music/beets/beets.log $HOME/Music/soulseek/complete/ >> $log 2>&1
mpc update >> $log 2>&1
echo "Finished: $(date)" >> $log
echo "-------------------------------------------------------" >> $log  
