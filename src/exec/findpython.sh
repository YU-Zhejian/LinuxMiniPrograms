#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.5
# shellcheck disable=SC1090
# shellcheck disable=SC2154
. "${path_sh}"
if [ -z "${mypython:-}" ]; then
    python_ver=3
    # shellcheck disable=SC2154
    for dir in "${eachpath[@]}"; do
        # shellcheck disable=SC2010
        while builtin read line; do
            if builtin echo "exit()" | "${line}" -v 2>&1 | grep -E '([C-Z]:\\)' >/dev/null; then
                infoh "Windows Python found in ${line}"
                builtin continue
            fi
            builtin echo "Python found in ${line}"
            curr_version=$("${line}" --version 2>&1 | cut -f 2 -d " ")
            # shellcheck disable=SC2046
            if [[ "${curr_version}" == 3* ]] && [ $(expr "${curr_version}" \>= "${python_ver}") -eq 1 ]; then
                Out_C="${line}"
                python_ver="${curr_version}"
                break 2 # Use fast mode
            fi
            builtin unset curr_version line
        done < <(ls -F -1 "${dir}" | grep '.[*@]$' | sed 's;[*@]$;;' | grep -E '^(python(3|2){0,1}(\.[[:digit:]]+)*(d|m|u){0,1}(.exe){0,1}$)' | sed "s;^;$(builtin echo ${dir})/;")
        builtin unset dir
    done
    if [ -n "${Out_C:-}" ]; then
        builtin echo "mypython=\"${Out_C}\" #version ${python_ver}" >>"${path_sh}"
        builtin echo "Python found in ${Out_C}, version ${python_ver}"
        builtin unset Out_C
    else
        builtin echo "mypython=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        warnh "Python still not found. Please configure it manually in $(readlink -f "${path_sh}")"
    fi
    builtin unset python_ver
    # shellcheck disable=SC1090
    . "${path_sh}"
else
    infoh "python configured"
fi
