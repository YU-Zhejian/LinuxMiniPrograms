#!/usr/bin/env bash
VERSION=1.2
set -eu
OLDIFS="${IFS}"
DN="$(readlink -f "$(dirname "${0}")/../../")"
cd "${DN}"
. lib/libstr
. etc/path.conf
#========Install PATH========
if ! which BeforeAdd.sh &>/dev/nulll; then
    echo "export PATH=\"${DN}/opt/lmp_dev/bin/:\${PATH:-}\"" >>"${HOME}"/.bashrc
    infoh "Will configure PATH (lmp_dev)...\033[32mPASSED"
fi
