#!/usr/bin/env python
#AD2U.py V1P8
import sys
import re
fix_tgt=90
def fix_tail():
    tmp_line = fdoc_out_lines.pop()
    if len(tmp_line)<=fix_tgt:
        fdoc_out_lines.append(tmp_line)
    else:
        tmp_blank_len=len(tmp_line) - len(tmp_line.lstrip())
        blank_pos=tmp_line[fix_tgt:0:-1].find(' ')
        line1=tmp_line[0:fix_tgt-blank_pos]
        line2=' '*tmp_blank_len+tmp_line[fix_tgt+1-blank_pos:]
        fdoc_out_lines.append(line1)
        fdoc_out_lines.append(line2)
        fix_tail()
fadoc_file_str = sys.argv[1]
fadoc_hand=open(fadoc_file_str,"r")
fdoc_lines=fadoc_hand.readlines()
fadoc_hand.close()
fdoc_out_lines=[]
Currindent=''
for line in fdoc_lines:
    if line.startswith(r"```") and Currindent.__contains__(r'| '):
        Currindent=Currindent[0:-2]
        fdoc_out_lines.append('')
        continue
    elif Currindent.__contains__(r'| '):
        fdoc_out_lines.append(Currindent + line)
        continue
    elif line.startswith(r"```"):
        Currindent = Currindent+r'| '
        fdoc_out_lines.append('')
    elif line.startswith(r'='):
        reeq=re.match(r'=*=',line).span()
        lneq=reeq[1]-reeq[0]-1
        Currindent='    '*lneq
        fdoc_out_lines.append('    '*(lneq-1)+line.replace('=','').strip())
        fdoc_out_lines.append('')
    elif line.startswith(r'*'):
        reeq = re.match(r'\**\*', line).span()
        lneq = reeq[1] - reeq[0]
        fdoc_out_lines.append(Currindent+'    ' * lneq + r'* ' + line.replace('*', '').strip())
        fix_tail()
        fdoc_out_lines.append('')
    elif line.startswith(r'.'):
        reeq = re.match(r'\.*\.', line).span()
        lneq = reeq[1] - reeq[0]
        fdoc_out_lines.append(Currindent+'    ' * lneq + r'- ' + line.replace('.', '').strip())
        fix_tail()
        fdoc_out_lines.append('')
    elif line.strip()=='':
        continue
    else:
        fdoc_out_lines.append(Currindent+line)
        fix_tail()
        fdoc_out_lines.append('')
dochead=fadoc_file_str[:-3:]
blank_len=(fix_tgt-13-len(dochead)) //2
fdoc_out_lines.insert(0,'')
fdoc_out_lines.insert(0,'YuZJLab'+' '*blank_len+dochead+' '*blank_len+'MANUAL')
fdoc_out_lines.append('YuZJLab'+' '*34+'2019-2020'+' '*34+'MANUAL')
fdoc_out_handle=open(dochead+'.usage','w')
for line in fdoc_out_lines:
    fdoc_out_handle.write(line.rstrip()+'\n')
fdoc_out_handle.close()
