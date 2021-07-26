#!/usr/env/bin bash
set -v +ue
builtin cd LinuxMiniPrograms || exit 1
./configure --all
cat GNUmakefile
. ~/.LMP_TEST_NOINTERCTIVErc
make
. ~/.LMP_TEST_NOINTERCTIVErc
make test -j20
. ~/.LMP_TEST_NOINTERCTIVErc
rm -rf .git
exit 0
