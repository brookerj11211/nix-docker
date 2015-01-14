#!/bin/sh

set -ex

# disable apt frontend to prevent
# any troublesome questions
export DEBIAN_FRONTEND=noninteractive

VERSION=1.4
OS=linux
ARCH=amd64

bin='/usr/local/go/bin'

if ! [ -e /usr/local/go ]; then
    wget -q https://storage.googleapis.com/golang/go$VERSION.$OS-$ARCH.tar.gz
    tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz
fi

# setup environments
echo 'export PATH=$PATH:'$bin > /etc/profile.d/gopath.sh
export PATH=$PATH:$bin

which git || apt-get install -y git

[ -e spec ] || git clone https://github.com/appc/spec.git
cd spec
./build
echo 'export PATH=$PATH:'$PWD/bin > /etc/profile.d/acipath.sh
cd ..

# install rocket
if ! [ -e rocket ]; then
    wget -q https://github.com/coreos/rocket/releases/download/v0.1.1/rocket-v0.1.1.tar.gz
    tar xzvf rocket-v0.1.1.tar.gz
fi

# nix-aci script depencencies
apt-get install -y jq

