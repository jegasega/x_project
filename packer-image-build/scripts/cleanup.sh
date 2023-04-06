#!/bin/bash -eux

#pip3 uninstall -y ansible

apt -y autoremove --purge
apt-get clean

sleep 60
