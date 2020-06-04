#!/usr/bin/env bash
# INSTALLER V3P1
set -euo pipefail
OLDIFS="${IFS}"
DN=$(readlink -f $(dirname "${0}"))
cd "${DN}"
echo -e "\e[33mYuZJLab Installer"
echo -e "Copyright (C) 2019-2020 YU Zhejian\e[0m"
. lib/libisopt
# ========Def Var========
VAR_install_config=false
VAR_clear_history=false
VAR_install_man=false
VAR_install_html=false
VAR_install_pdf=false
VAR_install_usage=false
VAR_update=false
VAR_interactive=true
VAR_update_path=false
# ========Read Opt========
for opt in "${@}"; do
    if isopt ${opt}; then
        case ${opt} in
        "-v" | "--version")
            echo -e "\e[33mVersion 3.\e[0m"
            exit 0
            ;;
        "-h" | "--help")
            echo \
                "This is the installation script of LinuxMiniPrograms.

SYNOPSIS: bash install.sh [opt]

FOR THE IMPATIENT:
    NEW COMPLETE INSTALLATION: bash install.sh --all

OPTIONS:
    -h|--help Display this help.
    -v|--version Show version information.
    -a|--all Install all compoments.
    --install-config (Re)Install configuration files in 'etc'.
    --clear-history Clear all previous histories in 'var'.
    --install-doc Install all documentations, need 'asciidoctor' 'asciidoctor-pdf' (available from Ruby's 'pem') and python 3.
    --install-man Install doc in Groff man, need 'asciidoctor'.
    --install-usage Install yldoc usage, need python 3.
    --install-pdf Install doc in pdf, need 'asciidoctor-pdf'.
    --install-html Install doc in html, need 'asciidoctor'.
    --update Update an existing installation.
    --update-path Update the etc/path.sh

    If no opt is given, the interactive mode will be used.
    "
            exit 0
            ;;
        "-a" | "--all")
            VAR_install_config=true
            VAR_clear_history=true
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
        "--update")
            VAR_interactive=false
            VAR_update=false
            ;;
        "--update-path")
            VAR_update_path=true
            VAR_interactive=false
            ;;
        *)
            echo -e "\e[31mERROR: Option '${opt}' invalid.\e[0m"
            exit 1
            ;;
        esac
    fi
done
# ========Check========
echo -e "\e[33mChecking FileSystem...\e[0m"
if ${VAR_update_path}; then
    rm 'etc/path.sh'
fi
if ! [ -f 'etc/path.sh' ]; then
    bash INSTALLER/configpath
fi
if ${VAR_update}; then
    ETC=$(
        [ -d "etc" ]
        echo ${?}
    )
    VAR=$(
        [ -d "etc" ]
        echo ${?}
    )
    ADOC=$(
        asciidoctor --help &>>/dev/null
        echo ${?}
    )
    ADOC_PDF=$(
        asciidoctor-pdf --help &>>/dev/null
        echo ${?}
    )
else
    ADOC=0
    ADOC_PDF=0
    ETC=0
    VAR=0
fi
. etc/path.sh
# ========Prompt========
if ${VAR_interactive}; then
    echo -e "\e[33mWellcome to install YuZJLab LinuxMiniPrograms! Before installation, please agree to our License:\e[0m"
    cat LICENSE.md
    read -p "Answer Y/N:>" VAR_Ans
    if ! [ "${VAR_Ans}" = "Y" ]; then
        exit 1
    fi
    if [ ${ETC} -eq 0 ]; then
        echo -e "\e[33mDo you want to reinstall the config in 'etc'?\e[0m"
        read -p "Answer Y/N:>" VAR_Ans
        if [ "${VAR_Ans}" = "Y" ]; then
            VAR_install_config=true
        fi
    else
        echo -e "\e[33mWill install the config in 'etc'\e[0m"
        VAR_install_config=true
    fi
    if [ ${VAR} -eq 0 ]; then
        echo -e "\e[33mDo you want to clear the history in 'var'?\e[0m"
        read -p "Answer Y/N:>" VAR_Ans
        if [ "${VAR_Ans}" = "Y" ]; then
            VAR_clear_history=true
        fi
    else
        echo -e "\e[33mWill install history to 'var'\e[0m"
        VAR_clear_history=true
    fi
    echo -e "\e[33mDo you want to install documentations in Groff man, pdf, YuZJLab Usage and HTML? This need command 'asciidoctor' and 'asciidoctor-pdf' (available from Ruby pem) and Python 3.\e[0m"
    read -p "Answer Y/N:>" VAR_Ans
    if [ "${VAR_Ans}" = "Y" ]; then
        VAR_install_doc=true
    fi
fi
#========Install ETC========
echo -e "\e[33mInstalling...\e[0m"
if ${VAR_install_config}; then
    "${mymkdir}" -p etc
    if [ ${ETC} -eq 1 ]; then
        "${mytar}" czf etc_backup.tgz etc
        "${myrm}" -rf etc/*
        echo -e "\e[33mBacking up settings...\e[32mPASSED\e[0m"
    fi
    "${mycp}" -fr INSTALLER/etc/* etc/
    echo -e "\e[33mInstalling config...\e[32mPASSED\e[0m"
fi
#========Install VAR========
if ${VAR_clear_history}; then
    "${mymkdir}" -p var
    if [ ${VAR} -eq 1 ]; then
        "${mytar}" czf var_backup.tgz var
        "${myrm}" -rf var/*
        echo -e "\e[33mBacking up histories...\e[32mPASSED\e[0m"
    fi
    "${mycp}" -fr INSTALLER/var/* var/
fi
#========Install DOC========
cd INSTALLER/doc
if ! [ ${ADOC} -eq 0 ]; then
    VAR_install_html=false
    VAR_install_man=false
fi
if ! [ ${ADOC_PDF} -eq 0 ]; then
    VAR_install_pdf=false
fi
if ${VAR_install_pdf}; then
    "${mymkdir}" -p ../../pdf
    for fn in *.adoc; do
        asciidoctor-pdf -a allow-uri-read ${fn}
        if [ ${?} -eq 0 ]; then
            echo -e "\e[33mCompiling ${fn} in pdf...\e[32mPASSED\e[0m"
        else
            echo -e "\e[33mCompiling ${fn} in pdf...\e[31mERROR\e[0m"
        fi
    done
    "${myrm}" -f ../../pdf/*
    "${mymv}" *.pdf ../../pdf
fi
if ${VAR_install_html}; then
    "${mymkdir}" -p ../../html
    for fn in *.adoc; do
        asciidoctor -a allow-uri-read ${fn} -b html5
        if [ ${?} -eq 0 ]; then
            echo -e "\e[33mCompiling ${fn} in html5...\e[32mPASSED\e[0m"
        else
            echo -e "\e[33mCompiling ${fn} in html5...\e[31mERROR\e[0m"
        fi
    done
    "${myrm}" -f ../../html/*
    "${mymv}" *.html ../../html
fi
if ${VAR_install_man}; then
    "${mymkdir}" -p ../../man ../../man/man1
    for fn in *.adoc; do
        asciidoctor -a allow-uri-read ${fn} -b manpage
        if [ ${?} -eq 0 ]; then
            echo -e "\e[33mCompiling ${fn} in Groff man...\e[32mPASSED\e[0m"
        else
            echo -e "\e[33mCompiling ${fn} in Groff man...\e[31mERROR\e[0m"
        fi
    done
    "${myrm}" -f ../../man/man1/*
    "${mymv}" *.1 ../../man/man1
    INPATH="${MANPATH:-}"
    . "${DN}"/lib/libpath
    unset invalid_path duplicated_path
    IFS=':'
    eachpath=(${valid_path})
    IFS=''
    MANCONF=false
    for item in ${eachpath}; do
        if [ "${item}" = "${DN}" ]; then
            echo -e "\e[33mMANPATH configured.\e[0m"
            MANCONF=true
            break
        fi
    done
    if ! ${MANCONF}; then
        echo "export MANPATH=\"${DN}/man/\""':${MANPATH}' >>"${HOME}"/.bashrc
        echo -e "\e[33mWill configure MANPATH...\e[32mPASSED\e[0m"
    fi
fi
if ${VAR_install_usage}; then
    ${mymkdir} -p ../../doc
    for fn in *.adoc; do
        bash ../adoc2usage ${fn}
        if [ ${?} -eq 0 ]; then
            echo -e "\e[33mCompiling ${fn} in YuZJLab Usage...\e[32mPASSED\e[0m"
        else
            echo -e "\e[33mCompiling ${fn} in YuZJLab Usage...\e[31mERROR\e[0m"
        fi
    done
    "${myrm}" -f ../../doc/*
    "${mymv}" *.usage ../../doc/
fi
cd ../../
#========Install PATH========
INPATH="${PYTHONPATH:-}"
. "${DN}"/lib/libpath
unset invalid_path duplicated_path
IFS=':'
eachpath=(${valid_path})
IFS=''
PYCONF=false
for item in ${eachpath}; do
    echo $item 
    if [ "${item}" = "${DN}" ]; then
        echo -e "\e[33mPYTHONPATH configured.\e[0m"
        PYCONF=true
        break
    fi
done
if ! ${PYCONF}; then
    echo "export PYTHONPATH=\"${DN}/\""':${PYTHONPATH}' >>"${HOME}"/.bashrc
    echo -e "\e[33mWill configure PYTHONPATH...\e[32mPASSED\e[0m"
fi
#========Install Permissions========
function add_dir() {
    "${myls}" -1 | while read file_name; do
        if [ -f ${file_name} ]; then
            "${mychmod}" -x ${file_name}
        else
            "${mychmod}" +x ${file_name}
            cd ${file_name}
            add_dir
            cd ..
        fi
    done
}
echo -e "\e[33mModifying file permissions...\e[0m"
"${mychown}" -R $(id -u) *
"${mychmod}" -R +r+w *
add_dir
"${mychmod}" +x bin/*
"${mychmod}" +x *.sh
IFS="${OLDIFS}"
echo -e "\e[33mFinished. Please execute 'exec bash' to restart bash.\e[0m"
