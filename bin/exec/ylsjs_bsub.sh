#!/usr/bin/env bash
#YLSJS_PS v1
# TODO: Implement number of cores used
"${mycat}" /dev/stdin | "${mygrep}" -v '[[:space:]]*#[[:space:]]*BSUB' | ylsjs init
