#!/bin/bash
#
# Refer to https://docs.openstack.org/horizon/latest/install/from-source.html
#
# Default settings (in keystone):
# <domain>:   default
# <user>:     admin
# <password>: adm2018

# ----------------- Setup Horizon (dashboard) ------------------
OS_VERSION="stable/pike"

apt-get install -y apache2 libapache2-mod-wsgi

git clone https://git.openstack.org/openstack/horizon -b $OS_VERSION --depth=1
cd horizon

# pip install openstacksdk
pip install --ignore-installed PyYAML -U python-openstackclient
pip install -r requirements.txt -e .
pip install -c https://git.openstack.org/cgit/openstack/requirements/plain/upper-constraints.txt?h=$OS_VERSION .
python setup.py build
python setup.py install

# ------------- Enable wsgi ------------------

# --- edit /etc/apache2/sites-available/openstack_dashboard.conf --
# cp -a ./openstack_dashboard-wsgi.conf /etc/apache2/sites-available/openstack_dashboard.conf
# a2ensite ironic

service apache2 restart
