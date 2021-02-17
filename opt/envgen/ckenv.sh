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
# ________________________Headers________________________
echo "${PWD}"

# ________________________Operating System Info________________________
uname -a
cat /etc/issue

# ________________________Boot Info________________________
uptime
runlevel
__rc_cat
crontab -l
__cron_cat
chkconfig --list
service --status-all

# ________________________Hardware Info________________________
free -h
cat /proc/cpuinfo
nvida-smi
lspci -vvk
lspci
lsusb -v
lsdev
lsscsi
hwinfo

# ________________________Users and Groups________________________
cat /etc/passwd
cat /etc/group
who --all
w --ip-addr
last --fulltimes  --fullnames
lastlog

# ________________________Partition Info________________________
lsblk
df -h
df -i
ls -lFh /dev
cat /etc/fstab
mount
cat /proc/mounts

# ________________________Network________________________
ifconfig -a
iwconfig
ip addr
nmap -T4 -F localhost
# nmap -p 1-65535 -T4 -A -v localhost # Disabled by default.
# nmap -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 --script "default or (discovery and safe)" localhost # Disabled by default.
netstat -atlp
netstat -antlp
# traceroute www.baidu.com # Disabled by default.
# traceroute www.google.com # Disabled by default.

# ________________________Process Info________________________
pstree -ap
top -H -b -n 1 c
ps -AT H all
# lsof -s # Disabled by default.

# ________________________Package Info________________________
apt list
dpkg --list
cat /etc/apt/sources.list /etc/apt/sources.list.d/*
yum list
dnf list
rpm -qa
cat /etc/yum.repos.d/*.repo
pacman -Sl
pacman -Qv
cat /etc/pacman.d/mirrorlist.*
mingw-get list
scoop list
scoop status
flatpak remotes
flatpak history
flatpak list
# snap list # DIsabled. This command may cause trouble.
brew config
brew list
brew doctor

# ________________________Shell Environment________________________
declare
env
whereis -l

# ________________________Bourne Again Shell________________________
WHERE bash
bash --version
cat ${HOME}/.bashrc
cat ${HOME}/.bash_history
cat ${HOME}/.bash_logout
cat ${HOME}/.bash_profile
echo "exit" \| bash -vi
echo "exit" \| bash -v

# ________________________Bourne shell________________________
WHERE sh
cat ${HOME}/.profile

# ________________________C Shell________________________
WHERE csh
cat ${HOME}/.cshrc
echo "exit" \| csh -Vi
echo "exit" \| csh -V

# ________________________Z Shell________________________
WHERE zsh
cat ${HOME}/.zshrc
zsh --version
echo "exit" \| zsh -vi /dev/stdin
echo "exit" \| zsh -v

# ________________________Friendly Interactive Shell________________________
WHERE fish
cat ${HOME}/.zshrc
fish --version

# ________________________Version Control Systems________________________
WHERE git
git --version
git config --show-origin --show-scope -l
WHERE hg
hg --version --verbose
hg config
WHERE svn
svn --version --verbose
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
pip freeze
WHERE pip2
pip2 --version
pip2 freeze
WHERE pip3
pip3 --version
pip3 freeze

WHERE conda
conda --version
conda list
conda info --all
cat ${HOME}/.condarc

# ________________________Perl________________________
WHERE perl
perl -v
perl -V
perl "${DN}"/exec/list_packages.pl
echo -e 'l\\\nq' \| instmodsh
WHERE cpan
echo "m" \| cpan
WHERE perldoc
perldoc -V

# ________________________R________________________
WHERE R
R --version
Rscript "${DN}"/exec/list_packages.R
WHERE Rscript

# ________________________Java________________________
WHERE javac
javac --version
WHERE java
java --version
WHERE jshell
jshell --version
WHERE jar
jar --version

WHERE ant
ant -version
WHERE gradle
gradle --version
WHERE mvn
mvn --version

# ________________________C________________________
WHERE cc
cc --version

WHERE gcc
gcc --version
gcc --verbose
WHERE g++
g++ --version
g++ --verbose
WHERE cpp
cpp --version
echo '' \| cpp --verbose

WHERE tcc
tcc --version
tcc -vv

WHERE clang
clang --version
clang --verbose
WHERE clang++
clang++ --version
clang++ --verbose

WHERE icc
icc --version
WHERE ifpc
ifpc --version

# ________________________Rust________________________
WHERE cargo
cargo --version --verbose
WHERE rustc
rustc --version --verbose

# ________________________Ruby________________________
WHERE gem
gem list
# gem query -ab # Disabled by default.
# gem search -ab # Disabled by default.
# gem outdated # Disabled by default.
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
WHERE miktex-console
WHERE initexmf
initexmf --version
initexmf --list-modes
initexmf  --list-formats
mpm --list
# mpm --list-repositories  # Disabled by default.
WHERE tlmgr
tlmgr repository list
tlmgr option showall
tlmgr key list
tlmgr info
tlmgr conf

# ________________________BinUtils________________________
WHERE pkgconf
pkgconf --version
pkgconf --list-all
WHERE pkg-config
pkg-config --version
pkg-config --list-all

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

# ________________________GNU CoreUtils________________________
# "dd" for example.
WHERE dd
dd --version

# ________________________Logs________________________
# __log_cat # Disabled by default.

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
