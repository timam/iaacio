#!/usr/bin/env bash
sudo setenforce 0
sudo yum install -y epel-release wget
sudo yum update  -y
sudo yum install -y java-1.8.0-openjdk
sudo yum install -y java-1.8.0-openjdk-devel
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install -y jenkins
sudo systemctl start jenkins.service
sudo systemctl enable jenkins.service


sudo cat /var/lib/jenkins/secrets/initialAdminPassword
