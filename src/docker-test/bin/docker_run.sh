#!/usr/env/bin bash
set -v
builtin cd LinuxMiniPrograms || exit 1
./configure --all
cat GNUmakefile
. ~/.zshrc
make
. ~/.zshrc
make test -j20
. ~/.zshrc
exit 0
