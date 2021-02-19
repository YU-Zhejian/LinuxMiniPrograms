# `envgen`: Environment Generator and Detector.

This is YuZJLab `envgen`, an environmental generator and detector.

This program mainly composed of two Shell script:

## `ckenv.sh`: Environmental Detector for a Problematic Computer with GNU/Linux Operating System

This program is useful when:

1. You have just got a new computer and want to see what's inside it.
2. You've encountered computer error and need to generate a report for maintenance.

`ckenv.sh` will check all aspects in your computer, and works well in various GNU/Linux systems. You may examine the report yourself, or give it to a professional maintainer.

### Usage

`bash ckenv.sh [OUTPUT]` Report generated will be saved to `[OUTPUT]`. If not specified, it will save to your working directory.

### Example\*

\* Due to the reason that `chenv.sh` is being updated at high frequency, the following documentation may be obsolete. But it will not affect the general usage of this program.

```
$ ./ckenv.sh
YuZJLab Environment Checker version 1.0.0
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

Initiating...
8/555 echo /home/yuzj/LinuxMiniPrograms/opt/envgen...PASS
10/555 uname -a...PASS
11/555 cat /etc/issue...PASS
13/555 uptime...PASS
14/555 runlevel...PASS
15/555 __rc_cat...PASS
16/555 crontab -l...FAIL
17/555 __cron_cat...FAIL
18/555 chkconfig --list...FAIL
[...]
555/555 which zstd...PASS
```

The report generated (Named `Report_2021-01-19_20-07-26.log` here) will be like:

```
2021-19-01,20:07:26 $ # Program Started.
2021-19-01,20:07:26 $ # Please make comments like this example.
2021-19-01,20:07:26 $ # You need to leave a space before your contents,
2021-19-01,20:07:26 $ # otherwise the software may fail when parsing them.
2021-19-01,20:07:26 $ # You may comment some of the tests if not needed,
2021-19-01,20:07:26 $ # or make other modifications on your purpose.
2021-19-01,20:07:26 $ # ________________________Headers________________________
2021-19-01,20:07:26 $ echo /home/yuzj/LinuxMiniPrograms/opt/envgen
	 1	OO /home/yuzj/LinuxMiniPrograms/opt/envgen
2021-19-01,20:07:26 $ # ________________________Operating System Info________________________
2021-19-01,20:07:26 $ uname -a
	 1	OO Linux yuzj-HP-ENVY-x360-Convertible-15-dr1xxx 5.10.0-12-generic #13-Ubuntu SMP Mon Jan 11 22:44:11 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
2021-19-01,20:07:26 $ cat /etc/issue
	 1	OO Ubuntu Hirsute Hippo (development branch) \n \l
	 2	OO 
2021-19-01,20:07:26 $ # ________________________Boot Info________________________
2021-19-01,20:07:26 $ uptime
	 1	OO  20:07:26 up  5:15,  2 users,  load average: 1.66, 2.04, 2.08
2021-19-01,20:07:26 $ runlevel
	 1	OO N 5
2021-19-01,20:07:26 $ __rc_cat
	 1	OO # ----------/etc/rc0.d/K01alsa-utils----------
	 2	OO #!/bin/sh
	 3	OO #
[...]
2021-19-01,20:07:26 $ crontab -l
	 1	EE no crontab for yuzj
2021-19-01,20:07:26 $ __cron_cat
	 1	EE ./ckenv.sh: line 59: file: unbound variable
2021-19-01,20:07:26 $ chkconfig --list
	 1	EE ./ckenv.sh: line 40: chkconfig: command not found
2021-19-01,20:07:26 $ service --status-all
[...]
	 1	2021-19-01,20:07:26 $ # Program Started.
	 2	2021-19-01,20:07:26 $ # Please make comments like this example.
	 3	2021-19-01,20:07:26 $ # You need to leave a space before your contents,
	 4	2021-19-01,20:07:26 $ # otherwise the software may fail when parsing them.
	 5	2021-19-01,20:07:26 $ # You may comment some of the tests if not needed,
	 6	2021-19-01,20:07:26 $ # or make other modifications on your purpose.
	 7	2021-19-01,20:07:26 $ # ________________________Headers________________________
	 8	2021-19-01,20:07:26 $ echo /home/yuzj/LinuxMiniPrograms/opt/envgen
	10	2021-19-01,20:07:26 $ # ________________________Operating System Info________________________
	11	2021-19-01,20:07:26 $ uname -a
 [...]
```

### Interpretation of the Report

The entire report can be decided into 3 segments: header, body and TOC (Table of Contents).

The header includes some simple information like working directory. These lines belong to the header segment:

```
2021-19-01,20:07:26 $ # Program Started.
[...]
2021-19-01,20:07:26 $ # ________________________Headers________________________
2021-19-01,20:07:26 $ echo /home/yuzj/LinuxMiniPrograms/opt/envgen
	 1	OO /home/yuzj/LinuxMiniPrograms/opt/envgen
```

Any command or comment in body segment is referenced in TOC segment. Let's look at the result generated by command `10/555 uname -a...PASS`. In body segment, they are in section `Operating System Info`:

```
2021-19-01,20:07:26 $ uname -a
	 1	OO Linux yuzj-HP-ENVY-x360-Convertible-15-dr1xxx 5.10.0-12-generic #13-Ubuntu SMP Mon Jan 11 22:44:11 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

The outcome listed here is straightforward. `2021-19-01,20:07:26` is when this command gets executed (and also when the previous command finishes) and `$` is just the prompt separating the time and the command, which is `uname -a`. Those parts listed below are standard output (Started with OO) and standard error (Started with EE) and the number before them are the line numbers. 

From the above output, we can easily see that one line of output is generated by `uname -a`. Other outputs can also be split in this way. If you have problems understanding what the output \& command means, please refer to an expert. They will not be explained here.

### Hacking `ckenv.sh`

**Please read this section---It's important!**

The environment checking script is listed here, starting from `echo "${PWD}"` to `WHERE zstd`. Other script is the wrapper or external functions.

```bash
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
[...]
WHERE zstd
EOF
```

You're free to add, delete or make comments (especially when these tests may leak personal information, too time consuming or unnecessary). There are instructions inside.

However, please note that all commands will be executed with `eval` command. So you may add lots of escaping characters just like what you do in LibDO. If the code you wish to add is too complex, you may firstly add a function outside and reference it inside. It will be recognized. Like:

```bash
function __rc_cat() {
	for file in /etc/rc*/*;do echo \# ----------${file}----------;cat ${file} || true;done
}
```

This function just pumps all the script inside `/etc/rc*/*`, which is where the starting script is kept in some old systems.

You may see more documentations in the script itself or `doc`.

## `envgen.sh`: Fast Environmental Generation on a New Computer

When migrating to a new computer, you may be interested in setting up a working system on the fly. `envgen.sh` is used to solve this problem. What it will do is listed as follows:

* Make `${HOME}"/envgen_"$(date +%Y-%m-%d_%H-%M-%S)"` as where temporary files and backup files are kept.

* Get a new functional `.bashrc` with following modifications.
	* A new prompt (`${PS1}`) like
		```
		0 2021-01-19_20-43-47 /home/yuzj/LinuxMiniPrograms/opt/envgen  (BSD) $
		```
		
		The first `0` is the exit status for the previous command. Its background colour will be green if the previous command finished without error and red if error occurs. `2021-01-19_20-43-47` is when the previous command finished and `/home/yuzj/LinuxMiniPrograms/opt/envgen` is your current working directory. `(BSD)` is the branch you're in if you're using git.
		
	* Useful C programming environmental variables. It will be effective if you execute `configure` script with option `--prefix="${HOME}/usr/local"`.
	
	* Simple aliases used to generate human-readable output for commands like `du` or `df`.
	
	* A program called `thefuck` which is used to correct your mis-spellings.
	
	* You may see more explanations in `etc/common.bashrc`.
	
* LinusBrew is a application manager for users without root permission. It will be installed with common updates and more software (like Git and R) will be installed. It will take about 3GiB of space.

* Miniconda installation with Jupyter Lab and other useful statistical packages. It will take about another 3GiB of space.

* Functional GNU Emacs settings like line numbers and backup removal.

* Statistical R packages.

* Mirror setting to TUNA for Miniconda, R and Ruby.

You may see more documentations in the script itself or `doc`.