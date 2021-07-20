#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.0
set -eu
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
cat etc/ubuntu.csv | grep -v '^#' | while builtin read -r line;do
    builtin mapfile -t CODENAME < <(builtin echo ${line} | tr ',' '\n')
    cat ubuntu_minimal.Dockerfile.in etc/run.Dockerfile.in | \
    sed "s;__REPLACE_VERSION__;$(builtin echo "${CODENAME[0]}");g" | \
    sed "s;__REPLACE_CODENAME__;$(builtin echo "${CODENAME[1]}");g" | \
    sed "s;__MIN_PACKAGES__;$(cat etc/ubuntu.min.packages | tr '\n' ' ');g" > out/ubuntu_"${CODENAME[0]}"_minimal.Dockerfile
    cat ubuntu_minimal.Dockerfile.in ubuntu_all.Dockerfile.in etc/run.Dockerfile.in | \
    sed "s;__REPLACE_VERSION__;$(builtin echo "${CODENAME[0]}");g" | \
    sed "s;__REPLACE_CODENAME__;$(builtin echo "${CODENAME[1]}");g" | \
    sed "s;__MIN_PACKAGES__;$(cat etc/ubuntu.min.packages | tr '\n' ' ');g" | \
    sed "s;__ADD_PACKAGES__;$(cat etc/ubuntu.add.packages | tr '\n' ' ');g" > out/ubuntu_"${CODENAME[0]}"_all.Dockerfile
done
# TODO: echo error in alpine Linux
#cat etc/alpine.csv | grep -v '^#' | while builtin read -r line;do
#    cat alpine_minimal.Dockerfile.in etc/run.Dockerfile.in | \
#    sed "s;__REPLACE_VERSION__;$(builtin echo "${line}");g" | \
#    sed "s;__MIN_PACKAGES__;$(cat etc/alpine.min.packages | tr '\n' ' ');g" > out/alpine_"${line}"_minimal.Dockerfile
#done
cat etc/debian.csv | grep -v '^#' | while builtin read -r line;do
    builtin mapfile -t CODENAME < <(builtin echo ${line} | tr ',' '\n')
    cat debian_minimal.Dockerfile.in etc/run.Dockerfile.in | \
    sed "s;__REPLACE_VERSION__;$(builtin echo "${CODENAME[0]}");g" | \
    sed "s;__REPLACE_CODENAME__;$(builtin echo "${CODENAME[1]}");g" | \
    sed "s;__MIN_PACKAGES__;$(cat etc/debian.min.packages | tr '\n' ' ');g"  > out/debian_"${CODENAME[0]}"_minimal.Dockerfile
done

exit 0
