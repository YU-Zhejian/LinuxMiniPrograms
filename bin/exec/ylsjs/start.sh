#!/usr/bin/env bash
VERSION=1.4
for opt in "${UKOPT[@]}"; do
    case "${opt}" in
    "-h" | "--help")
        man ylsjs
        builtin exit 0
        ;;
    "-v" | "--version")
        builtin echo "${VERSION}"
        builtin exit 0
        ;;
    *)
        warnh "Option '${opt}' invalid. Ignored"
        ;;
    esac
done

ylsjsd start
