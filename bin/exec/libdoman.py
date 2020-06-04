#!/usr/bin/env python
# LIBDOMAN.py V2
from LMP_Pylib.libisopt import *
from LMP_Pylib.libmktemp import *
import sys,os
sstr=[]
cmd=0
for sysarg in sys.argv[2:]:
    if isopt(sysarg):
        if sysarg=='-h' or sysarg=='--help':
            os.system('yldoc libdoman')
            exit(0)
        elif sysarg=='-v' or sysarg=='--version':
            print('Version 2, compatiable with libdo Version 2.')
            exit(0)
        elif sysarg.startswith('-o:'):
            cmd=int(sysarg[3:])
        elif sysarg.startswith('--output:'):
            cmd=int(sysarg[9:])
        else:
            print("\033[31mERROR: Option "+sysarg+" invalid.\033[0m")
            exit(1)
    else:
        sstr.append(sysarg)

if cmd==0:
    for fn in sstr:
        fn=sys.argv[1].strip()+'/'+fn.strip()
        if not os.path.isfile(fn):
            print("\033[31mERROR: Filename ", fn, "invalid. Use libdoman -h for help.\033[0m")
            exit(1)
        print("\033[33mLoading", fn, "...0 item proceeded.\033[0m")
        Proj = -1
        tmpf=mktemp("libdo_man.XXXXXX")
        os.system('cat "'+fn+'" | grep LIBDO >'+tmpf)
        ffn = open(tmpf)
        grep_lns = ffn.readlines()
        for i in range(len(grep_lns)):
            grep_lns[i]=grep_lns[i].strip()
        ffn.close()
        os.system('rm "'+tmpf+'"')
        i = 0
        ln = len(grep_lns)
        Proj_cmd = []
        Proj_time_s = []
        Proj_time_e = []
        Proj_time = []
        Proj_exit = []
        while ln > i:
            line = grep_lns[i]
            i += 1
            if line.startswith('LIBDO IS GOING TO EXECUTE'):
                Proj += 1
                print("\033[33mLoading", fn, "..." + str(Proj+1) + " item proceeded.\033[0m")
                Proj_cmd.append(line[26:])
                line = grep_lns[i]
                if line.startswith('LIBDO STARTED AT'):
                    Proj_time_s.append(line.replace('.', '')[17:])
                    i += 2
                    line = grep_lns[i]
                if ln == i:
                    Proj_time_e.append('0')
                    Proj_exit.append('-1')
                    Proj_time.append('ERR')
                    continue
                if line.startswith('LIBDO STOPPED AT'):
                    Proj_time_e.append(line.replace('.', '')[17:])
                    i += 1
                    line = grep_lns[i]
                    time_calc = os.popen(os.path.dirname('bash "'+sys.argv[0])+'"/datediff.sh ' + ' "' + Proj_time_s[Proj] + '" "' + Proj_time_e[Proj] + '"')
                    Proj_time.append(time_calc.read().strip())
                    time_calc.close()
                elif line.startswith('LIBDO IS GOING TO EXECUTE'):
                    Proj_time_e.append('0')
                    Proj_exit.append('-1')
                    Proj_time.append('ERR')
                    continue
                if line=='LIBDO EXITED SUCCESSFULLY':
                    i += 1
                    Proj_exit.append('0')
                elif line.startswith('LIBDO FAILED, GOT'):
                    Proj_exit.append(line.replace('.', '')[21:])
        print("\033[33mFile", fn, "loaded. Making table...\033[0m")
        tmpf=mktemp("libdo_man.XXXXXX")
        tmpf_hand = open(tmpf, 'w')
        tmpf_hand.write('#1\n#S90\n#1\n#1\nNO.;COMMAND;EXIT;TIME\n')
        for i in range(Proj+1):
            tmpf_hand.write(str(i) + ';' + Proj_cmd[i] + ';' + Proj_exit[i] + ';' + Proj_time[i]+'\n')
        tmpf_hand.close()
        os.system('ylmktbl "' + tmpf+'"')
        os.system('rm "' + tmpf+'"')
else:
    cmd=cmd-1
    fn = sys.argv[1].strip() + '/' + sstr[0]
    if not os.path.isfile(fn):
        print("\033[31mERROR: Filename ", fn, "invalid. Use libdoman -h for help.\033[0m")
        exit(1)
    ln_s=0
    ln_e=0
    tmpf=mktemp("libdo_man.XXXXXX")
    os.system('cat -n "' + fn + '" | grep "LIBDO IS GOING TO EXECUTE" >' + tmpf)
    ffn = open(tmpf)
    grep_lns = ffn.readlines()
    ffn.close()
    os.system("rm " + tmpf)
    if len(grep_lns)<cmd or cmd<0:
        print("\033[31mERROR: "+str(cmd)+" invalid.\033[0m")
    ln_e_hand = os.popen('wc -l "' + fn+'"')
    total = int(ln_e_hand.read().strip().split(" ")[0])
    ln_e_hand.close()
    ln_s = int(grep_lns[cmd].strip().split("\t")[0])
    if len(grep_lns)==cmd:
        ln_e=total-1
    else:
        ln_e = int(grep_lns[cmd+1].strip().split("\t")[0])
    ffn=open(fn)
    tmpf = mktemp("libdo_man.XXXXXX")
    os.system("head -n "+str(ln_s+1)+' "'+fn+ '" | tail -n 2 > "' + tmpf+'"')
    os.system("head -n " + str(ln_e-1) +' "'+fn+ '" | tail -n 2 >> "' + tmpf+'"')
    tmpf_hand=open(tmpf)
    grep_lns=tmpf_hand.readlines()
    for i in range(len(grep_lns)):
        grep_lns[i]=grep_lns[i].strip()
    CMD=grep_lns[0][26:]
    Time_s=grep_lns[1][17:]
    if len(grep_lns)<4:
        Time_e=0
        Exit="-1"
        Time="ERR"
    else:
        i=2
        line=grep_lns[i]
        
        if line.startswith('LIBDO STOPPED AT'):
            
            Time_e=line[17:]
            line = grep_lns[i]
            time_calc = os.popen(os.path.dirname('bash "' + sys.argv[0]) + '"/datediff.sh ' + ' "' + Time_s + '" "' + Time_e + '"')
            Time=time_calc.read().strip()
            time_calc.close()
            i += 1
            line = grep_lns[i]
        if line.startswith('LIBDO EXITED SUCCESSFULLY.'):
            Exit="0"
        elif line.startswith('LIBDO FAILED, GOT'):
            Exit=line[21:]
    print("\033[33mJOB_CMD      \033[36m:",CMD,"\033[0m")
    print("\033[33mELAPSED_TIME \033[36m:", Time_s,"TO",Time_e,", Total",Time,"\033[0m")
    print("\033[33mEXIT_STATUS  \033[36m:", Exit,"\033[0m")
    print("\033[33m________________JOB_________OUTPUT________________\033[0m")
    tls=ln_s+2
    els=ln_e-2
    if ln_e<=tls:
        print("\033[33mNO OUTPUT\033[0m")
    elif Exit=="-1":
        os.system('head -n '+str(ln_e) + ' "' +fn +'" | tail -n '+str(tls-ln_e))
    else:
        os.system('head -n ' + str(els) + ' "' +fn +'" | tail -n ' + str(tls - els+1))
    print("\033[33m_______________OUTPUT____FINISHED________________\033[0m")
print("\033[33mFinished.\033[0m")
