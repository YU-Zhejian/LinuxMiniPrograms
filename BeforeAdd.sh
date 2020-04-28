#!/bin/bash
# BADD V1P1
dos2unix `/usr/bin/find . -path './.git' -prune -o -type f -print|xargs`