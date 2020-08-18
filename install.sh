#!/usr/bin/env bash
# INSTALLER V3P3
set -eu
OLDIFS="${IFS}"
if ！ readlink -f . &>/dev/null;then
	echo -e "\033[31mERROR! NO readlink available.\033[0m"
	exit 1
fi
DN="$(readlink -f "$(dirname "${0}")")"
cd "${DN}"
echo -e "\033[33mYuZJLab Installer"
echo -e "Copyright (C) 2019-2020 YU Zhejian\033[0m"
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
			echo -e "\033[33mVersion 3 Patch 3.\033[0m"
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
			echo -e "\033[31mERROR: Option '${opt}' invalid.\033[0m"
			exit 1
			;;
		esac
	fi
done
# ========Check========
echo -e "\033[33mChecking FileSystem...\033[0m"
${VAR_update_path} && rm 'etc/path.sh' || true
! [ -f 'etc/path.sh' ] && bash INSTALLER/configpath || true
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
	echo -e "\033[33mWellcome to install YuZJLab LinuxMiniPrograms! Before installation, please agree to our License:\033[0m"
	cat LICENSE.md
	read -p "Answer Y/N:>" VAR_Ans
	! [ "${VAR_Ans}" = "Y" ]
	if [ ${ETC} -eq 0 ]; then
		echo -e "\033[33mDo you want to reinstall the config in 'etc'?\033[0m"
		read -p "Answer Y/N:>" VAR_Ans
		[ "${VAR_Ans}" = "Y" ] && VAR_install_config=true || true
	else
		echo -e "\033[33mWill install the config in 'etc'\033[0m"
		VAR_install_config=true
	fi
	if [ ${VAR} -eq 0 ]; then
		echo -e "\033[33mDo you want to clear the history in 'var'?\033[0m"
		read -p "Answer Y/N:>" VAR_Ans
		[ "${VAR_Ans}" = "Y" ] && VAR_clear_history=true
	else
		echo -e "\033[33mWill install history to 'var'\033[0m"
		VAR_clear_history=true
	fi
	echo -e "\033[33mDo you want to install documentations in Groff man, pdf, YuZJLab Usage and HTML? This need command 'asciidoctor' and 'asciidoctor-pdf' (available from Ruby pem) and Python 3.\033[0m"
	read -p "Answer Y/N:>" VAR_Ans
	[ "${VAR_Ans}" = "Y" ] && VAR_install_doc=true
fi
#========Install ETC========
echo -e "\033[33mInstalling...\033[0m"
if ${VAR_install_config}; then
	"${mymkdir}" -p etc
	if [ ${ETC} -eq 1 ]; then
		"${mytar}" czf etc_backup.tgz etc
		"${myrm}" -rf etc/*
		echo -e "\033[33mBacking up settings...\033[32mPASSED\033[0m"
	fi
	"${mycp}" -fr INSTALLER/etc/* etc/
	echo -e "\033[33mInstalling config...\033[32mPASSED\033[0m"
fi
#========Install VAR========
if ${VAR_clear_history}; then
	"${mymkdir}" -p var
	if [ ${VAR} -eq 1 ]; then
		"${mytar}" czf var_backup.tgz var
		"${myrm}" -rf var/*
		echo -e "\033[33mBacking up histories...\033[32mPASSED\033[0m"
	fi
	"${mycp}" -fr INSTALLER/var/* var/
fi
#========Install DOC========
cd INSTALLER/doc
if ! [ ${ADOC} -eq 0 ]; then
	VAR_install_html=false
	VAR_install_man=false
fi
! [ ${ADOC_PDF} -eq 0 ] && VAR_install_pdf=false || true
if ${VAR_install_pdf}; then
	"${mymkdir}" -p ../../pdf
	for fn in *.adoc; do
		asciidoctor-pdf -a allow-uri-read ${fn}
		[ ${?} -eq 0 ] && echo -e "\033[33mCompiling ${fn} in pdf...\033[32mPASSED\033[0m" || echo -e "\033[33mCompiling ${fn} in pdf...\033[31mERROR\033[0m"
	done
	"${myrm}" -f ../../pdf/*
	"${mymv}" *.pdf ../../pdf
fi
if ${VAR_install_html}; then
	"${mymkdir}" -p ../../html
	for fn in *.adoc; do
		asciidoctor -a allow-uri-read ${fn} -b html5
		[ ${?} -eq 0 ] && echo -e "\033[33mCompiling ${fn} in html5...\033[32mPASSED\033[0m" || echo -e "\033[33mCompiling ${fn} in html5...\033[31mERROR\033[0m"
	done
	"${myrm}" -f ../../html/*
	"${mymv}" *.html ../../html
fi
if ${VAR_install_man}; then
	"${mymkdir}" -p ../../man ../../man/man1
	for fn in *.adoc; do
		asciidoctor -a allow-uri-read ${fn} -b manpage
		[ ${?} -eq 0 ] && echo -e "\033[33mCompiling ${fn} in Groff man...\033[32mPASSED\033[0m" || echo -e "\033[33mCompiling ${fn} in Groff man...\033[31mERROR\033[0m"
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
		if [ "$(readlink -f "${item}"||true)" = "$(readlink -f "${DN}/man")" ] ; then
			echo -e "\033[33mMANPATH configured.\033[0m"
			MANCONF=true
			break
		fi
	done
	if ! ${MANCONF}; then
		echo "export MANPATH=\"${DN}/man/\""':${MANPATH}' >>"${HOME}"/.bashrc
		echo -e "\033[33mWill configure MANPATH...\033[32mPASSED\033[0m"
	fi
fi
if ${VAR_install_usage}; then
	${mymkdir} -p ../../doc
	for fn in *.adoc; do
		"${mypython}" ../exec/adoc2usage.py "${fn}"
		[ ${?} -eq 0 ] && echo -e "\033[33mCompiling ${fn} in YuZJLab Usage...\033[32mPASSED\033[0m" || echo -e "\033[33mCompiling ${fn} in YuZJLab Usage...\033[31mERROR\033[0m"
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
	if [ "$(readlink -f "${item}"||true)" = "$(readlink -f "${DN}")" ] ; then
		echo -e "\033[33mPYTHONPATH configured.\033[0m"
		PYCONF=true
		break
	fi
done
if ! ${PYCONF}; then
	echo "export PYTHONPATH=\"${DN}/\""':${PYTHONPATH}' >>"${HOME}"/.bashrc
	echo -e "\033[33mWill configure PYTHONPATH...\033[32mPASSED\033[0m"
fi

INPATH="${PATH:-}"
. "${DN}"/lib/libpath
unset invalid_path duplicated_path
IFS=':'
eachpath=(${valid_path})
IFS=''
PACONF=false
for item in ${eachpath}; do
	if [ "$(readlink -f "${item}"||true)" = "$(readlink -f "${DN}/bin")" ] ; then
		echo -e "\033[33mPATH configured.\033[0m"
		PACONF=true
		break
	fi
done
if ! ${PACONF}; then
	echo "export PATH=\"${DN}/bin/\""':${PATH}' >>"${HOME}"/.bashrc
	echo -e "\033[33mWill configure PATH...\033[32mPASSED\033[0m"
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
echo -e "\033[33mModifying file permissions...\033[0m"
"${mychown}" -R $(id -u) *
"${mychmod}" -R +r+w *
add_dir
"${mychmod}" +x bin/*
"${mychmod}" +x *.sh
IFS="${OLDIFS}"
echo -e "\033[33mFinished. Please execute 'exec bash' to restart bash.\033[0m"
