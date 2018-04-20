## WELOCOME TO ElectrumX server INSTALLATION SCRIPT
## Ubuntu 17.10 or above required else you need to install python 3.6 
## FLO node must be running to use this script

##Install LevelDB

sudo apt-get install python3-leveldb libleveldb-dev


## INSTALLATION SCRIPT for python3.6

## Set Python 3.6 as default python 3
##Check the default python3 version using the command
# python3 --version

##If the version in 3.6 then skip to next step, else set python 3.6 as default python 3 as follows :
##Run the command :

# sudo update-alternatives --config python3

##If it shows you this error:
##update-alternatives: error: no alternatives for python3 
##You need to update your update-alternatives , then you will be able to set your default python version.
# sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1
# sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 2

##Then run :

# sudo update-alternatives --config python3 

## Set python3.6 as default for python3.
## Check the default python3 version using the command
# python3 --version



## Install required Python packages
## You will also need to install some Python 3.6 dependencies for ElectrumX.
##Let's first upgrade setuptools:

sudo pip3 install --upgrade pip setuptools wheel

##then install some required packages:

sudo pip3 install aiohttp pylru leveldb plyvel

## Install and set up ElectrumX
## Clone the ElectrumX code from a GitHub repository using git:

git clone https://github.com/bitspill/flo-electrumx.git
cd flo-electrumx


sudo python3 setup.py install

## Next, create a data folder where the blockchain data will be stored:
mkdir ~/.electrumx

## Create a self-signed certificate
## To allow Electrum wallets to connect to your server over SSL you need to create a self-signed certificate.

## Go to the data folder:

cd ~/.electrumx 

## and generate your key:

openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
openssl rsa -passin pass:x -in server.pass.key -out server.key
rm server.pass.key
openssl req -new -key server.key -out server.csr

## Follow the on-screen information. It will ask for certificate details such as your country and password. You can leave those fields empty.
## When done, create a certificate:

openssl x509 -req -days 1825 -in server.csr -signkey server.key -out server.crt

##These commands will create 2 files: server.key and server.crt.
##When configuring the ElectrumX instance, make sure to add server.key to SSL_KEYFILE and server.crt to SSL_CERTFILE. More on this in the next step.

## Launch ElectrumX as service

sudo -s
cp ~/flo-electrumx/contrib/systemd/electrumx.service /lib/systemd/system/

##Edit the file to match your setup:

vim /lib/systemd/system/electrumx.service

##Press i and start editing.
##You need to edit at least ExecStart and User variables.

## ExecStart=/home/<username>/flo-electrumx/electrumx_server.py
## User=<username>

## When you're happy with the changes, hit ESC and type :wqa followed by ENTER.
## Create a configuration file for the server:

config="/etc/electrumx.conf"
sudo touch $config
echo "Enter your linux username: ")
read system_user
echo "Enter RPC username (mentioned in flo.conf) : ")
read RPC_USER
echo "Enter RPC password (mentioned in flo.conf) : ")
read RPC_PASS

echo "COIN = Flo" >> $config
echo "DAEMON_URL = http://<rpcuserName>:<rpcPassword>@localhost:7313/" >> $config
echo "DB_DIRECTORY = /home/<username>/.electrumx/" >> $config
echo "DB_ENGINE = leveldb" >> $config
echo "USERNAME = <username>" >> $config
echo "ELECTRUMX = /home/<username>/flo-electrumx/electrumx_server.py" >> $config
echo "HOST = 0.0.0.0" >> $config
echo "ANON_LOGS = xx.xx.xx.xx:xxx" >> $config
echo "CACHE_MB = 1800" >> $config
echo "MAX_SESSIONS = 500" >> $config
echo "SSL_CERTFILE = /home/<username>/.electrumx/server.crt" >> $config
echo "SSL_KEYFILE = /home/<username>/.electrumx/server.key" >> $config
echo "SSL_PORT = 50002" >> $config
echo "TCP_PORT = 50001" >> $config


## Comment out this if you don't want to start electrumx at the end of this SCRIPT
systemctl start electrumx

## Comment out this if you don't want to start viewing logs for electrumX
journalctl -u electrumx -f