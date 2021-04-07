#!/usr/bin/env bash
VERSION=1
# TODO: Implement number of cores used
cat /dev/stdin | grep -v '[[:space:]]*#[[:space:]]*BSUB' | ylsjs init
