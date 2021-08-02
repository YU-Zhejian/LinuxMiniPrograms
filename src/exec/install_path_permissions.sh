#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.11
builtin set -eu
DN="$(readlink -f "$(dirname "${0}")/../../")"
builtin cd "${DN}"
. shlib/libinclude.sh
VAR_install_shinclude=false
if ! __core_include libstr &> /dev/null; then
    export SH_INCLUDE_PATH="${SH_INCLUDE_PATH:-}:${PWD}/shlib"
    VAR_install_shinclude=true
fi

__include libstr
__include libman
. etc/linuxminiprograms/path.conf

#========Install PYTHONPATH========
# shellcheck disable=SC2154
if [ "${mypython}" != "ylukh" ] && ! has_python_package linuxminipy "${mypython}"; then
    if has_python_package setuptools "${mypython}" ;then
        builtin cd "${DN}"/libpy || exit 1
        "${mypython}" setup.py install
        builtin cd .. || exit 1
    else
        warnh "setuptools not found! Please install Python libraries located at ${DN}/libpy manually."
    fi
    infoh "Will configure PYTHONPATH...${ANSI_GREEN}PASSED"
fi
#========Install Permissions========
__change_dir_permissions() {
    ls -1 | while builtin read file_name; do
        if [ -f "${file_name}" ]; then
            # builtin echo - "${file_name}"
            chmod -x "${file_name}"
        else
            # builtin echo + "${file_name}"
            builtin cd "${file_name}"
            __change_dir_permissions
            builtin cd ..
        fi
    done
}
chown -R "$(id -u)" *
chmod -R +r+w *
__change_dir_permissions
chmod +x configure bin/* sbin/* bin/exec/*.co* sbin/exec/*.co* *.sh || true
infoh "Modifying file permissions...${ANSI_GREEN}PASSED"
infoh "Finished. Please execute 'builtin exec bash' to restart bash"
