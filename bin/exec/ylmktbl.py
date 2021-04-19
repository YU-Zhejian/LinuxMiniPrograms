#!/usr/bin/env python
'''
A wrapper for libylmktbl.
'''

import os
import sys

from linuxminipy.libisopt import isopt
from linuxminipy.libmktbl import mktbl
from linuxminipy.libstr import warnh

VERSION = 3.1

def main():
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

if __name__ == '__main__':
    main()
