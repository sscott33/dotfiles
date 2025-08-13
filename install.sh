#!/run/current-system/sw/bin/bash

SCRIPT_PATH=$(readlink -e "$BASH_SOURCE")
SCRIPT_DIR=${SCRIPT_PATH%/*}

fatal() {
    local msg code
    msg=$1
    code=$2

    (( code < 1 || code > 255 )) && code=1

    printf >&2 -- '--E-- fatal: %s\n' "$msg"
    exit $code
}

info() {
    local msg
    msg=$1
    printf -- '--I-- %s\n' "$msg"
}

info "checking for deps"
# we should have git, but check anyways
command -v git &> /dev/null || fatal "command 'git' not found, please install the stupid content tracker"
command -v stow &> /dev/null || fatal "command 'stow' not found, please install GNU Stow"

info "updating Git submodules and initializing if necessary"
( \cd "$SCRIPT_DIR" && git submodule update --init; ) || fatal "git submodule update failed"

info "installing dotfiles to $USER's home with GNU Stow"
stow -v 2 -d "$SCRIPT_DIR" -t ~ -R . || fatal "stow failed"

info "making sure that ~/bin contentes are executable"
chmod --verbose +x ~/bin/* || fatal "chmod failed"

info "installing Vim plugins with Vundle"
vim +PluginInstall +qall || fatal "encountered an issue installing Vim plugins with Vundle"
