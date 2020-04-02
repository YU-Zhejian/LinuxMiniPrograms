# ReadMe For YuZJLab LinuxMiniPrograms
## Copyright

These programs are designed to cut down time a bioinformatician spent on doing sys-admin work.

Copyright (C) 2019-2020 YU Zhejian

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

## Please Pay Attention

As we're developing programs mostly under Microsoft Windows, we **DO NOT** pay attention to file permissions. You can execute `git config core.filemode false` to make your own copy of repository ignore them as well.

## Installation
You can now execute `install.sh` to install all the programs for yourself. You can also run this script to change your settings to the defaults.

Detailed code:

```
git clone https://github.com/YuZJLab/LinuxMiniPrograms
cd LinuxMiniPrograms
chmod +x install.sh
./install.sh --all
```

## Branches on GitHub

There are two main branches on github: `master` and `NEW`. `master` branch is a stable releasing branch and `NEW` branch is cutting-edge developing branch. Other branches should be considered as unstable.

## Help
After installation, you can execute `yldoc --list` to get a complete  list of all available documentations and view them by using `yldoc [name]`.

