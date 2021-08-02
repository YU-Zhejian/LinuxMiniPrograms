#!/usr/bin/env bash
builtin set -eu
DN="$(readlink -f "$(dirname "${0}")")"
# shellcheck disable=SC2034
PROGNAME=autozip
. "${DN}"/00_libtest.sh
__DO dd if=/dev/zero of=tf bs=512 count=1
builtin mapfile -t < <(autozip 2>/dev/null | grep '>' | cut -f 1 -d '(' | xargs | tr ' ' '\n')
for ext in gz bgz xz bz2 lzma lz4 zst lzo lz br Z lzfse; do
    builtin echo "${MAPFILE[*]}" | grep '^'"${ext}"'$' &> /dev/null || builtin continue
    __DO autozip --force --parallel tf "${ext}" 1
    [ "${ext}" = "bz2" ] || __DO azlist tf."${ext}"
    __DO autounzip --force --remove --parallel tf."${ext}"
    __DO cat tf \| azcat --parallel - "${ext}" 1 \> tf.azc.${ext}
    [ "${ext}" = "bz2" ] || __DO azlist tf.asc."${ext}"
done
for ext in 7z zip rar; do
    __DO autozip --force --parallel tf "${ext}" 1
    __DO azlist tf."${ext}"
    __DO autounzip --force --remove --parallel tf."${ext}"
done
__DO autozip --force --parallel tf
__DO cat tf \| azcat --parallel \> tf.azc.ne
__DO autozip --force --parallel -1 tf gz
__DO cat tf \| azcat --parallel -1 - gz \> tf.azc.${ext}
# AUTOZIP WITH DIRECTORY
mkdir -p td
for i in {1..20}; do
    __DO dd if=/dev/zero of=td/${i} bs=512 count=1
done
__DO autozip td --force --parallel -1
__DO azcat --parallel td \> tf.azc.ne
for ext in tar tgz; do
    __DO autozip td --force --parallel -1 "${ext}"
    __DO azlist td."${ext}"
    __DO autounzip --force --remove --parallel td."${ext}"
    __DO azcat --parallel td "${ext}" -1 \> td.azc.${ext}
    __DO azlist td.asc."${ext}"
done
for ext in gz xz bz2 lzma lz4 zst lzo lz br 7z zip Z lzfse; do
    builtin echo "${MAPFILE[*]}" | grep '^'"${ext}"'$' &> /dev/null || builtin continue
    ext="tar.${ext}"
    __DO autozip td --force --parallel -1 "${ext}"
    [ "${ext}" = "bz2" ] || __DO azlist td."${ext}"
    __DO autounzip --force --remove --parallel td."${ext}"
    __DO azcat --parallel td "${ext}" -1 \> td.azc."${ext}"
    [ "${ext}" = "bz2" ] || __DO azlist td.asc."${ext}"
done
for ext in 7z zip rar; do
    __DO autozip td --force --parallel -1 "${ext}"
    __DO azlist td."${ext}"
    __DO autounzip --force --remove --parallel td."${ext}"
done

