#!/bin/sh

set -e

# disable apt frontend to prevent
# any troublesome questions
export DEBIAN_FRONTEND=noninteractive

apt-get install -y git

git clone https://github.com/appc/spec.git
cd spec
./build
