#!/usr/bin/env bash
# INSTALLER V3P5
set -eu
OLDIFS="${IFS}"
if ! readlink -f . &> /dev/null; then
	echo -e "\033[31mERROR: NO readlink available.\033[0m"
	exit 1
fi
DN="$(readlink -f "$(dirname "${0}")")"
cd "${DN}"
. lib/libisopt
. lib/libstr
infoh "YuZJLab Installer"
infoh "Copyright (C) 2019-2020 YU Zhejian"
# ========Def Var========
VAR_install_config=false
VAR_clear_history=false
VAR_install_man=false
VAR_install_html=false
VAR_install_pdf=false
VAR_install_usage=false
VAR_update_path=true
# ========Read Opt========
for opt in "${@}"; do
	if isopt ${opt}; then
		case ${opt} in
		"-v" | "--version")
			echo "Version 3 Patch 5"
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

	If no opt is given, the 'all' mode will be used.
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
			;;
		"--install-config")
			VAR_install_config=true
			;;
		"--clear-history")
			VAR_clear_history=true
			;;
		"--install-doc")
			VAR_install_man=true
			VAR_install_html=true
			VAR_install_pdf=true
			VAR_install_usage=true
			;;
		"--install-man")
			VAR_install_man=true
			;;
		"--install-html")
			VAR_install_html=true
			;;
		"--install-pdf")
			VAR_install_pdf=true
			;;
		"--install-usage")
			VAR_install_usage=true
			;;
		*)
			warnh "Option '${opt}' invalid. Ignored"
			;;
		esac
	fi
done
# ========Check========
infoh "Checking FileSystem..."
! ${VAR_update_path} || rm -f 'etc/path.sh'
[ -f 'etc/path.sh' ] || bash INSTALLER/configpath
. etc/path.sh
infoh "Installing..."
#========Install ETC========
if ${VAR_install_config}; then
	"${mymkdir}" -p etc
	if [ -d "etc" ]; then
		"${mytar}" czf etc_backup.tgz etc
		"${myrm}" -rf etc/*
		infoh "Backing up settings...\033[32mPASSED"
	fi
	"${mycp}" -fr INSTALLER/etc/* etc/
	infoh "Installing config...\033[32mPASSED"
fi
#========Install VAR========
if ${VAR_clear_history}; then
	"${mymkdir}" -p var
	if [ -d "var" ]; then
		"${mytar}" czf var_backup.tgz var
		"${myrm}" -rf var/*
		infoh "Backing up histories...\033[32mPASSED"
	fi
	"${mycp}" -fr INSTALLER/var/* var/
fi
#========Install C Programs========
bash INSTALLER/C_src/build.sh
#========Install DOC========
cd INSTALLER/doc
. build.sh
cd ../../
#========Install PATH========
INPATH="${PATH:-}"
. "${DN}"/lib/libpath
unset invalid_path duplicated_path
IFS=':'
eachpath=(${valid_path})
IFS=''
PACONF=false
for item in ${eachpath}; do
	if [ "$(readlink -f "${item}" || true)" = "$(readlink -f "${DN}/bin")" ]; then
		infoh "PATH configured"
		PACONF=true
		break
	fi
done
if ! ${PACONF}; then
	echo "export PATH=\"${DN}/bin/\""':${PATH}' >> "${HOME}"/.bashrc
	infoh "Will configure PATH...\033[32mPASSED"
fi
#========Install PYTHONPATH========
if [ "${mypython}" != "ylukh" ];then
	INPATH="${PYTHONPATH:-}"
	. "${DN}"/lib/libpath
	unset invalid_path duplicated_path
	IFS=':'
	eachpath=(${valid_path})
	IFS=''
	PYCONF=false
	for item in ${eachpath}; do
		if [ "$(readlink -f "${item}" || true)" = "$(readlink -f "${DN}")" ]; then
			infoh "PYTHONPATH configured"
			PYCONF=true
			break
		fi
	done
fi
if ! ${PYCONF}; then
	echo "export PYTHONPATH=\"${DN}/\""':${PYTHONPATH}' >> "${HOME}"/.bashrc
	infoh "Will configure PYTHONPATH...\033[32mPASSED"
fi
#========Install MANPATH========
if ${VAR_install_man}; then
	INPATH="${MANPATH:-}"
	. "${DN}"/lib/libpath
	unset invalid_path duplicated_path
	IFS=':'
	eachpath=(${valid_path})
	IFS=''
	MANCONF=false
	for item in ${eachpath}; do
		if [ "$(readlink -f "${item}" || true)" = "$(readlink -f "${DN}/man")" ]; then
			infoh "MANPATH configured"
			MANCONF=true
			break
		fi
	done
fi
if ! ${MANCONF}; then
	echo "export MANPATH=\"${DN}/man/\""':${MANPATH}' >> "${HOME}"/.bashrc
	infoh "Will configure MANPATH...\033[32mPASSED"
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
"${mychown}" -R $(id -u) *
"${mychmod}" -R +r+w *
add_dir
"${mychmod}" +x bin/* *.sh bin/exec/azcmd.sh
infoh "Modifying file permissions...\033[32mPASSED"
IFS="${OLDIFS}"
infoh "Finished. Please execute 'exec bash' to restart bash"
