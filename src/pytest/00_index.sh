#!/usr/bin/env bash
set +e -u
DN="$(readlink -f "$(dirname "${0}")")"
cd "${DN}"
. ../../lib/libstr
. ../../etc/path.conf
[ "${mypython}" = 'ylukh' ] && errh "Python not found"
infoh "Performing tests with args=${*}..."
for args in "${@}"; do
    if [ "${args}" = "all" ]; then
        for fn in "${DN}"/*.t.py; do
            printf "Executing ${fn}..."
            "${mypython}" "${fn}" && echo "PASS" || echo "FAIL"
        done
        exit
    elif [ -f "${DN}"/"${args}".t.sh ]; then
        printf "Executing ${DN}/${args}.t.py..."
        "${mypython}" "${DN}"/"${args}".t.py && echo "PASS" || echo "FAIL"
    else
        warnh "Target ${args} invalid. Skip"
    fi
done
