# ReadMe For YuZJLab LinuxMiniPrograms
## Copyright

These programs are designed to cut down time a bioinformatician spent on doing sys-admin work.

Copyright (C) 2019-2020 YU Zhejian

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

## Installation

**PLEASE READ THE *DEPENDENCOES* SECTION WITH EXTRA CARE. YOU CAN SKIP THIS SECTION ONLY IF YOU'RE USING THE NEWEST VERSION OF A POPULAR GNU/LINUX DISTRIBUTION.**

**FOR MACOS USERS: CURRENTLY WE DO NOT SUPPORT MACOS. PLEASE WAIT FOR LONGER TIME\*.**

\*: I would appreciate a lot if you're kind enough to buy me one.

### Dependencies

"Package management systems" or "Package manager" refers to software such as `apt` on Ubuntu Linux, `CYGWin installer` in CYGWin, `homebrew` under MacOS or  `pkg`/`ports` systems under FreeBSD.

All the program relies on `bash >= 4.4.12(3)`. For MacOS users, please update the default `bash`. For users using CentOS/Debian stable or other "stable "distributions, please upgrade it by compiling the source code (<https://ftp.gnu.org/gnu/bash/>).

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
  * `readlink` (Mandatory )
  * `rm`
  * `sleep`
  * `sort`
  * `split` (Mandatory )
  * `tail`
  * `tr`
  * `wc`
  * `uniq`
  
Mandatory for BSD or MacOS. It can be installed by compiling the source code (BSD) or `brew` (MacOS).
  
For MacOS users, if you use `brew`, please add the `bin` directory which contains binaries without leading "`g`" to your `${PATH}` environment variable. There will be instructions.
  
* `GNU grep>=2.20` available from <https://ftp.gnu.org/gnu/sed/>. Those installed in `FreeBSD>=12.1` will also work.

* `GNU sed>=4.4` available from <https://ftp.gnu.org/gnu/sed/>. Those installed in `FreeBSD>=12.1` will also work.

* `GNU parallel>=20200122` available from <https://ftp.gnu.org/gnu/parallel/>.

* `ps>=procps-ng version 3.3.10` available from <https://sourceforge.net/projects/procps-ng/> or `ps (cygwin) 3.1.4`. Those installed in `FreeBSD>=12.1` will also work.

If you would like to use libDO v3 instead of v2, you need following dependencies:

* `pstree(PSmisc)>=23.1` for GNU/Linux users.

* `psutil>=5.7.2`, a Python package (Need `Python>=3.6`) which can be installed by `pip3` or `conda`\*.

If you would like to use `git-mirror`, install `git>=2.21`.

The entire `LinuxMiniProgram` needs `git>=2.21` to be downloaded or upgraded. `git` can be installed by your package manager or by compiling its source code. If there's no `git` on your machine, please download a zipped archive from GitHub and use `scp` to transport it to your target machine. However, you may unable to get updates in this way. If you would like to use `git-mirror`, `git` would be mandatory.

All documentations are written in `asciidoctor`.If you wish to compile them into Groff man, PDF, HTML and YuZJLab Usage, please install the following dependencies:

* `python>=3.6` can be installed by your package manager or `conda`\*.
* Ruby, at least `ruby-gems>=3.0.3`\*, can be installed by your package manager or by compiling the source code.
* `Ruby gems` package `asciidoctor>=2.0.10` and `asciidoctor-pdf>=1.5.3` can be installed by `gem`.

\*: If you use CYGWin, you should **ONLY** use `python`/`ruby` installed by `CYGWin installer`.

To enable all archive utilities in `autozip` series, please install the following packages:

* `gzip>=1.8` available from <https://ftp.gnu.org/gnu/gzip/>.
* `pigz>=2.4` available from <http://www.zlib.net/pigz/>.
* `bsdtar>=3.3.2` or `gtar>=1.26` (available from <https://ftp.gnu.org/gnu/tar/>).
* `xz>=5.2.4` available from <https://tukaani.org/xz/>.
* `bzip2>=1.0.8` available from <https://sourceforge.net/projects/bzip2/>.
* `zip>=3.0` and `unzip>=6.0.0` can be installed by your package manager or `conda`.
* `unrar>=5.80` can be installed by your package manager but can be downloaded from <https://www.rarlab.com/> in binary form.
* `p7zip` or `p7zip-full` with `7za>=15.14`, available from <http://p7zip.sourceforge.net/> can be installed by your package manager or `conda`.
* `rar>=5.80` is property software, but can be downloaded from <https://www.rarlab.com/> in binary form.
* `bgzip>=1.10.2-23-g6b72368` is a part of `htslib` (originally `tabix`) which is available from <https://github.com/samtools/htslib>. You may also install `htslib` (or `tabix`) by your package manager.

Some packages such as `libmktbl` have its Python version, which is faster than those written in Shell script. There are also programs written purely in Python, like `libdo-monitor`. Please read `LMP_basis` to configure Python.

### General Guide
After downloading, you can now execute `install.sh` to install all the programs for yourself. You can also run this script to change your settings to the defaults.

Detailed code:

```bash
git clone https://github.com/YuZJLab/LinuxMiniPrograms
cd LinuxMiniPrograms
chmod +x install.sh
./install.sh --all
```

Execute `./install.sh -h` to get help about the installer.

## Compatibility

Please read the documents of each program and `LMP_basis` to check if the program supports your system.

## Help & Documentation

After installation, you can execute `yldoc -l` to get a complete list of all available documentations and view them by using `yldoc [name]`. You can also find PDF, HTML and other documentation format in corresponding folder.

It is recommended to read the `LMP_basis` to know the basic configurations to Linux Mini Programs.
