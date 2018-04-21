## WELOCOME TO Electrum Client INSTALLATION SCRIPT
## Ubuntu 17.10 or above required else you need to install python 3.6 


## If you want to use the Qt interface, install the Qt dependencies
sudo apt-get install python3-pyqt5

## Install the setuptools
sudo apt-get install python3-setuptools

##  Cloning Flo-electrum and installing
git clone https://github.com/bitspill/flo-electrum.git
cd flo-electrum
python3 setup.py install

## Compile the icons file for Qt
sudo apt-get install pyqt5-dev-tools
pyrcc5 icons.qrc -o gui/qt/icons_rc.py

##  Compile the protobuf description file
sudo apt-get install protobuf-compiler
protoc --proto_path=lib/ --python_out=lib/ lib/paymentrequest.proto

## Create translations (optional)
# sudo apt-get install python-requests gettext
# ./contrib/make_locale

echo "INSTALLATION COMPLETE"
echo "Start electrumX server and then run the electrum client."