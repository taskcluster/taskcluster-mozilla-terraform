#!/bin/bash

set -ex

apt-get update
apt install -y wget

curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
bash install-logging-agent.sh
rm install-logging-agent.sh

mkdir /opt/taskcluster
cd /opt/taskcluster

mv /tmp/generic-worker-nativeEngine-linux-amd64 .
chmod +x ./generic-worker-nativeEngine-linux-amd64
wget https://github.com/taskcluster/livelog/releases/download/v1.1.0/livelog-linux-amd64
chmod +x ./livelog-linux-amd64

adduser --system --group taskcluster

mv /tmp/sudoers-extra /etc/sudoers.d/taskcluster
chown root /etc/sudoers.d/taskcluster
chmod 0400 /etc/sudoers.d/taskcluster

mv /tmp/generic-worker-key.service /etc/systemd/system/generic-worker-key.service
mv /tmp/generic-worker.service /etc/systemd/system/generic-worker.service

systemctl enable generic-worker-key.service
systemctl enable generic-worker.service
