#!/usr/bin/env bash
# YLMKTNL.sh V3P2

{ . "${DN}"/../lib/libisopt; } && { echo -e "\e[33mlibisopt loaded.\e[0m" >&2; } || {
    echo -e "\e[31mFail to load libisopt.\e[0m" >&2
    exit 1
}
for opt in "${@}"; do
    if isopt ${opt}; then
        case ${opt} in
        "-h" | "--help")
            yldoc ylmktbl
            exit 0
            ;;
        "-v" | "--version")
            echo "Version 3 patch 2 in Bash"
            exit 0
            ;;
        *)
            echo -e "\e[31mERROR: Option '${opt}' invalid.\e[0m"
            exit 1
            ;;
        esac
    else
        STDS="${opt}"
    fi
done
mypy=$(cat "${DN}"/../etc/python.conf)
if ! [ -f "${STDS}" ]; then
    echo -e "\e[31mERROR: Table file ${STDS} invalid.\e[0m"
    exit 1
fi
function mktbl_GetLongestString_max_str() {
    for item in "${@}"; do
        if [ ${#item} -gt ${mlen} ]; then
            mlen=${#item}
            mitem=${item}
        fi
    done
    return ${mitem}
}
function mktbl_GetLongestString() {
    for item in "${@}"; do
        if [ ${#item} -gt ${#mktbl_GetLongestString_max_str} ]; then
            mktbl_GetLongestString_max_str=${item}
        fi
    done
    echo ${mktbl_GetLongestString_max_str}
}
oldifs=${IFS}
while read line; do
    if ! [[ "${line}" =~ ^#.* ]]; then
        IFS=";"
        curr_col_items=(${line})
        IFS=''
        j=0
        for item in "${curr_col_items[@]}"; do
            row[${j}]="${row[${j}]}$item;"
            j=$((${j} + 1))
        done
        unset item curr_col_items j
    else
        row_instruction=(${row_instruction[@]} ${line:1})
    fi
    unset line
done <"${STDS}"
for row_tmp_str in "${row[@]}"; do
    IFS=";"
    row_tmp=(${row_tmp_str})
    unset row_tmp_str
    IFS=''
    row_tmp_len=$(mktbl_GetLongestString "${row_tmp[@]}")
    row_len=${#row_tmp_len}
    unset row_tmp_len
    curr_row=''
    if [[ ${row_instruction[${j}]} =~ ^W.* ]]; then #Wrap
        echo "Still Testing."
        exit
        wrap=${row_instruction[${j}]:1}
        wrap_s=0
        wrap_e=${wrap}
        nit=""
        if [ $row_len -gt ${wrap} ]; then row_len=${wrap}; fi
        for item in "${row_tmp[@]}"; do
            while [ ${wrap_e} -lt ${#item} ]; do
                nit="${item:${wrap_s}:${wrap}}\n"
                wrap_s=$((${wrap_s} + ${wrap}))
                wrap_e=$((${wrap_e} + ${wrap}))
                formatted_item=${formatted_item}${nit}
            done
            while [ ${#formatted_item} -lt ${row_len} ]; do
                formatted_item="${formatted_item}_"
            done
            formatted_item="${formatted_item}\n${item:$wrap_s}"
            curr_row="${curr_row}${formatted_item};"
        done
        unset formatted_item wrap_s wrap wrap_e nit row_tmp item
    elif [[ ${row_instruction[${j}]} =~ ^S.* ]]; then #Shrink
        shrink=${row_instruction[${j}]:1}
        shrinked=$(($shrink - 3))
        if [ ${row_len} -gt ${shrink} ]; then row_len=${shrink}; fi
        for item in "${row_tmp[@]}"; do
            if [ ${#item} -gt ${shrink} ]; then
                item="${item:0:$shrinked}..."
            fi
            while [ ${#item} -lt ${row_len} ]; do
                item=${item}' '
            done
            curr_row="${curr_row}${item};"
        done
        unset shrink shrinked row_tmp item
    else #Unshrinkable
        for item in "${row_tmp[@]}"; do
            while [ ${#item} -lt ${row_len} ]; do
                item="${item} "
            done
            curr_row="${curr_row}${item};"
        done
        unset item row_tmp
    fi
    formatted_row=(${formatted_row[@]} ${curr_row})
    unset curr_row
    j=$((${j} + 1))
    total_col_len=$((${total_col_len} + ${row_len}))
done
unset row row_len
IFS=";"
col_num_tmp=(${formatted_row[0]})
col_num=${#row_num_tmp[@]}
row_num=${#formatted_row[@]}
IFS=''
unset col_num_tmp
for ((j = 0; j <= ${row_num}; j++)); do
    curr_row=${formatted_row[${j}]}
    IFS=";"
    curr_row_items=(${curr_row})
    IFS=''
    curr_col_num=0
    for item in "${curr_row_items[@]}"; do
        col[${curr_col_num}]="${col[${curr_col_num}]}$item;"
        curr_col_num=$((${curr_col_num} + 1))
    done
done
unset curr_row_items item curr_col_num formatted_row
col_len=$((${row_num} + ${total_col_len}))
SPB=''
for ((i = 0; i <= ${col_len}; i++)); do
    SPB="${SPB}-"
done
unset col_num total_col_len col_len
echo -e "\e[36m${SPB}\e[0m"
for curr_col in "${col[@]}"; do
    IFS=";"
    curr_col_items=(${curr_col})
    IFS=''
    msg="\e[36m|\e[0m"
    for item in "${curr_col_items[@]}"; do
        msg="${msg}${item}\e[36m|\e[0m"
    done
    echo -e ${msg}
    echo -e "\e[36m${SPB}\e[0m"
done
unset col curr_col msg SPB oldifs
IFS=${oldifs}
