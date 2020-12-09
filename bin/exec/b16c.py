#!/usr/bin/env python
# B16C.py V2P1

from LMP_Pylib.libisopt import *
from LMP_Pylib.libylfile import *

decode = False
for sysarg in sys.argv[1:]:
	if isopt(sysarg):
		if sysarg == '-h' or sysarg == '--help':
			os.system('yldoc b16c')
			exit(0)
		elif sysarg == '-v' or sysarg == '--version':
			print('Version 1 in Python')
			exit(0)
		elif sysarg == '-d':
			decode = True
if decode:
	f = open(sys.stdin.fileno(), mode='r')
	o = open(sys.stdout.fileno(), mode='wb')
	otmp = []
	while True:
		inp = f.read(2)
		if len(inp) < 2: break
		otmp.append((ord(inp[0]) - 65) * 16 + ord(inp[1]) - 65)
		o.write(bytes(otmp))
		otmp.pop()
	o.close()
else:
	f = open(sys.stdin.fileno(), mode='rb')
	while True:
		inp = f.read(1)
		if not inp: break
		inp = ord(inp)
		b1 = inp // 16
		b2 = inp % 16
		sys.stdout.write(chr(b1 + 65) + chr(b2 + 65))
f.close()
