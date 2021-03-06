#!/bin/bash
# run the script Under root user "
#$ sudo su
#$ sudo apt-get update
#$ sudo apt-get upgrade -y
#$ sudo apt -y install vim bash-completion wget
#$ apt install -y zip
#Create user frist
#$ sudo adduser odoo
#$ sudo reboot
#$ wget https://raw.githubusercontent.com/FalconValley/OdooScripts/13/Install_Odoo.sh
#$ chmod +x Install_Odoo.sh
#$ ./Install_Odoo.sh

##fixed parameters

OE_USER="odoo"
OE_BRANCH="14.0"
OE_Folder="odoo14"
InstallPostgrees="True"
Installlocalization="True"
InstallDependencies="True"
InstallNGINX="True"
Installwebmin="True"
odoodirectory="True"
Dwonloadodoo="True"
DwonloadodooService="True"
INSTALL_WKHTMLTOPDF="True"
IS_ENTERPRISE="false"

###  WKHTMLTOPDF download links
## === Ubuntu Trusty x64 & x32 === (for other distributions please replace these two links,
## in order to have correct version of wkhtmltox installed, for a danger note refer to 
## https://www.odoo.com/documentation/8.0/setup/install.html#deb ):
WKHTMLTOX_X64=https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb
WKHTMLTOX_X32=https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_i386.deb
#--------------------------------------------------
if [ $Installlocalization = "True" ]; then
echo "----------------------------localization-------------------------------"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
sudo dpkg-reconfigure locales
fi
if [ $InstallPostgrees = "True" ]; then
#--------------------------------------------------
# Install PostgreSQL Server
#--------------------------------------------------
wget https://raw.githubusercontent.com/FalconValley/OdooScripts/13/pgdg.list
wget https://raw.githubusercontent.com/FalconValley/OdooScripts/13/webmin.list
cp pgdg.list /etc/apt/sources.list.d
cp webmin.list /etc/apt/sources.list.d
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
echo -e "\n---- Install PostgreSQL Server ----"
sudo apt-get install postgresql-13 postgresql-server-dev-13 -y
fi

echo -e "\n---- Creating the ODOO PostgreSQL User  ----"
sudo su - postgres -c "createuser -s $OE_USER" 2> /dev/null || true

if [ $InstallDependencies = "True" ]; then
#--------------------------------------------------
# Install Dependencies
#--------------------------------------------------
echo -e "\n---- Install tool packages ----"
sudo apt-get install wget nano subversion git bzr bzrtools python-pip python3-pip gdebi-core -y pysassc	
echo -e "\n---- Install python packages ----"
sudo apt-get install python-dateutil python-feedparser python-ldap python-libxslt1 python-lxml python-mako python-openid python-psycopg2 python-pybabel python-pychart python-pydot python-pyparsing python-reportlab python-simplejson python-tz python-vatnumber python-vobject python-webdav python-werkzeug python-xlwt python-yaml python-zsi python-docutils python-psutil python-mock python-unittest2 python-jinja2 python-pypdf python-decorator python-requests python-passlib python-pil python-gpgme python-launchpadlib build-essential python-all-dev python-setuptools python-imaging python-suds python-xlsxwriter python-wheel -y	
echo -e "\n---- Install python libraries ----"
sudo pip install gdata psycogreen
# This is for compatibility with Ubuntu 16.04. Will work on 14.04, 15.04 and 16.04
sudo -H pip install suds
echo -e "\n--- Install other required packages"
sudo apt-get install node-clean-css -y
sudo apt-get install node-less -y
sudo apt-get install python-gevent -y
apt-get install libwww-perl -y
#sudo apt install ifupdown -y
fi
if [ $INSTALL_WKHTMLTOPDF = "True" ]; then
  echo -e "\n---- Install wkhtml and place shortcuts on correct place for ODOO 9 ----"
  #pick up correct one from x64 & x32 versions:
  if [ "`getconf LONG_BIT`" == "64" ];then
      _url=$WKHTMLTOX_X64
  else
      _url=$WKHTMLTOX_X32
  fi
  sudo wget $_url
  sudo gdebi --n `basename $_url`
  sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin
  sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin
else
  echo "Wkhtmltopdf isn't installed due to the choice of the user!"
fi
if [ $IS_ENTERPRISE = "True" ]; then
    # Odoo Enterprise install!
    echo -e "\n---- Installing Enterprise specific libraries ----"
    sudo apt-get install nodejs npm -y
    sudo npm install -g less
    sudo npm install -g less-plugin-clean-css
    sudo npm install -g rtlcss
else 
    echo -e "\n---- every thing is ready ----"
    
fi	

if [ $InstallDependencies = "True" ]; then
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo apt-get install -y libsasl2-dev python-dev libldap2-dev libssl-dev python3-dev
sudo easy_install greenlet
sudo easy_install gevent
sudo apt-get install -y libxml2-dev libxslt1-dev zlib1g-dev python3-pip python3-wheel python3-setuptools
sudo -H pip install -r https://raw.githubusercontent.com/odoo/odoo/10.0/requirements.txt
sudo apt install -y python3-asn1crypto 
sudo apt install -y python3-babel python3-bs4 python3-cffi-backend python3-cryptography python3-dateutil python3-docutils python3-feedparser python3-funcsigs python3-gevent python3-greenlet python3-html2text python3-html5lib python3-jinja2 python3-lxml python3-mako python3-markupsafe python3-mock python3-ofxparse python3-openssl python3-passlib python3-pbr python3-pil python3-psutil python3-psycopg2 python3-pydot python3-pygments python3-pyparsing python3-pypdf2 python3-renderpm python3-reportlab python3-reportlab-accel python3-roman python3-serial python3-stdnum python3-suds python3-tz python3-usb python3-vatnumber python3-werkzeug python3-xlsxwriter python3-yaml
sudo -H pip3 install -r https://raw.githubusercontent.com/odoo/odoo/13.0/requirements.txt
sudo -H pip3 install -r https://raw.githubusercontent.com/odoo/odoo/14.0/requirements.txt
sudo -H pip3 install -r https://raw.githubusercontent.com/it-projects-llc/odoo-saas-tools/12.0/requirements.txt
sudo -H pip3 install phonenumbers
fi

if [ $odoodirectory = "True" ]; then
echo "---------------------------odoo directory--------------------------------"
mkdir /$OE_Folder
mkdir /etc/$OE_Folder
mkdir /var/log/$OE_Folder
#touch /etc/$OE_Folder/$OE_Folder.conf
wget https://raw.githubusercontent.com/FalconValley/OdooScripts/13/$OE_Folder.conf
cp $OE_Folder.conf /etc/$OE_Folder
touch /var/log/$OE_Folder/$OE_Folder-server.log
chown $OE_USER:$OE_USER /var/log/$OE_Folder/$OE_Folder-server.log
chown $OE_USER:$OE_USER /etc/$OE_Folder/$OE_Folder.conf
chown -R $OE_USER:$OE_USER /$OE_Folder
fi

if [ $Dwonloadodoo = "True" ]; then

echo "---------------------------Dwonload odoo --------------------------------"
su $OE_USER 
cd /$OE_Folder

sudo git clone --depth 1 --branch $OE_BRANCH https://www.github.com/odoo/odoo .

mkdir extra

cd /



fi

if [ $DwonloadodooService = "True" ]; then
cd /root
echo "-------------------------------odoo service----------------------------"
wget https://raw.githubusercontent.com/FalconValley/OdooScripts/13/$OE_Folder.service
cp $OE_Folder.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable $OE_Folder
sudo systemctl start $OE_Folder
fi

if [ $InstallNGINX = "True" ]; then
echo "----------------------------NGINX-------------------------------"
wget https://raw.githubusercontent.com/FalconValley/OdooScripts/14/nginx.sh
bash nginx.sh
fi
if [ $Installwebmin = "True" ]; then
echo "---------------------------webmin--------------------------------"
apt-get install -y perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python
wget https://download.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
apt-get install apt-transport-https -y
apt-get update
apt-get install webmin -y
fi

echo " -------------------Test odoo ------------------------"
sudo systemctl status $OE_Folder
echo " Open Log"
tail -f /var/log/$OE_Folder/$OE_Folder-server.log

echo " -------------------test ngnix -----------" 
$ nginx -t

echo "Done! The Odoo production platform is ready:"

echo "Restart restart ur computer and start developing and have fun ;)"
echo "-----------------------------------------------------------"
