#!/usr/bin/env bash
#set -euo pipefail
set -v
echo "YuZJLab Environment Generator version 1.0.0
Copyright 2021 (C) YuZJLab

Basic environment generator for GNU/Linux.

This application aims at generating a common environmental configuration for
universal GNU/Linux platforms.

Please note that this script aims at working in any computer with minimal
software. There will be no documentations to this software except this one.

Initiating..."

DN="${HOME}"/envgen_"$(date +%Y-%m-%d_%H-%M-%S)"
mkdir -p "${DN}"
cp -r "$(readlink -f "$(dirname "${0}")")"/* "${DN}"
cd "${DN}"

sed -i 's/\r$//g' etc/*

# ________________________Installing bashrc with common aliases________________________
mv "${HOME}"/.bashrc .bashrc.bak
if ! __git_ps1 &>>/dev/null;then
	git clone --depth 1 --verbose https://github.com/git/git
	mv git/contrib/completion/git-prompt.sh "${HOME}"/.git-prompt.sh
fi
mv etc/common.bashrc ${HOME}/.bashrc
[ -f "${HOME}/.profile" ] || echo ". \${HOME}/.bashrc" >> "${HOME}/.profile"
# ________________________Installing Miniconda________________________
if ! conda --help &>> /dev/null; then
	wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
	bash Miniconda3-latest-Linux-x86_64.sh -b -p ${HOME}/conda
	mv "${HOME}"/.condarc .condarc.bak
	cp etc/.condarc "${HOME}"/.condarc
	cat etc/conda.bashrc >> "${HOME}"/.bashrc
fi

# ________________________EMACS Settings________________________
mkdir -p "${HOME}"/.emacs-backups
mv "${HOME}"/.emacsrc .emacsrc.bak
cp etc/common.emacsrc "${HOME}"/.emacsrc

# ________________________R Settings________________________
mv "${HOME}"/.Rprofile .Rprofile.bak
cp etc/common.Rprofile "${HOME}"/.Rprofile

# ________________________Ruby Settings________________________
mv "${HOME}"/.gemrc .gemrc.bak
cp etc/common.gemrc "${HOME}"/.gemrc

# ________________________Installing Conda Packages________________________
. "${HOME}"/.bashrc
conda update --all -y
conda install -y ipython jupyterlab matplotlib notebook numpy pandoc tqdm
conda clean --all -y
pip install thefuck
