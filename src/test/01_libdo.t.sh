#!/usr/bin/env bash
# AUTOZIP.t.sh v1
#exit 0
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
. "${DN}"/../../lib/libdo
LIBDO_TOP_PID=${$}
TDN="libdo_$(date +%Y-%m-%d_%H-%M-%S).t"
mkdir -p "${TDN}"
cd "${TDN}"
LIBDO_LOG_MODE=4
LIBDO_LOG="libdo.log"
# AUTOZIP WITH FILES
for LIBDO_LOG_MODE in {1..4} S;do
	DO ls -la "${HOME}" &>> /dev/null
done
