#!/bin/bash
#INSTALLER V1
cd $(dirname ${0})
echo -e "\e[33mYuZJLab Installer V1"
echo -e "Copyright (C) 2019-2020 YU Zhejian"
echo -e "Will override defaults..."
echo -e "Backing up settings...\e[0m"
tmpd=$(mktemp -t -d inst.XXXXXX)
cp -r etc ${tmpd}/
cp -r var ${tmpd}/
tar czf backup.tgz ${tmpd}
rm -fr ${tmpd}
echo -e "\e[33mInstalling config...\e[0m"
cp -fr INSTALLER/etc/* etc/
cp -fr INSTALLER/var/* var/
echo -e "\e[33mModifying \$PATH...\e[0m"
ifpath=$(bin/pls -l | grep ${PWD}/bin | wc -l | cut -d " " -f 1)
if [ ${ifpath} -eq 0 ]; then
    export PATH=${PWD}/bin/:${PATH}
    echo "export PATH=${PWD}/bin/"':${PATH}' >>${HOME}/.bashrc
    echo -e "\e[33m\$PATH modified.\e[0m"
else
    echo -e "\e[33m\$PATH unchanged.\e[0m"
fi
