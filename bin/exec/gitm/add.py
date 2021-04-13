#!/usr/env/bin python
'''
gitm_add in Python
'''
import os
import sys
from linuxminipy.libisopt import isopt

VERSION=1.0

def main():
    os.chdir(os.environ('GITM_HOME'))
    print(os.curdir)


if __name__ == '__main__':
    main()
