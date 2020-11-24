#!/usr/bin/env bash
# LIBAUTOZIP V5
. "${DN}"/../lib/libisopt
. "${DN}"/../lib/libstr
. "${DN}"/../etc/path.sh
. "${DN}"/../lib/libman
REMOVE=false
declare -i MAXTHREAD
MAXTHREAD=$(getcorenumber)
ISFORCE=false
THREAD=1
OPT=()
STDS=()
for opt in "${@}"; do
	if isopt "${opt}"; then
		case "${opt}" in
		"-h" | "--help")
			yldoc autozip
			exit 0
			;;
		"-v" | "--version")
			echo "Version 5"
			exit 0
			;;
		esac
		OPT=("${OPT[@]}" "${opt}")
	else
		STDS=("${STDS[@]}" "${opt}")
	fi
done
# Check for all components: backend.
function ckavail() {
	local CK_PROG=("${@}")
	local CK_EXT="${1} "
	local FOUND=false
	local i=1
	unset CK_PROG[0]
	for prog_grp in "${CK_PROG[@]}"; do
		CK_PROG_TMP=(${prog_grp})
		evalstr="true"
		for prog in "${CK_PROG_TMP[@]}"; do
			evalstr="${evalstr}"'&&[ ${my'${prog}'} != "ylukh" ]'
		done
		if eval "${evalstr}"; then
			echo "${CK_EXT}(${i}) --> ${prog_grp}"
			FOUND=true
			i=$((${i} + 1))
		fi
	done
	if ! ${FOUND}; then return 1; fi
}
# Check for all components: frontend.
function autozipck() {
	infoh "Start checking formats..."
	echo "Extension (ORDER) --> Program"
	ckavail "tar" tar && TAR=true || TAR=false
	ckavail "gz GZ" pigz gzip 7za 7z && GZ=true || GZ=false
	ckavail "bgz" bgzip && BGZ=true || BGZ=false
	ckavail "bz2" pbzip2 bzip2 7za 7z && BZ2=true || BZ2=false
	ckavail "xz" xz 7za 7z && XZ=true || XZ=false
	ckavail "lzma" xz lzma && LZMA=true || LZMA=false
	ckavail "lz4" lz4 && LZ4=true || LZ4=false
	ckavail "zst" zstd && ZST=true || ZST=false
	ckavail "lzo" lzop && LZO=true || LZO=false
	ckavail "lz" lzip && LZ=true || LZ=false
	ckavail "br" brotli && BR=true || BR=false
	ckavail "7z" 7za 7z && Z7=true || Z7=false
	ckavail "lzfse" lzfse && LZFSE=true || LZFSE=false
	ckavail "rar" "rar unrar" "7za" "7z" && RAR=true || RAR=false
	ckavail "zip" "zip unzip" && ZIP=true || ZIP=false
	echo "Combined formats:"
	${TAR} && ${GZ} && printf "tar.gz tgz "
	${TAR} && ${BZ2} && printf "tar.bz2 tbz "
	${TAR} && ${XZ} && printf "tar.xz txz "
	${TAR} && ${LZMA} && printf "tar.lzma tar.lz tlz "
	${TAR} && ${LZ4} && printf "tar.lz4 "
	${TAR} && ${ZST} && printf "tar.zst "
	${TAR} && ${LZO} && printf "tar.lzo "
	${TAR} && ${BR} && printf "tar.br "
	${TAR} && ${Z7} && printf "tar.7z "
	${TAR} && ${LZ} && printf "tar.lz "
	${TAR} && ${LZFSE} && printf "tar.lzfse "
	${TAR} && ${ZIP} && printf "tar.zip "
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
# Standard extract heads
function stdx_h() {
	local file_i=1
	local in_i=001
	if [ ${THREAD} -gt 0 ]; then

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
		infoh "Decompressing splitted archives..."
		while [ -f "${fulln}".${in_i} ]; do
			infoh "Decompressing ${file_i}/${file_total}..."
			"${mycat}" "${fulln}".${in_i} | ${*} > "${tempdir}"/${in_i}
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
		"${mycat}" "${tempdir}"/${in_i}
		file_i=$((${file_i} + 1))
		in_i=$(fixthree ${file_i})
	done
	unset file_i in_1
}
# standard TAR extractor
function stdtx() {
	infoh "Listing..."
	stdtle_h "${@}" | "${mytar}" -xv -f -
}
# standard TAR lister
function stdtl() {
	infoh "Extracting..."
	stdtle_h "${@}" | "${mytar}" -tv -f -
}
# standard FILE extractor
function stdfx() {
	OLD_temp="${tempf}"
	tempf="${fn}"
	stdtle_h "${@}"
	tempf="${OLD_temp}"
}
# standard archive creator
function stdac() {
	infoh "Splitting..."
	fcat "${fn}" | "${mysplit}" -a 3 --numeric-suffixes=001 -b ${SPLIT} - "${tempdir}"/"${fn}".
	infoh "Compressing splitted archive..."
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
# Check extension name
function ckext() {
	for name in "gz" "xz" "bz2" "lzma" "GZ" "lz" "zip" "7z" "lz4" "lzo" "zst" "Z" "z" "lzfse"; do
		if [ "${ext}" = "${name}" ] || [ "${ext}" = "tar.${name}" ]; then
			return
		fi
	done
	case "${ext}" in
	"tar" | t[bglx]z | "rar") ;;
	*)
		errh "Extension name '${ext}' invalid.\nYou can execute 'autozip' without any argument or option to check available method and extension"
		;;
	esac
}
# cat file; tar folder
function fcat() {
	if [ -d "${1}" ]; then
		"${mytar}" -f - -cv "${1}"
	elif [ -f "${1}" ]; then
		"${mycat}" "${1}"
	else
		errh "${1} do not exist"
	fi
}
