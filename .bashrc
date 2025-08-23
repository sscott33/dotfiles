### return if not running interactive ###
[[ $- == *i* ]] || return
########################################################################################################################

# SHELL OPTIONS ########################
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s histappend # do not overwrite history
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize # checks term size when bash regains control
# END SHELL OPTIONS ####################

# READLINE #############################
bind 'set bell-style none'
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
# END READLINE #########################

# INCLUDES #############################
. ~/.alias
. ~/src/paths.bash
. ~/src/utility_functions.bash
# END INCLUDES #########################

# PATH #################################
export AWKPATH=".:$HOME/src/awk"

paths=(
    "$HOME/bin"
)

for i in "${!paths[@]}"; do
    [[ -d ${paths[i]} ]] || unset "paths[$i]"
done
paths=( "${paths[@]}" )
PATH=$(IFS=:; echo "${paths[*]}:$PATH")
unset paths i p

# De-dupe PATH var
if [ -n "$PATH" ]; then
    old_PATH=$PATH:; PATH=
    while [ -n "$old_PATH" ]; do
        x=${old_PATH%%:*}       # the first remaining entry
        case $PATH: in
            *:"$x":*) ;;          # already there
            *) PATH=$PATH:$x;;    # not there yet
        esac
        old_PATH=${old_PATH#*:}
    done
    PATH=${PATH#:}
    unset old_PATH x
fi

export PATH
# END PATH #############################

# EDITOR/VIEWER ########################
EDITOR=$(type -p vim)
export EDITOR

PAGER=$(type -p less)
export PAGER
# END EDITOR/VIEWER ####################

# HISTORY ##############################
#export HISTCONTROL=ignoreboth:erasedups
export HISTCONTROL=ignoreboth
    # scroll back in history and use C-o to step-thru/repeat a series of commands
export HISTSIZE=5000
export HISTFILESIZE=5000
shopt -s histappend
#PROMPT_COMMAND='history -n; history -a'
# END HISTORY ##########################

# PROMPT ###############################
get_clearcase_view() {
    if [ "$CLEARCASE_ROOT" ]
    then
        echo -ne "($CLEARCASE_ROOT)" | sed -e "s/\/view\///"
    fi
}

[[ -z "$_PS1_VERSIONING" ]] && export _PS1_VERSIONING=on
fast_prompt() {
    if [[ -z "$1" || "$1" == "on" ]]; then
        export _PS1_VERSIONING=off
    else
        export _PS1_VERSIONING=on
    fi
}

# concatenate clearcase view and git status, pipe-separated
_concat() {
    #return
    local cc_view
    local git_view
    if [[ $_PS1_VERSIONING == "on" ]]; then
        cc_view=$(get_clearcase_view)
        git_view=$(__git_ps1 "(%s)")
    else
        cc_view=
        git_view=
    fi
    
    if [[ -n "$cc_view" && -n "$git_view" ]]; then
        echo -ne "{${cc_view} | ${git_view}}"
    elif [[ -z "$cc_view" && -z "$git_view" ]]; then
        return
    else
        echo -ne "{${cc_view}${git_view}}"
    fi
}

_jobs() {
    #local job_count=$(jobs | wc -l)
    #if (( job_count > 0 )); then
    #    printf "{%s}" $job_count
    #fi
    local count
    declare -a jobs
    readarray -t jobs < <(jobs -p)

    count=${#jobs[@]}
    (( count > 0 )) && printf "{%s}" $count
}

#_timer_start () {
#  _timer=${timer:-$SECONDS}
#}
#
#_timer_stop () {
#  _timer_show=$(($SECONDS - $timer))
#  _timer
#}
#
#if [ "$PROMPT_COMMAND" == "" ]; then
#  PROMPT_COMMAND="_timer_stop"
#else
#  PROMPT_COMMAND="$PROMPT_COMMAND; _timer_stop"
#fi

# abuse the DEBUG trap so that text follwing the command will use the default color
# (this trap is executed prior to each command's execution)
# https://unix.stackexchange.com/a/412934

normal_color="$(tput sgr0)"
_debug_trap () {
    [[ -t 1 ]] || return
    #set -x
    # this is problematic for loops in the shell
    printf "%s" "$normal_color"

    #[[ -e $HOME/.clipboard ]] && CLIP=$(<$HOME/.clipboard) || CLIP=

    # do this last
	#_timer_start
    #set +x
}

# because of the debug trap, we need this for some file redirects
clean_io () {
    if [[ $1 == "-revert" ]] ; then
        trap _debug_trap DEBUG
    else
        trap -- '' DEBUG
    fi
}
complete -W "-revert" clean_io
clean_io -revert

#git_loc=$(type -p git)
#git_loc=${git_loc%/*}
#. "$git_loc"/../share/bash-completion/completions/git-prompt.sh
#unset git_loc
. ~/src/git-prompt.sh
export GIT_PS1_DESCRIBE_STYLE='contains'
export GIT_PS1_SHOWCOLORHINTS='y'
export GIT_PS1_SHOWDIRTYSTATE='y'
export GIT_PS1_SHOWSTASHSTATE='y'
export GIT_PS1_SHOWUNTRACKEDFILES='y'
export GIT_PS1_SHOWUPSTREAM='auto'

red="\[$(tput setaf 9)\]"
green="\[$(tput setaf 10)\]"
white="\[$(tput setaf 15)\]"
if [ -n "$LSF_INVOKE_CMD" ]; then
    #set -x
    #export PS1="${white}"
    #export PS1+='[${_timer_show}s] '
    #export PS1+="${red}\h${white}[\W]"
    #set +x
    export PS1="${white}@${red}\h${white}[\W]"
    #export PS1+="$(get_clearcase_view)"
    #export PS1+='$(__git_ps1 "(%s)")\$ '
    export PS1+='$(_concat)$(_jobs)\$ '
else
    #set -x
    #export PS1="${white}"
    #export PS1+='[${_timer_show}s] '
    #export PS1+="${green}\h${white}[\W]"
    #set +x
    export PS1="${white}@${green}\h${white}[\W]"
    #export PS1+="$(get_clearcase_view)"
    #export PS1+='$(__git_ps1 "(%s)")\$ '
    export PS1+='$(_concat)$(_jobs)\$ '
fi
# END PROMPT ###########################

# LOCAL TWEAKS #########################
[[ -e ~/src/local_tweaks.sh ]] && . ~/src/local_tweaks.sh

# NEW SHELL INFO #######################
# print depth of shell
printf "%s " "## New shell:"
pstree -sH $$ $$ 2>/dev/null || echo "please install pstree"
printf "%s\n" "## Display: $DISPLAY"
