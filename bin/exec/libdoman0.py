#!/usr/bin/env python
# LIBDOMAN0.py V1
import os
import sys

for fn in sys.argv[2:]:
    fn=sys.argv[1].strip()+'/'+fn.strip()
    if not os.path.isfile(fn):
        print("\033[31mERROR: Filename ", fn, "invalid. Use libdoman -h for help.\033[0m")
        exit(1)
    print("\033[33mLoading", fn, "...0 item proceeded.\033[0m")
    Proj = -1
    ffn = open(fn)
    all_lns = ffn.readlines()
    ffn.close()
    grep_lns = []
    for line in all_lns:
        if line.startswith('LIBDO'):
            grep_lns.append(line.strip())
    del all_lns
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
                time_calc = os.popen(os.path.dirname('bash '+sys.argv[0])+'/datediff.sh ' + ' "' + Proj_time_s[Proj] + '" "' + Proj_time_e[Proj] + '"')
                Proj_time.append(time_calc.read().strip())
                time_calc.close()
            elif line.startswith('LIBDO IS GOING TO EXECUTE'):
                Proj_time_e.append('0')
                Proj_exit.append('-1')
                Proj_time.append('ERR')
                continue
            if line.startswith('LIBDO EXITED SUCCESSFULLY.'):
                i += 1
                Proj_exit.append('0')
            elif line.startswith('LIBDO FAILED, GOT'):
                Proj_exit.append(line.replace('.', '')[21:])
    print("\033[33mFile", fn, "loaded. Making table...\033[0m")
    mktmp_hand = os.popen('mktemp -t libdo_man.XXXXXX')
    tmpf = mktmp_hand.read().strip()
    mktmp_hand.close()
    tmpf_hand = open(tmpf, 'w')
    tmpf_hand.write('#1\n#S90\n#1\n#1\nNO.;COMMAND;EXIT;TIME\n')
    for i in range(Proj+1):
        tmpf_hand.write(str(i) + ';' + Proj_cmd[i] + ';' + Proj_exit[i] + ';' + Proj_time[i]+'\n')
    tmpf_hand.close()
    os.system('ylmktbl ' + tmpf)
    os.system('rm ' + tmpf)
