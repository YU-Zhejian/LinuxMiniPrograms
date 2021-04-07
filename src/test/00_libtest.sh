#!/usr/bin/env bash
# LIBTEST.sh v1
. "${DN}"/../../lib/libdo
LIBDO_TOP_PID=${$}
TDN="${DN}/${PROGNAME}_$(date +%Y-%m-%d_%H-%M-%S).t"
mkdir -p "${TDN}"
cd "${TDN}"
LIBDO_LOG_MODE=4
LIBDO_LOG="${PROGNAME}.log"

