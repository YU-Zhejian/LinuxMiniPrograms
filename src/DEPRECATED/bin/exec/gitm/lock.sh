#!/usr/bin/env bash
VERSION=1.3

FORCE=false
for opt in "${UKOPT[@]}"; do
    case "${opt}" in
    "-h" | "--help")
        yldoc git-mirror_lock
        exit 0
        ;;
    "-v" | "--version")
        echo "${VERSION}"
        exit 0
        ;;
    "-f" | "--force")
        FORCE=true
        ;;
    *)
        warnh "Option '${opt}' invalid. Ignored"
        ;;
    esac
done

[ ${#STDS[@]} -gt 0 ] || errh "Need more than ONE argument"
case "${STDS[1]}" in
"ls")
    if ls *.lock &>>/dev/null; then
        for fn in *.lock; do
            echo ${fn}"\t"$(cat ${fn})
        done
        echo -e "$(timestamp)\tLOCKLS\tSUCCESS" >>act.log
        infoh "Repository lock ls success"
    else
        infoh "No lock presented"
        echo -e "$(timestamp)\tLOCKLS\tNOLOCK" >>act.log
    fi
    ;;
"rm")
    unset STDS[1]
    tmpf="$(mktemp -t gitm.XXXXX)"
    tmpff="$(mktemp -t gitm.XXXXX)"
    if [ ${#STDS[@]} -gt 0 ]; then
        for url in "${STDS[@]}"; do
            grep_uuidtable "${url}" "${tmpf}" || warnh "${url} yields no results"
        done
    else
        cat uuidtable.d/* >"${tmpf}"
    fi
    while read line; do
        IFS=$'\t'
        fields=(${line})
        IFS=''
        [ -f "${fields[1]}".lock ] && echo ${line} | tee -a "${tmpff}"
    done <"${tmpf}"
    [ $(wc -l "${tmpff}" | awk '{print $1}') -ne 0 ] || FORCE=true
    if ! ${FORCE}; then read -p "Will remove locks of above repos. Continue? [Y/n] >" ANSWER; else ANSWER="Y"; fi
    if [ "${ANSWER}" = "Y" ]; then
        cat "${tmpff}" | while read line; do
            IFS=$'\t'
            fields=(${line})
            IFS=''
            if ps -p $(cat "${fields[1]}.lock" | awk '{print $2}') &>>/dev/null; then
                echo -e "$(timestamp)\tRMLOCK\tOCCUPIED\t${fields[0]}\t${fields[1]}" >>act.log
                warnh "Process still running for UUID=${fields[1]}. Will skip this repo"
                continue
            fi
            rm -f "${fields[1]}".lock
            echo -e "$(timestamp)\tRMLOCK\tSUCCESS\t${fields[0]}\t${fields[1]}" >>act.log
            infoh "Repository UUID=${fields[1]} rmlock success"
        done
    fi
    rm -f "${tmpf}" "${tmpff}"
    for fn in sync.lock rm.lock archive.lock gc.lock uuidtable.lock add.lock; do
        if ps -p $(cat "${fn}" 2>/dev/null | awk '{print $2}') &>>/dev/null; then
            warnh "Process still running for ${fn}. Will skip this lock."
            continue
        elif [ ! -e ${fn} ]; then
            continue
        fi
        if ! ${FORCE}; then
            rm -i "${fn}"
        else
            rm -f "${fn}" &>/dev/null
        fi
    done
    ;;
"add")
    unset STDS[1]
    [ ${#STDS[@]} -gt 0 ] || errh "Need more than ONE argument"
    tmpf="$(mktemp -t gitm.XXXXX)"
    for url in "${STDS[@]}"; do
        grep_uuidtable "${url}" "${tmpf}" || warnh "${url} yields no results"
    done
    if ! ${FORCE}; then read -p "Will add locks to above repos. Continue? [Y/n] >" ANSWER; else ANSWER="Y"; fi
    if [ "${ANSWER}" = "Y" ]; then
        cat "${tmpf}" | while read line; do
            IFS=$'\t'
            fields=(${line})
            IFS=''
            echo -e "lock\t${$}" >"${fields[1]}".lock
            echo -e "$(timestamp)\tADDLOCK\tSUCCESS\t${fields[0]}\t${fields[1]}" >>act.log
            infoh "Repository UUID=${fields[1]} addlock success"
        done
    fi
    rm -f "${tmpf}"
    ;;
*)
    errh "Invalid sub-sub command '${STDS[1]}'"
    ;;
esac
