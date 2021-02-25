#!/usr/bin/env bash
# AUTOZIP.t.sh v1
#exit 0
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
. "${DN}"/../../lib/libdo
LIBDO_TOP_PID=${$}
TDN="autozip_$(date +%Y-%m-%d_%H-%M-%S).t"
mkdir -p "${TDN}"
cd "${TDN}"
LIBDO_LOG_MODE=4
LIBDO_LOG="autozip.log"
# AUTOZIP WITH FILES
DO dd if=/dev/zero of=tf bs=512 count=1
for ext in gz bgz xz bz2 lzma lz4 zst lzo lz br Z lzfse;do
	DO autozip --force --parallel tf "${ext}" 1
	DO azlist tf."${ext}"
	DO autounzip --force --remove --parallel tf."${ext}"
	DO cat tf \| azcat --parallel - "${ext}" 1 \> tf.azc.${ext}
	DO azlist tf.asc."${ext}"
done
for ext in 7z zip rar;do
	DO autozip --force --parallel tf "${ext}" 1
	DO azlist tf."${ext}"
	DO autounzip --force --remove --parallel tf."${ext}"
done
DO autozip --force --parallel tf
DO cat tf \| azcat --parallel \> tf.azc.ne
DO autozip --force --parallel -1 tf gz
DO cat tf \| azcat --parallel -1 - gz \> tf.azc.${ext}
# AUTOZIP WITH DIRECTORY
mkdir -p td
for i in {1..20};do
	DO dd if=/dev/zero of=td/${i} bs=512 count=1
done
DO autozip td --force --parallel -1
DO azcat --parallel td \> tf.azc.ne
for ext in tar tbz tar.gz tar.xz tar.bz2 tar.lzma tar.lz4 tar.zst tar.lzo tar.lz tar.br tar.7z tar.zip tar.Z tar.lzfse;do
	DO autozip td --force --parallel -1 "${ext}"
	DO azlist tf."${ext}"
	DO autounzip --force --remove --parallel td."${ext}"
	DO azcat --parallel td "${ext}" -1 \> tf.azc.${ext}
	DO azlist tf.asc."${ext}"
done
for ext in 7z zip rar;do
	DO autozip td --force --parallel -1 "${ext}"
	DO azlist tf."${ext}"
	DO autounzip --force --remove --parallel td."${ext}"
done
cd ..
rm -rf "${TDN}"
