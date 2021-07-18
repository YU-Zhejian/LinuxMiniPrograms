#!/usr/bin/env bash
VERSION=1.3
for opt in "${UKOPT[@]}"; do
    case "${opt}" in
    "-h" | "--help")
        yldoc git-mirror_log
        exit 0
        ;;
    "-v" | "--version")
        echo "${VERSION}"
        exit 0
        ;;
    *)
        warnh "Option '${opt}' invalid. Ignored"
        ;;
    esac
done

if cat act.log; then
    infoh "Repository readlog success"
    echo -e "$(timestamp)\tLOG\tSUCCESS" >>act.log
else
    echo -e "$(timestamp)\tLOG\tFAILED" >>act.log
fi
