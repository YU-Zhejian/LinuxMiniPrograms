#!/usr/bin/env bash
#LIBDOMAN1.sh V6
fn=${STDI[0]}
if ! [ -f "${fn}" ] || [ -z "${fn}" ]; then
    echo -e "\e[31mERROR: Filename '${fn}' invalid. Use libdoman -h for help.\e[0m"
    exit 1
fi
ln_s=0
ln_e=0
tmps=$(mktemp -t libdo_man.XXXXXX)
cat -n "${fn}" | grep "LIBDO IS GOING TO EXECUTE" >"${tmps}"
while read line; do
    ln=$((${ln} + 1))
    if [ ${ln} -eq ${cmd} ]; then
        ln_s=$(echo $line | cut -f 1 -d " ")
    elif [ ${ln} -gt ${cmd} ]; then
        ln_e=$(($(echo $line | cut -f 1 -d " ") - 1))
        break
    fi
done <"${tmps}"
rm "${tmps}"
if [ ${ln_s} -eq 0 ]; then
    echo -e "\e[31mERROR: ${cmd} too large.\e[0m" >&2
    exit 1
fi
if [ ${ln_e} -eq 0 ]; then ln_e=$(($(wc -l ${fn} | cut -f 1 -d " "))); fi
unset line
tmpprj=$(mktemp -t libdo_man.XXXXXX)
cat ${fn} | tail -n $(($(wc -l ${fn} | cut -f 1 -d " ") - ${ln_s} + 1)) | head -n 2 >"${tmpprj}"
while read line; do
    all_lines=("${all_lines[@]}" "${line}")
done <"${tmpprj}"
CMD=${all_lines[0]:26}
Time_s=$(echo ${all_lines[1]:17} | sed "s/.$//")
unset all_lines
cat ${fn} | head -n ${ln_e} | tail -n 2 >"${tmpprj}"
while read line; do
    all_lines=("${all_lines[@]}" "${line}")
done <"${tmpprj}"
if [ ${#all_lines[@]} -lt 2 ]; then
    Time_e=0
    Exit="-1"
    Time="ERR"
else
    i=0
    line=${all_lines[i]}
    if [[ ${line} =~ "LIBDO STOPPED AT"* ]]; then
        Time_e=$(echo ${line:17} | sed "s/.$//")
        Time=$(${DN}/exec/datediff.sh "${Time_s}" "${Time_e}")
        i=$((${i} + 1))
        line=${all_lines[i]}
    fi
    if [[ ${line} == "LIBDO EXITED SUCCESSFULLY." ]]; then
        i=$((${i} + 1))
        Exit="0"
    elif [[ ${line} =~ "LIBDO FAILED, GOT"* ]]; then
        i=$((${i} + 1))
        Exit=$(echo ${line:21} | sed "s/.$//")
    fi
fi
echo -e "\e[33mJOB_CMD      \e[36m: ${CMD}\e[0m" >&2
echo -e "\e[33mELAPSED_TIME \e[36m: ${Time_s} to ${Time_e}, Total ${Time}\e[0m" >&2
echo -e "\e[33mEXIT_STATUS  \e[36m: ${Exit}\e[0m" >&2
echo -e "\e[33m________________JOB_________OUTPUT________________\e[0m" >&2
tls=$((${ln_s} + 2))
if [ ${ln_e} -le ${tls} ]; then
    echo -e "\e[33mNO_OUTPUT\e[0m"
elif [ ${Exit} = "-1" ]; then
    cat "${fn}" | head -n ${ln_e} | tail -n $((${ln_s} - ${ln_e} + 2)) | ${more}
else
    cat "${fn}" | head -n $((${ln_e} - 2)) | tail -n $((${ln_s} - ${ln_e} + 4)) | ${more}
fi
echo -e "\e[33m________________OUTPUT____FINISHED________________\e[0m" >&2
rm "${tmpprj}"
