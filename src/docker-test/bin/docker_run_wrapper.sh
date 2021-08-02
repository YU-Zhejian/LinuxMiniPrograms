#!/usr/bin/env bash
# A script to handle Docker installation issues.
# Usage: docker_wrapper.sh [FILE].Dockerfile
# shellcheck disable=SC2034
VERSION=1.0
set -eu
builtin cd "$(readlink -f "$(dirname "${0}")/../")" || builtin exit 1
NAME="$(basename -s '.Dockerfile' "${1}")"
TARGET_VERSION="$(cat "out/${NAME}.Dockerfile" | grep '^LABEL version' | cut -f 2 -d '=' | sed 's;";;g')"
. ../../shlib/libinclude.sh
__include libdo
mkdir -p log/
LIBDO_LOG_MODE=4
LIBDO_LOG="log/${NAME}_$(date +%Y-%m-%d_%H-%M-%S).log"

__DO docker build . --file "${1}" --tag "lmp_test_${NAME}:${TARGET_VERSION}" --build-arg tarname="lmp_test_${NAME}"
docker ps -a -f name="lmp_test_${NAME}" | grep "lmp_test_${NAME}" &> /dev/null || docker rm --force "lmp_test_${NAME}"
__DO docker run --name "lmp_test_${NAME}" "lmp_test_${NAME}:${TARGET_VERSION}"
__DO docker cp "lmp_test_${NAME}:/lmp_test_${NAME}.tar" .
__DO autounzip --remove "lmp_test_${NAME}.tar"
__DO docker rm "lmp_test_${NAME}"
