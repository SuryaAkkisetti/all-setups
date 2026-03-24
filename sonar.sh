#!/bin/bash

# Update system
yum update -y

# Install required packages
yum install -y wget unzip java-17-amazon-corretto

# Move to /opt
cd /opt

# Download SonarQube (LTS version recommended)
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.6.50800.zip

# Unzip package
unzip sonarqube-8.9.6.50800.zip

# Rename for simplicity
mv sonarqube-8.9.6.50800 sonarqube

# Create sonar user
useradd sonar

# Set permissions
chown -R sonar:sonar /opt/sonarqube
chmod -R 755 /opt/sonarqube

# Configure system limits (required for SonarQube)
echo "sonar   -   nofile   65536" >> /etc/security/limits.conf
echo "sonar   -   nproc    4096" >> /etc/security/limits.conf

# Kernel settings
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
echo "fs.file-max=65536" >> /etc/sysctl.conf

# Apply sysctl changes
sysctl -p

# Start SonarQube as sonar user
sudo -u sonar /opt/sonarqube/bin/linux-x86-64/sonar.sh start

# Enable SonarQube on boot (optional)
ln -s /opt/sonarqube/bin/linux-x86-64/sonar.sh /etc/init.d/sonar
chkconfig --add sonar
chkconfig sonar on

echo "======================================="
echo "SonarQube installation completed"
echo "Access URL: http://<YOUR_SERVER_IP>:9000"
echo "Default Username: admin"
echo "Default Password: admin"
echo "======================================="
