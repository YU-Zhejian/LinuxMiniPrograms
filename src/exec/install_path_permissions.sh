#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.10
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
. etc/path.conf

__rc_write() {
    # ~/.LMP_TEST_NOINTERCTIVErc is used for debugging in a non-interactive shell, like those in Docker
    builtin echo "${1}" | \
    tee -a "${HOME}"/.bashrc | \
    tee -a "${HOME}"/.zshrc | \
    tee -a "${HOME}"/.LMP_TEST_NOINTERCTIVErc
}

#========Install PATH========
if ! which yldoc &>/dev/null; then
    __rc_write "export PATH=\"${DN}/bin/:\${PATH:-}\""
    infoh "Will configure PATH (bin)...${ANSI_GREEN}PASSED"
fi
if ! which ylsjsd &>/dev/null; then
    __rc_write "export PATH=\"${DN}/sbin/:\${PATH:-}\""
    infoh "Will configure PATH (sbin)...${ANSI_GREEN}PASSED"
fi
if ${VAR_install_shinclude}; then
    __rc_write "export SH_INCLUDE_PATH=\"${DN}/shlib/:\${SH_INCLUDE_PATH:-}\""
    infoh "Will configure PATH (sbin)...${ANSI_GREEN}PASSED"
fi
#========Install PYTHONPATH========
# shellcheck disable=SC2154
if [ "${mypython}" != "ylukh" ] && ! has_python_package linuxminipy "${mypython}"; then
    if has_python_package setuptools "${mypython}" ;then
        builtin cd "${DN}"/libpy || exit 1
        "${mypython}" setup.py install
        builtin cd .. || exit 1
    else
        __rc_write "export PYTHONPATH=\"${DN}/libpy/:\${PYTHONPATH:-}\""
    fi
    infoh "Will configure PYTHONPATH...${ANSI_GREEN}PASSED"
fi
#========Install MANPATH========
if [ -e man/man1 ] && ! man yldoc &> /dev/null; then
    __rc_write "export MANPATH=\"${DN}/man1/:\${MANPATH:-}\""
fi
if [ -e man/man7 ] && ! man libisopt &> /dev/null; then
    __rc_write "export MANPATH=\"${DN}/man7/:\${MANPATH:-}\""
fi
infoh "Will configure MANPATH...${ANSI_GREEN}PASSED"
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
