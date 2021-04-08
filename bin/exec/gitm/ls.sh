#!/usr/bin/env bash
VERSION=1.0
for opt in "${UKOPT[@]}"; do
	case "${opt}" in
	"-h" | "--help")
		yldoc git-mirror
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

if cat uuidtable.d/*; then
	infoh "Repository ls success"
	echo -e "$(timestamp)\tLS\tSUCCESS" >> act.log
else
	echo -e "$(timestamp)\tLS\tFAILED" >> act.log
fi
