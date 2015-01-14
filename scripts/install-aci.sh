#!/bin/sh

set -ex

# disable apt frontend to prevent
# any troublesome questions
export DEBIAN_FRONTEND=noninteractive

VERSION=1.4
OS=linux
ARCH=amd64

rktver=0.1.1

bin='/usr/local/go/bin'

if ! [ -e /usr/local/go ]; then
    wget -q https://storage.googleapis.com/golang/go$VERSION.$OS-$ARCH.tar.gz
    tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz
fi

# setup environments
echo 'export PATH=$PATH:'$bin > /etc/profile.d/gopath.sh
export PATH=$PATH:$bin

which git || apt-get install -y git

if ! [ -e spec ] ; then 
    git clone https://github.com/appc/spec.git
    cd spec
    ./build
    echo 'export PATH=$PATH:'$PWD/bin > /etc/profile.d/acipath.sh
cd ..

# install rocket
if ! [ -e rocket-v$rktver ]; then
    wget -q https://github.com/coreos/rocket/releases/download/v0.1.1/rocket-v${rktver}.tar.gz
    tar xzvf rocket-v${rktver}.tar.gz
    echo 'export PATH=$PATH:'$PWD/rocket-v${rktver} > /etc/profile.d/rktpath.sh
fi

# nix-aci script depencencies
apt-get install -y jq

