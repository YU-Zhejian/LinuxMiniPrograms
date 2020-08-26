#!/usr/bin/env bash
# LIBAUTOZIP V4
. "${DN}"/../lib/libisopt
. "${DN}"/../lib/libstr
. "${DN}"/../etc/path.sh
. "${DN}"/../lib/libman
REMOVE=false
declare -i MAXTHREAD
MAXTHREAD=$(getcorenumber)
ISFORCE=false
THREAD=0
OPT=()
STDS=()
# Check for all components: backend.
function ckavail() {
	local CK_PROG=("${@}")
	local CK_EXT="${1} "
	unset CK_PROG[0]
	for prog_grp in "${CK_PROG[@]}"; do
		CK_PROG_TMP=(${prog_grp})
		evalstr="true"
		for prog in "${CK_PROG_TMP[@]}";do
			evalstr="${evalstr}"'&&[ ${my'${prog}'} != "ylukh" ]'
		done
		if eval "${evalstr}"; then
			printf "${CK_EXT}"
			return 0
		fi
	done
	return 1
}
# Check for all components: frontend.

function autozipck() {
	infoh "Start checking formats..."
	ckavail "tar" tar && TAR=true || TAR=false
	ckavail "gz GZ" gzip pigz && GZ=true || GZ=false
	ckavail "bgz" bgzip && BGZ=true || BGZ=false
	ckavail "bz2" bzip2 && BZ2=true || BZ2=false
	ckavail "xz" xz && XZ=true || XZ=false
	ckavail "lz lzma" xz lzma && LZMA=true || LZMA=false
	ckavail "lz4" lz4 && LZ4=true || LZ4=false
	ckavail "zst" zstd && ZST=true || ZST=false
	ckavail "lzo" lzop && LZO=true || LZO=false
	ckavail "br" brotli && BR=true || BR=false
	ckavail "7z" 7z 7za && Z7=true || Z7=false
	ckavail "rar" "rar unrar" && RAR=true || RAR=false
	ckavail "zip" "zip unzip" && ZIP=true || ZIP=false
	${TAR} && ${GZ} && printf "tar.gz tgz "
	${TAR} && ${BZ2} && printf "tar.bz2 tbz "
	${TAR} && ${XZ} && printf "tar.xz txz "
	${TAR} && ${LZMA} && printf "tar.lzma tar.lz tlz "
	${TAR} && ${LZ4} && printf "tar.lz4 "
	${TAR} && ${ZST} && printf "tar.zst "
	${TAR} && ${LZO} && printf "tar.lzo "
	${TAR} && ${BR} && printf "tar.br "
	infoh "\nCheck complete"
	[ "${myparallel}" != 'ylukh' ] && echo -e "Checking for 'parallel' in ${myparallel}...\033[32mOK\033[33m" || echo -e "Checking for 'parallel' ...\033[31mNO\033[33m"
	infoh "Available core number: ${MAXTHREAD}"
	exit 0
}
#Makt temporaty resources
function mktmp() {
	tempdir="$(mktemp -dt autozip.XXXXXX)"
	tempf="$(mktemp -t autozip.XXXXXX)"
	infoh "TEMP file '${tempf}' and directory '${tempdir}' made"
}
# Check opt
function ppopt() {
	for opt in "${@}"; do
		if isopt "${opt}"; then
			case "${opt}" in
			"-h" | "--help")
				yldoc autozip
				exit 0
				;;
			"-v" | "--version")
				echo "Version 4"
				exit 0
				;;
			"--force")
				warnh "Will remove the archive if exists"
				ISFORCE=true
				;;
			"--remove")
				warnh "Will remove the original file if success"
				REMOVE=true
				;;
			-p\:*)
				THREAD=${opt:3}
				;;
			--parallel\:*)
				THREAD=${opt:10}
				;;
			"-p" | "--parallel")
				THREAD=${MAXTHREAD}
				;;
			"-s" | "--split")
				${ISAUTOZIP} || errh "Option '${opt}' invalid"
				case ${ext} in
				"rar" | "zip" | "7z")
					SPLIT=1024m
					;;
				*)
					SPLIT=1G
					;;
				esac
				;;
			-s\:*)
				${ISAUTOZIP} || errh "Option '${opt}' invalid"
				SPLIT=${opt:3}
				;;
			--split\:*)
				${ISAUTOZIP} || errh "Option '${opt}' invalid"
				SPLIT=${opt:8}
				;;
			*)
				errh "Option '${opt}' invalid"
				;;
			esac
			OPT=("${OPT[@]}" "${opt}")
		else
			STDS=("${STDS[@]}" "${opt}")
		fi
	done
	! ${ISFORCE} && warnh "Will rename the archive if exists"
	if [ ${THREAD} -gt ${MAXTHREAD} ]; then
		warnh "Too many threads. Will be resetted to ${MAXTHREAD}"
		THREAD=${MAXTHREAD}
	fi
}
# Make a number 3 digit
function fixthree() {
	local fout="${1}"
	while [ ${#fout} -lt 3 ]; do
		fout="0${fout}"
	done
	echo ${fout}
}
# Get splitted numbers
function get_splitted_numbers() {
	local file_i=1
	local in_i=001
	while [ -f "${1}".${in_i} ]; do
		file_i=$((${file_i} + 1))
		in_i=$(fixthree ${file_i})
	done
	echo $((${file_i} - 1))
}
# Standard_X heads
function stdx_h() {
	if [ ${THREAD} -gt 0 ]; then
		local file_i=1
		local in_i=001
		infoh "Decompressing splitted archives in a paralleled manner..."
		while [ -f "${fulln}".${in_i} ]; do
			echo "\"${mycat}\" \"${PWD}/${fulln}\".${in_i} | ${*}>>\"${tempdir}\"/${in_i}" >> "${tempdir}"/"${in_i}".sh
			file_i=$((${file_i} + 1))
			in_i=$(fixthree ${file_i})
		done
		"${myfind}" "${tempdir}"/*.sh | "${myparallel}" -j ${THREAD} bash
	else
		local file_total
		file_total=$(get_splitted_numbers "${fulln}")
		local file_i=1
		local in_i=001
		infoh "Decompressing splitted archives..."
		while [ -f "${fulln}".${in_i} ]; do
			infoh "Decompressing ${file_i}/${file_total}..."
			"${mycat}" "${fulln}".${in_i} | ${*} >> "${tempdir}"/${in_i}
			file_i=$((${file_i} + 1))
			in_i=$(fixthree ${file_i})
		done
	fi
}
# standard TAR list/extract head
function stdtle_h() {
	stdx_h "${@}"
	local file_i=1
	local in_i=001
	local file_total
	file_total=$(get_splitted_numbers "${fulln}")
	infoh "Merging from splitted files"
	while [ -f "${fulln}".${in_i} ]; do
		infoh "Merging from ${file_i}/${file_total}..."
		"${mycat}" "${tempdir}"/${in_i} >> "${tempf}"
		file_i=$((${file_i} + 1))
		in_i=$(fixthree ${file_i})
	done
	unset file_i in_1
}
# standard TAR extractor
function stdtx() {
	stdtle_h "${@}"
	infoh "Listing..."
	"${mytar}" -xvf "${tempf}"
}
# standard TAR lister
function stdtl() {
	stdtle_h "${@}"
	infoh "Extracting..."
	"${mytar}" -tvf "${tempf}"
}
# standard FILE extractor
function stdfx() {
	OLD_temp="${tempf}"
	tempf="${fn}"
	stdtle_h "${@}"
	tempf="${OLD_temp}"
}
# Standard_C tails
function stdc_t() {
	local file_total
	file_total=$(get_splitted_numbers "${tempdir}/${fn}")
	local file_i=1
	local in_i=001
	while [ -f "${tempdir}/${fn}".${in_i} ]; do
		infoh "Making archive ${file_i}/${file_total}..."
		"${mycat}" "${tempdir}/${fn}"."${in_i}" | "${@}" > "${fn}".${ext}."${in_i}"
		file_i=$((${file_i} + 1))
		in_i=$(fixthree ${file_i})
	done
}
# standard TAR creator
function stdtc() {
	infoh "TARing and splitting the folder..."
	"${mytar}" -f - -cv "${fn}" | "${mysplit}" -a 3 --numeric-suffixes=001 -b ${SPLIT} - "${tempdir}"/"${fn}".
	infoh "Compressing splitted archive..."
	stdc_t "${@}"
}
# standard FILE creator
function stdfc() {
	infoh "Splitting the file..."
	"${mycat}" "${fn}" | "${mysplit}" -a 3 --numeric-suffixes=001 -b ${SPLIT} - "${tempdir}"/"${fn}".
	infoh "Compressing splitted files..."
	stdc_t "${@}"
}
# Check extension name
function ckext() {
	case "${ext}" in
	"tar" | "tar.gz" | "tgz" | "tar.GZ" | "tar.xz" | "txz" | "tar.bz2" | "tbz" | "tar.lzma" | "tar.lz" | "tlz" | "gz" | "bgz" | "GZ" | "xz" | "bz2" | "lzma" | "lz" | "rar" | "zip" | "7z" | "lz4" | "lzo" | "zst" | "br" | "tar.lz4" | "tar.lzo" | "tar.zst" | "tar.br") ;;
	*)
		errh "Extension name '${ext}' invalid.\nYou can execute 'autozip' without any argument or option to check available method and extension"
		;;
	esac
}
