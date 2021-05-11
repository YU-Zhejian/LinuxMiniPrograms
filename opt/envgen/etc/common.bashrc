# Source global definitions.
[ -f /etc/bashrc ] && . /etc/bashrc
[ -f "${HOME}"/.common.sh ] && . "${HOME}"/.common.sh
# There's no need to source "${HOME}/.profile". It gets executed before this one.

# Git helper, can be found at the source code of Git.
function __git_ps1 (){ true; } # The default ${PS1}
[ -f "${HOME}"/.git-prompt.sh ] && . "${HOME}"/.git-prompt.sh
export GIT_PS1_SHOWUPSTREAM="verbose"

# Fantastic ${PS1} with additional linebreak.
function __prevp (){
	local r=${?}
	[ ${r} -eq 0 ] && echo -e "\e[32m${r}\e[0m" || echo -e "\e[31m${r}\e[0m"
}

# TODO: bugs in MSYS2
export PS1='\[\e]0;\u@\h: \w\a\]\[\033[;32m\]┌──[$(__prevp)]-${debian_chroot:+($debian_chroot)──}${VIRTUAL_ENV:+(\[\033[0;1m\]$(basename $VIRTUAL_ENV)\[\033[;32m\])}(\[\033[1;34m\]\u@\h\[\033[;32m\])-$(date +%Y-%m-%d_%H-%M-%S)-[\[\033[0;1m\]${PWD}\[\033[;32m\]]$(__git_ps1 " (%s)")\n\[\033[;32m\]└─\[\033[1;34m\]\$\[\033[0m\] '
# It displays like TODO

# History settings.
export HISTTIMEFORMAT='%F %T ' # History with time.
export HISTFILE="${HOME}/.bash_history"
# Larger history size.
export HISTSIZE=50000
export HISTFILESIZE=50000
