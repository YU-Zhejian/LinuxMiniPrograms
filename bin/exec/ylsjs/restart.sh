#!/usr/bin/env bash
VERSION=1.1
for opt in "${UKOPT[@]}"; do
	case "${opt}" in
	"-h" | "--help")
		yldoc ylsjs
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

ylsjsd restart
