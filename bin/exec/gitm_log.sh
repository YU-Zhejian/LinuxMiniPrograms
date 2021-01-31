#GITM_LOG.sh v1
if cat act.log; then
	infoh "Repository readlog success"
	echo -e "$(timestamp)\tLOG\tSUCCESS" >> act.log
else
	echo -e "$(timestamp)\tLOG\tFAILED" >> act.log
fi
