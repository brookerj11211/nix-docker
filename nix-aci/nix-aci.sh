#!/bin/bash

set -ex

tmp=$(mktemp -d)

type jq                                 # jq

: ${container_manifest:=manifest}
: ${container_name:=$(jq -r '.name' $container_manifest)}
: ${aci:=$tmp/$container_name.aci}
: ${aci_out:=$PWD}
: ${nix_config:=default.nix}
: ${cache_dir:=$tmp/cache}
: ${build_root:=$tmp/$container_name}
: ${container_rootfs:=$tmp/$container_name/rootfs}
: ${nix_attribute:=""}
: ${NIX_PATH:=${nix_path:-${CALLER_NIX_PATH}}}
: ${NIX_REMOTE:=${nix_remote:-${CALLER_NIX_REMOTE}}}


export NIX_PATH NIX_REMOTE

type mkdir mv dirname readlink            # coreutils
type nix-instantiate nix-env nix-store    # nix
type rsync                                # rsync
type actool                               # aci

if ! [ -e $container_manifest ]; then
    echo "Container manifest does not exist ... failed"
    exit 1
fi

if ! [ -e $nix_config ]; then
    echo "Nix config does not exist... failed"
    exit 1
fi


test -d $cache_dir || mkdir -p $cache_dir
test -d $build_root || mkdir -p $build_root

cp $container_manifest $build_root/manifest

root=$(nix-build "${nix_config}" --attr "${nix_attribute}" \
    --out-link $cache_dir/output \
    --drv-link $cache_dir/derivation)
closure=$(nix-store --query --requisites $root)


mkdir -p $container_rootfs/nix/store
rsync --recursive --links --perms --times --hard-links \
    $closure $container_rootfs/nix/store
rsync --recursive --links --perms --times \
    $root/ $container_rootfs

actool build $build_root $aci

actool -debug validate -type appimage  $aci

mv -v $aci $aci_out

# cleanup
#rm -rf $tmp
