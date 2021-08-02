#!/usr/bin/env bash
VERSION=1.6
n=15
for opt in "${UKOPT[@]}"; do
    case "${opt}" in
    "-h" | "--help")
        man ylsjs
        builtin exit 0
        ;;
    "-v" | "--version")
        builtin echo "${VERSION}"
        builtin exit 0
        ;;
    -n\:*)
        n=${opt:3}
        ;;
    *)
        warnh "Option '${opt}' invalid. Ignored"
        ;;
    esac
done

__kill() {
    if [ -f "${1}".q ]; then
        mv "${1}".q "${ps_name}".f
        return
    elif [ -f "${1}".f ]; then
        warnh "Process ${1} finished"
        return
    elif ! [ -f ${1}.i ]; then
        warnh "Process ${1} not found"
        return
    fi
    PID=$(cat ${1}.i | tail -n 1)
    kill_tree ${PID} ${n} || true
    sleep 1
    if ps -p ${PID} &> /dev/null; then
        warnh "Failed to builtin kill ${1} with PID=${PID}. Retry with -n:9 option"
    else
        infoh "${1} killed"
    fi
}

if [ ${#STDS[@]} -eq 0 ]; then
    errh "Which process to kill?"
else
    for ps_name in "${STDS[@]}"; do
        __kill ${ps_name} &
    done
fi
