#!/bin/bash
#
# Refer to https://docs.openstack.org/ironic/latest/install/install-ubuntu.html
#      and https://blog.csdn.net/wanghuiict/article/details/52757359
#      and https://ironic-book.readthedocs.io/zh_CN/latest/index.html
#

# Required packages
# apt-get install -y sqlite3 libsqlite3-dev libssl-dev libldap2-dev

# --------------------- Setup Keystone -------------------------
# ./setup_keystone.sh

# ----------------- Setup Horizon (dashboard) ------------------
# ./setup_horizon.sh


# --------------------- Setup Mysql (mariadb) ------------------

apt-get install -y mariadb-server mycli

# Setup mysql account and db, replace 'test2018' with new password
mysql -u root <<SQL
CREATE DATABASE ironic CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON ironic.* TO 'ironic'@'localhost' IDENTIFIED BY 'test2018';
GRANT ALL PRIVILEGES ON ironic.* TO 'ironic'@'%' IDENTIFIED BY 'test2018';
SQL

# --------------------- Setup Ironic ---------------------------

# reading environments (keystone)
source ~/.profile

OS_VERSION="stable/pike"
apt-get install -y ipmitool tftpd-hpa apache2 libapache2-mod-wsgi python-pip

git clone https://git.openstack.org/openstack/ironic -b $OS_VERSION --depth=1
cd ironic

pip install -U pip
pip install --ignore-installed PyYAML -r requirements.txt -e .
python setup.py build
python setup.py install
cd  ..

# Configuring ironic-api service
mkdir -p /etc/ironic/
cp -a ./ironic.conf /etc/ironic/ironic.conf

# Create the Bare Metal service database tables
ironic-dbsync --config-file /etc/ironic/ironic.conf create_schema

# Restart the ironic-api service
sudo service ironic-api restart

# Restart the ironic-conductor service
sudo service ironic-conductor restart

# Create openstack ironic service。
openstack service create --name ironic --description "Ironic Bare Metal Provisioning Service" baremetal

# ------------- Enable wsgi ------------------

# Configuring ironic-api behind mod_wsgi
# cp -a ./ironic-wsgi.conf /etc/apache2/sites-available/ironic.conf
# a2ensite ironic
service apache2 reload

# --------------------- Setup Ironic UI -----------------------

# TODO (check python3 version)
# --------------------- Setup tftp Service -----------------------

# Prepare images' path
mkdir -p /tftpboot/ironic
chown -R ironic:ironic /tftpboot
chmod 664 /tftpboot/ironic

# Setting tftpd (/etc/default/tftpd-hpa)
service tftpd-hpa restart
