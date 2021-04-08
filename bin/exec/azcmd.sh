#!/usr/bin/env bash
VERSION=6.0
# ============ Functions ============
set -eu
DN="$(readlink -f "$(dirname "${0}")/../")"
PAR=""
GCMD=false
DECOMPRESS=false
. "${DN}"/exec/libautozip.sh
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
		cmd=cat
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
		if [ "${mypbz2}" != 'ylukh' ]; then
			cmd="${mypbz2} -cdvf"
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
		cmd="${mylzip} -cdvvf -"
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
		cmd=cat
		;;
	"gz" | "GZ")
		if [ "${mypigz}" != 'ylukh' ]; then
			__cklvl pigz
			cmd="${mypigz} -cvf ${LVL} -p ${THREAD}"
		elif [ "${mygzip}" != 'ylukh' ]; then
			__cklvl gz
			cmd="${PAR} ${mygzip} -cvf ${LVL}"
		elif [ "${my7za}" != 'ylukh' ]; then
			__cklvl 7z
			cmd="${my7za} a -aoa -si stdout -so -y -mmt=${THREAD} ${LVL} -tgzip"
		fi
		;;
	"xz")
		if [ "${myxz}" != 'ylukh' ]; then
			__cklvl xz
			cmd="${myxz} -cvvf --threads=${THREAD} ${LVL} -"
		elif [ "${my7za}" != 'ylukh' ]; then
			__cklvl 7z
			cmd="${my7za} a -aoa -si stdout -so -y -mmt=${THREAD} ${LVL} -txz"
		fi
		;;
	"bz2")
		if [ "${mypbz2}" != 'ylukh' ]; then
			__cklvl bzip2
			cmd="${mypbz2} -cvf -p${THREAD}  ${LVL}"
		elif [ "${mybzip2}" != 'ylukh' ]; then
			__cklvl bzip2
			cmd="${PAR} ${mybzip2} -cvf ${LVL}"
		elif [ "${my7za}" != 'ylukh' ]; then
			__cklvl 7z
			cmd="${my7za} a -aoa -si stdout -so -y -mmt=${THREAD} ${LVL} -tbzip2"
		fi
		;;
	"lzma")
		[ ${THREAD} -gt 1 ] && warnh "${1} do not support parallel. Thread will be resetted to 1"
		if [ "${myxz}" != 'ylukh' ]; then
			__cklvl xz
			cmd="${myxz} -fcvv --format=lzma ${LVL} -"
		elif [ "${mylzma}" != 'ylukh' ]; then
			__cklvl xz
			cmd="${mylzma} -cvf ${LVL} -"
		fi
		;;
	"lz4")
		[ "${mylz4}" != 'ylukh' ] || errh "NO valid lz4 exist"
		__cklvl lz4
		cmd="${PAR} ${mylz4} -cvvf ${LVL} -"
		;;
	"zst")
		[ "${myzstd}" != 'ylukh' ] || errh "NO valid zstd exist"
		__cklvl zst
		cmd="${myzstd} -cvvvf ${LVL} -T${THREAD} -"
		;;
	"lzo")
		[ "${mylzop}" != 'ylukh' ] || errh "NO valid lzop exist"
		__cklvl lzop
		cmd="${PAR} ${mylzop} -cvf ${LVL} -"
		;;
	"br")
		[ "${mybrotli}" != 'ylukh' ] || errh "NO valid brotli exist"
		__cklvl br
		cmd="${mybrotli} -cvf ${LVL} -"
		;;
	"Z" | "z")
		[ "${mycompress}" != 'ylukh' ] || errh "NO valid compress exist"
		__cklvl z
		cmd="${mycompress} -cvf -"
		;;
	"lzfse")
		[ "${mylzfse}" != 'ylukh' ] || errh "NO valid lzfse exist"
		__cklvl lzfse
		cmd="${mylzfse} -encode"
		;;
	"lz")
		[ "${mylzip}" != 'ylukh' ] || errh "NO valid lzip exist"
		__cklvl lzip
		cmd="${mylzip} -cvvf ${LVL} -"
		;;
	"bgz")
		[ "${mybgzip}" != 'ylukh' ] || errh "BGZip NO exist"
		__cklvl bgz
		cmd="${mybgzip} -fc -@ ${THREAD} ${LVL}"
		;;
	# TODO: No implement
	#"7z")
	#	if [ "${my7za}" != 'ylukh' ]; then
	#		__cklvl 7z
	#		cmd="${my7za} a -aoa -y /dev/stdout /dev/stdin -mmt=${THREAD} ${LVL} -t7z"
	#	fi
	#	;;
	"zip")
		# TODO: No implement
		#if [ "${my7za}" != 'ylukh' ]; then
		#	__cklvl 7z
		#	cmd="${my7za} a -aoa -si stdout -so -y -mmt=${THREAD} ${LVL} -tzip"
		if [ "${myzip}" != 'ylukh' ]; then
			__cklvl zip
			cmd="${myzip} --verbose ${LVL}"
		fi
		;;
	# TODO: No implement
	#"rar")
	#	if [ "${myrar}" != 'ylukh' ]; then
	#		__cklvl rar
	#		cmd="${myrar} -mt${THREAD} a /dev/stdout /dev/stdin"
	#	fi
	#	;;
	*)
		exit 1
		;;
	esac
fi
echo "${cmd}"
