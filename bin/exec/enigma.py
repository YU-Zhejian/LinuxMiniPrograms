#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Special-purpose enigma, will be replaced
'''
import os
import random
import sys

from linuxminipy.libisopt import isopt
from linuxminipy.libylfile import ylread, ylwrite

VERSION = 2.1


class Enigma():
    """
    Special-purpose Enigma machine
    """

    def encode(self, instr: str):
        for i in range(0, len(self.all_gear)):
            # print(instr+'->',end='')
            instr = self.all_gear[i][(ord(instr) - 65 +
                                      self.all_gear_s[i]) % 16]
        # print(instr)
        self._inc_gear()
        return instr

    def _inc_gear(self):
        # print(self.all_gear_s)
        self.all_gear_s[0] = self.all_gear_s[0] + 1
        for i in range(0, len(self.all_gear) - 1):
            cs = self.all_gear_s[i]
            if cs >= 16:
                self.all_gear_s[i] = cs % 16
                self.all_gear_s[i + 1] = self.all_gear_s[i + 1] + 1
        self.all_gear_s[len(self.all_gear) - 1] = \
            self.all_gear_s[len(self.all_gear) - 1] % 16

    def decode(self, instr: str):
        for i in range(len(self.all_gear) - 1, -1, -1):
            # print(instr+'->',end='')
            instr = chr((self.all_gear[i].index(instr) -
                         self.all_gear_s[i] + 16) % 16 + 65)
        # print(instr)
        self._inc_gear()
        return ord(instr) - 65

    def __init__(self, ss: str, gear: list):
        self.all_gear = []
        self.all_gear_s = []
        for i in range(0, len(gear)):
            self.all_gear.append(ylread(str(gear[i])))
            self.all_gear_s.append(self.all_gear[-1].index(ss[i]))

    @staticmethod
    def gengear():
        alh = []
        for fn in os.listdir('.'):
            alh.append(ylread(fn))
        while True:
            rgear = ''.join([chr(x + 65) for x in random.sample(range(16), 16)])
            if rgear not in alh:
                break
        ylwrite(str(len(alh) + 1), rgear)
        print(str(len(alh) + 1), rgear)


def main():
    enigmagear = []
    startingstring = ''
    os.chdir(os.path.abspath(os.path.dirname(sys.argv[0]) + '/../../var/enigma.d/'))
    decode = False
    for sysarg in sys.argv[1:]:
        if isopt(sysarg):
            if sysarg in ('-h', '--help'):
                os.system('yldoc b16c')
                sys.exit(0)
            elif sysarg in ('-v', '--version'):
                print(str(VERSION) + ' in Python')
                sys.exit(0)
            elif sysarg in ('-g', '--gengear'):
                Enigma.gengear()
                sys.exit(0)
            elif sysarg in ('-d', '--decode'):
                decode = True
            elif sysarg.startswith('-c:'):
                enigmagear.append(int(sysarg[3:]))
            elif sysarg.startswith('-s:'):
                startingstring = sysarg[3:]

    if decode:
        f = open(sys.stdin.fileno(), mode='r')
        o = open(sys.stdout.fileno(), mode='wb')
        otmp = []
        if len(startingstring) != len(enigmagear) or len(enigmagear) == 0:
            while True:
                inp = f.read(2)
                if len(inp) < 2: break
                otmp.append((ord(inp[0]) - 65) * 16 + ord(inp[1]) - 65)
                o.write(bytes(otmp))
                otmp.pop()
        else:
            myenigma = Enigma(startingstring, enigmagear)
            while True:
                inp = f.read(2)
                if len(inp) < 2: break
                otmp.append(myenigma.decode(inp[0]) * 16 + myenigma.decode(inp[1]))
                o.write(bytes(otmp))
                otmp.pop()
        o.close()
    else:
        f = open(sys.stdin.fileno(), mode='rb')
        if len(startingstring) != len(enigmagear) or len(enigmagear) == 0:
            while True:
                inp = f.read(1)
                if not inp: break
                inp = ord(inp)
                b1 = inp // 16
                b2 = inp % 16
                # print(inp)
                sys.stdout.write(chr(b1 + 65) + chr(b2 + 65))

        else:
            myenigma = Enigma(startingstring, enigmagear)
            while True:
                inp = f.read(1)
                if not inp: break
                inp = ord(inp)
                b1 = inp // 16
                b2 = inp % 16
                sys.stdout.write(myenigma.encode(chr(b1 + 65)) +
                                 myenigma.encode(chr(b2 + 65)))

    f.close()


if __name__ == '__main__':
    main()
