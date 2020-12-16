#!/usr/bin/env bash
#BUILD_DOC V1
if ! [ "${myasciidoctor}" != "ylukh" ]; then
	VAR_install_man=false
	if ! [ "${myasciidoc}" != "ylukh" ]; then
		VAR_install_html=false
	fi
fi
[ "${myasciidoctor_pdf}" != "ylukh" ] || VAR_install_pdf=false
if ${VAR_install_pdf}; then
	"${myrm}" -rf ../../pdf
	"${mymkdir}" -p ../../pdf
	for fn in *.adoc; do
		"${myasciidoctor_pdf}" -a allow-uri-read ${fn}
		[ ${?} -eq 0 ] && infoh "Compiling ${fn} in pdf...\033[32mPASSED" || infoh "Compiling ${fn} in pdf...\033[31mFAILED"
	done
	"${mymv}" *.pdf ../../pdf
fi
if ${VAR_install_html}; then
	"${mymkdir}" -p ../../html
	if ! [ "${myasciidoctor}" != "ylukh" ]; then
		for fn in *.adoc; do
			"${myasciidoctor}" -a allow-uri-read ${fn} -b html5
			[ ${?} -eq 0 ] && infoh "Compiling ${fn} in html5...\033[32mPASSED" || infoh "Compiling ${fn} in html5...\033[31mFAILED"
		done
	else
		for fn in *.adoc; do
			"${myasciidoc}" ${fn}
			[ ${?} -eq 0 ] && infoh "Compiling ${fn} in html5...\033[32mPASSED" || infoh "Compiling ${fn} in html5...\033[31mFAILED"
		done
	fi

	"${mymv}" *.html ../../html
fi
if ${VAR_install_man}; then
	"${myrm}" -rf ../../man
	"${mymkdir}" -p ../../man ../../man1
	for fn in *.adoc; do
		"${myasciidoctor}" -a allow-uri-read ${fn} -b manpage
		[ ${?} -eq 0 ] && infoh "Compiling ${fn} in Groff man...\033[32mPASSED" || infoh "Compiling ${fn} in Groff man...\033[31mFAILED"
	done
	"${mymv}" *.1 ../../man/man1
fi
if ${VAR_install_usage}; then
	"${myrm}" -rf ../../doc/
	"${mymkdir}" -p ../../doc
	for fn in *.adoc; do
		"${mypython}" ../exec/adoc2usage.py "${fn}"
		[ ${?} -eq 0 ] && infoh "Compiling ${fn} in YuZJLab Usage...\033[32mPASSED" || infoh "Compiling ${fn} in YuZJLab Usage...\033[31mFAILED"
	done
	"${mymv}" *.usage ../../doc/
fi
