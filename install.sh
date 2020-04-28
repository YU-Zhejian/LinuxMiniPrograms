#!/bin/bash
# INSTALLER V2P3
cd $(dirname ${0})
echo -e "\e[33mYuZJLab Installer V1"
echo -e "Copyright (C) 2019-2020 YU Zhejian\e[0m"

. lib/libisopt && echo -e "\e[33mlibisopt loaded.\e[0m" || {
    echo -e "\e[31mFail to load libisopt.\e[0m"
    exit 1
}

VAR_install_config=false
VAR_clear_history=false
VAR_install_path=false
VAR_add_permission=false
VAR_install_man=false
VAR_install_html=false
VAR_install_pdf=false
VAR_install_usage=false
VAR_interactive=true

for opt in "${@}"; do
    if isopt ${opt}; then
        case ${opt} in
        "-v")
            echo -e "\e[33mVersion 2.\e[0m"
            exit 0
            ;;
        "-h" | "--help")
            echo \
                "This is the installation script of LinuxMiniPrograms.

SYNOPSIS: install.sh [opt]

OPTIONS:
    -h|--help Display this help.
    -v|--version Show version information.
    -a|--all Install all compoments.
    --install-config (Re)Install configuration files in 'etc'.
    --clear-history Clear all previous histories in 'var'.
    --install-path Modify path variable.
    --add-permission Modify permissions of executables.
    --install-doc Install all documentations, need 'asciidoctor' 'asciidoctor-pdf' (available from Ruby's 'pem') and python 3.
    --install-man Install doc in Groff man, need 'asciidoctor'.
    --install-usage Install yldoc usage, need python 3.
    --install-pdf Install doc in pdf, need 'asciidoctor-pdf'.
    --install-html Install doc in html, need 'asciidoctor'.
    "
            exit 0
            ;;
        "-a" | "--all")
            VAR_install_config=true
            VAR_clear_history=true
            VAR_install_path=true
            VAR_add_permission=true
            VAR_install_man=true
            VAR_install_html=true
            VAR_install_pdf=true
            VAR_install_usage=true
            VAR_interactive=false
            ;;
        "--install-config")
            VAR_install_config=true
            VAR_interactive=false
            ;;
        "--clear-history")
            VAR_clear_history=true
            VAR_interactive=false
            ;;
        "--install-path")
            VAR_install_path=true
            VAR_interactive=false
            ;;
        "--add-permission")
            VAR_add_permission=true
            VAR_interactive=false
            ;;
        "--install-doc")
            VAR_install_man=true
            VAR_install_html=true
            VAR_install_pdf=true
            VAR_install_usage=true
            VAR_interactive=false
            ;;
        "--install-man")
            VAR_install_man=true
            VAR_interactive=false
            ;;
        "--install-html")
            VAR_install_html=true
            VAR_interactive=false
            ;;
        "--install-pdf")
            VAR_install_pdf=true
            VAR_interactive=false
            ;;
        "--install-usage")
            VAR_install_usage=true
            VAR_interactive=false
            ;;
        *)
            echo -e "\e[31mERROR: Option '${opt}' invalid.\e[0m"
            exit 1
            ;;
        esac
    else
        STDS="${STDS} ${opt}"
    fi
done
if ${VAR_interactive}; then
    echo -e "\e[33mGenerating config...\e[0m"
    echo -e "\e[33mWellcome to install YuZJLab LinuxMiniPrograms! Before installation, please agree to our License:\e[0m"
    cat LICENSE.md
    read -p "Answer Y/N:>" VAR_Ans
    if ! [ ${VAR_Ans} = "Y" ]; then
        exit 1
    fi
    echo -e "\e[33mDo you want to (Re)install the config in 'etc'?\e[0m"
    read -p "Answer Y/N:>" VAR_Ans
    if [ ${VAR_Ans} = "Y" ]; then
        VAR_install_config=true
    fi
    echo -e "\e[33mDo you want to clear the history in 'var'?\e[0m"
    read -p "Answer Y/N:>" VAR_Ans
    if [ ${VAR_Ans} = "Y" ]; then
        VAR_clear_history=true
    fi
    echo -e "\e[33mDo you want to modify \$PATH variable?\e[0m"
    read -p "Answer Y/N:>" VAR_Ans
    if [ ${VAR_Ans} = "Y" ]; then
        VAR_install_path=true
    fi
    echo -e "\e[33mDo you want to modify permissions of executables?\e[0m"
    read -p "Answer Y/N:>" VAR_Ans
    if [ ${VAR_Ans} = "Y" ]; then
        VAR_add_permission=true
    fi
    echo -e "\e[33mDo you want to install documentations in Groff man, pdf, YuZJLab Usage and HTML? This need command 'asciidoctor' and 'asciidoctor-pdf' (available from Ruby pem) and Python 3.\e[0m"
    read -p "Answer Y/N:>" VAR_Ans
    if [ ${VAR_Ans} = "Y" ]; then
        VAR_install_doc=true
    fi
fi
if ${VAR_install_config}; then
    mkdir -p etc
    echo -e "Backing up settings...\e[0m"
    tar czvf etc_backup.tgz etc
    echo -e "\e[33mInstalling config...\e[0m"
    rm -rf etc/*
    cp -fr INSTALLER/etc/* etc/
fi
bash INSTALLER/configpy
if ${VAR_clear_history}; then
    mkdir -p var
    echo -e "Backing up settings...\e[0m"
    tar czvf var_backup.tgz var
    rm -rf var/*
    cp -fr INSTALLER/var/* var/
fi
if ${VAR_install_path}; then
    echo -e "\e[33mModifying \$PATH...\e[0m"
    if ! [ -e bin/pls ]; then
        echo -e "\e[31mbin/pls not exist!\e[0m"
        exit 1
    fi
    ifpath=$(bash bin/pls -l | grep ${PWD}/bin | wc -l |sed "s/^ *//"| cut -d " " -f 1)
    if [ ${ifpath} -eq 0 ]; then
        echo "export PATH=${PWD}/bin/"':${PATH}' >>${HOME}/.bashrc
        echo -e "\e[33m\$PATH modified.\e[0m"
    else
        echo -e "\e[33m\$PATH unchanged.\e[0m"
    fi
fi
if ${VAR_add_permission}; then
    echo -e "\e[33mModifying file permissions...\e[0m"
    chmod +x bin/*
    chmod +x *.sh
fi
if ${VAR_install_pdf}; then
mkdir -p pdf
cd INSTALLER/doc
echo -e "\e[33mCompiling pdf...\e[0m"
asciidoctor-pdf *.adoc
mv *.pdf ../../pdf
cd ../../
fi
if ${VAR_install_html}; then
    mkdir -p html
    cd INSTALLER/doc
    echo -e "\e[33mCompiling html5...\e[0m"
    asciidoctor *.adoc -b html5
    mv *.html ../../html
    cd ../../
fi
if ${VAR_install_man}; then
    mkdir -p man man/man1
    cd INSTALLER/doc
    echo -e "\e[33mCompiling Groff man...\e[0m"
    asciidoctor *.adoc -b manpage
    mv *.1 ../../man/man1
    cd ../../
    echo "export MANPATH=${PWD}/man/"':${MANPATH}' >>${HOME}/.bashrc
fi
if ${VAR_install_usage}; then
    mkdir -p doc
echo -e "\e[33mCompiling YuZJLab Usage...\e[0m"
    bash adoc2usage
fi

echo -e "\e[33mFinished. Please execute 'exec bash' to restart bash.\e[0m"
