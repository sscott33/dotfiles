#!/run/current-system/sw/bin/bash

SCRIPT_PATH=$(readlink -e "$BASH_SOURCE")
SCRIPT_DIR=${SCRIPT_PATH%/*}

fatal() {
    local msg code
    msg=$1
    code=$2

    (( code < 1 || code > 255 )) && code=1

    echo >&2 "Fatal: $*"
    exit $code
}

# we should have git, but check anyways
command -v git &> /dev/null || fatal "command 'git' not found, please install 'the stupid content tracker'"

# check if we have GNU stow
command -v stow &> /dev/null || fatal "command 'stow' not found, please install GNU Stow"

# install packages
stow -v 2 -d "$SCRIPT_DIR" -t ~ -S vim -S tmux -S shell -S bin_src

# make sure bin contentes are executable
chmod --dereference +x ~/bin/*
