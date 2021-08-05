#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.0
set -eu
builtin cd "$(readlink -f "$(dirname "${0}")/../")" || builtin exit 1
. ../../shlib/libinclude.sh
__include libstr

# Test 'docker' command
docker ps &> /dev/null && EXITV=0 || EXITV=${?}
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


# File pattern, for debian-based and non-debian-based
__change_distro_debian(){
    cat in/"${1}"_minimal.Dockerfile.in \
    in/run.Dockerfile.in | \
    sed "s;__REPLACE_DISTRO__;$(builtin echo "${2}");g" | \
    sed "s;__REPLACE_VERSION__;$(builtin echo "${2}");g" | \
    sed "s;__MIN_PACKAGES__;$(cat etc/${1}.min.packages | tr '\n' ' ');g" | \
    sed "s;__REPLACE_CODENAME__;$(builtin echo "${3}");g" | \
    cat > out/"${1}"_"${2}"_minimal.Dockerfile

    cat in/"${1}"_minimal.Dockerfile.in \
    in/"${1}"_all.Dockerfile.in \
    in/run.Dockerfile.in | \
    sed "s;__REPLACE_DISTRO__;$(builtin echo "${1}");g" | \
    sed "s;__REPLACE_VERSION__;$(builtin echo "${2}");g" | \
    sed "s;__REPLACE_CODENAME__;$(builtin echo "${3}");g" | \
    sed "s;__MIN_PACKAGES__;$(cat etc/${1}.min.packages | tr '\n' ' ');g" | \
    sed "s;__ADD_PACKAGES__;$(cat etc/${1}.add.packages | tr '\n' ' ');g" | \
    cat > out/"${1}"_"${2}"_all.Dockerfile

    cat in/"${1}".sources.list.in | \
    sed "s;__REPLACE_CODENAME__;$(builtin echo "${3}");g" | \
    cat > out/"${1}"_"${2}".sources.list
}

__change_distro(){
    cat in/"${1}"_minimal.Dockerfile.in \
    in/run.Dockerfile.in | \
    sed "s;__REPLACE_DISTRO__;$(builtin echo "${1}");g" | \
    sed "s;__REPLACE_VERSION__;$(builtin echo "${2}");g" | \
    sed "s;__MIN_PACKAGES__;$(cat etc/${1}.min.packages | tr '\n' ' ');g" | \
    cat > out/"${1}"_"${2}"_minimal.Dockerfile
    
    cat in/"${1}"_minimal.Dockerfile.in \
    in/"${1}"_all.Dockerfile.in \
    in/run.Dockerfile.in | \
    sed "s;__REPLACE_DISTRO__;$(builtin echo "${1}");g" | \
    sed "s;__REPLACE_VERSION__;$(builtin echo "${2}");g" | \
    sed "s;__MIN_PACKAGES__;$(cat etc/${1}.min.packages | tr '\n' ' ');g" | \
    sed "s;__ADD_PACKAGES__;$(cat etc/${1}.add.packages | tr '\n' ' ');g" | \
    cat > out/"${1}"_"${2}"_minimal.Dockerfile
}

# Generating Dockerfiles
for distro in ubuntu \
debian
do
    cat etc/"${distro}".csv | grep -v '^#' | while builtin read -r line;do
        builtin mapfile -t CODENAME < <(builtin echo ${line} | tr ',' '\n')
        __change_distro_debian "${distro}" "${CODENAME[0]}" "${CODENAME[1]}"
    done
done

for distro in fedora \
alpine
do
    cat etc/"${distro}".csv | grep -v '^#' | while builtin read -r line;do
        __change_distro "${distro}" "${line}"
    done
done

exit 0
