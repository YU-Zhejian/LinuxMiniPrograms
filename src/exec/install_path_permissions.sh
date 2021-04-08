#!/usr/bin/env bash
VERSION=1.0
set -eu
OLDIFS="${IFS}"
DN="$(readlink -f "$(dirname "${0}")")/../../"
cd "${DN}"
. lib/libstr
. etc/path.conf
#========Install PATH========
if ! which yldoc &> /dev/null || ! which ylsjsd &> /dev/null; then
	echo "export PATH=\"${DN}/bin/:${DN}/sbin/:\${PATH:-}\"" >> "${HOME}"/.bashrc
	infoh "Will configure PATH...\033[32mPASSED"
fi
#========Install PYTHONPATH========
if [ "${mypython}" != "ylukh" ] && ! echo "from LMP_Pylib.libylfile import *" | "${mypython}"; then
	echo "export PYTHONPATH=\"${DN}/libpy/:\${PYTHONPATH:-}\"" >> "${HOME}"/.bashrc
	infoh "Will configure PYTHONPATH...\033[32mPASSED"
fi
#========Install MANPATH========
if [ -e man/man1 ] && ! man yldoc &>> /dev/null ; then
	echo "export MANPATH=\"${DN}/man/:\${MANPATH:-}\"" >> "${HOME}"/.bashrc
	infoh "Will configure MANPATH...\033[32mPASSED"
fi
#========Install Permissions========
function __change_dir_permissions() {
	ls -1 | while read file_name; do
		if [ -f "${file_name}" ]; then
			chmod -x "${file_name}"
		else
			chmod +x "${file_name}"
			cd "${file_name}"
			__change_dir_permissions
			cd ..
		fi
	done
}
chown -R "$(id -u)" *
chmod -R +r+w *
__change_dir_permissions
chmod +x configure bin/* sbin/* bin/exec/*.co* sbin/exec/*.co* *.sh  || true
infoh "Modifying file permissions...\033[32mPASSED"
IFS="${OLDIFS}"
infoh "Finished. Please execute 'exec bash' to restart bash"
