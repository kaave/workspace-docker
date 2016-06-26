#!/bin/bash

# copy key file from user directory
if [ ! -e ~/.ssh/id_rsa || ! -e ~/.ssh/id_rsa ]; then
    echo "\e[1;31m Error! can't find key file on ~/.ssh/ \e[m";
    echo "\e[1;31m You must create your key files before workspace setup \e[m";
    exit 1;
fi

cp ~/.ssh/id_rsa ./
cp ~/.ssh/id_rsa.pub ./

# build dev
docker-compose build

# pull db images
docker-compose pull

# remove key files
rm -rf ./id_rsa
rm -rf ./id_rsa.pub


exit 0;

