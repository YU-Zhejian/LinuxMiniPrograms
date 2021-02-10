# Source global definitions
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"

[ -f /etc/bashrc ] && . /etc/bashrc

# Git helper, can be found at git's source code.
. "${HOME}"/.git-prompt.sh

# Fantastic $PS1 with additional linebreak.
function __prevp (){
	local r=${?}
	[ ${r} -eq 0 ] && echo -e "\e[42m\e[30m${r}\e[32m\e[46m \e[0m" || echo -e "\e[41m\e[30m${r}\e[31m\e[46m \e[0m"
}
export PS1='$(__prevp)\e[30m\e[46m$(date +%Y-%m-%d_%H-%M-%S)\e[43m\e[36m \e[30m${PWD}\e[42m\e[33m \e[30m$(__git_ps1 " (%s)")\e[32m\e[40m \e[0m\n\$ '

# Conda setup scripts omitted.

export PATH="${HOME}/bin:${HOME}/usr/bin:${HOME}/usr/local/bin:${PATH}"
export CMAKE_PREFIX_PATH="${HOME}/usr/local/CMAKE_PREFIX:${CMAKE_PREFIX_PATH:-}"
export PKG_CONFIG_PATH="${HOME}/usr/local/lib/pkgconfig/:${HOME}/usr/local/lib64/pkgconfig/:${PKG_CONFIG_PATH:-}"
export PKG_CONFIG_LIBFIR="${HOME}/usr/local/lib64/pkgconfig/:${HOME}/usr/local/lib/pkgconfig/:${PKG_CONFIG_LIBFIR:-}"
export MANPATH="${HOME}/bin/cpan.d/man/man3:${HOME}/usr/local/share/man:${MANPATH:-}"
export INFOPATH="${HOME}/usr/local/share/info:${INFOPATH:-}"
export LD_LIBRARY_PATH="${HOME}/usr/local/lib/:${HOME}/usr/local/lib64/:${LD_LIBRARY_PATH:-}"
export LIBRARY_PATH="${HOME}/usr/local/lib/:${HOME}/usr/local/lib64/:${LIBRARY_PATH:-}"
export LD_RUN_PATH="${HOME}/usr/local/lib:${HOME}/usr/local/lib64/:${LD_RUN_PATH:-}"
export CPLUS_INCLUDE_PATH="${HOME}/usr/local/include:${CPLUS_INCLUDE_PATH:-}"
export C_INCLUDE_PATH="${HOME}/usr/local/include:${C_INCLUDE_PATH:-}"
alias du="du -h" # More readable du.
alias df="df -h" # More readable df.
alias diff="diff -u" # Make the output of $(diff) similar to git diff.
alias ls="ls -lhF --color=auto" # More readable ls.
alias grep="grep --color=auto" # More readable grep.
alias shutdown="echo What the hell you\'re thinking?\!"
alias reboot="echo What the hell you\'re thinking?\!"
alias sudo="echo What the hell you\'re thinking?\!"
alias rm="rm -i" # Safer $(rm).
alias git-log="git log --pretty=oneline --abbrev-commit --graph --branches" # More readable git log.
alias git-gc="git gc --aggressive --prune=now" # Clean git up
alias top="htop" # htop is a task manager better than top.
alias emacs="emacs -nw"
eval "$(thefuck -a)"
