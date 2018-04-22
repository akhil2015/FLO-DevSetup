## FLO wallet export key script
## flo-qt must be running to use this script

target="keys$(date +%F).txt"
sudo rm -r $target
sudo touch $target
flo-cli dumpwallet $target
