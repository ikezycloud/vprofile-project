#!/bin/bash

# Update package lists
sudo apt update -y

# Install Java (required for Tomcat)
sudo apt install -y openjdk-11-jdk

# Install AWS CLI
sudo snap install aws-cli --classic

# Create a dedicated user for Tomcat (without login shell)
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat

# Download Tomcat 9.0.97
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.97/bin/apache-tomcat-9.0.97.tar.gz -P /tmp

# Create the installation directory
sudo mkdir /opt/tomcat

# Extract the downloaded archive to the installation directory
sudo tar xf /tmp/apache-tomcat-9.0.97.tar.gz -C /opt/tomcat --strip-components=1

# Set appropriate ownership and permissions for the Tomcat directory
sudo chown -R tomcat:tomcat /opt/tomcat
sudo chmod -R 755 /opt/tomcat

# Create a systemd service file for Tomcat
sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOF
[Unit]
Description=Apache Tomcat 9 Web Application Server
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload the systemd daemon to apply the new service file
sudo systemctl daemon-reload

# Enable and start the Tomcat service
sudo systemctl enable tomcat
sudo systemctl start tomcat

# Confirm that Tomcat is running
sudo systemctl status tomcat