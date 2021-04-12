#!/usr/bin/env python
'''
pathls in Python, should be same as in shell
'''
import os
import re
import sys

from LMP_Pylib.libisopt import isopt
from LMP_Pylib.libpath import LibPath
from LMP_Pylib.libstr import warnh

VERSION = 1.9


def mygrep(mylist: list, regxp: str) -> list:
    for idx in range(len(mylist) - 1, -1, -1):
        if re.search(regxp, mylist[idx]):
            mylist.pop(idx)
    return mylist


def do_search(P: str) -> list:
    if not os.path.isdir(P):
        return []
    ls_ret = os.popen('ls -1 -F ' + ''' + P + ''', 'r')
    ls_all = ls_ret.readlines()
    ls_ret.close()
    for n in range(len(ls_all)):
        ls_all[n] = P + '/' + ls_all[n].strip()
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
        if sysarg in ('-h', '--help'):
            os.system('yldoc pathls')
            sys.exit(0)
        elif sysarg in ('-v', '--version'):
            print(str(VERSION) + ' in Python')
            sys.exit(0)
        elif sysarg == '--no-x':
            allow_x = False
        elif sysarg == '--allow-d':
            allow_d = True
        elif sysarg == '--no-o':
            allow_o = False
        elif sysarg in ('-l', '--list'):
            mylibpath = LibPath('PATH')
            for mypath in mylibpath.valid_path:
                print(mypath)
            sys.exit(0)
        elif sysarg in ('-i', '--invalid'):
            mylibpath = LibPath('PATH')
            for mypath in mylibpath.invalid_path:
                print(mypath)
            sys.exit(0)
        else:
            warnh('Option ' + sysarg + ' invalid')
            sys.exit(1)
    else:
        sstr.append(sysarg)
mylibpath = LibPath('PATH')
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
