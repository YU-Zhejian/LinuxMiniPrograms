#!/usr/bin/env bash
#LIBDOMAN0.sh V6
more="cat"
echo -e "\e[33mWill use '${more}' as More.\e[0m"
for fn in "${STDI[@]}"; do
    if ! [ -f "${fn}" ] || [ -z "${fn}" ]; then
        echo -e "\e[31mERROR: Filename '${fn}' invalid. Use libdoman -h for help.\e[0m"
        exit 1
    fi
    echo -e "\e[33mLoading ${fn}...0 item proceeded.\e[0m"
    Proj=0
    ffn=$(mktemp -t libdo_man.XXXXXX)
    cat "${fn}" | grep LIBDO >"${ffn}"
    while read line; do
        all_lines=("${all_lines[@]}" "${line}")
    done <"${ffn}"
    i=0
    while [ ${#all_lines[@]} -gt ${i} ]; do
        line=${all_lines[i]}
        i=$((${i} + 1))
        if [[ ${line} =~ "LIBDO IS GOING TO EXECUTE"* ]]; then
            Proj=$((${Proj} + 1))
            echo -e "\e[33mLoading ${fn}...${Proj} item proceeded.\e[0m"
            Proj_CMD[${Proj}]=${line:26}
            line=${all_lines[i]}
            if [[ ${line} =~ "LIBDO STARTED AT"* ]]; then
                Proj_Time_s[${Proj}]=$(echo ${line:17} | sed "s/.$//")
                i=$((${i} + 2)) #Skip PID
                line=${all_lines[i]}
            fi
            if [ ${#all_lines[@]} -eq ${i} ]; then
                Proj_Time_e[${Proj}]=0
                Proj_Exit[${Proj}]="-1"
                Proj_Time[${Proj}]="ERR"
                continue
            fi
            if [[ ${line} =~ "LIBDO STOPPED AT"* ]]; then
                Proj_Time_e[${Proj}]=$(echo ${line:17} | sed "s/.$//")
                Proj_Time[${Proj}]=$(${DN}/exec/datediff.sh "${Proj_Time_s[${Proj}]}" "${Proj_Time_e[${Proj}]}")
                i=$((${i} + 1))
                line=${all_lines[i]}
            elif [[ ${line} =~ "LIBDO IS GOING TO EXECUTE"* ]]; then
                Proj_Time_e[${Proj}]=0
                Proj_Exit[${Proj}]="-1"
                Proj_Time[${Proj}]="ERR"
                continue
            fi
            if [[ ${line} == "LIBDO EXITED SUCCESSFULLY." ]]; then
                i=$((${i} + 1))
                Proj_Exit[${Proj}]="0"
            elif [[ ${line} =~ "LIBDO FAILED, GOT"* ]]; then
                i=$((${i} + 1))
                Proj_Exit[${Proj}]=$(echo ${line:21} | sed "s/.$//")
            fi
        fi
    done
    echo -e "\e[33mFile ${fn} loaded. Making table...\e[0m"
    table=$(mktemp -t libdo_man.XXXXXX)
    echo -e "#1\n#S90\n#1\n#1" >"${table}"
    echo "NO.;COMMAND;EXIT;TIME" >>"${table}"
    for ((i = 1; i <= ${Proj}; i++)); do
        echo "${i};${Proj_CMD[${i}]};${Proj_Exit[${i}]};${Proj_Time[${i}]}" >>"${table}"
    done
    ylmktbl "${table}" | ${more}
    rm "${table}" "${ffn}"
    unset Proj Proj_CMD Proj_Exit Proj_Time_e Proj_Time_s table ffn all_lines
done
