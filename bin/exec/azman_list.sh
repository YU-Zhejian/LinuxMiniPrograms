#!/usr/bin/env bash
#AZMAN_LIST V2
USESPLIT=false
unset STDS[0]
[ ${#STDS[@]} -gt 0 ] || errh "Need more than ONE argument."
for fulln in "${STDS[@]}"; do
	fn="$(echo ${fulln%.*} | "${mysed}" "s;.part1;;" | "${mysed}" "s;.part01;;")"
	ext="${fulln##*.}"
	if [ "${fn##*.}" = "tar" ]; then
		ext="tar.${ext}"
		fn="${fn%.*}"
	fi
	if ! [ -f "${fulln}" ] && [ -f "${fulln}.001" ]; then
		USESPLIT=true
	elif ! [ -f "${fulln}" ] && [ -f "$(echo ${fulln} | "${mysed}" "s;.rar;.part01.rar;")" ] && [ ${ext} = "rar" ]; then
		fulln="$(echo ${fulln} | "${mysed}" "s;.rar;.part01.rar;")"
		USESPLIT=true
	elif ! [ -f "${fulln}" ] && [ -f "$(echo ${fulln} | "${mysed}" "s;.rar;.part1.rar;")" ] && [ ${ext} = "rar" ]; then
		fulln="$(echo ${fulln} | "${mysed}" "s;.rar;.part1.rar;")"
		USESPLIT=true
	elif ! [ -f "${fulln}" ]; then
		warnh "Filename '${fulln}' invalid and skipped"
		continue
	fi
	! ${USESPLIT} || mktmp
	ckext
	infoh "Received: ${0} ${STDS[0]} "${fulln}" ${OPT:-} ==>Extension=${ext}"
	# ============ Start ============
	case ${ext} in
	"tar") # ============ tar ============
		[ "${mytar}" != 'ylukh' ] || errh "Tar NO exist"
		if ${USESPLIT}; then
			file_i=1
			in_i=001
			while [ -f "${fulln}".${in_i} ]; do
				"${mycat}" "${fulln}".${in_i} >>"${tempf}"
				file_i=$((${file_i} + 1))
				in_i=$(fixthree ${file_i})
			done
			unset file_i in_1
			"${mytar}" -tvf "${tempf}"
		else
			"${mytar}" -tvf "${fulln}"
		fi
		;;
	"tar.gz" | "tgz" | "tar.GZ") # ============ tgz ============
		[ "${mygzip}" != 'ylukh' ] || errh "GZip NO exist"
		[ "${mytar}" != 'ylukh' ] || errh "Tar NO exist"
		if ${USESPLIT} ;then stdtl "${mygzip} -dk" ; else "${mytar}" -tzvf "${fulln}"; fi
		;;
	"tar.xz" | "txz") # ============ txz ============
		[ "${myxz}" != 'ylukh' ] || errh "XZ Utils NO exist"
		[ "${mytar}" != 'ylukh' ] || errh "Tar NO exist"
		if ${USESPLIT} ;then stdtl "${myxz} -dk" ; else "${mytar}" -tJvf "${fulln}"; fi
		;;
	"tar.bz2" | "tbz") # ============ tbz ============
		[ "${mybzip2}" != 'ylukh' ] || errh "BZip2 NO exist"
		[ "${mytar}" != 'ylukh' ] || errh "Tar NO exist"
		if ${USESPLIT} ;then stdtl "${mybzip2} -dk" ; else "${mytar}" -tjvf "${fulln}"; fi
		;;
	"tar.lzma" | "tar.lz" | "tlz") # ============ tlz ============
		[ "${myxz}" != 'ylukh' ] || errh "XZ Utils NO exist"
		[ "${mytar}" != 'ylukh' ] || errh "Tar NO exist"
		if ${USESPLIT} ;then stdtl "${myxz} -dk --format=lzma" ; else "${myxz}" -dc "${fulln}" | "${mytar}" -tv -f -; fi
		;;
	"gz" | "GZ") # ============ gz ============
		[ "${mygzip}" != 'ylukh' ] || errh "GZip NO exist"
		! ${USESPLIT} || errh "Splitted archive not supported"
		"${mygzip}" -l "${fulln}"
		;;
	"xz") # ============ xz ============
		[ "${myxz}" != 'ylukh' ] || errh "XZ Utils NO exist"
		! ${USESPLIT} || errh "Splitted archive not supported"
		"${myxz}" -l "${fulln}"
		;;
	"bz2") # ============ bz2 ============
		errh "BZip2 do not support this function"
		;;
	"lz" | "lzma") # ============ lz ============
		errh "XZ Utils do not support this function"
		;;
	"7z") # ============ 7z ============
		[ "${my7z}" != 'ylukh' ] || errh "p7zip NO exist"
		if [ ! -f "${fulln}" ] && [ -f "${fulln}.001" ]; then
			fulln="${fulln}.001"
		fi
		"${my7z}" l "${fulln}"
		;;
	"zip") # ============ zip ============
		[ "${myunzip}" != 'ylukh' ] || errh "unzip NO exist"
		if [ -f "${fn}".z01 ]; then
			[ "${myzip}" != 'ylukh' ] || errh "zip NO exist"
			mktmp
			"${mycp}" "${fn}".z* "${tempdir}"/
			"${myzip}" -FF "${tempdir}"/"${fn}".zip --out "${tempdir}"/"${fn}".fzip
			"${myunzip}" -v "${tempdir}"/"${fn}".fzip
		else
			"${myunzip}" -v "${fulln}"
		fi
		;;
	"rar")
		[ "${myunrar}" != 'ylukh' ] || errh "unrar NO exist"
		"${myunrar}" v "${fulln}"
		;;
	esac
done
# ============ Finished ============
infoh "Finished"
exit 0
