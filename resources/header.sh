NRUN_AT_END=0

function set_variable {
    local name="$1"
    shift
    local value=("$@")
    set +v
    eval "$name=(\"\${value[@]}\")"
    set -v
}

function run_at_end {
    set_variable "RUN_AT_END_$NRUN_AT_END" "$@"
    set +e
    (( NRUN_AT_END++ ))
    set -e
}

function run_end_commands {
    set +v
    local i=0
    local name
    local value
    while [[ $i -lt $NRUN_AT_END ]]; do
        name="RUN_AT_END_$i"
        eval "value=(\"\${$name[@]}\")"
        echo "${value[@]}"
        "${value[@]}"
        set +e
        (( i++ ))
        set -e
    done
    set -v
}

set -ev
