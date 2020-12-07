#!/usr/bin/env bash
# AZCMD V5
# ============ Functions ============
set -eu
DN="$(readlink -f "$(dirname "${0}")/../")"
PAR=""
GCMD=false
DECOMPRESS=false
. "${DN}"/exec/libautozip.sh
# Check level
function cklvl() {
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
	*)
		lvl_able="[123456789]"
		;;
	esac
	if [[ ! "${LVL}" == ${lvl_able} ]]; then
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
		"xz" | "zst" | "rar" | "7z" | "bgz" | "pigz" | "pbzip2")
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
# exec 2>/dev/null
# ============ Start ============
for opt in "${OPT[@]}"; do
	case "${opt}" in
	"-d" | "--decompress")
		DECOMPRESS=true
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
	*)
		warnh "Option '${opt}' invalid. Ignored"
		;;
	esac
done
ext="${STDS[0]:-}"
! [ -z "${ext}" ] || ext="gz"
LVL="${STDS[1]:-}"

if ${DECOMPRESS}; then
	case ${ext} in
	"txt" | "cat" | "tar")
		cmd="${mycat}"
		;;
	"gz" | "GZ" | "bgz")
		if [ "${mypigz}" != 'ylukh' ]; then
			cmd="${mypigz} -cdvf"
		elif [ "${mygzip}" != 'ylukh' ]; then
			cmd="${PAR} ${mygzip} -cdvf"
		elif [ "${my7za}" != 'ylukh' ]; then
			cmd="${my7za} e -aoa -sistdin -so -y -tgzip"
		fi
		;;
	"xz")
		if [ "${myxz}" != 'ylukh' ]; then
			cmd="${myxz} -cdvvf -"
		elif [ "${my7za}" != 'ylukh' ]; then
			cmd="${my7za} e -aoa -sistdin -so -y ${fn} -txz"
		fi
		;;
	"bz2")
		if [ "${mypbzip2}" != 'ylukh' ]; then
			cmd="${mypbzip2} -cdvf"
		elif [ "${mybzip2}" != 'ylukh' ]; then
			cmd="${PAR} ${mybzip2} -cdvf"
		elif [ "${my7za}" != 'ylukh' ]; then
			cmd="${my7za} e -aoa -sistdin -so -y -tbzip2"
		fi
		;;
	"lzma")
		[ ${THREAD} -gt 1 ] && warnh "${1} do not support parallel. Thread will be resetted to 1"
		if [ "${myxz}" != 'ylukh' ]; then
			cmd="${myxz} -cdvvf --format=lzma -"
		elif [ "${mylzma}" != 'ylukh' ]; then
			cmd="${mylzma} -cdvf -"
		fi
		;;
	"lz4")
		[ "${mylz4}" != 'ylukh' ] || errh "NO valid lz4 exist"
		cmd="${PAR} ${mylz4} -cdvvf -"
		;;
	"zst")
		[ "${myzstd}" != 'ylukh' ] || errh "NO valid zstd exist"
		cmd="${myzstd} -cdvvvf -"
		;;
	"lzo")
		[ "${mylzop}" != 'ylukh' ] || errh "NO valid lzop exist"
		cmd="${PAR} ${mylzop} -cdvf -"
		;;
	"br")
		[ "${mybrotli}" != 'ylukh' ] || errh "NO valid brotli exist"
		cmd="${mybrotli} -cdvf -"
		;;
	"Z" | "z")
		[ "${mycompress}" != 'ylukh' ] || errh "NO valid compress exist"
		cmd="${mycompress} -cdvf -"
		;;
	"lzfse")
		[ "${mylzfse}" != 'ylukh' ] || errh "NO valid lzfse exist"
		cmd="${mylzfse} -decode"
		;;
	"lz")
		[ "${mylzip}" != 'ylukh' ] || errh "NO valid lzip exist"
		cmd="${mylzip} -cdvvf ${LVL} -"
		;;
	"7z")
		if [ "${my7za}" != 'ylukh' ]; then
			cmd="${my7za} e -aoa -sistdin -so -y -t7z"
		fi
		;;
	"zip")
		if [ "${my7za}" != 'ylukh' ]; then
			cmd="${my7za} e -aoa -sistdin -so -y -tzip"
		elif [ "${myunzip}" != 'ylukh' ]; then
			cmd="${myunzip} --verbose"
		fi
		;;
	*)
		exit 1
		;;
	esac
else
	case ${ext} in
	"txt" | "tar" | "cat")
		cmd="${mycat}"
		;;
	"gz" | "GZ")
		if [ "${mypigz}" != 'ylukh' ]; then
			cklvl pigz
			cmd="${mypigz} -cvf ${LVL} -p ${THREAD}"
		elif [ "${mygzip}" != 'ylukh' ]; then
			cklvl gz
			cmd="${PAR} ${mygzip} -cvf ${LVL}"
		elif [ "${my7za}" != 'ylukh' ]; then
			cklvl 7z
			cmd="${my7za} a -aoa -si stdout -so -y -mmt=${THREAD} ${LVL} -tgzip"
		fi
		;;
	"xz")
		if [ "${myxz}" != 'ylukh' ]; then
			cklvl xz
			cmd="${myxz} -cvvf --threads=${THREAD} ${LVL} -"
		elif [ "${my7za}" != 'ylukh' ]; then
			cklvl 7z
			cmd="${my7za} a -aoa -si stdout -so -y -mmt=${THREAD} ${LVL} -txz"
		fi
		;;
	"bz2")
		if [ "${mypbzip2}" != 'ylukh' ]; then
			cklvl bzip2
			cmd="${mypbzip2} -cvf -p${THREAD}  ${LVL}"
		elif [ "${mybzip2}" != 'ylukh' ]; then
			cklvl bzip2
			cmd="${PAR} ${mybzip2} -cvf ${LVL}"
		elif [ "${my7za}" != 'ylukh' ]; then
			cklvl 7z
			cmd="${my7za} a -aoa -si stdout -so -y -mmt=${THREAD} ${LVL} -tbzip2"
		fi
		;;
	"lzma")
		[ ${THREAD} -gt 1 ] && warnh "${1} do not support parallel. Thread will be resetted to 1"
		if [ "${myxz}" != 'ylukh' ]; then
			cklvl xz
			cmd="${myxz} -fcvv --format=lzma ${LVL} -"
		elif [ "${mylzma}" != 'ylukh' ]; then
			cklvl xz
			cmd="${mylzma} -cvf ${LVL} -"
		fi
		;;
	"lz4")
		[ "${mylz4}" != 'ylukh' ] || errh "NO valid lz4 exist"
		cklvl lz4
		cmd="${PAR} ${mylz4} -cvvf ${LVL} -"
		;;
	"zst")
		[ "${myzstd}" != 'ylukh' ] || errh "NO valid zstd exist"
		cklvl zst
		cmd="${myzstd} -cvvvf ${LVL} -T${THREAD} -"
		;;
	"lzo")
		[ "${mylzop}" != 'ylukh' ] || errh "NO valid lzop exist"
		cklvl lzop
		cmd="${PAR} ${mylzop} -cvf ${LVL} -"
		;;
	"br")
		[ "${mybrotli}" != 'ylukh' ] || errh "NO valid brotli exist"
		cklvl br
		cmd="${mybrotli} -cvf ${LVL} -"
		;;
	"Z" | "z")
		[ "${mycompress}" != 'ylukh' ] || errh "NO valid compress exist"
		cklvl z
		cmd="${mycompress} -cvf -"
		;;
	"lzfse")
		[ "${mylzfse}" != 'ylukh' ] || errh "NO valid lzfse exist"
		cklvl lzfse
		cmd="${mylzfse} -encode"
		;;
	"lz")
		[ "${mylzip}" != 'ylukh' ] || errh "NO valid lzip exist"
		cklvl lzip
		cmd="${mylzip} -cvvf ${LVL} -"
		;;
	"bgz")
		[ "${mybgzip}" != 'ylukh' ] || errh "BGZip NO exist"
		cklvl bgz
		cmd="${mybgzip} -fc -@ ${THREAD} ${LVL}"
		;;
		#TODO: No implement
		#"7z")
		#	if [ "${my7za}" != 'ylukh' ]; then
		#		cklvl 7z
		#		cmd="${my7za} a -aoa -si stdout -so -y -mmt=${THREAD} ${LVL} -t7z"
		#	fi
		#	;;
	"zip")
		if [ "${my7za}" != 'ylukh' ]; then
			cklvl 7z
			cmd="${my7za} a -aoa -si stdout -so -y -mmt=${THREAD} ${LVL} -tzip"
		elif [ "${myzip}" != 'ylukh' ]; then
			cklvl zip
			cmd="${myzip} --verbose --split-verbose ${LVL}"
		fi
		;;
	*)
		exit 1
		;;
	esac
fi
echo "${cmd}"