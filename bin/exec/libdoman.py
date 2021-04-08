#!/usr/bin/env python
VERSION=3.1
from datetime import datetime

from LMP_Pylib.libisopt import *
from LMP_Pylib.libmktbl import *
from LMP_Pylib.libstr import *

sstr = []
cmd = 0
ISMACHINE = False
# Parse arguments
path = os.path.abspath(os.path.dirname(sys.argv[0]) + "/../") + '/'
for sysarg in sys.argv[1:]:
	if isopt(sysarg):
		if sysarg == '-h' or sysarg == '--help':
			os.system('yldoc libdoman')
			exit(0)
		elif sysarg == '-v' or sysarg == '--version':
			print('Version ' + str(VERSION) + ' in Python, compatiable with libdo Version 2 & 3')
			exit(0)
		elif sysarg == '-m' or sysarg == '--machine':
			cmd = 0
			ISMACHINE = True
		elif sysarg.startswith('-o:'):
			cmd = int(sysarg[3:])
		elif sysarg.startswith('--output:'):
			cmd = int(sysarg[9:])
		else:
			warnh("Option " + sysarg + " invalid")
	else:
		sstr.append(sysarg)


def timediff(diff_s: int) -> str:
	hour = "0"
	min = "0"
	sec = str(diff_s)
	if diff_s / 60 > 0:
		min = str(diff_s // 60)
		sec = str(diff_s % 60)
	if int(min) / 60 > 0:
		hour = str(int(min) // 60)
		min = str(int(min) % 60)
	return ':'.join([hour, min, sec])


class record:
	"""
	LibDO Record formatter
	"""

	def __init__(self, cmd: str):
		"""
		Start a new LibDO Record
		Exit: Exit status
		Time: Time used to finish this step.
		Time_s: Time started
		Time_e: Time ended
		:param cmd: Commandline, mandatory field
		"""
		self.cmd = cmd
		self.Exit = "-1"
		self.Time = "ERR"
		self.Time_s = "0"
		self.Time_e = "0"

	def pp(self):
		"""
		To generate Time. Note the difference in machines and humans.
		:return: Nothing
		"""
		if self.Time == "ERR":
			if self.Time_e != "0" and self.Time_s != "0":
				time_calc = (datetime.strptime(self.Time_e, '%Y-%m-%d %H:%M:%S') - datetime.strptime(self.Time_s,
																									 '%Y-%m-%d %H:%M:%S')).seconds
				if ISMACHINE:
					self.Time = str(time_calc)
				else:
					self.Time = timediff(time_calc)


# List all processes
if cmd == 0:
	# Fix relative path
	for fn in sstr:
		fn_ = path + fn
		if not os.path.isfile(fn_):
			if os.path.isfile(fn):
				fn_ = fn
			else:
				errh("Filename " + fn_ + " invalid. Use libdoman -h for help")
		fn = fn_
		i = 0
		grep_lns = open(fn, "r")
		Proj = []
		# Read file
		while True:
			line = grep_lns.readline()
			if line == '':
				break
			line = line.strip()
			if line.startswith('LIBDO IS GOING TO EXECUTE'):
				i += 1
				infoh("Loading " + fn + "..." + str(i) + " item proceeded")
				Proj.append(record(line[26:]))
				# Similar structure to accelerate.
				# It is clear that there will not be two 'LIBDO STARTED AT' in one record
				while True:
					last_pos = grep_lns.tell()
					line = grep_lns.readline()
					if line == '':
						break
					line = line.strip()
					if line.startswith('LIBDO IS GOING TO EXECUTE'):
						grep_lns.seek(last_pos)
						break
					elif line.startswith('LIBDO STARTED AT'):
						Proj[-1].Time_s = line.replace('.', '')[17:]
						while True:
							last_pos = grep_lns.tell()
							line = grep_lns.readline()
							if line == '':
								break
							line = line.strip()
							if line.startswith('LIBDO IS GOING TO EXECUTE'):
								grep_lns.seek(last_pos)
								break
							elif line.startswith('LIBDO STOPPED AT'):
								Proj[-1].Time_e = line.replace('.', '')[17:]
								while True:
									last_pos = grep_lns.tell()
									line = grep_lns.readline()
									if line == '':
										break
									line = line.strip()
									if line.startswith('LIBDO IS GOING TO EXECUTE'):
										grep_lns.seek(last_pos)
										break
									elif line == 'LIBDO EXITED SUCCESSFULLY':
										Proj[-1].Exit = "0"
									elif line.startswith('LIBDO FAILED, GOT'):
										Proj[-1].Exit = line.replace('.', '')[21:]

		infoh("File " + fn + " loaded. Making table...")
		if ISMACHINE:
			for rec in Proj:
				rec.pp()
				print('\t'.join([rec.cmd, rec.Exit, rec.Time]))
		else:
			tmpf = mktemp("libdo_man.XXXXXX")
			tmpf_hand = open(tmpf, 'w')
			tmpf_hand.write('#1\n#S90\n#1\n#1\nNO.;COMMAND;EXIT;TIME\n')
			i = 0
			for rec in Proj:
				i += 1
				rec.pp()
				tmpf_hand.write(';'.join([str(i), rec.cmd, rec.Exit, rec.Time]) + '\n')
			tmpf_hand.close()
			mktbl(tmpf)
			os.remove(tmpf)
else:
	fn = path + sstr[0]
	if not os.path.isfile(fn):
		if os.path.isfile(sstr[0]):
			fn = sstr[0]
		else:
			errh("Filename " + fn + " invalid. Use libdoman -h for help")
	ln_s = 0
	ln_e = 0
	tmpf = mktemp("libdo_man.XXXXXX")
	os.system('cat -n "' + fn + '" | grep "LIBDO IS GOING TO EXECUTE" >"' + tmpf + '"')
	grep_lns = ylreadline(tmpf)
	os.remove(tmpf)
	ln = 0
	for line in grep_lns:
		ln = ln + 1
		if ln == cmd:
			ln_s = int(line.strip().split("\t")[0])
		elif ln > cmd:
			ln_e = int(line.strip().split("\t")[0]) - 1
			break
	if ln_s == 0:
		errh(str(cmd) + " invalid")
	if ln_e == 0:
		ln_e = pywcl(fn)
	tmpf = mktemp("libdo_man.XXXXXX")
	os.system("head -n " + str(ln_s + 1) + ' "' + fn + '" | tail -n 2 > "' + tmpf + '"')
	os.system("head -n " + str(ln_e) + ' "' + fn + '" | tail -n 2 >> "' + tmpf + '"')
	grep_lns = ylreadline(tmpf)
	CMD = grep_lns[0][26:]
	Time_s = grep_lns[1][17:]
	if len(grep_lns) < 4:
		Time_e = 0
		Exit = "-1"
		Time = "ERR"
	else:
		i = 2
		line = grep_lns[i]
		if line.startswith('LIBDO STOPPED AT'):
			Time_e = line[17:]
			line = grep_lns[i]
			Time = timediff((datetime.strptime(Time_s, '%Y-%m-%d %H:%M:%S') - datetime.strptime(Time_e,
																								'%Y-%m-%d %H:%M:%S')).seconds)
			i += 1
			line = grep_lns[i]
		else:
			Time_e = 0
			Exit = "-1"
			Time = "ERR"
		if line.startswith('LIBDO EXITED SUCCESSFULLY'):
			Exit = "0"
		elif line.startswith('LIBDO FAILED, GOT'):
			Exit = line[21:]
		else:
			Exit = "-1"
	print("\033[33mJOB_CMD	  \033[36m:", CMD, "\033[0m")
	print("\033[33mELAPSED_TIME \033[36m:", Time_s, "TO", Time_e, ", Total", Time, "\033[0m")
	print("\033[33mEXIT_STATUS  \033[36m:", Exit, "\033[0m")
	print("\033[33m________________JOB_________OUTPUT________________\033[0m")
	tls = ln_s + 2
	els = ln_e - 2
	if ln_e <= tls:
		print("\033[33mNO OUTPUT\033[0m")
	elif Exit == "-1":
		os.system('head -n ' + str(ln_e) + ' "' + fn + '" | tail -n ' + str(tls - ln_e))
	else:
		os.system('head -n ' + str(els) + ' "' + fn + '" | tail -n ' + str(tls - els + 1))
	print("\033[33m_______________OUTPUT____FINISHED________________\033[0m")
infoh("Finished")
