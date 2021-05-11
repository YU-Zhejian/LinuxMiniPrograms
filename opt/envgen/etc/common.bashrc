# Source global definitions.
[ -f /etc/bashrc ] && . /etc/bashrc
# There's no need to source "${HOME}/.profile". It gets executed before this one.

# Git helper, can be found at the source code of Git.
function __git_ps1 (){ true; } # The default ${PS1}
[ -f "${HOME}"/.git-prompt.sh ] && . "${HOME}"/.git-prompt.sh
export GIT_PS1_SHOWUPSTREAM="verbose"

# Fantastic ${PS1} with additional linebreak.
function __prevp (){
	local r=${?}
	[ ${r} -eq 0 ] && echo -e "\e[42m\e[30m${r}\e[32m\e[46m \e[0m" || echo -e "\e[41m\e[30m${r}\e[31m\e[46m \e[0m"
}

# TODO: bugs in MSYS2
export PS1='$(__prevp)\e[30m\e[46m$(date +%Y-%m-%d_%H-%M-%S)\e[43m\e[36m \e[30m${PWD}\e[42m\e[33m\e[30m$(__git_ps1 " (%s)")\e[0m\n\$ '
# It displays like '(base) 0 2021-02-19_20-50-49 /mnt/d/Work/LinuxMiniPrograms  (BSD)' in a Git repository.
#                      |   |          |                     |                     |_ The Git branch you're on.
#                      |   |          |                     |_______________________ Your working directory.
#                      |   |          |_____________________________________________ Date & Time when the previous command finishes.
#                      |   |________________________________________________________ Exit status of the previous command.
#                      |____________________________________________________________ Conda environment you're on.

# Conda and LinuxBrew setup scripts omitted.
# Useful paths if you install software with configure option --prefix="${HOME}/usr/local".
