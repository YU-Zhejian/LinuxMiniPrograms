#!/usr/bin/env python
# LIBDOMAN.py V2P2
from LMP_Pylib.libisopt import *
from LMP_Pylib.libmktbl import *
from LMP_Pylib.libstr import *
import sys,os
sstr=[]
cmd=0
ISMACHINE=False
for sysarg in sys.argv[2:]:
	if isopt(sysarg):
		if sysarg=='-h' or sysarg=='--help':
			os.system('yldoc libdoman')
			exit(0)
		elif sysarg=='-v' or sysarg=='--version':
			print('Version 2 patch 2 in Python, compatiable with libdo Version 2 & 3')
			exit(0)
		elif sysarg == '-m' or sysarg == '--machine':
			cmd=0
			ISMACHINE=True
		elif sysarg.startswith('-o:'):
			cmd=int(sysarg[3:])
		elif sysarg.startswith('--output:'):
			cmd=int(sysarg[9:])
		else:
			errh("Option "+sysarg+" invalid")
	else:
		sstr.append(sysarg)

if cmd==0:
	for fn in sstr:
		fn=sys.argv[1].strip()+'/'+fn.strip()
		if not os.path.isfile(fn):
			errh("Filename "+ fn+ " invalid. Use libdoman -h for help")
		if not ISMACHINE:
			infoh("Loading"+ fn+ "...0 item proceeded")
		Proj = -1
		tmpf=mktemp("libdo_man.XXXXXX")
		os.system('cat "'+fn+'" | grep LIBDO >'+tmpf)
		grep_lns = ylreadline(tmpf)
		os.remove(tmpf)
		i = 0
		ln = len(grep_lns)
		Proj_cmd = []
		Proj_time_s = []
		Proj_time_e = []
		Proj_time = []
		Proj_exit = []
		while ln > i:
			line = grep_lns[i]
			i += 1
			if line.startswith('LIBDO IS GOING TO EXECUTE'):
				Proj += 1
				infoh("Loading"+ fn+ "..." + str(Proj+1) + " item proceeded")
				Proj_cmd.append(line[26:])
				line = grep_lns[i]
				if line.startswith('LIBDO STARTED AT'):
					Proj_time_s.append(line.replace('.', '')[17:])
					i += 2
					line = grep_lns[i]
				if ln == i:
					Proj_time_e.append('0')
					Proj_exit.append('-1')
					Proj_time.append('ERR')
					continue
				if line.startswith('LIBDO STOPPED AT'):
					Proj_time_e.append(line.replace('.', '')[17:])
					i += 1
					line = grep_lns[i]
					if ISMACHINE:
						time_calc = yldo('bash "' + os.path.dirname(sys.argv[0]) + '"/datediff.sh ' + ' "' + Proj_time_s[Proj] + '" "' + Proj_time_e[Proj] + '" machine')
					else:
						time_calc = yldo('bash "'+os.path.dirname(sys.argv[0])+'"/datediff.sh ' + ' "' + Proj_time_s[Proj] + '" "' + Proj_time_e[Proj] + '"')
					Proj_time.append(time_calc)
				elif line.startswith('LIBDO IS GOING TO EXECUTE'):
					Proj_time_e.append('0')
					Proj_exit.append('-1')
					Proj_time.append('ERR')
					continue
				if line=='LIBDO EXITED SUCCESSFULLY':
					i += 1
					Proj_exit.append('0')
				elif line.startswith('LIBDO FAILED, GOT'):
					Proj_exit.append(line.replace('.', '')[21:])
		infoh("File"+ fn+ "loaded. Making table...")
		if ISMACHINE:
			for i in range(Proj + 1):
				print(Proj_cmd[i] + '\t' + Proj_exit[i] + '\t' + Proj_time[i])
		else:
			tmpf=mktemp("libdo_man.XXXXXX")
			tmpf_hand = open(tmpf, 'w')
			tmpf_hand.write('#1\n#S90\n#1\n#1\nNO.;COMMAND;EXIT;TIME\n')
			for i in range(Proj+1):
				tmpf_hand.write(str(i+1) + ';' + Proj_cmd[i] + ';' + Proj_exit[i] + ';' + Proj_time[i]+'\n')
			tmpf_hand.close()
			mktbl(tmpf)
			os.remove(tmpf)
else:
	fn = sys.argv[1].strip() + '/' + sstr[0]
	if not os.path.isfile(fn):
		errh("Filename "+ fn+ " invalid. Use libdoman -h for help")
	ln_s=0
	ln_e=0
	tmpf=mktemp("libdo_man.XXXXXX")
	os.system('cat -n "' + fn + '" | grep "LIBDO IS GOING TO EXECUTE" >"' + tmpf + '"')
	grep_lns = ylreadline(tmpf)
	os.remove(tmpf)
	ln=0
	for line in grep_lns:
		ln=ln+1
		if ln==cmd:
			ln_s = int(line.strip().split("\t")[0])
		elif ln>cmd:
			ln_e = int(line.strip().split("\t")[0])-1
			break
	if ln_s==0:
		errh(str(cmd)+" invalid")
	if ln_e==0:
		ln_e = pywcl(fn)
	tmpf = mktemp("libdo_man.XXXXXX")
	os.system("head -n "+str(ln_s+1)+' "'+fn+ '" | tail -n 2 > "' + tmpf+'"')
	os.system("head -n " + str(ln_e) +' "'+fn+ '" | tail -n 2 >> "' + tmpf+'"')
	grep_lns = ylreadline(tmpf)
	CMD=grep_lns[0][26:]
	Time_s=grep_lns[1][17:]
	if len(grep_lns)<4:
		Time_e=0
		Exit="-1"
		Time="ERR"
	else:
		i=2
		line=grep_lns[i]
		if line.startswith('LIBDO STOPPED AT'):
			Time_e=line[17:]
			line = grep_lns[i]
			Time = yldo('bash "' + os.path.dirname(sys.argv[0]) + '"/datediff.sh ' + ' "' + Time_s + '" "' + Time_e + '"')
			i += 1
			line = grep_lns[i]
		if line.startswith('LIBDO EXITED SUCCESSFULLY'):
			Exit="0"
		elif line.startswith('LIBDO FAILED, GOT'):
			Exit=line[21:]
	print("\033[33mJOB_CMD	  \033[36m:",CMD,"\033[0m")
	print("\033[33mELAPSED_TIME \033[36m:", Time_s,"TO",Time_e,", Total",Time,"\033[0m")
	print("\033[33mEXIT_STATUS  \033[36m:", Exit,"\033[0m")
	print("\033[33m________________JOB_________OUTPUT________________\033[0m")
	tls=ln_s+2
	els=ln_e-2
	if ln_e<=tls:
		print("\033[33mNO OUTPUT\033[0m")
	elif Exit=="-1":
		os.system('head -n '+str(ln_e) + ' "' +fn +'" | tail -n '+str(tls-ln_e))
	else:
		os.system('head -n ' + str(els) + ' "' +fn +'" | tail -n ' + str(tls - els+1))
	print("\033[33m_______________OUTPUT____FINISHED________________\033[0m")
infoh("Finished")
