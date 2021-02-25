#!/usr/bin/env bash
# LIBAUTOZIP V6
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
	ckavail "bz2" pbz2 bzip2 7za 7z && BZ2=true || BZ2=false
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
# Check extension name
function __ckext() {
	for name in "gz" "xz" "bz2" "lzma" "GZ" "lz" "zip" "7z" "lz4" "lzo" "zst" "Z" "z" "lzfse" "br"; do
		if [ "${ext}" = "${name}" ] || [ "${ext}" = "tar.${name}" ]; then
			return
		fi
	done
	case "${ext}" in
	"tar" | t[bglx]z | "rar" | "bgz") ;;
	*)
		errh "Extension name '${ext}' invalid.\nYou can execute 'autozip' without any argument or option to check available method and extension"
		;;
	esac
}
# cat file; tar folder
function fcat() {
	if [ -d "${1}" ]; then
		"${mytar}" -f - -cv "${1}"
	elif [ -f "${1}" ] || [ "${fn}" = "/dev/stdin" ]; then
		cat "${1}"
	else
		errh "${1} do not exist"
	fi
}
# Check level
function __cklvl() {
	local lvl_able=""
	local lvl_pref="-"
	case "${1}" in
	"tar" | "z" | "Z" | "lzfse")
		lvl_able="0"
		;;
	"xz" | "zip" | "br" | "lzip")
		lvl_able="[0123456789]"
		;;
	"rar")
		lvl_able="[012345]"
		;;
	"7z")
		lvl_pref="-mx="
		lvl_able="[013579]"
		;;
	"lz4")
		lvl_able='(1[012])|[123456789]'
		;;
	"pigz")
		lvl_able='(11)|[0123456789]'
		;;
	"zst")
		lvl_able='(1[01234567899])|[123456789]'
		;;
	"bgz")
		lvl_pref="-l "
		;;
	*)
		lvl_able="[123456789]"
		;;
	esac
	if [ -z "${LVL}" ] ||  echo "${LVL}" | grep -E '${lvl_able}' &> /dev/null ; then
		warnh "Compression level '${LVL}' undefined. You can use ${lvl_able} for ${1} algorithm.\nWill use default value provided by corresponding algorithm"
		LVL=''
	else
		LVL="${lvl_pref}${LVL}"
	fi
	unset lvl_able lvl_pref
	if [ ${THREAD} -gt ${MAXTHREAD} ]; then
		warnh "Too many threads. Will be resetted to ${MAXTHREAD}"
		THREAD=${MAXTHREAD}
	fi
	if [ ${THREAD} -gt 1 ]; then
		case "${1}" in
		"xz" | "zst" | "rar" | "7z" | "bgz" | "pigz" | "pbz2")
			warnh "Will use parallel embedded in the algorithm"
			;;
		"zip" | "tar" | "lzfse" | "z" | "br")
			warnh "${1} do not support parallel. Thread will be resetted to 1"
			THREAD=1
			;;
		*)
			if [ "${myparallel}" = 'ylukh' ]; then
				warnh "No parallel available. Thread will be resetted to 1"
				THREAD=1
			else
				PAR="${myparallel} -j ${THREAD} --pipe --recend '' -k"
			fi
			;;
		esac
	else
		THREAD=1
	fi
}
