#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=ylmktbl
. "${DN}"/00_libtest.sh
cat << EOF | ylmktbl /dev/stdin &>> ylmktbl.log
#1
#S90
#1
#1
NO.;COMMAND;EXIT;TIME
1;bwa mem -M -R @RG"tID:case4_techrep_2tSM:case4_techrep_2tLB:WXStPL:Illumina" /gpfsdata/hg38.fa 1.fq 2.fq;0;3:47:51
EOF
