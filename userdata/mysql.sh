#!/bin/bash
DATABASE_PASS='admin123'
sudo yum update -y
sudo yum install git zip unzip mariadb105-server iptables-services -y

# Starting & enabling mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Cloning the project repository
cd /tmp/
git clone -b main https://github.com/hkhcoder/vprofile-project.git

# Setting up MariaDB
sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DATABASE_PASS'"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.global_priv WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.global_priv WHERE User=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Restarting mariadb-server
sudo systemctl restart mariadb

# Setting up iptables firewall
# sudo bash -c 'cat > /etc/sysconfig/iptables <<EOF
# *filter
# :INPUT DROP [0:0]
# :FORWARD DROP [0:0]
# :OUTPUT ACCEPT [0:0]
# -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# -A INPUT -i lo -j ACCEPT
# -A INPUT -p tcp -m state --state NEW -m tcp --dport 3306 -j ACCEPT
# COMMIT
# EOF'
# sudo systemctl enable iptables
# sudo systemctl start iptables
