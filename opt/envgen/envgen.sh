#!/usr/bin/env bash
set -euo pipefail
echo "YuZJLab Environment Generator version 1.0.0
Copyright 2021 (C) YuZJLab

Basic environment generator for GNU/Linux.

This application aims at generating a common environmental configuration for
universal GNU/Linux platforms.

Please note that this script aims at working in any computer with minimal
software. There will be no documentations to this software except this one.

Initiating..."

mkdir -p "${HOME}"/envgen_"$(date +%Y-%m-%d_%H-%M-%S)"
cp -r * "${HOME}"/envgen_"$(date +%Y-%m-%d_%H-%M-%S)"/
cd "${HOME}"/envgen_"$(date +%Y-%m-%d_%H-%M-%S)"

sed -i 's/\r$//g' etc/* || true

# ________________________Installing bashrc with common aliases________________________
mv "${HOME}"/.bashrc .bashrc.bak || true
git clone --depth 1 --verbose https://github.com/git/git
mv git/contrib/completion/git-prompt.sh "${HOME}"/.git-prompt.sh
mv etc/common.bashrc ${HOME}/.bashrc

# ________________________Installing Miniconda________________________
if ! conda --help &>> /dev/null; then
	wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda-latest-Linux-x86_64.sh
	bash Miniconda-latest-Linux-x86_64.sh -b -p conda
	mv "${HOME}"/.condarc .condarc.bak || true
	mv etc/.condarc "${HOME}"/.condarc
	cat etc/conda.bashrc >> "${HOME}"/.bashrc
fi

# ________________________EMACS Settings________________________
mkdir -p "${HOME}"/.emacs-backups
mv "${HOME}"/.emacsrc .emacsrc.bak || true
mv etc/common.emacsrc "${HOME}"/.emacsrc

# ________________________R Settings________________________
mv "${HOME}"/.Rprofile .Rprofile.bak || true
mv etc/common.Rprofile "${HOME}"/.Rprofile

# ________________________Installing Conda Packages________________________
. "${HOME}"/.bashrc || true
conda update --all -y
conda install -y ipython jupyterlab matplotlib notebook numpy pandoc tqdm
conda clean --all -y
