#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.10
builtin set -eu
DN="$(readlink -f "$(dirname "${0}")/../../")"
builtin cd "${DN}"
. lib/libstr
. etc/path.conf

rcWrite() {
    builtin echo "${1}" | tee -a "${HOME}"/.bashrc | tee -a "${HOME}"/.zshrc
    # TODO: Support SH, ZSH
}

#========Install PATH========
if ! which yldoc &>/dev/null; then
    rcWrite "export PATH=\"${DN}/bin/:\${PATH:-}\""
    infoh "Will configure PATH (bin)...${GREEN}PASSED"
fi
if ! which ylsjsd &>/dev/null; then
    rcWrite "export PATH=\"${DN}/sbin/:\${PATH:-}\""
    infoh "Will configure PATH (sbin)...${GREEN}PASSED"
fi
#========Install PYTHONPATH========
# shellcheck disable=SC2154
if [ "${mypython}" != "ylukh" ] && ! builtin echo "from linuxminipy.libylfile import *" | "${mypython}" &>>/dev/null; then
    rcWrite "export PYTHONPATH=\"${DN}/libpy/:\${PYTHONPATH:-}\""
    infoh "Will configure PYTHONPATH...${GREEN}PASSED"
fi
#========Install MANPATH========
if [ -e man/man1 ] && ! man yldoc &>>/dev/null; then
    rcWrite "export MANPATH=\"${DN}/man/:\${MANPATH:-}\""
    infoh "Will configure MANPATH...${GREEN}PASSED"
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
infoh "Modifying file permissions...${GREEN}PASSED"
infoh "Finished. Please execute 'builtin exec bash' to restart bash"
