#!/usr/env/bin bash
set -v -u +e
builtin cd LinuxMiniPrograms || exit 1
./configure --all &> configure.log
# Because install depends on all, so no need to make
make install &> make.log
make test -j20 &> /dev/null
rm -rf .git
mv "${HOME}"/usr/local ./usr/local
exit 0
