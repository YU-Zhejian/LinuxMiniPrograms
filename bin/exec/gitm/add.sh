#!/usr/bin/env bash
VERSION=1.3
for opt in "${UKOPT[@]}"; do
    case "${opt}" in
    "-h" | "--help")
        yldoc git-mirror_add
        exit 0
        ;;
    "-v" | "--version")
        echo "${VERSION}"
        exit 0
        ;;
    *)
        warnh "Option '${opt}' invalid. Ignored"
        ;;
    esac
done

[ ${#STDS[@]} -gt 0 ] || errh "Need more than ONE argument"
[ "${mypython}" != "ylukh" ] || errh "Python not found"
set -C
if ! echo -e "add\t${$}" >add.lock 2>/dev/null; then
    set +C
    echo -e "$(timestamp)\tADD\tOCCUPIED" >>act.log
    errh "Repository being added by $(cat add.lock)"
fi
for url in "${STDS[@]}"; do
    url=$(echo ${url} | sed 's;^file://;;')
    if ! "${mypython}" "${DN}"/exec/valid_url.py "${url}"; then
        warnh "Skipping bad URL ${url}"
        continue
    fi
    tmpf="$(mktemp -t gitm.XXXXX)"
    if grep_uuidtable "${url}" "${tmpf}" &>>/dev/null; then
        warnh "Skipping existing URL ${url}"
        continue
    fi
    while true; do
        uuid=$(uuidgen)
        grep_uuidtable "${uuid}" "${tmpf}" &>>/dev/null || break
    done
    infoh ${url}' -> '${uuid}
    mkdir "logs/${uuid}/"
    if git clone --mirror --no-hardlinks --verbose --progress "${url}" "${uuid}" 2>&1 | tee "logs/${uuid}/add-$(date '+%Y-%m-%d_%H-%M-%S').log"; then
        for fn in uuidtable.d/*; do
            ADDED=false
            if [ $(wc -l "${fn}" | awk '{print $1}') -le 1000 ]; then
                ADDED=true
                echo -e "${url}\t${uuid}" >>"${fn}"
                break
            fi
        done
        if ! ${ADDED}; then
            echo -e "${url}\t${uuid}" >>uuidtable.d/"$(date '+%Y-%m-%d_%H-%M-%S')"
        fi
        echo -e "$(timestamp)\tADD\tSUCCESS\t${url}\t${uuid}" >>act.log
    else
        warnh "${url} corrupted. Will be skipped"
        rm -rf "${uuid}" "logs/${uuid}/"
        echo -e "$(timestamp)\tADD\tFAILED\t${url}\t${uuid}" >>act.log
    fi
done
rm -f "${tmpf}" add.lock
