#!/bin/bash

set -e
set -o pipefail

FILE=
USER="$(whoami)"
VERBOSITY=0

#-----------------------------------------------------------
print_help() {
    local NAME="$(basename "$0")"
    cat <<EOF
$NAME
-------------

Uploads an image to Scanarium for scanning.

Usage:
  $NAME [ OPTIONS ] FILE

FILE - The file to upload


The given FILE gets uploaded to Scanarium for the current system user
(See '--user'). Credentials for uploading are taken from '.netrc'
(See https://everything.curl.dev/usingcurl/netrc )



OPTIONS:
  -h, --help        -- Prints this help page and exits
  --user USER       -- Upload to the Scanarium as USER instead of the current
                       system user.
  -v, --verbosity   -- Increases verbosity



Return value:
  0: The uploading of the file worked. Note that this does not mean the the
    subsequent scanning worked, for this you need to look into the command's
    JSON output.
  Any other value: An error occurred.


Output:
  If the return value is 0, the output contains a JSON object with details and
  result of the scanning process.
EOF
    exit 1
}

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
        shift 1
        case "$ARG" in
            "-h" | "--help" )
                print_help
                ;;
            "--user" )
                [[ $# -ge 1 ]] || error "--user needs another argument"
                USER="$1"
                shift 1
                ;;
            "-v" | "--verbose" )
                VERBOSITY=$((VERBOSITY + 1))
                ;;
            * )
                if [ -z "$FILE" ]
                then
                    FILE="$ARG"
                else
                    error "Unknown argument '$ARG'"
                fi
                ;;
        esac
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