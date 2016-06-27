#!/bin/bash

# copy key file from user directory
if [ ! -e ~/.ssh/id_rsa ] || [ ! -e ~/.ssh/id_rsa.pub ]; then
    echo "Error! can't find key file on ~/.ssh/";
    echo "You must create your key files before workspace setup";
    exit 1;
fi

# copy keyfiles
cp ~/.ssh/id_rsa ./
cp ~/.ssh/id_rsa.pub ./

# create db directories
mkdir -p ./data/{mysql,postgres,redis,mongodb}

# build dev
docker-compose build

# pull db images
docker-compose pull

# remove key files
rm -rf ./id_rsa
rm -rf ./id_rsa.pub

exit 0;
