#GITM_LS.sh v1
"${mycat}" uuidtable.d/*
echo -e "$(timestamp)\tLS\tSUCCESS" >> act.log
infoh "Repository ls success."
