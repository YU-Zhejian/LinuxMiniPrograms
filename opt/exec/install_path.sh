#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.6
builtin set -eu
DN="$(readlink -f "$(dirname "${0}")/../../")"
builtin cd "${DN}" || exit 1
. ./shlib/libinclude.sh

__include libstr
. etc/path.conf
#========Install PATH========
if ! which stage_tools.sh &>/dev/nulll; then
    builtin echo "export PATH=\"${DN}/opt/lmp_dev/bin/:\${PATH:-}\"" >>"${HOME}"/.bashrc
    infoh "Will configure PATH (lmp_dev)...${GREEN}PASSED"
fi
