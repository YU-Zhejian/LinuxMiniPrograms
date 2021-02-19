#!/usr/bin/env bash
set -euo pipefail
echo "YuZJLab Environment Checker version 1.0.0
Copyright 2021 (C) YuZJLab

WARNING: This application have the capacity of collecting sensitive information
on your system! If you use this application to generate a report for
maintenance, please make sure that the commands you're unfamiliar with are
disabled!

Please note that although sensitive information will be collected, it will not be
sent to anyone anywhere. All output generated will be a single file, named
Report_2021-01-04_00-27-09.log or something like that. THIS FILE MAY CONTAIN
SENSITIVE INFORMATION ABOUT YOUR SYSTEM SO USE WITH CARE.

Please note that this script aims at getting computer information with minimal
software. There will be no documentations to this software except this one.

If there are questions, contact an expert.

Usage:

	envgen.sh [OUTPUT]

	Report generated will be saved to [OUTPUT]. If not specified, will save
	to your working directory.

Initiating..."
declare -i LINE_NUMBERS
LINE_NUMBERS=1
[ -n "${1:-}" ] && out_file="${1}" || out_file=Report_"$(date +%Y-%m-%d_%H-%M-%S)".log
tmpsh=$(mktemp -t envgen_XXXXX.sh)
DN="$(readlink -f "$(dirname "${0}")")"

function __exec(){
	if [ "${1:-}" = '#' ];then
		echo "$(date +%Y-%d-%m,%H:%M:%S) \$ ${*}"
	else
		local PF="\033[032mPASS\033[0m"
		printf "${LINE_NUMBERS}/${ALL_LINE_NUMBERS} ${*}..." >&2
		echo "$(date +%Y-%d-%m,%H:%M:%S) \$ ${*}"
		eval ${*} > >(sed 's;^;OO ;')  2> >(sed 's;^;EE ;') | \
		sed 's;^OO EE;EE;' | \
		cat -n || PF="\033[031mFAIL\033[0m"
		echo -e "${PF}" >&2
	fi
	LINE_NUMBERS=$((${LINE_NUMBERS}+1))
}
function __rc_cat() {
	for file in /etc/rc*/*;do echo \# ----------${file}----------;cat ${file} || true;done
}
function __cron_cat() {
	for files in /var/spool/cron/* \
/etc/crontab \
/etc/cron.d/* \
/etc/cron.daily/* \
/etc/cron.hourly/* \
/etc/cron.monthly/* \
/etc/cron.weekly/* \
/etc/anacrontab \
/var/spool/anacron/* ;do echo \# ----------${file}----------;cat ${file} || true;done
}
function __log_cat() {
	find /var/log | grep -v '/$' | while read file;do echo \# ----------${file}----------;cat ${file} || true;done
}

cat << EOF | \
grep -v '^$' | \
sed 's;^#;\\#;' | \
sed 's;^WHERE \(.*\);whereis -b \1\nwhereis -m \1\nwhich \1;' | \
sed 's;^;__exec ;' > "${tmpsh}"
# Program Started.
# Please make comments like this example.
# You need to leave a space before your contents,
# otherwise the software may fail when parsing them.
# You may comment some of the tests if not needed,
# or make other modifications on your purpose.
# MNID=May Not be Installed by Default.
# DD=Disabled by Default.
# ________________________Headers________________________
# I hope you have no difficulties in understanding this command.
# It just prints the working directory you're in.
# If you do not understand concepts like woring directory,
# please search the web.
echo "${PWD}"

# ________________________Operating System Info________________________
uname -a # Kernel information.
# Kernel and login information.
cat /etc/issue
cat /etc/issue.net
cat /etc/motd
cat /etc/redhat-release

# ________________________Boot Info________________________
uptime # How many time since it was booted?
runlevel # On which level the system is operated? See `man runlevel` for more details.
# __rc_cat # Get all startup scripts. DD.
# Get all planed tasks.
crontab -l
__cron_cat
chkconfig --list # Which service is set to bootable? Used under RedHat-derived Linux systems.
service --status-all # List all services. Used under Debian-derived systems.
# TODO: systemctl commands.
# TODO: SELINUX commands.

# ________________________Hardware Info________________________
free -h # How many memory is available?
cat /proc/cpuinfo # Detailed information about CPU.
# NVIDIA driver status. MNID.
# You might need to install "nvidia-smi" package if you install NVIDIA drivers using package management software installed with system.
nvida-smi
# PCI devices. Used to diagnose driver failures. MNID.
lspci -vvk
lspci
lsusb -v # USB devices. Used to diagnose driver failures. MNID.
lsdev # Display information about installed hardware. MNID.
lsscsi # List disk drivers connected. MNID.
hwinfo # General hardware information. MNID.

# ________________________Users and Groups________________________
cat /etc/passwd # Show all users.
cat /etc/group # Show all groups.
who --all # Show all users.
# Who have logged in this system?
w --ip-addr
last --fulltimes  --fullnames
lastlog

# ________________________Partition Info________________________
lsblk # List all partitions & mount points available.
df -h # How many disk space is available?
df -i # Display inode status.
ls -lFh /dev # List all files in /dev. Used to find hard disks, and other pieces of software.
cat /etc/fstab # Automatic-mounting configuration.
# List mounted devices.
mount
cat /proc/mounts

# ________________________Network________________________
# Show internet adapter information.
ifconfig -a # MNID.
iwconfig # MNID.
ip addr # MNID.
# Show ports opened.
nmap -T4 -F localhost # MNID.
# nmap -p 1-65535 -T4 -A -v localhost # Will check all ports. DD.
# nmap -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 --script "default or (discovery and safe)" localhost # Slow and comprehensive check. DD.
netstat -atlp # MNID.
netstat -antlp
# Assess whether it is possible to connect to the internet outside.
# traceroute www.baidu.com # DD. MNID. You may replace it with common addresses.
# traceroute www.google.com # DD.

# ________________________Process Info________________________
# Show all processes.
pstree -ap # With hierarchies. MNID.
top -H -b -n 1 c # With tables. MNID.
ps -AT H all # By default.
# lsof -s # With all files it is using. DD. MNID.

# ________________________System Security________________________
# DD. To show:
# find / -type f -perm -2 -o -perm -20 2\> /dev/null \| xargs ls -al # File with write permission for all users.
# find / -type d -perm -2 -o -perm -20 2\> /dev/null \| xargs ls –ld # Folder with write permission for all users.
# find / -type f -perm -4000 -o -perm -2000 -print 2\> /dev/null \| xargs ls –al # Insecure executables with "s" permission
# find / -user root -perm -2000 -print # File with suid.
# find / -user root -perm -4000 -print # File with sgid.
# find / -nouser -o –nogroup # File with no group or user information.
# The above commands are from 高俊峰 (Junfeng GAO) (2016-03-25 00:29) https://www.cnblogs.com/MYSQLZOUQI/p/5317916.html, accessed 2001-02-19

# ________________________Package Info________________________
# A=All
# I=Installed
# AS=All sources & repositories
# List system package management software in:
# Debian-derived systems.
apt list # A
dpkg --list # I
cat /etc/apt/sources.list /etc/apt/sources.list.d/* # AS

# RedHat-derived sytems.
yum list # A for old systems.
dnf list # A
rpm -qa # TODO
cat /etc/yum.repos.d/*.repo # AS

# Arch-derived systems.
pacman -Sl # A
pacman -Qv # I
cat /etc/pacman.d/mirrorlist.* # AS

# MinGW in Windows.
mingw-get list # TODO

# Scoop in Windows.
scoop list # I
scoop statust # I

# Flatpak in universal GNU/Linux.
flatpak remotes # AS
flatpak history # Show history commands.
flatpak list # I

# Snap in universal GNU/Linux.
# snap list # DD. This command may cause trouble.

# LinuxBrew/HomeBrew  in universal GNU/Linux and macOS.
brew config
brew list # I
brew doctor

# ________________________Shell Environment________________________
# Show what is executed before this script.
declare
env
export
# Settings for whereis.
whereis -l

# ________________________Bourne Again Shell________________________
# WHERE command is a function defined in this code. It uses `whereis` and `which`.
WHERE bash
bash --version
# Check startup scripts of bash.
cat ${HOME}/.bashrc
cat ${HOME}/.bash_history
cat ${HOME}/.bash_logout
cat ${HOME}/.bash_profile
# Check differences in interactive amd non-interactive mode.
echo "exit" \| bash -vi
echo "exit" \| bash -v

# ________________________Bourne shell________________________
# See the aove section for more details.
WHERE sh
cat ${HOME}/.profile

# ________________________C Shell________________________
# See the aove section for more details.
WHERE csh
cat ${HOME}/.cshrc
echo "exit" \| csh -Vi
echo "exit" \| csh -V

# ________________________Z Shell________________________
# See the aove section for more details.
WHERE zsh
cat ${HOME}/.zshrc
zsh --version
echo "exit" \| zsh -vi /dev/stdin
echo "exit" \| zsh -v

# ________________________Friendly Interactive Shell________________________
# See the aove section for more details.
WHERE fish
cat ${HOME}/.zshrc
fish --version

# ________________________Version Control Systems________________________
# Git
WHERE git
git --version
git config --show-origin --show-scope -l

# Mercurial
WHERE hg
hg --version --verbose
hg config

# Subversion
WHERE svn
svn --version --verbose

# Concurrent Versions System
WHERE cvs
cvs --version

# ________________________Python________________________
WHERE python
python --version
echo '' \| python -v

WHERE python3
python3 --version
echo '' \| python3 -v

WHERE python2
python2 --version
echo '' \| python2 -v

WHERE pip
pip --version
pip freeze # I

WHERE pip2
pip2 --version
pip2 freeze

WHERE pip3
pip3 --version
pip3 freeze

WHERE conda
conda --version
conda list # I
conda info --all
cat ${HOME}/.condarc

# TODO: ActiveState Python.

# ________________________Perl________________________
WHERE perl
perl -v
perl -V
perl "${DN}"/exec/list_packages.pl # I
echo -e 'l\\\nq' \| instmodsh # I

WHERE cpan
echo "m" \| cpan # I

WHERE perldoc
perldoc -V

# ________________________R________________________
WHERE R
R --version
Rscript "${DN}"/exec/list_packages.R # See the comments inside for more details.
WHERE Rscript

# ________________________Java________________________
# OpenJDK/Oracle JDK and other interesting JDKs.
WHERE javac
javac --version
WHERE java
java --version
WHERE jshell
jshell --version
WHERE jar
jar --version

# Building systems.
WHERE ant
ant -version
WHERE gradle
gradle --version
WHERE mvn
mvn --version

# ________________________C________________________
# UNIX C Compiler.
WHERE cc
cc --version

# GNU Compiler Collection
WHERE gcc
gcc --version
gcc --verbose
WHERE g++
g++ --version
g++ --verbose
WHERE cpp
cpp --version
echo '' \| cpp --verbose

# Tiny C Compiler.
WHERE tcc
tcc --version
tcc -vv

# LLVM C Compiler.
WHERE clang
clang --version
clang --verbose
WHERE clang++
clang++ --version
clang++ --verbose

# Intel C Compiler.
WHERE icc
icc --version
WHERE ifpc
ifpc --version

# ________________________Rust________________________
WHERE cargo
cargo --version --verbose
cargo --list # Show installed commands, not packages.
WHERE rustc
rustc --version --verbose

# ________________________Ruby________________________
WHERE gem
gem list # I
# gem query -ab # DD. A
# gem search -ab # DD. A
# gem outdated # DD. A
gem environment
WHERE ruby
ruby --version

# ________________________FORTRAN________________________
WHERE gfortran
gfortran --version
echo \| gfortran --verbose
WHERE ifort
ifort --version

# ________________________Text Processor/Editor________________________
WHERE grep
grep --version
WHERE sed
sed --version
WHERE awk
awk --version
WHERE gawk
gawk --version
WHERE ed
ed --version
WHERE nano
nano --version
WHERE vi
vi --version
WHERE vim
vim --version
WHERE gvim
gvim --version
WHERE emacs
emacs --version
WHERE nvim
nvim --version
WHERE code
code --version
WHERE code-insiders
code-insiders --version

# ________________________Help/Documentaton________________________
WHERE man
man -d man
man --version
WHERE apropos
apropos --version
WHERE info
info --version

WHERE asciidoc
asciidoc --version
WHERE asciidoctor
asciidoctor --version
WHERE asciidoctor-pdf
asciidoctor-pdf --version
WHERE pandoc
pandoc --version
pandoc --list-input-formats
pandoc --list-output-formats
pandoc --list-extensions
pandoc --list-highlight-languages
pandoc --list-highlight-styles

WHERE tex
tex --version
WHERE latex
WHERE pdftex
WHERE pdflatex
WHERE luatex
WHERE lualatex
WHERE xetex
WHERE xelatex
WHERE dvipdfmx
WHERE latexmk
WHERE bibtex
WHERE biber
WHERE texdoc
WHERE texdoc-tk

# MikTeX
WHERE miktex-console
WHERE initexmf
initexmf --version
initexmf --list-modes
initexmf --list-formats
mpm --list # A
# mpm --list-repositories  # AS. DD.

# TeXLive amd MacTeX
WHERE tlmgr
tlmgr repository list # AS
tlmgr option showall
tlmgr key list
tlmgr info
tlmgr conf
$ TODO: More tlmgr commands

# ________________________BinUtils and other tools in GNU Toolchain________________________
WHERE pkgconf
pkgconf --version
pkgconf --list-all # I
WHERE pkg-config
pkg-config --version
pkg-config --list-all # I

WHERE ar
ar --version
WHERE ld
ld --version
WHERE make
make --version
WHERE gmake
gmake --version

WHERE automake
automake --version
WHERE autoconf
autoconf --version
WHERE autoreconf
autoreconf --version
WHERE autopoint
autopoint --version
WHERE m4
m4 --version
WHERE libtool
libtool --version

# ________________________GNU CoreUtils________________________
# "dd" for example.
WHERE dd
dd --version

# ________________________Logs________________________
# __log_cat # DD.

# ________________________Archiving Utils________________________
WHERE 7z
WHERE 7za
WHERE bgzip
WHERE brotli
WHERE bzip2
WHERE compress
WHERE gtar
WHERE gzip
WHERE lz4
WHERE lzfse
WHERE lzip
WHERE lzma
WHERE lzop
WHERE pbz2
WHERE pbzip
WHERE pigz
WHERE rar
WHERE tar
WHERE unzip
WHERE unrar
WHERE xz
WHERE zip
WHERE zstd
EOF
ALL_LINE_NUMBERS=$(wc -l "${tmpsh}" | awk '{print $1}')
. "${tmpsh}" > "${out_file}"
# ________________________TOC________________________
printf "Generating TOC..." >&2


echo "# ________________________TOC________________________" > "${out_file}".tmp
cat "${out_file}" -n | grep --text -v 'OO ' | grep --text -v 'EE ' >> "${out_file}".tmp && \
cat "${out_file}".tmp >> "${out_file}" && \
rm "${out_file}".tmp && \
echo -e "\033[032mPASS\033[0m" >&2 || echo -e "\033[031mFAIL\033[0m" >&2

rm -f "${tmpsh}"
echo "Finished." >&2
