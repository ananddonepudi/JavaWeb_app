# Java Web Application

Simple Java WebApp with Maven build, CodeBuild buildspec.yaml, Dockerfile, and a basic servlet.

#!/bin/bash

# Update system packages
sudo yum update -y

# Install Java (Amazon Corretto 17)
sudo yum install -y java-17-amazon-corretto

# Install Tomcat 9
sudo groupadd tomcat
sudo useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

sudo mkdir /opt/tomcat
cd /opt/tomcat

curl -s https://downloads.apache.org/tomcat/tomcat-9/ | grep v9
#use the latest version 
sudo wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.105/bin/apache-tomcat-9.0.105.tar.gz
sudo tar xvf apache-tomcat-9.0.105.tar.gz --strip-components=1
sudo rm apache-tomcat-9.0.105.tar.gz

# Set permissions
sudo chown -R tomcat:tomcat /opt/tomcat

# Create a systemd service for Tomcat
sudo bash -c 'cat > /etc/systemd/system/tomcat.service << EOF
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd and start Tomcat
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

# Install AWS CodeDeploy Agent
sudo yum install -y ruby wget
cd /home/ec2-user
wget https://aws-codedeploy-ap-south-1.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo systemctl start codedeploy-agent
sudo systemctl enable codedeploy-agent

# Confirm services
sudo systemctl status tomcat
sudo systemctl status codedeploy-agent
