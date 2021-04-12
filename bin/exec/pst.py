#!/usr/bin/env python
'''
pst in Python
'''

import os
import sys
import threading
import time

from linuxminipy.libisopt import isopt
from linuxminipy.libstr import warnh

VERSION = 1.1

ISMACHINE = False
for sysarg in sys.argv[1:]:
    if isopt(sysarg):
        if sysarg in ('-h', '--help'):
            os.system('yldoc pst')
            sys.exit(0)
        elif sysarg in ('-v', '--version'):
            print(str(VERSION) + ' in Python')
            sys.exit(0)
        elif sysarg in ('-m', '--machine'):
            ISMACHINE = True
        else:
            warnh('Option ' + sysarg + ' invalid')


class ReadThread(threading.Thread):
    '''
    Thread for reading
    '''

    def __init__(self):
        super().__init__()
        self.i = 0

    def run(self):
        si = open(sys.stdin.fileno(), mode='rb', buffering=0)
        so = open(sys.stdout.fileno(), mode='wb', buffering=0)
        while True:
            inp = si.read(1)
            if not inp: break
            self.i += 1
            so.write(inp)
        si.close()
        so.close()


class WriteThread(threading.Thread):
    '''
    Thread for writing
    '''

    def __init__(self, readthread: ReadThread):
        super().__init__()
        self.readthread = readthread

    def tohuman(self, diff: int) -> str:
        dc = 'b'
        if diff > 1024:
            diff /= 1024
            dc = 'kb'
        if diff > 1024:
            diff /= 1024
            dc = 'mb'
        if diff > 1024:
            diff /= 1024
            dc = 'gb'
        return str(diff) + dc

    def run(self):
        global ISMACHINE
        se = open(sys.stderr.fileno(), mode='wt')
        iold = self.readthread.i
        t = 0
        if ISMACHINE:
            while self.readthread.is_alive():
                t = t + 1
                time.sleep(1)
                i = self.readthread.i
                se.write(str(i) + '\t' + str(t) + '\t' + str(i - iold) + '\n')
                iold = i
        else:
            while self.readthread.is_alive():
                t = t + 1
                time.sleep(1)
                i = self.readthread.i
                se.write('\n\033[1A')
                diff = i - iold
                se.write('CC=' + self.tohuman(i) + ', TE=' + str(t) +
                         ', SPEED=' + self.tohuman(diff) + '/s')
                iold = i
        se.close()

def main():
    rt = ReadThread()
    rt.start()
    wt = WriteThread(rt)
    wt.start()

if __name__ == '__main__':
    main()
