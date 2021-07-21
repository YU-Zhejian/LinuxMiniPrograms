#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
LibDO Manager in Python.
'''
import os
import sys
from datetime import datetime

from linuxminipy.libisopt import isopt
from linuxminipy.libmktbl import mktbl
from linuxminipy.libstr import infoh, errh, warnh
from linuxminipy.libylfile import mktemp

VERSION = 3.2
sstr = []
ISMACHINE = False
FMTSTR = '%Y-%m-%d %H:%M:%S'
fn = ''
path = os.path.abspath(os.path.dirname(sys.argv[0]) + "/../") + '/'


def main():
    cmd = 0
    global sstr
    global ISMACHINE

    for sysarg in sys.argv[1:]:
        if isopt(sysarg):
            if sysarg in ('-h', '--help'):
                os.system('yldoc libdoman')
                sys.exit(0)
            elif sysarg in ('-v', '--version'):
                print(str(VERSION) + ' in Python, compatible with libdo 2 & 3')
                sys.exit(0)
            elif sysarg in ('-m', '--machine'):
                cmd = 0
                ISMACHINE = True
            elif sysarg.startswith('-o:'):
                cmd = int(sysarg[3:])
            elif sysarg.startswith('--output:'):
                cmd = int(sysarg[9:])
            else:
                warnh("Option " + sysarg + " invalid")
        else:
            sstr.append(sysarg)
    if cmd == 0:
        cmd0()
    else:
        cmd1(cmd)
    infoh("Finished")


def timediff(diff_s: int) -> str:
    hour = "0"
    minute = "0"
    sec = str(diff_s)
    if diff_s / 60 > 0:
        minute = str(diff_s // 60)
        sec = str(diff_s % 60)
    if int(minute) / 60 > 0:
        hour = str(int(minute) // 60)
        minute = str(int(minute) % 60)
    return ':'.join([hour, minute, sec])


class LibdoRecord:
    """
    LibDO Record formatter
    """

    def __init__(self, cmd_exec: str, pos_s: int = 0):
        """
        Start a new LibDO Record
        exit_stat: exit_stat status
        time: time used to finish this step.
        time_s: time started
        time_e: time ended
        :param cmd_exec: Commandline, mandatory field
        """
        self.cmd_exec = cmd_exec
        self.exit_stat = "-1"
        self.time = "ERR"
        self.time_s = "0"
        self.time_e = "0"
        self.pos_s = pos_s
        self.pos_e = 0

    def pp(self):
        """
        To generate time. Note the difference in machines and humans.
        :return: Nothing
        """
        if self.time == "ERR" and self.time_e != "0" and self.time_s != "0":
            time_calc = (datetime.strptime(self.time_e, FMTSTR) -
                          datetime.strptime(self.time_s, FMTSTR)).seconds
            if ISMACHINE:
                self.time = str(time_calc)
            else:
                self.time = timediff(time_calc)

    def pppos(self):
        '''
        Porcess position
        :return: Nothing
        '''
        fh = open(fn, 'r')
        fh.seek(self.pos_s)
        while True:
            last_pos = fh.tell()
            line = fh.readline()
            if line == '':
                self.pos_e = last_pos
                return
            line = line.strip()
            if line.startswith('LIBDO PID'):
                self.pos_s = fh.tell()
                while True:
                    last_pos = fh.tell()
                    line = fh.readline()
                    if line == '' or line.startswith('LIBDO STOPPED AT'):
                        self.pos_e = last_pos
                        return


def extract_record(segment: [], pos_s: int) -> LibdoRecord:
    '''
    To extract libDO record from a list of strings
    :param segment: A list of strings
    :param pos_s: Start position in the file
    :return: LibdoRecord extracted
    '''
    returnv = None
    n_line = 0
    while n_line < len(segment) - 1:
        line = segment[n_line]
        if line.startswith('LIBDO IS GOING TO EXECUTE'):
            returnv = LibdoRecord(line[26:], pos_s)
            # Similar structure to accelerate.
            while n_line < len(segment) - 1:
                line = segment[n_line]
                n_line += 1
                if line.startswith('LIBDO STARTED AT'):
                    returnv.time_s = line.replace('.', '')[17:]
                    while n_line < len(segment) - 1:
                        line = segment[n_line]
                        n_line += 1
                        if line.startswith('LIBDO STOPPED AT'):
                            returnv.time_e = line.replace('.', '')[17:]
                            while n_line < len(segment) - 1:
                                line = segment[n_line]
                                n_line += 1
                                if line == 'LIBDO EXITED SUCCESSFULLY':
                                    returnv.exit_stat = "0"
                                elif line.startswith('LIBDO FAILED, GOT'):
                                    returnv.exit_stat = line.replace('.', '')[21:]
                                break
    return returnv


def extract_segment(n: int = -1) -> []:
    '''
    Read the file and extract segments, then throw it to extract_record
    :param: int: Which segment to extract. -1 for all.
    :return: A list of libdo records
    '''
    global fn
    grep_lns = open(fn, "r")
    Proj = []
    n_record = 0
    pos_s = 0
    while True:
        line = grep_lns.readline()
        segment = []
        if line == '':
            break
        line = line.strip()
        if line.startswith('LIBDO IS GOING TO EXECUTE'):
            pos_s = grep_lns.tell()
            n_record += 1
            segment.append(line)
            infoh("Loading " + fn + "..." + str(n_record) + " item proceeded")
            while True:
                last_pos = grep_lns.tell()
                line = grep_lns.readline()
                if line == '':
                    break
                elif line.startswith('LIBDO IS GOING TO EXECUTE'):
                    segment.append(line)  # To avoid the left of the last line.
                    grep_lns.seek(last_pos)
                    break
                elif line.startswith('LIBDO'):
                    segment.append(line.strip('\n'))
            segment.append(line)
        if n == -1 or n == n_record:
            Proj.append(extract_record(segment, pos_s))
    grep_lns.close()
    return Proj


def extract_procedure(start_pos: int, end_pos: int):
    '''
    Extract specific lines and put it to stdout
    :param fn: Filename
    :param start_pos: Start line number
    :param end_pos: End line number
    :return: Nothing
    '''
    global fn
    fh = open(fn, 'r')
    fh.seek(start_pos)
    i = start_pos
    while i < end_pos:
        print(fh.read(1), end='')
        i = fh.tell()


# List all processes
def cmd0():
    global fn
    global sstr
    # Fix relative path
    for fn in sstr:
        fn_ = path + fn
        if not os.path.isfile(fn_):
            if os.path.isfile(fn):
                fn_ = fn
            else:
                errh("Filename " + fn_ + " invalid. Use libdoman -h for help")
        fn = fn_
        records = extract_segment()

        infoh("File " + fn + " loaded. Making table...")
        if ISMACHINE:
            for rec in records:
                rec.pp()
                print('\t'.join([rec.cmd_exec, rec.exit_stat, rec.time]))
        else:
            tmpf = mktemp("libdo_man.XXXXXX")
            tmpf_hand = open(tmpf, 'w')
            tmpf_hand.write('#1\n#S90\n#1\n#1\n#1\n#1\nNO.;COMMAND;EXIT;START;END;TIME\n')
            i = 0
            for rec in records:
                i += 1
                rec.pp()
                tmpf_hand.write(';'.join([str(i),
                                          rec.cmd_exec,
                                          rec.exit_stat,
                                          rec.time_s,
                                          rec.time_e,
                                          rec.time]) + '\n')
            tmpf_hand.close()
            mktbl(tmpf)
            os.remove(tmpf)


def cmd1(cmd: int):
    '''
    Extrac a specific record
    :param cmd: which record to be extracted
    :return: Nothing, Will be printed
    '''
    global fn
    global sstr
    fn = sstr[0]
    fn_ = path + fn
    if not os.path.isfile(fn_):
        if os.path.isfile(fn):
            fn_ = fn
        else:
            errh("Filename " + fn_ + " invalid. Use libdoman -h for help")
        fn = fn_
    record = extract_segment(cmd)[0]
    record.pp()
    record.pppos()
    print("\033[33mJOB_CMD      \033[36m:", record.cmd_exec, "\033[0m")
    print("\033[33mELAPSED_TIME \033[36m:", record.time_s, "TO", record.time_e, ", Total", record.time, "\033[0m")
    print("\033[33mEXIT_STATUS  \033[36m:", record.exit_stat, "\033[0m")
    print("\033[33m________________JOB_________OUTPUT________________\033[0m")
    extract_procedure(record.pos_s, record.pos_e)
    print("\033[33m_______________OUTPUT____FINISHED________________\033[0m")


if __name__ == '__main__':
    main()
