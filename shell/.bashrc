[[ -e ~/.alias ]] && . ~/.alias

mkdir -p ~/bin

mkdir -p ~/src/bash

[[ ! -e ~/src/bash/paths.bash ]] && git clone https://github.com/sscott33/paths.bash.git ~/src/bash/paths.bash
[[ -e ~/src/bash/paths.bash ]] && . ~/src/bash/paths.bash/paths.bash

EDITOR=$(which vim)
