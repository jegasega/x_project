#!/bin/bash

set -e

export PACKER_LOG=1
if [[ -e ./output-virtualbox-iso ]];
then

  rm -rf ./output-virtualbox-iso || true

fi

./packer.exe build -only virtualbox-iso packer.json
vagrant box remove debian-11.0.0-amd64-js || true
vagrant box add debian-11.0.0-amd64-js ./debian-11.0.0-amd64-js.box
