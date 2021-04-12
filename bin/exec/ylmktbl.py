#!/usr/bin/env python
'''
A wrapper for libylmktbl.
'''

from LMP_Pylib.libisopt import isopt
from LMP_Pylib.libmktbl import mktbl
from LMP_Pylib.libstr import warnh
import sys
import os

VERSION=3.1

sstr = []
for sysarg in sys.argv[1:]:
    if isopt(sysarg):
        if sysarg in ('-h', '--help'):
            os.system('yldoc ylmktbl')
            sys.exit(0)
        elif sysarg in ('-v', '--version'):
            print(str(VERSION) + ' in Python')
            sys.exit(0)
        else:
            warnh('Option ' + sysarg + ' invalid')
            sys.exit(1)
    else:
        sstr.append(sysarg)
mktbl(sstr[0])
