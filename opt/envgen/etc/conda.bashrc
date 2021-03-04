__conda_setup="$("${HOME}/conda/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
if [ ${?} -eq 0 ]; then
	eval "${__conda_setup}"
else
	if [ -f "${HOME}/conda/etc/profile.d/conda.sh" ]; then
		. "${HOME}/conda/etc/profile.d/conda.sh"
	else
		export PATH="${HOME}/conda/bin:${PATH}"
	fi
fi
/public/workspace/3190110679bit/
export PATH="${HOME}/.local/bin:${PATH}"
