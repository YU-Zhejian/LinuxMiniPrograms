#!/usr/bin/env python
VERSION=1
import os
import threading
import time

from LMP_Pylib.libisopt import *
from LMP_Pylib.libstr import *

ISMACHINE = False
for sysarg in sys.argv[1:]:
	if isopt(sysarg):
		if sysarg == '-h' or sysarg == '--help':
			os.system('yldoc pst')
			exit(0)
		elif sysarg == '-v' or sysarg == '--version':
			print(str(VERSION) + ' in Python')
			exit(0)
		elif sysarg == '-m' or sysarg == '--machine':
			ISMACHINE = True
		else:
			warnh("Option " + sysarg + " invalid")


class readThread(threading.Thread):
	def __init__(self):
		super().__init__()
		self.i = 0

	def run(self):
		si = open(sys.stdin.fileno(), mode='rb', buffering=0)
		so = open(sys.stdout.fileno(), mode='wb', buffering=0)
		while True:
			inp = si.read(1)
			if not inp: break
			self.i += 1
			so.write(inp)
		si.close()
		so.close()


class writeThread(threading.Thread):
	def __init__(self, RT: readThread):
		super().__init__()
		self.RT = RT

	def tohuman(self, diff: int) -> str:
		dc = "b"
		if diff > 1024:
			diff /= 1024
			dc = "kb"
		if diff > 1024:
			diff /= 1024
			dc = "mb"
		if diff > 1024:
			diff /= 1024
			dc = "gb"
		return str(diff) + dc

	def run(self):
		global ISMACHINE
		se = open(sys.stderr.fileno(), mode='wt')
		iold = self.RT.i
		t = 0
		if ISMACHINE:
			while self.RT.is_alive():
				t = t + 1
				time.sleep(1)
				i = self.RT.i
				se.write(str(i) + "\t" + str(t) + "\t" + str(i - iold) + "\n")
				iold = i
		else:
			while self.RT.is_alive():
				t = t + 1
				time.sleep(1)
				i = self.RT.i
				se.write("\n\033[1A")
				diff = i - iold
				se.write("CC=" + self.tohuman(i) + ", TE=" + str(t) + ", SPEED=" + self.tohuman(diff) + "/s")
				iold = i
		se.close()


RT = readThread()
RT.start()
WT = writeThread(RT)
WT.start()
