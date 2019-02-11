#!/bin/bash
#
# Refer to https://docs.openstack.org/nova/latest/install/controller-install-ubuntu.html
#

# --------------------- Setup Mysql (mariadb) ------------------

apt-get install -y mariadb-server mycli

# Setup mysql account and db, replace 'test2018' with new password
mysql -u root <<SQL
SQL

# --------------------- Setup Nova -----------------------------
# TODO
