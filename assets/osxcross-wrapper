#!/bin/bash

# set -x

# check if we are a symlink
if [ "$(readlink -f $0)" != "$0" ]; then
    exec "$(readlink -f $0)" $@
    exit $?
fi

# normal behavior -> proxy to osxcross binary
triple=$(echo "$0" | cut -d/ -f3)
binary=$(basename "$0")
binary_path="/usr/osxcross/bin/$triple-$binary"

exec "$binary_path" $@
