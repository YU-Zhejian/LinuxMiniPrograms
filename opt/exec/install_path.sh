#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.5
set -eu
DN="$(readlink -f "$(dirname "${0}")/../../")"
cd "${DN}"
. lib/libstr
. etc/path.conf
#========Install PATH========
if ! which stage_tools.sh &>/dev/nulll; then
    echo "export PATH=\"${DN}/opt/lmp_dev/bin/:\${PATH:-}\"" >>"${HOME}"/.bashrc
    infoh "Will configure PATH (lmp_dev)...${GREEN}PASSED"
fi
