# ReadMe For YuZJLab LinuxMiniPrograms

This file is written in Markdown, a lightweight Markup language. If you have no idea how to read them, you may use Pandoc (<https://www.pandoc.org/>) or Markdown editors like Typora (<https://www.typora.io/>) if you have access to a Graphical User Interface (GUI). This documentation can be converted to PDF, HTML or other various formats by Pandoc available from <https://www.pandoc.org/>. 

## Copyright

These programs are designed to cut down the time a bioinformatician spent on doing sys-admin work.

Copyright (C) 2019-2021 YU Zhejian

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of **MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

## Installation

Please refer to `Install.md`.

## Compatibility

Please read the documents of each program and `LMP_basis` to check if the program supports your system.

## Help for GreenHands

### Dealing with the environment

The following scripts will set up a basic environment for development and everyday use.

```bash
cd opt/envgen
bash envgen.sh bash conda emacs r ruby
```

Run `exec bash` afterwards.

The following script will generate a bug report.

```bash
cd opt/envgen
bash ckenv.sh
```

See the documentation there for more details.

### Dealing with CRLF

Skip this section if you use Git on GNU/Linux, FreeBSD or macOS, unless you met problems described below.

For those who use Git for Windows, you may experience problems caused by line endings. These errors may look like `bash: line 1: $'true\r': command not found`.

That is because Windows uses `CRLF` (That is, "Carriage Return [回车] + Next Line [换行]") while *nix use `LF`, and your Git distribution automatically converts `LF` to `CRLF` when getting the file. To remove this issue, please do as follows:

1. Install `dos2unix` by your package manager or get one from <http://dos2unix.sourceforge.net/>. If you do not know how to do that, replace `dos2unix` with `sed -i'.bak' 's/\'$'\r$//g'` in commands listed below.

2. Execute the following code:

```bash
dos2unix opt/LMP_dev/bin/BeforeAdd.sh
bash opt/LMP_dev/bin/BeforeAdd.sh
```

This piece of code will automatically change all `CRLF` into `LF`.

For those who use the second piece of command, please remove those files with `.bak` suffix manually.

## Help \& Documentation \& Supporting

After installation, you can execute `yldoc -l` to get a complete list of all available documentation and view them by using `yldoc [name]` to access documentations for `[NAME]`. You can also find PDF, HTML, and other documentation formats in the corresponding folder if you enable `--install-doc` flag when executing `configure`.

It is recommended to read the `LMP_basis` to know the basic configurations to Linux MiniPrograms. News for the developers are listed in `src/news` in Asciidoc. See `Readme.adoc` in `src/` for further details.

## 3rd Party Codes

This project use codes from:

* Git - fast, scalable, distributed revision control system
	
	Available: <https://github.com/git/git> <https://git-scm.com/>
	
	```
	 Note that the only valid version of the GPL as far as this project
	 is concerned is _this_ particular version of the license (ie v2, not
	 v2.2 or v3.x or whatever), unless explicitly otherwise stated.
	
	 HOWEVER, in order to allow a migration to GPLv3 if that seems like
	 a good idea, I also ask that people involved with the project make
	 their preferences known. In particular, if you trust me to make that
	 decision, you might note so in your copyright message, ie something
	 like
	
		This file is licensed under the GPL v2, or a later version
		at the discretion of Linus.
	
	  might avoid issues. But we can also just decide to synchronize and
	  contact all copyright holders on LibdoRecord if/when the occasion arises.
	
				Linus Torvalds
	```

* pure bash bible (A collection of pure bash alternatives to external processes)
	
	Available: <https://github.com/dylanaraps/pure-bash-bible>
	
	```
	The MIT License (MIT)
	
	Copyright (c) 2018 Dylan Araps
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
	```
