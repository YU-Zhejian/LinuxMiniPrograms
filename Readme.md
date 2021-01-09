# ReadMe For YuZJLab LinuxMiniPrograms
## Copyright

These programs are designed to cut down time a bioinformatician spent on doing sys-admin work.

Copyright (C) 2019-2020 YU Zhejian

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

## Installation

**PLEASE READ THE *DEPENDENCIES* SECTION WITH EXTRA CARE.**

**FOR MACOS USERS: CURRENTLY WE DO NOT SUPPORT MACOS. PLEASE WAIT FOR LONGER TIME\*.**

\*: I would appreciate a lot if you're kind enough to buy me one.

### Dependencies

"Package management systems" or "Package manager" refers to software such as `apt` on Ubuntu Linux, `CYGWin installer` in CYGWin, `homebrew` under MacOS or  `pkg`/`ports` systems under FreeBSD.

All the program relies on `bash >= 4.4.12(3)`. For MacOS users, please update the default `bash`. For users using CentOS/Debian stable, CentOS or other "stable" distributions, please upgrade it by compiling the source code (<https://ftp.gnu.org/gnu/bash/>).

For most programs written in Shell, these programs will be needed and GNU version would be better:

* `GNU CoreUtils>=8.22` available from <https://ftp.gnu.org/gnu/coreutils/>, including:

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
  * `split` (Mandatory)
  * `tail`
  * `tr`
  * `wc`
  * `uniq`


Mandatory for BSD or MacOS. It can be installed by compiling the source code (BSD) or `brew` (MacOS).

For MacOS users, if you use `brew`, please add the `bin` directory which contains binaries without leading "`g`" to your `${PATH}` environment variable. There will be instructions.

* Other essential GNU utils may include:

  * `GNU grep>=2.20` available from <https://ftp.gnu.org/gnu/sed/>. Those installed in `FreeBSD>=12.1` will also work.
  * `GNU sed>=4.4` available from <https://ftp.gnu.org/gnu/sed/>. Those installed in `FreeBSD>=12.1` will also work.
  * `GNU parallel>=20200122` available from <https://ftp.gnu.org/gnu/parallel/>.
  * `ps>=procps-ng version 3.3.10` available from <https://sourceforge.net/projects/procps-ng/> or `ps (cygwin) 3.1.4`. Those installed in `FreeBSD>=12.1` will also work.
  * `GNU make>=4.3` (Available from <https://www.gnu.org/software/make/>).

* Some programs such as `libmktbl` have its Python version (Need `python>=3.6`), which is faster than those written in Shell script. There are also programs written purely in Python, like `libdo-monitor`. When installing the program, the installer will search for all Python 3 interpreter inside the `${PATH}` variable and locate the newest Python interpreter as the default Python interpreter of the LMP. However, you can modify this by editing `etc/path.sh` to specific your own Python interpreter.

* Some programs such as `pst` have its C version, which is faster than those written in Python. You may need to install `gcc>=10.2.1-1ubuntu1` (Available from <http://gcc.gnu.org/>) to build these programs.

* If you would like to use libDO v3 instead of v2, you need following dependencies:

  * `pstree(PSmisc)>=23.1` for GNU/Linux users.
  * `psutil>=5.7.2`, a Python package which can be installed by `pip3` or `conda`\*.

* If you would like to use `git-mirror`, install `git>=2.21`.

  The entire `LinuxMiniProgram` needs `git>=2.21`\* to be downloaded or upgraded. It can be installed by your package manager or by compiling its source code. If there's no `git` available, please download a zipped archive from GitHub (See below.). However, you may unable to get updates in this way. If you would like to use `git-mirror`, `git` would be mandatory.

  \*: If you use CYGWin, you should **ONLY** use `git` installed by `CYGWin installer` instead of `winGit`. Otherwise, you may see *Dealing with CRLF*.

* All documentation are written in AsciiDoc, a modern Markup Language. If you wish to compile them into Groff man, PDF, HTML and YuZJLab Usage, please install the following dependencies:

  * `python>=3.6` can be installed by your package manager or `Conda`\*.
  * Ruby, at least `ruby-gems>=3.0.3`\*, can be installed by your package manager or by compiling the source code.
  * Asciidoc compiler `asciidoctor>=2.0.10` and `asciidoctor-pdf>=1.5.3` can be installed by `gem`.
  * If you only need to compile HTML, you may install `asciidoc>=9.0.4`, a Python package, instead. However, the rendering effect may be worse.

  \*: If you use CYGWin, you should **ONLY** use `python`/`ruby` installed by `CYGWin installer`. You may not use those provided by `Conda`/`Anaconda` or `WinPython`.

* To enable all archive utilities in `autozip` series, please install the following packages:


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
| tar (BSD tar)         | 3.3.2              |                                              |
| tar (GNU Tar)         | 1.26               | <https://www.gnu.org/software/tar/>          |
| rar, unrar, WinRAR    | 5.80               | <https://www.rarlab.com/>                    |
| xz (XZ Utils)         | 5.2.4              | <https://tukaani.org/xz/>                    |
| zip, unzip (Info-Zip) | 3.0/6.0.0          | <http://infozip.sourceforge.net/>            |
| zstd                  | 1.4.5              | <https://github.com/facebook/zstd>           |


### General Guide
After downloading, you can now execute `install.sh` to install all the programs for yourself. You can also run this script to change your settings to the defaults.

Detailed code:

```bash
git clone https://github.com/YuZJLab/LinuxMiniPrograms
cd LinuxMiniPrograms
chmod +x install.sh
./install.sh --all
```

If there's no `git` available, you may use the following way to download the code:

```bash
wget https://github.com/YuZJLab/LinuxMiniPrograms/archive/master.zip
# If there's no even wget, you may use:
# curl https://github.com/YuZJLab/LinuxMiniPrograms/archive/master.zip -o master.zip
unzip LinuxMiniPrograms-master
mv LinuxMiniPrograms-master LinuxMiniPrograms
```

Execute `./install.sh -h` to get help about the installer.

## Compatibility

Please read the documents of each program and `LMP_basis` to check if the program supports your system.

### Dealing with CRLF

For those who use `WinGit`, you may experience problems caused by line endings. They may looks like `bash: line 1: $'true\r': command not found`.

That is because Windows uses `CRLF` while *ix use `LF`, and your `git` distribution automatically converts `LF` to `CRLF` when getting the file. To remove this issue, please do as follows:

1. Install `dos2unix` by your package manager or get one from <http://dos2unix.sourceforge.net/>.

2. Execute the following code:

```bash
dos2unix BeforeAdd.sh
./BeforeAdd.sh
```

## Help & Documentation

After installation, you can execute `yldoc -l` to get a complete list of all available documentations and view them by using `yldoc [name]`. You can also find PDF, HTML and other documentation formats in corresponding folder.

It is recommended to read the `LMP_basis` to know the basic configurations to Linux Mini Programs.

