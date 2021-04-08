VERSION=1.0
if cat uuidtable.d/*; then
	infoh "Repository ls success"
	echo -e "$(timestamp)\tLS\tSUCCESS" >> act.log
else
	echo -e "$(timestamp)\tLS\tFAILED" >> act.log
fi
