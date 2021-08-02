#!/usr/env/bin python3
# -*- coding: utf-8 -*-
"""
Report generator -- Generate Asciidoc report from csv-like source
"""

import sys
import time

import pandas

all_csv = pandas.read_csv(sys.argv[1], sep=';',header=None)

print("""= Test Report at `%s`""" % sys.argv[1], end='\n\n')

allnct = 0
allect = 0

for prog in set(all_csv.iloc[:, 0]):
    all_rec = all_csv.loc[all_csv.iloc[:, 0] == prog, :].iloc[:, 1:]
    print("""== `%s`""" % prog, end='\n\n')
    nct = 0
    ect = 0
    for i in range(len(all_rec)):
        if all_rec.iloc[i, 0] == 0:
            nct += 1
        else:
            ect += 1
        print("""* %d\t `%s`""" % (int(all_rec.iloc[i, 0]), all_rec.iloc[i, 1]), end='\n')
    print("""\nIMPORTANT: Overall passing rate: %d/%d=%d%%""" % (nct, (nct + ect), nct / (nct + ect) * 100), end='\n\n')
    allnct += nct
    allect += ect
print("""== `%s`""" % "SUMMARY", end='\n\n')

print("""\nIMPORTANT: Overall passing rate: %d/%d=%d%%""" % (allnct, (allnct + allect), allnct / (allnct + allect) * 100), end='\n\n')

print("""Report generated at %s""" % time.asctime(time.localtime()), end='\n')
