msg() {
    local level="${1}"
    shift

    local _esc=$'\033'
    local normal="$_esc[0m"

    case $level in
        # don't display debug messages unless DEBUG is set
        debug) [ -z "$DEBUG" ] && return ;;
        info) local color="$_esc[0;36m" ;;
        warn*) local color="$_esc[1;33m" ;;
        err*) local color="$_esc[1;31m" ;;
    esac

    echo "$color${@}$normal" >&2
}
