#!/bin/bash
#
# Refer to https://docs.openstack.org/keystone/latest/install/keystone-install-ubuntu.html
#

# --------------------- Setup Mysql (mariadb) ------------------

apt-get install -y mariadb-server mycli

# Setup mysql account and db, replace 'test2018' with new password
mysql -u root <<SQL
CREATE DATABASE keystone CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'test2018';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'test2018';
SQL

# --------------------- Setup Keystone -------------------------

apt-get install -y keystone

# configuring keystone service in /etc/keystone/keystone.conf
cp -a ./keystone.conf /etc/keystone/keystone.conf

# Populate the Identity service database
su -s /bin/sh -c "keystone-manage db_sync" keystone

# Initialize Fernet key repositories
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
# keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

# Bootstrap the Identity service, prelace 'adm2018' with new password
keystone-manage bootstrap --bootstrap-password adm2018 \
  --bootstrap-admin-url http://controller:5000/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne

# Edit /etc/apache2/apache2.conf
# ServerName controller

# Restart the Apache service
# service apache2 restart

# --- add hostname 'controller' in /etc/hosts ---
echo "127.0.1.1    controller" >> /etc/hosts

service keystone restart

# Configure the administrative account
cat >> ~/.profile <<ENV

export OS_USERNAME=admin
export OS_PASSWORD=adm2018
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
ENV
