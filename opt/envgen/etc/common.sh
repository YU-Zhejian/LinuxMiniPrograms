# Export basic PATH variables.
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:${PATH:-}"

# Git helper, can be found at the source code of Git.
__git_ps1() { true; } # The default ${PS1}
[ -f "${HOME}"/.git-prompt.sh ] && . "${HOME}"/.git-prompt.sh
export GIT_PS1_SHOWUPSTREAM="verbose"

# Fantastic ${PS1} with additional linebreak.
__prevp() {
    local r=${?}
    [ ${r} -eq 0 ] && builtin echo -e "\e[42m\e[30m${r}\e[32m\e[46m \e[0m" || builtin echo -e "\e[41m\e[30m${r}\e[31m\e[46m \e[0m"
}

# Useful paths if you install software with configure option --prefix="${HOME}/usr/local".
export PATH="${HOME}/.local/bin:${HOME}/bin:${HOME}/usr/bin:${HOME}/usr/local/bin:${PATH}"
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

# Perl system settings, commented for causing problems
# export PERL5LIB="/etc/perl:/usr/local/lib/x86_64-linux-gnu/perl/5*:/usr/local/share/perl/5*:/usr/lib/x86_64-linux-gnu/perl5/5*:/usr/share/perl5:/usr/lib/x86_64-linux-gnu/perl/5*:/usr/share/perl/5*:/usr/local/lib/site_perl:/usr/lib/x86_64-linux-gnu/perl-base:${PERL5LIB:-}"

# Useful aliases. Will only work in commandline but not scripts.
alias du="du -h"                # More readable du.
alias df="df -h"                # More readable df.
# alias df="duf --all" # duf to replace df
alias diff="diff -u"            # Make the output of $(diff) similar to git diff.
alias ls="ls -lhF --color=auto" # More readable ls.
# Common ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
# alias ls="exa -lhF --color=auto" # Use exa to replace ls.
alias grep="grep --color=auto"   # More readable grep.
alias fgrep='fgrep --color=auto' # More readable grep.
alias egrep='egrep --color=auto' # More readable egrep.
alias diff='diff --color=auto'   # More readable diff.
alias ip='ip --color=auto'       # More readable ip.
# alias grep="ack" # ack to replace grep.
# Shutdown, reboot and sudo is banned. For those who need to those commands, please comment the following three lines.
alias shutdown="builtin echo What the hell you\'re thinking?\!"
alias reboot="builtin echo What the hell you\'re thinking?\!"
alias sudo="builtin echo What the hell you\'re thinking?\!"
alias rm="rm -i"                                                            # Safer $(rm).
alias git-log="git log --pretty=oneline --abbrev-commit --graph --branches" # More readable git log.
alias git-gc="git gc --aggressive --prune=now"                              # Clean git up
alias top="htop"                                                            # htop is a task manager better than top.
alias emacs="emacs -nw"
alias DO=eval    # LibDO simulator
alias __DO =eval # LibDO simulator

# Initializing thefuck.
# eval "$(thefuck -a)"
