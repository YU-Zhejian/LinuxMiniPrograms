#!/usr/bin/env bash
#YLSJS_PS v1
# TODO: Implement number of cores used
cat /dev/stdin | grep -v '[[:space:]]*#[[:space:]]*BSUB' | ylsjs init
