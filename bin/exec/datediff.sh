#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=3.3
if [ -n "${3:-}" ] && [ "${3:-}" != "machine" ]; then
    Start_Sec=${1}
    End_Sec=${2}
elif [[ "$(date --version 2>&1 || true)" == *"GNU"* ]]; then
    Start_Sec=$(date -d "${1}" "+%s")
    End_Sec=$(date -d "${2}" "+%s")
else
    Start_Sec=$(date -j -f "%Y-%m-%d %H:%M:%S" "${1}" "+%s")
    End_Sec=$(date -j -f "%Y-%m-%d %H:%M:%S" "${2}" "+%s")
fi

if [ ${Start_Sec} -ge ${End_Sec} ]; then Diff_Sec=$((${Start_Sec} - ${End_Sec})); else Diff_Sec=$((${End_Sec} - ${Start_Sec})); fi
if [ "${3:-}" = "machine" ]; then
    echo ${Diff_Sec}
else
    Diff_H=$((${Diff_Sec} / 3600))
    Diff_M=$(((${Diff_Sec} - ($Diff_H * 3600)) / 60))
    Diff_S=$((${Diff_Sec} % 60))
    echo "${Diff_H}:${Diff_M}:${Diff_S}"
fi
