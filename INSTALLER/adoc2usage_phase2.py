#!/usr/bin/env python
#AD2U.py V1P1
import sys
import re
def fix_tail():
    tmp_line = fdoc_out_lines.pop()
    if len(tmp_line)>64:
        tmp_blank_len=len(tmp_line) - len(tmp_line.lstrip())
        blank_pos=tmp_line[64:0:-1].find(' ')
        line1=tmp_line[0:64-blank_pos]
        line2=' '*tmp_blank_len+tmp_line[65-blank_pos:]
        fdoc_out_lines.append(line1)
        fdoc_out_lines.append(line2)
        fix_tail()
    else:
        fdoc_out_lines.append(tmp_line)
fadoc_file_str = sys.argv[1]
fadoc_hand=open(fadoc_file_str,"r")
fdoc_lines=fadoc_hand.readlines()
fadoc_hand.close()
fdoc_out_lines=[]
Currindent=False
for line in fdoc_lines:
    if line.startswith(r'#'):
        fdoc_out_lines.append('\n'+line[2::])
        Currindent=True
    elif line.startswith(r'`'):
        soc=re.search(r'^`(.*)` (.*)',line)
        fdoc_out_lines.append("    "+soc.group(1))
        fdoc_out_lines.append("        "+soc.group(2))
    else:
        fdoc_out_lines.append("    "+line)
    fix_tail()
dochead=fadoc_file_str[:-3:]
blank_len=(51-len(dochead)) //2
fdoc_out_lines.insert(0,'YuZJLab'+' '*blank_len+dochead+' '*blank_len+'MANUAL')
fdoc_out_lines.append("\nYuZJLab                     2019-2020                     MANUAL")
fdoc_out_handle=open(dochead+'.usage','w')
for line in fdoc_out_lines:
    fdoc_out_handle.write(line.rstrip()+'\n')
fdoc_out_handle.close()
