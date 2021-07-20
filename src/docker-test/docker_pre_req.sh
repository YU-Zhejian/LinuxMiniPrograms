#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.0
builtin cd "$(readlink -f "$(dirname "${0}")")" || builtin exit 1
. ../../shlib/libinclude.sh
__include libstr

# Test 'docker' command
docker ps &>> /dev/null && EXITV=0 || EXITV=${?}
case ${EXITV} in
    0)
    ;;
    1)
        errh "Got permission declined or Docker daemon is not running. Contact your system administrator for further issues."
        ;;
    127)
        errh "'docker' executable not found in \${PATH}=${PATH}"
        ;;
    *)
        errh "Unknown error no=${EXITV}."
        ;;
esac
unset EXITV

# Generating Dockerfiles
cat codename_ubuntu.csv | grep -v '^#' | while builtin read -r line;do
    builtin mapfile -t CODENAME < <(builtin echo ${line} | tr ',' '\n')
    cat ubuntu_minimal.Dockerfile.in | \
    sed "s;__REPLACE_VERSION__;$(builtin echo "${CODENAME[0]}");g" | \
    sed "s;__REPLACE_CODENAME__;$(builtin echo "${CODENAME[1]}");g" > ubuntu_"${CODENAME[0]}"_minimal.Dockerfile
done
exit 0
