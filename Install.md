# How to Install YuZJLab LinuxMiniPrograms

## Definitions

* "Package management systems" or "package manager" refers to software such as "Advanced Packaging Tool\*", "Yellowdog Updater Modified\*\*" "Dandified YUM\*\*\*", "Pacman\*\*\*\*" or "LinuxBrew\*\*\*\*\*" under various of GNU/Linux operating systems, "Cygwin installer" in Cygwin, "HomeBrew" under macOS (Available from <https://brew.sh/>) or  `pkg`/`ports` systems under FreeBSD. These pieces of software are designed to install, update or remove packages on the fly. You may not use them to install LinuxMiniPrograms now. However, you may use them to install the dependencies required for utilizing LinuxMiniPrograms.

	\*: "APT" for short, provided in Debian-derived systems like Ubuntu GNU/Linux, Deepin Linux, Kali Linux, or Linux Mint by default.
	
	\*\*: "YUM" for short, provided in Red Hat-derived systems like Red Hat Enterprise Linux (RHEL), Community ENTerprise Operating System (CentOS), Fedora Linux, or Red Flag Linux by default.
	
	\*\*\*: "DNF" for short, updated version of YUM.
	
	\*\*\*\*: Provided in Arch-derived systems like Manjaro.
	
	\*\*\*\*\*: LinuxBrew is Homebrew under GNU/Linux.
	
	Most package management systems require root privilege. They can only be operated under root account/with root permission. If you are working in a shared cluster, please contact your system administrator for more details. If you do not have access to root privilege, you may install LinuxBrew or Anaconda.
	
	Other specific-purposed package management systems like Anaconda\*, pip3\*\*, and Ruby gems\*\* might be useful.
	
	\*: For Python libraries and others, available from <https://www.anaconda.com>.
	
	\*\*: For Python libraries and others, should be with your Python distribution by default, available from <https://pip.pypa.io/en/stable/installing/>.
	
	\*\*: For Ruby libraries (Called "gems" in their language), should be with your Ruby distribution by default.

## Installation

**PLEASE READ THE *DEPENDENCIES* SECTION WITH EXTRA CARE.**

### Dependencies

All the program relies on Bourne Again SHell (Bash) >= 4.4.12(3). You may observe this by typing `bash --version` in a terminal. For macOS users, please update the default Bash installation by HomeBrew. For users using CentOS, Debian stable or other "stable" distributions with an older version Bash, please upgrade it by compiling the source code (<https://ftp.gnu.org/gnu/bash/>). Bash is not installed in FreeBSD\* or macOS\*\* by default.

\*: As long as I am concerned, it's C SHell (csh).

\*\*: As long as I am concerned, it's Z SHell (zsh). Zsh is 100% compatible with Bash, but you still need to install Bash to execute LinuxMiniPrograms.

For most programs written in Shell, the following programs will be needed and GNU version would be better:

* GNU CoreUtils>=8.22 available from <https://ftp.gnu.org/gnu/coreutils/>, including:

	* `[`
	* `cat`
	* `chmod`
	* `chown`
	* `cp`
	* `cut`
	* `date`
	* `head`
	* `kill`
	* `ls`
	* `mkdir`
	* `readlink` (Mandatory)
	* `rm`
	* `sleep`
	* `sort`
	* `tail`
	* `tr`
	* `wc`
	* `uniq`

	It is mandatory for BSD or macOS to install readlink. It can be installed by compiling the source code (BSD) or HomeBrew (macOS). You **MUST** make sure that a GNU version of `readlink` or `greadlink` is reachable in your `${PATH}`.

* Other essential GNU utils may include:

	* GNU grep>=2.20 available from <https://ftp.gnu.org/gnu/sed/>. Those installed in FreeBSD>=12.1 will also work.
	* GNU sed>=4.4 available from <https://ftp.gnu.org/gnu/sed/>. Those installed in FreeBSD>=12.1 will also work.
	* GNU parallel>=20200122`available from <https://ftp.gnu.org/gnu/parallel/>.
	* procps-ng (ps)>= version 3.3.10 available from <https://sourceforge.net/projects/procps-ng/> or ps (Cygwin) 3.1.4. Those installed in FreeBSD>=12.1 will also work. Please note that you should **NOT** try to compile programs requiring GNU LibC (glibc) in Cygwin like procps-ng, top ot htop.
	* GNU make>=4.3 (named "gmake" under FreeBSD) available from <https://www.gnu.org/software/make/>. Those installed in FreeBSD>=12.1 will ***NOT*** work.

* Some programs such as `libmktbl` have their Python version (Need Python>=3.5), which is typically faster than those written in Shell script. There are also programs written purely in Python, like `libdo-monitor`. During the configuring process of LinuxMiniPrograms, the installer will search for all Python 3 interpreters inside your `${PATH}` variable and locate the newest Python interpreter as the default Python interpreter of the LinuxMiniPrograms. However, you can modify this by editing `etc/path.conf` to specific your own Python interpreter.

* Some programs such as `pst` have its C version, which is faster than those written in Python. You may need to install GNU Compiler Collection (gcc)>=10.2.1-1 (Available from <http://gcc.gnu.org/>) or FreeBSD Clang for FreeBSD\* to build these programs.

\*: If you insist to use GCC under FreeBSD, please make sure that your machine is able to use GNU/Linux executables. This can be enabled by:

```bash
kldload linux
kldload linux64
```

with package `linux_base-c7` installed.

* If you would like to use libDO v3 instead of v2, you need the following dependencies:

	* pstree(PSmisc)>=23.1 for GNU/Linux users.
	* psutil>=5.7.2, a Python package which can be installed by `pip3` or Anaconda.

* If you would like to use `git-mirror` or use `LMP_dev` in `opt/`, install Git>=2.21.

	The entire LinuxMiniProgram needs Git\* (Available from <https://git-scm.com/>) to be downloaded and upgraded. It can be installed by your package manager or by compiling its source code. If there's no Git available, please download a zipped archive from GitHub (See below.). However, you may be unable to get updates in this way. If you would like to use `git-mirror` or `LMP_dev`, Git would be mandatory.

	\*: If you use Cygwin, you should **ONLY** use Git installed by Cygwin installer instead of those provided by Git for Windows. See *Dealing with CRLF* for further details.

* All documentation is written in AsciiDoc, a modern Markup Language. If you wish to compile them into Groff man, PDF, HTML, and YuZJLab Usage, please install the following dependencies:

	* Python>=3.5 can be installed by your package manager or Anaconda\*.
	* Ruby, at least Ruby>=3.0.3\*, can be installed by your package manager or by compiling the source code.
	* Asciidoc compiler Asciidoctor>=2.0.10 (Available from <https://asciidoctor.org/>) and Asciidoctor-pdf>=1.5.3 can be installed by Rung gem.
	* If you only need to compile HTML, you may install Asciidoc>=9.0.4 (Available from <https://asciidoc.org/>), a Python package, instead. However, the rendering effect may be worse.

	\*: If you use Cygwin, you should **ONLY** use `python`/`ruby` binary installed by Cygwin installer. You may not use those provided by Anaconda or WinPython. The `configure` script will detect and exclude all Windows implementation of Python and accept the Cygwin version only.

* To enable all archive utilities in AutoZip series, please install the following packages:

| Software              | Version            | URL                                          |
| --------------------- | ------------------ | -------------------------------------------- |
| 7za (p7zip)           | 15.14              | <http://p7zip.sourceforge.net/>              |
| 7za (Windows)         | 1900               | <https://www.7-zip.org/>                     |
| brotli                | 1.0.9              | <https://github.com/google/brotli>           |
| bzip2                 | 1.0.8              | <https://sourceforge.net/projects/bzip2/>    |
| bgzip (HTSLib)        | 1.10.2-23-g6b72368 | <https://github.com/samtools/htslib>         |
| compress (ncompress)  | 4.2.4.6-4          | <https://github.com/vapier/ncompress>        |
| gzip (GNU GZip)       | 1.8                | <https://www.gnu.org/software/gzip/>         |
| lz4                   | 1.9.3              | <https://github.com/lz4/lz4>                 |
| lzip                  | 1.11               | <https://www.nongnu.org/lzip/>               |
| lzop                  | 1.04               | <https://www.lzop.org/>                      |
| Modern 7Z             | Unknown            | <https://www.tc4shell.com/en/7zip/modern7z/> |
| pbz2 (pbzip2)         | 1.1.13             | <http://compression.ca/pbz2/>                |
| pigz                  | 2.4                | <http://www.zlib.net/pigz/>                  |
| tar (BSD tar)         | 3.3.2              | Installed in MacOS and BSD by default.       |
| tar (GNU Tar)         | 1.26               | <https://www.gnu.org/software/tar/>          |
| rar, unrar, WinRAR    | 5.80               | <https://www.rarlab.com/>                    |
| xz (XZ Utils)         | 5.2.4              | <https://tukaani.org/xz/>                    |
| zip, unzip (Info-Zip) | 3.0/6.0.0          | <http://infozip.sourceforge.net/>            |
| zstd                  | 1.4.5              | <https://github.com/facebook/zstd>           |

### General Guide

#### Download

```bash
git config --global core.autocrlf input # for Windows only
git clone https://github.com/YuZJLab/LinuxMiniPrograms
# You may download from https://gitee.com/yuzjlab/LinuxMiniPrograms/ if unable to visit GitHub
cd LinuxMiniPrograms
```

If there's no Git available, you may use the following way to download the code:

```bash
wget https://github.com/YuZJLab/LinuxMiniPrograms/archive/master.zip
# If there's no even wget, you may use:
# curl https://github.com/YuZJLab/LinuxMiniPrograms/archive/master.zip -o master.zip
# You may also use axel or aria2c to accelerate the download if available
# You may download from https://gitee.com/yuzjlab/LinuxMiniPrograms/repository/archive/master.zip manually if unable to visit GitHub
unzip LinuxMiniPrograms-master.zip
mv LinuxMiniPrograms-master LinuxMiniPrograms
```

#### Configure

After downloading, you can now execute `configure` to install all the programs for yourself. You can also run this script to change your settings to the defaults.

Detailed code:

```bash
chmod +x configure
./configure --all
```

Execute `./configure -h` to get help with the installer.

#### Make

Then, you may execute `make` to compile the source code for programs written in C and compile the documentation. For users under FreeBSD or macOS, use `gmake` instead.

#### Changing Repository

If your access to GitHub is declined, you may use LinuxMiniPrograms on Gitee instead. For a cloned repository, it will be:

```bash
git remote rm origin
git remote add origin https://gitee.com/yuzjlab/LinuxMiniPrograms/
```

There will be instructions on how to set up a tracking branch if you're performing a `git pull`.

If you wish to change back to GitHub, just repeat the code with URLs modified.
