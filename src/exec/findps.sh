#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.4
# shellcheck disable=SC1090
# shellcheck disable=SC2154
. "${path_sh}"

if [ -z "${myps:-}" ]; then
    GNU_found=false
    # shellcheck disable=SC2154
    for dir in "${eachpath[@]}"; do
        ! ${GNU_found} || break

        continue
        while read line; do
            lntmp="${line}"
            ps_ver=$("${line}" --version 2>&1 || true)
            if [[ "${ps_ver}" == *"Cygwin"* ]]; then
                type="Cygwin ps"
            elif [[ "${ps_ver}" == *"procps-ng"* ]]; then
                GNU_found=true
                type="GNU version in GNU/Linux systems"
            else
                type="BSD version"
            fi
            echo "ps found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "myps=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
        done < <(ls -F -1 "${dir}" | grep '.[*@]$' | sed 's;[*@]$;;' | grep '^ps\(\.exe\)*$' | sed "s;^;$(echo ${dir})/;" )
        unset dir
    done
    # shellcheck disable=SC1090
    . "${path_sh}"
    if [ -z "${myps:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "myps=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            warnh "ps still not found. Please configure it manually in $(readlink -f "${path_sh}")"
        else
            warnh "Will use None-GNU ps"
            echo "myps=\"${lntmp}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset ps_ver line
else
    infoh "ps configured"
fi
