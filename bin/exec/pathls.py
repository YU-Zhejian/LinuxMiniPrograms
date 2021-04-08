#!/usr/bin/env python
VERSION=1.8
from LMP_Pylib.libisopt import *
from LMP_Pylib.libpath import *
from LMP_Pylib.libstr import *


import sys, os, re


def mygrep(mylist: list, regxp: str) -> list:
	for idx in range(len(mylist) - 1, -1, -1):
		if re.search(regxp, mylist[idx]):
			mylist.pop(idx)
	return mylist


def do_search(P: str) -> list:
	if not os.path.isdir(P):
		return []
	ls_ret = os.popen('ls -1 -F ' + "'" + P + "'", 'r')
	ls_all = ls_ret.readlines()
	ls_ret.close()
	for n in range(len(ls_all)):
		ls_all[n] = P + "/" + ls_all[n].strip()
	if not allow_d:
		ls_all = mygrep(ls_all, r'/$')
	if not allow_o:
		ls_all = mygrep(ls_all, r'[^\*/]$')
	if not allow_x:
		ls_all = mygrep(ls_all, r'\*$')
	return ls_all


allow_x = True
allow_d = False
allow_o = True
sstr = []
for sysarg in sys.argv[1:]:
	if isopt(sysarg):
		if sysarg == '-h' or sysarg == '--help':
			os.system('yldoc pathls')
			exit(0)
		elif sysarg == '-v' or sysarg == '--version':
			print(str(VERSION) + ' in Python')
			exit(0)
		elif sysarg == '--no-x':
			allow_x = False
		elif sysarg == '--allow-d':
			allow_d = True
		elif sysarg == '--no-o':
			allow_o = False
		elif sysarg == '-l' or sysarg == '--list':
			mylibpath = libpath("PATH")
			for mypath in mylibpath.valid_path:
				print(mypath)
			exit(0)
		elif sysarg == '-i' or sysarg == '--invalid':
			mylibpath = libpath("PATH")
			for mypath in mylibpath.invalid_path:
				print(mypath)
			exit(0)
		else:
			warnh("Option " + sysarg + " invalid")
			exit(1)
	else:
		sstr.append(sysarg)
mylibpath = libpath("PATH")
if sstr == []:
	for mypath in mylibpath.valid_path:
		ret_l = do_search(mypath)
		for item in ret_l:
			print(item)
else:
	ret_l = []
	out_l = []
	for mypath in mylibpath.valid_path:
		ret_l += do_search(mypath)
	for item in ret_l:
		for jtem in sstr:
			if jtem in item:
				out_l.append(item)
	for item in out_l:
		print(item)
