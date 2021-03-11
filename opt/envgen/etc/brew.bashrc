function initbrew (){
	# Until LinuxBrew is fixed, the following is required.
	# See: https://github.com/Homebrew/linuxbrew/issues/47
	export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig:/usr/lib64/pkgconfig:/usr/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig:$PKG_CONFIG_PATH
	## Setup linux brew
	export LINUXBREWHOME="${HOME}/linuxbrew"
	export PATH="${LINUXBREWHOME}/bin:${LINUXBREWHOME}/sbin:${LINUXBREWHOME}/opt/coreutils/libexec/gnubin:${PATH}"
	export MANPATH="${LINUXBREWHOME}/share/man:${MANPATH}"
	export PKG_CONFIG_PATH="${LINUXBREWHOME}/lib64/pkgconfig:${LINUXBREWHOME}/lib/pkgconfig:${PKG_CONFIG_PATH}"
	export CPLUS_INCLUDE_PATH="${LINUXBREWHOME}/include:${CPLUS_INCLUDE_PATH:-}"
	export C_INCLUDE_PATH="${LINUXBREWHOME}/include:${C_INCLUDE_PATH:-}"
	export LD_LIBRARY_PATH="${LINUXBREWHOME}/lib64:${LINUXBREWHOME}/lib:${LD_LIBRARY_PATH}"
	export LIBRARY_PATH="${LINUXBREWHOME}/lib64:${LINUXBREWHOME}/lib:${LD_LIBRARY_PATH}"
	export LD_RUN_PATH="${LINUXBREWHOME}/lib64:${LINUXBREWHOME}/lib:${LD_LIBRARY_PATH}"
	export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/linuxbrew-bottles/
}
