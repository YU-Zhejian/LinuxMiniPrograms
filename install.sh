#!/usr/bin/env bash
# src V3P5
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
			cat src/doc/installer.txt
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
[ -f 'etc/path.sh' ] || bash src/configpath
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
	"${mycp}" -fr src/etc/* etc/
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
	"${mycp}" -fr src/var/* var/
fi
#========Install C Programs========
bash src/C_src/build.sh
#========Install DOC========
cd src/doc
. build.sh
cd ../../
#========Install PATH========
MANCONF=true
PACONF=false
PYCONF=true
INPATH="${PATH:-}"
. "${DN}"/lib/libpath
unset invalid_path duplicated_path
IFS=':'
eachpath=(${valid_path})
IFS=''
for item in ${eachpath}; do
	if [ "$(readlink -f "${item}" || true)" = "$(readlink -f "${DN}/bin/")" ]; then
		infoh "PATH already configured"
		PACONF=true
		break
	fi
done
if ! ${PACONF}; then
	echo "export PATH=\"${DN}/bin/:${PATH:-}\"" >> "${HOME}"/.bashrc
	infoh "Will configure PATH...\033[32mPASSED"
fi
#========Install PYTHONPATH========
if [ "${mypython}" != "ylukh" ];then
	PYCONF=false
	INPATH="${PYTHONPATH:-}"
	. "${DN}"/lib/libpath
	unset invalid_path duplicated_path
	IFS=':'
	eachpath=(${valid_path})
	IFS=''
	for item in ${eachpath}; do
		if [ "$(readlink -f "${item}" || true)" = "$(readlink -f "${DN}/libpy/")" ]; then
			infoh "PYTHONPATH already configured"
			PYCONF=true
			break
		fi
	done
fi
if ! ${PYCONF}; then
	echo "export PYTHONPATH=\"${DN}/libpy/:${PYTHONPATH:-}\"" >> "${HOME}"/.bashrc
	infoh "Will configure PYTHONPATH...\033[32mPASSED"
fi
#========Install MANPATH========
if ${VAR_install_man}; then
	MANCONF=false
	INPATH="${MANPATH:-}"
	. "${DN}"/lib/libpath
	unset invalid_path duplicated_path
	IFS=':'
	eachpath=(${valid_path})
	IFS=''
	for item in ${eachpath}; do
		if [ "$(readlink -f "${item}" || true)" = "$(readlink -f "${DN}/man")" ]; then
			infoh "MANPATH already configured"
			MANCONF=true
			break
		fi
	done
fi
if ! ${MANCONF}; then
	echo "export MANPATH=\"${DN}/man/:${MANPATH:-}\"" >> "${HOME}"/.bashrc
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
