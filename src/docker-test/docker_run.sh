#!/usr/bin/env bash
git clone https://gitee.com/YuZJLab/LinuxMiniPrograms
builtin cd LinuxMiniPrograms || exit 1
git checkout feature/google
./configure --all
. ~/.bashrc
make -j20
. ~/.bashrc
make test -j20
. ~/.bashrc
exit 0
