#!/usr/bin/env bash
# VERSION=2.4

if [ -z "${__LIBPATH_VERSION:-}" ];then
    __LIBPATH_VERSION=2.4
    validate_path (){
        builtin mapfile -t eachpath  < <(builtin echo ${1} | tr ':' '\n' )
        valid_path=':'
        invalid_path=':'
        duplicated_path=':'
        for dir in "${eachpath[@]}"; do
            dir_full=$(readlink -f "${dir}" || true)
            if [ ! -d "${dir_full}" ]; then
                invalid_path="${invalid_path}${dir}:"
            elif [[ ${valid_path} == *":${dir_full}:"* ]]; then
                duplicated_path="${duplicated_path}${dir_full}:"
            else
                valid_path="${valid_path}${dir_full}:"
            fi
            builtin unset dir_full dir
        done
        [ "${duplicated_path}" = ":" ] || duplicated_path=${duplicated_path:1:-1}
        [ "${invalid_path}" = ":" ] || invalid_path=${invalid_path:1:-1}
        [ "${valid_path}" = ":" ] || valid_path=${valid_path:1:-1}
    }


    __addpref() {
        builtin echo "/${1}"
        builtin echo "/usr/${1}"
        builtin echo "/usr/local/${1}"
        builtin echo "${HOME}/${1}"
        builtin echo "${HOME}/usr/${1}"
        builtin echo "${HOME}/usr/local/${1}"
    }
fi
