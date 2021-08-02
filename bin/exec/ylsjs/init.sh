#!/usr/bin/env bash
VERSION=1.5
NAME="UK"
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
        NAME=${opt:3}
        ;;
    --name\:*)
        NAME=${opt:7}
        ;;
    *)
        warnh "Option '${opt}' invalid. Ignored"
        ;;
    esac
done

MAX_JOB=$(ls -1 *.sh | wc -l | awk '{print $1}')
MAX_JOB=$((${MAX_JOB} + 1))
builtin echo "${NAME}" >${MAX_JOB}.q
builtin echo "${WD}" >${MAX_JOB}.wd
cat /dev/stdin >${MAX_JOB}.sh
builtin echo ${MAX_JOB}
infoh "$(cat ${MAX_JOB}.q)"
