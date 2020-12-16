#!/usr/bin/env python
# B16C.py V2P2

from LMP_Pylib.libisopt import *
from LMP_Pylib.libylfile import *

decode = False
for sysarg in sys.argv[1:]:
	if isopt(sysarg):
		if sysarg == '-h' or sysarg == '--help':
			os.system('yldoc b16c')
			exit(0)
		elif sysarg == '-v' or sysarg == '--version':
			print('Version 12 Patch 2 in Python')
			exit(0)
		elif sysarg == '-d' or sysarg == '--decode':
			decode = True
if decode:
	f = open(sys.stdin.fileno(), mode='r')
	o = open(sys.stdout.fileno(), mode='wb')
	while True:
		inp = f.read(2)
		if len(inp) < 2: break
		o.write(bytes((ord(inp[0]) - 65) * 16 + ord(inp[1]) - 65))
	o.close()
else:
	f = open(sys.stdin.fileno(), mode='rb')
	while True:
		inp = f.read(1)
		if not inp: break
		inp = ord(inp)
		sys.stdout.write(chr(inp // 16 + 65) + chr(inp % 16 + 65))
f.close()
