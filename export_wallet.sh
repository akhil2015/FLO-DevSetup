## FLO wallet export key script
## flo-qt must be running to use this script
## Don't use sudo to run this script

target="latest_keys.txt"
touch $target
flo-cli dumpwallet $target
