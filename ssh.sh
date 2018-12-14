_sshrc() {
    SSHRC="${SSHHOME:=$HOME}/.sshrc"
    local OPTS=""
    local OPTS2=""
    local DOMAIN=""
    local CMD=""
    while [[ -n $1 ]]; do
        case $1 in
            -D|-E|-e|-F|-L|-O|-Q|-R|-S|-W|-w)
                OPTS="$OPTS $1 $2"
                shift
                ;;
            -c|-i|-l|-o|-p|-b|-I|-m)
                OPTS2="$OPTS $1 $2"
                shift
                ;;
            -t|-T)
                ;;
            -*)
                OPTS="$OPTS $1";
                ;;
            *)
                if [[ -z $DOMAIN ]]; then
                    DOMAIN=$1
                else
                    CMD=$1
                fi
                ;;
        esac
        shift
    done
    if [[ -z $DOMAIN ]]; then
        command ssh $OPTS $OPTS2
        return 1
    fi
    if [[ -f $SSHRC ]]; then
        local dir=$(dirname $SSHRC)
        local name=$(basename $SSHRC)
        local dest=${SSHRC_DEST:="/tmp"}
        tar -hzcf - -C $dir $name | command ssh $OPTS2 $DOMAIN "tar -zxf - -C $dest"
        if [[ -z $CMD ]]; then
            CMD="source $dest/$name && bash -i"
        else
            CMD="source $dest/$name; $CMD"
        fi
    else
        echo ".sshrc file not find"
    fi

    command ssh -t -t $OPTS $OPTS2 $DOMAIN $CMD
}

