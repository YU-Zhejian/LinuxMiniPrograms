#!/usr/bin/env python
'''
b16c in Python. Should get same output as in C.
'''

import os
import struct
import sys

from linuxminipy.libisopt import isopt

VERSION = 2.3


# T#O#D#O: Still bugs in MSYS2

def main():
    decode = False
    for sysarg in sys.argv[1:]:
        if isopt(sysarg):
            if sysarg in ('-h', '--help'):
                os.system('yldoc b16c')
                sys.exit(0)
            elif sysarg in ('-v', '--version'):
                print(str(VERSION) + ' in Python')
                sys.exit(0)
            elif sysarg in ('-d', '--decode'):
                decode = True
    if decode:
        f = open(sys.stdin.fileno(), mode='rb')
        o = open(sys.stdout.fileno(), mode='wb')
        while True:
            inp1 = f.read(1)
            inp2 = f.read(1)
            if not inp1 or not inp2: break
            o.write(struct.pack('b', (ord(inp1) - 65) * 16 + ord(inp2) - 65 - 128))
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


if __name__ == '__main__':
    main()
