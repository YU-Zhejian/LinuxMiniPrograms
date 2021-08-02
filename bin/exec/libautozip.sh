#!/usr/bin/env bash
# VERSION=6.8

. "${DN}"/../etc/linuxminiprograms/path.conf
. "${DN}"/../shlib/libinclude.sh
__include libisopt
__include libstr
__include libman

# shellcheck disable=SC2034
REMOVE=false
builtin declare -i MAXTHREAD
MAXTHREAD=$(get_core_number)
# shellcheck disable=SC2034
ISFORCE=false
THREAD=1
OPT=()
STDS=()
for opt in "${@}"; do
    if isopt "${opt}"; then
        case "${opt}" in
        "-h" | "--help")
            man autozip
            builtin exit 0
            ;;
        "-v" | "--version")
            builtin echo ${VERSION}
            builtin exit 0
            ;;
        "-x")
            builtin set -x
            ;;
        esac
        OPT=("${OPT[@]}" "${opt}")
    else
        STDS=("${STDS[@]}" "${opt}")
    fi
done
# Check for all components: backend.
ckavail() {
    builtin local CK_PROG
    CK_PROG=("${@}")
    builtin local CK_EXT
    CK_EXT="${1} "
    builtin local FOUND
    FOUND=false
    builtin local i
    i=1
    builtin unset "CK_PROG[0]"
    for prog_grp in "${CK_PROG[@]}"; do
        # shellcheck disable=SC2206
        CK_PROG_TMP=(${prog_grp})
        evalstr="true"
        for prog in "${CK_PROG_TMP[@]}"; do
            evalstr="${evalstr}"'&&[ ${my'${prog}'} != "ylukh" ]'
        done
        if eval "${evalstr}"; then # TODO: Why I can't use builtin here?
            builtin echo "${CK_EXT}(${i}) --> ${prog_grp}"
            FOUND=true
            i=$((${i} + 1))
        fi
    done
    if ! ${FOUND}; then builtin return 1; fi
}
# Check for all components: frontend.
autozipck() {
    infoh "Start checking formats..."
    builtin echo "Extension (ORDER) --> Program"
    ckavail "tar" tar && TAR=true || TAR=false
    ckavail "gz GZ" pigz gzip 7za 7z && GZ=true || GZ=false
    # shellcheck disable=SC2034
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
    # shellcheck disable=SC2034
    ckavail "rar" "rar unrar" && RAR=true || RAR=false
    ckavail "zip" "zip unzip" && ZIP=true || ZIP=false
    builtin echo "Combined formats:"
    ${TAR} && ${GZ} && builtin printf "tar.gz tgz "
    ${TAR} && ${BZ2} && builtin printf "tar.bz2 tbz "
    ${TAR} && ${XZ} && builtin printf "tar.xz txz "
    ${TAR} && ${LZMA} && builtin printf "tar.lzma tar.lz tlz "
    ${TAR} && ${LZ4} && builtin printf "tar.lz4 "
    ${TAR} && ${ZST} && builtin printf "tar.zst "
    ${TAR} && ${LZO} && builtin printf "tar.lzo "
    ${TAR} && ${BR} && builtin printf "tar.br "
    ${TAR} && ${Z7} && builtin printf "tar.7z "
    ${TAR} && ${LZ} && builtin printf "tar.lz "
    ${TAR} && ${LZFSE} && builtin printf "tar.lzfse "
    ${TAR} && ${ZIP} && builtin printf "tar.zip "
    infoh "\nCheck complete"
    # shellcheck disable=SC2154
    [ "${myparallel}" != 'ylukh' ] && builtin echo -e "Checking for 'parallel' in ${myparallel}...${ANSI_GREEN}OK${ANSI_YELLOW}" || builtin echo -e "Checking for 'parallel' ...${ANSI_RED}NO${ANSI_YELLOW}"
    infoh "Available core number: ${MAXTHREAD}"
    builtin exit 0
}
# Check extension name
__ckext() {
    for name in "gz" "xz" "bz2" "lzma" "GZ" "lz" "zip" "7z" "lz4" "lzo" "zst" "Z" "z" "lzfse" "br"; do
        # shellcheck disable=SC2154
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
fcat() {
    if [ -d "${1}" ]; then
        # shellcheck disable=SC2154
        "${mytar}" -f - -cv "${1}"
    elif [ -f "${1}" ] || [ "${fn}" = "/dev/stdin" ]; then
        cat "${1}"
    else
        errh "${1} do not exist"
    fi
}
# Check level
__cklvl() {
    builtin local lvl_able
    lvl_able=""
    builtin local lvl_pref
    lvl_pref="-"
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
    if [ -z "${LVL}" ] || builtin echo "${LVL}" | grep -E '${lvl_able}' &>/dev/null; then
        warnh "Compression level '${LVL}' undefined. You can use ${lvl_able} for ${1} algorithm.\nWill use default value provided by corresponding algorithm"
        LVL=''
    else
        LVL="${lvl_pref}${LVL}"
    fi
    builtin unset lvl_able lvl_pref
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
                # shellcheck disable=SC2034
                PAR="${myparallel} -j ${THREAD} --pipe --recend '' -k"
            fi
            ;;
        esac
    else
        THREAD=1
    fi
}
