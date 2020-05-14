#!/bin/bash
# DATEDIFF v1
Start_Sec=$(date --date="${1}" +%s)
End_Sec=$(date --date="${2}" +%s)
if [ ${Start_Sec} -ge ${End_Sec} ]; then
    Diff_Sec=$((${Start_Sec} - ${End_Sec}))
else
    Diff_Sec=$((${End_Sec} - ${Start_Sec}))
fi
Diff_H=$((${Diff_Sec} / 3600))
Diff_M=$(((${Diff_Sec} - ($Diff_H * 3600)) / 60))
Diff_S=$((${Diff_Sec} % 60))
echo "${Diff_H}:${Diff_M}:${Diff_S}"
