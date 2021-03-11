#!/usr/bin/env python
# B16C.py V2P2
import struct

from LMP_Pylib.libisopt import *
from LMP_Pylib.libylfile import *
from LMP_Pylib.libstr import *

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
	f = open(sys.stdin.fileno(), mode='rb')
	o = open(sys.stdout.fileno(), mode='wb')
	while True:
		inp1 = f.read(1)
		inp2 = f.read(1)
		if not inp1 or not inp2: break
		#infoh(",".join([str(inp1),str(inp2),chr((ord(inp1) - 65) * 16 + ord(inp2) - 65)]))
		o.write(struct.pack('b',(ord(inp1) - 65) * 16 + ord(inp2) - 65 - 128))
else:
	f = open(sys.stdin.fileno(), mode='rb')
	o = open(sys.stdout.fileno(), mode='w')
	while True:
		inp = f.read(1)
		if not inp: break
		inp = ord(inp)
		o.write(chr(inp // 16 + 65) + chr(inp % 16 + 65))
o.close()
f.close()
