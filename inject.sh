#!/bin/bash

set -e
set -o pipefail

FILE=
USER=
VERBOSITY=0

#-----------------------------------------------------------
error() {
    echo "Error:" "$@" >&2
    exit 1
}

#-----------------------------------------------------------
log() {
    echo "$(date --utc +%Y-%m-%dT%H:%M:%SZ)" "$@"
}

#-----------------------------------------------------------
log_verbose() {
    if [ "$VERBOSITY" -ge 1 ]
    then
        log "$@"
    fi
}

#-----------------------------------------------------------
parse_arguments() {
    while [ "$#" -ge 1 ]
    do
        local ARG="$1"
        case "$ARG" in
            "-v" | "--verbose" )
                VERBOSITY=$((VERBOSITY + 1))
                ;;
            * )
                if [ -z "$USER" ]
                then
                    USER="$ARG"
                elif [ -z "$FILE" ]
                then
                    FILE="$ARG"
                else
                    error "Unknown argument '$ARG'"
                fi
                ;;
        esac
        shift
    done
}

#-----------------------------------------------------------
inject() {
    local COMMAND=(curl)
    local IDX=1 # Starting at 1 to pass one "--verbose" less than $VERBOSITY.
    while [ $IDX -lt $VERBOSITY ]
    do
        COMMAND+=( "--verbose" )
        IDX=$((IDX + 1))
    done
    COMMAND+=( \
        "--netrc" \
        "--form" "data=@$FILE" \
        "https://$USER.scanarium.com/cgi-bin/scan-data" \
        )

    log_verbose "Running" "${COMMAND[@]}"
    exec "${COMMAND[@]}"
}

#-----------------------------------------------------------
parse_arguments "$@"

[[ -n "$USER" ]] || error "No user given"
[[ -n "$FILE" ]] || error "No file given"

inject