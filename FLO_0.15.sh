## WELCOME TO FLO 0.15 INSTALLATION SCRIPT

##  Switch To Home Directory
cd ~


## Installing the Dependencies
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
sudo apt-get install libboost-all-dev

## Installing db4.8 (Only for Ubuntu users)
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install libdb4.8-dev libdb4.8++-dev

## If you want to build FLO-Qt, make sure that the required packages for Qt development are installed. 
sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler

## This is the source 
git clone https://github.com/floblockchain/flo.git
cd flo
./autogen.sh
./configure
make
make install

## Adding the flo.conf file and creating RPC username and password
cd ~
sudo mkdir .flo
config=".flo/flo.conf"
sudo touch $config
echo "server=1" >> $config
echo "daemon=1" >> $config
echo "listen=1" >> $config
echo "txindex=1" >> $config
randUser=input("Enter your RPC username: ")
randPass=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
echo $randPass
echo "rpcuser=$randUser" >> $config
echo "rpcpassword=$randPass" >> $config
echo "addnode=146.185.148.114" >> $config

