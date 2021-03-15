#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=git-mirror
. "${DN}"/00_libtest.sh
which git &>> /dev/null || exit 0
export GITM_HOME=tmp
DO git-mirror add https://github.com/YuZJLab/SoftInstall https://github.com/YuZJLab/R_CheatSheet
DO git-mirror sync
DO git-mirror ls
DO git-mirror lsbranch
DO git-mirror gc
DO git-mirror rmrepo -f https://github.com/YuZJLab/SoftInstall https://github.com/YuZJLab/R_CheatSheet
DO git-mirror log
rm -rf "${TDN}"
