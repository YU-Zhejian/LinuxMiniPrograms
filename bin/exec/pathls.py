#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
pathls in Python, should be same as in shell
'''
import os
import re
import sys
import threading

from linuxminipy.libisopt import isopt
from linuxminipy.libpath import LibPath
from linuxminipy.libstr import warnh, infoh

VERSION = 1.10
allow_x = True
allow_d = False
allow_o = True
PARALLEL = False

def mygrep(mylist: list, regxp: str) -> list:
    for idx in range(len(mylist) - 1, -1, -1):
        if re.search(regxp, mylist[idx]):
            mylist.pop(idx)
    return mylist


def do_search(inpath: str) -> list:
    if not os.path.isdir(inpath):
        return []
    ls_ret = os.popen('ls -1 -F ' + '\'' + inpath + '\'', 'r')
    ls_all = ls_ret.readlines()
    ls_ret.close()
    for n in range(len(ls_all)):
        ls_all[n] = inpath + '/' + ls_all[n].strip()
    if not allow_d:
        ls_all = mygrep(ls_all, r'/$')
    if not allow_o:
        ls_all = mygrep(ls_all, r'[^\*/]$')
    if not allow_x:
        ls_all = mygrep(ls_all, r'\*$')
    return ls_all


def do_search_py(inpath: str) -> list:
    '''
    Deprecated due to slow speed
    :param inpath: path
    :return: Items under that path
    '''
    if not os.path.isdir(inpath):
        return []
    ls_ret = os.listdir(inpath)
    for n in range(len(ls_ret)):
        ls_ret[n] = os.path.abspath(inpath + '/' + ls_ret[n])
        if not allow_d and os.path.isdir(ls_ret[n]):
            ls_ret[n] = ''
        if not allow_o and not os.access(ls_ret[n], os.X_OK):
            ls_ret[n] = ''
        if not allow_x and os.access(ls_ret[n], os.X_OK):
            ls_ret[n] = ''
    return list(filter(None, ls_ret))


class ParallelDoSearch(threading.Thread):
    '''
    Multi-threading support
    '''

    def __init__(self, inpath: str):
        super().__init__()
        self.P = inpath
        self.outlist = []

    def run(self) -> None:
        self.outlist = do_search(self.P)

    def result(self) -> list:
        return self.outlist


def parallel_do_search(inpath_list: list) -> list:
    search_threads = []
    i = 0
    for P in inpath_list:
        search_threads.append(ParallelDoSearch(P))
        search_threads[i].start()
        i += 1
    outlist = []
    for n in range(i):
        infoh("Waiting " + inpath_list[n])
        search_threads[n].join()
        outlist.extend(search_threads[n].result())
    return outlist


def non_parallel_do_search(inpath_list: list) -> list:
    outlist = []
    for P in inpath_list:
        infoh("Searching " + P)
        outlist.extend(do_search(P))
    return outlist


def main():
    global allow_o, PARALLEL
    global allow_d
    global allow_x
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
            elif sysarg in ('-p', '--parallel'):
                PARALLEL = True
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
    if PARALLEL:
        ret_l = parallel_do_search(mylibpath.valid_path)
    else:
        ret_l = non_parallel_do_search(mylibpath.valid_path)
    if sstr == []:
        for item in ret_l:
            print(item)
    else:
        out_l = []
        for item in ret_l:
            for jtem in sstr:
                if jtem in item:
                    out_l.append(item)
        for item in out_l:
            print(item)


if __name__ == '__main__':
    main()
