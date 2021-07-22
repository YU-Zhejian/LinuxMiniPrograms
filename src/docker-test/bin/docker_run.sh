#!/usr/env/bin bash
set -v +ue
builtin cd LinuxMiniPrograms || exit 1
./configure --all
cat GNUmakefile
. ~/.zshrc
make
. ~/.zshrc
make test -j20
. ~/.zshrc
rm -rf .git
exit 0
