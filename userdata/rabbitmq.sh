#!/bin/bash

# Update package lists this was done on an Ubuntu 22.04 LTS server
sudo apt update -y

# Install necessary dependencies
sudo apt install -y curl gnupg apt-transport-https

# Add RabbitMQ signing key
curl -fsSL https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/rabbitmq-archive-keyring.gpg

# Add Erlang signing key
curl -fsSL https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/rabbitmq-erlang-archive-keyring.gpg

# Add RabbitMQ repository
echo "deb [signed-by=/usr/share/keyrings/rabbitmq-archive-keyring.gpg] https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/deb/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list

# Add Erlang repository
echo "deb [signed-by=/usr/share/keyrings/rabbitmq-erlang-archive-keyring.gpg] https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/deb/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/erlang.list

# Update package lists again
sudo apt update -y

# Install Erlang and RabbitMQ
sudo apt install -y erlang-base erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key erlang-runtime-tools erlang-snmp erlang-ssl erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl rabbitmq-server

# Start and enable RabbitMQ service
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server

# Enable RabbitMQ management plugin
sudo rabbitmq-plugins enable rabbitmq_management

# Create RabbitMQ user with administrator privileges
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator

# Restart RabbitMQ service to apply changes
sudo systemctl restart rabbitmq-server
