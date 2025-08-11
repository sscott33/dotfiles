# grep through history, showing at most the 20 most recent results
hg() {
    #local matches=${
    history | \grep -E --color=always "$@" | tail -21 | head -n -1
}

# colored man pages
#man() {
#    #LESS='--RAW-CONTROL-CHARS'
#    export LESS_TERMCAP_md=$'\e[01;31m' \
#    export LESS_TERMCAP_me=$'\e[0m' \
#    export LESS_TERMCAP_us=$'\e[01;32m' \
#    export LESS_TERMCAP_ue=$'\e[0m' \
#    export LESS_TERMCAP_so=$'\e[45;93m' \
#    export LESS_TERMCAP_se=$'\e[0m' \
#    command man "$@"
#}

# kill all children
# can do this for bash with lord_vader $$
# should modify to have option to not kill with -9
# from https://stackoverflow.com/a/26966800
#kill_descendant_processes() {
lord_vader() {
    local pid="$1"
    local and_parent="${2:-false}"
    if children="$(pgrep -P "$pid")"; then
        local child
        for child in $children; do
            lord_vader "$child" true
        done
    fi
    if $and_parent; then
        echo killing $pid
        kill -9 "$pid"
    fi
}

# get the RAM usage of all users on current host
user_mem() {
    # from https://serverfault.com/a/395529
    # look at the comments on this answer
    ps --no-headers -eo user,rss | awk '{arr[$1]+=$NF}; END {for (i in arr) {print i,arr[i], "KB"}}' | sort -nk2
}

# to files passed: add a shebang and make executable (supported file extentions only)
shebang() {
    #if [[ "$(grep -En '^#!' myvim.sh | cut -d: -f1)" -ne 1 ]];
    local prog script str
    for script in "$@"; do
        case "$script" in
            *.awk)
                prog=$(type -p gawk)
                str=$(printf '1i#!%s -f\' "$prog")
                sed -i "$str" "$script" ;;
            *.py)
                prog=$(type -p python3)
                str=$(printf '1i#!%s\' "$prog")
                sed -i "$str" "$script" ;;
            *.sh | *.bash)
                prog=$(type -p bash)
                str=$(printf '1i#!%s\' "$prog")
                sed -i "$str" "$script" ;;
            *)
                echo "unrecognized appension for script '$script'"
        esac
        chmod +x "$script"
    done
}

# simple terminal calculator; must quote arguments if there are special characters or spaces
#calc() {
#    awk "BEGIN {print $*}"
#}

# archive extraction function
# currently broken due to desire to more smartly match within the case statement
# fix it by using case to set compression_format and if_tarball
ex ()
{
    if [ -f "$1" ] ; then
        local typical_tarballs=$(echo -n *{.{t,tar.}{gz,bz2,xz},.tar})
        typical_tarballs="${typical_tarballs// /|}"

        # need the eval to properly expand $typical_tarballs before case execution
        eval "
        case '$1' in
            $typical_tarballs)  tar xf '$1'     ;;   # this line does not work without eval
            *.gz)               gunzip '$1'     ;;
            *.xz)               unxz '$1'       ;;
            *.zip)              unzip '$1'      ;;
            *.7z)               7z x '$1'       ;;
            *.Z)                uncompress '$1' ;;
            *.rar)              unrar x '$1'    ;;
            *.deb)              ar x '$1'       ;;
            *.zst)              unzstd '$1'     ;;

            *) echo '\"$1\" cannot be extracted via ex()' ;;
        esac
        "
    else
        echo "'$1' is not a valid file"
    fi
}

#ex ()
#{
#    if [ -f "$1" ] ; then
#        case "$1" in
#            *{.{t,tar.}{gz,bz2,xz},.tar})  tar xf "$1"     ;;   # this line does not work
#            *.gz)               gunzip "$1"     ;;
#            *.xz)               unxz "$1"       ;;
#            *.zip)              unzip "$1"      ;;
#            *.7z)               7z x "$1"       ;;
#            *.Z)                uncompress "$1" ;;
#            *.rar)              unrar x "$1"    ;;
#            *.deb)              ar x "$1"       ;;
#            *.zst)              unzstd "$1"     ;;
#
#            *) echo "'$1' cannot be extracted via ex()" ;;
#        esac
#    else
#        echo "'$1' is not a valid file"
#    fi
#}

# grep for drcs in the given file/DRC.sum; if no argument given, file must be in the working dir

# wrapper function to display months with ISO week numbers
#alias c='cal -mwn 2'
c () {
    local months=${1:-3}

    cal -mwn $months
}

rename_xterm () {
    echo -ne "\033]2;$*\007"
}

# emergency kill of my processes
_ekill () {
    local host="$1"
    #local kill_cmd='kill -9 $(pgrep -u $USER)'

    if [[ -n "$host" ]]; then
        echo "killing your processes on $host"
        ssh "$host" 'kill -9 $(pgrep -u $USER)'
    else
        echo "killing your processes"
        kill -9 $(pgrep -u $USER)
    fi
}


ww () {
    date "$@" +w%g%V
}

pf () {
    head -n -0 "$@"
}

= () {
    # concept and initial credit to grymoire via Reddit (4/30/2023)
    # https://www.reddit.com/r/bash/comments/133tyzt/improvement_in_my_alias_which_bookmarks/
    #
    # additional modifications made to improve the concept

    (( $# == 1 )) || { echo "function '=' requires exactly one argument" >&2; return 1; }
    local __dir="$(realpath "$(pwd)")"
    eval "$1='$__dir'"
    eval "$1 () { cd '$__dir'; }"
}

# quick display setting
d () {
    export DISPLAY=$1
}

time_diff () {
    local t1 t2
    local arg1_type=d arg2_type=d

    [[ -e "$1" ]] && arg1_type=r
    [[ -e "$2" ]] && arg2_type=r
    
    t2="$(date -$arg1_type "$1" +%s)"
    t1="$(date -$arg2_type "$2" +%s)"
    #awk -v t2=$t2 -v t1=$t1 'BEGIN {CONVFMT = "%.3g"; t = t2 - t1; print t / 60 / 60 " hours"; exit(0)}'
    awk -v t2=$t2 -v t1=$t1 'BEGIN {OFMT = "%02.g"; t = t2 - t1; th = t / 60 / 60; hr = int(th); min = int(60 * (th - hr)) ; printf "%d hours and %d minutes\n", hr, min; exit(0)}'
}

alias td=time_diff

