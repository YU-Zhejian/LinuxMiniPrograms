#!/usr/bin/env bash
# YLMKTBL.sh V3P3
. "${DN}"/../lib/libisopt
. "${DN}"/../lib/libstr
warnh "This program is no longer monitored and updates may not be provided"
STDS=''
for opt in "${@}"; do
	if isopt "${opt}"; then
		case "${opt}" in
		"-h" | "--help")
			yldoc yl_
			exit 0
			;;
		"-v" | "--version")
			echo "Version 3 patch 2 in Bash"
			exit 0
			;;
		*)
			warnh "Option '${opt}' invalid. Ignored"
			;;
		esac
	else
		STDS="${opt}"
	fi
done
[ -f "${STDS}" ] || errh "Table file ${STDS} invalid"

function __GetLongestString_max_str() {
	for item in "${@}"; do
		if [ ${#item} -gt ${mlen} ]; then
			mlen=${#item}
			mitem=${item}
		fi
	done
	return ${mitem}
}
function __GetLongestString() {
	local max_str=''
	for item in "${@}"; do
		! [ ${#item} -gt ${#max_str} ] || max_str=${item}
	done
	echo ${max_str}
}
oldifs=${IFS}
while read line; do
	if ! [[ "${line}" == ^#* ]]; then
		IFS=";"
		curr_col_items=(${line})
		IFS=''
		j=0
		for item in "${curr_col_items[@]}"; do
			row[${j}]="${row[${j}]:-}${item};"
			j=$((${j} + 1))
		done
		unset item curr_col_items j
	else
		row_instruction=(${row_instruction[@]} ${line:1})
	fi
	unset line
done < "${STDS}"
j=0
total_col_len=0
for row_tmp_str in "${row[@]}"; do
	IFS=";"
	row_tmp=(${row_tmp_str})
	unset row_tmp_str
	IFS=''
	row_tmp_len=$(__GetLongestString "${row_tmp[@]}")
	row_len=${#row_tmp_len}
	unset row_tmp_len
	curr_row=''
	if [[ ${row_instruction[${j}]} == ^W* ]]; then #Wrap
		echo "Still Testing"
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
	elif [[ ${row_instruction[${j}]} == ^S* ]]; then #Shrink
		shrink=${row_instruction[${j}]:1}
		shrinked=$(($shrink - 3))
		if [ ${row_len} -gt ${shrink} ]; then row_len=${shrink}; fi
		for item in "${row_tmp[@]}"; do
			! [ ${#item} -gt ${shrink} ] || item="${item:0:$shrinked}..."
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
row_num=${#formatted_row[@]}
IFS=''
for ((j = 0; j <= ${row_num}; j++)); do
	curr_row=${formatted_row[${j}]:-}
	IFS=";"
	curr_row_items=(${curr_row})
	IFS=''
	curr_col_num=0
	for item in "${curr_row_items[@]}"; do
		col[${curr_col_num}]="${col[${curr_col_num}]:-}${item};"
		curr_col_num=$((${curr_col_num} + 1))
	done
done
unset curr_row_items item curr_col_num formatted_row
col_len=$((${row_num} + ${total_col_len}))
SPB=''
for ((i = 0; i <= ${col_len}; i++)); do
	SPB="${SPB}-"
done
unset total_col_len col_len
echo -e "\033[36m${SPB}\033[0m"
for curr_col in "${col[@]}"; do
	IFS=";"
	curr_col_items=(${curr_col})
	IFS=''
	msg="\033[36m|\033[0m"
	for item in "${curr_col_items[@]}"; do
		msg="${msg}${item}\033[36m|\033[0m"
	done
	echo -e "${msg}"
	echo -e "\033[36m${SPB}\033[0m"
done
unset col curr_col msg SPB
IFS=${oldifs}
