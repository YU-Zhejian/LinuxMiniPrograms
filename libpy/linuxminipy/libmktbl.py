#!/usr/bin/env python
# -*- coding: utf-8 -*-
__LIBMKTBL_VERSION=1.2
'''
Print table.
'''
from linuxminipy.libylfile import ylreadline
from linuxminipy.libstr import ANSI_CRAYON, ANSI_CLEAR


def mktbl(fn: str, split: str = ';', commentstr: str = '#'):
    '''
    Print table.
    :param fn: The source file of the table.
    :param split: The character needed to split the fields.
    :param commentstr: How comments start.
    '''
    configline = []
    normalline = []
    for line in ylreadline(fn):
        line = line.strip()
        if line.startswith(commentstr):
            configline.append(line[1:])
        else:
            myapp = line.split(split)
            normalline.append(myapp)
    if len(normalline[0]) != len(configline):
        raise ValueError('Configline number disagree with normal colum number')
    for n in range(len(normalline[0])):
        mlen = 0
        for m in range(len(normalline)):
            ltj = len(normalline[m][n])
            if ltj > mlen:
                mlen = ltj
        if configline[n].startswith('S'):
            mylen = int(configline[n][1:])
            for i in range(len(normalline)):
                if len(normalline[i][n]) < mylen:
                    normalline[i][n] = normalline[i][n].ljust(mylen, ' ')
                else:
                    normalline[i][n] = normalline[i][n][0:mylen - 3] + '...'
        else:
            for i in range(len(normalline)):
                normalline[i][n] = normalline[i][n].ljust(mlen, ' ')
    alllen = 0
    for item in normalline[0]:
        alllen = alllen + len(item) + 1
    spb = ANSI_CRAYON +'|'+'=' * (alllen - 1) + '|'+ANSI_CLEAR
    for item in normalline:
        print(spb)
        pl = ANSI_CRAYON+'|'+ANSI_CLEAR
        for jtem in item:
            pl = pl + jtem + ANSI_CRAYON+'|'+ANSI_CLEAR
        print(pl)
    print(spb)
