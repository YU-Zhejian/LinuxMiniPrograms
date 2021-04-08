#!/usr/bin/env bash
set -u +e
cd "$(readlink -f "$(dirname "${0}")")"/../../../
/usr/bin/find . -path './.git' -prune -o -type f -print | grep '\.bak$' | while read fn; do rm -v "${fn}"; done
