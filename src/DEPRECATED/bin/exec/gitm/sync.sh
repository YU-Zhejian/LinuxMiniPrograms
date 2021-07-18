#!/usr/bin/env bash
VERSION=1.4
for opt in "${UKOPT[@]}"; do
    case "${opt}" in
    "-h" | "--help")
        yldoc git-mirror_sync
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

tmpf="$(mktemp -t gitm.XXXXX)"
__sync() {
    infoh "Repository UUID=${fields[1]} sync started"
    rm -fr "${fields[1]}".sync
    cp -r "${fields[1]}" "${fields[1]}".sync
    echo -e "$(timestamp)\tSYNC_CPDIR\tSUCCESS\t${fields[0]}\t${fields[1]}" >>act.log
    cd "${fields[1]}".sync
    if git remote --verbose update --prune &>../logs/"${fields[1]}"/sync-"$(date '+%Y-%m-%d_%H-%M-%S')".log; then
        cd ..
        mv "${fields[1]}" "${fields[1]}".obs
        mv "${fields[1]}".sync "${fields[1]}"
        rm -rf "${fields[1]}".obs
        echo -e "$(timestamp)\tSYNC\tSUCCESS\t${fields[0]}\t${fields[1]}" >>act.log
        infoh "Repository UUID=${fields[1]} sync success"
    else
        cd ..
        rm -rf "${fields[1]}".sync
        echo -e "$(timestamp)\tSYNC\tFAILED\t${fields[0]}\t${fields[1]}" >>act.log
        warnh "Repository UUID=${fields[1]} sync failed. Will skip this repo"
    fi
    rm "${fields[1]}".lock
}
set -C
if ! echo -e "sync\t${$}" >sync.lock 2>/dev/null; then
    set +C
    echo -e "$(timestamp)\tSYNC\tOCCUPIED" >>act.log
    errh "Repository being synced by $(cat sync.lock)"
fi
set +C
cat uuidtable.d/* | while read line; do
    IFS=$'\t'
    fields=(${line})
    IFS=''
    set -C
    if ! echo -e "sync\t${$}" >"${fields[1]}".lock 2>/dev/null; then
        warnh "Repository UUID=${fields[1]} is being locked by $(cat "${fields[1]}".lock). Will skip this repo"
        echo -e "$(timestamp)\tSYNC\tOCCUPIED\t${fields[0]}\t${fields[1]}" >>act.log
        continue
    fi
    set +C
    __sync
done
rm -f "${tmpf}" sync.lock
