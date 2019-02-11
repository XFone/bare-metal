#!/bin/bash
#
# Refer to https://www.rabbitmq.com/install-debian.html
#

# Setup RabitMQ
apt-key adv --keyserver "hkps.pool.sks-keyservers.net" --recv-keys "0x6B73A36E6026DFCA"

cat > /etc/apt/sources.list.d/bintray.rabbitmq.list <<EOF
deb https://dl.bintray.com/rabbitmq-erlang/debian xenial erlang
deb https://dl.bintray.com/rabbitmq/debian xenial main
EOF

apt-get update
apt-get install -y erlang-nox rabbitmq-server

# Run RabbitMQ Server
ulimit -S -n 4096
sudo service rabbitmq-server start

# Add user and set permissions 
rabbitmqctl add_user ironic test2018
rabbitmqctl list_users

rabbitmqctl set_permissions -p / ironic ".*" ".*" ".*"
