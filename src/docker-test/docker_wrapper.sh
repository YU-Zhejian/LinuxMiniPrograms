#!/usr/bin/env bash
# A script to handle Docker installation issues.
# Usage: docker_wrapper.sh [FILE].Dockerfile
# shellcheck disable=SC2034
VERSION=1.0
set -ue
builtin cd "$(readlink -f "$(dirname "${0}")")" || builtin exit 1
NAME="$(basename -s '.Dockerfile' "${1}")"
TARGET_VERSION="$(cat ${1} | grep '^LABEL version' | cut -f 2 -d '=' | sed 's;";;g')"
. ../../shlib/libinclude.sh
__include libdo
LIBDO_LOG_MODE=4
LIBDO_LOG="${NAME}_$(date +%Y-%m-%d_%H-%M-%S).log"

if docker images | awk '{print $1;}'| grep "^${NAME}$" &>> /dev/null;then
    docker rmi "${NAME}"
fi
__DO docker build . --file "${1}" --tag "lmp_test_${NAME}:${TARGET_VERSION}"
__DO docker run --rm "lmp_test_${NAME}:${TARGET_VERSION}"
