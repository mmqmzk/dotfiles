_sshrc() {
    SSHRCD="${SSHHOME:-$HOME}/.sshrc.d"
    local OPTS=""
    local OPTS2=""
    local DOMAIN=""
    local CMD=""
    while [[ -n "$1" ]]; do
        case $1 in
            -D|-E|-e|-L|-O|-Q|-R|-S|-W|-w)
                OPTS="$OPTS $1 $2"
                shift
                ;;
            -b|-c|-F|-i|-I|-l|-m|-o|-p)
                OPTS2="$OPTS2 $1 $2"
                shift
                ;;
            -*)
                OPTS="$OPTS $1";
                ;;
            *)
                if [[ -z "$DOMAIN" ]]; then
                    DOMAIN=$1
                else
                    CMD=$1
                fi
                ;;
        esac
        shift
    done
    if [[ -z "$DOMAIN" ]]; then
        command ssh ${OPTS} ${OPTS2}
        return 1
    fi
    shopt -s extglob
    if [[ -e "$SSHRCD" ]] && [[ "$OPTS" != *(*-N*|*-D*|*-L*|*-R*|*-W*|*-w*) ]]; then
        local dir=$(dirname "$SSHRCD")
        local name=$(basename "$SSHRCD")
        local randomFileName=".sshrc.d.$(cat /dev/urandom | tr -dc '0-9a-zA-Z' | head -c 32 -q)"
        local dest="${SSHRCD_DEST:-/tmp}/$randomFileName"
        tar -hzcf - -C "$dir" "$name" | command ssh -T ${OPTS2} "$DOMAIN" "mkdir -p '$dest' && tar -zxf - -C '$dest'"
        if [[ -z "$CMD" ]]; then
            CMD="/usr/bin/env SSHRCD='$dest/$name' bash --rcfile '$dest/$name/sshrc'"
            OPTS="$OPTS -t"
        else
            CMD="export SSHRCD='$dest/$name'; source '$dest/$name/sshrc'; $CMD"
        fi
    fi

    command ssh ${OPTS} ${OPTS2} ${DOMAIN} ${CMD}
}

