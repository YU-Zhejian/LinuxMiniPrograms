#!/usr/env/bin bash
set -v +ue
builtin cd LinuxMiniPrograms || exit 1
./configure --all
cat GNUmakefile
make
make install
make test -j20
rm -rf .git
exit 0
