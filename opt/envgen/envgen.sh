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

INSTALL_BASH_SETTINGS=false
INSTALL_CONDA=false
INSTALL_BREW=false
INSTALL_EMACS_SETTINGS=false
INSTALL_R_SETTINGS=false
INSTALL_RUBY_SETTINGS=false

for pg in "${@}"; do
	case "${pg}" in
	"bash")
		INSTALL_BASH_SETTINGS=true
		;;
	"conda")
		INSTALL_CONDA=true
		;;
	"brew")
		INSTALL_BREW=true
		;;
	"emacs")
		INSTALL_EMACS_SETTINGS=true
		;;
	"r")
		INSTALL_R_SETTINGS=true
		;;
	"ruby")
		INSTALL_RUBY_SETTINGS=true
		;;
	"all")
		INSTALL_BASH_SETTINGS=true
		INSTALL_CONDA=true
		INSTALL_BREW=true
		INSTALL_EMACS_SETTINGS=true
		INSTALL_R_SETTINGS=true
		INSTALL_RUBY_SETTINGS=true
		;;
	esac
done

DN="${HOME}"/envgen_"$(date +%Y-%m-%d_%H-%M-%S)"
mkdir -p "${DN}"
cp -r "$(readlink -f "$(dirname "${0}")")"/* "${DN}"
cd "${DN}"

sed -i 's/\r$//g' etc/*

# ________________________Installing bashrc with common aliases________________________
if ${INSTALL_BASH_SETTINGS}; then
	mv "${HOME}"/.bashrc .bashrc.bak
	if ! __git_ps1 &>>/dev/null; then
		git clone --depth 1 --verbose https://github.com/git/git
		mv git/contrib/completion/git-prompt.sh "${HOME}"/.git-prompt.sh
	fi
	mv etc/common.bashrc "${HOME}"/.bashrc
	[ -f "${HOME}/.profile" ] || echo ". \${HOME}/.bashrc" >>"${HOME}/.profile"
fi

# ________________________Installing Miniconda________________________
if ${INSTALL_CONDA} && ! which conda &>>/dev/null; then
	wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
	bash Miniconda3-latest-Linux-x86_64.sh -b -p ${HOME}/conda
	mv "${HOME}"/.condarc .condarc.bak
	cp etc/.condarc "${HOME}"/.condarc
	cat etc/conda.bashrc >>"${HOME}"/.bashrc
	. etc/conda.bashrc
	conda update --all -y
	conda install -y ipython jupyterlab matplotlib notebook numpy pandoc tqdm
	conda clean --all -y
	pip install thefuck
fi

# ________________________Installing LinuxBrew________________________
# brew uninstall $(brew list | xargs) # Removing all programs
if ${INSTALL_BREW} && ! which brew &>>/dev/null; then
	git clone https://mirrors.ustc.edu.cn/brew.git "${HOME}"/linuxbrew
	cat etc/brew.bashrc >>"${HOME}"/.bashrc
	cat etc/brew.bashrc >>"${HOME}"/.Renviron
	. etc/brew.bashrc
	HOMEBREW_BOTTLE_DOMAIN=https://mirrors.cloud.tencent.com/homebrew-bottles/ # USTC mirror do not provide bottles-portable-ruby.
	mkdir -p "$(brew --repo homebrew/core)"
	# mkdir -p "$(brew --repo)"/Library/Taps/homebrew/homebrew-cask
	git clone https://mirrors.ustc.edu.cn/linuxbrew-core.git "$(brew --repo homebrew/core)"
	# git clone https://mirrors.ustc.edu.cn/homebrew-cask.git "$(brew --repo)"/Library/Taps/homebrew/homebrew-cask
	# brew tap brewsci/bio
	# brew tap brewsci/num
	# brew tap brewsci/base
	sed -i "s;^HOMEBREW_LINUX_DEFAULT_PREFIX =.*$;HOMEBREW_LINUX_DEFAULT_PREFIX = \"${HOME}/linuxbrew\";" "${HOME}"/linuxbrew/Library/Homebrew/global.rb
	brew install --build-from-source openssl # The most important program.
	# These programs may fail.
	for programs in ruby python; do
		brew install --force-bottle "${programs}" || true
	done
	# These programs should be updated. Those installed inside the system may be too old.
	brew install --force-bottle binutils bash pbzip2 gnu-tar coreutils
	brew install --force-bottle libtool autogen pkg-config autoconf automake gcc@10 llvm
	brew install --force-bottle r mercurial
	# brew install emacs # Cannot be used without GitHub.
fi

# ________________________Installing Brew Utils________________________
if ${INSTALL_BREW}; then
	function __brew_install() {
		which ${1} &>>/dev/null || brew install --force-bottle ${2}
	}
	function __brew_src_install() {
		which ${1} &>>/dev/null || brew install --build-from-source ${2}
	}
	__brew_install 7za p7zip
	__brew_install compress ncompress
	__brew_install lz4 lz4
	__brew_install lzip lzip
	__brew_install lzop lzop
	__brew_install pigz pigz
	__brew_install zip zip
	__brew_src_install htop htop
	__brew_install pstree pstree
	__brew_install mc mc
	__brew_install vim vim
	__brew_install aria2 aria2
	__brew_install javac openjdk
	__brew_install duf duf
	__brew_install brotli brotli
	# __brew_install ack ack # Failed.
	__brew_install lzfse lzfse
	__brew_install bc bc
	# Adding CA Certs
	brew install --build-from-source axel git
	git config --global http.sslVerify false # Have to use this to solve issues.

	# Git rid of the problematic perl installation.
	brew uninstall --ignore-dependencies perl
fi
# ________________________EMACS Settings________________________
if ${INSTALL_EMACS_SETTINGS}; then
	mkdir -p "${HOME}"/.emacs-backups
	mv "${HOME}"/.emacsrc .emacsrc.bak
	cp etc/common.emacsrc "${HOME}"/.emacsrc
fi

# ________________________R Settings________________________
if ${INSTALL_R_SETTINGS}; then
	mv "${HOME}"/.Rprofile .Rprofile.bak
	cp etc/common.Rprofile "${HOME}"/.Rprofile
	echo 'install.packages(c("ggpubr","tidyverse","rmarkdown","knitr","viridis","stringr","devtools","BiocManager"))' | R --no-save # May cause problems.
fi
# ________________________Ruby Settings________________________
if ${INSTALL_RUBY_SETTINGS}; then
	mv "${HOME}"/.gemrc .gemrc.bak
	cp etc/common.gemrc "${HOME}"/.gemrc
fi
