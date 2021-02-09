#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
. "${DN}"/../../lib/libdo
LIBDO_TOP_PID=${$}
mkdir -p autozip_$(date +%Y-%m-%d_%H-%M-%S).t
cd autozip_$(date +%Y-%m-%d_%H-%M-%S).t
LIBDO_LOG_MODE=4
LIBDO_LOG="autozip.log"
DO dd if=/dev/zero of=tf bs=512 count=1
AZ_CMD="autozip tf --force --parallel"
DO "${AZ_CMD}"
DO "${AZ_CMD}" gz
DO "${AZ_CMD}" bgz
DO "${AZ_CMD}" -5 gz
DO "${AZ_CMD}" gz 5
DO "${AZ_CMD}" gz
DO "${AZ_CMD}" xz
DO "${AZ_CMD}" bz2
DO "${AZ_CMD}" lzma
DO "${AZ_CMD}" lz4
DO "${AZ_CMD}" zst
DO "${AZ_CMD}" lzo
DO "${AZ_CMD}" lz
DO "${AZ_CMD}" br
DO "${AZ_CMD}" 7z
DO "${AZ_CMD}" zip
DO "${AZ_CMD}" rar
mkdir -p td
for i in {1..20};do
	DO dd if=/dev/zero of=td/${i} bs=512 count=1
done
AZ_CMD="autozip td --force --parallel"
DO "${AZ_CMD}"
DO "${AZ_CMD}" tar
DO "${AZ_CMD}" tbz
DO "${AZ_CMD}" tar.gz
DO "${AZ_CMD}" tar.xz
DO "${AZ_CMD}" tar.bz2
DO "${AZ_CMD}" tar.lzma
DO "${AZ_CMD}" tar.lz4
DO "${AZ_CMD}" tar.zst
DO "${AZ_CMD}" tar.lzo
DO "${AZ_CMD}" tar.lz
DO "${AZ_CMD}" tar.br
DO "${AZ_CMD}" tar.7z
DO "${AZ_CMD}" tar.zip
DO "${AZ_CMD}" 7z
DO "${AZ_CMD}" zip
DO "${AZ_CMD}" rar
cd ..
rm -rf autozip_$(date +%Y-%m-%d_%H-%M-%S).t
