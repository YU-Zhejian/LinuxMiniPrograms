#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=b16c
. "${DN}"/00_libtest.sh
sha512sum="sha512sum"
! which sha512sum &>> /dev/null && sha512sum="gsha512sum" # For compatibility under FreeBSD
DO b16c --version
DO cat /bin/ls \| "${sha512sum}" \> ls.512
DO cat /bin/ls \| b16c \| b16c -d \| "${sha512sum}" -c ls.512 &>> /dev/null
DO enigma --version
DO enigma -g
DO cat /bin/ls \| b16c \| enigma -c:1 -s:A \| enigma -c:1 -s:A -d \| b16c -d \| "${sha512sum}" -c ls.512 &>> /dev/null
rm -rf "${TDN}"
