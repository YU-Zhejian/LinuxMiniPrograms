# Readme For YuZJLab LinuxMiniPrograms
## Purpose
The reason I write these programs are to cut down time a bioinformatician spent on doing sysadmin work.

## Installation
Just add the "bin" directory to the PATH variable. In details, that will be:

```bash
git clone https://github.com/YuZJLab/LinuxMiniPrograms
cd LinuxMiniPrograms/bin
echo "PATH=\"${PWD}:\${PATH}\";export \${PATH}">>${HOME}/.bashrc
. ${HOME}/.bashrc
```
for an installation that only works on yourself.
## Help
After installation, you can execure `yldoc --list` to get acomplete  list of all available documentations and view them by using `yldoc [name]`.

