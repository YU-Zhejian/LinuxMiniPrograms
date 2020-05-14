#!/usr/bin/env python
#PLS.py V1P2
from LMP_Pylib.libisopt import isopt
import sys,os,re
def mygrep(mylist:list,regxp:str)->list:
    for idx in range(len(mylist)-1,-1,-1):
        if re.search(regxp,mylist[idx]):
            mylist.pop(idx)
    return mylist

def do_search(P:str)->list:
    if not os.path.isdir(P):
        return []
    ls_ret=os.popen('ls -1 -F '+"'"+P+"'",'r')
    ls_all=ls_ret.readlines()
    ls_ret.close()
    for n in range(len(ls_all)):
        ls_all[n]=P+ls_all[n].strip()
    if not allow_d:
        ls_all=mygrep(ls_all,r'/$')
    if not allow_o:
        ls_all=mygrep(ls_all,r'[^\*/]$')
    if not allow_x:
        ls_all=mygrep(ls_all,r'\*$')
    return ls_all

mypaths=os.environ['PATH'].split(':')+[os.getcwd()]
for i in range(len(mypaths)):
    if not mypaths[i].endswith('/'):
        mypaths[i]+='/'
mypaths=list(set(mypaths))
allow_x=True
allow_d=False
allow_o=True
sys.argv.pop(0)
sstr=[]
for sysarg in sys.argv:
    if isopt(sysarg):
        if re.match(r'-h|--help',sysarg):
            os.system('yldoc pls')
            exit(0)
        elif re.match(r'-v|--version',sysarg):
            print('Version 1 Patch 2 in Python')
            exit(0)
        elif re.match(r'--no-x',sysarg):
            allow_x=False
        elif re.match(r'--allow-d',sysarg):
            allow_d=True
        elif re.match(r'--no-o',sysarg):
            allow_o=False
        elif re.match(r'-l|--list',sysarg):
            for mypath in mypaths:
                if os.path.isdir(mypath):
                    print(mypath+'/')
        elif re.match(r'-i|--invalid',sysarg):
            for mypath in mypaths:
                if not os.path.isdir(mypath):
                    print(mypath+'/')
        else:
            print("\033[31mERROR: Option "+sysarg+" invalid.\033[0m")
            exit(1)
    else:
        sstr.append(sysarg)

if sstr==[]:
    for mypath in mypaths:
        ret_l=do_search(mypath)
        for item in ret_l:
            print(item)
else:
    ret_l=[]
    out_l=[]
    for mypath in mypaths:
        ret_l+=do_search(mypath)
    for item in ret_l:
        for jtem in sstr:
            if jtem in item:
                out_l.append(item)
    for item in out_l:
        print(item)
